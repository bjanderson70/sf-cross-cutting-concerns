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
 * @description How to invoke the caching strategy
 * @group Common Interface Layer
 */
public virtual  interface accc_IApexCacheStrategyInvocation {

	/**
	 * Setter Method to set the SoqlQuery.
	 */
	void setTheSoqlQuery(string soql);
	/**
	 * Getter Method to get the SoqlQuery.
	 */
	string getTheSoqlQuery();
    /**
	*
     * @description  Used to call the cache strategy as defined by the user in the metadata
     * 
     *   User cache strategy, if used, MUST inherit from this interface. The DataCache__mdt will then
     *   contain the name of the concrete class and will be used to determine cache strategy.
     *   
     *   An example of this can be seen in the 'TestInvokerApexCacheStrategyForTesting' (used for testing)
     *   
     * @param string name or label
     * @param CacheInformation to provide information on invocation
     * @return true, if can be cached
     */
    boolean invokeCacheStrategy(String soqlQuery,accc_DataCachingDataModel.CacheInformation invocationInformation);
 
} // end of IApexCachePolicyStrategy