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
 * @description Test the logger
 * @group Common Test Layer
 */
@isTest
private class accc_ApexLoggerTest {

    /**
     * @description [Check message validity]
     */
    @isTest static void testMessages() {
        // arrange & act
        List<String> messages = accc_ApexLoggerTest.getLogMessages();

        accc_ILogger logger = accc_ApexLoggerTest.getLogger(LoggingLevel.DEBUG);

        for (Integer inx = 0; inx < messages.size(); inx++) {
            logger.debug(messages[inx]);
            system.assertEquals(true, logger.lastMessage().contains(messages[inx]));
        }
    } // end of testMessages

    /**
     * @description est log level
     */
    @isTest static void testLogLevel() {
        // arrange & act
        List<LoggingLevel> loglevel = new LoggingLevel[] {
            LoggingLevel.INFO
            , LoggingLevel.DEBUG
            , LoggingLevel.ERROR
            , LoggingLevel.FINE
            , LoggingLevel.FINER
            , LoggingLevel.FINEST
        };

        accc_ILogger logger = accc_ApexLoggerTest.getLogger(LoggingLevel.DEBUG);

        for (Integer inx = 0; inx < loglevel.size(); inx++) {
            logger.logLevel(loglevel[inx]);
            system.assertEquals(String.valueOf(loglevel[inx]), loglevel[inx].name());
        }
    } // end of testLogLevel

    /**
     * @description Explicit Log
     */
    @isTest static void testExplicitLogLevel() {
        // arrange & act
        String message = 'message';
        accc_ILogger logger = accc_ApexLoggerTest.getLogger(LoggingLevel.DEBUG);

        logger.info(message);
        system.assertEquals(true, logger.lastMessage().contains(LoggingLevel.INFO.name()) );
        logger.warn(message);
        system.assertEquals( true, logger.lastMessage().contains(LoggingLevel.WARN.name()) );
        logger.debug(message);
        system.assertEquals( true, logger.lastMessage().contains(LoggingLevel.DEBUG.name())  );
        logger.error(message);
        system.assertEquals(  true, logger.lastMessage().contains(LoggingLevel.ERROR.name())  );
        logger.fine(message);
        system.assertEquals(  true, logger.lastMessage().contains(LoggingLevel.FINE.name()) );
        logger.finer(message);
        system.assertEquals(  true, logger.lastMessage().contains(LoggingLevel.FINER.name()) );
        logger.finest(message);
        system.assertEquals(  true, logger.lastMessage().contains(LoggingLevel.FINEST.name()) );
    } // end of testExplicitLogLevel

    /**
     * @description test message written with proper log level
     */
    @isTest static void testMessagesWithInjectionOfLogLevel() {
        // arrange & act
        List<String> messages = accc_ApexLoggerTest.getLogMessages();

        accc_ILogger logger = accc_ApexLoggerTest.getLogger(LoggingLevel.FINEST);

        for (Integer i = 0; i < messages.size(); i++) {
            logger.write(messages[i]);
            system.assertEquals(true, logger.lastMessage().contains(LoggingLevel.FINEST.name()));
        }
    } // end of testMessagesWithInjectionOfLogLevel

    /**
    * @description test message traced with proper log level
    */
    @isTest static void testTraceMessagesWithInjectionOfLogLevel() {
        // arrange & act
        List<String> messages = accc_ApexLoggerTest.getLogMessages();
        LoggingLevel lvl = (LoggingLevel)  accc_ApexEnvironment.getRuntimeEnvironment().provider().get(accc_ApexConstants.TraceLogLevel_r);

        accc_ILogger logger = accc_ApexLoggerTest.getLogger(lvl);

        for (Integer i = 0; i < messages.size(); i++) {
            logger.trace(messages[i]);
            system.assertEquals(true, logger.lastMessage().contains(lvl.name()));
        }
    } // end of testTraceMessagesWithInjectionOfLogLevel

    /**
    * @description test message traced with proper log level
    */
    @isTest static void testTraceListOfMessagesWithInjectionOfLogLevel() {
        // arrange & act
        List<String> messages = accc_ApexLoggerTest.getLogMessages();
        LoggingLevel lvl = (LoggingLevel)  accc_ApexEnvironment.getRuntimeEnvironment().provider().get(accc_ApexConstants.TraceLogLevel_r);

        accc_ILogger logger = accc_ApexLoggerTest.getLogger(lvl);

        for (Integer inx = 0; inx < messages.size(); inx++) {
            logger.trace(new List<Object> {messages[inx]});
            system.assertEquals(true, logger.lastMessage().contains(messages[inx]));
        }
    } // end of testTraceListOfMessagesWithInjectionOfLogLevel

    /**
    *
     * @description test message written with improper log level
     */
    @isTest static void negativeTestMessagesWithInjectionOfLogLevel() {
        // arrange & act
        List<String> messages = accc_ApexLoggerTest.getLogMessages();

        accc_ILogger logger = accc_ApexLoggerTest.getLogger(LoggingLevel.FINEST);

        for (Integer i = 0; i < messages.size(); i++) {
            logger.write(messages[i]);
            system.assertNotEquals( true, logger.lastMessage().contains(LoggingLevel.FINER.name()));
        }
    } // end of negativeTestMessagesWithInjectionOfLogLevel

    @isTest
    static void testwriteWithArraySendLoggerWith2Params() {
        final String lastValue = 'data3';
        final List<String> values = new List<String> {
            'data',
            'data2',
            lastValue
        };
        accc_ApexLogger logger = new accc_ApexLogger();
        logger.write(LoggingLevel.DEBUG, values);
        System.assertEquals(true, logger.lastMessage().contains(lastValue));
        logger.write(values);
        System.assertEquals(true, logger.lastMessage().contains(lastValue));
    }// end of testwriteWithArraySendLoggerWith2Params

    @isTest
    static void testwriteWithArraySendLoggerWith3Params() {
        final String lastValue = 'data3';
        final List<String> values = new List<String> {
            'data',
            'data2',
            lastValue
        };
        accc_ApexLogger logger = new accc_ApexLogger();
        logger.write(LoggingLevel.DEBUG, values, false);
        System.assertEquals(true, logger.lastMessage() == null);
        logger.write(LoggingLevel.DEBUG, values, true);
        System.assertEquals(true, logger.lastMessage().contains(lastValue));
    }// end of testwriteWithArraySendLoggerWith3Params

    @isTest
    static void testisTracingOn() {
        // assign
        accc_ApexLogger logger = new accc_ApexLogger();
        // act / asssert
        System.assertEquals(true, logger.isTracingOn());
    } // end of testisTracingOn
    //
    // get the logger ... can be changed to pull from the test environment (if needed)
    //
    private static accc_ILogger getLogger(LoggingLevel loglevel) {
        return new accc_ApexLogger(logLevel);
    } // end of getLogger

    //
    // get log messages
    //
    private static List<String> getLogMessages() {
        List<String> messages = new String[] {
            'info'
            , 'debug'
            , 'error'
            , 'fine'
            , 'finer'
            , 'finest'
        };
        return messages;
    } // end of getLogMessages

} // end of accc_ApexLoggerTest