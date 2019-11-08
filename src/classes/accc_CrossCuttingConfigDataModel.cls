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
 * change ALL dependencies. [Added layer of indirection to adjust for change].
 *
 * To Add a new resource: See Steps below
 *
 * @group Common Layer
 */
public without sharing class accc_CrossCuttingConfigDataModel extends accc_BaseMdtDataModel {

    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Data Members
    //
    /////////////////////////////////////////////////////////////////////////////////////////

    // our field we categorize on ( this will hold the environment [test, debug,prod])
    @TestVisible
    static final String CATEGORY_FIELD = 'DeveloperName';

    // the custom mdt name
    @TestVisible
    static private final string MDT_Name = 'accc_Apex_Code_Configuration__mdt';
    // fields supported on this custom mdt
    // Step 1a. Added field name here, ie. 'LogFormatter__c'
    @TestVisible
    static private final List<String> FieldList = new List<String> {
        'CacheResource__c'
        , 'ConfigurationResource__c'
        , 'CacheStrategyInvocation__c'
        , 'CacheStrategy__c'
        , 'ExceptionHandler__c'
        , 'ExceptionFormatter__c'
        , 'ExceptionPolicyHandler__c'
        , 'FallbackResource__c'
        , 'FactoryResource__c'
        , 'Logger__c'
        , 'LogFormatter__c'
        , 'PreviousTransactionResultResource__c'
        , 'RuntimeEnvironment__c'
        , 'SendEmailChannel__c'

    };
    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Ctors
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    /**
     * @description data cache information - view representation , allows for changes
     * in the implementation (data representation) w/o affecting the consumption [DAO]
     *
     * To Added New Resouce classes (Step 1b: Add data member here (i.e.,'logFormatterClass'))
     *
     */
    public class CrossCuttingConfigInformation extends accc_BaseMdtDataModel.BaseDataModelInformation {

        public string cacheClass;
        public String exceptionHandlerClass;
        public String fallbackResourcesClass;
        public String loggingClass;
        public String logFormatterClass;
        public String cacheStrategyClass;
        public String cacheStrategyInvocationClass;
        public String configurationClass;
        public String exceptionFormatterClass;
        public String exceptionPolicyHandlerClass;
        public String previousTransactionResultResourceClass;
        public String sendEmailChannelClass;
        public String runtimeEnvironmentClass;
        public String factoryClass;

    } // end of CrossCuttingConfigInformation

    /**
     * @description default ctor
     *
     */
    public accc_CrossCuttingConfigDataModel() {
        super(MDT_Name, CATEGORY_FIELD);

    } // end of ctor
    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Protected Methods
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    /**
     * @description populate our external view of the data cache structure
     *
     * @param cacheMDT the data cache Metadata
     * @param the map of data
     * @return our view of the data ( allows us to change internally)
     */
    @TestVisible
    protected override List<accc_BaseMdtDataModel.BaseDataModelInformation> populateFromDataObjectChild(List<SObject> data) {
        List<CrossCuttingConfigInformation> results = new List<CrossCuttingConfigInformation> ();
        List<accc_Apex_Code_Configuration__mdt> cmdts = (List<accc_Apex_Code_Configuration__mdt>) data;


        if (cmdts != null && cmdts.size() > 0) {
            for (accc_Apex_Code_Configuration__mdt cmdt : cmdts) {
                CrossCuttingConfigInformation result = new CrossCuttingConfigInformation();
                this.setValues((accc_BaseMdtDataModel.BaseDataModelInformation)result, cmdt.Label, cmdt.NamespacePrefix, cmdt.DeveloperName);

                /* To Added New Resouce classes (Step 2: Assign data member here (i.e.,'logFormatterClass')
                 *                                       from SF Object 'LogFormatter__c')
                 *
                 *                               Step 3: Ensure you add field to 'accc_Apex_Code_Configuration__mdt'
                 *                               Step 4: Ensure Fallback Resources have the Resource Name (see accc_ApexConstants and accc_ApexKnownCCConcernsFallback)
                 **/

                result.cacheClass = accc_Apexutilities.normalizeString(cmdt.CacheResource__c, true);
                result.cacheStrategyInvocationClass = accc_Apexutilities.normalizeString(cmdt.CacheStrategyInvocation__c, true);
                result.cacheStrategyClass = accc_Apexutilities.normalizeString(cmdt.CacheStrategy__c, true);
                result.configurationClass = accc_Apexutilities.normalizeString(cmdt.ConfigurationResource__c, true);
                result.exceptionFormatterClass = accc_Apexutilities.normalizeString(cmdt.ExceptionFormatter__c, true);
                result.exceptionPolicyHandlerClass = accc_Apexutilities.normalizeString(cmdt.ExceptionPolicyHandler__c, true);
                result.exceptionHandlerClass = accc_Apexutilities.normalizeString(cmdt.ExceptionHandler__c, true);
                result.factoryClass = accc_Apexutilities.normalizeString(cmdt.FactoryResource__c, true);
                result.fallbackResourcesClass = accc_Apexutilities.normalizeString(cmdt.FallbackResource__c, true);
                result.loggingClass = accc_Apexutilities.normalizeString(cmdt.Logger__c, true);
                result.logFormatterClass = accc_Apexutilities.normalizeString(cmdt.LogFormatter__c, true);
                result.previousTransactionResultResourceClass = accc_Apexutilities.normalizeString(cmdt.PreviousTransactionResultResource__c, true);
                result.sendEmailChannelClass = accc_Apexutilities.normalizeString(cmdt.SendEmailChannel__c, true);
                result.runtimeEnvironmentClass = accc_Apexutilities.normalizeString(cmdt.RuntimeEnvironment__c, true);

                results.add(result);
            }
        } // endif

        return results;
    } // end of populateFromDataObjectChild
    /**
     * @description allow the child to return their custom fields to select
     * @return collection of field name
     */
    @TestVisible
    protected override List<String> getSelectFields() {
        return accc_CrossCuttingConfigDataModel.FieldList;
    } // end of getSelectFields
    /**
     * @description used to get MDT data and remap to our external view for testing
     *
     * @return CacheInformation our view
     */
    @TestVisible
    protected override accc_BaseMdtDataModel.BaseDataModelInformation getTestInformationByLookup() {
        List<accc_BaseMdtDataModel.BaseDataModelInformation> results = super.getInformationByLookup(accc_ApexConstants.TEST_CATEGORY, accc_ControlPolicySearchEnum.byLabel);

        return results != null && results.size() > 0 ? results[0] : null;
    } // end of getTestInformationByLookup


} // end of accc_CrossCuttingConfigDataModel