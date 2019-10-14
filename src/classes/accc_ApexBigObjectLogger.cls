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
 * @description This logger writes to a Big Object; if fails, defaults to the parent
 *     The default logging level is DEBUG. This logger will write information to
 *     Big Object (AcccApplicationLog__c)
 * @group Log Aspects
 */
global virtual without sharing class accc_ApexBigObjectLogger extends accc_ApexObjectLogger {

	@TestVisible
	static Boolean m_forceException = false;
	@TestVisible
	static final string EXCEPTION_MSG_FOR_TEST = 'accc_ApexBigObjectLogger:TESTING FORCED EXCEPTION';

	///////////////////////////////////////////////////////////////////////////////////////////////
	//
	// CTORS
	///////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * @description default ctor of accc_ApexBigObjectLogger -- set the default LoggingLevel to DEBUG
	 */
	public accc_ApexBigObjectLogger() {
		super(LoggingLevel.DEBUG);
	} // end of ctor

	/**
	 * @description ctor of accc_ApexBigObjectLogger Logger
	 *
	 * @param level LoggingLevel to use for 'write'
	 */
	public accc_ApexBigObjectLogger(LoggingLevel level) {
		super(level);
	} // end of ctor

	////////////////////////////////////////////////////////////////////////////////
	/// Protected methods
	////////////////////////////////////////////////////////////////////////////////

	/**
	 * @description write output to log
	 *
	 * @param LoggingLevel log level
	 * @param List<Object> data output
	 * @param Boolean true to send out
	 */
	@TestVisible
	protected override List<AcccApplicationLog__c>  writeOutput(LoggingLevel level, List<Object> result, boolean sendToLogger) {

		// write data to the application log object and Big Object
		List<AcccApplicationLog__c> entries = null;
		try {

			if ( accc_ApexConstants.UNIT_TEST_RUNNING 
				&& accc_ApexBigObjectLogger.m_forceException==true){
				throw new accc_ApexApplicationException(EXCEPTION_MSG_FOR_TEST);
			}
			// here we get back what the parent sent -
			// and use to create the outgoing big object
			entries = super.writeOutput(level, result, sendToLogger);

			// if all went well, we have the data sent to the custom object
			if ( sendToLogger && null != entries ) {
				// now, we have to  convert/translate to new entries (right now this is 2(O(n)) in perf!!.
				// Perhaps, another iteration/refactoring this will be changed
				List<accc_PlatformEventDAOLog> daoBO = accc_MessageTransformation.translateFromAppLog(entries);
				List<accc_Org_Events__b> bigObjects = accc_PlatformEventDAOLog.mapFrom(daoBO);
				// get a writer to a big object. At some point this too should be changed
				// to use a factory!!! (REFACTOR)
				this.getWriter(bigObjects).execute();

			}

		} catch (Exception excp) {
			// Exception occurred, output the exception message
			accc_ApexUtilities.log(excp);
		}

		return entries;
	} // end of writeOutput

	/**
	 * @description get our Big Object Data writer, We want async and denote it is Big Object
	 *
	 * @param entries our SObjects to write
	 * @return accc_SObjectBaseWriter
	 */
	@TestVisible
	protected virtual accc_SObjectBaseWriter getWriter(List<SObject> entries) {
		return  new accc_SyncAsyncWriter(entries,
		                                 false,// Do NOT Delete these items (upsert)
		                                 false,// Is Synchronous Only (grandfathered in)
		                                 true, // Is Big Object
		                                 true  // Force Async
		                                );
	} // end of getWriter

} // end of accc_ApexBigObjectLogger