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
 * @description defines the consumer process
 * @group Common Layer
 */
public virtual without sharing class accc_DefaultPEConsumer extends accc_DefaultPlatformEvent {


	////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////
	/**
	* @description default ctor
	*
	*/
	public accc_DefaultPEConsumer() {
		super(null);
	}
	/**
	* @description ctor with event name
	*
	* @param theEventName the event name
	*/
	public accc_DefaultPEConsumer(String theEventName) {
		super(theEventName);
	}
	/**
	* @description ctor with event name
	*
	* @param theEventName the event name
	* @param doSerialization do we serialize the event
	*/
	public accc_DefaultPEConsumer(String theEventName, Boolean doSerialization) {
		super(theEventName, doSerialization);
	}

	////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////


	////////////////////////////////////////////////////////////////////////
	// Protected Methods
	/////////////////////////////////////////////////////////////////////////
	/**
	 * @description consumer -- Here are the steps are as follows:
	 *
	 *  1. Call method 'consumePlatformEvent' to consume the event.
	 *      a. 'consumePlatformEvent' throws EventBus.RetryableException, if exception
	 *      b. 'process' determines if we can process based on retry count
	 *  2. Non-EventBus.RetryableException causes the handler not to process further
	 *  3. Call finallyProcess to tidy up, any exception is caught and retained
	 *  4. If no exceptions return state back to callee.
	 *
	 * @param collectionOfEvents the event colection
	 * @param handlers the handlers (log, error, success)
	 * @param attributes platform event attributes
	 * @return true, if successful
	 */
	@TestVisible
	protected override boolean childProcess(List<SObject> collectionOfEvents
	                                        , accc_IProcessEventHandlers handlers
	                                        , accc_PlatformEventAttrs attributes) {
		Boolean state = false;
		// holds the data information
		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theData = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		// holds error information
		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		// holds the instrumentation data
		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		// holds alert information
		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theAlerts = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();


		integer retryCount = attributes.retryCount(),
		        currentRetries = EventBus.TriggerContext.currentContext().retries;

		// start message
		accc_DefaultPlatformEvent.PlatformEvtResultPOAC  alertMsg = new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Consumer: Start Time');

		// add instrumentation, if necessary
		super.addInstrumentation(super.willInstrument
		                         , alertMsg
		                         , theLogData);

		try {
			// reset the retry (in case of re-entrance)
			super.retryRequired = false;
			// add message and alert we have started
			super.alertAddAndSend(handlers, alertMsg, theAlerts, attributes);
			// normal processing, assuming the retry count is less than we allow
			if ( currentRetries < retryCount ) {
				// add message and alert we about to process
				super.alertAddAndSend(handlers
				                      ,  new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Consumer: Before Processing')
				                      , theAlerts
				                      , attributes);
				state = this.consumeCanonicalForm(collectionOfEvents, handlers, attributes, theData, errResult, theLogData);
			} else {
				throw new accc_PlatformEventException(this.formatRetryMessage('Consumer: Exceeded Platform Event Retries {0} - Max is 9', currentRetries));
			}
		} catch ( EventBus.RetryableException retryException ) {
			accc_PlatformEventLogger.myInstance().log(retryException);
			super.retryRequired = true;

			// we got another exception, save
			errResult.add(new accc_DefaultPlatformEvent.PlatformEvtResultPOAC(new accc_DefaultPlatformEvent.ErrorResultPOAC(StatusCode.UNKNOWN_EXCEPTION, retryException.getMessage())));
			// child decided to retry again, check our retry  level
			// ..... do we retry
			if (currentRetries < retryCount ) {
				// process errors encountered, notify and save in prep for the next invocation.
				// as throwing a RetryableException will cause the process/trigger to be called again (upto 10 times)
				if ( errResult.size() > 0 && super.canLogError ) {
					super.errorHandler(handlers, errResult, attributes);
				}

				// Condition isn't met, so try again later. Up to 9 times (it is 10, but we already did 1)
				throw retryException;
			}
		} catch (Exception excp) {
			// we got another exception, save
			errResult.add(new accc_DefaultPlatformEvent.PlatformEvtResultPOAC(new accc_DefaultPlatformEvent.ErrorResultPOAC(StatusCode.INVALID_STATUS, excp.getMessage())));
		} finally {

			// do not allow possible children to throw exceptions in our finally clause
			// instead, catch
			this.finallyProcess(collectionOfEvents
			                    , state
			                    , handlers
			                    , attributes
			                    , theData
			                    , errResult
			                    , theLogData
			                    , theAlerts,
			                    currentRetries);
		}

		return state;
	} // end of childProcess
	/**
	 * @description this defines a canonical form to process the event. There is no need to catch an
	 * exception as it will be handled in the caller. The following is ensured:
	 *  1) Save data for audit
	 *  2) consume the event (whatever that means to the user)
	 *  3) record good state
	 *  4) return state
	 * @param collectionOfEvents the event colection
	 * @param handlers the handlers (log, error, success)
	 * @param attributes platform event attributes
	 * @param errResult the error log
	 * @param theData the event information (json)
	 * @param theLogData the log information
	 * @return true, if successful
	 */
	@TestVisible
	protected  boolean consumeCanonicalForm(List<SObject>  collectionOfEvents
	                                        , accc_IProcessEventHandlers handlers
	                                        , accc_PlatformEventAttrs attributes
	                                        , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theData
	                                        , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult
	                                        , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData
	                                       ) {
		Boolean state;

		// add data for auditing/logging
		super.serializeEventData(theData, collectionOfEvents);
		// check for any exception
		if ( super.theException != null ) {
			errResult.add(new accc_DefaultPlatformEvent.PlatformEvtResultPOAC(new accc_DefaultPlatformEvent.ErrorResultPOAC(StatusCode.INVALID_STATUS, super.theException.getMessage())));
		}
		// child should override for desired behavior
		state = this.consumePlatformEvent( collectionOfEvents
		                                   , handlers
		                                   , attributes
		                                   , errResult
		                                   , theLogData);
		// record process of save result
		super.addInstrumentation(super.willInstrument,
		                         new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Consumer: consumePlatformEvent Processed')
		                         , theLogData);

		// did the child process finish successfully.

		if ( state == true ) {
			super.logSuccess(handlers, theData, attributes);
		}
		return state;
	} // end of consumeCanonicalForm

	/**
	 * @description child decide how to consume; child should throw EventBus.RetryableException if the handler
	 * needs to be called again.
	 *
	 * @param collectionOfEvents the collection of events
	 * @param handlers platform event handlers
	 * @param attributes platform event attributes
	 * @param errResult errors that occur
	 * @return true if processed
	 */
	@TestVisible
	protected virtual boolean consumePlatformEvent(List<SObject> collectionOfEvents
	        , accc_IProcessEventHandlers handlers
	        , accc_PlatformEventAttrs attributes
	        , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult
	        , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData) {
		// record process of save result
		super.addInstrumentation(super.willInstrument,
		                         new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Consumer: consumePlatformEvent result=true')
		                         , theLogData);
		return true;

	} // end of consumePlatformEvent
	/**
	 * @description Allow the child to do anything after completion of the event publish process
	 *
	 * @param event the event
	 * @param state true if successful completion
	 * @param errResult the error log
	 * @param theData the event information (json)
	 * @param theLogData the log information
	 * @param attributes platform event attributes
	 * @return void
	 */
	@TestVisible
	protected virtual void handleCompletion(Object event
	                                        , Boolean state
	                                        , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult
	                                        , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theData
	                                        , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData
	                                        , accc_PlatformEventAttrs attributes) {

		// NO-OP
		super.addInstrumentation(super.willInstrument,
		                         new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Consumer: handleCompletion result=true')
		                         , theLogData);
	} // end of handleCompletion

	/**
	 * @description our exception message
	 *
	 * @param message our message (has one {0} collectionOfEvents)
	 * @param retryCount number of retries
	 *
	 * @return formated string
	 */
	@TestVisible
	protected string formatRetryMessage(String message, integer retryCount) {
		String placeholder = message == null ? 'Platform Event message [{0}]' : message;
		List<String> fillers = new String[] { string.valueOf(retryCount) };

		return String.format(placeholder, fillers);

	} // end of formatRetryMessage

	/**
	 * @description our retry message
	 *
	 * @param retryCount number of retries
	 *
	 * @return formated string
	 */
	@TestVisible
	protected string formatRetryMessage(integer retryCount) {
		String placeholder = 'Platform Event condition is not met, so retrying the trigger again [{0}]';
		return this.formatRetryMessage(placeholder, retryCount);
	} // end of formatRetryMessage
	/**
	 *@description finallyProcess-- ensure all handlers are appropriately called and no exceptions
	 * are thrown from here. Capture exception, if any, into the memeber data
	 * @param collectionOfEvents the event colection
	 * @param state our current state
	 * @param handlers the handlers (log, error, success)
	 * @param attributes platform event attributes
	 * @param errResult the error log
	 * @param theData the event information (json)
	 * @param theLogData the log information
	 * @param theAlerts the alert information
	 * @param currentRetries number of transaction retries
	 * @return true, if successful
	 */
	@TestVisible
	protected void finallyProcess(List<SObject>  collectionOfEvents
	                              , Boolean state
	                              , accc_IProcessEventHandlers handlers
	                              , accc_PlatformEventAttrs attributes
	                              , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theData
	                              , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult
	                              , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData
	                              , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theAlerts
	                              , integer currentRetries
	                             ) {
		// do not allow possible children to throw exceptions in our finally clause
		// instead, catch
		try {
			
			// add message and alert we have started
			super.alertAddAndSend(handlers
			                      ,  new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Consumer: Finally State')
			                      , theAlerts
			                      , attributes);
			// process errors encountered
			if ( errResult != null && errResult.size() > 0 && super.canLogError ) {
				super.errorHandler(handlers, errResult, attributes);
			}
			if ( theLogData != null && super.canLog ) {
				super.addInstrumentation(super.willInstrument,
				                         new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Consumer : Process Done')
				                         , theLogData);
				// log the information on the event
				super.logHandler(handlers, theLogData, attributes);
			}
			// store data (once) ... if we have retried multiple times, only store it ONCE
			if ( theData != null && theData.size() > 0 && currentRetries == 0) {
				super.storeHandler(handlers, theData, attributes);
			}
			// allow the children to do any other type of cleanup
			this.handleCompletion(collectionOfEvents, state, errResult, theData, theLogData, attributes );
		} catch (Exception excp) {
			accc_PlatformEventLogger.myInstance().log('accc_DefaultPEConsumer - Exception: ' + excp.getMessage());
			super.theException = excp;
		}

	} // end of finallyProcess

} // end of accc_DefaultPEConsumer