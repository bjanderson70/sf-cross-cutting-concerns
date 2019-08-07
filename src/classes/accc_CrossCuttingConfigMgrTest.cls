/**
 * Copyright (c) 2016-2019, Bill Anderson  All rights reserved.
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
 * @description  Cross Cutting Configuration Manager Test
 * @group Common Test Layer
 */
@isTest
private class accc_CrossCuttingConfigMgrTest {


    // known configuration categories
    static final List<String> CATEGORIES = new List<String> {
        accc_ApexConstants.DEBUG_CATEGORY,
        accc_ApexConstants.PRODUCTION_CATEGORY,
        accc_ApexConstants.TEST_CATEGORY
    };
    // Known field names in custom mdt that holds the classes to be instantiated
    static final List<String> CLASSES = new List<String> {
        accc_ApexConstants.CacheResource,
        accc_ApexConstants.ExceptionHandler,
        accc_ApexConstants.FallbackResource,
        accc_ApexConstants.LoggerResource
    };

    @isTest
    static void testgetClasses() {
        // assign
        accc_CrossCuttingConfigMgr cccm = new accc_CrossCuttingConfigMgr();
        // act
        Map<String, Map<String, String> > maps = cccm.getClasses(accc_ApexConstants.All_s);
        // assert
        system.assertNotEquals(false, maps.size() > 0);
        system.assertEquals(true, maps.keySet().containsAll(CATEGORIES));

        for (String key : maps.keyset()) {
            Map<String, String> items = maps.get(key);
            Set<String> sets = new Set<String>(items.keyset());

            system.assertEquals(true, sets.containsAll(CLASSES));
        }

    } // end of testgetClasses

    @isTest
    static void testgetInstanceCreators() {
        // assign
        accc_CrossCuttingConfigMgr cccm = new accc_CrossCuttingConfigMgr();
        // act
        List<accc_ApexClassInstanceMgr> insts = cccm.getInstanceCreators(accc_ApexConstants.TEST_CATEGORY);
        // assert
        system.assertEquals(true, insts.size() > 0);


    } // end of testgetInstanceCreators

    @isTest
    static void testgetInstanceCreatorWithBadParam() {
        // assign
        accc_CrossCuttingConfigMgr cccm = new accc_CrossCuttingConfigMgr();
        // act
        accc_ApexClassInstanceMgr inst = cccm.getInstanceCreator(null, null);
        // assert
        system.assertEquals(true, inst == null);

    } // end of testgetInstanceCreatorWithBadParam

    @isTest
    static void testgetInstanceCreatorsBadParam() {
        // assign
        final string myCat = 'Not Found Category';
        accc_CrossCuttingConfigMgr cccm = new accc_CrossCuttingConfigMgr();
        // act
        List<accc_ApexClassInstanceMgr> insts = cccm.getInstanceCreators(myCat);
        // assert
        system.assertEquals(true, insts.size() == 0);
        system.assertEquals(true, cccm.category == myCat);

    } // end of testgetInstanceCreatorsBadParam

    @isTest
    static void testaddToInstanceList() {
        // assign
        final string myCat = 'Not Found Category';
        boolean result;
        accc_CrossCuttingConfigMgr cccm = new accc_CrossCuttingConfigMgr();
        Map<String, String> items = new Map<String, String> ();
        List<accc_ApexClassInstanceMgr> instances = new List<accc_ApexClassInstanceMgr>();
        // act
        result = cccm.addToInstanceList(accc_ApexConstants.LoggerResource, items, instances);
        // assert
        system.assertEquals(true, result);

    } // end of testaddToInstanceList

    @isTest
    static void testgetInterfaceNameFrom() {
        // assign
        String classname = 'accc_ApexLogger';
        
        accc_CrossCuttingConfigMgr cccm = new accc_CrossCuttingConfigMgr();
        // act
        String result = cccm.getInterfaceNameFrom(accc_ApexConstants.CategoryConcrete_s,
                        classname,
                        null);
        // assert
        system.assertEquals(classname, result);

        result = cccm.getInterfaceNameFrom(accc_ApexConstants.CategoryInterface_s,
                        classname,
                        null);
        // assert
        system.assertEquals(classname, result);

    } // end of testgetInterfaceNameFrom


    @isTest
    static void testCtorAndgetInstanceCreatorsBadParam() {
        // assign
        final string myCat = 'Not Found Category';
        accc_CrossCuttingConfigMgr cccm = new accc_CrossCuttingConfigMgr(myCat);
        // act
        List<accc_ApexClassInstanceMgr> insts = cccm.getInstanceCreators();
        // assert
        system.assertEquals(true, insts.size() == 0);
        system.assertEquals(true, cccm.category == myCat);

    } // end of testCtorAndgetInstanceCreatorsBadParam

    @isTest
    static void testgetInstanceCreator() {
        // assign
        accc_CrossCuttingConfigMgr cccm = new accc_CrossCuttingConfigMgr();
        // act
        accc_ApexClassInstanceMgr inst = cccm.getInstanceCreator(accc_ApexConstants.LogFormatter, 'accc_IDataFormat');
        // assert
        system.assertEquals(true, inst != null );
        system.assertEquals(true, inst.className == accc_ApexConstants.LogFormatter );
      
    } // end of testgetInstanceCreator

    @isTest
    static void testgetInstanceCreatorWithOneParam() {
        // assign
        accc_CrossCuttingConfigMgr cccm = new accc_CrossCuttingConfigMgr();
        // act
        accc_ApexClassInstanceMgr inst = cccm.getInstanceCreator('ApexClass');
        // assert
        system.assertEquals(true, inst != null );
        system.assertEquals(true, inst.className == 'ApexClass' );
        system.assertEquals(true, inst.classInterfaceType == inst.className );

    } // end of testgetInstanceCreatorWithOneParam

    @isTest
    static void testaddToMap() {
        // assign
        accc_CrossCuttingConfigMgr cccm = new accc_CrossCuttingConfigMgr();
        // act
        boolean result = cccm.addToMap(accc_ApexConstants.TEST_CATEGORY, null, null);
        // assert
        system.assertEquals(false, result );

    } // end of testaddToMap

}