/**
 * Copyright (c) 2016-2018, Bill Anderson All rights reserved.
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
 *   * Neither the name of Bill Andersonnor Bill Anderson nor the names of its
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
 * @description Test base class for fallback resources
 *
 * @group Common Test Layer
 */
@isTest
private class accc_ApexBaseFallbackTest {

	private static string json = '{ "name" : "Account"}';

	@isTest
	static void testctorBadParam() {
		// assign
		accc_IFallbackResources resource = null;
		Exception expected = null;
		try {
			// act
			resource = new accc_ApexBaseFallback();
		} catch (accc_ApexApplicationException excp ) {
			expected = excp;
		}

		// assert
		system.assertEquals(null, resource);
		system.assertEquals(true, expected instanceof accc_ApexApplicationException);
	} // end of testctorBadParam

	@isTest
	static void testfallbackResource() {
		// assign / act
		accc_IFallbackResources resource = new accc_ApexBaseFallback(json);
		Object result = resource.fallbackResource();
		// assert
		system.assertNotEquals(null, result);
	} // end of testfallbackResource

	@isTest
	static void testtoString() {
		// assign / act
		accc_IFallbackResources resource = new accc_ApexBaseFallback(json);
		String result = resource.toString();
		// assert
		system.assertEquals(true, result.length() > 1);
	} // end of testtoString


	@isTest
	static void testget() {
		// assign / act
		accc_IFallbackResources resource = new accc_ApexBaseFallback(json);

		// we expect actual class names -- let's check
		Type resultType = Type.forName((String) resource.get('name'));
		// assert
		system.assertNotEquals(null, resultType);

	} // end of testget
	@isTest
	static void testgetWithBadData() {
		// assign / act
		accc_IFallbackResources resource = new accc_ApexBaseFallback(json);

		Object result = resource.get(accc_ApexConstants.CategoryInterface_s, '*123*bad*index*');
		// assert
		system.assertEquals(null, result );

	} // end of testgetWithBadData
} // end of accc_ApexBaseFallbackTest