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
 * @author Bill Anderson
 * @description Test class the Apex Big Object Logger (writes to Application Log and Big Object)
 * @group Common Test Layer
 */
@isTest
private class accc_ApexBigObjectLoggerTest {

	/**********************************************************
	 *
	 * Use for Testing
	 */
	public without sharing class accc_SObjectBaseWriterStub extends accc_SObjectBaseWriter {

		public accc_SObjectBaseWriterStub(List<Sobject> entries) { super(entries);}

		protected override accc_GenericDbResultHandler  performDatabaseOperation() {

			return new accc_GenericDbResultHandler(new List<Database.SaveResult> {(Database.SaveResult)JSON.deserialize('{"success":false,"errors":[{"message":"You fool what are you doing...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}',
			                                       Database.SaveResult.class)
			                                                                     });
		}
	}// end of accc_SObjectBaseWriterStub

	/**********************************************************
	 *
	 * Use for Testing
	 */
	public without sharing class accc_ApexBigObjectLoggerStub extends accc_ApexBigObjectLogger {

		public List<SObject> ResultsWritten { get; set;}
		public accc_ApexBigObjectLoggerStub() { super();}
		public accc_ApexBigObjectLoggerStub(System.LoggingLevel  lvl) {super(lvl); this.ResultsWritten = null;}

		protected override accc_SObjectBaseWriter getWriter(List<SObject> entries) {
			this.ResultsWritten = entries;
			return new accc_SObjectBaseWriterStub(entries);
		}

	}// end of accc_ApexBigObjectLoggerStub

	///////////////////////////////////////////////////////////////////////////////////////////
	//
	// Start of Tests
	///////////////////////////////////////////////////////////////////////////////////////////

	@isTest
	static void testDefaultCtor() {
		final String value = 'data';
		Test.startTest();
		accc_ApexBigObjectLoggerStub logger = new accc_ApexBigObjectLoggerStub();
		Test.stopTest();
		System.assertEquals(LoggingLevel.DEBUG, logger.logLevel());

		System.assertEquals(null, logger.lastMessage());

	} // end of testDefaultCtor

	@isTest
	static void testCtor() {
		final String value = 'data';
		Test.startTest();
		accc_ILogger logger = new accc_ApexBigObjectLoggerStub();

		logger.write(value);
		Test.stopTest();
		System.assertEquals(true, logger.lastMessage().contains(value));

	} // end of testCtor
	@isTest
	static void testsetLastMessage() {
		final String value = 'data';
		Test.startTest();
		accc_ApexBigObjectLoggerStub logger = (accc_ApexBigObjectLoggerStub)accc_ApexBigObjectLoggerTest.getLogger(LoggingLevel.DEBUG);

		logger.setLastMessage(LoggingLevel.ERROR, value);
		Test.stopTest();
		System.assertEquals(true, logger.lastMessage().contains(value));

	} // end of testsetLastMessage

	@isTest
	static void testCtorCheckLogLevel() {
		final String value = 'data';
		Test.startTest();
		accc_ILogger logger = accc_ApexBigObjectLoggerTest.getLogger(LoggingLevel.ERROR);
		Test.stopTest();
		System.assertEquals(LoggingLevel.ERROR, logger.logLevel());

	} // end of testCtorCheckLogLevel


	@isTest
	static void testwriteWithTrueSendLogger() {
		final String value = 'data';
		Test.startTest();
		accc_ApexBigObjectLoggerStub logger = (accc_ApexBigObjectLoggerStub)accc_ApexBigObjectLoggerTest.getLogger(LoggingLevel.ERROR);
		logger.write(LoggingLevel.DEBUG, value, true);
		Test.stopTest();
		System.assertEquals(true, logger.lastMessage().contains(value));
	}// end of testwriteWithTrueSendLogger

	@isTest
	static void testwriteWithFalseSendLogger() {
		final String value = 'data';
		Test.startTest();
		accc_ApexBigObjectLoggerStub logger = (accc_ApexBigObjectLoggerStub)accc_ApexBigObjectLoggerTest.getLogger(LoggingLevel.ERROR);
		logger.write(LoggingLevel.DEBUG, value, false);
		Test.stopTest();
		System.assertEquals(true, logger.lastMessage().contains(value));
	}// end of testwriteWithFalseSendLogger

