/**
 * Copyright (c) 2016-2019, Bill anderson.  All rights reserved.
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
 * @description creates the Platform Event Mock (as described by Salesforce)
 *
 *  Provider is invoked as follows (assuming bubba__e is a created platform event:
 *  
 *      List<SObject> events = accc_SendPlatformEventNotificationTest.createBubbaEvents(100);
 *		accc_PlatformEventTestServiceHelper mockPE = (accc_PlatformEventTestServiceHelper)accc_MockPlatformEventServiceUtil.createMock(accc_PlatformEventTestServiceHelper.class);
 *	 
 *		System.assertEquals(true, mockPE.publish(events).successful);
 *		System.assertEquals(false,mockPE.publish((SObject)null).successful);
 *		
 *  Mock/Sub -- https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_stub_api.htm
 *
 * @group Test Layer
 */
@isTest
public with sharing class accc_MockPlatformEventServiceUtil {
	private accc_MockPlatformEventServiceUtil() {}

	public static accc_TestPlatformEventMock getInstance() {
		return new accc_TestPlatformEventMock();
	}

	public static Object createMock(Type typeToMock) {
		// Invoke the stub API and pass it our mock provider to create a
		// mock class of typeToMock.
		return Test.createStub(typeToMock, accc_MockPlatformEventServiceUtil.getInstance());
	}
} // end of accc_MockPlatformEventServiceUtil