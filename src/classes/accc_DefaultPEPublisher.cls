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
 * @description defines the default publisher; YOU MUST inherit to change behavior
 * @group Common Layer
 */
public virtual without sharing class accc_DefaultPEPublisher extends accc_DefaultPlatformEvent {


    ////////////////////////////////////////////////////////////////////////
    // Data Members
    ////////////////////////////////////////////////////////////////////////
    /*
     * Our Preamble for errors that can occur in the SaveResult from a Published Event.
     * Helps denotes the fault (i.e. SaveResult)
     */
    public static final String PUBLISHER_ERROR_PREAMBLE = 'Problem publishing event(s) [SaveResult]:';

    ////////////////////////////////////////////////////////////////////////
    // Ctors
    ////////////////////////////////////////////////////////////////////////

    /**
     * @description default ctor
     *
     */
    public accc_DefaultPEPublisher() {
        super(null);
    }
    /**
     * @description ctor with event name
     *
     * @param theEventName the event name
     */
    public accc_DefaultPEPublisher(String theEventName) {
        super(theEventName);
    }
    /**
     * @description ctor with event name
     *
     * @param theEventName the event name
     * @param theSerializeEvent serialize the event
     */
    public accc_DefaultPEPublisher(String theEventName, Boolean theSerializeEvent) {
        super(theEventName, theSerializeEvent);
    }

    ////////////////////////////////////////////////////////////////////////
    // Public Methods
    /////////////////////////////////////////////////////////////////////////

    public virtual override String toString() {
        return super.toString() + '\n' +
               '\taccc_DefaultPEPublisher\n' +
               '\t{' + '\n' +
               '\t}' + '\n';
    } // end of toString

    ////////////////////////////////////////////////////////////////////////
    // Protected Methods
    /////////////////////////////////////////////////////////////////////////
    /**
     * @description publisher -- go through a stepwise process to alert, wrap, send and notify
     *
     * @param collectionOfEvents the events
     * @param handlers the handlers (log, error, success)
     * @param attributes platform event attributes
     * @return true, if successful
     */
    protected override boolean childProcess(List<SObject> collectionOfEvents, accc_IProcessEventHandlers handlers, accc_PlatformEventAttrs attributes) {
        Boolean state = false;

        accc_PlatformEventAttrs.EventLogging logStatus = attributes.loggingStatus();

        // holds the errors
        List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();
        // holds the data (i.e. json)
        List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theData = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();
        // holds the instrumentation data
        List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();
        // holds alert information
        List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theAlerts = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();
        // start message
        accc_DefaultPlatformEvent.PlatformEvtResultPOAC alertMsg = new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher: Start Time');

        super.addInstrumentation(super.willInstrument
                                 , alertMsg
                                 , theLogData);

        try {
            // Step 1: Notify
            //
            // add message and alert we have started
            super.alertAddAndSend(handlers, alertMsg, theAlerts, attributes);
            //
            // Step 2: Serialize Events
            //
            // add data for auditing/storage
            super.serializeEventData(theData, collectionOfEvents);
            //
            // Step 3: Check for Exceptions
            //
            // check for any exception
            if ( super.theException != null ) {
                errResult.add(new accc_DefaultPlatformEvent.PlatformEvtResultPOAC(new accc_DefaultPlatformEvent.ErrorResultPOAC(StatusCode.INVALID_STATUS, super.theException.getMessage())));
            } else {
                //
                // Step 4: Ready to Send , Instrumentation and Process
                state = this.readyToSend(collectionOfEvents
                                         , handlers
                                         , attributes
                                         , theData
                                         , errResult
                                         , theLogData
                                         , theAlerts);
            }
            //
            // Step 5: Complete Event Processing/Sending -- notify/alert
            //
            // add message and alert we are after publish
            super.alertAddAndSend(handlers
                                  , new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher: After processResults')
                                  , theAlerts
                                  , attributes);

        } catch (Exception excp) {
            super.theException = excp;
            errResult.add(new accc_DefaultPlatformEvent.PlatformEvtResultPOAC(new accc_DefaultPlatformEvent.ErrorResultPOAC(StatusCode.INVALID_STATUS, excp.getMessage())));
            throw excp;

        } finally {
            //
            // Step 6: Final - Handle Notifications
            //

            // do not allow possible children to throw exceptions in our finally clause
            // instead, catch
            this.finallyProcess(collectionOfEvents
                                , state
                                , handlers
                                , attributes
                                , theData
                                , errResult
                                , theLogData
                                , theAlerts);
        }

        return state;
    } // end of childProcess

    /**
     * @description publish event -- it is a virtual in the event it needs to be overriden
     *
     * @param events the events to publish
     * @return List<Database.SaveResult>
     */
    @TestVisible
    protected virtual List<Database.SaveResult> publish(List<SObject> events) {
        // Call method to publish events
        return EventBus.publish(events);

    } // end of publish

  
    /**
     * @description process the results from the publish
     *
     * @param the results of the save
     * @param collection of events
     * @param errResult logs any errors -- it is a virtual in the event it needs to be overriden
     * @param theData holds operation ids, etc.
     * @return integer number of successful records saved
     */
    @TestVisible
    protected virtual integer processResults(List<Database.SaveResult> results,
                                             List<SObject>  collectionOfEvents,
                                             List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult,
                                             List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theData) {
        integer count = results != null ? results.size() : 0;

        // any work
        if ( count > 0 ) {
            Integer inx = 0;
            String excpMessage='';
            // set the operation ids
            this.setOperationIds(results);
            // Inspect publishing result for each event
            for (Database.SaveResult sr : results) {
                // if error
                if (false == sr.isSuccess() ) {
                    count--;
                    if ( errResult != null ) {
                        for (Database.Error err : sr.getErrors()) {
                            excpMessage += this.formErrorMessage(err);
                            errResult.add(new accc_DefaultPlatformEvent.PlatformEvtResultPOAC(new accc_DefaultPlatformEvent.ErrorResultPOAC(err.getStatusCode(), err.getMessage())));
                        }
                        // we have errors from publishing. This can occur due to many cases;
                        // for example, one of the text field has a define length, and you did not trim before stashing;
                        // you would get a STRING_TOO_LONG. The error is pushed into 'errResult' but it
                        // would be good to create an exception so callers can more readily see an exception.
                        //
                        // No need to throw as the status will be false that the event did not publish and the information
                        // if logs are captured (i.e. Not NoOp Logging), will see the error (as well)
                        // ( we do not overwrite any other exception)
                        if (string.isNotEmpty(excpMessage)
                            && super.theException==null) {
                            super.theException = new accc_PlatformEventException(PUBLISHER_ERROR_PREAMBLE
                                                                                 + excpMessage
                                                                                 );
                        }
                    }
                }
            }
            // record the operation ids and replay ids in case of
            // an AsyncOperationEvent failure
            super.recordOperationAndReplayIds(theData);
        }
        return count;
    } // end of processResults

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
        //
        // NO-OP -- TO BE DEFINED BY CHILDREN  !!!
        //
    } // end of handleCompletion
    /**
     *@description ready to send the information
     *
     * @param collectionOfEvents the event colection
     * @param handlers the handlers (log, error, success)
     * @param attributes platform event attributes
     * @param errResult the error log
     * @param theData the event information (json)
     * @param theLogData the log information
     * @param theAlerts the alert information
     * @return true, if successful
     */
    @TestVisible
    protected boolean readyToSend(List<SObject>  collectionOfEvents
                                  , accc_IProcessEventHandlers handlers
                                  , accc_PlatformEventAttrs attributes
                                  , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theData
                                  , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult
                                  , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData
                                  , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theAlerts
                                  ) {
        integer count = 0, processed = 0;
        // add message and alert we are calling publish
        super.alertAddAndSend(handlers
                              , new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher: Before Publish')
                              , theAlerts
                              , attributes);
        // Call method to publish events
        List<Database.SaveResult> results = this.publish(collectionOfEvents);

        // record event publish time
        super.addInstrumentation(super.willInstrument,
                                 new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher: Event Published')
                                 , theLogData);
        // add message and alert after publish
        super.alertAddAndSend(handlers
                              , new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher: After Publish')
                              , theAlerts
                              , attributes);
        // remember the number of results
        count = results.size();
        // Inspect publishing result for each event, return the decremented errors from the initial size
        processed = this.processResults(results, collectionOfEvents, errResult, theData);
        // record process of save result
        super.addInstrumentation(super.willInstrument,
                                 new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher: SaveResult Processed')
                                 , theLogData);

        // check state based on return of results, if no match there was an error
        return count == processed;
    } // end of readyToSend
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
                                  ) {
        // do not allow  children to throw exceptions in our finally clause
        // instead, catch. Note, if our handlers catches exceptions, continue to flow thru the
        // process. User can decide later what to do.
        //
        // FUTURE ...
        //
        // TBD ... Allow the user to stop ALL processing if ANY exception occurs (DONE via attributes)
        //

        try {

            accc_ApexUtilities.log('++++' + this.toString());

            // Here we log the successful state by calling it's handler
            if ( theData.size() > 0 && super.canLogSuccess && state == true ) {
                // Log the success marker, this will pass in the json data
                super.logSuccess(handlers, theData, attributes);
            }

            //
            // here we call the error handler, if any.
            //
            if ( errResult.size() > 0 && super.canLogError ) {
                super.errorHandler(handlers, errResult, attributes);
            }

            //
            // notify the handler of the instrumented data gathered
            //
            if ( theLogData.size() > 0 && super.canLog ) {
                super.addInstrumentation(super.willInstrument,
                                         new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher : Process Done')
                                         , theLogData);
                // log the information on the event
                super.logHandler(handlers, theLogData, attributes);
            }

            //
            // add message and alert we are in finally
            //
            super.alertAddAndSend(handlers
                                  , new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Publisher: Finally State')
                                  , theAlerts
                                  , attributes);


            // here we store event
            if ( theData.size() > 0 && super.isEventToBeStored ) {
                // store the event(s)
                super.storeHandler(handlers, theData, attributes);
            }

            //
            // **** this is cleanup/completion to be defined by the CHILD method 'handleCompletion' ***
            // allow the children to do any other type of completion/ cleanup they want
            //
            this.handleCompletion(collectionOfEvents, state, errResult, theData, theLogData, attributes );

        } catch (Exception excp) {
            accc_ApexUtilities.log(excp);
            // if we are here, something occur with one of the handlers
            // save it for the callee
            super.theException = excp;
        }
    } // end of finallyProcess

    /**
     * @description form the error message for exception when processing Database.Error.
     * protected (virtual) to allow a different format. My best guess
     * @param Database.Error error in the save-result
     * @return String exception string
     **/
    @TestVisible
    protected virtual String formErrorMessage(Database.Error err){
        return 'Error Code:' +err.getStatusCode() + ', Error Message:'+ err.getMessage() + accc_ApexConstants.NewLine;
    }// end of formErrorMessage

} // end of accc_DefaultPEPublisher