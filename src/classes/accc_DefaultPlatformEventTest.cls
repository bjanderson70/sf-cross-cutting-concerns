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
 * @description defines the platform event test
 * @group Test Layer
 */
@isTest
private class accc_DefaultPlatformEventTest {

	@isTest
	static void testCtor() {
		// assign / act
		accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
		// assert
		system.assertEquals(true, dpe != null);
		system.assertEquals(true, dpe.eventName == null);
		system.assertEquals(true, dpe.canLogSuccess == false);
		system.assertEquals(true, dpe.canLog == false);
		system.assertEquals(true, dpe.canLogError == false);
		system.assertEquals(true, dpe.serializeEvent == true);
		system.assertEquals(true, dpe.willInstrument == false);
		system.assertEquals(true, dpe.getLastReplayId() == null);
		system.assertEquals(true, dpe.eventBatchSize == accc_PlatformEventAttrs.DEFAULT_EVENT_BATCH_SIZE);
	}
	@isTest
	static void testCtorWithEventName() {
		// assign / act
		final String ename = 'junk-name';
		accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent(ename);
		// assert
		system.assertEquals(true, dpe != null);
		system.assertEquals(true, dpe.eventName != null);
		system.assertEquals(true, dpe.canLogSuccess == false);
		system.assertEquals(true, dpe.canLog == false);
		system.assertEquals(true, dpe.canLogError == false);
		system.assertEquals(true, dpe.serializeEvent == true);
		system.assertEquals(true, dpe.willInstrument == false);
		system.assertEquals(true, dpe.handlerEventName() == ename);
	}
	@isTest
	static void testCtorWithEventNameAndSerialize() {
		// assign / act
		final String ename = 'junk-name';
		accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent(ename, true);
		// assert
		system.assertEquals(true, dpe != null);
		system.assertEquals(true, dpe.eventName != null);
		system.assertEquals(false, dpe.canLogSuccess);
		system.assertEquals(false, dpe.canLog);
		system.assertEquals(false, dpe.canLogError );
		system.assertEquals(true, dpe.serializeEvent );
		system.assertEquals(true, dpe.isEventActive );
		system.assertEquals(true, dpe.handlerIsActive());
		system.assertEquals(false, dpe.willInstrument);
		system.assertEquals(true, dpe.handlerEventName() == ename);
		system.assertEquals(true, dpe.handlerException() == null);
		dpe.handlerEventName('new');
		system.assertEquals(true, dpe.handlerEventName() == 'new');
		dpe.handlerToSerialize(false);
		system.assertEquals(false, dpe.serializeEvent );
	}
	@isTest
	static void testprocessWithNullValues() {
		// assign
		accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
		Boolean exceptionFired = false;
		try {
			// act
			dpe.process(null, null, null);
		} catch ( accc_PlatformEventException excp) {
			exceptionFired = true;

		}
		// assert
		system.assertEquals(true, exceptionFired);
	}

	@isTest
	static void testprocessWithValidValues() {
		// assign
		Boolean result = true;
		List<SObject> events = new List<SObject> { new pe_test__e()};
		accc_IProcessEventHandlers handlers = new accc_DefaultProcessEventHandlers();
		accc_PlatformEventAttrs attributes = new accc_PlatformEventAttrs ();
		accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
		accc_DefaultPlatformEvent.DO_NOT_SET_CHECKPOINT = true;
		Boolean exceptionFired = false;
		try {
			// act
			result = dpe.process(events, handlers, attributes);
		} catch ( accc_PlatformEventException excp) {
			exceptionFired = true;

		}
		// assert
		system.assertEquals(false, exceptionFired);
		system.assertEquals(true, result);
		// by default replay ids are not set for 'accc_DefaultPlatformEvent' only in the consumer
		system.assertEquals(true, dpe.getLastReplayId() == null);
		system.assertEquals(false, dpe.updateCheckPoint());
		system.assertEquals(true, dpe.operationIds.size()==1);
		
	} // end of testprocessWithValidValues

	@isTest
	static void testprocessWithInValidEventName() {
		// assign
		Boolean result = false;
		final String eventName = 'bad_pe_test__e';
		List<SObject> events = new List<SObject> { new pe_test__e()};
		accc_IProcessEventHandlers handlers = new accc_DefaultProcessEventHandlers();
		accc_PlatformEventAttrs attributes = new accc_PlatformEventAttrs ();
		accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent(eventName);
		Boolean exceptionFired = false;
 
		try {
			// act
			result = dpe.process(events, handlers, attributes);
		} catch ( accc_PlatformEventException excp) {
			exceptionFired = true;
		}
		// assert
		system.assertEquals(true, exceptionFired);
		system.assertEquals(false, result);
	} // end of testprocessWithInValidEventName

