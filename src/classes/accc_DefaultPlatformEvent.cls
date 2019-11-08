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
 * @description defines the default platform event process. This class SHOULD NOT be used to process
 * platform events (pub/sub) bec/ it defines the shell/pattern to use. The intent was to have subclasses
 * to do the following :
 *    1) Override the 'process' method
 *    2) Use a builder pattern to ensure the process-handlers are defined
 *
 * NOTE: 'accc_DefaultPEPublisher' and 'accc_DefaultPEConsumer' define the process but DO NOT define the handlers!
 *
 * Ideally, define custom metadata to seed the correct object/class (done via a builder). This way
 * one can vary the behavior of the platform events.
 *
 *  When Testing just this class, EventBus.publish() is NOT used. This, we have to simulate
 *  the ReplayId; during NORMAL process of the Consumer/Publisher classes, this is not needed
 *
 * @group Common Layer
 */
public virtual without sharing class accc_DefaultPlatformEvent implements accc_IEventHandler {

    /////////////////////////////////////////////////////////////////////////
    // Data Members
    /////////////////////////////////////////////////////////////////////////
    public static final String REPLAY_ID_INDEX_NAME = 'ReplayId';

    @TestVisible
    static final String EXPECTED_REPLAY_ID_FOR_TESTING = '28531';
    @TestVisible
    static Boolean DO_NOT_SET_CHECKPOINT = false;

    /**
     * @description Error information for processed events
     */
    public class ErrorResultPOAC {
        /////////////////////////////////////////////////////////////
        // DATA MEMBERS
        /////////////////////////////////////////////////////////////
        public string Message;
        public System.StatusCode Code = StatusCode.INVALID_STATUS;
        /////////////////////////////////////////////////////////////
        // Ctors
        /////////////////////////////////////////////////////////////
        public ErrorResultPOAC(System.StatusCode theCode, String theMessage) {
            this.Message = theMessage;
            this.Code = theCode;
        }
        public ErrorResultPOAC(String theMessage) {
            this.Message = theMessage;
        }
    } // end of ErrorResultPOAO

    /**
     * @description this Plain Old Apex Class (POAC) is used by the platform events for data transfer
     *
     */
    public class PlatformEvtResultPOAC {
        /////////////////////////////////////////////////////////////
        // DATA MEMBERS
        /////////////////////////////////////////////////////////////

        public string Datum = '';
        public string Name = '';
        public Object Misc = null;
        public long TheTime = 0;
        public List<ErrorResultPOAC> error = null;
        // version 46, capture the operation ids
        public List<String> operationIds = null;
        // version 46, capture the replay ids
        public List<String> replayIds = null;

        /////////////////////////////////////////////////////////////
        // Ctors
        /////////////////////////////////////////////////////////////
        public PlatformEvtResultPOAC(ErrorResultPOAC theError) {
            if ( error == null) {
                error = new List<ErrorResultPOAC> ();
            }
            error.add(theError);
        }
        public PlatformEvtResultPOAC(string theName) {
            this(theName, null, null, System.currentTimeMillis());

        }
        public PlatformEvtResultPOAC(string theName, string theDatum) {
            this(theName, theDatum, null, System.currentTimeMillis());

        }
        public PlatformEvtResultPOAC(string theName, string theDatum, Object miscellaneousData) {
            this(theName, theDatum, miscellaneousData, System.currentTimeMillis());
        }
        public PlatformEvtResultPOAC(string theName, string theDatum, Object miscellaneousData, long cpuTime) {
            this.Datum = theDatum;
            this.Name = theName;
            this.Misc = miscellaneousData;
            this.TheTime = cpuTime;
        }
        /////////////////////////////////////////////////////////////
        // PUBLIC MEMBERS
        /////////////////////////////////////////////////////////////
        public override String toString() {
            List<String> data = new List<String> {
                'accc_DefaultPlatformEvent: Name=' + this.Name
                , '\nDatum=' + this.Datum
                , '\nMisc=' + string.valueOf(this.Misc)
                , '\nTheTime=' + this.TheTime + ' (ms)'

            };
            if ( this.TheTime != 0 ) {
                data.add('\nConverted Time=' + DateTime.newInstance(this.TheTime).format());
            }
            if ( this.error != null ) {
                for (ErrorResultPOAC item : this.error) {
                    data.add('\n-------------------------');
                    data.add('\nerror.Message=' + item.Message);
                    data.add('\nerror.Code=' + item.Code);
                }
            }
            return String.join(data, '\n');
        } // end of toString
    } // end of PlatformEvtResultPOAC
    // The event Name
    @TestVisible
    String m_eventName = null;
    // Collectoin of events replay Ids
    @TestVisible
    List<String> m_replayIds = null;
    @TestVisible
    List<String> m_opIds = null;
    // the Exception
    @TestVisible
    Exception m_exception = null;
    // use the attributes to determine logging
    @TestVisible
    Boolean m_canLogSuccess = false,
    m_canLogError = false,
    m_canLog = false,
    m_willInstrument = false,
    m_retry = false,
    m_serializeEvent = false,
    m_isActive = true,
    m_canStore = true,
    m_allowRetryAfterException = true;
    // The event Batch Size (set to the default)
    @TestVisible
    Integer mEvtBatchSize = accc_PlatformEventAttrs.DEFAULT_EVENT_BATCH_SIZE;

    /////////////////////////////////////////////////////////////////////////
    // Ctors
    /////////////////////////////////////////////////////////////////////////
    /**
     * @description default ctor
     *
     */
    public accc_DefaultPlatformEvent() {
        this(null, true, true);
    }// end of ctor

    /**
     * @description ctor with event name
     *
     * @param theEventName the event name
     */
    public accc_DefaultPlatformEvent(String theEventName) {
        this(theEventName, true, true);
    }// end of ctor
    /**
     * @description ctor with event name
     *
     * @param theEventName the event name
     * @param serializeTheEvent the data should be serialize
     */
    public accc_DefaultPlatformEvent(String theEventName, Boolean serializeTheEvent) {
        this(theEventName, serializeTheEvent, true);
    }// end of ctor
    /**
     * @description ctor with event name
     *
     * @param theEventName the event name
     * @param serializeTheEvent the data should be serialize
     * @param isActive is the event active
     */
    public accc_DefaultPlatformEvent(String theEventName,
                                     Boolean serializeTheEvent,
                                     Boolean isActive) {
        this.eventName = theEventName;
        this.serializeEvent = serializeTheEvent;
        this.isEventActive = isActive;
        this.ourCurrentSaveResults =null;

    }// end of ctor
    /////////////////////////////////////////////////////////////////////////
    // Public Methods ( as define in the contract)
    /////////////////////////////////////////////////////////////////////////

    /**
     * @description is the event active
     * @return true, if active
     */
    public Boolean handlerIsActive() {
        return this.isEventActive;
    }
    /**
     * @description  the event name, (ie, 'my_event__e')
     * @return name of the event
     */
    public String handlerEventName() {
        return this.eventName;
    }// end of handlerEventName
    /**
     * @description allow a setter from the interface on the event namre
     *
     * @param theEventName string name
     */
    public void handlerEventName(String theEventName) {
        this.eventName = theEventName;
    }// end of handlerEventName
    /**
     * @description any exception which may have occurred
     *
     * @return  Exception
     */
    public Exception handlerException() {
        return this.theException;
    }// end of handlerException


    /**
     * @description the saved results from a publish (default is null)
     * @return List<Database.SaveResult>
     **/
    public List<Database.SaveResult> theSaveResults(){
        return this.ourCurrentSaveResults;
    }
    /**
     * @description retry required from the child. Normally, the consumer, processing an event via a trigger handler,
     * indicates (via boolean) whether a retry is required within the trigger.
     *
     * Note : https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/platform_events_subscribe_apex_refire.htm
     * @return  Boolean
     */
    public Boolean handlerRequiredRetry() {
        this.retryTriggerIfNecessary();
        return this.retryRequired;
    }// end of handlerRequiredRetry
    /**
     * @description should the data be serialize for saving
     *
     * @return  Boolean
     */
    public Boolean handlerToSerialize() {
        return this.serializeEvent;
    } // end of handlerToSerialize
    /**
     * @description set the serialization of the event data
     *
     * @param doSerialize boolean
     */
    public void handlerToSerialize(Boolean doSerialize) {
        this.serializeEvent = doSerialize;
    } // end of handlerToSerialize
    /**
     * @description override to String to show contents
     * @return string of accc_DefaultPlatformEvent contents
     */
    public virtual override String toString() {

        return
            'accc_DefaultPlatformEvent\n' +
            '{' + '\n' +
            '   this.m_eventName               : ' + this.m_eventName + '\n' +
            '   this.m_exception               : ' + this.m_exception + '\n' +
            '   this.m_canLogSuccess           : ' + this.m_canLogSuccess + '\n' +
            '   this.m_canLogError             : ' + this.m_canLogError  + '\n' +
            '   this.m_serializeEvent          : ' + this.m_serializeEvent + '\n'  +
            '   this.m_isActive                : ' + this.m_isActive + '\n'  +
            '   this.m_canStore                : ' + this.m_canStore + '\n'  +
            '   this.m_allowRetryAfterException: ' + this.m_allowRetryAfterException + '\n'  +
            '   this.mEvtBatchSize             : ' + this.mEvtBatchSize + '\n'  +
            '}';
    } //  end of toString

    /////////////////////////////////////////////////////////////////////////
    // Public Properties
    /////////////////////////////////////////////////////////////////////////


    /**
     * @description Is the event Active
     */
    public Boolean isEventActive {
        get { return this.m_isActive;}
        set { this.m_isActive = value;}
    } // end of isEventActive
    /**
     * @description Is the event to be stored
     */
    public Boolean isEventToBeStored {
        get { return this.m_canStore;}
        set { this.m_canStore = value;}
    } // end of isEventToBeStored
    /**
     * @description Serialize the event(s)
     */
    public Boolean serializeEvent {
        get { return this.m_serializeEvent;}
        set { this.m_serializeEvent = value;}
    } // end of serializeEvent
    /**
     * @description Allow consumer to retry event after retryexception
     */
    public Boolean allowRetryAfterException {
        get { return this.m_allowRetryAfterException;}
        set { this.m_allowRetryAfterException = value;}
    } // end of allowRetryAfterException
    /**
     * @description Event name
     */
    public String eventName {
        get { return this.m_eventName;}
        set { this.m_eventName = value;}
    } // end of eventName

    /**
     * @description Exception
     */
    public Exception theException {
        get { return this.m_exception;}
        set { this.m_exception = value;}
    } // end of theException


    /**
     * @description collection of replay Ids of platform event
     */
    @TestVisible
    public List<String> replayIds {
        get { return this.m_replayIds;}
        protected set { this.m_replayIds = value;}
    } // end of replayIds

    /**
     * @description collection of operation Ids of individual platform events
     */
    @TestVisible
    public List<String> operationIds {
        get {
            // special test condition : this class does not use EventBus.publish when processing
            // so we simulate
            if ( accc_ApexConstants.UNIT_TEST_RUNNING
                 && DO_NOT_SET_CHECKPOINT==true ) {
                if (  this.m_opIds == null ) {
                    this.m_opIds  = new List<String>();
                }
                this.m_opIds.add(EXPECTED_REPLAY_ID_FOR_TESTING);
            }
            return this.m_opIds;
        }
        protected set { this.m_opIds = value;}
    } // end of operationIds

    /////////////////////////////////////////////////////////////////////////
    // Protected Properties
    /////////////////////////////////////////////////////////////////////////
    /**
     * @description getter/setter of the current database saveresults
     */
    protected List<Database.SaveResult> ourCurrentSaveResults {
        get;
        set;
    }// end of ourCurrentSaveResults
    /**
     * @description Retry Required
     */
    @TestVisible
    protected Boolean retryRequired {
        get { return this.m_retry;}
        set { this.m_retry = value;}
    } // end of retryRequired

    /**
     * @description Can we log on success
     */
    @TestVisible
    protected Boolean canLogSuccess {
        get { return this.m_canLogSuccess;}
        set { this.m_canLogSuccess = value;}
    } // end of canLogSuccess
    /**
     * @description Can we Log Information
     */
    @TestVisible
    protected Boolean canLog {
        get { return this.m_canLog;}
        set { this.m_canLog = value;}
    } // end of canLog
    /**
     * @description Can we Log Error Information
     */
    @TestVisible
    protected Boolean canLogError {
        get { return this.m_canLogError;}
        set { this.m_canLogError = value;}
    } // end of canLogError

    /**
     * @description Will instrument platform event
     */
    @TestVisible
    protected Boolean willInstrument {
        get { return this.m_willInstrument;}
        set { this.m_willInstrument = value;}
    } // end of willInstrument

    /**
     * @description platform event Batch Size
     */
    @TestVisible
    protected Integer eventBatchSize {
        get { return this.mEvtBatchSize;}
        set { this.mEvtBatchSize = value;}
    } // end of eventBatchSize


    /////////////////////////////////////////////////////////////////////////
    // Public Methods
    /////////////////////////////////////////////////////////////////////////

    /**
     * @description process the publish or subscription/consumer. Expected 'childProcess' to be overwritten
     *
     * @param parameter the events
     * @param handlers the handlers (log, error, success, alert)
     * @param attributes platform event attributes
     * @return true, if successful
     */
    public boolean process(List<SObject> parameter,
                           accc_IProcessEventHandlers handlers,
                           accc_PlatformEventAttrs attributes) {

        if ( parameter == null
             ||  parameter.size() == 0
             || handlers == null
             || attributes == null) {
            this.theException = new accc_PlatformEventException('accc_DefaultPlatformEvent.process requires valid data for all parameters [List<SObject>,accc_IProcessEventHandlers,accc_PlatformEventAttrs]');
            throw this.theException;
        }

        String parameterEventName =  accc_ApexUtilities.getSobjectName(parameter);
        Boolean childStatus = false,
                isEventBlank = String.isBlank(this.eventName),
                isParamEventName = String.isBlank(parameterEventName),
                processResult = true;

        accc_PlatformEventAttrs.EventLogging logStatus = attributes.loggingStatus();

        /*
         * Set our attributes for this events
         */
        this.willInstrument = attributes.instrumentation();
        this.allowRetryAfterException = attributes.allowRetryAfterException();
        this.isEventToBeStored = attributes.storeEvent();
        this.eventBatchSize = attributes.eventBatchSize();

        // NOTE, the user may change the event serialization via attributes!!
        this.serializeEvent = attributes.serializeData();
        this.canLogSuccess = logStatus == accc_PlatformEventAttrs.EventLogging.ON_SUCCESS
                             || logStatus == accc_PlatformEventAttrs.EventLogging.ALL;
        this.canLogError = logStatus == accc_PlatformEventAttrs.EventLogging.ON_ERROR
                           || logStatus == accc_PlatformEventAttrs.EventLogging.ALL;
        this.canLog = logStatus == accc_PlatformEventAttrs.EventLogging.ON_LOG
                      || logStatus == accc_PlatformEventAttrs.EventLogging.ALL;


        // ensure we have an event name (from one aspect)
        if ( isEventBlank &&  !isParamEventName ) {
            this.eventName = parameterEventName;
        }

        // check event name
        if (  isEventBlank == false
              &&  isParamEventName == false
              && !this.eventName.equalsIgnoreCase(parameterEventName))  {
            this.theException = new accc_PlatformEventException('accc_DefaultPlatformEvent.process: Exception, event Name (' + this.eventName + ') is not the same as the event parameter passed in (' + parameterEventName + ')');
            throw this.theException;
        }
        // is the event active, then call the child process
        if ( this.isEventActive ) {

            // now call child process (CHILDREN SHOULD OVERRIDE -- may make ABSTRACT to Force)
            processResult = this.childProcess(parameter, handlers, attributes);

        }
        return processResult;

    } // end of process


    /////////////////////////////////////////////////////////////////////////
    // Protected Methods
    /////////////////////////////////////////////////////////////////////////
    /**
     * @description set the replay ids. You can only set the replay Ids after you
     * have published the events!!
     *
     * @param event, event that has been Published
     * @return collection of Replay Ids (List<String>)
     */
    @TestVisible
    protected virtual List<String> setReplayIds(SObject event) {

        if ( this.replayIds == null ) {
            this.replayIds  = new List<String>();
        }

        String replayId = null;
        // event getting the replay id
        try {
            replayId = (String)event.get(REPLAY_ID_INDEX_NAME);
            if ( replayId != null ) {
                this.replayIds.add(replayId);
            } else if ( accc_ApexConstants.UNIT_TEST_RUNNING ) {
                /*********************************************************************
                 * START OF TESTING
                 */
                // when testing and we DO NOT use the trigger to insert
                // then the system did NOT process via the regular channel;
                // thus, NO REPLAY ID will be generated ( so we simulate it) :-(  )
                this.replayIds.add(EXPECTED_REPLAY_ID_FOR_TESTING);
                /*
                 * END OF TESTING
                 **********************************************************************/
            }

        } catch (Exception excp) {
            accc_ApexUtilities.log(excp);
            this.theException = excp;
            // this is may NOT be an event type ( ends in __e)
            // Not checking everytime
        }
        return this.replayIds;
    } // end of setReplayIds
    /**
     * @description set the replay ids. You can only set the replay Ids after you
     * have published the events!!
     *
     * @param events collection of events that have been Published
     * @return collection of Replay Ids (List<String>)
     */
    @TestVisible
    protected virtual List<String> setReplayIds(List<SObject> events) {

        // iterate over the events getting the replay ids
        // will check here to see if this is an Event type
        if ( events != null
             && accc_ApexUtilities.validEventName(accc_ApexUtilities.getSobjectName(events))
             )  {
            // iterate over the events getting the replay id
            for ( SObject sobj : events) {
                this.setReplayIds(sobj);
            }
        }
        return this.replayIds;

    }// end of setReplayIds

    /**
     * @description get the last replay id from the known list (if any)
     *
     * @param events collection of events that have been Published
     * @return last Replay Id (String)
     */
    @TestVisible
    protected virtual String getLastReplayId() {
        String result = null;
        // look at list and pull last one
        if ( this.replayIds != null )  {
            integer lastIndex = this.replayIds.size()-1;
            // ensure correctness
            if ( lastIndex >= 0 ) {
                result =this.replayIds.get(lastIndex);
            }
        }
        return result;

    }// end of getLastReplayId

    /**
     * @description update the last trigger event checkpoint
     *
     * @return Boolean returns true, if updated with valid replay id
     */
    @TestVisible
    protected virtual Boolean updateCheckPoint(){
        Boolean result = true;
        String lastReplayId = this.getLastReplayId();
        // valid data
        if ( string.isNotBlank(lastReplayId) ) {
            // set our new checkpoint
            // specal consideration for testing :-(  )
            if ( accc_ApexConstants.UNIT_TEST_RUNNING ) {
                /*********************************************************************
                 * START OF TESTING
                 */
                // user wants to set checkpoint
                if ( DO_NOT_SET_CHECKPOINT == false) {
                    // no need to fault all
                    result=this.setResumeCheckpoint(lastReplayId);
                }
                /*
                 * END OF TESTING
                 **********************************************************************/
            } else {
                result=this.setResumeCheckpoint(lastReplayId);
            }

        } else {
            result = false;
        }
        return result;
    } // end of updateCheckPoint

    /**
     * @description get the operation ids from the save result
     *
     * @param srx single save results
     * @return Operation Id or empty if not valid
     */
    @TestVisible
    protected String setOperationIds(Database.SaveResult srx) {
        String operationId = accc_ApexConstants.EmptyString;
        // is there a collection, if not create
        if (  this.operationIds == null ) {
            this.operationIds  = new List<String>();
        }
        try {
            // is there a save result to get the operation id from
            if ( srx != null) {
                operationId = System.EventBus.getOperationId(srx);
                this.operationIds.add(operationId);
            }
        } catch (Exception excp ) {
            this.theException = excp;
        }
        return operationId;
    } // end of setOperationIds
    /**
     * @description get the operation ids from the save result
     *
     * @param results collection of save results
     * @return collection of Operation Ids (List<String>; if null, there may have been an exception
     */
    @TestVisible
    protected List<String> setOperationIds(List<Database.SaveResult> results) {

        if ( results != null
             && results.size() > 0 ) {
            try {
                // reset the operations ids to ensure we are getting the
                // full list of results. As we do not know if the user first
                // called the 'operationIds' w/ just a single saved result
                this.operationIds = null;
                for (Database.SaveResult srx : results) {
                    this.setOperationIds(srx);
                }
            } catch (Exception excp ) {
                this.theException = excp;
                // reset to null, thus, the caller can retry.
                this.operationIds = null;
                // REPLACE as needed to log to custom object, etc.
                accc_Apexutilities.log(excp);
            }
        }

        return this.operationIds;
    } // end of setOperationIds
    /**
     * @description Normally called within a trigger handler, force a trigger handler to retry.
     */
    @TestVisible
    protected virtual void retryTriggerIfNecessary() {
        if ( this.retryRequired && this.allowRetryAfterException) {
            throw new EventBus.RetryableException('Condition is not met, so retrying the trigger again.');
        }
    } // end of retryTriggerIfNecessary
    /**
     * @description process the publish or subscription/consumer. Expected to be OVERRIDDEN!!
     *
     * @param parameter the events
     * @param handlers the handlers (log, error, success, alert)
     * @param attributes platform event attributes
     * @return true, if successful
     */
    @TestVisible
    protected virtual boolean childProcess(List<SObject> parameter,
                                           accc_IProcessEventHandlers handlers,
                                           accc_PlatformEventAttrs attributes) {
        return true;

    } // end of childProcess
    /**
     * @description invoke success,  can be overridden
     *
     * @param handler holds our process handlers
     * @param data data to process, 'List<PlatformEvtResultPOAC>'
     * @param attributes platform events attributes
     */
    @TestVisible
    protected virtual boolean logSuccess (accc_IProcessEventHandlers handler,
                                          List<PlatformEvtResultPOAC> data,
                                          accc_PlatformEventAttrs attributes ) {
        if ( handler != null && handler.successHandler() != null ) {
            return this.callHandler(handler.successHandler(), data, attributes);
        }
        return false;
    } // end of logSuccess
    /**
     * @description invoke error handler, can be overridden
     *
     * @param handler holds our process handlers
     * @param data data to process, 'List<PlatformEvtResultPOAC>'
     * @param attributes platform events attributes
     */
    @TestVisible
    protected virtual boolean  errorHandler (accc_IProcessEventHandlers handler,
                                             List<PlatformEvtResultPOAC> data,
                                             accc_PlatformEventAttrs attributes ) {
        if ( handler != null && handler.errorHandler() != null ) {
            return this.callHandler(handler.errorHandler(), data, attributes);
        }
        return false;
    } // end of errorHandler
    /**
     * @description invoke log handler , can be overridden
     *
     * @param handler holds our process handlers
     * @param data data to process, 'List<PlatformEvtResultPOAC>'
     * @param attributes platform events attributes
     */
    @TestVisible
    protected virtual boolean logHandler (accc_IProcessEventHandlers handler,
                                          List<PlatformEvtResultPOAC> data,
                                          accc_PlatformEventAttrs attributes ) {
        if ( handler != null && handler.logHandler() != null ) {
            return this.callHandler(handler.logHandler(), data, attributes);
        }
        return false;
    } // end of logHandler

    /**
     * @description invoke alert/notifications , can be overridden
     *
     * @param handler holds our process handlers
     * @param data data to process, 'List<PlatformEvtResultPOAC>'
     * @param attributes platform events attributes
     */
    @TestVisible
    protected virtual boolean alertHandler (accc_IProcessEventHandlers handler,
                                            List<PlatformEvtResultPOAC> data,
                                            accc_PlatformEventAttrs attributes ) {
        if ( handler != null && handler.alertHandler() != null ) {
            return this.callHandler(handler.alertHandler(), data, attributes);
        }
        return false;
    } // end of alertHandler
    /**
     * @description invoke storing of event informatio
     *
     * @param handler holds our process handlers
     * @param data data to process, 'List<PlatformEvtResultPOAC>'
     * @param attributes platform events attributes
     */
    @TestVisible
    protected virtual boolean storeHandler (accc_IProcessEventHandlers handler,
                                            List<PlatformEvtResultPOAC> data,
                                            accc_PlatformEventAttrs attributes ) {
        if ( handler != null && handler.storeHandler() != null ) {
            return this.callHandler(handler.storeHandler(), data, attributes);
        }
        return false;
    } // end of storeHandler

    /**
     * @description write alert messages
     *
     * @param canAdd can the alert
     * @param data item in the list
     * @param theLogData the log information
     */
    @TestVisible
    protected virtual void addInstrumentation(Boolean canAdd
                                              , accc_DefaultPlatformEvent.PlatformEvtResultPOAC data
                                              , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData
                                              ) {

        if ( canAdd
             && data != null
             && theLogData != null) {
            theLogData.add(data);
        }
    } // end of addInstrumentation

    /**
     * @description call the handler. Values are already check for validity, we also ensure no exception
     * bubbles up -- the callee MUST HANDLE exceptions
     *
     * @param handler holds our process handlers
     * @param data data to process, 'List<PlatformEvtResultPOAC>'
     * @param attributes platform events attributes
     */
    @TestVisible
    protected virtual boolean callHandler (accc_IProcessEventHandler handler,
                                           List<PlatformEvtResultPOAC> data,
                                           accc_PlatformEventAttrs attributes ) {
        boolean result = handler != null;
        try {
            // simple check to ensure handler is not null; no need to THROW when
            // a simple check will do
            if ( result ) {
                handler.process(data, attributes);
            }
        } catch (Exception excp) {
            this.theException = excp;
            result = false;
            // REPLACE as needed to log to custom object, etc.
            accc_ApexUtilities.log(excp);
        }
        return result;
    } // end of callHandler
    /**
     * @description allow children to send data and send out alert
     *
     * @param handler holds our process handlers
     * @param theList data to process, 'List<PlatformEvtResultPOAC>'
     * @param data the data , PlatformEvtResultPOAC
     * @param attributes platform events attributes
     *
     * @return status of result of alert
     */
    @TestVisible
    protected virtual boolean alertAddAndSend(accc_IProcessEventHandlers handler,
                                              PlatformEvtResultPOAC data,
                                              List<PlatformEvtResultPOAC> theList,
                                              accc_PlatformEventAttrs attributes ) {
        // any work to perform
        if ( handler == null
             || data == null
             || theList == null) {
            return false;
        }
        // add data
        theList.add(data);
        // forward to alert handler
        return this.alertHandler(handler, theList, attributes);
    } // end of alertAddAndSend
    /**
     * @description serialize the collection of events
     *
     * @param collectionOfEvents colleciton of SObjects (i.e. __e)
     * @return JSON string of the event collection
     */
    @TestVisible
    protected virtual String serializeEventData(List<PlatformEvtResultPOAC> theList,
                                                List<SObject> collectionOfEvents) {
        String result = accc_ApexConstants.EMPTY_JSON_s;

        // just in case the serialization throws an exception
        try {

            // if the user wants to serialize
            if ( this.serializeEvent &&
                 collectionOfEvents != null &&
                 collectionOfEvents.size() > 0 ) {
                integer count = collectionOfEvents.size();

                // storage available and valid event name
                if (  theList != null && !string.isBlank(this.eventName)) {
                    result = JSON.serialize(collectionOfEvents);
                    // add data for auditing/logging
                    theList.add(new PlatformEvtResultPOAC(this.eventName,
                                                          result == null ? accc_ApexConstants.EMPTY_JSON_s : result,
                                                          (Object)count));
                }
            }
        } catch (Exception excp) {
            this.theException = excp;
        }
        return result;
    } // end of serializeEventData

    /**
     * @description record the operation and replay ids
     *
     * @param theData , place to store operation and replay ids
     *
     */
    @TestVisible
    protected virtual void recordOperationAndReplayIds(List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theData) {

        if ( theData != null ) {
            // look for the event name and add information there
            for ( accc_DefaultPlatformEvent.PlatformEvtResultPOAC item : theData ) {
                if ( item.Name == this.eventName) {
                    // if there are operation ids
                    if ( this.operationIds != null ) {
                        item.operationIds = this.operationIds.clone();
                    }
                    // if there are replay ids
                    if ( this.replayIds != null ) {
                        item.replayIds = this.replayIds.clone();
                    }
                    break;
                }
            }
        }
    }    // end of recordOperationAndReplayIds

    /**
     * @description perform the set resume checkpoint
     * @param lastReplayId last replay id
     * @return boolean true, if successful, otherwise false (supplied Replay ID is not valid—the replay ID)
     **/
    protected virtual Boolean setResumeCheckpoint(String lastReplayId){
        Boolean didFault = false;
        /* we can get a fault....The method throws an EventBus.InvalidReplayIdException if
         * the supplied Replay ID is not valid—the replay ID isn’t in the current trigger batch of
         * events in the Trigger.new list .
         */
        try {
            EventBus.TriggerContext.currentContext().setResumeCheckpoint(lastReplayId);
        } catch (Exception excp) {
            didFault = true;
            this.theException = excp;
            accc_ApexUtilities.log(excp);
        }
        return didFault;
    }// end of setResumeCheckpoint
} // end of accc_DefaultPlatformEvent