/**
 * Copyright (c) 2016-2018, Bill anderson.  All rights reserved.
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
 *   * Neither the name of Bill anderson nor the names of its
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
 * @author Bill anderson
 * @description Encapsulates test of all behaviour logic relating to the handlers in the chain
 *
 * For more guidelines and details see
 *   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Domain_Layer
 * @group Test Layer
 **/
@isTest
private class accc_VirtualTriggerHandlerChainTest {
	// place holder for testing trigger handler classes
	public class myTestTriggerHandler extends accc_TriggerHandlerBase {
	}

	@isTest
	static void testctor() {
		// assign
		accc_ITriggerHandler handler = new myTestTriggerHandler();
		// act
		accc_VirtualTriggerHandlerChain chain = new accc_VirtualTriggerHandlerChain(handler);

		// assert
		system.assertEquals(true, chain.getHandler() != null);
	}

	@isTest
	static void testgetNextAndgetHandler() {
		// assign
		accc_ITriggerHandler handler = new myTestTriggerHandler();
		// act
		accc_IHandlerChain chain1 = new accc_VirtualTriggerHandlerChain(handler);
		accc_IHandlerChain chain2 = new accc_VirtualTriggerHandlerChain(handler);
		chain1.setNext(chain2);
		// assert
		system.assertEquals(handler, chain1.getHandler());
		system.assertEquals(chain2, chain1.getNext());
	}
}