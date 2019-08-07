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
 * @description Test the Implementation of the log formatter.
 * @group Common Test Layer
 */
@isTest
private class accc_ApexLogFormatterTest {
    static final String TEST_STRING = 'The quick brown fox jumps over the lazy dog';
    @isTest
    static void testformat() {
        // assign
        String result;
        accc_IDataFormat dataFmt = new accc_ApexLogFormatter();
        // act
        result = (String)dataFmt.format(TEST_STRING);
        // assert
        system.assertEquals(true, result.contains(TEST_STRING));

    } // end of testformat


    @isTest
    static void testformatBadParams() {
        // assign
        String result;
        accc_IDataFormat dataFmt = new accc_ApexLogFormatter();
        // act
        result = (String) dataFmt.format(null);
        // assert
        system.assertEquals(true, result.contains(LoggingLevel.INFO.name()));

    } // end of testformatBadParams

    @isTest
    static void testformatNullTraceandDefaultFormatter() {
        // assign
        String result;
        accc_IDataFormat dataFmt = new accc_ApexLogFormatter();
        // act
        result = (String) dataFmt.format(null, new accc_ApexLogDataModel());
        // assert
        system.assertEquals(true, result.contains(LoggingLevel.DEBUG.name()));

    } // end of testformatNullTraceandDefaultFormatter

    @isTest
    static void testAllFormats() {

        final accc_IDataFormat dataFmt = new accc_ApexLogFormatter();
        Map<LoggingLevel, Object> results = new Map<LoggingLevel, Object> {
            LoggingLevel.ERROR => dataFmt.format(TEST_STRING, new accc_ApexLogDataModel(LoggingLevel.ERROR)),
            LoggingLevel.INTERNAL => dataFmt.format(TEST_STRING, new accc_ApexLogDataModel(LoggingLevel.INTERNAL)),
            LoggingLevel.FINEST => dataFmt.format(TEST_STRING, new accc_ApexLogDataModel(LoggingLevel.FINEST)),
            LoggingLevel.FINER => dataFmt.format(TEST_STRING, new accc_ApexLogDataModel(LoggingLevel.FINER)),
            LoggingLevel.FINE => dataFmt.format(TEST_STRING, new accc_ApexLogDataModel(LoggingLevel.FINE)),
            LoggingLevel.DEBUG => dataFmt.format(TEST_STRING, new accc_ApexLogDataModel(LoggingLevel.DEBUG)),
            LoggingLevel.INFO => dataFmt.format(TEST_STRING, new accc_ApexLogDataModel(LoggingLevel.INFO))
        };
        for ( LoggingLevel lvl : results.keyset()) {
            // assert
            system.assertEquals(true, ((String)results.get(lvl)).contains(lvl.name()));
            system.assertEquals(true, ((String)results.get(lvl)).contains(TEST_STRING));
        }
    } // end of testAllFormats

}// end of accc_ApexLogFormatterTest