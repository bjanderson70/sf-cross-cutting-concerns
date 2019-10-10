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
 * For Platform Events, all you need to do is override the onAfterInsertChild method (look at 'accc_LogEventHandler')
 *                 // for example
 *                 public override void onAfterInsertChildrInsert(List<SObject> newItems) { }
 *
 * For CDC Events, there is a plethora of mechanisms available to you:
 *             1) If you override 'onAfterInsertChildrInsert' (as for PE) then you control everything.
 *                You can look at 'accc_EventBase' onAfterInsertChildrInsert for items to help
 *             2) Inherit from  CDCEventBase for CDC events as it takes care of a lot plumbing
 *
 * @group Common Layer
 **/
public virtual with sharing class accc_EventBase  extends accc_TriggerHandlerBase  {

    //==============================================================
    // Data members
    //==============================================================
    public static final String UNKNOWN_HEADER_INFO = 'Header NOT initialized';
    public static final String UNKNOWN_INFO = 'Unknown';
    public static final Long UNKNOWN_HEADER_VALUE_INFO = -1;

     /*
     * @description Type of event
     */  
    @TestVisible
    private Type mTypeOfEvent;
 
    /*
     * @description Keep a local reference in order to help on testing
     */
    @TestVisible
    private List<SObject> mRecords = null;

    //==============================================================
    // Ctors
    //==============================================================
    /**
     * @description accc_EventBase default ctor
     *
     */
    public accc_EventBase() {
        // note, 'Trigger.New' can be Null if called from a non-trigger (i.e. testing)
        this(Trigger.New,null);
    }// end of ctor
    /**
     * @description accc_EventBase  ctor
     * @param incoming collection of SObject
     */
    public accc_EventBase(List<SObject> incoming) {
        this(incoming,null);
    }// end of ctor
    /**
     * @description accc_EventBase  ctor
     *
     */
    public accc_EventBase(Type theType) {
        // note, 'Trigger.New' can be Null if called from a non-trigger (i.e. testing)
        this(Trigger.New,theType);
    }// end of ctor
    /**
     * @description accc_EventBase  ctor
     * @param incoming collection of SObject
     * @param event Type
     */
    public accc_EventBase(List<SObject> incoming, Type theEventType) {
        this.records(incoming);
        if ( theEventType == null ){
            theEventType=accc_ApexUtilities.getTypeFromSObject(incoming);
        }
        this.eventType = theEventType;
        this.processException = null;
    }// end of ctor

    //==============================================================
    // Public Properties
    //==============================================================
    /**
    * @description getter/setter for the Type of Event
    * @return Type
    */
    @TestVisible
    public Type eventType {
        get;
        protected set;
    } // end of eventType
      /**
    * @description getter/setter for the Type of Event
    * @author Bill Anderson 
    * @return Type
    */
    @TestVisible
    public Exception processException {
        get;
        protected set;
    } // end of processException
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
        this.records(newItems);
    } // end of onAfterInsertChild

    /**
    * @description get the trigger records (trigger.new)
    * @author Bill Anderson 
    * @return List<SObject> 
    */
    public List<SObject> records() {
        // note, 'Trigger.New' can be Null if called from a non-trigger (i.e. testing)
         return this.mRecords==null ? Trigger.New : this.mRecords; 
    }// end of records
    //==============================================================
    // Protected Methods
    //==============================================================
 
    /**
    * @description setter of sobject records
    * @author Bill Anderson 
    * @param List<SObject> value
    * @return void
    */
    @TestVisible
    protected void records(List<SObject>  value){
        this.mRecords = value;
    }// end of records
   
    //==============================================================
    // Private Methods 
    //==============================================================

 } // end of accc_EventBase