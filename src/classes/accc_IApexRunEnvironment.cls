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
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE
 *
 *
 * @author Bill Anderson
 * @description Provides the defined interfaces used in the runtime environment.
 *     This includes a configuraiton provider, logger, etc. These are the main cross-cutting concerns.
 *     However, if one of the resources you need does not have the method to expose the value.
 *     then use the 'objectFactory()' method to pull it out explicitly by name. For example,
 *     the 'logFormatter' is not an exposed method, but can be retrieved by :
 *     
 *           objectFactory().create(accc_ApexConstants.LogFormatter);
 *     
 * @group Common Interface Layer
 */
public virtual interface accc_IApexRunEnvironment {

    /**
     * @description A factory to create the cross-cutting concerns used in the runtime
     * @return accc_IApexFactory runtime factory creator
     */
    accc_IApexFactory objectFactory();

    /**
     * @description get the configuration provider; if none defined, return the default one
     * @return accc_IConfigurationProvider that allows access to runtime-related environment (i.e. soft-assertion is on, etc)
     */
    accc_IConfigurationProvider provider();

    /**
     * @description get the logger; if none defined, return the default one
     * @return accc_ILogger
     */
    accc_ILogger logger();

    /**
     * @description Fallback runtime resources
     * @return accc_IFallbackResources that provide  values to drive runtime
     */
    accc_IFallbackResources fallbackResources();

    /**
     * @description Exception handler
     * @return accc_IApexExceptionHandler that provide handling of the exception consistently (based on policy)
     */
    accc_IApexExceptionHandler exceptionhandler();

    /**
     * @description for caching information
     * @return accc_ICache
     */
    accc_ICache cache();

    /**
     * @description previous transaciton result
     * @return accc_IPreviousTransactionResult
     */
    accc_IPreviousTransactionResult transactionResult();

    /**
     * @description cache strategy policy
     * @return accc_IApexCachePolicyStrategy the caching policy strategy
     */
     accc_IApexCachePolicyStrategy cachePolicyStrategy();
    /**
     * @description cache strategy invocation
     * @return accc_IApexCacheStrategyInvocation the caching strategy
     */
    accc_IApexCacheStrategyInvocation cacheStrategyInvocation();
       
    /**
     * @description send messages
     * @return accc_IApexMessageSender
     */
    accc_IApexMessageSender messageSender();

    ////////////////////////////////////////////////////////////////////////
    //
    // SETTERS
    ////////////////////////////////////////////////////////////////////////
    /**
     * @description set the configuration provider
     *
     * @param provider the configuration provider
     */
    void provider(accc_IConfigurationProvider provider);

    /**
     * @description set the logger
     *
     * @param logger the logger
     */
    void logger(accc_ILogger logger);

    /**
     * @description A factory to create the cross-cutting concerns used in the runtime
     *
     * @param factory accc_IApexFactory
     */
    void objectFactory(accc_IApexFactory factory);

    /**
     * @description sets the fallback resources that provide  values to drive runtime
     *
     * @param resources accc_IFallbackResources that provide  values to drive runtime
     */
    void fallbackResources(accc_IFallbackResources resources);

    /**
     * @description set Exception handler
     * @param accc_IApexExceptionHandler that provide handling of the exception consistently (based on policy)
     */
    void exceptionhandler(accc_IApexExceptionHandler handler);

    /**
     * @description set cache handler
     * 
     * @param transacitonResult ICache
     */
    void cache(accc_ICache runTimeCache);

    /**
     * @description set previous transaciton result
     * 
     * @param transacitonResult accc_IPreviousTransactionResult
     */
    void transactionResult(accc_IPreviousTransactionResult transacitonResult);

    /**
    * @description set the cache strategy invocation
    *
    * @param accc_IApexCacheStrategyInvocation cache strategy
    */
    void cacheStrategyInvocation(accc_IApexCacheStrategyInvocation cacheStrategyInvo);
 
    /**
    * @description set the cache strategy polict
    *
    * @param accc_IApexCachePolicyStrategy cache policy
    */
    void cachePolicyStrategy(accc_IApexCachePolicyStrategy theCachePolicyStrategy);
    /**
     * @description set the message sender
     * @param accc_IApexMessageSender set message channel
     */
    void messageSender(accc_IApexMessageSender theMessageSender) ;
} // end of accc_IApexRunEnvironment