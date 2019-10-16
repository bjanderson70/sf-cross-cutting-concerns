/**
 * Copyright (c) 2016-2018, Bill Anderson.  All rights reserved.
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
 * @description Platform Event Logger Tester (Singleton for the public; not so for protected/children)
 * @group Test Layer
 */
@isTest
private class accc_TriggerMediatorTest {

    static final String ExpectedTHEnvironmentCustomMDT = accc_ApexConstants.TEST_CATEGORY;

    @isTest
    static void testCtorWithBadType() {
        // arrange/act
        Boolean hasException = false;
        try {
            accc_TriggerMediator ctor = new accc_TriggerMediator((Type)null);
        } catch (Exception excp) {
            hasException = true;
        }
        // assert
        System.assertEquals(true,hasException);
    }
    @isTest
    static void testCtorWithType() {
        // arrange/act
        accc_TriggerMediator ctor = new accc_TriggerMediator(Account.class);
        // assert
        System.assertEquals(Account.class, ctor.triggerType);
        // default is test
        System.assertEquals(ExpectedTHEnvironmentCustomMDT, ctor.theEnvironment);
        // no records
        System.assertEquals(null, ctor.records);
        // no existing records
        System.assertEquals(null, ctor.existingRecords);

    }
    @isTest
    static void testCtorWithTypeAndEnv() {
        // arrange/act
        accc_TriggerMediator ctor = new accc_TriggerMediator(Contact.class,ExpectedTHEnvironmentCustomMDT);
        // assert
        System.assertEquals(Contact.class, ctor.triggerType);
        // default is test
        System.assertEquals(ExpectedTHEnvironmentCustomMDT, ctor.theEnvironment);
        // no records
        System.assertEquals(null, ctor.records);
        // no existing records
        System.assertEquals(null, ctor.existingRecords);

    }
    @isTest
    static void testCtorWithTypeAndWithNullEnv() {
        // arrange/act
        accc_TriggerMediator ctor = new accc_TriggerMediator(Contact.class,(String)null);
        // assert
        System.assertEquals(Contact.class, ctor.triggerType);
        // default is test
        System.assertEquals(ExpectedTHEnvironmentCustomMDT, ctor.theEnvironment);
        // no records
        System.assertEquals(null, ctor.records);
        // no existing records
        System.assertEquals(null, ctor.existingRecords);

    }
    @isTest
    static void testCtorWithTypeAndEnvAndRecords() {
        // arrange/act
        List<SObject> records = new List<SObject> {
            new Account(),
            new Account()
        };
        accc_TriggerMediator ctor = new accc_TriggerMediator(Contact.class,records);
        // assert
        System.assertEquals(Contact.class, ctor.triggerType);
        // default is test
        System.assertEquals(ExpectedTHEnvironmentCustomMDT, ctor.theEnvironment);
        // no records
        System.assertEquals(records.size(), ctor.records.size());
        // no existing records
        System.assertEquals(null, ctor.existingRecords);

    }
    @isTest
    static void testCtorWithTypeAndEnvAndExistingRecords() {
        // arrange/act
        Map<Id,SObject> existing = new Map<Id,SObject> {
            accc_TestUtility.getFakeId(Account.SObjectType) => new Account(),
            accc_TestUtility.getFakeId(Account.SObjectType) => new Account()
        };
        accc_TriggerMediator ctor = new accc_TriggerMediator(Contact.class,existing);
        // assert
        System.assertEquals(Contact.class, ctor.triggerType);
        // default is test
        System.assertEquals(ExpectedTHEnvironmentCustomMDT, ctor.theEnvironment);
        //  existing records
        System.assertEquals(existing.size(), ctor.existingRecords.size());
        //  existing records
        System.assertEquals(null, ctor.records);

    }
    @isTest
    static void testCtorWithTypeAndEnvAndRecordsAndExisting() {
        // arrange/act
        List<SObject> records = new List<SObject> {
            new Account(),
            new Account()
        };
        Map<Id,SObject> existing = new Map<Id,SObject> {
            accc_TestUtility.getFakeId(Account.SObjectType) => new Account(),
            accc_TestUtility.getFakeId(Account.SObjectType) => new Account()
        };
        accc_TriggerMediator ctor = new accc_TriggerMediator(Contact.class,records,existing);
        // assert
        System.assertEquals(Contact.class, ctor.triggerType);
        // default is test
        System.assertEquals(ExpectedTHEnvironmentCustomMDT, ctor.theEnvironment);
        // no records
        System.assertEquals(records.size(), ctor.records.size());
        // no existing records
        System.assertEquals(existing.size(), ctor.existingRecords.size());

    }
    @isTest
    static void testcreateHandlerChainByDomain() {
        // arrange
        final String domain = 'Account';
        final String madeUpDomain = 'MyJunk*';
        accc_TriggerMediator ctor = new accc_TriggerMediator(Account.class);
        accc_TriggerHandlerChainManager thcm = ctor.theTriggerManager();
        // assert
        System.assertEquals(true, thcm.createHandlerChainByDomain(domain) != null);
        // default is true
        System.assertEquals(true, thcm.continueIfException);
    }
    @isTest
    static void testonBeforeInsertChild() {
        // arrange/assign/act
        accc_TriggerMediator ctor = new accc_TriggerMediator(Account.class);
        Boolean result = ctor.execute(accc_TriggerHelperClass.TriggerState.BeforeInsert);
        // assert
        system.assertEquals(true, accc_ApexUtilities.containsInTestLog(accc_TriggerHandlerBase.OBIC));
        system.assertEquals(true, result);
    }

