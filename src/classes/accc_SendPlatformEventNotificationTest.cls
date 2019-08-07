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
 * @author Bill Anderson
 * @description testing to send out a Platform Event (queuable)
 * @group Data
 */
@isTest
private class accc_SendPlatformEventNotificationTest {

	static final integer SIZE = 50;
	
	@isTest
	static  void testQueueable() {

		// get event data
		List<SObject> events = accc_SendPlatformEventNotificationTest.createEvents(SIZE);
		Test.startTest();
		Test.enableChangeDataCapture();
		// Create our Queueable instance
		accc_SendPlatformEventNotification sender = new accc_SendPlatformEventNotification(events);
		// startTest/stopTest block to force async processes to run
		
		ID jobId = System.enqueueJob(sender);
 
		Test.getEventBus().deliver();
		Test.stopTest();
		// Validate the job ran.
		AsyncApexJob job = [select Status, NumberOfErrors from AsyncApexJob where Id = :jobId];
		System.assertEquals('Completed', job.Status);
		System.assertEquals(0, job.NumberOfErrors);
		System.assertEquals(SIZE, sender.m_entries.size());
	}


	@isTest
	static  void testBadCtorParameterOne() {

		Exception myException = null;
		// get event data
		List<SObject> events = accc_SendPlatformEventNotificationTest.createEvents(SIZE);
		try {
			// Create our Queueable instance
			accc_SendPlatformEventNotification sender = new accc_SendPlatformEventNotification(null);
		} catch (Exception excp) {
			myException = excp;
		}

		// Validate the job ran.
		System.assertEquals(true, myException != null);

	}

	@isTest
	static  void testBadCtorParameterTwo() {

		// get event data
		List<SObject> events = accc_SendPlatformEventNotificationTest.createEvents(SIZE);

		// Create our Queueable instance
		// startTest/stopTest block to force async processes to run
		Test.startTest();
		Test.enableChangeDataCapture();
		accc_SendPlatformEventNotification sender = new accc_SendPlatformEventNotification(events, null);
		ID jobId = System.enqueueJob(sender);

		Test.getEventBus().deliver();
		Test.stopTest();
		// Validate the job ran.
		AsyncApexJob job = [select Status, NumberOfErrors from AsyncApexJob where Id = :jobId];
		System.assertEquals('Completed', job.Status);
		System.assertEquals(0, job.NumberOfErrors);
		System.assertEquals(SIZE, sender.m_entries.size());
		System.assertEquals(true, sender.m_environment == accc_ApexConstants.PRODUCTION_CATEGORY);

	}
	@isTest
	static  void testBadCtorParameterTwoWithName() {
		Exception myException = null;
		// Create our Queueable instance
		try {
			// Create our Queueable instance
			accc_SendPlatformEventNotification sender = new accc_SendPlatformEventNotification(null, 'pe_test__e');
		} catch (Exception excp) {
			myException = excp;
		}

		// Validate the job ran.
		System.assertEquals(true, myException != null);

	}
	@isTest
	static  void testBadCtorParameterThree() {

		// startTest/stopTest block to force async processes to run
		Test.startTest();

		
		Test.enableChangeDataCapture();
		// get event data

		List<SObject> events = accc_SendPlatformEventNotificationTest.createEvents(SIZE + 1);

		// Create our Queueable instance
		accc_SendPlatformEventNotification sender = new accc_SendPlatformEventNotification(events, null, accc_ApexConstants.DEBUG_CATEGORY);
		ID jobId = System.enqueueJob(sender);
		Test.getEventBus().deliver();
		Test.stopTest();
		// Validate the job ran.
		AsyncApexJob job = [select Status, NumberOfErrors from AsyncApexJob where Id = :jobId];
		System.assertEquals('Completed', job.Status);
		System.assertEquals(0, job.NumberOfErrors);
		System.assertEquals(SIZE + 1, sender.m_entries.size());
		System.assertEquals(true, sender.m_environment == accc_ApexConstants.DEBUG_CATEGORY);

	}

	static List<SObject> createEvents(integer count) {
		List<SObject> pe_events = new List<pe_test__e>();

		// add 100 child accounts
		for (Integer inx = 0; inx < count; inx++) {
			pe_events.add(new pe_test__e());
		}
		return pe_events;
	} // end of createEvents

} // end of accc_SendPlatformEventNotificationTest