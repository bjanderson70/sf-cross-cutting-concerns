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
 * @description all behaviour logic relating to the testing the trigger handler for children
 *
 *NOTE: JUST USED FOR TESTING
 *
 *@group Test Layer
 **/

@isTest
private class accc_TestTriggerHandlerForAccountTest  {
	public static final String OBIC_TEST = accc_TriggerHandlerBase.OBIC;
	final static String DOMAIN_NAME = 'Account';
	// IF TESTS FAIL HERE ... did you add 'accc_TestTriggerHandlerForAccount'
	// into the custom metadata under 'Test' and made Active
	//
	// This is ALL we overroad in accc_TestTriggerHandlerForAccountTest, and so we test
	// that method we wrote as follows:
	@isTest
	static void testonBeforeInsertChild() {
		// arrange/assign/act
		accc_TestUtilityForTriggerHandler.cannotAssumeWeAreWireIntoTriggerHandler(DOMAIN_NAME);
		// assert
		system.assertEquals(true, accc_ApexUtilities.containsInTestLog(OBIC_TEST));
	}

} // end of accc_TestTriggerHandlerForAccountTest