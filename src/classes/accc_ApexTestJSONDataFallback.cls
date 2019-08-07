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
 * @description Name/Value pair for the fallback resources use in tests
 * @group Fallback Resources
 */
public class accc_ApexTestJSONDataFallback  extends accc_ApexBaseFallback {

    ////////////////////////////////////////////////////////////////////////////////
    /// Data Members
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * Define the fallback resources (JSON), we want
     */
    private static final String DefaultStaticResource = '{' +
            //
            // Cross-Cutting resources (interfaces)
            //
            '"' + accc_ApexConstants.CategoryInterface_s + '":' +
            '{' +
            '"' + accc_ApexConstants.CacheResource + '": "accc_ICache",' +
            '"' + accc_ApexConstants.CacheStrategy + '": "accc_IApexCachePolicyStrategy",' +
            '"' + accc_ApexConstants.CacheStrategyInvocation + '": "accc_IApexCacheStrategyInvocation",' +
            '"' + accc_ApexConstants.ConfigurationResource + '": "accc_IConfigurationProvider",' +
            '"' + accc_ApexConstants.LoggerResource + '": "accc_ILogger",' +
            '"' + accc_ApexConstants.LogFormatter + '": "accc_IDataFormat",' +
            '"' + accc_ApexConstants.ExceptionHandler + '": "accc_IApexExceptionHandler",' +
            '"' + accc_ApexConstants.ExceptionFormatter + '": "accc_IDataFormat",' +
            '"' + accc_ApexConstants.SendEmailChannel + '": "accc_IApexMessageSender",' +
            '"' + accc_ApexConstants.ExceptionPolicyHandler + '": "accc_IApexExceptionPolicyStrategy",' +
            '"' + accc_ApexConstants.PreviousTransactionResultResource + '": "accc_IApexPreviousTransactionResult",' +
            '"' + accc_ApexConstants.FactoryResource + '": "accc_IApexFactory",' +
            '"' + accc_ApexConstants.FallbackResource + '": "accc_IFallbackResources",' +
            '"' + accc_ApexConstants.RuntimeEnvironment + '": "accc_IApexRunEnvironment"'  +
            '},' +
            //
            // Cross-Cutting resources (implementation)
            //

            '"' + accc_ApexConstants.CategoryConcrete_s + '":' +
            '{' +
            '"' + accc_ApexConstants.CacheResource + '": "accc_ApexCache",' +
            '"' + accc_ApexConstants.CacheStrategy + '": "accc_ApexCachePolicyStrategy",' +
            '"' + accc_ApexConstants.CacheStrategyInvocation + '": "accc_ApexCacheStrategyInvocation",' +
            '"' + accc_ApexConstants.ConfigurationResource + '": "accc_VirtualCustomSettings",' +
            '"' + accc_ApexConstants.LoggerResource + '": "accc_ApexLogger",' +
            '"' + accc_ApexConstants.LogFormatter + '": "accc_ApexLogFormatter",' +
            '"' + accc_ApexConstants.ExceptionHandler + '": "accc_ApexExceptionHandler",' +
            '"' + accc_ApexConstants.ExceptionFormatter + '": "accc_ExceptionFormatter",' +
            '"' + accc_ApexConstants.SendEmailChannel + '": "accc_ApexMailMessageSender",' +
            '"' + accc_ApexConstants.ExceptionPolicyHandler + '": "accc_ApexExceptionPolicyStrategy",' +
            '"' + accc_ApexConstants.PreviousTransactionResultResource + '": "accc_ApexPreviousTransactionResult",' +
            '"' + accc_ApexConstants.FactoryResource + '": "accc_ApexObjectFactory",' +
            '"' + accc_ApexConstants.FallbackResource + '": "accc_ApexTestJSONDataFallback",' +
            '"' + accc_ApexConstants.RuntimeEnvironment + '": "accc_ApexBaseRuntimeEnvironment"'  +
            '},' +
            '"' + accc_ApexConstants.UseCachingStrategy_r + '": "true",' +
            '"' + accc_ApexConstants.TriggersEnabled_r + '": "true",' +
            '"' + accc_ApexConstants.TraceFlagOn_r + '": "true",' +
            '"' + accc_ApexConstants.TraceLogLevel_r + '": "debug",' +
            '"' + accc_ApexConstants.ShowCCTraceInfo_r + '": "false",' +
            '"' + accc_ApexConstants.SoftAsserts_r + '": "true",' +
            '"' + accc_ApexConstants.EnvironmentClass_r + '": "TestEnvironmentSingleton",' +
            '"' + accc_ApexConstants.MaxChunkSize_r + '": "' + integer.valueOf(accc_ApexConstants.DEFAULT_MAX_NUMBER_OF_ITEMS_IN_CHUNK) + '"' +
            '}';

    ////////////////////////////////////////////////////////////////////////////////
    /// Ctor
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description default ctor
     */
    public accc_ApexTestJSONDataFallback() {
        super(accc_ApexTestJSONDataFallback.DefaultStaticResource);
    } // end of ctor

    /**
     * @description ctor , holds json data of resources
     *
     * @param defaultValue holds json data of resources
     */
    public accc_ApexTestJSONDataFallback(String defaultValue) {
        super(defaultValue);
    } // end of ctor

} // end of accc_ApexTestJSONDataFallback