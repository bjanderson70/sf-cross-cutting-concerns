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
 * @description This class tests access to static resource for testing. The resource
 *     are default resources in the event a custom resource (setting/metadata) not set.
 * @group Common Test Layer
 */
@isTest
private class accc_ConfigurationTestProviderTest {

	@isTest
	static void testload() {
		// assign
		boolean result;
		accc_IConfigurationProvider settings = new accc_ConfigurationTestProvider();
		// act
		result = settings.load();
		// assert
		system.assertEquals(true, result);

	} // end of testload

	@isTest
	static void testbadGetEntity() {
		// assign
		Object result;
		accc_IConfigurationProvider settings = new accc_ConfigurationTestProvider();
		// act
		result = settings.get(null);
		// assert
		system.assertEquals(null, result);

	} // end of testbadGetEntity

	@isTest
	static void testbadNameForGetEntity() {
		// assign
		Object result;
		accc_IConfigurationProvider settings = new accc_ConfigurationTestProvider();
		// act
		result = settings.get('null');
		// assert
		system.assertEquals(null, result);

	} // end of testbadNameForGetEntity

	@isTest
	static void testgetFallbackResource() {
		// assign
		Map<String,Object> result;
		accc_ConfigurationTestProvider settings = new accc_ConfigurationTestProvider();
		// act
		result = settings.getFallbackResource();
		// assert
		system.assertNotEquals(null, result);

	} // end of testgetFallbackResource

	@isTest
	static void testgoodNameForGetEntity() {
		// assign
		Object result;
		accc_IConfigurationProvider settings = new accc_ConfigurationTestProvider();
		// act
		result = settings.get(accc_ApexConstants.TriggersEnabled_r);
		// assert
		system.assertEquals(result, 'true');

	} // end of testgoodNameForGetEntity

	@isTest
	static void testgetFallbackResourceByName() {
		// assign
		Map<String,Object> result;
		accc_ConfigurationTestProvider settings = new accc_ConfigurationTestProvider();
		// act
		result = settings.getFallbackResource();
		// assert
		system.assertEquals(result.get(accc_ApexConstants.MaxChunkSize_r), 
							string.valueOf(accc_ApexConstants.DEFAULT_MAX_NUMBER_OF_ITEMS_IN_CHUNK));

	} // end of testgetFallbackResourceByName
} // end of accc_ConfigurationTestProviderTest