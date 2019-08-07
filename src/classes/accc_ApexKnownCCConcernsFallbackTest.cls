/**
 * Copyright (c) 2016-2019, Bill Anderson All rights reserved.
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
 * @description Test the cross-cutting concerns fallback resources
 *
 * @group Common Test Layer
 */
@isTest
private class accc_ApexKnownCCConcernsFallbackTest {
    // known resources
    static final List<String> KnownResources = new List<String> {
        accc_ApexConstants.CacheResource
        , accc_ApexConstants.CacheStrategy
        , accc_ApexConstants.CacheStrategyInvocation
        , accc_ApexConstants.ConfigurationResource
        , accc_ApexConstants.LoggerResource
        , accc_ApexConstants.ExceptionHandler
        , accc_ApexConstants.ExceptionFormatter
        , accc_ApexConstants.LogFormatter
        , accc_ApexConstants.SendEmailChannel
        , accc_ApexConstants.ExceptionPolicyHandler
        , accc_ApexConstants.PreviousTransactionResultResource
        , accc_ApexConstants.FactoryResource
        , accc_ApexConstants.FallbackResource
        , accc_ApexConstants.RuntimeEnvironment

    };

    @isTest
    static void testctor() {
        // assign / act
        accc_IFallbackResources resource = new accc_ApexKnownCCConcernsFallback();
        // assert
        system.assertNotEquals(null, resource);
    }
    @isTest
    static void testctorBadParam() {
        // assign
        accc_IFallbackResources resource = null;
        Exception expected = null;
        try {
            // act
            resource = new accc_ApexKnownCCConcernsFallback('');
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
        accc_IFallbackResources resource = new accc_ApexKnownCCConcernsFallback();
        Object result = resource.fallbackResource();
        // assert
        system.assertNotEquals(null, result);
    } // end of testfallbackResource


    @isTest
    static void testtoString() {
        // assign / act
        accc_IFallbackResources resource = new accc_ApexKnownCCConcernsFallback();
        String result = resource.toString();
        // assert
        system.assertEquals(true, result.length() > 1);
    } // end of testtoString


    @isTest
    static void testget() {
        // assign / act
        accc_IFallbackResources resource = new accc_ApexKnownCCConcernsFallback();
        for ( string item : KnownResources) {
            // we expect actual class names -- let's check
            Type resultType = Type.forName((String) resource.get(accc_ApexConstants.CategoryInterface_s, item));
            // assert
            system.assertNotEquals(null, resultType);
            resultType = Type.forName((String) resource.get(accc_ApexConstants.CategoryConcrete_s, item));
            // assert
            system.assertNotEquals(null, resultType);
        }
    } // end of testget

    @isTest
    static void testgetWithBadData() {
        // assign / act
        accc_IFallbackResources resource = new accc_ApexKnownCCConcernsFallback();
        for ( string item : KnownResources) {
            Object result = resource.get(accc_ApexConstants.CategoryInterface_s, item + '*123*bad*index*');
            // assert
            system.assertEquals(null, result );
        }
    } // end of testgetWithBadData

} // end of accc_ApexKnownCCConcernsFallbackTest