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
 * Encapsulates all behaviour logic relating to the Trigger invocation
 *
 * @author Bill Anderson
 * @description  Test class for the  accc_TriggerHelperClass methods
 * @group Common Test Layer
 */
@isTest
private class accc_TriggerHelperClassTest {
	/**
	 * Supported trigger action states
	 */
	private static List<accc_TriggerHelperClass.TriggerState> triggerAction = new List<accc_TriggerHelperClass.TriggerState> {
		accc_TriggerHelperClass.TriggerState.BeforeInsert
		, accc_TriggerHelperClass.TriggerState.BeforeUpdate
		, accc_TriggerHelperClass.TriggerState.BeforeDelete
		, accc_TriggerHelperClass.TriggerState.AfterInsert
		, accc_TriggerHelperClass.TriggerState.AfterUpdate
		, accc_TriggerHelperClass.TriggerState.AfterDelete
		, accc_TriggerHelperClass.TriggerState.AfterUndelete
	};
	

	@isTest
	static void testtoggleRunStateWithObjectName() {
		// assign/act/assert
		List<String> objectNames = new List<String> { 'Lead', 'Contact', 'Account'};

		for ( String objectname : objectNames) {
			// first time they should be TRUE
			for (accc_TriggerHelperClass.TriggerState action : triggerAction ) {
				System.assertEquals(accc_TriggerHelperClass.toggleRunState(objectname, action), true);
			}
			// second time they should be FALSE
			for (accc_TriggerHelperClass.TriggerState action : triggerAction ) {
				System.assertEquals(accc_TriggerHelperClass.toggleRunState(objectname, action), false);
			}
		}
		// assert
		System.assertEquals(accc_TriggerHelperClass.toggleRunState(null, accc_TriggerHelperClass.TriggerState.AfterInsert), false);
		System.assertEquals(accc_TriggerHelperClass.toggleRunState('', null), false);
	}
	/**
	* @description testing to ensure reset sets all actions to true
	*/
	@isTest
	static void testreset() {
		// assign/act/assert
		List<String> objectNames = new List<String> { 'Lead', 'Contact', 'Account'};

		for ( String objectname : objectNames) {
			// first time they should be TRUE
			for (accc_TriggerHelperClass.TriggerState action : triggerAction ) {
				System.assertEquals(accc_TriggerHelperClass.toggleRunState(objectname, action), true);
			}
			// act
			accc_TriggerHelperClass.reset();
			// second time they should be TRUE, after a reset
			for (accc_TriggerHelperClass.TriggerState action : triggerAction ) {
				System.assertEquals(accc_TriggerHelperClass.toggleRunState(objectname, action), true);
			}
		}
		// act
		accc_TriggerHelperClass.reset();

		for ( String objectname : objectNames) {
			accc_TriggerHelperClass.reset(null);
			// assert
			System.assertEquals(false, accc_TriggerHelperClass.hasBeenCalled('Lead', null));
		}
	} // end of testreset

	@isTest
	static void testhasBeenCalled() {
		// assign/act/assert
		List<String> objectNames = new List<String> { 'Lead', 'Contact', 'Account'};

		for ( String objectname : objectNames) {

			// act
			accc_TriggerHelperClass.reset();
			// they should be FALSE, after a reset
			for (accc_TriggerHelperClass.TriggerState action : triggerAction ) {
				System.assertEquals(false, accc_TriggerHelperClass.hasBeenCalled(objectname, action));
			}
		}
		// assert
		System.assertEquals(false, accc_TriggerHelperClass.hasBeenCalled(null, accc_TriggerHelperClass.TriggerState.AfterInsert));
		System.assertEquals(false, accc_TriggerHelperClass.hasBeenCalled('Lead', accc_TriggerHelperClass.TriggerState.AfterInsert));
	} // end of testhasBeenCalled

	@isTest
	static void testisKnownAction() {
		// assign
		for (accc_TriggerHelperClass.TriggerState evt : triggerAction) {
			// act /assert
			System.assertEquals(true, accc_TriggerHelperClass.isKnownAction(evt));
		}
	} // end of testisKnownAction
	//
	@isTest
	static void testgetTriggerMapWithNullParam() {
		// assign/act
		Map<accc_TriggerHelperClass.TriggerState, Boolean> triggerMap = accc_TriggerHelperClass.getTriggerMap(null);
		// assert
		System.assertEquals(null, triggerMap);

	} // end of testgetTriggerMapWithNullParam
}