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
 * @description Implementation of the apex runtime environment for cross-cutting concerns.
 *     This class is a convience class as these values can be extracted from the factory, if so loaded.
 * @group Common Layer
 */
public virtual without sharing class accc_ApexBaseRuntimeEnvironment implements accc_IApexRunEnvironment {

    ////////////////////////////////////////////////////////////////////////////////
    /// Data Members
    ////////////////////////////////////////////////////////////////////////////////

    // data members are made static as they are not likely to change and save in
    // the cost of construction/destruction
    //
    private static final String ResourceIdentifier_r = 'accc_ApexBaseRuntimeEnvironment-id';
    private static final accc_ApexLocalL1Cache ccResources = new accc_ApexLocalL1Cache(ResourceIdentifier_r);

    private static accc_IApexFactory aFactory = null;
    private static accc_IConfigurationProvider aProvider = null;
    private static accc_ILogger aLogger = null;
    private static accc_IFallbackResources aResource = null;
    private static accc_IApexExceptionHandler anExceptionHandler = null;
    private static accc_ICache aCache = null;
    private static accc_IPreviousTransactionResult aTransactionResult = null;
    private static accc_IApexCachePolicyStrategy aCachePolicyStrategy = null;
    private static accc_IApexCacheStrategyInvocation aCacheStrategyInvocation = null;
    private static accc_IApexMessageSender aMessageSender = null;


    ////////////////////////////////////////////////////////////////////////////////
    /// Ctors / Class Initialization
    ////////////////////////////////////////////////////////////////////////////////
    //static {
    //    // initially all resources are null
    //    for ( String key : accc_ApexConstants.CC_AllResourceNames) {
    //        accc_ApexBaseRuntimeEnvironment.ccResources.put(key, null);
    //    }
    //}

    ////////////////////////////////////////////////////////////////////////////////
    /// Public Methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description get the creator the objects from the known list
     * @return a factory to create objects
     */
    public virtual accc_IApexFactory objectFactory() {
        accc_IApexFactory result = (accc_IApexFactory)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.ObjectFactory);
        if ( result == null ) {
            // default  factory, subject to change
            result =  (accc_IApexFactory)accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.ObjectFactory, new accc_ApexObjectFactory());
        }

        return result;
    } // end of objectFactory

    /**
     * @description get the configuration provider; if none defined, return the default one
     * @return accc_IConfigurationProvider that allows access to runtime-related environment (i.e. soft-assertion is on, etc)
     */
    public virtual accc_IConfigurationProvider provider() {
        accc_IConfigurationProvider result = (accc_IConfigurationProvider)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.ConfigurationResource);
        if ( result == null ) {
            result = (accc_IConfigurationProvider) accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.ConfigurationResource,
                     this.objectFactory().create(accc_ApexConstants.ConfigurationResource));
        }

        return result;
    } // end of provider

    /**
     * @description get the logger; if none defined, return the default one
     * @return accc_ILogger
     */
    public virtual accc_ILogger logger() {
        accc_ILogger result = (accc_ILogger)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.LoggerResource);
        if ( result == null ) {
            result =  (accc_ILogger) accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.LoggerResource,
                      this.objectFactory().create(accc_ApexConstants.LoggerResource));
        }

        return result;
    } // end of logger

    /**
     * @description get fallback resources; if none defined, return the default one
     * @return accc_IFallbackResources the fallback resource
     */
    public virtual accc_IFallbackResources fallbackResources() {
        accc_IFallbackResources result = (accc_IFallbackResources)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.FallbackResource);
        if ( result == null ) {
            result = (accc_IFallbackResources) accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.FallbackResource,
                     this.objectFactory().create(accc_ApexConstants.FallbackResource));
        }

        return result;
    } // end of fallbackResources

    /**
     * @description get the Exception handler
     * @return accc_IApexExceptionHandler that provide handling of the exception consistently (based on policy)
     */
    public virtual accc_IApexExceptionHandler exceptionHandler() {
        accc_IApexExceptionHandler result = (accc_IApexExceptionHandler)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.ExceptionHandler);
        if ( result == null ) {
            result =  (accc_IApexExceptionHandler) accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.ExceptionHandler,
                      this.objectFactory().create(accc_ApexConstants.ExceptionHandler));
        }

        return result;
    } // end of exceptionHandler

    /**
     * @description get the cache
     * @return accc_ICache
     */
    public virtual accc_ICache cache() {
        accc_ICache result = (accc_ICache)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.CacheResource);
        if ( result == null ) {
            result = (accc_ICache) accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.CacheResource,
                     this.objectFactory().create(accc_ApexConstants.CacheResource));
        }

        return result;
    } // end of cache
    /**
     * @description get the cache strategy invocation
     * @return accc_IApexCacheStrategyInvocation the caching strategy
     */
    public virtual accc_IApexCacheStrategyInvocation cacheStrategyInvocation() {
        accc_IApexCacheStrategyInvocation result = (accc_IApexCacheStrategyInvocation)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.CacheStrategyInvocation);
        if ( result == null ) {
            result = (accc_IApexCacheStrategyInvocation) accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.CacheStrategyInvocation,
                     this.objectFactory().create(accc_ApexConstants.CacheStrategyInvocation));
        }

        return result;
    } // end of cacheStrategyInvocation

    /**
    * @description get the cache strategy policy
    * @return accc_IApexCachePolicyStrategy the caching policy strategy
    */
    public virtual accc_IApexCachePolicyStrategy cachePolicyStrategy() {
        accc_IApexCachePolicyStrategy result = (accc_IApexCachePolicyStrategy)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.CacheStrategy);
        if ( result == null ) {
            result  = (accc_IApexCachePolicyStrategy) accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.CacheStrategy,
                      this.objectFactory().create(accc_ApexConstants.CacheStrategy));
        }

        return result;
    } // end of cachePolicyStrategy
    /**
     * @description get the transaction result
     * @return accc_IPreviousTransactionResult
     */
    public virtual accc_IPreviousTransactionResult transactionResult() {
        accc_IPreviousTransactionResult result = (accc_IPreviousTransactionResult)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.PreviousTransactionResultResource);
        if ( result == null ) {
            result   = (accc_IPreviousTransactionResult)accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.PreviousTransactionResultResource,
                       this.objectFactory().create(accc_ApexConstants.PreviousTransactionResultResource));
        }

        return result;
    } // end of transactionResult
    /**
     * @description get the sender of messages
     * @return accc_IApexMessageSender
     */
    public virtual accc_IApexMessageSender messageSender() {
        accc_IApexMessageSender result = (accc_IApexMessageSender)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.SendEmailChannel);
        if ( result == null ) {
            result   = (accc_IApexMessageSender)  accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.SendEmailChannel,
                       this.objectFactory().create(accc_ApexConstants.SendEmailChannel));
        }

        return result;
    } // end of messageSender
    //////////////////////////////////////////////////////////////////////
    // Setters
    //////////////////////////////////////////////////////////////////////

    /**
     * @description set the configuration provider
     *
     * @param provider the configuration provider
     */
    public void provider(accc_IConfigurationProvider provider) {
        accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.ConfigurationResource, provider);

    } // end of provider

    /**
     * @description set the logger
     *
     * @param logger the logger
     */
    public void logger(accc_ILogger logger) {
        accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.LoggerResource, logger);
    } // end of logger

    /**
     * @description factory to create  objects used
     *
     * @param factory creates test related objects
     */
    public void objectFactory(accc_IApexFactory factory) {
        accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.ObjectFactory, factory);
    } // end of objectFactory

    /**
     * @description sets the fallback resources that provide  values to drive tests
     *
     * @param resources creates  related fallback resources
     */
    public void fallbackResources(accc_IFallbackResources resources) {
        accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.FallbackResource, resources);
    } // end of fallbackResources

    /**
     * @description sets the fallback resources that provide  values to drive tests
     *
     * @param handler defines how to handle and exception
     */
    public void exceptionHandler(accc_IApexExceptionHandler handler) {
        accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.ExceptionHandler, handler);
    } // end of fallbackResources

    /**
     * @description set the cache
     *
     * @param cache accc_ICache
     */
    public void cache(accc_ICache cache) {
        accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.CacheResource, cache);
    } // end of cache

    /**
     * @description set the previous transacton result
     *
     * @param result accc_IPreviousTransactionResult
     */
    public void transactionResult(accc_IPreviousTransactionResult result) {
        accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.PreviousTransactionResultResource, result);
    } // end of thePreviousTransactionResult

    /**
    * @description set the cache strategy invocation
    *
    * @param accc_IApexCacheStrategyInvocation cache strategy
    */
    public void cacheStrategyInvocation(accc_IApexCacheStrategyInvocation cacheStrategyInvo) {
        accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.CacheStrategyInvocation, cacheStrategyInvo);
    } // end of cacheStrategyInvocation


    /**
    * @description set the cache strategy polict
    *
    * @param accc_IApexCachePolicyStrategy cache policy
    */
    public void cachePolicyStrategy(accc_IApexCachePolicyStrategy theCachePolicyStrategy) {
        accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.CacheStrategy, theCachePolicyStrategy);
    } // end of cachePolicyStrategy
    /**
     * @description set the message sender
     * @parsam accc_IApexMessageSender message channel
     */
    public void messageSender(accc_IApexMessageSender theMessageSender) {
        accc_ApexBaseRuntimeEnvironment.ccResources.put(accc_ApexConstants.SendEmailChannel, theMessageSender);
    } // end of messageSender
    ////////////////////////////////////////////////////////////////////////////////
    /// Protected  Properties
    ////////////////////////////////////////////////////////////////////////////////

    // NOTE: (Ugly Hack)
    //
    // The properties below were a hack to allow a child class that is a Singleton
    // access to the private static resources. Unfortunately, a child which is a singleton
    // does not retain a single copy if used in more than one method ( verified via tests).
    // As such, to avoid the new/delete lifecycle, the values were made static and access to children
    // was provided via the properties below
    //

    /**
     * @description Just return the current factory
     *
     * @return accc_IApexFactory the Factory
     */
    @TestVisible
    protected accc_IApexFactory theFactory {
        get {
            return (accc_IApexFactory)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.ObjectFactory);
        }
    } // end of theFactory

    /** @description Just return the current resource
    *
    * @return accc_IFallbackResources the Resource
    */
    @TestVisible
    protected accc_IFallbackResources theResource {
        get {
            return (accc_IFallbackResources)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.FallbackResource);
        }
    } // end of theResources


    /** @description Just return the current exception handler
    *
    * @return accc_IApexExceptionHandler the ExceptionHandler
    */
    @TestVisible
    protected accc_IApexExceptionHandler theExceptionHandler {
        get {
            return (accc_IApexExceptionHandler)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.ExceptionHandler);
        }
    } // end of theExceptionHandler

    /**
     * @description Just return the current provider
     *
     * @return accc_IConfigurationProvider the Provider
     */
    @TestVisible
    protected accc_IConfigurationProvider theProvider {
        get {
            return (accc_IConfigurationProvider)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.ConfigurationResource);
        }
    } // end of theProvider


    /** @description Just return the current logger
    *
    * @return accc_ILogger the Logger
    */
    @TestVisible
    protected accc_ILogger theLogger {
        get {
            return (accc_ILogger)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.LoggerResource);
        }
    } // end of theLogger


    /**
     * @description Just return the current cache
     *
     * @return accc_ICache the Cache
     */
    @TestVisible
    protected accc_ICache theCache {
        get {
            return (accc_ICache)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.CacheResource);
        }
    } // end of theCache


    /** @description Just return the current cache policy strategy
    *
    * @return  accc_IApexCachePolicyStrategy the Cache Policy Strategy
    */
    @TestVisible
    protected accc_IApexCachePolicyStrategy theCachePolicyStrategy {
        get {
            return (accc_IApexCachePolicyStrategy)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.CacheStrategy);
        }
    } // end of theCachePolicyStrategy


    /**
     * @description Just return the current cache strategy innocation
     *
     * @return  accc_IApexCacheStrategyInvocation the Cache Strategy Invocation
     */
    @TestVisible
    protected accc_IApexCacheStrategyInvocation theCacheStrategyInvocation {
        get {
            return (accc_IApexCacheStrategyInvocation)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.CacheStrategyInvocation);
        }
    } // end of theCacheStrategyInvocation

    /** @description Just return the previous transacton result
    *
    * @return  accc_IPreviousTransactionResult the Previous Transaction Result
    */
    @TestVisible
    protected accc_IPreviousTransactionResult thePreviousTransactionResult {
        get {
            return (accc_IPreviousTransactionResult)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.PreviousTransactionResultResource);
        }
    } // end of thePreviousTransactionResult


    /** @description Just return the message sender
    *
    * @return  accc_IApexMessageSender the Message Sender
    */
    @TestVisible
    protected accc_IApexMessageSender theMessageSender {
        get {
            return (accc_IApexMessageSender)accc_ApexBaseRuntimeEnvironment.ccResources.get(accc_ApexConstants.SendEmailChannel);
        }
    } // end of theMessageSender
}