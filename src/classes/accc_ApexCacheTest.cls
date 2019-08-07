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
 * @description Test Cache
 *
 * Note: The cache MUST BE SETUP FIRST!!!
 * https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_cache_partition_setup.htm
 * @group Common Test Layer
 */
@isTest
private class accc_ApexCacheTest {

    @isTest
    static void TestCtor() {
        // assign & act
        accc_ICache mcache = new accc_ApexCache();
        // assert
        System.Assert(mcache != null, 'Test accc_ApexCache ctor');
    } // end of TestCtor

    @isTest
    static void TestCtorWithBadParams() {
        // assign & act
        accc_ICache mcache = new accc_ApexCache('1', '2');
        // assert
        System.Assert(mcache != null, 'Test accc_ApexCache ctor');
        System.Assert(mcache.isAvailable() == false, 'Test accc_ApexCache ctor is AVAILABLE');
    } // end of TestCtorWithBadParams

    @isTest
    static void TestCtorWithOneBadParams() {
        // assign & act
        accc_ICache mcache = new accc_ApexCache('2');
        // assert
        System.Assert(mcache != null, 'Test accc_ApexCache ctor');
        System.Assert(mcache.isAvailable() == false, 'Test accc_ApexCache ctor is AVAILABLE');
    } // end of TestCtorWithOneBadParams

    @isTest
    static void TesttoggleEnabled() {
        // assign
        accc_ApexCache mcache = new accc_ApexCache();
        Boolean toggleEnabled = false;
        // act
        Boolean result = mcache.toggleEnabled();
        // assert
        System.Assert(result == toggleEnabled, 'Test accc_ApexCache toggleEnabled');
    } // end of TesttoggleEnabled

    @isTest
    static void TestisAvailable() {
        // assign
        accc_ICache mcache = new accc_ApexCache();
        Boolean isAvailable = true;
        // act
        Boolean result = mcache.isAvailable();
        // assert
        System.Assert(isAvailable == result, 'Test accc_ApexCache isAvailable');
    } // end of TestisAvailable

    @isTest
    static void TestgetString() {
        // assign
        accc_ICache mcache = new accc_ApexCache();
        String key = accc_ApexUtilities.newGuid();
        // act
        String result = (String)mcache.get(key);
        // assert
        System.Assert(result == null, 'Test accc_ApexCache get');
    } // end of TestgetString

    @isTest
    static void TestgetStringByPartition() {
        // assign
        accc_ICache mcache = new accc_ApexCache();
        String key = accc_ApexUtilities.newGuid();
        // act
        String result = (String)mcache.get(mcache.theCachePartition(), key);
        // assert
        System.Assert(result == null, 'Test accc_ApexCache get');
    } // end of TestgetStringByPartition

    @isTest
    static void TestputString() {
        // assign
        accc_ICache mcache = new accc_ApexCache();
        String key = accc_ApexUtilities.newGuid();
        // act
        mcache.put(key, key);
        String result = (String)mcache.get(key);
        // assert
        System.Assert(result == key, 'Test accc_ApexCache put');
    } // end of TestputString

    @isTest
    static void TestputStringByPartition() {
        // assign
        accc_ICache mcache = new accc_ApexCache();
        String key = accc_ApexUtilities.newGuid();
        // act
        mcache.put(mcache.theCachePartition(), key, key);
        String result = (String)mcache.get(mcache.theCachePartition(), key);
        // assert
        System.Assert(result == key, 'Test accc_ApexCache put');
    } // end of TestputStringByPartition

    @isTest
    static void TestgetKeys() {
        // assign
        accc_ICache mcache = new accc_ApexCache();
        Set<String> keys = new Set<String>();
        Set<String> results = null;
        String key;
        // act
        for (Integer inx = 0; inx < 100; inx++) {
            key = accc_ApexUtilities.newGuid();
            keys.add( key);
            mcache.put(key, key);
            System.assert((String)mcache.get(mcache.theCachePartition(), key) == key, 'TestgetKeys expected entry, not found');
        }

        // act
        results = mcache.getKeys();
        for (String item : results) {
            keys.remove(item);
        }
        // assert
        System.Assert( keys.size() == 0, 'Test accc_ApexCache getkeys');
    } // end of TestgetKeys

    @isTest
    static void TestgetKeysByPartition() {
        // assign
        accc_ICache mcache = new accc_ApexCache();
        Set<String> keys = new Set<String>();
        Set<String> results = null;
        String key;
        // act
        for (Integer inx = 0; inx < 100; inx++) {
            key = accc_ApexUtilities.newGuid();
            keys.add( key);
            mcache.put(mcache.theCachePartition(), key, key);
            System.assert((String)mcache.get(mcache.theCachePartition(), key) == key, 'TestgetKeys expected entry, not found');
        }

        // act
        results = mcache.getKeys(mcache.theCachePartition());
        for (String item : results) {
            keys.remove( item);
        }
        // assert
        System.Assert( keys.size() == 0, 'Test accc_ApexCache getkeys');
    } // end of TestgetKeysByPartition

