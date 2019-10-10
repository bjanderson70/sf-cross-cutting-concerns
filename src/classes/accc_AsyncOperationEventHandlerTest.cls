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
 * @description test the accc_AsyncOperationEventHandler
 * @group Test Layer
 */
@isTest
private class accc_AsyncOperationEventHandlerTest {


    @isTest
    static void testTriggerClassExplicitly(){
        accc_EventBase handler = new accc_AsyncOperationEventHandler();
        Test.startTest();
        List<AsyncOperationEvent> events = accc_AsyncOperationEventHandlerTest.createLogEvents(10);
        handler.onAfterInsertChild(events);
        Test.stopTest();

        // check the log
        System.assertEquals(true, accc_ApexUtilities.containsInTestLog(accc_AsyncOperationEventHandler.TEST_MESSAGE));

    }

    @isTest
    static void testTriggerClassExplicitlyWithException(){
         accc_EventBase handler = new accc_AsyncOperationEventHandler();
        accc_AsyncOperationEventHandler.useForTestingException=true;
        Test.startTest();
        List<AsyncOperationEvent> events = accc_AsyncOperationEventHandlerTest.createLogEvents(10);
        handler.onAfterInsertChild(events);
        Test.stopTest();

        // check the log
        System.assertEquals(true, accc_ApexUtilities.containsInTestLog(accc_AsyncOperationEventHandler.TEST_MESSAGE));
        System.assertEquals(true, accc_ApexUtilities.containsInTestLog(accc_AsyncOperationEventHandler.FOR_TESTING_EXCEPTION));

    }


    @isTest
    static void testTriggerClassExplicitlyWithNulls(){
        accc_AsyncOperationEventHandler handler = new accc_AsyncOperationEventHandler();
        Test.startTest();
        List<SObject> events = null;
        handler.onAfterInsertChild(null);
        Test.stopTest();

        // check the log
        System.assertEquals(true, accc_ApexUtilities.containsInTestLog(accc_AsyncOperationEventHandler.TEST_MESSAGE));
    }
    ////////////////////////////////////////////////////////////////////////////////
    // Private Methods
    ////////////////////////////////////////////////////////////////////////////////

    static List<AsyncOperationEvent> createLogEvents(integer count){
        List<AsyncOperationEvent> events = new List<AsyncOperationEvent>();
        for ( integer inx=0; inx<count; inx++) {
            events.add(new AsyncOperationEvent(OperationId = 'Op'+inx ));
        }
        return events;
    }// end of createLogEvents

}// end of accc_AsyncOperationEventHandlerTest
