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
 *   * Neither the name of Bill Anderson nor Bill Anderson nor the names of its
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
 * @description How to handle caching. Based on the policy (DataCaching__mdt) and soql query
 * @group Cache Aspects
 */
public virtual without sharing class accc_ApexCachePolicyStrategy implements accc_IApexCachePolicyStrategy {
	/*---------------------------------------------------------------------------------------
	 * CTORS
	 *---------------------------------------------------------------------------------------
	 **/

	/*---------------------------------------------------------------------------------------
	 * PUBLIC METHODS
	 *---------------------------------------------------------------------------------------
	 **/

	/**
	 *
	 * @description  Base on the query and using DataCache_mdt, determine if item was cached
	 *
	 * @param string name or label
	 *
	 * @return Boolean returns true, if to cache
	 */
	public boolean cacheValue(String nameOrLabel, string soqlQuery) {
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered nameOrLabel=' + nameOrLabel + ', soqlQuery=' + soqlQuery );

		if ( string.isBlank(nameOrLabel) ||
		        string.isBlank(soqlQuery) ) {
			return false;
		}

		accc_DataCachingDataModel.CacheInformation cacheInfo = this.findCacheStrategy(nameOrLabel);

		return this.regexSoqlQueryCheck(soqlQuery, cacheInfo);
	} // end of cacheValue
	/**
	 *
	 * @description  Base on the query and using DataCache_mdt, determine if item was cached
	 *
	 * @param string category/namespace
	 * @param string label
	 * @param string soqlQuery
	 * @return true, if can be cached
	 */
	public boolean cacheValue(String category, String label, string soqlQuery) {
		Boolean result = false;
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered category=' + category +  ', label=' + label + ', soqlQuery=' + soqlQuery );

		if ( string.isBlank(category) ||
		        string.isBlank(label) ) {
			return result;
		}
		accc_DataCachingDataModel.CacheInformation cacheInfo = this.findCacheStrategy(category, label);
		// if there is no soql but 'cacheInfo',
		// then we just look if the caching is enabled
		if ( cacheInfo != null ) {
			// caching is enabled; even if the soql is not present, we want to cache
			result = cacheInfo.isCachingEnabled;
			// now if we do have a soql query, see if there is a finer granularity to check
			if ( result == true && !string.isBlank(soqlQuery)  ) {
				// we have a soql query and caching is enabled for this category/label
				result = this.regexSoqlQueryCheck(soqlQuery, cacheInfo);
			}
		}
		return result;

	} // end of cacheValue

	/*---------------------------------------------------------------------------------------
	 * PRIVATE METHODS
	 *---------------------------------------------------------------------------------------
	 **/
	/**
	*
	* @description find the cache strategy based on the name or the label
	*
	* @param nameOrLabel string holding the name or label
	* @return accc_DataCachingDataModel.CacheInformation
	*/
	@TestVisible
	private accc_DataCachingDataModel.CacheInformation findCacheStrategy( string nameOrLabel) {
		return this.findCacheStrategy(null, nameOrLabel);
	} // end of findCacheStrategy

	/**
	 *
	 * @description find the cache strategy based on the name or the label
	 *
	 * @param category string holding the category
	 * @param nameOrLabel string holding the name or label
	 * @return accc_DataCachingDataModel.CacheInformation
	 */
	@TestVisible
	private accc_DataCachingDataModel.CacheInformation findCacheStrategy(string category, string nameOrLabel) {
		accc_DataCachingDataModel.CacheInformation result = null;
		List<accc_BaseMdtDataModel.BaseDataModelInformation> results = null;
		accc_BaseMdtDataModel dci = (accc_BaseMdtDataModel)  accc_ApexEnvironment.getRuntimeEnvironment().provider().get(accc_ApexConstants.DataCachingConfiguration_r);

		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered category=' + category +  ', nameOrLabel=' + nameOrLabel + ', dci=' + dci );
		// resource not found -- configuration was wrong
		if ( dci == null ) {
			Exception excp = new accc_ApexApplicationException('accc_ApexCachePolicyStrategy.findCacheStrategy - Could not find the provider ' + accc_ApexConstants.DataCachingConfiguration_r + ', Remedy: Check accc_CustomSettings or accc_VirtualCustomSettings');
			// process exception
			accc_ApexEnvironment.getRuntimeEnvironment().exceptionHandler().process(excp, true);
			throw excp;
		}
		// do we have cactegory
		if ( string.isBlank(category) ) {
			// look up by name
			results = dci.findByName(nameOrLabel);
			// if not by name, then by label
			if ( results == null || results.size() == 0) {
				// look up by label
				results = dci.findByLabel(nameOrLabel);
			}
		} else {
			// call base, if the values are not right, will return null
			results = dci.findByCategoryAndLabel(category, nameOrLabel);
		}
		// we only grab the first one
		result = results != null && results.size() > 0 ? (accc_DataCachingDataModel.CacheInformation)results[0] : (accc_DataCachingDataModel.CacheInformation)null;

		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Exited result=' + result);

		return result;
	} // end of findCacheStrategy
	/**
	 * @description find by regex expression
	 * @param string soql query
	 * @param CacheInformation data from the custom mdt
	 * @return boolean true if the value from the sqol should be cached
	 **/
	@TestVisible
	private boolean regexSoqlQueryCheck(string soqlQuery, accc_DataCachingDataModel.CacheInformation  cinfo) {
		Boolean result = false;

		if ( cinfo != null &&
		        !string.isBlank(cinfo.containFields) &&
		        !string.isBlank(soqlQuery)) {

			// check via regex
			result = this.checkRegex(cinfo.containFields, soqlQuery);
			// if still not found check parameters/fields
			if ( result == false  ) {
				result = this.checkSplitAndContain(cinfo.containFields, soqlQuery);
			}
		}
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered/Exited result=' + result );

		return result;
	} // end of regexSoqlQueryCheck
	/**
	 * @description does the regex match
	 * @param string regular expression
	 * @param string soql query to inspect
	 * @return boolean soql query results should be cached
	 **/
	@TestVisible
	private boolean checkRegex(String regex, string soqlQuery) {
		Pattern MyPattern = Pattern.compile(regex);
		Matcher MyMatcher = MyPattern.matcher(soqlQuery);
		Boolean result = MyMatcher.find();
		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered/Exited result=' + result );
		return result;

	} // end of checkRegex
	/**
	 * @description based on fields see if ALL fields match
	 * @param string comma separated fields to check
	 * @param string raw soql statement
	 * @return boolean return true if value should be cached
	 **/
	@TestVisible
	private boolean checkSplitAndContain(string containsRaw, string soqlQueryRaw) {
		// remove multi-spaces
		String soqlQuery = soqlQueryRaw.normalizeSpace();
		String contains = containsRaw.normalizeSpace();
		Boolean result = false;
		Set<String> splitted = new Set<String>(soqlQuery.toLowerCase().split('\\b+'));
		Set<String> uniqContains = new Set<String>(contains.toLowerCase().split('\\b+'));
		
		// remove empty/blank item
		splitted.remove( ' ');
		uniqContains.remove(' ');

		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered soqlQuery=' + soqlQuery + ', contains=' + contains );
		// look for all values
		result = splitted.containsAll(uniqContains); //search array for word

		accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Exited result=' + result );

		return result;
	} // end of checkSplitAndContain

} // end of accc_ApexCachePolicyStrategy