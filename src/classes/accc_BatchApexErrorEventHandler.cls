/**
 * Copyright (c) 2016-2019, Bill Anderson.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *
 *   * Neither the name of Bill Anderson nor the names of its
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * @author Bill Anderson
 * @date 01/04/2019
 *
 * @description Handles BatchApexError. This simple mechanism just logs the data. It needs refactoring!
 *
 * Note, A. Fawcett ( see reference below) implemented a retry on the Batch
 *
 * @group Platform Events Handling
 */
public virtual class accc_BatchApexErrorEventHandler extends accc_EventBase {

	static final String DEBUG_LEVEL = 'Debug';
	static final String ERROR_LEVEL = 'Error';
	static final String INTEGRATION_PAYLOAD = 'Batch';
	
	@TestVisible
	static Boolean causeExceptionForTesting = false;
	
	/**
	 * @description Platform events only supports after insert
	 *
	 * @param List<SObject> list of new sobjects
	 */
	public virtual override void onAfterInsertChild(List<SObject> newItems) {
		this.records(newItems);
		// Query associated AsyncApexJobs (borrow portions from A. Fawcett [see below])
		// TODO: Use force-di to inject a test JobInfoResolver
		Map<Id, JobInfo> jobs = this.getJobInformationFromJobIds();
		try {

			// if testing are we throwing an exception
			if  (accc_ApexConstants.UnitTestsRunning) {
				if ( accc_BatchApexErrorEventHandler.causeExceptionForTesting ) {
					throw new accc_ApexApplicationException(DEBUG_LEVEL);
				}
			}
			List<AcccApplicationLog__c> entries = new List<AcccApplicationLog__c>();

			for ( BatchApexErrorEvent event : (List<BatchApexErrorEvent>)this.records()) {
				JobInfo asyncApexJob = jobs.get(event.AsyncApexJobId);
				// job present
				if (asyncApexJob != null) {

					entries.add(new AcccApplicationLog__c(
					                DebugLevel__c = ERROR_LEVEL,
					                Username__c = UserInfo.getUserName(),
					                Exception__c = event.ExceptionType,
					                ReferenceId__c = event.RequestId,
					                IntegrationPayload__c = INTEGRATION_PAYLOAD,
					                Source__c = asyncApexJob.ApexClassName,
					                ReferenceInfo__c = event.JobScope,
					                Message__c =   event.Message,
					                StackTrace__c = event.StackTrace,
					                InvocationType__c = asyncApexJob.toString()
					            ));
				}
			}// end for

			// anything to log
			if ( entries.size() > 0 ) {
				accc_ApplicationLog applLog = new accc_ApplicationLog();
				applLog.log(entries);
			}

		} catch (Exception excp) {
			// process exception, handle w/ care
			accc_ApexEnvironment.getRuntimeEnvironment().exceptionHandler().process(excp, true);
		}

	} // end of afterInsert

	/**
	 * @description get job information from the incoming event data
	 *
	 * @return Map of Job Info by job id
	 */
	private Map<Id, JobInfo> getJobInformationFromJobIds() {
		// Query associated AsyncApexJobs
		Set<Id> asyncApexJobIds = new Set<Id>();
		for (BatchApexErrorEvent evt :  (List<BatchApexErrorEvent>)this.records() ) {
			asyncApexJobIds.add(evt.AsyncApexJobId);
		}
		// TODO: Use force-di to inject a test JobInfoResolver
		return new RuntimeJobInfoResolver().resolveById(asyncApexJobIds);

	} // end of getJobInformationFromJobIds

	//====================================================================================
	//
	// The code below was borrowed from Andy's Github ...
	// Borrowed from https://raw.githubusercontent.com/afawcett/force-brf/master/force-brf/main/classes/brf_BatchApexErrorEvents.cls
	//
	//====================================================================================


	// Abstract queries made against AsyncApexJob to aid testability
	public abstract class JobInfoResolver {
		/**
		* @description Borrowed from https://raw.githubusercontent.com/afawcett/force-brf/master/force-brf/main/classes/brf_BatchApexErrorEvents.cls
		* Getting Job Information
		*
		* @param jobIds job ids of the batch jobs
		*
		*/
		public abstract Map<Id, JobInfo> resolveById(Set<Id> jobIds);
	}// end of JobInfoResolver
	/**
	 * @description run time job resolver
	 *
	 */
	public class RuntimeJobInfoResolver extends JobInfoResolver {
		/**
		* @description Borrowed from https://raw.githubusercontent.com/afawcett/force-brf/master/force-brf/main/classes/brf_BatchApexErrorEvents.cls
		* Getting Job Information
		*
		* @param jobIds job ids of the batch jobs
		*
		*/
		public override Map<Id, JobInfo> resolveById(Set<Id> jobIds) {
			Map<Id, JobInfo> jobsById = new Map<Id, JobInfo>();
			for (AsyncApexJob job : [select id, CreatedDate, ApexClass.Name from AsyncApexJob where Id IN :jobIds]) {
				JobInfo jobInfo = new JobInfo();
				jobInfo.id = job.Id;
				jobInfo.apexClassName = job.ApexClass.Name;
				jobInfo.createdDate = job.CreatedDate;
				jobsById.put(jobInfo.id, jobInfo);
			}

			return jobsById;
		}
	}
	/**
	 * @description plain old apex class (POAC) -- container only
	 *
	 */
	public class JobInfo {
		public Id id;
		public String apexClassName;
		public DateTime createdDate;
		public override String toString() {
			return 'Job Id:' + this.id 
				+ ', Classname:' + this.apexClassName 
				+ ', CreatedDate:' + this.createdDate;
		}
	} // end of JobInfo

} // end of accc_BatchApexErrorEventHandler