    @isTest
    static void Testcontains() {
        // assign
        accc_ICache mcache = new accc_ApexCache();
        String key =  accc_ApexUtilities.newGuid();

        // act
        mcache.put(key, 'key');
        Boolean result = mcache.contains(key);

        // assert
        System.Assert(result == true, 'Test accc_ApexCache Contains');
    } // end of Testcontains

    @isTest
    static void TestcontainsByPartition() {
        // assign
        accc_ICache mcache = new accc_ApexCache();
        String key =  accc_ApexUtilities.newGuid();

        // act
        mcache.put(mcache.theCachePartition(), key, 'key');
        Boolean result = mcache.contains(mcache.theCachePartition(), key);

        // assert
        System.Assert(result == true, 'Test accc_ApexCache Contains');
    } // end of TestcontainsByPartition

    @isTest
    static void TestputStringTTL() {
        // assign
        accc_ICache mcache = new accc_ApexCache();
        String key = accc_ApexUtilities.newGuid();

        // act
        mcache.put(key, (Object)key, accc_ApexCache.DEFAULT_MIN_TTL_IN_SECS);

        String result = (String)mcache.get(key);
        // assert
        System.Assert(result == key, 'Test accc_ApexCache put TTL');
    } // end of TestputStringTTL

    @isTest
    static void Testremove() {
        // assign
        accc_ICache mcache = new accc_ApexCache();
        String key = accc_ApexUtilities.newGuid();

        // act
        mcache.put(key, key);
        mcache.remove(key);
        String result = (String)mcache.get(key);
        // assert
        System.Assert(result == null, 'Test accc_ApexCache remove');
    } // end of Testremove

    @isTest
    static void TestremoveByPartition() {
        // assign
        accc_ICache mcache = new accc_ApexCache();
        String key = accc_ApexUtilities.newGuid();

        // act
        mcache.put(mcache.theCachePartition(), key, key);
        mcache.remove(mcache.theCachePartition(), key);
        String result = (String)mcache.get(mcache.theCachePartition(), key);
        // assert
        System.Assert(result == null, 'Test accc_ApexCache remove');
    } // end of TestremoveByPartition

    @isTest
    static void TestpartitionName() {
        // assign
        accc_ICache mcache = new accc_ApexCache();
        String key = accc_ApexUtilities.newGuid();
        String expNS = accc_ApexCache.CACHE_NS;
        String expPN = accc_ApexConstants.DefaultCachePartitionName_s;
        String expected = expNS + '.' + expPN;
        // act
        String partitionName = mcache.partitionName();

        // assert
        System.Assert(partitionName == expected, 'Test accc_ApexCache partition');
    } // end of partitionName

    @isTest
    static void TestpartitionNameWithPartitionName() {
        // assign
        accc_ICache mcache = new accc_ApexCache(accc_ApexCache.CACHE_NS, accc_ApexConstants.DefaultCachePartitionName_s);
        String expNS = accc_ApexCache.CACHE_NS;
        String expPN = accc_ApexConstants.DefaultCachePartitionName_s;
        String expected = expNS + '.' + expPN;
        // act
        String partitionName = mcache.partitionName();

        // assert
        System.Assert(partitionName == expected, 'Test accc_ApexCache partition');
    } // end of TestpartitionNameWithPartitionName

    @isTest
    static void TestcacheNamespace() {
        // assign
        accc_ApexCache mcache = new accc_ApexCache(accc_ApexCache.CACHE_NS, accc_ApexConstants.DefaultCachePartitionName_s);
        String expNS = accc_ApexCache.CACHE_NS;
        String expPN = accc_ApexConstants.DefaultCachePartitionName_s;
        String expected = expNS;
        // act
        String cacheNamespace = mcache.theCacheNamespace();

        // assert
        System.Assert(cacheNamespace == expected, 'Test accc_ApexCache Namespace');
    } // end of TestcacheNamespace
    @isTest
    static void testgetCachePartitionName() {
        // assign
        String expNS = accc_ApexCache.CACHE_NS;
        String expPN = accc_ApexConstants.DefaultCachePartitionName_s;

        String expected = expNS + '.' + expPN;
        // act
        String partitionName = accc_ApexCache.getCachePartitionName(expNS, expPN);

        // assert
        System.Assert(partitionName == expected, 'Test accc_ApexCache partition');
    } // end of testgetCachePartitionName

}