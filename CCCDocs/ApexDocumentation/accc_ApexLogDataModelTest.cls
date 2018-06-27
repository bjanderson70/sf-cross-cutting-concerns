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
 *
 * @author Bill Anderson
 * @description Test the log data model
 * @group Common Test Layer
 */
@isTest
private class accc_ApexLogDataModelTest {
    @isTest
    static void testctor() {
        // assign /act
        accc_ApexLogDataModel model = new accc_ApexLogDataModel('');
        // assert
        system.assertEquals('', model.stacktrace);
    } // end of testctor
    @isTest
    static void testdefaultctor() {
        // assign /act
        accc_ApexLogDataModel model = new accc_ApexLogDataModel();
        // assert
        system.assertEquals('', model.stacktrace);
        system.assertEquals(LoggingLevel.DEBUG, model.logLevel);
    } // end of testdefaultctor
    @isTest
    static void testctorWithLogLevel() {
        // assign /act
        accc_ApexLogDataModel model = new accc_ApexLogDataModel(LoggingLevel.ERROR);
        // assert
        system.assertEquals('', model.stacktrace);
        system.assertEquals(LoggingLevel.ERROR, model.logLevel);
    } // end of testctorWithLogLevel

    @isTest
    static void testctorWith3Params() {
        // assign /act
        Long ms = system.currentTimeMillis();
        accc_ApexLogDataModel model = new accc_ApexLogDataModel('', LoggingLevel.ERROR, ms);
        // assert
        system.assertEquals('', model.stacktrace);
        system.assertEquals(LoggingLevel.ERROR, model.logLevel);
        system.assertEquals(ms, model.startTime);
    } // end of testctorWith3Params

    @isTest
    static void testctorWithGarbageTrace() {
        // assign /act
        final String garbageTrace = 'jsj sjs jssjj ssjas udiqwri qwi qe';
        Long ms = system.currentTimeMillis();
        accc_ApexLogDataModel model = new accc_ApexLogDataModel(garbageTrace, LoggingLevel.ERROR, ms);
        // assert
        system.assertEquals(garbageTrace, model.stacktrace);
        system.assertEquals(accc_ApexConstants.EmptyString, model.className);
        system.assertEquals(accc_ApexConstants.EmptyString, model.methodName);
        system.assertEquals(accc_ApexConstants.EmptyString, model.lineNumber);
        system.assertEquals(LoggingLevel.ERROR, model.logLevel);
        system.assertEquals(ms, model.startTime);
    } // end of testctorWithGarbageTrace

    @isTest
    static void testctorValidParam() {
        // assign /act
        accc_ApexLogDataModel model = new accc_ApexLogDataModel(new DmlException().getStackTraceString());
        // assert
        system.assertNotEquals('', model.stacktrace);
        system.assertEquals(LoggingLevel.DEBUG, model.logLevel);
    } // end of testctorValidParam

    @isTest
    static void testctorValidLoggingLevel() {
        // assign /act
        accc_ApexLogDataModel model = new accc_ApexLogDataModel(new DmlException().getStackTraceString(), LoggingLevel.INFO);
        // assert
        system.assertEquals(LoggingLevel.INFO, model.logLevel);
    } // end of testctorValidLoggingLevel

    @isTest
    static void testctorValidLoggingLevelAndStart() {
        // assign /act
        long ms = System.currentTimeMillis();
        accc_ApexLogDataModel model = new accc_ApexLogDataModel(new DmlException().getStackTraceString(), LoggingLevel.INFO, ms);
        // assert
        system.assertEquals(LoggingLevel.INFO, model.logLevel);
        system.assertEquals(ms, model.startTime);
    } // end of testctorValidLoggingLevelAndStart

    @isTest
    static void testclassName() {
        // assign /act
        long ms = System.currentTimeMillis();
        string trace = new DmlException().getStackTraceString(),
        clsname = 'accc_ApexLogDataModelTest';
        accc_ApexLogDataModel model = new accc_ApexLogDataModel(trace, LoggingLevel.INFO, ms);
        // assert
        system.assertEquals(LoggingLevel.INFO, model.logLevel);
        system.assertEquals(ms, model.startTime);
        system.assertEquals(model.className, clsname);
    } // end of testclassName

    @isTest
    static void testctorParams() {
        // assign /act
        long ms = System.currentTimeMillis();
        string trace = '',
               clsnm  = 'clsnm',
               mthname = 'mthnm',
               lineno = '100';
        LoggingLevel lvl = LoggingLevel.ERROR;
        accc_ApexLogDataModel model = new accc_ApexLogDataModel(trace, clsnm, mthname, lineno, lvl, ms);

        // assert
        system.assertEquals(trace, model.stacktrace);
        system.assertEquals(mthname, model.methodName);
        system.assertEquals(clsnm, model.className);
        system.assertEquals(lvl, model.logLevel);
        system.assertEquals(ms, model.startTime);
        system.assertEquals(lineno, model.lineNumber);
    } // end of testctorValidLoggingLevelAndStart
} // end of accc_ApexLogDataModelTest