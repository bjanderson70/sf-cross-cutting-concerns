/**
 * Copyright (c) 2016-2018, Bill Anderson.
 * All rights reserved.
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
 * @description Use a local L1-like cache to speed and reduce lookups
 * @group Common Test Layer
 */
@isTest
private class accc_ApexLocalL1CacheTest {
	@isTest
	static void testctor() {
		// assign /act
		accc_ApexLocalL1Cache cache = new accc_ApexLocalL1Cache();
		// assert
		system.assertEquals(accc_ApexConstants.All_s, cache.category);
	} // end of testctor

	@isTest
	static void testctorWithParam() {
		// assign /act
		accc_ApexLocalL1Cache cache = new accc_ApexLocalL1Cache('test');
		// assert
		system.assertEquals('test', cache.category);

	} // end of testctorWithParam

	@isTest
	static void testput() {
		// assign
		accc_ApexLocalL1Cache cache = new accc_ApexLocalL1Cache('test');
		// act
		cache.put('key', 'value');
		// assert
		system.assertEquals('value', (String) cache.get('key'));

	} // end of testput

	@isTest
	static void testputWithNull() {
		// assign
		accc_ApexLocalL1Cache cache = new accc_ApexLocalL1Cache('test');
		// act
		cache.put('key', null);
		// assert
		system.assertEquals(null, (String) cache.get('key'));

	} // end of testputWithNull

	@isTest
	static void testputWithNullKey() {
		// assign
		accc_ApexLocalL1Cache cache = new accc_ApexLocalL1Cache('test');
		// act
		cache.put(null, 'null');
		// assert
		system.assertEquals(0, cache.size());

	} // end of testputWithNullKey

	@isTest
	static void testget() {
		// assign
		accc_ApexLocalL1Cache cache = new accc_ApexLocalL1Cache();
		Map<String, Object> datum = new Map<String, Object> {
			'1' => 'every',
			'2' => 'time',
			'3' => 'all'
		};
		// act
		for ( string key : datum.keyset()) {
			cache.put(key, datum.get(key));
		}

		// assert
		for ( string key : datum.keyset()) {
			system.assertEquals((String)datum.get(key), (String) cache.get(key));
		}
		system.assertEquals(datum.size(), cache.size());


	} // end of testget

	@isTest
	static void testreset() {
		// assign
		accc_ApexLocalL1Cache cache = new accc_ApexLocalL1Cache();
		Map<String, Object> datum = new Map<String, Object> {
			'1' => 'every',
			'2' => 'time',
			'3' => 'all'
		};
		// act
		for ( string key : datum.keyset()) {
			cache.put(key, datum.get(key));
		}
		cache.reset();
		// assert
		for ( string key : datum.keyset()) {
			system.assertEquals(null, cache.get(key));
		}

	} // end of testreset
} // end of accc_ApexLocalL1CacheTest