	@isTest
	static void testprocessWithEmptyData() {
		// assign
		Boolean exceptionCaught = false;
		Map<String, Object> attributes = new Map<String, Object> {
			accc_PlatformEventAttrs.SERIALIZE_EVENTS_s => false
			, accc_PlatformEventAttrs.EVENT_LOGGING_s => accc_PlatformEventAttrs.EventLogging.ALL
			, accc_PlatformEventAttrs.RETRY_COUNT_s => accc_PlatformEventAttrs.DEFAULT_RETRY_COUNT
			, accc_PlatformEventAttrs.CHECK_EVENT_NAME_s => true
			, accc_PlatformEventAttrs.ADD_INSTRUMENTATION_s => true
		};

		accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
		accc_DefaultProcessEventHandlers handlers = new accc_DefaultProcessEventHandlers();
		accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
		try {
			// act
			dpe.process(new List<Account>(), handlers, attrs);
		} catch (accc_PlatformEventException excp) {
			exceptionCaught = true;
		}
		// assert
		system.assertEquals(true, dpe != null);
		system.assertEquals(true, exceptionCaught == true);

	}
	@isTest
	static void testErrorResultPOAC() {
		// assign
		accc_DefaultPlatformEvent.ErrorResultPOAC ctor1 = new accc_DefaultPlatformEvent.ErrorResultPOAC('error1');
		accc_DefaultPlatformEvent.ErrorResultPOAC ctor2 = new accc_DefaultPlatformEvent.ErrorResultPOAC(StatusCode.ALREADY_IN_PROCESS, 'error2');

		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> results = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> {
			new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('thename')
			, new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('thename', 'thedata')
			, new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('thename', 'thedata', 'misc')
			, new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('thename', 'thedata', 'misc', 10)
		};
		// assert
		system.assertEquals(true, ctor1.Message == 'error1');
		system.assertEquals(true, ctor2.Message == 'error2');
		system.assertEquals(true, ctor2.Code == StatusCode.ALREADY_IN_PROCESS);
		system.assertEquals(true, ctor1.Code == StatusCode.INVALID_STATUS);
		// assert
		for (accc_DefaultPlatformEvent.PlatformEvtResultPOAC poac : results) {
			String data = poac.toString();
			system.assertEquals(true, data.contains('thename'));
			system.assertEquals(true, data.contains('Misc='));

		}
	}
	@isTest
	static void testHandlers() {
		// act
		accc_IProcessEventHandlers handlers = new accc_DefaultProcessEventHandlers();
		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> data = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		accc_PlatformEventAttrs attributes = new accc_PlatformEventAttrs();
		Boolean hasException = false;
		Boolean success;

		accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
		// act
		success = dpe.logSuccess(handlers, data, attributes) == true &&
		          dpe.errorHandler(handlers, data, attributes) == true  &&
		          dpe.logHandler(handlers, data, attributes) == true  &&
		          dpe.alertHandler(handlers, data, attributes) == true ;

		hasException = dpe.logSuccess(null, data, attributes) == false &&
		               dpe.errorHandler(null, data, attributes) == false &&
		               dpe.logHandler(null, data, attributes) == false &&
		               dpe.alertHandler(null, data, attributes) == false;
		// assert
		system.assertEquals(true, success);
		system.assertEquals(true, hasException);
	}
	@isTest
	static void testcallHandler() {
		// act
		accc_IProcessEventHandler handler = new accc_DefaultProcessHandler();
		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> data = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		accc_PlatformEventAttrs attributes = new accc_PlatformEventAttrs();
		Boolean result;
		try {
			// act
			accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
			result = dpe.callHandler(handler, data, attributes);

		} catch (Exception excp) {
			result = false;
		}
		// assert
		system.assertEquals(true, result);
	}
	@isTest
	static void testcallHandlerWithBadData() {
		// assign
		Boolean hasException ;

		accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
		// act
		hasException = dpe.callHandler(null, null, null);
		// assert
		system.assertEquals(false, hasException);
	}
	@isTest
	static void testaddInstrumentationWithNoAdd() {
		// assign
		Boolean hasException = false;
		accc_DefaultPlatformEvent.PlatformEvtResultPOAC data = new accc_DefaultPlatformEvent.PlatformEvtResultPOAC ('thename');
		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData = new  List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();

		try {
			// act
			accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
			dpe.addInstrumentation(false, data, theLogData);

		} catch (Exception excp) {
			hasException = true;
		}
		// assert
		system.assertEquals(true, theLogData.size() == 0);
	}
	@isTest
	static void testaddInstrumentationWithGoodData() {
		// assign
		Boolean hasException = false;
		accc_DefaultPlatformEvent.PlatformEvtResultPOAC data = new accc_DefaultPlatformEvent.PlatformEvtResultPOAC ('thename');
		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData = new  List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();

		try {
			// act
			accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
			dpe.addInstrumentation(true, data, theLogData);

		} catch (Exception excp) {
			hasException = true;
		}
		// assert
		system.assertEquals(true, theLogData.size() == 1);
	}
	@isTest
	static void testaddInstrumentationWithBadData() {
		// assign
		Boolean hasException = false;

		try {
			// act
			accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
			dpe.addInstrumentation(true, null, null);

		} catch (Exception excp) {
			hasException = true;
		}
		// assert
		system.assertEquals(true, hasException == false);
	}
	@isTest
	static void testretryTriggerTest() {
		// assign
		Boolean hasException = false;

		try {
			// act
			accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
			dpe.retryRequired = true;
			dpe.retryTriggerIfNecessary();

		} catch ( EventBus.RetryableException excp) {
			hasException = true;
		}
		// assert
		system.assertEquals(true, hasException == true);
	}
	@isTest
	static void testretryTriggerWithNoRetryTest() {
		// assign
		Boolean hasException = false;

		try {
			// act
			accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
			dpe.retryRequired = false;
			dpe.retryTriggerIfNecessary();

		} catch ( EventBus.RetryableException excp) {
			hasException = true;
		}
		// assert
		system.assertEquals(true, hasException == false);
	}

