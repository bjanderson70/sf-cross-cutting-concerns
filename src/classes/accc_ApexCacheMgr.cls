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
 * @description Encapsulates all behaviour logic relating to the caching.
 *
 * The caching manager uses the runtime environment to determine the,
 *  + cache strategy
 *  + cache invocation
 *  + cache resources
 *
 * Instead of using all the different cache mechanisms, this class manages most
 * of those aspect for you. Whether to cache or not, simply call the following:
 *
 * @group Cache Aspects
 */
public virtual without sharing class accc_ApexCacheMgr  {
	/*---------------------------------------------------------------------------------------
	 * DATA MEMBERS
	 *---------------------------------------------------------------------------------------
	 **/
	static accc_ApexLocalL1Cache l1Cache = new  accc_ApexLocalL1Cache('accc_ApexCacheMgr');

	/*---------------------------------------------------------------------------------------
	 * PUBLIC PROPERTIES
	 *---------------------------------------------------------------------------------------
	 **/
	public boolean useCacheStrategy { get; protected set;}
	/**
	 * @description cache
	 * @return accc_ICache, cache
	 */
	public accc_ICache theCache { get; protected set;}
	/**
	 * @description cache strategy
	 * @return accc_IApexCachePolicyStrategy, cache strategy
	 */
	public accc_IApexCachePolicyStrategy theCacheStrategy { get; protected set;}
	/**
	* @description cache invocation
	* @return accc_IApexCacheStrategyInvocation, cache invocation
	*/
	public accc_IApexCacheStrategyInvocation theCacheStrategyInvocation { get; protected set;}

	/*---------------------------------------------------------------------------------------
	 * CTORS
	 *---------------------------------------------------------------------------------------
	 **/
	/**
	 * @description default ctor; use cache strategy is based on your provider settings
	 *
	 * @example
	 *
	 * 	accc_ApexCacheMgr mgr = new accc_ApexCacheMgr() ; // default ctor, uses caching strategy
	 * 	SomeData data= new SomeData();
	 * 	Boolean wasCached = mgr.cache('Data','somedata',data); // cache data
	 * 	   :
	 * 	   :
	 * 	// assuming the data 'wasCached' == true
	 * 	//
	 * 	data = mgr.cache('Data','somedata');
	 */
	public accc_ApexCacheMgr() {
		this( (Boolean) accc_ApexEnvironment.getRuntimeEnvironment().provider().get(accc_ApexConstants.UseCachingStrategy_r));
	} // end of ctor

	/**
	 * @description ctor
	 *
	 * @param useCachingStrategy true to use the cache strategy; otherwise bypass
	 */
	public accc_ApexCacheMgr(boolean useCachingStrategy) {
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered useCachingStrategy=' + useCachingStrategy);
		this.theCache =  accc_ApexEnvironment.getRuntimeEnvironment().cache();
		this.theCacheStrategy =  accc_ApexEnvironment.getRuntimeEnvironment().cachePolicyStrategy();
		this.theCacheStrategyInvocation =  accc_ApexEnvironment.getRuntimeEnvironment().cacheStrategyInvocation();
		this.useCacheStrategy = useCachingStrategy;
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Exited');
	} // end of ctor
	/*---------------------------------------------------------------------------------------
	 * PUBLIC METHODS
	 *---------------------------------------------------------------------------------------
	 **/

	/**
	 * @description get data based on category and label
	 *
	 * @param String label used to lookup the cache datum
	 * @return Object, if the the item was cached
	 * @example
	 *
	 * 	accc_ApexCacheMgr mgr = new accc_ApexCacheMgr() ; // default ctor, uses caching strategy
	 * 	SomeData data= new SomeData();
	 * 	Boolean wasCached = mgr.cache('Data','somedata',data); // cache data
	 * 	   :
	 * 	   :
	 * 	// assuming the data 'wasCached' == true
	 * 	//
	 * 	data = mgr.cache('Data','somedata');
	 */
	public Object cache(string label) {
		return this.cache(null, label);
	} // end of cache
	/**
	 * @description get data based on category and label
	 *
	 * @param String category used to lookup the cache datum
	 * @param String label used to lookup the cache datum
	 * @return Object, if the the item was cached
	 */
	public Object cache(string category, string label) {
		Object result = null;
		String identifier = accc_ApexUtilities.makeCacheIdentifier(category, label);

		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered, identifier=' + identifier);

		if ( !string.isBlank(identifier)) {
			string partition = this.getCachePartition(category, label);

			result = this.theCache.get(partition, identifier);
		}
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Exited');
		return result;
	} // end of cache

	/**
	 * @description get data based on label
	 *
	 * @param String label used to lookup the cache datum
	 * @param Object data to stash
	 * @return true, if the the item should be cached
	 */
	public boolean cache(string label, Object datum) {
		return this.cache(null, label, datum);
	} // end of cache
	/**
	 * @description get data based on category and label
	 *
	 * @param String category used to lookup the cache datum
	 * @param String label used to lookup the cache
	 * @param Object data to stash
	 * @return true, if the the item should be cached
	 */
	public boolean cache(string category, string label, Object datum) {
		return this.cache(category, label, null, datum);
	} // end of cache
	/**
	 * @description get data based on category and label
	 *
	 * @param String category used to lookup the cache datum
	 * @param String label used to lookup the cache datum
	 * @param String soql clause
	 * @param Object data to stash
	 * @return true, if the the item should be cached
	 */
	public boolean cache(string category, string label, string soqlQuery, Object datum) {
		Boolean  result = false;

		String identifier = accc_ApexUtilities.makeCacheIdentifier(category, label);
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered, identifier=' + identifier);

		if ( !string.isBlank(identifier) && datum != null) {
			try {
				string partition = this.getCachePartition(category, label);

				result = true;
				if ( this.useCacheStrategy) {
					// see if caching is enabled and we have soql
					result = this.theCacheStrategy.cacheValue(category, label, soqlQuery);
				}
				// we cache at this point depending on the incoming criteria
				// note, if there is no caching strategy, 'result' will be true
				if ( result == true) {
					this.theCache.put(partition , identifier, datum);
				}

			} catch (Exception excp) {
				// process exception
				accc_ApexEnvironment.getRuntimeEnvironment().exceptionHandler().process(excp);
			}
		}
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Exited, result=' + result);

		return result;
	} // end of cache
	/**
	* @description  find caching information by label
	*
	* @param String byLabel
	*
	* @return accc_DataCachingDataModel.CacheInformation cache information
	*/
	public accc_DataCachingDataModel.CacheInformation cacheInformation(String byLabel) {
		return this.cacheInformation(null, byLabel);
	}// end of cacheInformation
	/**
	 * @description  find caching information by category and label
	 *
	 * @param String category
	 * @param String byLabel
	 *
	 * @return accc_DataCachingDataModel.CacheInformation cache information
	 */
	public accc_DataCachingDataModel.CacheInformation cacheInformation(String category, String byLabel) {
		accc_DataCachingDataModel.CacheInformation item = null;
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = null;
		string key = accc_ApexUtilities.makeLocalCacheKey(category, byLabel);

		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered key:' + key);
		// check out local cache
		item = (accc_DataCachingDataModel.CacheInformation)l1Cache.get(key);
		// was the item in the local cache ( locality of reference?)
		if (item == null ) {
			// valid label
			if ( !string.isBlank(byLabel) ) {
				// need caching information
				accc_BaseMdtDataModel ctor = (accc_BaseMdtDataModel)  accc_ApexEnvironment.getRuntimeEnvironment().provider().get(accc_ApexConstants.DataCachingConfiguration_r);
				// find by
				result = ctor.findByCategoryAndLabel(category, byLabel);
			}
			// check the results
			if (  result != null && result.size() > 0) {

				item = (accc_DataCachingDataModel.CacheInformation)result[0];
				// store last value in our local cache
				l1Cache.put(key, item);
			}
		}
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Exited');
		return item;
	} // end of cacheInformation

	/**
	 * @description get the cache partition based on the category and label lookup
	 *
	 * @param String cache category
	 * @param String cache label
	 *
	 * @return cache parttion as found in the Data Cache metadata
	 */
	@TestVisible
	private string getCachePartition(String category, String label) {
		String partition = accc_ApexConstants.DefaultCachePartitionName_s;
		accc_DataCachingDataModel.CacheInformation info = this.cacheInformation(category, label);
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered');
		if ( info != null ) {
			partition = info.cachePartition;
		}
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Exited, partition=' + partition);
		return partition;
	} // end of getPartition

} // end of accc_ApexCacheMgr