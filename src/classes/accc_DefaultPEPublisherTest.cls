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
 * @description defines the default publisher tests
 * @group Test Layer
 */
@isTest
private class accc_DefaultPEPublisherTest {
	static final String ExceptedEventLabelInCustomMDT = 'pe_test__e';

	//
	// test class used to excercise the default behavior
	//
	public class accc_PublisherTest extends accc_DefaultPEPublisher {
		public Boolean didHandle = false;
		public Boolean causeException = false;

		public accc_PublisherTest() {
			super(null);
		}
		public accc_PublisherTest(string evt) {

			super(evt);

		}
		public accc_PublisherTest(string evt, Boolean serialize) {

			super(evt, serialize);

		}
		protected override void handleCompletion(Object event
		        , Boolean state
		        , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult
		        , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theData
		        , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData
		        , accc_PlatformEventAttrs attributes) {
			didHandle = true;
		}
		protected override integer processResults(List<Database.SaveResult> results,
		        List<SObject>  collectionOfEvents,
		        List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult) {
			integer count = results.size();
			if ( causeException ) {
				throw new accc_PlatformEventException('For Testing');
			}
			return count;
		}

	}
	@isTest
	static void testBasicPublisherCtor() {
		// assign / act
		accc_PublisherTest publisher = new accc_PublisherTest();
		// assert
		System.assertEquals(true, publisher.handlerEventName() == null);

	}
	@isTest
	static void testBasicPublisherCtorWithTwoArguments() {
		// assign / act
		accc_PublisherTest publisher = new accc_PublisherTest(ExceptedEventLabelInCustomMDT, true);
		// assert
		System.assertEquals(true, publisher.handlerEventName() == ExceptedEventLabelInCustomMDT);
		System.assertEquals(true, publisher.serializeEvent);

	}
	@isTest
	static void testBasicPublisher() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		Boolean result;
		accc_PlatformEvtBuilder ctor = new accc_PlatformEvtBuilder(eventName,accc_ApexConstants.TEST_CATEGORY);
		accc_IEventHandler publisher = ctor.buildPublisher();
		List<SObject> evt = new List<SObject> { new pe_test__e()};
		accc_DefaultProcessEventHandlers handlers = new accc_DefaultProcessEventHandlers();
		accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs();

		Test.startTest();
		// act
		// Publish test event
		result = publisher.process(evt, handlers, attrs);
		Test.getEventBus().deliver();
		Test.stopTest();

		// assert Verify results value
		System.assertEquals(true, result);
		System.assertEquals(true, publisher.handlerException() == null);
		System.assertEquals(true, publisher.handlerEventName() != null);

	} // end of testBasicPublisher

	@isTest
	static void testPublisherTest() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		Boolean result;
		accc_PublisherTest publisher = new accc_PublisherTest(eventName);
		accc_DefaultProcessEventHandlers handlers = new accc_DefaultProcessEventHandlers();
		List<SObject> evt = new List<SObject> { new pe_test__e()};
		accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs();

		Test.startTest();
		// act - Publish test event
		result = publisher.process(evt, handlers, attrs);
		Test.getEventBus().deliver();
		Test.stopTest();

		// assert -- Verify SaveResult value
		System.assertEquals(true, result);
		System.assertEquals(true, publisher.eventName == eventName);
		System.assertEquals(true, publisher.didHandle);
		System.assertEquals(true, publisher.theException == null);
	} // end of testPublisherTest

	@isTest
	static void testPublisherTestNoEvent() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		Boolean result;
		accc_PublisherTest publisher = new accc_PublisherTest(eventName);
		accc_DefaultProcessEventHandlers handlers = new accc_DefaultProcessEventHandlers();
		List<SObject> evt = new List<SObject> { };
		accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs();

		Test.startTest();
		try {
			// act -- Publish test event
			result = publisher.process(evt, handlers, attrs);
			Test.getEventBus().deliver();
		} catch (Exception excp) {
			result = false;
		}
		Test.stopTest();

		// assert --Verify results
		System.assertEquals(false, result);
		System.assertEquals(true, publisher.eventName == eventName);
		System.assertEquals(true, publisher.theException != null);
		System.assertEquals(false, publisher.didHandle);
	}// end of testPublisherTestNoEvent

	@isTest
	static void testPublisherTestEventButDifferentName() {
		// assign
		final String eventName = 'junk';
		Boolean result = true;
		accc_PublisherTest publisher = new accc_PublisherTest(eventName);
		accc_DefaultProcessEventHandlers handlers = new accc_DefaultProcessEventHandlers();
		List<SObject> evt = new List<SObject> { new pe_test__e()};
		accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs();

		Test.startTest();
		try {
			// act -- Publish test event
			result = publisher.process(evt, handlers, attrs);
			Test.getEventBus().deliver();
		} catch (Exception excp) {
			result = false;
		}
		Test.stopTest();

		// assert -- Verify results
		System.assertEquals(false, result); 
		System.assertEquals(true, publisher.eventName == eventName);
		System.assertEquals(false, publisher.theException == null);
		System.assertEquals(false, publisher.didHandle);
	} // end of testPublisherTestEventButDifferentName

	@isTest
	static void testPublisherTestWithException() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		Boolean result = true, exceptionOccurred = false;
		accc_PublisherTest publisher = new accc_PublisherTest(eventName);

		accc_DefaultProcessEventHandlers handlers = new accc_DefaultProcessEventHandlers();
		List<SObject> evt = new List<SObject> { new pe_test__e()};
		accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs();

		Test.startTest();
		try {
			publisher.causeException = true;
			// act -- Publish test event
			result = publisher.process(evt, handlers, attrs);
			Test.getEventBus().deliver();
		} catch (accc_PlatformEventException pexcp) {
			exceptionOccurred = true;
		} catch (Exception excp) {
			result = false;
		}
		Test.stopTest();

		// assert -- Verify results
		System.assertEquals(true, result);
		System.assertEquals(true, publisher.eventName == eventName);
		System.assertEquals(true, publisher.theException != null);
		System.assertEquals(true, exceptionOccurred);
	} // end of testPublisherTestWithException

	@isTest
	static void testprocessResults() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		Boolean result = true, exceptionOccurred = false;
		integer expected = 1;
		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult = new  List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		// Create two accounts, assuming the NAME is all that is required;
		// otherwise, this db insert is incorrect.

		accc_DefaultPEPublisher publisher = new accc_DefaultPEPublisher(eventName);

		// the goal is to have success and the count be equl to the results size (2) [as no errors]
		List<Account> sobjects = new List<Account> {
			new Account(Name = 'we'),
			new Account()
		};

		Database.SaveResult[] db_results = Database.insert(sobjects, false);

		integer count = publisher.processResults(db_results,sobjects, errResult);

		System.assertEquals(expected, count);
		count = publisher.processResults(db_results,sobjects, null);

		System.assertEquals(expected, count);


	} // end of testprocessResults

}