	@isTest
	static void testhandlerRequiredRetryTest() {
		// assign
		Boolean hasException = false, result = true;

		try {
			// act
			accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
			dpe.retryRequired = false;
			result = dpe.handlerRequiredRetry();

		} catch ( EventBus.RetryableException excp) {
			hasException = true;
		}
		// assert
		system.assertEquals(true, hasException == false);
		system.assertEquals(true, result == false);
	}
	@isTest
	static void testchildProcessTest() {
		// assign
		Boolean hasException = false, didRun = false;

		try {
			// act
			accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
			didRun = dpe.childProcess(null, null, null);

		} catch ( EventBus.RetryableException excp) {
			hasException = true;
		}
		// assert
		system.assertEquals(true, didRun == true);
		system.assertEquals(true, hasException == false);
	}

	@isTest
	static void testalertAddAndSendWithBadData() {
		// assign
		Boolean hasException = false, failed = true;
		List<Boolean> results = new List<Boolean>();

		try {
			// act
			accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
			results.add( dpe.alertAddAndSend(null, null, null, null));
			results.add( dpe.alertAddAndSend(new accc_DefaultProcessEventHandlers(), null, null, null));
			results.add( dpe.alertAddAndSend(new accc_DefaultProcessEventHandlers()
			                                 , new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('test')
			                                 , null
			                                 , null));


		} catch ( EventBus.RetryableException excp) {
			hasException = true;
		}
		// assert
		for (Boolean result : results) {
			system.assertEquals(true, result == false);
		}
		system.assertEquals(true, hasException == false);
	}
	@isTest
	static void testalertAddAndSendWithGoodData() {
		// assign
		Boolean hasException = false, success = true;
		accc_IProcessEventHandlers handlers = new accc_DefaultProcessEventHandlers();
		accc_DefaultPlatformEvent.PlatformEvtResultPOAC data = new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('testing');
		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theList = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		accc_PlatformEventAttrs attributes = new accc_PlatformEventAttrs();

		try {
			// act
			accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent();
			success = dpe.alertAddAndSend(handlers, data, theList, attributes);

		} catch ( Exception excp) {
			hasException = true;
		}
		// assert
		system.assertEquals(true, hasException == false);
		system.assertEquals(true, success);
	}
	@isTest
	static void testserializeEventData() {
		// assign
		Boolean hasException = false;
		String result = '';
		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theList = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		accc_PlatformEventAttrs attributes = new accc_PlatformEventAttrs();
		pe_test__e  pe = null;
		List<SObject> collectionOfEvents = new List<SObject>();

		for (integer inx = 0; inx < 2001; inx++) {
			collectionOfEvents.add(new pe_test__e ());
		}
		// act
		accc_DefaultPlatformEvent dpe = new accc_DefaultPlatformEvent('pe_test__e', true, true);

		try {
			result = dpe.serializeEventData(theList, collectionOfEvents);

		} catch ( Exception excp) {
			hasException = true;
		}
		// assert
		system.assertEquals(true, string.isBlank(result) == false);
		system.assertEquals(true, hasException == false);
		system.assertEquals(true, dpe.handlerToSerialize());
		system.assertEquals(true, dpe.isEventActive );

	}
	@isTest
	static void testPlatformEvtResultPOACCtor() {
		// assign
		accc_DefaultPlatformEvent.ErrorResultPOAC ctor1 = new accc_DefaultPlatformEvent.ErrorResultPOAC('error1');

		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> results = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> {
			new accc_DefaultPlatformEvent.PlatformEvtResultPOAC(ctor1)
		};

		// assert
		for (accc_DefaultPlatformEvent.PlatformEvtResultPOAC poac : results) {
			String data = poac.toString();
			system.assertEquals(true, data.contains('error1'));

		}
	}
}