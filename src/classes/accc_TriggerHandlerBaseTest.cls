/**
 * Copyright (c) 2016-2018, Bill anderson.  All rights reserved.
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
 *   * Neither the name of Bill anderson nor the names of its
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
 * @author Bill anderson
 *
 * @description Test the trigger handler
 *
 * The test classes :
 *  Contact ---> accc_TestTriggerHandlerForContactTest
 *  Account ---> accc_TestTriggerHandlerForAccountTest, accc_TestTriggerHandlerForAccountTwoTest
 *
 * @group Test Layer
 */
@isTest
private class accc_TriggerHandlerBaseTest {
    // our messages posted per trigger event
    static final List<String> logMsgs = new List<String> {
        'On Before Insert',
        'On Before Update',
        'On After Insert',
        'On After Update',
        'On Before Delete',
        'On After Delete',
        'On After UnDelete'
    };

    @isTest
    static void testaccc_TriggerHandlerBaseNoParams() {
        // assign/act
        accc_TriggerHandlerBase ctor = new accc_TriggerHandlerBase();

        // assert
        system.assertEquals(true, ctor.theParameters!=null);

    }// end of testaccc_TriggerHandlerBaseNoParams

    @isTest
    static void testaccc_TriggerHandlerBaseWithParams() {
        // assign
        final String MYDATA='this is argument';
        final accc_TriggerHandlerResources.PassThruResourceDAO theData = new accc_TriggerHandlerResources.PassThruResourceDAO(MYDATA);
        accc_TriggerHandlerBase ctor = new accc_TriggerHandlerBase();
        ctor.handlerResources().add('test',theData);
        // assert
        system.assertEquals(MYDATA, (String)ctor.theParameters.get('test').triggerData);

    }// end of testaccc_TriggerHandlerBaseWithParams

    @isTest
    static void testaccc_TriggerHandlerBaseMessages() {
        // assign
       final String MYDATA='this is argument';
       final accc_TriggerHandlerResources.PassThruResourceDAO theData = new accc_TriggerHandlerResources.PassThruResourceDAO(MYDATA);
       accc_TriggerHandlerBase ctor = new accc_TriggerHandlerBase();
       ctor.handlerResources().add('test',theData);
        // act
        system.assertEquals(MYDATA, (String)ctor.theParameters.get('test').triggerData);
        ctor.onAfterUndeleteChild(null);
        ctor.onAfterDeleteChild(null);
        ctor.onBeforeDeleteChild(null);
        ctor.onAfterUpdateChild(null, null);
        ctor.onAfterInsertChild(null);
        ctor.onBeforeUpdateChild(null, null);
        ctor.onBeforeInsertChild(null);
        ctor.addError(null, MYDATA);
        // assert
        for ( String key : accc_TriggerHandlerBaseTest.logMsgs) {
            system.assertEquals(true, accc_ApexUtilities.containsInTestLog(key));
        }
        // error message passed to addError
        system.assertEquals(null, ctor.for_testing);

    }// end of testaccc_TriggerHandlerBaseMessages

    @isTest
    static void testaccc_TriggerHandlerBaseaddError() {
        // assign
        final String param = 'this is argument again';
        Boolean expectedExceptionThrown = false;
        accc_TriggerHandlerBase ctor = new accc_TriggerHandlerBase();
        Contact myContact = insertNewContactToFireTriggers();
        // act
        ctor.addError(myContact, param);
        // assert
        // error message passed to addError
        system.assertEquals(param, ctor.for_testing);

    }// end of testaccc_TriggerHandlerBaseMessages


    static Contact insertNewContactToFireTriggers() {
        Contact newContact = new Contact(LastName = 'testlastname',
                                         FirstName = 'theFirstName',
                                         Email = 'myname@somecompany.com');
        insert newContact;
        return newContact;
    }
}