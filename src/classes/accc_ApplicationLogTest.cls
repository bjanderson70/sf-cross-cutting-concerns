/**
 * Copyright (c) 2016-2019, Bill Anderson. All rights reserved.
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
 *   * Neither the name of Bill Anderson , Bill Anderson nor the names of its
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
 * @description  Test class for the  accc_ApplicationLog methods
 * @group Common Test Layer
 */
@isTest
private class accc_ApplicationLogTest {

    /**
    *
     * @description testing default ctor
     */
    @isTest
    static void accc_ApplicationLogDefaultCtorTest() {
        // assign/act
        accc_ApplicationLog item = new accc_ApplicationLog();

        System.assertNotEquals(item, null);
        System.assertNotEquals(item.entry(), null);

    } // end of accc_ApplicationLogDefaultCtorTest

    /**
    *
     * @description testing ctor with entry
     */
    @isTest
    static void accc_ApplicationLogCtorWithEntryTest() {
        // assign
        String payload = 'Test';
        AcccApplicationLog__c entry = new AcccApplicationLog__c();
        entry.IntegrationPayload__c = payload;
        // act
        Test.startTest();
        accc_ApplicationLog item = new accc_ApplicationLog(entry);
        Test.stopTest();
        // assert
        System.assertNotEquals(item, null);
        System.assertEquals(item.entry().IntegrationPayload__c, payload);

    } // end of accc_ApplicationLogCtorWithEntryTest

    /**
    *
     * @description testing  ctor with exception, classname, method name
     */
    @isTest
    static void accc_ApplicationLogCtorWithExceptionClassnameMethodNameTest() {
        // assign

        accc_ApexApplicationException excp = new accc_ApexApplicationException();
        // act
        Test.startTest();
        accc_ApplicationLog item = new accc_ApplicationLog(excp, 'classname', 'methodName');
        Test.stopTest();
        // assert
        System.assertNotEquals(item, null);
        System.assertEquals( 'accc_ApexApplicationException', item.entry().Exception__c);
        System.assertEquals(LoggingLevel.ERROR.name(), item.entry().LogCode__c);
        System.assertEquals('classname', item.entry().Source__c);
        System.assertEquals('methodName', item.entry().SourceFunction__c);

    } // end of accc_ApplicationLogCtorWithExceptionClassnameMethodNameTest

    /**
    *
     * @description testing  ctor with  classname, method name
     */
    @isTest
    static void accc_ApplicationLogCtorWithClassnameMethodNameTest() {
        // assign
        // act
        Test.startTest();
        accc_ApplicationLog item = new accc_ApplicationLog('classname', 'methodName');
        // set payload
        item.setIntegrationPayload('Payload');
        Test.stopTest();
        // assert
        System.assertNotEquals(null, item);
        System.assertEquals(null, item.entry().Exception__c);
        System.assertEquals(null, item.entry().LogCode__c);
        System.assertEquals('classname', item.entry().Source__c );
        System.assertEquals('methodName', item.entry().SourceFunction__c);
        System.assertEquals('Payload', item.entry().IntegrationPayload__c);

    } // end of accc_ApplicationLogCtorWithClassnameMethodNameTest

    /**
    *
     * @description testing  ctor with message
     */
    @isTest
    static void accc_ApplicationLogCtorWithMessageTest() {
        // assign
        // act
        Test.startTest();
        accc_ApplicationLog item = new accc_ApplicationLog('message');
        Test.stopTest();
        // assert
        System.assertNotEquals(item, null);
        System.assertEquals(item.entry().Exception__c, null);
        System.assertEquals(item.entry().LogCode__c, null);
        System.assertEquals(item.entry().Source__c, accc_ApexConstants.EmptyString);
        System.assertEquals(item.entry().ReferenceInfo__c, 'message');
        System.assertNotEquals(item.entry().ReferenceId__c, null);

    } // end of accc_ApplicationLogCtorWithMessageTest

    /**
    *
     * @description testing  ctor with message
     */
    @isTest
    static void accc_ApplicationLogCtorWithExceptionAndMessageTest() {
        // assign
        // act
        Test.startTest();
        accc_ApplicationLog item = new accc_ApplicationLog(new accc_ApexApplicationException('test'), 'message', true);
        Test.stopTest();
        // assert
        System.assertNotEquals(null, item);
        System.assertEquals(item.entry().Exception__c, 'accc_ApexApplicationException');
        System.assertEquals(item.entry().ReferenceInfo__c, 'message');


    } // end of accc_ApplicationLogCtorWithMessageTest
    /**
    *
     * @description testing  ctor with message
     */
    @isTest
    static void accc_ApplicationLogCtorWithMessageCheckLogTest() {
        // assign
        // act
        Test.startTest();
        accc_ApplicationLog item = new accc_ApplicationLog('message will be logged');
        Id entryId = item.entryIdentifier();
        // assert
        System.assertNotEquals(item, null);
        System.assertEquals(item.entry().Exception__c, null);
        System.assertEquals(item.entry().LogCode__c, null);
        System.assertEquals(item.entry().Source__c, accc_ApexConstants.EmptyString);
        System.assertEquals(item.entry().ReferenceInfo__c, 'message will be logged');

    } // end of accc_ApplicationLogCtorWithMessageCheckLogTest

