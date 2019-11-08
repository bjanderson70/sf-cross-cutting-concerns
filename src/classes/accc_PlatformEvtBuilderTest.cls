/**
 * Copyright (c) 2016-2019, Bill Anderson.
 * All rights reserved.
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
 * @description platform event publisher/consumer builder Tests
 * NOTE: This class does too much -- refactor!
 * @group Test Layer
 */

@isTest
private class accc_PlatformEvtBuilderTest {
	// This test event MUST BE PRESENT
	static final String ExceptedEventLabelInCustomMDT = 'pe_test__e';

	@isTest
	static void testctorWithEvent() {
		// assign
		final String eventName = '*no_event_e';
		// act
		accc_PlatformEvtBuilder ctor = new accc_PlatformEvtBuilder(eventName);
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(eventName, ctor.eventName);
		System.assertEquals(accc_ApexConstants.PRODUCTION_CATEGORY, ctor.eventEnvironment );
		System.assertEquals(true, ctor.validEventName);
		System.assertEquals(true, ctor.m_elements != null);
	}
	@isTest
	static void testctorWithEventAndEnv() {
		// assign
		final String eventName = '*still_no_event_e';
		// act
		accc_PlatformEvtBuilder ctor = new accc_PlatformEvtBuilder(eventName, accc_ApexConstants.DEBUG_CATEGORY);
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(eventName, ctor.eventName);
		System.assertEquals(accc_ApexConstants.DEBUG_CATEGORY, ctor.eventEnvironment );
		System.assertEquals(true, ctor.validEventName);
		System.assertEquals(true, ctor.m_elements != null);
	}
	@isTest
	static void testctorWithValidEvent() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		// act
		accc_PlatformEvtBuilder ctor = new accc_PlatformEvtBuilder(eventName);
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(eventName, ctor.eventName);
		System.assertEquals(accc_ApexConstants.PRODUCTION_CATEGORY, ctor.eventEnvironment );
		System.assertEquals(false, ctor.validEventName);
		// Note, it will ALWAYS attempts to create elements, if none are found
		// bec/ the USER/ADMIN did not populate entries in the custom metadata type
		System.assertEquals(true, ctor.m_elements != null);
	}

	@isTest
	static void testctorWithValidEventAndEnv() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		// act
		accc_PlatformEvtBuilder ctor = new accc_PlatformEvtBuilder(eventName, accc_ApexConstants.DEBUG_CATEGORY);
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(eventName, ctor.eventName);
		System.assertEquals(accc_ApexConstants.DEBUG_CATEGORY, ctor.eventEnvironment );
		System.assertEquals(false, ctor.validEventName);
		System.assertEquals(true, ctor.eventActive);
		// Note, it will ALWAYS attempts to create elements, if none are found
		// bec/ the USER/ADMIN did not populate entries in the custom metadata type
		System.assertEquals(true, ctor.m_elements != null);
	}


	@isTest
	static void testbuildConsumer() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		accc_PlatformEvtBuilder ctor = new accc_PlatformEvtBuilder(eventName, accc_ApexConstants.TEST_CATEGORY);
		// act
		accc_IEventHandler consumer = ctor.buildConsumer();
		Boolean result = consumer instanceof accc_DefaultPEConsumer;
		// assert
		System.assertEquals(true, consumer != null);
		// Note, there are  elements bec/ the expected event is defined for the Test, not Prod, environment
		System.assertEquals(true, ctor.m_elements != null);
		System.assertEquals(true, result);
	}

	@isTest
	static void testbuildPublisher() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		accc_PlatformEvtBuilder ctor = new accc_PlatformEvtBuilder(eventName, accc_ApexConstants.TEST_CATEGORY);
		// act
		accc_IEventHandler publisher = ctor.buildPublisher();
		Boolean result = publisher instanceof accc_DefaultPEPublisher;
		// assert
		System.assertEquals(true, publisher != null);
		System.assertEquals(true, result);
	}

	@isTest
	static void testbuildConsumerWithBadEvent() {
		// assign
		final String eventName =  'bad_event';
		Boolean result = false;
		accc_PlatformEvtBuilder ctor = new accc_PlatformEvtBuilder(eventName, accc_ApexConstants.TEST_CATEGORY);
		accc_IEventHandler consumer = null;
		try {
			consumer = ctor.buildConsumer();
			// act
			ctor.build(consumer);
		} catch (accc_PlatformEventException excp) {
			result = true;
		}
		// assert
		System.assertEquals(true, result);
	}

	@isTest
	static void testbuildPublisherWithBadEvent() {
		// assign
		final String eventName =  'bad_event';
		Boolean result = false;
		accc_PlatformEvtBuilder ctor = new accc_PlatformEvtBuilder(eventName, accc_ApexConstants.TEST_CATEGORY);
		accc_IEventHandler publisher = null;
		try {
			publisher = ctor.buildPublisher();
			// act
			ctor.build(publisher);
		} catch (accc_PlatformEventException excp) {
			result = true;
		}
		// assert
		System.assertEquals(true, result);
	}

	@isTest
	static void testbuildPublisherWithBadEventAndNoCheckEventAttr() {
		// assign
		final String eventName =  'bad_event';
		Map<String, Object> attributes = new Map<String, Object> {
			accc_PlatformEventAttrs.CHECK_EVENT_NAME_s => false
		};
		accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
		Boolean result = true;
		accc_PlatformEvtBuilder ctor = new accc_PlatformEvtBuilder(eventName, accc_ApexConstants.TEST_CATEGORY);
		accc_IEventHandler publisher = ctor.buildPublisher();
		try {
			// act
			ctor.build(publisher, attrs);
		} catch (accc_PlatformEventException excp) {
			result = false;
		}
		// assert
		System.assertEquals(true, result);
	}

	@isTest
	static void testbuild() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		accc_PlatformEvtBuilder ctor = new accc_PlatformEvtBuilder(eventName, accc_ApexConstants.TEST_CATEGORY);
		accc_IEventHandler publisher = ctor.buildPublisher();
		// act
		accc_IPlatformEventModel model = ctor.build();
		accc_IProcessEventHandlers handlers = model.processHandlers();
		Boolean result = model.eventHandler() instanceof accc_DefaultPEPublisher;
		Exception excp = model.getException();
		// assert
		System.assertEquals(true, publisher != null);
		System.assertEquals(true, result);
		System.assertEquals(true, handlers != null);
		System.assertEquals(true, excp == null);

	}// end of testbuild

	@isTest
	static void testbuildWithAttributes() {

		// assign
		final String eventName =  'bad_event';
		Map<String, Object> attributes = new Map<String, Object> {
			accc_PlatformEventAttrs.CHECK_EVENT_NAME_s => false
		};
		accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
		accc_PlatformEvtBuilder ctor = new accc_PlatformEvtBuilder(eventName, accc_ApexConstants.TEST_CATEGORY);
		// act
		accc_IPlatformEventModel model = ctor.build(attrs);
		accc_IProcessEventHandlers handlers = model.processHandlers();

		Exception excp = model.getException();
		// assert
		System.assertEquals(true, handlers != null);
		System.assertEquals(true, excp == null);

	}// end of testbuildWithAttributes

}