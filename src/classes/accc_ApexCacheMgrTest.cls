/**
 * Copyright (c) 2016-2019, Bill Anderson. All rights reserved.
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
 * @description Encapsulates all behaviour logic relating to testing cache manager.
 *
 * The caching manager uses the runtime environment to determine the,
 *  + cache strategy
 *  + cache invocation
 *  + cache resources
 *
 * Instead of using all the different cache mechanisms, this class manages most
 * of those aspect for you. Whether to cache or not, simply call the following:
 *
 *  accc_ApexCacheMgr mgr = new accc_ApexCacheMgr() ; // default ctor, uses caching strategy
 *  SomeData data= new SomeData();
 *  Boolean wasCached = mgr.cache('Data',data); // cache data
 *     :
 *     :
 *  // assuming the data 'wasCached' == true
 *  //
 *  data = mgr.cache('Data','somedata');
 *
 * @group Common Test Layer
 */
@isTest
private class accc_ApexCacheMgrTest {

    static Boolean isCacheAvailableAndEnabled = false;
	
    @isTest
    static void testctorWithParam() {
        // assign
        Boolean expected = true;
        // act
        accc_ApexCacheMgr mgr = new accc_ApexCacheMgr(expected);
        // assert
        system.assertEquals(true, mgr.useCacheStrategy);
    } // end of testctorWithParam

    @isTest
    static void testctorNoParam() {
        // assign
        Boolean expected =  (Boolean) accc_ApexEnvironment.getRuntimeEnvironment().provider().get(accc_ApexConstants.UseCachingStrategy_r);
        // act
        accc_ApexCacheMgr mgr = new accc_ApexCacheMgr();
        // assert
        system.assertEquals(true, mgr.useCacheStrategy);
    } // end of testctorNoParam

    @isTest
    static void testctorNoParamTestProperties() {
        // assign/act
        accc_ApexCacheMgr mgr = new accc_ApexCacheMgr();
        // assert
        system.assertNotEquals(null, mgr.theCache);
        system.assertNotEquals(null, mgr.theCacheStrategy);
        system.assertNotEquals(null, mgr.theCacheStrategyInvocation);

    } // end of testctorNoParamTestProperties

    @isTest
    static void testcache() {
        // assign
        Object result = null;
        // CACHE MUST BE SETUP !!!
        if ( accc_ApexCacheMgrTest.isCacheAvailableAndEnabled ) {
            accc_ApexCacheMgr mgr = new accc_ApexCacheMgr(false);
            //act
            result = mgr.cache('mydata');
            // assert
            system.assertEquals(null, result);
        }
    } // end of testcache

    @isTest
    static void testcacheWithNoCacheStrategyAndDataThatIsPresent() {
        // assign
        String label = 'mylabel';
        Object result = 'mydata';
        final String expected = 'mydata';
        // CACHE MUST BE SETUP !!!
        if ( accc_ApexCacheMgrTest.isCacheAvailableAndEnabled ) {
            // do not use caching strategy as nothing is set
            accc_ApexCacheMgr mgr = new accc_ApexCacheMgr(false);
            //act
            Boolean wasCached = mgr.cache(label, result);
            result = mgr.cache(label);
            // assert
            system.assertEquals(true, wasCached);
            system.assertEquals(expected, (String)result);
        }

    } // end of testcacheWithNoCacheStrategyAndDataThatIsPresent

    @isTest
    static void testcacheWithNoCacheStrategyAndDataThatIsPresentBadLabel() {
        // assign
        String label = 'mylabel';
        Object result = 'mydata';
        final String expected = null;
        // CACHE MUST BE SETUP !!!
        if ( accc_ApexCacheMgrTest.isCacheAvailableAndEnabled ) {
            // do not use caching strategy as nothing is set
            accc_ApexCacheMgr mgr = new accc_ApexCacheMgr(false);
            //act
            Boolean wasCached = mgr.cache(label, result);
            result = mgr.cache('label');
            // assert
            system.assertEquals(true, wasCached);
            system.assertEquals(expected, (String)result);
        }
    } // end of testcacheWithNoCacheStrategyAndDataThatIsPresentBadLabel