    /**
    *
     * @description testing  ctor with dml exception
     */
    @isTest
    static void accc_ApplicationLogCtorWithMessageCollectionWithDMLExceptionTest() {
        // assign
        // act

        accc_ApplicationLog item = new accc_ApplicationLog('message will be logged', false);
        Test.startTest();
        // cause governor limits to be reached and throw an internal exception
        while ( item.log() == true ) {
        }
        Test.stopTest();
        // assert
        System.assertNotEquals(null, item.logException());

    } // end of accc_ApplicationLogCtorWithMessageCollectionWithDMLExceptionTest

    /**
    *
     * @description testing  ctor with dml exception
     */
    @isTest
    static void accc_ApplicationLogCtorWithExceptionTest() {
        // assign
        // act
        Test.startTest();
        accc_ApplicationLog item = new accc_ApplicationLog(new accc_ApexApplicationException('message will be logged'));
        item.log();
        Test.stopTest();

        // assert
        System.assertNotEquals(item, null);
        System.assertEquals(item.entry().Exception__c, 'accc_ApexApplicationException');

    } // end of accc_ApplicationLogCtorWithExceptionTest


    @isTest
    static void testlogApplicationList() {
        // assign
        List<AcccApplicationLog__c> entries = new List<AcccApplicationLog__c> {
            new AcccApplicationLog__c(),
            new AcccApplicationLog__c(),
            new AcccApplicationLog__c()
        };
        // act
        Test.startTest();
        accc_ApplicationLog item = new accc_ApplicationLog();
        Boolean result = item.log(entries);
        Test.stopTest();
        // assert

        System.assertEquals(true, result);

    } // end of testlogApplicationList

    @isTest
    static void testentriesLogged() {
        // assign
        List<AcccApplicationLog__c> entries = new List<AcccApplicationLog__c> {
            new AcccApplicationLog__c(Message__c = 'test'),
            new AcccApplicationLog__c(Message__c = 'test1'),
            new AcccApplicationLog__c(Message__c = 'test2')
        };
        // act

        Test.startTest();
        accc_ApplicationLog item = new accc_ApplicationLog();
        item.log(entries);
        Test.stopTest();
        Integer count = item.entriesLogged();
        // assert
        System.assertEquals(true, count == entries.size());

    } // end of testentriesLogged

    @isTest
    static void testlogApplicationEntries() {
        // assign
        List<AcccApplicationLog__c> logEntries = null;
        Test.startTest();
        accc_ApplicationLog item = new accc_ApplicationLog();
        // act
        Boolean result = item.logApplicationEntries(logEntries );
        Test.stopTest();

        // assert
        System.assertEquals(false, result);
    } // end of testlogApplicationEntries
    /**
    *
     * @description testing ctor with null entry
     */
    @isTest
    static void accc_ApplicationLogCtorWithNullEntryTest() {
        // assign
        AcccApplicationLog__c entry = null;

        // act
        Test.startTest();
        accc_ApplicationLog item = new accc_ApplicationLog(entry);

        // assert
        System.assertNotEquals(null, item);
        System.assertEquals(null, item.entry());
        System.assertEquals(false, item.log());
        Test.stopTest();

    } // end of accc_ApplicationLogCtorWithNullEntryTest
    /**
    *
     * @description testing  call to log with null entry
     */
    @isTest
    static void accc_ApplicationLogCallLogWithNullTest() {
        // assign

        // act
        Test.startTest();
        accc_ApplicationLog item = new accc_ApplicationLog();
        AcccApplicationLog__c entry = null;
        // assert
        System.assertNotEquals(null, item);
        System.assertEquals(false, item.log(entry));
        Test.stopTest();

    } // end of accc_ApplicationLogCallLogWithNullTest

    @isTest
    static void testcorrectString() {
        // assign
        String tvalue = '';
        Integer MaxSize = accc_ApplicationLog.MAX_TEXT_SIZE;
        // act
        accc_ApplicationLog item = new accc_ApplicationLog();

        for (integer inx = 0; inx < MaxSize + 10; ++inx) {
            tvalue += '1';
        }
        String result = item.correctString(tvalue);
        // assert
        System.assertEquals(result.length(), MaxSize);
        result = item.correctString(null);
        // assert
        System.assertEquals(result.length(), 0);
    } // end of testcorrectString

}// end of accc_ApplicationLogTest