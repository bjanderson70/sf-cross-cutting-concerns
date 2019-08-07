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
 * @description Test exception handler
 * @group Common Test Layer
 */
@isTest
private class accc_ApexExceptionHandlerTest {

    // my specific test exception
    public class TestException extends Exception {}
    // expected exception string
    private static final String EXPECTED_EXCP_STRING = 'Exception type caught: accc_ApexExceptionHandlerTest.TestException';

    //
    // test the exception handling process
    //
    @isTest static void testProcess() {
        // assign
        TestException excp = new TestException ('accc_ApexExceptionHandlerTest:testProcess');
        // act
        accc_ApexExceptionHandler excpHandler = new accc_ApexExceptionHandler();

        excpHandler.process(excp);
        String msg =  accc_ApexEnvironment.getRuntimeEnvironment().logger().lastMessage();
        Integer result = msg.indexOf(EXPECTED_EXCP_STRING);
        // assert
        system.assertNotEquals(result, -1);

    } // end of testProcess

    //
    // Ensure the log is not created by turning it off
    //
    @isTest static void testProcessNoLog() {
        // assign
        TestException excp = new TestException ('accc_ApexExceptionHandlerTest:testProcessNoLog');
        // act
        accc_ApexExceptionHandler excpHandler = new accc_ApexExceptionHandler();

        excpHandler.process(excp, accc_ApexExceptionPolicyEnum.Top, false);
        String msg =  accc_ApexEnvironment.getRuntimeEnvironment().logger().lastMessage();
        // assert
        system.assertEquals(msg, null);

    } // end of testProcessNoLog

    //
    // test the exception handling process which uses carefully (system.debug)
    //
    @isTest static void testProcessCarefully() {
        // assign
        TestException excp = new TestException ('accc_ApexExceptionHandlerTest:testProcess');
        // act
        accc_ApexExceptionHandler excpHandler = new accc_ApexExceptionHandler();

        excpHandler.process(excp, true);
        Boolean handleWithCare = excpHandler.handlingLoggingWithCare;
        String msg = excpHandler.systemDebugLogger().lastMessage();
        Integer result = msg.indexOf('accc_ApexExceptionHandlerTest:testProcess');
        // assert
        system.assertNotEquals(-1, result);
        system.assertEquals(false, handleWithCare);

    } // end of testProcessCarefully
    //
    // Test rethrow
    //
    @isTest static void testRethrow() {
        // assign
        TestException excp = new TestException ('accc_ApexExceptionHandlerTest:testRethrow');
        // act
        accc_ApexExceptionHandler excpHandler = new accc_ApexExceptionHandler();

        Exception result = excpHandler.rethrow(excp);
        // assert
        system.assertEquals(result.getTypeName(), excp.getTypeName());

    } // end of testRethrow

    @isTest static void testhandleException() {
        // assign
        accc_ILogger logger = new accc_ApexLogger(LoggingLevel.ERROR);
        TestException excp = new TestException ('accc_ApexExceptionHandlerTest:testhandleException');
        accc_ApexExceptionHandler excpHandler = new accc_ApexExceptionHandler();
        // act
        excpHandler.handleException(excp);
        // assert
        system.assertEquals(true, excpHandler.getLogger().lastMessage().contains('accc_ApexExceptionHandlerTest:testhandleException'));

    } // end of testhandleException

    @isTest static void testgetLogger() {
        // assign
        accc_ApexExceptionHandler excpHandler = new accc_ApexExceptionHandler();
        excpHandler.handlingLoggingWithCare = true;
        // act
        accc_ILogger logger = excpHandler.getLogger();
        // assert
        system.assertEquals(true, logger instanceof accc_ApexLogger);

    } // end of testgetLogger

    @isTest static void testgetDataFormatter() {
        // assign
        accc_ApexExceptionHandler excpHandler = new accc_ApexExceptionHandler();
        excpHandler.handlingLoggingWithCare = true;
        // act
        accc_IDataFormat formatter = excpHandler.getDataFormatter();
        // assert
        system.assertEquals(true, formatter instanceof accc_ExceptionFormatter);

    } // end of testgetDataFormatter

    @isTest
    static void testwriteExceptionToLogger() {
        // assign
        TestException excp = new TestException ('accc_ApexExceptionHandlerTest:testwriteExceptionToLogger');
        accc_ApexExceptionHandler excpHandler = new accc_ApexExceptionHandler();
        excpHandler.handlingLoggingWithCare = true;
        // act
        excpHandler.writeExceptionToLogger(excp, accc_ApexExceptionPolicyEnum.Top);
        // assert
        system.assertEquals(true, excpHandler.systemDebugLogger().lastMessage().contains(excp.getMessage()));

    } // end of testwriteExceptionToLogger

    @isTest
    static void testformatExceptionMessageWithNull() {
        // assign
        accc_ApexExceptionHandler excpHandler = new accc_ApexExceptionHandler();

        // act
        String msg = excpHandler.formatExceptionMessage(null, accc_ApexExceptionPolicyEnum.Top);
        // assert
        system.assertEquals(accc_ApexConstants.EmptyString, msg);

    } // end of testformatExceptionMessageWithNull

} // end of accc_ApexExceptionHandlerTest