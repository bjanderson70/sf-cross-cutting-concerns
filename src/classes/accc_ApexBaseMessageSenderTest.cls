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
 * @description Send information base class test
 * @group Common Test Layer
 *
 */
@isTest
private class accc_ApexBaseMessageSenderTest {
	// used for testing
	public class accc_ApexBaseMessageSenderTestImpl  extends accc_ApexBaseMessageSender {

		public integer flag;
		public override accc_ApexMessageSendResponse send(accc_ApexMessagePayload messagePayload) {
			accc_ApexMessageSendResponse response = new accc_ApexMessageSendResponse(null);
			return response;
		}
	} // end of accc_ApexBaseMessageSenderTestImpl

	@isTest
	static void testCtor() {
		accc_ApexBaseMessageSenderTestImpl ctor = new accc_ApexBaseMessageSenderTestImpl();
		system.assertNotEquals(null, ctor);
	} // end of testCtor

	@isTest
	static void testgetException() {
		accc_ApexBaseMessageSenderTestImpl ctor = new accc_ApexBaseMessageSenderTestImpl();
		system.assertEquals(null, ctor.getException());
	} // end of testgetException

	@isTest
	static void testgetExceptionWithException() {
		accc_ApexBaseMessageSenderTestImpl ctor = new accc_ApexBaseMessageSenderTestImpl();
		ctor.sendException = new accc_ApexApplicationException();
		system.assertNotEquals(null, ctor.getException());
	} // end of testgetExceptionWithException

	@isTest
	static void testgetExceptionWithExceptionAndReset() {
		accc_ApexBaseMessageSenderTestImpl ctor = new accc_ApexBaseMessageSenderTestImpl();
		ctor.sendException = new accc_ApexApplicationException();
		system.assertNotEquals(null, ctor.getException());
		ctor.reset();
		system.assertEquals(null, ctor.getException());
	} // end of testgetExceptionWithExceptionAndReset

	@isTest
	static void testgetStringListFromPayload() {
		accc_ApexBaseMessageSenderTestImpl ctor = new accc_ApexBaseMessageSenderTestImpl();
		List<String> items = ctor.getStringArrayFromPayload(getPayload(), 'list', ' the list was not found');
		system.assertEquals(3, items.size());
	} // end of testgetStringListFromPayload

	@isTest
	static void testgetStringListFromPayloadIgnoreExcp() {
		accc_ApexBaseMessageSenderTestImpl ctor = new accc_ApexBaseMessageSenderTestImpl();
		List<String> items = ctor.getStringArrayFromPayload(getPayload(), 'list', ' the list was not found', true);
		system.assertEquals(3, items.size());
	} // end of testgetStringListFromPayloadIgnoreExcp

	@isTest
	static void testgetStringListFromPayloadNullPayload() {
		accc_ApexBaseMessageSenderTestImpl ctor = new accc_ApexBaseMessageSenderTestImpl();
		List<String> items = ctor.getStringArrayFromPayload(null, 'list', ' the list was not found');
		system.assertEquals(null, items);
	} // end of testgetStringListFromPayloadNullPayload

	@isTest
	static void testgetStringFromPayloadNullPayload() {
		accc_ApexBaseMessageSenderTestImpl ctor = new accc_ApexBaseMessageSenderTestImpl();
		String item = ctor.getStringFromPayload(getPayload(true), 'list', ' the list was not found');
		system.assertEquals('i', item);
	} // end of testgetStringFromPayloadNullPayload

	@isTest
	static void testhandlerException() {
		accc_ApexBaseMessageSenderTestImpl ctor = new accc_ApexBaseMessageSenderTestImpl();
		boolean handle = ctor.handleException(getPayload(true),
		                                      new accc_ApexApplicationException('excp'),
		                                      'list',
		                                      false);
		system.assertEquals(handle, true);
	} // end of testhandlerException

	/////////////////////////////////////////////////////////////////////////////////////////////
	//
	// Private Methods
	/////////////////////////////////////////////////////////////////////////////////////////////
	
	private static accc_ApexMessagePayload getPayload() {
		return accc_ApexBaseMessageSenderTest.getPayload(false);
	} // end of getPayload

	private static accc_ApexMessagePayload getPayload(boolean useString) {
		accc_ApexMessagePayload payload = new accc_ApexMessagePayload();
		payload.payload = new List<String> { '1', '2', '3'};
		if ( !useString ) {
			payload.attributes = new Map<String, Object> { 'list' => new List<String> { 'q', 'z', 'x'} };
		} else {
			payload.attributes = new Map<String, Object> { 'list' => 'i'};
		}

		return payload;
	} // end of getPayload


} // end of accc_ApexBaseMessageSenderTest