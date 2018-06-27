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
 * @description Test class for the Factory object
 * @group Common Test Layer
 */
@isTest
private class accc_ApexObjectFactoryTest {

    /**
     * @description Test the factory can be created
     */
    @isTest
    static void testCtor() {
        // arrange & act
        // our factory
        accc_IApexFactory factory = new accc_ApexObjectFactory();

        // assert
        System.assertNotEquals(null, factory ) ;

    } // end of testCtor

    /**
     * @description Test the factory keySet
     */
    @isTest
    static void testKeySet() {
        // arrange & act
        // our factory
        accc_IApexFactory factory = new accc_ApexObjectFactory();

        // assert
        System.assertNotEquals(null, factory.keys() ) ;

    } // end of testKeySet

    /**
     * @description Test the factory add name
     */
    @isTest
    static void testKAddByName() {
        // arrange & act
        List<String> names = new String[] {
            'accc_ApexLogger',
            'accc_ApexExceptionHandler',
            'accc_ApexExceptionPolicyStrategy'
        };
        // our factory
        accc_IApexFactory factory = new accc_ApexObjectFactory();

        // assert

        // iterate over known list
        for (String key : names) {
            factory.add(key);
            System.assertNotEquals(null, factory.create(key) ) ;
        }

    } // end of testKAddByName

    /**
     * @description test creating items from the factory
     */
    @isTest static void testCreateItems() {
        // arrange & act
        List<String> myFQN = new List<String> { accc_ApexConstants.LoggerResource, accc_ApexConstants.ExceptionHandler};
        // our factory
        accc_IApexFactory factory = new accc_ApexObjectFactory();


        // iterate over known list
        for (String fqn : myFQN) {
            // assertion
            System.assertEquals(true, accc_ApexObjectFactoryTest.assertion(fqn, factory));
        }

    } // end of testCreateItems

    /**
     * @description Test adding and creating items to the factory
     */
    @isTest
    static void testAddItems() {
        // arrange
        accc_IApexFactory factory = new accc_ApexObjectFactory();
        Map<String, Type> myNames = new Map<String, Type> {
            'defaultLogger' => accc_ApexLogger.class,
            'exceptionDeal' => accc_ApexExceptionHandler.class
        };

        // act

        for (String key : myNames.keySet()) {
            // add our types
            factory.add(key, myNames.get(key));

        }
        // assert
        for (String name : myNames.keySet()) {
            // assertion
            System.assertEquals(true, accc_ApexObjectFactoryTest.assertion(name, factory));
        }

    } // end of testAddItems

    /**
     * @description Test creating items  by namespace from the factory
     */
    @isTest
    static void testCreateItemsWithNamespace() {
        // arrange
        accc_IApexFactory factory = new accc_ApexObjectFactory();
        Map<String, Type> myNames = new Map<String, Type> {
            'defaultLogger' => accc_ApexLogger.class,
            'exceptionDeal' => accc_ApexExceptionHandler.class
        };

        // act

        for (String key : myNames.keySet()) {
            // add our types
            factory.add(key, myNames.get(key));

        }

        // assert
        for (String name : myNames.keySet()) {
            // assertion
            System.assertEquals(true, accc_ApexObjectFactoryTest.assertionWithNamespace(name, factory));
        }

    } // end of testCreateItemsWithNamespace

    /**
     * @description Test creating items  by type from the factory
     */
    @isTest
    static void testCreateItemsWithType() {
        // arrange
        accc_IApexFactory factory = new accc_ApexObjectFactory();
        Map<String, Type> myNames = new Map<String, Type> {
            'defaultLogger' => accc_ApexLogger.class,
            'exceptionDeal' => accc_ApexExceptionHandler.class
        };

        // act

        for (String key : myNames.keySet()) {
            // add our types
            factory.add(key, myNames.get(key));

        }
        // assert
        for (String name : myNames.keySet()) {
            // assertion
            System.assertEquals(true, accc_ApexObjectFactoryTest.assertionWithType((Type)myNames.get(name), factory));
        }

    } // end of testCreateItemsWithType

    @isTest
    static void testaddToCollection() {
        // arrange
        accc_ApexObjectFactory factory = new accc_ApexObjectFactory();
        accc_ApexClassInstanceMgr mgr = new accc_ApexClassInstanceMgr('Account');

        // act
        factory.addToCollection('act', mgr);
        system.assertNotEquals(null, factory.create('act'));
    } // end of testaddToCollection

    @isTest
    static void testadd() {
        // arrange
        accc_ApexObjectFactory factory = new accc_ApexObjectFactory();
        accc_ApexClassInstanceMgr mgr = new accc_ApexClassInstanceMgr('Account');

        // act
        factory.add( mgr);
        system.assertNotEquals(null, factory.keys().contains('Account'));
    } // end of testadd

     @isTest
    static void testaddWithDifferentType() {
        // arrange
        accc_ApexObjectFactory factory = new accc_ApexObjectFactory();
        accc_IApexObjectGetter  mgr = new accc_ApexClassInstanceMgr('Account');

        // act
        factory.add( mgr);
        system.assertNotEquals(null, factory.keys().contains('Account'));
    } // end of testaddWithDifferentType
    
    @isTest
    static void testobjectCollection() {
        // arrange
        accc_ApexObjectFactory factory = new accc_ApexObjectFactory();

        // act
        system.assertNotEquals(null, factory.objectCollection());
    } // end of testobjectCollection

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //
    //Private Methods
    ///////////////////////////////////////////////////////////////////////////////////////////////


    /**
     * @description make an assertion
     *
     * @param name lookup string
     * @param factory accc_IApexFactory
     * @return true if the assertion was correct
     */
    private static Boolean assertion(String name, accc_IApexFactory factory) {
        // act
        Object result = factory.create(name);
        // assert
        return result != null;
    } // end of assertion

    /**
     * @description make an assertion with namespace
     *
     * @param name lookup string
     * @param factory accc_IApexFactory
     * @return true if the assertion was correct
     */
    private static Boolean assertionWithNamespace(String name, accc_IApexFactory factory) {
        // act
        Object result = factory.create('', name);
        // assert
        return result != null;
    } // end of assertionWithNamespace

    /**
     * @description make an assertion with Type
     *
     * @param name lookup string
     * @param factory accc_IApexFactory
     * @return true if the assertion was correct
     */
    private static Boolean assertionWithType(Type name, accc_IApexFactory factory) {
        // act
        Object result = factory.create(name);
        // assert
        return result != null;
    } // end of assertionWithType

} // end of accc_ApexObjectFactoryTest