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
 * @description Test CDC functionality.
 *
 * @group Test Layer
 **/
@isTest
private class accc_CDCEventBaseTest {

    // Used for testing
    public with sharing class myCDCEventTestClass extends accc_CDCEventBase {
        @TestVisible
        Boolean afterCalled = false;
        @TestVisible
        Integer numOfItems = 0;
        @TestVisible
        Boolean useParent = false;
        @TestVisible
        Boolean handleEventMethodResult=false;
        @TestVisible
        Boolean causeHandleEventMethodException=false;

        public myCDCEventTestClass(List<SObject> incoming, Type theEventType){
            super(incoming,theEventType);
        }
        public override void onAfterInsertChild(List<SObject> newItems) {
            this.afterCalled=true;
            this.numOfItems = newItems == null ? 0 : newItems.size();
            super.onAfterInsertChild(newItems);
        }
        protected override Boolean  handleEventMethod(SObject event){
            this.handleEventMethodResult = true;
            if ( this.useParent) {
                handleEventMethodResult= super.handleEventMethod(event);
            } else if ( this.causeHandleEventMethodException == true) {
                handleEventMethodResult= super.handleEventMethod(event);
            }
            return this.handleEventMethodResult;
        }
    }

    @isTest
    static void testaccc_CDCEventBaseDefaultCtor(){
        // arrange / act
        accc_CDCEventBase ctor = new accc_CDCEventBase();
        // assert
        system.assertEquals(true, ctor != null);
        system.assertEquals(true, ctor.records()==null);
        system.assertEquals(true, ctor.eventType==null);
    }
    @isTest
    static void testaccc_CDCEventBaseCtorWithType(){
        // arrange / act
        Type theExpectedType = AccountChangeEvent.class;
        accc_CDCEventBase ctor = new accc_CDCEventBase(theExpectedType);
        // assert
        system.assertEquals(true, ctor != null);
        system.assertEquals(true, ctor.records()==null);
        system.assertEquals(true, ctor.eventType==theExpectedType);
    }
    @isTest
    static void testaccc_CDCEventBaseCtorWithRecords(){
        // arrange / act
        Type theExpectedType = AccountChangeEvent.class;
        List<AccountChangeEvent > theRecords = new List<AccountChangeEvent > {
            new AccountChangeEvent (),
            new AccountChangeEvent ()
        };
        accc_CDCEventBase ctor = new accc_CDCEventBase(theRecords);
        // assert
        system.assertEquals(true, ctor != null);
        system.assertEquals(true, ctor.records().size()==theRecords.size());
        system.assertEquals(true, ctor.eventType==theExpectedType);
    }
    @isTest
    static void testaccc_CDCEventBaseCtorWithRecordsAndType(){
        // arrange / act
        Type theExpectedType = AccountChangeEvent.class;
        List<AccountChangeEvent > theRecords = new List<AccountChangeEvent > {
            new AccountChangeEvent (),
            new AccountChangeEvent ()
        };
        accc_CDCEventBase ctor = new accc_CDCEventBase(theRecords,theExpectedType);
        // assert
        system.assertEquals(true, ctor != null);
        system.assertEquals(true, ctor.records().size()==theRecords.size());
        system.assertEquals(true, ctor.eventType==theExpectedType);
    }
    @isTest
    static void testaccc_CDCEventBaseOnAfter(){
        // arrange / act
        Type theExpectedType = AccountChangeEvent.class;
        List<AccountChangeEvent > theRecords = new List<AccountChangeEvent > {
            new AccountChangeEvent (),
            new AccountChangeEvent ()
        };
        myCDCEventTestClass ctor = new myCDCEventTestClass(theRecords,theExpectedType);

        // assert
        system.assertEquals(true, ctor != null);
        system.assertEquals(true, ctor.records().size()==theRecords.size());
        system.assertEquals(true, ctor.eventType==theExpectedType);
        system.assertEquals(false, ctor.afterCalled);
        system.assertEquals(true, ctor.numOfItems==0);
        // act
        ctor.onAfterInsertChild(theRecords);
        // assert
        system.assertEquals(true, ctor.afterCalled);
        system.assertEquals(true, ctor.numOfItems==theRecords.size());
        // act
        ctor.onAfterInsertChild(null);
        system.assertEquals(0, ctor.numOfItems);
    }
    @isTest
    static void testaccc_CDCEventBaseCauseExceptionOnAfter(){
        // arrange / act
        Type theExpectedType = AccountChangeEvent.class;
        List<AccountChangeEvent > theRecords = new List<AccountChangeEvent > {
            new AccountChangeEvent (),
            new AccountChangeEvent ()
        };
        myCDCEventTestClass ctor = new myCDCEventTestClass(theRecords,theExpectedType);
        accc_CDCEventBase.forceExceptionInUnitTest=true;
        // assert before
        system.assertEquals(true, ctor.processException == null);
        // act
        ctor.onAfterInsertChild(theRecords);
        // assert after
        system.assertEquals(true, ctor.afterCalled);
        system.assertEquals(true, ctor.processException!= null);

    }

