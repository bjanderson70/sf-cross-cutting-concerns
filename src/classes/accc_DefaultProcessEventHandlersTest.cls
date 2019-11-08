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
 * @description test the eprocess event handler
 * @group Test  Layer
 */
@isTest
private class accc_DefaultProcessEventHandlersTest {
	static List<String> names = new List<String> {
		accc_DefaultProcessHandler.DEFAULT_LOG_NAME
		, accc_DefaultProcessHandler.DEFAULT_ERROR_NAME
		, accc_DefaultProcessHandler.DEFAULT_SUCCESS_NAME
		, accc_DefaultProcessHandler.DEFAULT_ALERT_NAME
		, accc_DefaultProcessHandler.DEFAULT_STORE_NAME
	};
	@isTest
	static void defaultCtorTest() {
		// assign

		// act
		accc_DefaultProcessEventHandlers ctor = new accc_DefaultProcessEventHandlers();

		// assert
		system.assertEquals(5, accc_DefaultProcessEventHandlers.m_DefaultHandlers.size());
		for (String name : names) {
			system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName(name));
		}

	}
	@isTest
	static void oneParamCtorTest() {
		// assign

		// act
		accc_DefaultProcessEventHandlers ctor = new accc_DefaultProcessEventHandlers(new  accc_DefaultProcessHandler('one'));

		// assert
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('one'));


	}
	@isTest
	static void twoParamCtorTest() {
		// assign

		// act
		accc_DefaultProcessEventHandlers ctor = new accc_DefaultProcessEventHandlers(
		    new  accc_DefaultProcessHandler('one')
		    , new accc_DefaultProcessHandler('two'));

		// assert
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('one'));
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('two'));


	}
	@isTest
	static void threeParamCtorTest() {
		// assign

		// act
		accc_DefaultProcessEventHandlers ctor = new accc_DefaultProcessEventHandlers(
		    new  accc_DefaultProcessHandler('one')
		    , new accc_DefaultProcessHandler('two')
		    , new accc_DefaultProcessHandler('three'));

		// assert
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('one'));
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('two'));
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('three'));


	}
	@isTest
	static void fourParamCtorTest() {
		// assign

		// act
		accc_DefaultProcessEventHandlers ctor = new accc_DefaultProcessEventHandlers(
		    new  accc_DefaultProcessHandler('one')
		    , new accc_DefaultProcessHandler('two')
		    , new accc_DefaultProcessHandler('three')
		    , new accc_DefaultProcessHandler('four'));

		// assert
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('one'));
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('two'));
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('three'));
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('four'));

	}
	@isTest
	static void fiveParamCtorTest() {
		// assign

		// act
		accc_DefaultProcessEventHandlers ctor = new accc_DefaultProcessEventHandlers(
		    new  accc_DefaultProcessHandler('one')
		    , new accc_DefaultProcessHandler('two')
		    , new accc_DefaultProcessHandler('three')
		    ,  new accc_DefaultProcessHandler('four')
		    ,  new accc_DefaultProcessHandler('five'));

		// assert
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('one'));
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('two'));
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('three'));
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('four'));
		system.assertNotEquals(null, accc_DefaultProcessEventHandlers.defaultHandlerByName('five'));

	}

	@isTest
	static void methodsAccessTest() {
		// assign
		accc_DefaultProcessHandler one = new accc_DefaultProcessHandler('one');
		accc_DefaultProcessHandler two = new accc_DefaultProcessHandler('two');
		accc_DefaultProcessHandler three = new accc_DefaultProcessHandler('three');
		accc_DefaultProcessHandler four = new accc_DefaultProcessHandler('four');
		accc_DefaultProcessHandler five = new accc_DefaultProcessHandler('five');
		// act
		accc_DefaultProcessEventHandlers ctor = new accc_DefaultProcessEventHandlers(
		    one, two, three, four, five);

		// assert
		system.assertEquals(one, accc_DefaultProcessEventHandlers.defaultHandlerByName('one'));
		system.assertEquals(two, accc_DefaultProcessEventHandlers.defaultHandlerByName('two'));
		system.assertEquals(three, accc_DefaultProcessEventHandlers.defaultHandlerByName('three'));
		system.assertEquals(four, accc_DefaultProcessEventHandlers.defaultHandlerByName('four'));
		system.assertEquals(five, accc_DefaultProcessEventHandlers.defaultHandlerByName('five'));

		

		system.assertEquals('one', ctor.logHandler().handlerName());
		system.assertEquals('two', ctor.errorHandler().handlerName());
		system.assertEquals('three', ctor.successHandler().handlerName());
		system.assertEquals('four', ctor.alertHandler().handlerName());
		system.assertEquals('five', ctor.storeHandler().handlerName());

		system.assertNotEquals(null, ctor.logHandler());
		system.assertNotEquals(null, ctor.errorHandler());
		system.assertNotEquals(null, ctor.successHandler());
		system.assertNotEquals(null, ctor.alertHandler());
		system.assertNotEquals(null, ctor.storeHandler());

	}
}