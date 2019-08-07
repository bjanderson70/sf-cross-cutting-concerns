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
 * @description Used  to test CachePolicy
 * @group Common Test Layer
 */
@isTest
private class accc_ApexCachePolicyStrategyTest {

	@isTest
	static void testcacheValueNullParams() {

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		boolean result = aps.cacheValue(null, null);

		// assert
		System.assertEquals(false, result);
	} // end of testcacheValueNullParams
	@isTest
	static void testcacheValueAllNullParams() {

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		boolean result = aps.cacheValue(null, null, null);

		// assert
		System.assertEquals(false, result);
	} // end of testcacheValueAllNullParams

	@isTest
	static void testcacheValueOneNull() {

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		boolean result = aps.cacheValue(accc_DataCachingDataModel.TestName2018, null);

		// assert
		System.assertEquals(false, result);
	} // end of testcacheValueOneNull


	@isTest
	static void testcacheValueWithBadLabel() {

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		boolean result = aps.cacheValue('id', 'select id from account');

		// assert
		System.assertEquals(false, result);
	} // end of testcacheValueWithBadLabel


	@isTest
	static void testcacheValueWithCategory() {

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		boolean result = aps.cacheValue(accc_DataCachingDataModel.TestCategory, accc_DataCachingDataModel.TestLabel2018, 'select id from ACCOUNT');

		// assert
		System.assertEquals(true, result);
	} // end of testcacheValueWithCategory

	@isTest
	static void testcacheValueWithQueryBadContains() {

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		boolean result = aps.cacheValue('dd', 'select id FROM account');

		// assert
		System.assertEquals(false, result);
	} // end of testcacheValueWithQueryBadContains

	@isTest
	static void testfindCacheStrategy() {

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		accc_DataCachingDataModel.CacheInformation  result = aps.findCacheStrategy(accc_DataCachingDataModel.TestLabel2018);
		// assert
		System.assertNotEquals(null, result);

	} // end of testfindCacheStrategy

	@isTest
	static void testcheckSplitAndContain() {

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		Boolean  result = aps.checkSplitAndContain('select id', 'select id from Custom');

		// assert
		System.assertEquals(true, result);
	} // end of testcheckSplitAndContain


	@isTest
	static void testcheckSplitAndContainWithHello() {

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		Boolean result = aps.checkSplitAndContain('select hello', 'select id from Opportunity');

		// assert
		System.assertEquals(false, result);
	} // end of testcheckSplitAndContainWithHello

	@isTest
	static void testcheckSplitAndContainWithMultiSpaces() {

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		Boolean result = aps.checkSplitAndContain('select  ', 'select id from Product');

		// assert
		System.assertEquals(true, result);
	} // end of testcheckSplitAndContainWithMultiSpaces

	@isTest
	static void testcheckRegex() {

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		Boolean result = aps.checkRegex('select  ', 'select id from Lead');

		// assert
		System.assertEquals(false, result);
	} // end of testcheckRegex

	@isTest
	static void testcheckRegexBadSelect() {

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		Boolean result = aps.checkRegex('/seqlect/', 'select id from Contact');

		// assert
		System.assertEquals(false, result);

	} // end of testcheckRegexBadSelect
	@isTest
	static void testcheckRegexValid() {

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		Boolean result = aps.checkRegex('\\bselect\\b', 'select id from Contact');

		// assert

		System.assertEquals(true, result);
	} // end of testcheckRegexValid

} // end of accc_ApexCachePolicyStrategyTest