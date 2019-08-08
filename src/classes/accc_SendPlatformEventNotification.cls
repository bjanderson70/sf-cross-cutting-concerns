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
 * @description send out a Platform Event via (queuable)
 * @group Data Layer
 */
public with sharing class accc_SendPlatformEventNotification implements Queueable {
	/////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////

	@TestVisible
	private List<SObject> m_entries;
	@TestVisible
	private String m_eventName = null;
	@TestVisible
	private String m_environment = accc_ApexConstants.TEST_CATEGORY ;
	@TestVisible
	private Boolean m_delivered = false;

	/////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////
	/**
	 * @brief ctor
	 * @description ctor
	 *
	 * @param entries collection of SObjects
	 */
	public accc_SendPlatformEventNotification(List<SObject> entries) {
		this(entries, null, null);
	} // end of ctor
	/**
	 * @brief ctor
	 * @description ctor
	 *
	 * @param entries collection of SObjects
	 * @param environment (test, debug, production)
	 */
	public accc_SendPlatformEventNotification(List<SObject> entries, String environment) {
		this(entries, null, environment);
	} // end of ctor

	/**
	 * @description ctor to insert/or remove items from big object
	 *
	 * @param entries data entries
	 * @param event name
	 * @param the environment  (test, debug, production)
	 *
	 */
	public accc_SendPlatformEventNotification(List<SObject> entries, String eventName, String environment) {
		String evtName = String.isBlank(eventName) && entries != null ? accc_ApexUtilities.getSobjectName(entries) : eventName,
		       environ = String.isBlank(environment) ? accc_ApexConstants.PRODUCTION_CATEGORY : environment;

		if ( String.isBlank(evtName)) {
			throw new accc_PlatformEventException('accc_SendPlatformEventNotification: Event Name is invalid (blank, null, or empty)');
		} else if ( entries == null ) {
			throw new accc_PlatformEventException('accc_SendPlatformEventNotification: Event list is invalid (null)');
		}
		this.m_entries = entries;
		this.m_eventName = evtName;
		this.m_environment = environ;

	}// end of ctor

	/////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////

	/*
	* @description Here we insert the event data big object records,
	* or log an error if insertion fails.
	*
    * @param queuable context
	*/
	public void execute(QueueableContext context) {

		try {

			accc_ApexUtilities.log(
			    '++++ In accc_SendPlatformEventNotification.process : \n' +
			    '        +++++ size of entires      : ' + this.m_entries.size() + '\n' +
			    '        +++++ getDMLStatements     : '	+ Limits.getDMLStatements() + '\n' +
			    '        +++++ getLimitAsyncCalls   : ' + Limits.getLimitAsyncCalls() + '\n' +
			    '        +++++ getLimitQueueableJobs: ' + Limits.getLimitQueueableJobs() + '\n' +
			    '        +++++ getCpuTime           : ' + Limits.getCpuTime() + '\n' +
			    '        +++++ getLimitCpuTime      : ' + Limits.getLimitCpuTime() + '\n' +
			    '        ++++++getLimitDMLRows   : ' + Limits.getLimitDMLRows() + '\n' +
			    '        +++++ getDMLRows           : ' + Limits.getDMLRows() + '\n');

			// rem-map for a new event to send out

			// [1] create default attributes -- optional
			accc_PlatformEventAttrs attributes = new accc_PlatformEventAttrs();
			// [2] create platform event builder, platform event name and the runtime environment (‘test’,’debug’prod’)
			accc_PlatformEvtBuilder builder = new accc_PlatformEvtBuilder(this.m_eventName, this.m_environment);
			// [3] create the default publisher
			accc_IEventHandler publisher = builder.buildPublisher();
			// [4] create event model
			accc_IPlatformEventModel model = builder.build(publisher); // or builder.build(publisher,attributes);
			// result of process
			this.m_delivered = model.process(this.m_entries);
			// [6] process/publish the event (returns true, if processed successfully)
			accc_ApexUtilities.log('++++ accc_SendPlatformEventNotification.process - result :' + this.m_delivered);

		} catch (Exception excp) {
			// Exception occurred, output the exception message
			accc_ApexUtilities.log(excp);
		}

	} // end of execute

} // end of accc_SendPlatformEventNotification