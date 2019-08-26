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
 * @description Handles Testing of Platform Events Disptaching (after insert only).In two
 * overloaded forms.You can either pass the specific handler to be invoked or, pass in the
 * Type which will be looked up in the Trigger Handler.The latter assumes you have:
 *   (1) Installed the trigger handler ( https://github.com/bjanderson70/sf-trigger-handling )
 *   (2) Uncommented out the code in accc_ApexPlatformEventDispatcher
 *
 * @group Test Layer
 */
@isTest
private class accc_ApexPlatformEventDispatcherTest {

    @isTest
    static void testrun() {
        accc_ITriggerHandler iplatEvt = new accc_LogPlatformEventHandler();
        boolean status =accc_ApexPlatformEventDispatcher.run(iplatEvt);
        // there is no trigger that will have fired
        system.assertEquals(false, accc_ApexUtilities.containsInTestLog('accc_ApexPlatformEventDispatcher.name'));
        system.assertEquals(false, status);

    } // end of testrun

    @isTest
    static void testrunWithType() {
        Type eventType = Contact.class;
        Boolean status=accc_ApexPlatformEventDispatcher.run(eventType);
        // this checks that the event is execute w/o looking at the result
        system.assertEquals(true, accc_ApexUtilities.containsInTestLog('accc_ApexPlatformEventDispatcher.handlerType='));
        /************************
         * This is commented out as it would assume you have the sf-trigger-handler installed. Bec/ the handler is
         * not installed beforehand, the status will be false; however, once the trigger handler IS installed, and assuming the
         * TriggerMediator ran successfully, the result would be true. Thus, will leave commented out.
          system.assertEquals(true, status);
         *************************/
    } // end of testrunWithType

    @isTest
    static void testrunWithNullType() {
        Type eventType = null;
        Boolean status=accc_ApexPlatformEventDispatcher.run(eventType);
        // assert
        // exception is filed for null ( though, it does not throw, just logs)
        system.assertEquals(true, accc_ApexUtilities.containsInTestLog('accc_ApexPlatformEventDispatcher'));
        // this checks that the event did not execute w/o looking at the result
        system.assertEquals(false, accc_ApexUtilities.containsInTestLog('accc_ApexPlatformEventDispatcher.handlerType='));
        system.assertEquals(false, status);
    }  // end of testrunWithNullType

    @isTest
    static void testrunWithNullParam() {
        accc_ApexPlatformEventDispatcher.run((accc_ITriggerHandler)null);
        system.assertEquals(false, accc_ApexUtilities.containsInTestLog('accc_ApexPlatformEventDispatcher.name'));
    } // end of testrunWithNullParam

    @isTest
    static void testrunWithTriggerFire() {
        String msg = 'testrunWithTriggerFire';
        List<accc_Log__e> logEvt = new List<accc_Log__e> {new accc_Log__e(Message__c = msg)};

        Test.startTest();
        // Publish log event
        List<Database.SaveResult> sr = EventBus.publish(logEvt);
        Test.stopTest();

        // there is a trigger that will have fired
        system.assertEquals(true, accc_ApexUtilities.containsInTestLog('accc_ApexPlatformEventDispatcher.name=accc_LogPlatformEventHandler'));
    } // end of testrunWithTriggerFire
} // end of accc_ApexPlatformEventDispatcherTest
