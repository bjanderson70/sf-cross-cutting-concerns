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
 * @description  External representation of the data cached metadata. Providing a
 * wrapper around the internal data mapper allows one to vary the metadata w/o having to
 * change ALL dependencies. [DAO]
 * @group Common Layer
 */
public without sharing class accc_DataCachingDataModel extends accc_BaseMdtDataModel {

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Data Members
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	@TestVisible
	static private final String CATEGORY_FIELD = 'Category__c';
	@TestVisible
	static private final string TestLabel2018 = 'testLabel';
	@TestVisible
	static private final string TestName2018 = 'testName';
	@TestVisible
	static private final string TestCategory = 'test';
	@TestVisible
	static private final String TestClassName = 'accc_TestInvokerApexCacheStrategy';
	@TestVisible
	static private final string MDT_Name = 'AcccDataCachingDataModel__mdt';
	@TestVisible
	static private final List<String> FieldList = new List<String> {
		'Category__c',
		'CachingEnabled__c',
		'ContainFields__c',
		'TimeToLiveMS__c',
		'CachePartition__c'
	};

	/**
	 * @description data cache information - view representation , allows for changes
	 * in the implementation (data representation) w/o affecting the consumption
	 */

	public class CacheInformation extends accc_BaseMdtDataModel.BaseDataModelInformation {

		public Boolean isCachingEnabled;
		public String containFields;
		public integer timeToLiveMS;
		public string category;
		public string cachePartition;

	} // end of CacheInformation
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Ctors
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description ctor
	 *
	 */
	public accc_DataCachingDataModel() {
		super(MDT_Name,CATEGORY_FIELD);

	} // end of ctor
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Protected Methods
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description populate our external view of the data cache structure
	 *
	 * @param List<SObject> list of the data cache objects
	 * @return our view of the data ( allows us to change internally)
	 */
	protected override List<accc_BaseMdtDataModel.BaseDataModelInformation> populateFromDataObjectChild(List<SObject> data) {
		List<accc_BaseMdtDataModel.BaseDataModelInformation> results = null;
		List<AcccDataCachingDataModel__mdt> cmdts = (List<AcccDataCachingDataModel__mdt>) data;

		if (cmdts != null && cmdts.size() > 0) {
			results = new List<accc_BaseMdtDataModel.BaseDataModelInformation> ();

			for (AcccDataCachingDataModel__mdt cmdt : cmdts) {
				CacheInformation result = new CacheInformation();
				this.setValues((accc_BaseMdtDataModel.BaseDataModelInformation)result, cmdt.Label, cmdt.NamespacePrefix, cmdt.DeveloperName);


				result.category = accc_Apexutilities.normalizeString(cmdt.Category__c, true);
				result.isCachingEnabled = cmdt.CachingEnabled__c;
				result.containFields = accc_Apexutilities.normalizeString(cmdt.ContainFields__c, true);
				result.timeToLiveMS = (integer) cmdt.TimeToLiveMS__c;
				result.cachePartition = accc_Apexutilities.normalizeString(cmdt.CachePartition__c, true);

				results.add(result);
			}
		}
		return results;
	} // end of populateFromDataObjectChild
	/**
	 * @description allow the child to return their custom fields to select
	 * @return collection of field name
	 */
	protected override List<String> getSelectFields() {
		return accc_DataCachingDataModel.FieldList;
	} // end of getSelectFields
	/**
	 * @description used to get MDT data and remap to our external view for testing
	 *
	 * @return CacheInformation our view
	 */
	@TestVisible
	protected override accc_BaseMdtDataModel.BaseDataModelInformation getTestInformationByLookup() {
		List<accc_BaseMdtDataModel.BaseDataModelInformation> results = super.getInformationByLookup(TestLabel2018,
		        accc_BaseMdtDataModel.accc_ControlPolicySearchEnum.byLabel);
		return results != null && results.size() > 0 ? results[0] : null;
	} // end of getTestInformationByLookup


} // end of accc_DataCachingDataModel