    @isTest
    static void testcacheWithCacheStrategyAndDataThatIsPresentWithTestLabel() {
        // assign
        final String label = accc_DataCachingDataModel.TestLabel2018;
        Object result = 'mydata';
        final String expected = null;
        // CACHE MUST BE SETUP !!!
        if ( accc_ApexCacheMgrTest.isCacheAvailableAndEnabled ) {
            // DO use caching strategy as this is set for testing (default is true)
            accc_ApexCacheMgr mgr = new accc_ApexCacheMgr();
            //act
            Boolean wasCached = mgr.cache(accc_DataCachingDataModel.TestCategory,
                                          label,
                                          result);
            result = mgr.cache(label);
            // assert
            system.assertEquals(true, wasCached);
            system.assertEquals(expected, (String)result);
        }
    } // end of testcacheWithCacheStrategyAndDataThatIsPresentWithTestLabel

    @isTest
    static void testcacheWithNoCacheStrategyAndDataThatIsPresentWithTestLabel() {
        // assign
        final String label = accc_DataCachingDataModel.TestLabel2018;
        Object result = 'mydata';
        final String expected = null;
        // CACHE MUST BE SETUP !!!
        if ( accc_ApexCacheMgrTest.isCacheAvailableAndEnabled ) {
            // DO use caching strategy as this is set for testing (default is true)
            accc_ApexCacheMgr mgr = new accc_ApexCacheMgr(false);
            //act
            Boolean wasCached = mgr.cache(accc_DataCachingDataModel.TestCategory,
                                          label,
                                          result);
            result = mgr.cache(label);
            // assert
            system.assertEquals(true, wasCached);
            system.assertEquals(expected, (String)result);
        }
    } // end of testcacheWithNoCacheStrategyAndDataThatIsPresentWithTestLabel

    @isTest
    static void testcacheWithCacheStrategyAndSoqlAndDataThatIsPresentWithTestLabel() {
        // assign
        final String label = accc_DataCachingDataModel.TestLabel2018;
        final String soql = 'select id from account';
        Object result = 'mydata';
        final String expected = null;
        // CACHE MUST BE SETUP !!!
        if ( accc_ApexCacheMgrTest.isCacheAvailableAndEnabled ) {
            // DO use caching strategy as this is set for testing (default is true)
            accc_ApexCacheMgr mgr = new accc_ApexCacheMgr();
            //act
            Boolean wasCached = mgr.cache(accc_DataCachingDataModel.TestCategory,
                                          label,
                                          soql,
                                          result);
            result = mgr.cache(label);
            // assert
            system.assertEquals(true, wasCached);
            system.assertEquals(expected, (String)result);
        }
    } // end of testcacheWithCacheStrategyAndSoqlAndDataThatIsPresentWithTestLabel

    @isTest
    static void testcacheInformation() {
        // assign
        final String label = accc_DataCachingDataModel.TestLabel2018;
        // DO use caching strategy as this is set for testing (default is true)
        accc_ApexCacheMgr mgr = new accc_ApexCacheMgr();
        //act

        accc_DataCachingDataModel.CacheInformation datum = mgr.cacheInformation(label);

        // assert
        system.assertNotEquals(null, datum);
        system.assertEquals( accc_DataCachingDataModel.TestCategory, datum.category);
        system.assertEquals(accc_DataCachingDataModel.TestName2018, datum.developerName);
        system.assertEquals(true, datum.isCachingEnabled);

    } // end of testcacheInformation

    @isTest
    static void testcacheInformationWithCategoryAndLabel() {
        // assign
        final String label = accc_DataCachingDataModel.TestLabel2018;
        final String category = accc_DataCachingDataModel.TestCategory;
        // DO use caching strategy as this is set for testing (default is true)
        accc_ApexCacheMgr mgr = new accc_ApexCacheMgr();
        //act
        accc_DataCachingDataModel.CacheInformation datum = mgr.cacheInformation(category, label);

        // assert
        system.assertNotEquals(null, datum);
        system.assertEquals( accc_DataCachingDataModel.TestCategory, datum.category);
        system.assertEquals(accc_DataCachingDataModel.TestName2018, datum.developerName);
        system.assertEquals(true, datum.isCachingEnabled);

    } // end of testcacheInformationWithCategoryAndLabel

	/*
	 * We ensure that Cache is ENABLED with the right partition. Otherwise,
	 * is is pointless to test. Event is no unit test is run on cache ( due to no setup)
	 * the ACCC unit tests have 96% code coverage
	 */
    @TestSetup
    static void makeData(){
        accc_ICache mcache = new accc_ApexCache();
        accc_ApexCacheMgrTest.isCacheAvailableAndEnabled  =mcache.isAvailable();
    }
} // end of accc_ApexCacheMgrTest