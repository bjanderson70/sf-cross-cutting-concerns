/**
 * Copyright (c) 2016-2019, Bill Anderson .  All rights reserved.
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
 *   * Neither the name of Bill Anderson the names of its
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
 * @description test the test environment singleton
 * @group Common Test Layer
 */
@isTest
private class accc_TestEnvironmentSingletonTest {

    //
    // all operations should return a valid value. The check casts to the underlying
    // interface to ensure the correct value is asserted
    //
    @isTest static void testMethodsValidity() {
        accc_IApexRunEnvironment env = accc_TestEnvironmentSingleton.getInstance();
        accc_IConfigurationProvider provider = env.provider();
        accc_ILogger logger = env.logger();
        accc_IFallbackResources fallback = env.fallbackResources();
        accc_IApexFactory factory = env.objectFactory();
        accc_IApexExceptionHandler excpHandler = env.exceptionhandler();
        accc_ICache cache = env.cache();
        accc_IPreviousTransactionResult previousResult = env.transactionResult();

        system.assertEquals( accc_ApexTestUtilities.isProvider(provider), true);
        system.assertEquals( accc_ApexTestUtilities.isLogger(logger), true);
        system.assertEquals( accc_ApexTestUtilities.isFallback(fallback), true);
        system.assertEquals( accc_ApexTestUtilities.isFactory(factory), true);
        system.assertEquals( accc_ApexTestUtilities.isExceptionHandler(excpHandler), true);
        system.assertEquals( accc_ApexTestUtilities.isCache(cache), true);
        system.assertEquals( accc_ApexTestUtilities.isPreviousTransactionResult(previousResult), true);

    } // end of testMethodsValidity

    //
    // All values should be present; however, the wrong comparison/casting should cause
    // exceptions and return of null
    //
    @isTest static void testMethodsInValid() {
        accc_IApexRunEnvironment env = accc_TestEnvironmentSingleton.getInstance();
        accc_IConfigurationProvider provider = env.provider();
        accc_ILogger logger = env.logger();
        accc_IFallbackResources fallback = env.fallbackResources();
        accc_IApexFactory factory = env.objectFactory();
        accc_IApexExceptionHandler excpHandler = env.exceptionhandler();
        accc_ICache cache = env.cache();


        system.assertNotEquals( accc_ApexTestUtilities.isLogger(provider), true);
        system.assertNotEquals( accc_ApexTestUtilities.isProvider(logger), true);
        system.assertNotEquals( accc_ApexTestUtilities.isFactory(fallback), true);
        system.assertNotEquals( accc_ApexTestUtilities.isLogger(factory), true);
        system.assertNotEquals( accc_ApexTestUtilities.isFallback(excpHandler), true);
        system.assertNotEquals( accc_ApexTestUtilities.isFallback(cache), true);

    } // end of testMethodsInValid
    //
    // Test the methods are valid even of the values are set to null
    //
    @isTest static void testSetMethodsAreValid() {
        accc_IApexRunEnvironment env = accc_TestEnvironmentSingleton.getInstance();
        //
        // even if we set the value to null, the singleton should re-creates the values
        //
        env.provider(null);
        accc_IConfigurationProvider provider = env.provider();
        env.logger(null);
        accc_ILogger logger = env.logger();
        env.fallbackResources(null);
        accc_IFallbackResources fallback = env.fallbackResources();
        env.objectFactory(null);
        accc_IApexFactory factory = env.objectFactory();
        env.exceptionhandler(null);
        accc_IApexExceptionHandler excpHandler = env.exceptionhandler();
        accc_ICache cache = env.cache();

        system.assertEquals( accc_ApexTestUtilities.isLogger(logger), true);
        system.assertEquals( accc_ApexTestUtilities.isProvider(provider), true);
        system.assertEquals( accc_ApexTestUtilities.isFactory(factory), true);
        system.assertEquals( accc_ApexTestUtilities.isFallback(fallback), true);
        system.assertEquals( accc_ApexTestUtilities.isExceptionHandler(excpHandler), true);
        system.assertEquals( accc_ApexTestUtilities.isCache(cache), true);

    } // end of testSetMethodsAreValid

} // end of accc_TestEnvironmentSingletonTest