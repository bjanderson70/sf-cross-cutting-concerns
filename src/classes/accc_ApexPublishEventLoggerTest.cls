/**
 * Copyright (c) 2016-2018, Bill Anderson. All rights reserved.
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
 * @description Test Publishing Log events
 * @group Common Test Layer
 */
@isTest
private class accc_ApexPublishEventLoggerTest {

	@isTest
	static void testValidLogEvent() {

		// Create a test event instance

		Log__e logEvt = new Log__e(LogCode__c = 'debug',
		                           Message__c = 'message',
		                           Username__c = UserInfo.getUserId());


		Test.startTest();
		// Publish log event
		Database.SaveResult sr = EventBus.publish(logEvt);
		Test.stopTest();

		// assert
		System.assertEquals(true, sr.isSuccess());

	} // end of testValidLogEvent


	@isTest
	static void testpublishLogEvent() {
		accc_ApexPublishEventLogger apel = new accc_ApexPublishEventLogger();
		LoggingLevel level = LoggingLevel.DEBUG;
		Object message = 'message';
		// Create a test event instance
		Test.startTest();
		boolean result = apel.publishLogEvent( level, message);
		Test.stopTest();

		// assert
		System.assertEquals(true, result);

	} // end of testpublishLogEvent


	@isTest
	static void testwrite() {
		accc_ApexPublishEventLogger apel = new accc_ApexPublishEventLogger();
		LoggingLevel level = LoggingLevel.DEBUG;
		Object message = 'my message';

		// Create a test event instance
		Test.startTest();
		apel.write(level, message);
		Test.stopTest();

		// assert
		System.assertEquals(true, apel.lastMessage().contains('my message') );

	} // end of testwrite

	@isTest
	static void testwriteWithArray() {
		accc_ApexPublishEventLogger apel = new accc_ApexPublishEventLogger();
		LoggingLevel level = LoggingLevel.DEBUG;
		List<Object> messages = new List<Object> {
			'my message',
			'my message2',
			'my message3'
		};

		// Create a test event instance
		Test.startTest();
		apel.write(level, messages);
		Test.stopTest();

		// assert
		System.assertEquals(true, apel.lastMessage().contains('my message3') );

	} // end of testwriteWithArray

} // end of accc_ApexPublishEventLoggerTest