    @isTest
    static void testonAllEventsChild() {
        // arrange/assign
        accc_TriggerMediator ctor = new accc_TriggerMediator(Account.class);
        Map<accc_TriggerHelperClass.TriggerState,Boolean> events = new  Map<accc_TriggerHelperClass.TriggerState,Boolean> {
            accc_TriggerHelperClass.TriggerState.BeforeInsert=>true,
            accc_TriggerHelperClass.TriggerState.BeforeUpdate=>true,
            accc_TriggerHelperClass.TriggerState.BeforeDelete=>true,
            accc_TriggerHelperClass.TriggerState.AfterInsert=>true,
            accc_TriggerHelperClass.TriggerState.AfterUpdate=>true,
            accc_TriggerHelperClass.TriggerState.AfterDelete=>true,
            accc_TriggerHelperClass.TriggerState.AfterUndelete=>true

        };

        Map<accc_TriggerHelperClass.TriggerState,String> stringMsgs = new  Map<accc_TriggerHelperClass.TriggerState,String> {
            accc_TriggerHelperClass.TriggerState.BeforeInsert=>accc_TriggerHandlerBase.OBIC,
            accc_TriggerHelperClass.TriggerState.BeforeUpdate=>accc_TriggerHandlerBase.OBUC,
            accc_TriggerHelperClass.TriggerState.BeforeDelete=>accc_TriggerHandlerBase.OBDC,
            accc_TriggerHelperClass.TriggerState.AfterInsert=>accc_TriggerHandlerBase.OAIC,
            accc_TriggerHelperClass.TriggerState.AfterUpdate=>accc_TriggerHandlerBase.OAUC,
            accc_TriggerHelperClass.TriggerState.AfterDelete=>accc_TriggerHandlerBase.OADC,
            accc_TriggerHelperClass.TriggerState.AfterUndelete=>accc_TriggerHandlerBase.OAUDC

        };
        // act
        Boolean result = false;
        for (accc_TriggerHelperClass.TriggerState state: events.keySet()) {
            result=ctor.execute(state);
            // assert
            system.assertEquals(true, accc_ApexUtilities.containsInTestLog(stringMsgs.get(state)));
            system.assertEquals(true, events.get(state));
        }
    }

    @isTest
    static void testMediatorCauseException() {
        // arrange

        accc_TriggerMediator ctor = new accc_TriggerMediator(Account.class);
        accc_TriggerMediator.mCauseException =true;
        ctor.theTriggerManager().continueIfException = false;
        Boolean result = ctor.execute(accc_TriggerHelperClass.TriggerState.BeforeInsert);

        // assert
        system.assertEquals(true, accc_ApexUtilities.containsInTestLog(accc_TriggerHandlerBase.OBIC));
        system.assertEquals(false, result);
    }
} // end of accc_TriggerMediatorTest