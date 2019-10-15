/**
 * Copyright (c) 2016-2019, Bill anderson.  All rights reserved.
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
 *   * Neither the name of Bill anderson nor the names of its
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
 * @author Bill anderson
 * Encapsulates all behaviour logic relating to the reading the trigger handler
 * custom metadata
 *
 * For more guidelines and details see
 *   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Domain_Layer
 * @group Common Trigger Layer
 **/
public virtual without sharing class accc_TriggerHandlerMetaDataModel extends accc_BaseMdtDataModel {

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Data Members
	//
	/////////////////////////////////////////////////////////////////////////////////////////

	public static final String CLASS_SEPARATOR_s = '[,: ]+';
	public static final String EXCEPTION_STRING_IN_LOOKUP = '+++ EXCEPTION +++ accc_TriggerHandlerMetaDataModel.getInformationByLookup: ';
	// acts as the environment
	@TestVisible
	static final String CUSTOM_MDT_ENVIRONMENT = 'Environment__c';
	// custom mdt domain
	@TestVisible
	static final String CUSTOM_MDT_DOMAIN =  'Domain__c';

	/**
	 * @description data cache information - viewmodel representation , allows for changes
	 * in the implementation (data representation) w/o affecting the consumption
	 *
	 * DO NOT FORGET TO UPDATE the 'm_FieldList' which brings the fields in the event you
	 * ADD MORE FIELDS below!!
	 */
	public virtual class THDataModelInformation extends accc_BaseMdtDataModel.BaseDataModelInformation  {
		// specific to trigger handling
		public String environment;
		public String domain;
		public Set<String> classes;
		public Boolean isActive;
		public Boolean  continueIfException;
		public Boolean  performanceMetrics;

	} // end of  THDataModelInformation


	// the custom mdt name
	@TestVisible
	static private final string MDT_NAME = 'accc_Trigger_Handler_MetaData_Model__mdt';
	// fields supported on this custom mdt. DO NOT FORGET TO UPDATE
	// IF YOU ADD MORE FIELDS above in 'THDataModelInformation'
	@TestVisible
	static private final List<String> m_FieldList = new List<String> {
		'Environment__c'
		, 'Domain__c'
		, 'Trigger_Classes__c'
		, 'Active__c'
		, 'Continue_If_Exception__c'
		, 'Performance_Metrics__c'

	};
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Properties
	//
	/////////////////////////////////////////////////////////////////////////////////////////

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// CTORS
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description ctor
	 *
	 */
	public accc_TriggerHandlerMetaDataModel() {
		super(MDT_NAME, accc_BaseMdtDataModel.CUSTOM_MDT_NAME) ;
	} // end of ctor

	/**
	 * @description find by environment and domain
	 *
	 * @param string the environment / namespace
	 * @param string the domain name
	 * @return the model informaiton
	 */
	public List<accc_BaseMdtDataModel.BaseDataModelInformation> findbyEnvironmentAndDomain(String environment, String domainName) {
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = null;
		// must have a valid name
		if ( !string.isBlank(domainName) ) {
			if ( string.isBlank(environment)) {
				result = this.getInformationByLookup(domainName, accc_BaseMdtDataModel.accc_ControlPolicySearchEnum.byDomain);
			} else {
				String last = this.categoryField;
				this.categoryField = CUSTOM_MDT_ENVIRONMENT;
				result = this.getInformationByLookup(environment, domainName, accc_BaseMdtDataModel.accc_ControlPolicySearchEnum.byDomain);
				this.categoryField = last;
			}
		} else if ( !string.isBlank(environment) ) {
			result = this.findByEnvironment(environment);
		}
		return result;

	} // end of findbyEnvironmentAndDomain
	/**
		* @description find by environment
		*
		* @param string the environment / namespace
		* @return the model informaiton
		*/
	public List<accc_BaseMdtDataModel.BaseDataModelInformation> findByEnvironment(String environment) {
		String last = this.categoryField;
		this.categoryField = CUSTOM_MDT_ENVIRONMENT;
		List<accc_BaseMdtDataModel.BaseDataModelInformation>  result = this.getInformationByLookup(environment, null, accc_ControlPolicySearchEnum.byLabel);
		this.categoryField = last;

		return result;
	}// end of findByEnvironment
	/**
	 * @description find by environment and label
	 *
	 * @param string the environment / namespace
	 * @param string the label name
	 * @return the model informaiton
	 */
	public List<accc_BaseMdtDataModel.BaseDataModelInformation> findbyEnvironmentAndLabel(String environment, String labelName) {
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = null;
		// must have a valid name
		if ( !string.isBlank(labelName) ) {
			if ( string.isBlank(environment)) {
				result = this.getInformationByLookup(labelName, accc_ControlPolicySearchEnum.byLabel);
			} else {
				String last = this.categoryField;
				this.categoryField = CUSTOM_MDT_ENVIRONMENT;
				result = this.getInformationByLookup(environment, labelName, accc_ControlPolicySearchEnum.byLabel);
				this.categoryField = last;
			}
		} else if ( !string.isBlank(environment) ) {
			result = this.findByEnvironment(environment);
		}
		return result;

	} // end of findbyEnvironmentAndLabel

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Protected Methods
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description populates ALL data from the custom mdt
	 *
	 * @param mdt custom MDT
	 * @return data representation of the custom metadata type
	 */
	@TestVisible
	protected override List<accc_BaseMdtDataModel.BaseDataModelInformation> populateFromDataObjectChild(List<SObject> mdt) {
		List<THDataModelInformation> results = new List<THDataModelInformation> ();
		List<accc_Trigger_Handler_MetaData_Model__mdt> cmdts = (List<accc_Trigger_Handler_MetaData_Model__mdt>) mdt;

		if (cmdts != null && cmdts.size() > 0) {
			String classes;
			for (accc_Trigger_Handler_MetaData_Model__mdt cmdt : cmdts) {
				THDataModelInformation result = new THDataModelInformation();
				// set common mdt values
				this.setValues((accc_BaseMdtDataModel.BaseDataModelInformation)result, cmdt.Label, cmdt.NamespacePrefix, cmdt.DeveloperName);

				/* Set Data from the custom metadata type */
				result.environment = accc_ApexUtilities.normalizeString(cmdt.Environment__c, true).toLowerCase();
				classes = accc_ApexUtilities.normalizeString(cmdt.Trigger_Classes__c, true);
				result.domain = accc_ApexUtilities.normalizeString(cmdt.Domain__c, true);
				result.isActive = cmdt.Active__c == null ? false : cmdt.Active__c;
				result.continueIfException = cmdt.Continue_If_Exception__c == null ? false : cmdt.Continue_If_Exception__c ;
				result.performanceMetrics = cmdt.Performance_Metrics__c == null ? false : cmdt.Performance_Metrics__c ;

				// the classes will be present or not, if not create an empty set
				if ( string.isblank(classes)) {
					result.classes = new Set<String>();
				} else {
					// lets ensure we remove DUPLICATES by instantiating the set from
					// a delimeted list of classes ( comma, space or colon separated)
					result.classes = new Set<String>(classes.split(CLASS_SEPARATOR_s));
				}
				// update the list with new values
				results.add(result);
			}
		} // endif

		return results;
	} // end of populateFromDataObjectChild
	/**
	 * @description return their custom fields to select
	 * @return collection of field name
	 */
	@TestVisible
	protected override List<String> getSelectFields() {
		return accc_TriggerHandlerMetaDataModel.m_FieldList;
	} // end of getSelectFields

	/**
	* @description used to get MDT data and remap to our external view for testing
	*
	* @return  accc_BaseMdtDataModel.BaseDataModelInformation
	*/
	@TestVisible
	protected override accc_BaseMdtDataModel.BaseDataModelInformation getTestInformationByLookup() {
		List<accc_BaseMdtDataModel.BaseDataModelInformation> results = this.findByEnvironment(accc_ApexConstants.TEST_CATEGORY);

		return results != null && results.size() > 0 ? results[0] : null;
	} // end of getTestInformationByLookup
	/**
	 * @description get our query by string
	 * @details get our query by string
	 *
	 * @param controlType control of the query by
	 * @return the query by string
	 */
	@TestVisible
	protected override string getQueryBy(accc_ControlPolicySearchEnum controlType) {
		Boolean theControlType = controlType == accc_BaseMdtDataModel.accc_ControlPolicySearchEnum.byName;
		Boolean theControlDomain = controlType == accc_BaseMdtDataModel.accc_ControlPolicySearchEnum.byDomain;

		return theControlType ? accc_BaseMdtDataModel.CUSTOM_MDT_NAME : theControlDomain ? accc_TriggerHandlerMetaDataModel.CUSTOM_MDT_DOMAIN : accc_BaseMdtDataModel.CUSTOM_MDT_LABEL;

	} // end of getQueryBy

} // end of accc_TriggerHandlerMetaDataModel