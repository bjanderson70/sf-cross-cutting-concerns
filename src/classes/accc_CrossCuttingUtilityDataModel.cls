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
 * @description  External representation of the data cached metadata. Providing a
 * wrapper around the internal data mapper allows one to vary the metadata w/o having to
 * change ALL dependencies. [Added layer of indirection to adjust for change]
 * @group Common Layer
 */
public without sharing class accc_CrossCuttingUtilityDataModel extends accc_BaseMdtDataModel {

    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Data Members
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    @TestVisible
    static private final string TestLabel2018 = 'test';
    @TestVisible
    static private final string TestName2018 = 'test';
    // name of the custom mdt
    @TestVisible
    static private final string MDT_Name = 'CrossCuttingUtilityData__mdt';

    @TestVisible
    static private final List<String> FieldList = new List<String> {
        'environmentClass__c'
        , 'maxNumberOfItemsInChunks__c'
        , 'softAssert__c'
        , 'triggersEnable__c'
        , 'UseCachingStrategy__c'
        , 'LogLevelForCCC__c'
        , 'ShowCCDebugInfo__c'
    };
    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Ctors
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    /**
     * @description data cache information - view representation , allows for changes
     * in the implementation (data representation) w/o affecting the consumption
     *
     */

    public class CrossCuttingUtilityInformation extends accc_BaseMdtDataModel.BaseDataModelInformation {

        public boolean assertTypeIsSoft;
        public String environmentClass;
        public integer maxNumberOfItemsInChunks;
        public boolean triggersAreEnable;
        public boolean useCachingStrategy;
        public String loglevel;
        public boolean showCrossCuttingConcernsInfo;

    }// end of CrossCuttingUtilityInformation

    /**
     * @description ctor
     *
     */
    public accc_CrossCuttingUtilityDataModel() {
        super(MDT_Name);

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
        List<CrossCuttingUtilityInformation> results = new List<CrossCuttingUtilityInformation> ();
        List<CrossCuttingUtilityData__mdt> cmdts = (List<CrossCuttingUtilityData__mdt>) data;

        if (cmdts != null && cmdts.size() > 0) {
            for (CrossCuttingUtilityData__mdt cmdt : cmdts) {
                CrossCuttingUtilityInformation result = new CrossCuttingUtilityInformation();
                this.setValues((accc_BaseMdtDataModel.BaseDataModelInformation)result, cmdt.Label, cmdt.NamespacePrefix, cmdt.DeveloperName);


                result.assertTypeIsSoft = cmdt.softAssert__c;
                result.environmentClass = accc_Apexutilities.normalizeString(cmdt.environmentClass__c, true);
                result.maxNumberOfItemsInChunks = (Integer)cmdt.maxNumberOfItemsInChunks__c;
                result.triggersAreEnable = cmdt.triggersEnable__c;
                result.useCachingStrategy = cmdt.UseCachingStrategy__c;
                result.showCrossCuttingConcernsInfo = cmdt.ShowCCDebugInfo__c;
                result.loglevel = cmdt.LogLevelForCCC__c;

                results.add(result);
            }
        }

        return results;
    } // end of populateFromDataObjectChild
    /**
     * @description allow the child to return their custom fields to select
     * @return collection of field names
     */
    @TestVisible
    protected override List<String> getSelectFields() {
        return accc_CrossCuttingUtilityDataModel.FieldList;
    } // end of getSelectFields
    /**
     * @description used to get MDT data and remap to our external view for testing
     *
     * @return CacheInformation our view
     */
    @TestVisible
    protected override accc_BaseMdtDataModel.BaseDataModelInformation getTestInformationByLookup() {

        List<accc_BaseMdtDataModel.BaseDataModelInformation> results = super.getInformationByLookup(accc_ApexConstants.TEST_CATEGORY,
                accc_BaseMdtDataModel.accc_ControlPolicySearchEnum.byLabel);

        return results != null && results.size() > 0 ? results[0] : null;
    } // end of getTestInformationByLookup


} // end of accc_CrossCuttingConfigDataModel