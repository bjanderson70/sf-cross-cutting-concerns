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
 * @author Bill Anderson
 * @description Use for common test for accc_ApexUtilities
 * @group Common Test Layer
 */
@isTest
public without sharing class accc_ApexTestUtilities extends accc_ApexUtilities {
    ////////////////////////////////////////////////////////////////////////////////
    /// Data Members
    ////////////////////////////////////////////////////////////////////////////////

    public static final String AssertResource = 'Asserts';
    public static final String FallbackTestResource = 'FallbackTestResource';
    public static final String CustomResourceNameInSalesforce = 'TestUtilityData';
    public static final String AttributeIsOn = 'on';
    public static final String AttributeIsOff = 'off';
    public static final String AttributeSoftAssert = 'SoftAssert';

    ////////////////////////////////////////////////////////////////////////////////
    /// Ctors
    ////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////
    /// Public Methods
    ////////////////////////////////////////////////////////////////////////////////

    //
    // is it a provider
    //
    public static Boolean isProvider(Object obj) {
        try {
            accc_IConfigurationProvider isConfig = (accc_IConfigurationProvider) obj;

            if ( isConfig != null ) {
                return true;
            }
        } catch (Exception excp) {}

        return false;
    } // end of isProvider

    //
    // is it a logger
    //
    public static Boolean isLogger(Object obj) {
        try {
            accc_ILogger isLogger = (accc_ILogger)obj;

            if ( isLogger != null ) {
                return true;
            }
        } catch (Exception excp) {}

        return false;
    } // end of isLogger

    //
    // is a fallback resource
    //
    public static Boolean isFallback(Object obj) {
        try {
            accc_IFallbackResources fb = (accc_IFallbackResources)obj;

            if ( fb != null ) {
                return true;
            }
        } catch (Exception excp) {}

        return false;
    } // end of isFallback

    //
    // is a factory
    //
    public static Boolean isFactory(Object obj) {
        try {
            accc_IApexFactory factory = (accc_IApexFactory)obj;

            if ( factory != null ) {
                return true;
            }
        } catch (Exception excp) {}

        return false;
    } // end of isFactory

    //
    // is a exception handler
    //
    public static Boolean isExceptionHandler(Object obj) {
        try {
            accc_IApexExceptionHandler handler = (accc_IApexExceptionHandler)obj;

            if ( handler != null ) {
                return true;
            }
        } catch (Exception excp) {}

        return false;
    } // end of isExceptionHandler

    //
    // is a cache handler
    //
    public static Boolean isCache(Object obj) {
        try {
            accc_ICache  handler = (accc_ICache)obj;

            if ( handler != null ) {
                return true;
            }
        } catch (Exception excp) {}

        return false;
    } // end of isCache

    //
    // is a isPreviousTransactionResult handler
    //
    public static Boolean isPreviousTransactionResult(Object obj) {
        try {
            accc_IPreviousTransactionResult handler = (accc_IPreviousTransactionResult)obj;

            if ( handler != null ) {
                return true;
            }
        } catch (Exception excp) {}

        return false;
    } // end of isPreviousTransactionResult

    //
    // is a isCachePolicyStrategy handler
    //
    public static Boolean isCachePolicyStrategy(Object obj) {
        try {
            accc_IApexCachePolicyStrategy handler = (accc_IApexCachePolicyStrategy)obj;

            if ( handler != null ) {
                return true;
            }
        } catch (Exception excp) {}

        return false;
    } // end of isCachePolicyStrategy

    //
    // is a isCacheStrategyInvocation handler
    //
    public static Boolean isCacheStrategyInvocation(Object obj) {
        try {
            accc_IApexCacheStrategyInvocation handler = (accc_IApexCacheStrategyInvocation)obj;

            if ( handler != null ) {
                return true;
            }
        } catch (Exception excp) {}

        return false;
    } // end of isCacheStrategyInvocation

    //
    // is a isMessageSender handler
    //
    public static Boolean isMessageSender(Object obj) {
        try {
            accc_IApexMessageSender handler = (accc_IApexMessageSender)obj;

            if ( handler != null ) {
                return true;
            }
        } catch (Exception excp) {}

        return false;
    } // end of isMessageSender


} // end of accc_ApexTestUtilities