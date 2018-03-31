/**
 * Copyright (c) 2016-2018, Bill Anderson  All rights reserved.
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
 *   * Neither the name of nor Bill Anderson nor the names of its
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
 * @description  Apex Class Instance Manager test
 * @group Common Test Layer
 */
@isTest
private class  accc_ApexClassInstanceMgrTest {

	@isTest
	static void testaccc_ApexClassInstanceMgrCtorBadParam() {
		Boolean expected = false;
		try {
			accc_ApexClassInstanceMgr mgr = new accc_ApexClassInstanceMgr((String)null);
		} catch (accc_ApexApplicationException excp) {
			expected = true;
			Type theType = Type.forName('accc_ApexApplicationException');
			system.assertEquals(true, theType.getName() == 'accc_ApexApplicationException');
		}
		system.assertEquals(true, expected == true);
	} // end of testaccc_ApexClassInstanceMgrCtorBadParam

	@isTest
	static void testaccc_ApexClassInstanceMgrCtorBadTypeParam() {
		Boolean expected = false;
		try {
			accc_ApexClassInstanceMgr mgr = new accc_ApexClassInstanceMgr((Type)null);
		} catch (accc_ApexApplicationException excp) {
			expected = true;
			Type theType = Type.forName('accc_ApexApplicationException');
			system.assertEquals(true, theType.getName() == 'accc_ApexApplicationException');
		}
		system.assertEquals(true, expected == true);
	} // end of testaccc_ApexClassInstanceMgrCtorBadTypeParam

	@isTest
	static void testaccc_ApexClassInstanceMgrCtorFromType() {

		Type expected = accc_ApexApplicationException.class;
		Boolean result = false;

		accc_ApexClassInstanceMgr mgr = new accc_ApexClassInstanceMgr(expected);
		result = mgr.getClassInstance() instanceof accc_ApexApplicationException;

		system.assertEquals(true, result == true);
	} // end of testaccc_ApexClassInstanceMgrCtorFromType

	@isTest
	static void testaccc_ApexClassInstanceMgrCtor() {
		accc_ApexClassInstanceMgr mgr = new accc_ApexClassInstanceMgr('Account');

		system.assertEquals(true, mgr.className == 'Account');
	} // end of testaccc_ApexClassInstanceMgrCtor

	@isTest
	static void testaccc_ApexClassInstanceMgrCtorWithAllParams() {
		accc_ApexClassInstanceMgr mgr = new accc_ApexClassInstanceMgr('Account', 'Object');

		system.assertEquals(true, mgr.className == 'Account');
		system.assertEquals(true, mgr.classInterfaceType == 'Object');

	} // end of testaccc_ApexClassInstanceMgrCtorWithAllParams

	@isTest
	static void testgetClassInstance() {
		accc_ApexClassInstanceMgr mgr = new accc_ApexClassInstanceMgr('Account');
		Account expected = (Account) mgr.getClassInstance();

		system.assertEquals(true, expected != null);

	} // end of testgetClassInstance

	@isTest
	static void testget() {
		accc_ApexClassInstanceMgr mgr = new accc_ApexClassInstanceMgr('Account');
		Account expected = (Account) mgr.get();

		system.assertEquals(true, expected != null);

	} // end of testget

	@isTest
	static void testname() {
		accc_ApexClassInstanceMgr mgr = new accc_ApexClassInstanceMgr('Account');

		system.assertEquals(true, mgr.name() == 'Account');
	} // end of testname

} // end of accc_ApexClassInstanceMgrTest