    @isTest
    static void testaccc_CDCEventBaseHeader(){
        // arrange / act
        Type theExpectedType = AccountChangeEvent.class,
             processingType = Account.class;

        List<AccountChangeEvent > theRecords = new List<AccountChangeEvent > {
            new AccountChangeEvent (),
            new AccountChangeEvent ()
        };
        accc_CDCEventBase ctor = new accc_CDCEventBase(theRecords,theExpectedType);
        EventBus.ChangeEventHeader header = ctor.header();
        // assert
        system.assertEquals(true, header != null);
        system.assertEquals(true, ctor.entityName()==processingType.getName());
        system.assertEquals(true, ctor.changeType()==accc_CDCEventBase.CDC_CREATE_CHANGE_TYPE);
        system.assertEquals(true, ctor.changeOrigin()==accc_CDCEventBase.FOR_TEST_CHANGE_ORIGIN_NAME);
        system.assertEquals(true, ctor.commitnumber()==1);
        system.assertEquals(true, ctor.committimestamp().month() == DateTime.now().month());
        system.assertEquals(true, ctor.commituser()==UserInfo.getUserId());
        system.assertEquals(true, ctor.transactionkey()!= null);
        system.assertEquals(true, ctor.recordids().size() >= 1);

    }

    @isTest
    static void testaccc_CDCEventBaseOnAfterAndMethods(){

        // arrange / act
        Type theExpectedType = AccountChangeEvent.class;
        List<AccountChangeEvent > theRecords = new List<AccountChangeEvent > {
            new AccountChangeEvent (),
            new AccountChangeEvent ()
        };
        myCDCEventTestClass ctor = new myCDCEventTestClass(theRecords,theExpectedType);
        EventBus.ChangeEventHeader header = ctor.header();
        // assert
        system.assertEquals(true, header != null);
        system.assertEquals(true, ctor != null);
        system.assertEquals(true, ctor.records().size()==theRecords.size());
        system.assertEquals(true, ctor.eventType==theExpectedType);
        system.assertEquals(false, ctor.afterCalled);
        system.assertEquals(true, ctor.numOfItems==0);
        system.assertEquals(true,ctor.getHeaderByType()!=null);

        // act
        ctor.onAfterInsertChild(theRecords);
        // assert
        system.assertEquals(true, ctor.afterCalled);
        system.assertEquals(true, ctor.numOfItems==theRecords.size());
        system.assertEquals(true, ctor.handleEventMethodResult);

        // +act
        ctor.useParent = true;
        ctor.onAfterInsertChild(theRecords);
        // assert
        system.assertEquals(true, ctor.handleEventMethodResult);
        system.assertEquals(true, accc_ApexUtilities.containsInTestLog('handleCreate'));
        system.assertEquals(true, ctor.processException == null);
    }

