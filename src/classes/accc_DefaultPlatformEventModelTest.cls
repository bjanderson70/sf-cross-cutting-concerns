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
 * @description define the concrete implementation of the core platform event model tests
 * @group Test Layer
 */
@isTest
private class accc_DefaultPlatformEventModelTest {
	@isTest
	static void testCtor() {
	 	// assign
	 	accc_IEventHandler handler=null;
		accc_IPlatformEventModel pem = new accc_DefaultPlatformEventModel(null, null, null);
		// act
		accc_IProcessEventHandlers handlers = pem.processHandlers();
		handler =  pem.eventHandler();
		// assert
		system.assertEquals(true, pem != null);
		system.assert(handler != null, 'should be a default publisher/handler');
		system.assert(pem.getException() == null , 'should be NO exception');
	 
		system.assert(handlers != null, 'should be true');
		system.assert(pem.attributes() != null, 'should not be null');
	}
	@isTest
	static void testCtorWithProcess() {
		// assign
		List<SObject> events = new List<SObject> {
			new Account( Name = 'Junk')
		};
		// act
		accc_IPlatformEventModel pem = new accc_DefaultPlatformEventModel();
		// assert
		system.assert(pem.process(events) == true, 'event is processed');
		system.assert(pem.process(null) == false);
	}

	@isTest
	static void testsetException() {
		// assign
		accc_DefaultPlatformEventModel pem = new accc_DefaultPlatformEventModel();
		pem.setException(new accc_PlatformEventException('hello'));
		// act / assert
		system.assertEquals(true, pem.getException() != null);

	}
}