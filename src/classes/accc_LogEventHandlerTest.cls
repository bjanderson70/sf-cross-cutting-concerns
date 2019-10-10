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
 * @description test the LogEventHandler
 * @group Test Layer
 */
@isTest
private class accc_LogEventHandlerTest {


    @isTest
    static void testTriggerClassExplicitly(){
        accc_LogEventHandler handler = new accc_LogEventHandler();
        Test.startTest();
        List<ACCC_Log_Event__e> events = accc_LogEventHandlerTest.createLogEvents(10);
        handler.onAfterInsertChild(events);
        Test.stopTest();

        // check the log
        System.assertEquals(true, accc_ApexUtilities.containsInTestLog(accc_LogEventHandler.TEST_MESSAGE));

    }

    @isTest
    static void testTriggerClassExplicitlyWithException(){
        accc_LogEventHandler handler = new accc_LogEventHandler();
        accc_LogEventHandler.useForTestingException=true;
        Test.startTest();
        List<ACCC_Log_Event__e> events = accc_LogEventHandlerTest.createLogEvents(10);
        handler.onAfterInsertChild(events);
        Test.stopTest();

        // check the log
        System.assertEquals(true, accc_ApexUtilities.containsInTestLog(accc_LogEventHandler.TEST_MESSAGE));
        System.assertEquals(true, accc_ApexUtilities.containsInTestLog(accc_LogEventHandler.FOR_TESTING_EXCEPTION));

    }


    @isTest
    static void testTriggerClassExplicitlyWithNulls(){
        accc_LogEventHandler handler = new accc_LogEventHandler();
   
        Test.startTest();
        List<SObject> events = null;
        handler.onAfterInsertChild(null);
        Test.stopTest();

        // check the log
        System.assertEquals(true, accc_ApexUtilities.containsInTestLog(accc_LogEventHandler.TEST_MESSAGE));
    }
    ////////////////////////////////////////////////////////////////////////////////
    // Private Methods
    ////////////////////////////////////////////////////////////////////////////////

    static List<ACCC_Log_Event__e> createLogEvents(integer count){
        List<ACCC_Log_Event__e> events = new List<ACCC_Log_Event__e>();
        for ( integer inx=0; inx<count; inx++) {
            events.add(new ACCC_Log_Event__e(Payload__c = ''+inx));
        }
        return events;
    }// end of createLogEvents

}// end of accc_LogEventHandlerTest