    @isTest
    static void testhandleEventMethodBadData(){

        // arrange
        accc_CDCEventBase basector = new accc_CDCEventBase();
        // act
        Boolean result = basector.handleEventMethod(null);

        // assert
        system.assertEquals(false, result);
        system.assertEquals(true, basector.processException != null);
    }

    @isTest
    static void testafterOnAfterInsertChild() {
        // arrange
        accc_CDCEventBase basector = new accc_CDCEventBase();
        // act
        basector.afterOnAfterInsertChild();
        // assert
        system.assertEquals(true, accc_ApexUtilities.containsInTestLog(accc_CDCEventBase.FOR_TEST_AFTER_CHILD));
    }
    @isTest
    static void testbeforeOnAfterInsertChild() {
        // arrange
        accc_CDCEventBase basector = new accc_CDCEventBase();
        // act
        basector.beforeOnAfterInsertChild();
        // assert
        system.assertEquals(true, accc_ApexUtilities.containsInTestLog(accc_CDCEventBase.FOR_TEST_BEFORE_CHILD));
    }
    @isTest
    static void testgetHeaderByType(){

        // arrange

        // known types
        Map<Type,Boolean> types = new  Map<Type,Boolean>  {
            AccountChangeEvent.class=>true,
            ContactChangeEvent.class=>true,
            LeadChangeEvent.class=>true,
            CaseChangeEvent.class=>true,
            Account.class=>false,
            Contact.class=>false
        };
        Map<Type,SObject > theRecords = new Map<Type,SObject > {
            AccountChangeEvent.class=>new AccountChangeEvent (),
            ContactChangeEvent.class=>new ContactChangeEvent (),
            LeadChangeEvent.class=>new LeadChangeEvent(),
            CaseChangeEvent.class=>new CaseChangeEvent(),
            Account.class=>new Account(),
            Contact.class=>new Contact()
        };
        accc_CDCEventBase basector = new accc_CDCEventBase();
        Integer count=0;
        // act
        for ( Type cdcType: types.keySet()) {
            // act
            Object result = basector.getHeaderByType(cdcType,theRecords.get(cdcType));
            Boolean expectedResult=result != null;

            if ( types.get(cdcType) == false ) {
                expectedResult = result == null;
            }
            // assert
            system.assertEquals(true,expectedResult );
        }
    }

    @isTest
    static void testhandleEventMethodWithAllVariations(){

        // arrange

        // known types
        Map<Type,Boolean> types = new  Map<Type,Boolean>  {
            AccountChangeEvent.class=>false,
            ContactChangeEvent.class=>false,
            LeadChangeEvent.class=>false,
            CaseChangeEvent.class=>false,
            Account.class=>false,
            Contact.class=>false
        };


        for ( Type cdcType: types.keySet()) {
            // act ( there is no events, so all should be false as we cannot get event info)
            accc_CDCEventBase basector = new accc_CDCEventBase(cdcType);
            Boolean result = basector.handleEventMethod(null);
            // assert
            system.assertEquals(types.get(cdcType),result );
        }
    }

    @isTest
    static void testhandleEventMethodWithChangeTypeVariations(){

        // arrange

        // known types
        Map<Type,Boolean> types = new  Map<Type,Boolean>  {
            AccountChangeEvent.class=>true,
            ContactChangeEvent.class=>true,
            LeadChangeEvent.class=>true,
            CaseChangeEvent.class=>true,
            Account.class=>true,
            Contact.class=>true,
            Lead.class=>true,
            Task.class=>true
        };
        Map<Type,String> cType = new  Map<Type,String>  {
            AccountChangeEvent.class=>accc_CDCEventBase.CDC_UPDATE_CHANGE_TYPE,
            ContactChangeEvent.class=>accc_CDCEventBase.CDC_DELETE_CHANGE_TYPE,
            LeadChangeEvent.class=>accc_CDCEventBase.CDC_GAPCREATE_CHANGE_TYPE,
            CaseChangeEvent.class=>accc_CDCEventBase.CDC_UNDELETE_CHANGE_TYPE,
            Account.class=>accc_CDCEventBase.CDC_GAPUPDATE_CHANGE_TYPE,
            Contact.class=>accc_CDCEventBase.CDC_GAPDELETE_CHANGE_TYPE,
            Lead.class=>accc_CDCEventBase.CDC_GAPUNDELETE_CHANGE_TYPE,
            Task.class=>accc_CDCEventBase.CDC_CREATE_CHANGE_TYPE
        };


        for ( Type cdcType: types.keySet()) {
            // act
            accc_CDCEventBase basector = new accc_CDCEventBase(cdcType);
            basector.header( accc_CDCEventBaseTest.createEventBase(cType.get(cdcType),cdcType.getName() ));
            Boolean result = basector.handleEventMethod(null);

            // assert
            system.assertEquals(types.get(cdcType),result );
            system.assertEquals(true,basector.getChildHeaderByType(null)==null);
        }

    }

