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
 * @description Test class the Apex NoOp Logger
 * @group Common Test Layer
 */
@isTest
private class accc_ApexNoOpLoggerTest {
	@isTest
	static void testDefaultCtor() {
		final String value = 'data';
		accc_ApexNoOpLogger logger = new accc_ApexNoOpLogger();

		System.assertEquals(LoggingLevel.DEBUG, logger.logLevel());
		System.assertEquals(null, logger.lastMessage());

	} // end of testDefaultCtor

	@isTest
	static void testCtor() {
		final String value = 'data';
		accc_ILogger logger = accc_ApexNoOpLoggerTest.getLogger(LoggingLevel.DEBUG);

		logger.write(value);
		System.assertEquals(null, logger.lastMessage());

	} // end of testCtor
	@isTest
	static void testsetLastMessage() {
		final String value = 'data';
		accc_ApexNoOpLogger logger = (accc_ApexNoOpLogger)accc_ApexNoOpLoggerTest.getLogger(LoggingLevel.DEBUG);

		logger.setLastMessage(LoggingLevel.ERROR, value);
		System.assertEquals(null, logger.lastMessage());

	} // end of testsetLastMessage

	@isTest
	static void testCtorCheckLogLevel() {
		final String value = 'data';
		accc_ILogger logger = accc_ApexNoOpLoggerTest.getLogger(LoggingLevel.ERROR);
		System.assertEquals(LoggingLevel.ERROR, logger.logLevel());

	} // end of testCtorCheckLogLevel


	@isTest
	static void testwriteWithTrueSendLogger() {
		final String value = 'data';
		accc_ApexNoOpLogger logger = (accc_ApexNoOpLogger)accc_ApexNoOpLoggerTest.getLogger(LoggingLevel.ERROR);
		logger.write(LoggingLevel.DEBUG, value, true);
		System.assertEquals(null, logger.lastMessage());
	}// end of testwriteWithTrueSendLogger

	@isTest
	static void testwriteWithFalseSendLogger() {
		final String value = 'data';
		accc_ApexNoOpLogger logger = (accc_ApexNoOpLogger)accc_ApexNoOpLoggerTest.getLogger(LoggingLevel.ERROR);
		logger.write(LoggingLevel.DEBUG, value, false);
		System.assertEquals(null, logger.lastMessage());
	}// end of testwriteWithFalseSendLogger

	@isTest
	static void testwriteWithArraySendLogger() {
		final List<String> values = new List<String> {
			'data',
			'data2',
			'data3'
		};
		accc_ApexNoOpLogger logger = (accc_ApexNoOpLogger)accc_ApexNoOpLoggerTest.getLogger(LoggingLevel.ERROR);
		logger.write(LoggingLevel.DEBUG, values, false);
		System.assertEquals(null, logger.lastMessage());
	}// end of testwriteWithArraySendLogger

	@isTest
	static void testwriteWithNoSendLogger() {
		final String value = 'data';
		accc_ApexNoOpLogger logger = (accc_ApexNoOpLogger)accc_ApexNoOpLoggerTest.getLogger(LoggingLevel.ERROR);
		logger.write(LoggingLevel.DEBUG, value);
		System.assertEquals(null, logger.lastMessage());
	}// end of testwriteWithNoSendLogger

	@isTest
	static void testwriteWithListArray() {
		final List<Object> values = new List<Object> {'data', 'two'};
		accc_ApexNoOpLogger logger = (accc_ApexNoOpLogger)accc_ApexNoOpLoggerTest.getLogger(LoggingLevel.ERROR);
		logger.write(LoggingLevel.DEBUG, values);
		System.assertEquals(null, logger.lastMessage());
	}// end of testwriteWithListArray
	//////////////////////////////////////////////////////////////////////////////////
	// PRIVATE METHODS
	//////////////////////////////////////////////////////////////////////////////////

	//
	// get the logger ... can be changed to pull from the test environment (if needed)
	//
	private static accc_ILogger getLogger(LoggingLevel loglevel) {
		return new accc_ApexNoOpLogger(logLevel);
	} // end of getLogger
} // end of accc_ApexNoOpLoggerTest