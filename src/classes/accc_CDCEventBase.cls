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
 * @description Provides a base class for handling/encapsulating PE & CDC functionality. It
 * already uses the interface defined here 'accc_ITriggerHandler' which provides
 * 'onAfterInsertChild' method.
 *
 * In order to support both PE and CDC, the following is best:
 *
 * For Platform Events, all you need to do is override the afterInsert method (look at 'accc_LogEventHandler').
 * However, Platform Events should just inherit from accc_EventBase.
 *                 // for example
 *                 public override void onAfterInsertChild(List<SObject> newItems) { }
 *
 * For CDC Events, there is a plethora of mechanisms available to you:
 *             1) If you override 'onAfterInsertChild' (as for PE) then you control everything.
 *                You can would inherit from this class; You may want to override onAfterInsertChild 
 *             2)
 *
 * @group CDC
 **/
public virtual with sharing class accc_CDCEventBase  extends accc_EventBase  {

    //==============================================================
    // Data members
    //==============================================================
        //==============================================================
    // Our known Change Types
    //==============================================================
    public static final String CDC_CREATE_CHANGE_TYPE = 'CREATE';
    public static final String CDC_UPDATE_CHANGE_TYPE = 'UPDATE';
    public static final String CDC_DELETE_CHANGE_TYPE = 'DELETE';
    public static final String CDC_UNDELETE_CHANGE_TYPE = 'UNDELETE';
    public static final String CDC_GAPCREATE_CHANGE_TYPE = 'GAP_CREATE';
    public static final String CDC_GAPUPDATE_CHANGE_TYPE = 'GAP_UPDATE';
    public static final String CDC_GAPDELETE_CHANGE_TYPE = 'GAP_DELETE';
    public static final String CDC_GAPUNDELETE_CHANGE_TYPE = 'GAP_UNDELETE';
    // container of ALL Known Change Types
    public static final List<String> CDC_KNOWN_CHANGE_TYPES = new List<String> {
        CDC_CREATE_CHANGE_TYPE ,
        CDC_UPDATE_CHANGE_TYPE ,
        CDC_DELETE_CHANGE_TYPE ,
        CDC_UNDELETE_CHANGE_TYPE,
        CDC_GAPCREATE_CHANGE_TYPE,
        CDC_GAPUPDATE_CHANGE_TYPE,
        CDC_GAPDELETE_CHANGE_TYPE,
        CDC_GAPUNDELETE_CHANGE_TYPE
    };  
    @TestVisible
    static final String FOR_TEST_CHANGE_ORIGIN_NAME = 'com/salesforce/api/soap/46.0;client=Astro';
    /*
     * @description Header information on the event
     */
    @TestVisible
    private EventBus.ChangeEventHeader mHeader= null;
    //==============================================================
    // Ctors
    //==============================================================
    /**
     * @description accc_CDCEventBase default ctor
     *
     */
    public accc_CDCEventBase() {
        super();
    }// end of ctor
    /**
     * @description accc_CDCEventBase default ctor
     * @param incoming collection of SObject
     */
    public accc_CDCEventBase(List<SObject> incoming) {
        super(incoming);
    }// end of ctor
     /**
     * @description accc_CDCEventBase default ctor
     * @param the type of event
     */
    public accc_CDCEventBase(Type theType) {
        super(theType);
    }// end of ctor
     /**
     * @description accc_CDCEventBase default ctor
     * @param incoming collection of SObject
     */
    public accc_CDCEventBase(List<SObject> incoming, Type theType) {
        super(incoming, theType);
    }// end of ctor
    
    //==============================================================
    // Properties
    //==============================================================
    
 
    //==============================================================
    // Public Methods
    //==============================================================
    /**
     * @description Capture changed events -- only supports after insert
     *
     * @param List<SObject> list of new sobjects
     */
    public virtual override void onAfterInsertChild(List<SObject> newItems) {
        // we do this to ensure the header is set (at least once);
        // Normally, this will already be set; but if we are testing [non-trigger] 
        // it provides more robustness :-)
        // any work; could be testing
        if ( newItems == null ){
            return;
        }
        
        this.records(newItems);

        try {
            
            // iterate over the events
            for (SObject event : super.records() ) {
                // determine the header information of event
                this.header(this.getHeaderByType(event));
                // sanity check
                if ( this.header() == null ) {
                    accc_ApexUtilities.log('WARNING: Unable to determine event (' + event + ')');
                    continue;
                }
                // go handle the event
                this.handleEventMethod(event);
            }
        } catch (Exception excp){
            super.processException = excp;
            accc_ApexUtilities.log(excp);
        }
    } // end of onAfterInsertChild

        
    /**
    * @description getter of the CDC Header
    * @author Bill Anderson 
    * @return EventBus.ChangeEventHeader
    */
    @TestVisible
    public virtual EventBus.ChangeEventHeader header() {
      
        // do this if we have no header and we can discern from the records
        if ( this.mHeader == null && 
            (this.records() != null || this.eventType != null )
            ) {
            if ( this.eventType == null ){
                 this.eventType= accc_ApexUtilities.getTypeFromSObject(this.records());
            }
            this.header((EventBus.ChangeEventHeader) this.getHeaderByType(this.eventType) );
        }
        return this.mHeader;
    } // end of header
     /**
     * @description get the CDC Header Name
     */
    public String entityName() {
         return  this.header() != null ? this.header().entityName : UNKNOWN_HEADER_INFO;   
    }// end of entityName
    /**
     * @description get the CDC Operation (i.e. CREATE, UPDATE, etc.)
     */
    public String changeType() {
         return this.header() != null ?  this.header().changeType : UNKNOWN_HEADER_INFO;   
    }// end of changeType
    /**
     * @description get Only populated for changes done by API apps or from Lightning 
     * Experience; empty otherwise. The Salesforce API and the API client ID that initiated the change, 
     * if set by the client. Use this field to detect whether your app initiated the change to not process 
     * the change again and potentially avoid a deep cycle of changes.
     */
    public String changeOrigin() {
         return this.header() != null ?  this.header().getChangeOrigin() : UNKNOWN_HEADER_INFO;    
    }// end of changeOrigin
    /**
     * @description  get he system change number (SCN) of a committed transaction, 
     * which increases sequentially. This field is provided for diagnostic purposes. 
     * The field value is not guaranteed to be unique
     */
    public Long commitNumber() {
         return this.header() != null ?  this.header().getCommitNumber() : UNKNOWN_HEADER_VALUE_INFO;    
    }// end of commitNumber
    /**
     * @description  get the CDC committing date/time
     */
    public Datetime commitTimestamp() {
        return this.header() != null ?  DateTime.newInstance(this.header().getCommitTimestamp()) : Datetime.now();
    }// end of commitTimestamp
    /**
     * @description  get the ID of the user that ran the change operation.
     */
    public String commitUser() {
        return this.header() != null ?  this.header().getCommitUser() : UNKNOWN_INFO;   
    }// end of commitUser
    /**
     * @description A string that uniquely identifies each Salesforce transaction. 
     *  You can use this key to identify and group all changes that were made in the same transaction.
     */
    public String transactionKey() {
        return this.header() != null ?  this.header().getTransactionKey() :UNKNOWN_INFO;   
    }// end of transactionKey
     
    /**
     * @description One or more record IDs for the changed records. Typically, this field contains one 
     * record ID. But if the same change occurred in multiple records of the same object type during the 
     * same transaction, Salesforce groups the change notifications and sends one change event for all affected records. 
     * In this case, the recordIds field contains an array of record IDs for all records that have the same change.
     */
    public List<String> recordIds() {
        return this.header() != null ?  this.header().getRecordIds() : new  List<String>();  
    }// end of recordIds   

    /**
    * @description get the header event information
    * @author Bill Anderson 
    * @return EventBus.ChangeEventHeader
    */
    public EventBus.ChangeEventHeader  getHeaderByType(){
        return this.getHeaderByType(accc_ApexUtilities.getTypeFromSObject(this.records()));
    } // end of getHeaderByType
   
    //==============================================================
    // Protected Methods 
    //==============================================================

    /**
    * @description set the header for CDC
    * @author Bill Anderson 
    * @param EventBus.ChangeEventHeader value
    * @return void
    */
    @TestVisible
    protected void header(EventBus.ChangeEventHeader value) {
        this.mHeader=value;
    }// end of header
      /**
    * @description get the event header from the sobject
    * @author Bill Anderson 
    * @param SObject recordType
    * @return EventBus.ChangeEventHeader
    */
    @TestVisible
    protected virtual EventBus.ChangeEventHeader  getHeaderByType(SObject record){
        return this.getHeaderByType(accc_ApexUtilities.getTypeFromSObject(record));
    } // end of getHeaderByType
    /**
    * @description get the event header from the type ( this is UGLY!!)
    * @author Bill Anderson 
    * @param Type recordType
    * @return EventBus.ChangeEventHeader
    */
    @TestVisible
    protected virtual EventBus.ChangeEventHeader  getHeaderByType(Type recordType){
        EventBus.ChangeEventHeader  result=null;
       
        // so that we may test w/o a trigger
        if ( recordType != null ) { 
            List<SObject> recordList = this.records();
            if ( recordList != null && recordList.size() > 0 ) {
                SObject event=recordList[0];
                
                if ( recordType == AccountChangeEvent.class) {
                    result =  ((AccountChangeEvent)event).ChangeEventHeader;
                } else  if ( recordType == ContactChangeEvent.class) {
                    result=  ((ContactChangeEvent)event).ChangeEventHeader;  
                    // NOTE: Lead is NOT yet available   
                } else  if ( recordType == LeadChangeEvent.class) {
                    result=  ((LeadChangeEvent)event).ChangeEventHeader; 
                } else  if ( recordType == CaseChangeEvent.class) {
                    result=  ((CaseChangeEvent)event).ChangeEventHeader;   
                } else {
                    // call child to get the change header based on the type
                    // This is THE METHOD CHILDREN SHOULD OVERRIDE (may change to ABSTRACT)
                    result= this.getChildHeaderByType(recordType);
                }
            }
        }
        // TESTING ONLY!
        //
        // for testing we create the changeeventheader
        //
        if ( Test.isRunningTest() 
            && result == null 
            && ( recordType == AccountChangeEvent.class
                || recordType == ContactChangeEvent.class
                || recordType == CaseChangeEvent.class
                || recordType == LeadChangeEvent.class
                )
            ){
           result=accc_CDCEventBase.getChangeEventHeaderForTesting();
        }
        return result;
    } // end of getHeaderByType

    /**
    * Note -- Normally, I would have made this 
    * @description let the child get me the ChangeEventHeader as I have limited scope 
    * @author Bill Anderson 
    * @param Type recordType
    * @return EventBus.ChangeEventHeader
    */
    @TestVisible
    protected virtual EventBus.ChangeEventHeader  getChildHeaderByType(Type recordType){
        return null;
    } // end of getChildHeaderByType

    /**
    * @description Determine which handler to call for the event on the SObject event
    * @author Bill Anderson 
    * @return Boolean, true is change type was found and handler called
    */
    @TestVisible
    protected virtual Boolean  handleEventMethod(SObject event){
        String action = this.changeType();
        Boolean handled = true;
  
        try
        {
            if ( CDC_CREATE_CHANGE_TYPE.equalsIgnoreCase(action)) {
                this.handleCreate(event);
            } else  if (CDC_UPDATE_CHANGE_TYPE.equalsIgnoreCase(action)) {
                this.handleUpdate(event);  
            } else  if ( CDC_DELETE_CHANGE_TYPE.equalsIgnoreCase(action) ) {
                this.handleDelete(event); 
            } else  if ( CDC_UNDELETE_CHANGE_TYPE.equalsIgnoreCase(action) ) {
                this.handleUnDelete(event);  
            } else if ( CDC_GAPCREATE_CHANGE_TYPE.equalsIgnoreCase(action)) {
                this.handleGAPCreate(event);   
            } else  if (CDC_GAPUPDATE_CHANGE_TYPE.equalsIgnoreCase(action)) {
                this.handleGAPUpdate(event);  
            } else  if ( CDC_GAPDELETE_CHANGE_TYPE.equalsIgnoreCase(action) ) {
            this.handleGAPDelete(event); 
            } else  if ( CDC_GAPUNDELETE_CHANGE_TYPE.equalsIgnoreCase(action) ) {
                this.handleGAPUndelete(event);   
            } else {
                throw new accc_ApexApplicationException('accc_CDCEventBase :"changeType" is Not Known; check incoming typew or records');
            }
        } catch (Exception excp){
            super.processException = excp;
            handled = false;
            accc_ApexUtilities.log(excp);
        }
        return handled;
    } // end of handleEventMethod

    ////////////////////////////////////////////////////////////////////////////////////////
    //
    // Methods below are overwritable. These methods get called when a specific handler is
    // required for Create, Update, Delete or UnDelete action.
    ////////////////////////////////////////////////////////////////////////////////////////
    /**
    * @description child handle update
    * @author Bill Anderson 
    * @param SObject event
    * @return void
    */
    @TestVisible
    protected virtual void handleUpdate(SObject event){
         accc_ApexUtilities.log('handleUpdate: event=' +event);
    } // end of handleUpdate

    /**
     * @description child handle create
     * @author Bill Anderson 
     * @param SObject event
     * @return void
     */
    @TestVisible
    protected virtual void handleCreate(SObject event){
        accc_ApexUtilities.log('handleCreate: event=' +event);
    } // end of handleCreate

    /**
    * @description child to handle delete
    * @author Bill Anderson 
    * @param SObject event
    * @return void
    */
    @TestVisible
    protected virtual void handleDelete(SObject event){
        accc_ApexUtilities.log('handleDelete: event=' +event);
    } // end of handleDelete

    /**
    * @description child handle undelete
    * @author Bill Anderson 
    * @param SObject event
    * @return void
    */
    @TestVisible
    protected virtual void handleUndelete(SObject event){
        accc_ApexUtilities.log('handleUndelete: event=' +event);
    } // end of handleUndelete
   
   /**
    * @description child handle GAP update
    * @author Bill Anderson 
    * @param SObject event
    * @return void
    */
    @TestVisible
    protected virtual void handleGAPUpdate(SObject event){
        accc_ApexUtilities.log('handleGAPUpdate: event=' +event);
    } // end of handleGAPUpdate

    /**
     * @description child handle GAP create
     * @author Bill Anderson 
     * @param SObject event
     * @return void
     */
     @TestVisible
     protected virtual void handleGAPCreate(SObject event){
          accc_ApexUtilities.log('handleGAPCreate: event=' +event);
    } // end of handleGAPCreate

    /**
    * @description child to handle GAP delete
    * @author Bill Anderson 
    * @param SObject event
    * @return void
    */
    @TestVisible
    protected virtual void handleGAPDelete(SObject event){
         accc_ApexUtilities.log('handleGAPDelete: event=' +event);
    } // end of handleGAPDelete

    /**
    * @description child handle GAP undelete
    * @author Bill Anderson 
    * @param SObject event
    * @return void
    */
    @TestVisible
    protected virtual void handleGAPUndelete(SObject event){
         accc_ApexUtilities.log('handleGAPUndelete: event=' +event);
    } // end of handleGAPUndelete
         
    //==============================================================
    // Private Methods 
    //==============================================================
    @TestVisible
    private static EventBus.ChangeEventHeader  getChangeEventHeaderForTesting (){
        EventBus.ChangeEventHeader result=null;
        if ( Test.isRunningTest() ){
            result = new EventBus.ChangeEventHeader();
            result.changeOrigin = FOR_TEST_CHANGE_ORIGIN_NAME;
            result.changeType = CDC_CREATE_CHANGE_TYPE;
            result.commitnumber = 1;
            result.committimestamp = DateTime.now().getTime();
            result.commituser = UserInfo.getUserId();
            result.entityname = 'Account';
            result.recordids = new List<String> {
                '001000200000001',
                '001000200000002'
            };
            result.sequencenumber = 1;
            result.transactionkey = accc_ApexUtilities.newGuid();
        }
        return result;
    }// end of getChangeEventHeaderForTesting
 } // end of accc_CDCEventBase