    @isTest
    static void testgetFieldsChangedInUpdate(){

        // arrange
        Type theExpectedType = AccountChangeEvent.class;
        List<AccountChangeEvent > theRecords = new List<AccountChangeEvent > {
            new AccountChangeEvent (),
            /**
             * AccountChangeEvent description
             * @return   return description
             */
            new AccountChangeEvent (),
            new AccountChangeEvent ()
        };
        Integer inx=0;
        Map<String, Map<String,accc_CDCEventBase.FieldUpdateState> > expectedResults = new Map<String, Map<String,accc_CDCEventBase.FieldUpdateState> > {
            accc_CDCEventBase.CDC_UPDATE_CHANGE_TYPE=>new Map<String,accc_CDCEventBase.FieldUpdateState> { 'Name'=>accc_CDCEventBase.FieldUpdateState.DELETED},
            accc_CDCEventBase.CDC_DELETE_CHANGE_TYPE=>new Map<String,accc_CDCEventBase.FieldUpdateState>()
        };

        Map<String,Type> cType = new  Map<String,Type>  {
            accc_CDCEventBase.CDC_UPDATE_CHANGE_TYPE=>AccountChangeEvent.class,
            accc_CDCEventBase.CDC_DELETE_CHANGE_TYPE=>AccountChangeEvent.class
        };
        myCDCEventTestClass ctor = new myCDCEventTestClass(theRecords,theExpectedType);
        ctor.useParent=true;
        SObject event = null;

        for ( String cdcType: cType.keySet()) {
            event = theRecords[inx++];
            // act
            ctor.header( accc_CDCEventBaseTest.createEventBase(cdcType,cType.get(cdcType).getName() ));
            Boolean result = ctor.handleEventMethod(event);
            // assert
            system.assertEquals(true,result );
            system.assertEquals(expectedResults.get(cdcType),ctor.getFieldsChangedInUpdate(event));
        }

    }// end of testgetFieldsChangedInUpdate

    ////////////////////////////////////////////////////////////////////////////////////////
    // Private Testing
    ////////////////////////////////////////////////////////////////////////////////////////

    static EventBus.ChangeEventHeader createEventBase(String changetype, string entityname) {
        EventBus.ChangeEventHeader result = new EventBus.ChangeEventHeader();
        result.changeOrigin = accc_CDCEventBase.FOR_TEST_CHANGE_ORIGIN_NAME;
        result.setChangeType(changetype);
        result.commitnumber = 1;
        result.committimestamp = DateTime.now().getTime();
        result.commituser = UserInfo.getUserId();
        result.entityname = entityname;
        result.recordids = new List<String> {
            '001000200000001',
            '001000200000002'
        };
        if ( changetype == accc_CDCEventBase.CDC_UPDATE_CHANGE_TYPE ) {
            result.changedFields = new List<String> { 'Name'};
        }
        result.sequencenumber = 1;
        result.transactionkey = accc_ApexUtilities.newGuid();
        return result;
    } // end of createEventBase

} // end of accc_CDCEventBaseTest