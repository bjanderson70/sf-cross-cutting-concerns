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
 * @description This test class is called when an event is needed to be logged
 *
 * @group Test Layer
 */
@isTest
private class accc_DefaultProcessLogHandlerTest {
	@isTest
	static void testCtoraccc_DefaultProcessLogHandler() {
		// assign / act
		accc_DefaultProcessLogHandler ctor = new accc_DefaultProcessLogHandler();

		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(true, ctor.handlerName() == accc_DefaultProcessHandler.DEFAULT_LOG_NAME);
		System.assertEquals(true, ctor.toString() != null);
	}

	@isTest
	static void testCtoraccc_DefaultProcessLogHandlerWithName() {
		// assign
		String name = 'mylog';
		// act
		accc_DefaultProcessLogHandler ctor = new accc_DefaultProcessLogHandler(name);

		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(true, ctor.handlerName() == name);
		System.assertEquals(true, ctor.toString() != null);
	}

	@isTest
	static void testchildProcess() {
		// assign
		String name = 'mylog';
		accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs();
		List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> param = new List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> {
			new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('thename')
			, new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('thename', 'thedata')
			, new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('thename', 'thedata', 'misc')
			, new accc_DefaultPlatformEvent.PlatformEvtResultPOAC('thename', 'thedata', 'misc', 10)
		};
		accc_DefaultProcessLogHandler ctor = new accc_DefaultProcessLogHandler(name);
		// act
		String result =	(String)ctor.childProcess(param, attrs);
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(true, ctor.handlerName() == name);
		System.assertEquals(true, result != null);
	}

	@isTest
	static void testchildProcessWithBadParam() {
		// assign
		String name = 'mylog';
		

		accc_DefaultProcessLogHandler ctor = new accc_DefaultProcessLogHandler(name);
		// act
		String result =	(String)ctor.childProcess(null, null);
		
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(true, ctor.handlerName() == name);
		System.assertEquals(true, ctor.handlerException() != null);
	}
}