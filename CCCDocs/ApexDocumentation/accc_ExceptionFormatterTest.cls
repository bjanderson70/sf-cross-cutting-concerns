/**
 * Copyright (c) 2016-2018, Bill Anderson.  All rights reserved.
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
 * @description Test Exception formatter
 * @group Common Test Layer
 */
@isTest
private class accc_ExceptionFormatterTest {
	@isTest
	static void testCtor() {
		// act / assign
		accc_IDataFormat formatter = new accc_ExceptionFormatter();
		system.assertNotEquals(null, formatter);

	} // end of testCtor

	@isTest
	static void testFormat() {
		// assign
		final string testStr = 'test exception again';
		accc_ApexApplicationException aae = new accc_ApexApplicationException(testStr);
		accc_IDataFormat formatter = new accc_ExceptionFormatter();
		system.assertEquals(true, ((String)formatter.format(aae)).contains(testStr));

	} // end of testCtor

	@isTest
	static void testFormatWithTwoArgs() {
		// assign
		final string testStr = 'test exception';
		accc_ApexApplicationException aae = new accc_ApexApplicationException(testStr);
		accc_IDataFormat formatter = new accc_ExceptionFormatter();
		system.assertEquals(true, ((String)formatter.format(aae,accc_ApexExceptionPolicyEnum.Business)).contains(testStr));

	} // end of testFormatWithTwoArgs
} // end of accc_ExceptionFormatterTest