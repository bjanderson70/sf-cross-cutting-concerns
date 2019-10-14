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
 *
 * @description defines the consumer process. This a default consumer. It DOES NOT do true processing
 * of the incoming event. It does a lot of the heavy lifting. If you are reading this then know,
 * you would override the method 'consumePlatformEvent'. It does pass quite a number of parameters.
 * The Unit Test shows how they are used. You can see how they are used in 'consumePlatformEvent'
 *
 * @group Common Layer
 */
public virtual without sharing class accc_DefaultPEConsumer extends accc_DefaultPlatformEvent {

    ////////////////////////////////////////////////////////////////////////
    // Data Members
    /////////////////////////////////////////////////////////////////////////
    /*
     * keep track of the number of events processed
     */
    @TestVisible
    integer numberOfEventsProcessed = 0;
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
     * @param doSerialization do we serialize the event (if you want to store it in BO, this is needed)
     */
    public accc_DefaultPEConsumer(String theEventName, Boolean doSerialization) {
        super(theEventName, doSerialization);
    }

    ////////////////////////////////////////////////////////////////////////
    // Public Methods
    /////////////////////////////////////////////////////////////////////////

    public class accc_DefaultPEConsumerException extends Exception {}

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
        //
        // get some event trigger information
        //
        integer retryCount = attributes.retryCount(),
                currentRetries = EventBus.TriggerContext.currentContext().retries,
                eventBatchSize = attributes.eventBatchSize(),
                collectionSize= (collectionOfEvents !=null ) ? collectionOfEvents.size() : 0;
        // are there more entries than we have batched for; if so, will slice and set next replay id
        Boolean willNeedRetryDueToBatchSize = collectionSize > eventBatchSize;

        // start message
        accc_DefaultPlatformEvent.PlatformEvtResultPOAC alertMsg = new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Consumer: Start Time');
        // add instrumentation, if necessary
        super.addInstrumentation(super.willInstrument
                                 , alertMsg
                                 , theLogData);

        try {
            // take note of the incoming collection ( may need to slice)
            List<SObject>  collectionOfEventsByAttribute=collectionOfEvents;
            this.numberOfEventsProcessed = 0;
            //********************************************************************************
            // Batching ?
            //
            // (refer: https ://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/platform_events_subscribe_compare_checkpoint_retryable.htm)
            //
            // Users have the ability to specify how much data they wish to process. This
            // allows the user to determine ( via testing) how much data they can process within
            // the trigger (for example, see pe_test__e which sets the Batch to 200). The class
            // uses setResumeCheckpoint() for a number of reasons:
            //
            //    (1) Any DML is NOT rolled back like EventBus.RetryableException
            //    (2) We slice the data into the Batch chunk specified by the invoker (controlled via attributes)
            //    (3) When the trigger fires AGAIN, only the event messages after the one with the specified replay ID are resent
            //
            // User still has the ability to throw a EventBus.RetryableException. However, it has
            // the following consequences:
            //
            //    (1) DML operations performed before the exception is thrown are rolled back and not committed .
            //    (2) When the trigger fires again, all event messages from the previous batch are resent in the new batch, in addition to any new event messages .
            //
            //
            //*******************************************************************************/

            // for test reference
            this.numberOfEventsProcessed =collectionSize;
            // When the Batch limit is specified we DO NOT throw; instead, we slice and 
            // set last replayid processed
            //
            // do we need to slice the data
           if (willNeedRetryDueToBatchSize ) {
               collectionOfEventsByAttribute= (List<SObject>)accc_ApexUtilities.slice(collectionOfEvents,0,eventBatchSize);
                this.numberOfEventsProcessed = eventBatchSize;
            }
            
            // let's remember our replay ids ( just remembering)
            super.setReplayIds(collectionOfEventsByAttribute);
            // reset the retry (in case of re-entrance)
            super.retryRequired = false;
            // add message and alert we have started
            super.alertAddAndSend(handlers, alertMsg, theAlerts, attributes);
            // normal processing, assuming the retry count is less than we allow
            // ( only applicable w/ EventBus.RetryableException)
            if ( currentRetries < retryCount ) {
                // add message and alert we about to process
                super.alertAddAndSend(handlers
                                      ,  new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Consumer: Before Processing')
                                      , theAlerts
                                      , attributes);
                // perform the function needed. Requires the child to override
                // 'consumePlatformEvent'
                state = this.consumeCanonicalForm(collectionOfEventsByAttribute, handlers, attributes, theData, errResult, theLogData);
            } else {
                throw new accc_PlatformEventException(this.formatRetryMessage('Consumer: Exceeded Platform Event Retries {0} - Max is 9', currentRetries));
            }

        } catch ( EventBus.RetryableException retryException ) {
            accc_ApexUtilities.log(retryException);
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
     *  4) save replayIds and operation Ids
     *  5) Store information
     *  6) return state
     * @param collectionOfEvents the event colection
     * @param handlers the handlers (log, error, success)
     * @param attributes platform event attributes
     * @param theData the event information (json)
     * @param errResult the error log
     * @param theLogData the log information
     * @return true, if successful
     */
    @TestVisible
    protected boolean consumeCanonicalForm(List<SObject>  collectionOfEvents
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

        // here we do some house-keeping so the child does not have to
        this.preludeBeforeChildOverridingConsumption(collectionOfEvents, theLogData);
        // Here is where we ensure that the Batch Size requested is processed correctly.
        // From : https ://releasenotes.docs.salesforce.com/en-us/summer19/release-notes/rn_platform_event_batch.htm
        //
        // Why : By processing fewer event messages, your trigger is less likely to hit Apex governor limits.
        // The maximum batch size of a platform event trigger is 2,000, while the maximum of an Apex object
        // trigger is 200. Therefore, platform event triggers are more likely to reach limits and can benefit
        // from this feature .

        // NOTE, Children SHOULD OVERRIDE method (consumePlatformEvent) and perform consumption of the event
        // TBD -- Make Abstract
        // child SHOULD OVERRIDE for desired behavior
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
            // update check point ( this is where the setresumereplayid is done)
            super.updateCheckPoint();
            // log success
            super.logSuccess(handlers, theData, attributes);
        }
        return state;
    } // end of consumeCanonicalForm

    /**
     * @description This method is called BEFORE the child performs any override. This allows
     * us to provide some information ( as the child may not)
     *
     * @param List<SObject> collectionOfEvents
     * @param List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData
     * @return void
     */
    protected void preludeBeforeChildOverridingConsumption(List<SObject> collectionOfEvents
                                                           , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData)
    {
        // record process of save result
        super.addInstrumentation(super.willInstrument,
                                 new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Consumer: preludeBeforeChildOverridingConsumption')
                                 , theLogData);
    } // end of preludeBeforeChildOverridingConsumption
    /**
     * @description child decide how to consume; child should throw EventBus.RetryableException if the handler
     * needs to be called again. Or, specify a small batch size ( via the attributes) to process a smaller chunk.
     *
     * @param collectionOfEvents the collection of events
     * @param handlers platform event handlers
     * @param attributes platform event attributes
     * @param theData the event information (json)
     * @param errResult errors that occur
     * @return true if processed
     */
    @TestVisible
    protected virtual boolean consumePlatformEvent(List<SObject> collectionOfEvents
                                                   , accc_IProcessEventHandlers handlers
                                                   , accc_PlatformEventAttrs attributes
                                                   , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult
                                                   , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData) {


        // NOTE, Children SHOULD OVERRIDE this method and perform consumption of the event
        // TBD -- Make Abstract

        // if we are here , we handled the events;
        if ( accc_ApexConstants.UNIT_TEST_RUNNING) {
            // record process of save result -- LEAVE this in for testing
            super.addInstrumentation(super.willInstrument,
                                     new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Consumer: consumePlatformEvent result=true , collection size=' + collectionOfEvents.size())
                                     , theLogData);
        }

        return true;

    } // end of consumePlatformEvent
    /**
     * @description Allow the child to do anything after completion of the event publish process
     *
     * @param collectionOfEvents the events
     * @param state true if successful completion
     * @param errResult the error log
     * @param theData the event information (json)
     * @param theLogData the log information
     * @param attributes platform event attributes
     * @return void
     */
    @TestVisible
    protected virtual void handleCompletion(List<SObject>  collectionOfEvents
                                            , Boolean state
                                            , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult
                                            , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theData
                                            , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData
                                            , accc_PlatformEventAttrs attributes) {
        if ( accc_ApexConstants.UNIT_TEST_RUNNING) {
            // NO-OP
            super.addInstrumentation(super.willInstrument,
                                     new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('Consumer: handleCompletion result=true')
                                     , theLogData);
        }
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
            // update the state
            if ( state ) {
                // update check point
                super.updateCheckPoint();
            }
            // allow the children to do any other type of cleanup
            this.handleCompletion(collectionOfEvents, state, errResult, theData, theLogData, attributes );
        } catch (Exception excp) {
            accc_ApexUtilities.log(excp);
            super.theException = excp;
        }

    } // end of finallyProcess

} // end of accc_DefaultPEConsumer
