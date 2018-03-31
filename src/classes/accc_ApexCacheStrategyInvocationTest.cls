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
 * @description Used  to test Cache Strategy Invocation
 * @group Common Test Layer
 */
@isTest
private class accc_ApexCacheStrategyInvocationTest {

	@isTest
	static void testCtor() {
		// assign  / act
		accc_IApexCacheStrategyInvocation icsi = new accc_ApexCacheStrategyInvocation();
		// assert
		System.assertEquals(true, icsi != null);
		System.assertEquals(true, icsi.getTheSoqlQuery() == null);

	} // end of testCtor

	@isTest
	static void testCtorWithInjection() {
		// assign
		final string soql = 'select id from account';
		// act
		accc_IApexCacheStrategyInvocation icsi = new accc_ApexCacheStrategyInvocation(soql);
		// assert
		System.assertEquals(true, icsi != null);
		System.assertEquals(true, icsi.getTheSoqlQuery() == soql);

	} // end of testCtor

	@isTest
	static void testsetTheSoqlQuery() {
		// assign
		final string soql = '1 select id from account';
		final string soql2 = '2 select id from account';
		accc_IApexCacheStrategyInvocation icsi = new accc_ApexCacheStrategyInvocation(soql);
		// assert
		System.assertEquals(true, icsi != null);
		System.assertEquals(true, icsi.getTheSoqlQuery() == soql);
		// act
		icsi.setTheSoqlQuery(soql2);
		// assert
		System.assertEquals(true, icsi.getTheSoqlQuery() == soql2);

	} // end of testsetTheSoqlQuery

	@isTest
	static void testgetClassName() {
		// assign
		final string soql = 'select id from account';
		accc_ApexCacheStrategyInvocation csi = new accc_ApexCacheStrategyInvocation(soql);

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		accc_DataCachingDataModel.CacheInformation  info = aps.findCacheStrategy(accc_DataCachingDataModel.TestLabel2018);
		// act // assert
		System.assertEquals(true, info != null );

	} // end of testgetClassName

	@isTest
	static void testinvokeCacheStrategyWithSoql() {
		// assign
		accc_IApexCacheStrategyInvocation csi = new accc_ApexCacheStrategyInvocation();

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		accc_DataCachingDataModel.CacheInformation  info = aps.findCacheStrategy(accc_DataCachingDataModel.TestLabel2018);
		// act
		Boolean result = csi.invokeCacheStrategy('select id from account', info);
		
		// assert
		System.assertEquals(true, result);

	} // end of testinvokeCacheStrategyWithSoql

	@isTest
	static void testinvokeCacheStrategyWithNoSoql() {

		accc_ApexCacheStrategyInvocation csi = new accc_ApexCacheStrategyInvocation();

		accc_ApexCachePolicyStrategy aps = new accc_ApexCachePolicyStrategy();
		accc_DataCachingDataModel.CacheInformation  info = aps.findCacheStrategy(accc_DataCachingDataModel.TestLabel2018);

		Boolean result = csi.invokeCacheStrategy(info);
		System.assertEquals(false, result);

	} // end of testinvokeCacheStrategyWithNoSoql

}