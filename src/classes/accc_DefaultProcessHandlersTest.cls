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
 * @description define the default implementation of the core platform event event handlers container
 * @group Test  Layer
 */
@isTest
private class accc_DefaultProcessHandlersTest {
	@isTest
	static void testCtorNoParameters() {
		// assign/act
		accc_DefaultProcessEventHandlers ctor = new accc_DefaultProcessEventHandlers();
		// assert
		system.assertEquals(true, ctor != null);
		system.assertEquals(true, ctor.logHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.errorHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.successHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.alertHandler() instanceof accc_DefaultProcessHandler);

	}
	@isTest
	static void testCtorOneParameters() {
		// assign/act
		accc_DefaultProcessEventHandlers ctor = new accc_DefaultProcessEventHandlers(new accc_DefaultProcessHandler());
		// assert
		system.assertEquals(true, ctor != null);
		system.assertEquals(true, ctor.logHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.errorHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.successHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.alertHandler() instanceof accc_DefaultProcessHandler);
	}
	@isTest
	static void testCtorTwoParameters() {
		// assign/act
		accc_DefaultProcessEventHandlers ctor = new accc_DefaultProcessEventHandlers(new accc_DefaultProcessHandler(), new accc_DefaultProcessHandler());
		// assert
		system.assertEquals(true, ctor != null);
		system.assertEquals(true, ctor.logHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.errorHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.successHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.alertHandler() instanceof accc_DefaultProcessHandler);
	}
	@isTest
	static void testCtorThreeParameters() {
		// assign/act
		accc_DefaultProcessEventHandlers ctor = new accc_DefaultProcessEventHandlers(new accc_DefaultProcessHandler()
		        , new accc_DefaultProcessHandler()
		        , new accc_DefaultProcessHandler());
		// assert
		system.assertEquals(true, ctor != null);
		system.assertEquals(true, ctor.logHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.errorHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.successHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.alertHandler() instanceof accc_DefaultProcessHandler);
	}
	@isTest
	static void testCtorFourParameters() {
		// assign/act
		accc_DefaultProcessEventHandlers ctor = new accc_DefaultProcessEventHandlers(new accc_DefaultProcessHandler()
		        , new accc_DefaultProcessHandler()
		        , new accc_DefaultProcessHandler()
		        , new accc_DefaultProcessHandler());
		// asssert
		system.assertEquals(true, ctor != null);
		system.assertEquals(true, ctor.logHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.errorHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.successHandler() instanceof accc_DefaultProcessHandler);
		system.assertEquals(true, ctor.alertHandler() instanceof accc_DefaultProcessHandler);
	}
	@isTest
	static void testdefaultHandlerByName() {
		// assign/act
		accc_DefaultProcessEventHandlers hndlrs = new accc_DefaultProcessEventHandlers();
		accc_IProcessEventHandler handler = accc_DefaultProcessEventHandlers.defaultHandlerByName(accc_DefaultProcessHandler.DEFAULT_LOG_NAME);
		// assert
		system.assertEquals(true, handler instanceof accc_DefaultProcessHandler);
	}
	@isTest
	static void testdefaultHandlerByNameWithBadName() {
		// assign/act
		accc_IProcessEventHandler handler = accc_DefaultProcessEventHandlers.defaultHandlerByName('junk');
		// assert
		system.assertEquals(true, handler == null);
	}
}