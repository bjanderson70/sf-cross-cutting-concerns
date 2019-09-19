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
 * @description Test handles Platform Events for Logging.
 * @group Common Test Layer
 */
@isTest
private class accc_LogPlatformEventHandlerTest {
    @isTest
    static void testafterInsert() {
        integer inx = 0;
        List<accc_Log__e> elogs = new List<accc_Log__e> {
            new accc_Log__e(Message__c = '1'),
            new accc_Log__e(Message__c = '2'),
            new accc_Log__e(Message__c = '3')
        };
        accc_ITriggerHandler evtHndlr = new accc_LogPlatformEventHandler();

        evtHndlr.onAfterInsertChild(elogs);
        List<AcccApplicationLog__c> logs = [select Message__c from AcccApplicationLog__c];
        for (AcccApplicationLog__c item : logs ) {
            if ( item.Message__c == '1' ||
                 item.Message__c == '2' ||
                 item.Message__c == '3') {
                inx++;
            }
        }
        system.assertEquals(3, inx);
    } // end of testafterInsert

    @isTest
    static void testafterInsertWithException(){
        // arrange
        boolean exceptionOccurred = false;
        List<accc_Log__e> elogs = new List<accc_Log__e>();
        accc_LogPlatformEventHandler.useForTestingException=true;
        accc_ITriggerHandler evtHndlr = new accc_LogPlatformEventHandler();
        try {
            evtHndlr.onAfterInsertChild(elogs);
        } catch (accc_ApexApplicationException excp) {
            exceptionOccurred=true;
        }
        system.assertEquals(true, exceptionOccurred);
    }// end of testafterInsertWithException
	
} // end of accc_LogPlatformEventHandlerTest