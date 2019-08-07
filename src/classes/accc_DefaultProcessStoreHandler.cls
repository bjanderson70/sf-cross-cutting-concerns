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
 *
 * @author Bill Anderson
 * @description defines a handler. This class is called when an event is needing to be stored. Assuming the
 * Platform Attribute is serialize (== true) the event that is sent/received, this class will extract
 * the serialize event and push to the asynchronous queue to store in a Big Object. This serves two
 * thoughts:
 *      1) Bec/ it is asynchronous it will have its own DML (not impeded the currect transaction)
 *      2) This is stored in a Big Object for AMPLE storage
 *      3) Allows the ability to Audit Platform Events
 *
 * If you need to extract the data, use a local custom object to push data into nightly (batch).
 *
 * @group Common Layer
 */
public with sharing class accc_DefaultProcessStoreHandler  extends accc_DefaultProcessHandler {


	/////////////////////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////////////////////

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Ctors
	//
	/////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * @brief ctor
	 * @description ctor
	 *
	 */
	public accc_DefaultProcessStoreHandler() {
		super(accc_DefaultProcessHandler.DEFAULT_STORE_NAME);
	} // end of ctor

	/**
	 * @brief ctor
	 * @description ctor
	 *
	 */
	public accc_DefaultProcessStoreHandler(string name) {
		super(name);
	} // end of ctor
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Public Methods
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description override to String to show contents
	 * @return string of accc_DefaultProcessHandler contents
	 */
	public  override String toString() {

		return
		    super.toString() + '\n' +
		    'accc_DefaultProcessStoreHandler\n' +
		    '{' +
		    '\n' +
		    '}';
	} //  end of toString
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Protected Methods
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description Override this method if needed
	 *
	 * @param parameter data to the log,error, success, alert, etc.
	 * @param attributes  platform attributes
	 *
	 * @return object information
	 */
	@TestVisible
	protected override Object childProcess(Object parameter, accc_PlatformEventAttrs attributes) {

		// are we storing ?? check the attributes to control
		if ( attributes != null
		        && attributes.storeEvent() == false ) {
			// no work to perform
			return null;
		}
		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> data = (List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> )parameter;
		String results = accc_DefaultProcessHandler.makeResultsFromList(data);
		String placeholder = '++++ MESSAGE ++++ [{0}] : accc_DefaultProcessStoreHandler.childProcess called\n {1}';
		List<String> fillers = new String[] { this.handlerName(),  results };
		String result = String.format(placeholder, fillers);

		accc_ApexUtilities.log(result);
		// reset our exception
		this.caughtException = null;

		try {
			if ( parameter == null ) {
				throw new NullPointerException();
			}
			List<accc_PlatformEventDAOLog> dbData = accc_DefaultProcessStoreHandler.getEventInformation(data);
			result = string.valueOf(dbData);
			// get the injector to store the data
			accc_PlatformEventLogInjector injector = new accc_PlatformEventLogInjector(dbData);
			// injector can throw an exception
			injector.store();

		} catch (Exception excp) {
			this.caughtException = excp;
			result = excp.getMessage();
			accc_ApexUtilities.log(excp);
		}

		return result;
	} // end of childProcess
	/**
	 * @description get the event information
	 *
	 * @param data collection of various data information on the event
	 * @return String, serialized event
	 */
	@TestVisible
	static List<accc_PlatformEventDAOLog> getEventInformation(List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> data) {
		List<accc_PlatformEventDAOLog> result = new List<accc_PlatformEventDAOLog>();
		// any data to process
		if ( data != null) {

			for ( accc_DefaultPlatformEvent.PlatformEvtResultPOAC item : data) {
				// event, should only be one and ends in '__e'
				// Note, the 'Misc' contains the # of events that were sent
				if ( !string.isBlank(item.Name) &&
				        item.Name.endsWith(accc_ApexConstants.EVENT_TYPE_TAG_s) ) {
					result.add(new accc_PlatformEventDAOLog(item.Name,
					                                       item.Datum,
					                                       Datetime.Now(),
					                                       (integer)item.Misc,
					                                       item.replayIds,
					                                       item.operationIds)
					          );
				}

			}
		}
		return result;
	} // end of getEventInformation

} // end of accc_DefaultProcessStoreHandler