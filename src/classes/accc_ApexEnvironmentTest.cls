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
 * @description Test environment class
 * @group Common Test Layer
 */
@isTest
private class accc_ApexEnvironmentTest {


	@isTest
	static void testgetEnvironment() {
		// assign act
		String env = accc_ApexEnvironment.getEnvironment();
		// assert
		system.assertEquals(true, accc_ApexConstants.SUPPORTED_CATEGORY_SET.contains(env));

	} // end of testgetEnvironment

	@isTest
	static void testgetRuntimeEnvironment() {
		// assign/ act
		accc_IApexRunEnvironment runtime = accc_ApexEnvironment.getRuntimeEnvironment() ;
		String rType = null,
		       expected = String.valueOf(runtime).split(':')[0];

		if ( Test.isRunningTest()  ) {
			rType = String.valueOf(accc_TestEnvironmentSingleton.class).split(':')[0];
		} else {
			rType = String.valueOf(accc_ApexBaseRuntimeEnvironment.class).split(':')[0];
		}
		// assert
		system.assertEquals(expected, rType);
	} // end of testgetRuntimeEnvironment

	@isTest
	static void testgetRuntimeFallbackExceptionHandler() {
		system.assertNotEquals(null, accc_ApexEnvironment.getRuntimeFallbackExceptionHandler());
	} // end of testgetRuntimeFallbackExceptionHandler

	@isTest
	static void testgetRuntimeFallbackResources() {
		system.assertNotEquals(null, accc_ApexEnvironment.getRuntimeFallbackResources());
	} // end of testgetRuntimeFallbackResources

} // end of accc_ApexEnvironmentTest