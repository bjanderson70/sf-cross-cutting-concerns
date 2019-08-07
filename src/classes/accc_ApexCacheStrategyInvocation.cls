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
 * @description Defines how to invoke the cache strategy
 * @group Cache Aspects
 */
public virtual without sharing class accc_ApexCacheStrategyInvocation implements accc_IApexCacheStrategyInvocation {

	/*---------------------------------------------------------------------------------------
	 * DATA MEMBERS
	 *---------------------------------------------------------------------------------------
	 **/

	/**
	 * The expected interface for cache invocation
	 */
	@TestVisible
	static final string CACHE_STRATEGY_INVOCATION_INTERFACE = 'accc_IApexCacheStrategyInvocation';
	/*---------------------------------------------------------------------------------------
	 * PROPERTIES
	 *---------------------------------------------------------------------------------------
	 **/

	/**
	 * @description the soql query
	 * @return soql query
	 */
	public string theSoqlQuery { protected get; protected set; }

	/*---------------------------------------------------------------------------------------
	* CTORS
	*---------------------------------------------------------------------------------------
	**/


	/**
	 * @description ctor
	 *
	 */
	public accc_ApexCacheStrategyInvocation() {
		this(null);

	} // end of ctor

	/**
	 * @description ctor
	 *
	 */
	public accc_ApexCacheStrategyInvocation(String soqlQuery) {
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered soqlQuery=' + soqlQuery );

		this.theSoqlQuery = soqlQuery;

	} // end of ctor

	/*---------------------------------------------------------------------------------------
	* PUBLIC METHODS
	*---------------------------------------------------------------------------------------
	**/

	/**
	 * @description  Used to call the cache strategy as defined by the user in the metadata
	 *
	 * @param string name or label
	 * @param CacheInformation to provide information on invocation
	 * @return true, if can be cached
	 */
	public boolean invokeCacheStrategy(String soqlQuery, accc_DataCachingDataModel.CacheInformation invocationInformation) {

		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered soqlQuery=' + soqlQuery );
		this.setTheSoqlQuery( soqlQuery);
		return this.invokeCacheStrategy(invocationInformation);

	} // end of invokeCacheStrategy

	/**
	 * Getter Method to get the SoqlQuery. Exposed to consumer via the interface
	 */
	public string getTheSoqlQuery() {
		return this.theSoqlQuery;
	} // end of getTheSoqlQuery
	/**
	 * Setter Method to set the SoqlQuery.
	 */
	public void setTheSoqlQuery(string soql) {
		this.theSoqlQuery = soql;
	} // end of setTheSoqlQuery
	/**
	 * @description  Used to call the cache strategy as defined by the user in the metadata
	 *
	 * @param string name or label
	 * @param CacheInformation to provide information on invocation
	 * @return true, if can be cached
	 */
	public boolean invokeCacheStrategy(accc_DataCachingDataModel.CacheInformation invocationInformation) {
		Boolean result = false;
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered invocationInformation=' + invocationInformation );
		if (string.isBlank(this.theSoqlQuery) ||
		        invocationInformation == null ||
		        !invocationInformation.isCachingEnabled) {
			return result;
		}
		try {
			result = this.invokeCustomImpl(this.getTheSoqlQuery(),
			                               invocationInformation);
		} catch (Exception excp) {
			// process exception
			accc_ApexEnvironment.getRuntimeEnvironment().exceptionHandler().process(excp);

		}
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Exited result=' + result );

		return result;
	} // end of invokeCacheStrategy

	/*---------------------------------------------------------------------------------------
	* PROTECTED METHODS
	*---------------------------------------------------------------------------------------
	**/

	/**
	 * @description invoke the custom class to determine cache strategy
	 * @param string sqol query to check
	 * @param string class name which will be created
	 * @return boolean result of the invocation of the user-define cache strategy
	 **/
	@TestVisible
	protected virtual boolean invokeCustomImpl(String soqlQuery, accc_DataCachingDataModel.CacheInformation invocationInformation) {
		boolean status = false;

		// get from the factory
		accc_IApexCacheStrategyInvocation invoke =  accc_ApexEnvironment.getRuntimeEnvironment().cacheStrategyInvocation();
		
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered invocationInformation=' + invocationInformation );

		if ( invoke != null ) {
			// as this is the base class for others, we DO NOT call ourselves , in the event
			// someone reference this class as the cache strategy
			boolean isSameClass = accc_ApexUtilities.getClassName(invoke).equals('accc_ApexCacheStrategyInvocation');
			// avoid calling ourself (as someone may have inherited but DID NOT override 'invokeCustomImpl')
			if ( isSameClass == false)  {
				// set the sqol query of the type/class
				invoke.setTheSoqlQuery(soqlQuery);
				// Call the method -- user's custom implementation
				status = invoke.invokeCacheStrategy(soqlQuery, invocationInformation);
			}
		}
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Exited status=' + status );

		return status;
	} // end of invokeCustomImpl

} // end of accc_ApexCacheStrategyInvocation