	@isTest
	static void testwriteWithArraySendLogger() {
		final String lastValue = 'data3';
		final List<String> values = new List<String> {
			'data',
			'data2',
			lastValue
		};
		Test.startTest();
		accc_ApexBigObjectLoggerStub logger = (accc_ApexBigObjectLoggerStub)accc_ApexBigObjectLoggerTest.getLogger(LoggingLevel.ERROR);
		logger.write(LoggingLevel.DEBUG, values, false);
		Test.stopTest();
		System.assertEquals(true, logger.lastMessage().contains(lastValue));
		System.assertEquals(true,  (List<accc_Org_Events__b>)logger.ResultsWritten==null);

	}// end of testwriteWithArraySendLogger
	@isTest
	static void testwriteWithArraySendLoggerWith2Params() {
		final String lastValue = 'data3';
		final List<String> values = new List<String> {
			'data',
			'data2',
			lastValue
		};
		Test.startTest();
		accc_ApexBigObjectLoggerStub logger = (accc_ApexBigObjectLoggerStub)accc_ApexBigObjectLoggerTest.getLogger(LoggingLevel.ERROR);
		logger.write(LoggingLevel.DEBUG, values);
		Test.stopTest();
		System.assertEquals(true, logger.lastMessage().contains(lastValue));
		System.assertEquals(true, accc_ApexBigObjectLoggerTest.isBigObjectCorrect(String.join(values, ','), (List<accc_Org_Events__b>)logger.ResultsWritten));

	}// end of testwriteWithArraySendLoggerWith2Params

	@isTest
	static void testwriteWithArraySingleParam() {
		final String lastValue = 'data3';
		final List<String> values = new List<String> {
			'data',
			'data2',
			lastValue
		};
		Test.startTest();
		 
		accc_ApexBigObjectLoggerStub logger = (accc_ApexBigObjectLoggerStub)accc_ApexBigObjectLoggerTest.getLogger(LoggingLevel.DEBUG);
		logger.write(values);
		Test.stopTest();
		System.assertEquals(true, logger.lastMessage().contains(lastValue));
		System.assertEquals(true, logger.lastMessage().contains(LoggingLevel.DEBUG.name()));
		
	}// end of testwriteWithArraySingleParam

	@isTest
	static void testwriteWithNoSendLogger() {
		final String value = 'data';
		Test.startTest();
		accc_ApexBigObjectLoggerStub logger = (accc_ApexBigObjectLoggerStub)accc_ApexBigObjectLoggerTest.getLogger(LoggingLevel.ERROR);
		logger.write(LoggingLevel.DEBUG, value);
		Test.stopTest();

		System.assertEquals(true, logger.lastMessage().contains(value));
		System.assertEquals(true, accc_ApexBigObjectLoggerTest.isBigObjectCorrect(value, (List<accc_Org_Events__b>)logger.ResultsWritten));

	}// end of testwriteWithNoSendLogger

	@isTest
	static void testwriteWithListArray() {
		final List<Object> values = new List<Object> {'data', 'two'};
		Test.startTest();
		accc_ApexBigObjectLoggerStub logger = (accc_ApexBigObjectLoggerStub)accc_ApexBigObjectLoggerTest.getLogger(LoggingLevel.ERROR);
		logger.write(LoggingLevel.DEBUG, values);
		Test.stopTest();

		System.assertEquals(true, logger.lastMessage().contains('two'));
		System.assertEquals(true, accc_ApexBigObjectLoggerTest.isBigObjectCorrect(String.join(values, ','), (List<accc_Org_Events__b>)logger.ResultsWritten));
	}// end of testwriteWithListArray

	@isTest
	static void testgetWriter() {

		Test.startTest();
		accc_ApexBigObjectLogger logger = new accc_ApexBigObjectLogger(LoggingLevel.ERROR);

		accc_SObjectBaseWriter writer = logger.getWriter(null);

		Test.stopTest();

		System.assertEquals(true, writer != null);
	}// end of testgetWriter

	@isTest
	static void testWriterForceException() {

		Test.startTest();
		accc_ApexBigObjectLogger.m_forceException=true;
		accc_ApexBigObjectLogger logger = new accc_ApexBigObjectLogger(LoggingLevel.ERROR);

		logger.write(LoggingLevel.DEBUG, 'test');

		Test.stopTest();

		System.assertEquals(true, accc_ApexUtilities.containsInTestLog(accc_ApexBigObjectLogger.EXCEPTION_MSG_FOR_TEST));
	}// end of testWriterForceException


	//////////////////////////////////////////////////////////////////////////////////
	// PRIVATE METHODS
	//////////////////////////////////////////////////////////////////////////////////

	private static Boolean isBigObjectCorrect(String json, List<accc_Org_Events__b> item ) {
		return
		    item[0].Event_Date_Day__c == Datetime.now().day() &&
		    item[0].Event_Date_Month__c == Datetime.now().month() &&
		    item[0].Event_Date_Year__c == Datetime.now().year() &&
		    item[0].Event_Json__c == json  ;
	}
	//
	// get the logger ... can be changed to pull from the test environment (if needed)
	//
	private static accc_ILogger getLogger(LoggingLevel loglevel) {
		return new accc_ApexBigObjectLoggerStub(logLevel);
	} // end of getLogger


}// end of accc_ApexBigObjectLoggerTest