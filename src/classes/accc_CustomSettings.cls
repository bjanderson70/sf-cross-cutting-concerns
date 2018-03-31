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
 * @description Custom settings information aka Configuration. This class forms the
 * cornerstone of Known Custom Settings for Cross Ctting Concerns. Should there be
 * a need to augment then subclass from 'accc_VirtualCustomSettings'. This class provides
 * a means for others to deviate from this design w/o impacting changes.
 *
 * @group Common Layer
 *
 */
public without sharing class accc_CustomSettings implements accc_IConfigurationProvider {
    /////////////////////////////////////////////////////////////////////////////////////////////
    //++++++++++++++++++++++++++++++++++ Data Members +++++++++++++++++++++++++++++++++++++++++++
    /////////////////////////////////////////////////////////////////////////////////////////////

    // keep the known settings
    static Map<String, Object> knownSettings = new Map<String, Object>();
    // data caching model
    static accc_DataCachingDataModel dataCachingModel = null;
    // cross-cutting configuration model
    static accc_CrossCuttingConfigDataModel ccConfigModel = null;
    // cross-cutting utility information
    static accc_CrossCuttingUtilityDataModel ccUtilityDataModel = null;

    /////////////////////////////////////////////////////////////////////////////////////////////
    //++++++++++++++++++++++++++++++++++ Data Initialization ++++++++++++++++++++++++++++++++++++
    /////////////////////////////////////////////////////////////////////////////////////////////
    //static {
    //	// seed the data
    //	accc_CustomSettings.getKnownResourceSettings();
    //}
    /////////////////////////////////////////////////////////////////////////////////////////////
    //++++++++++++++++++++++++++++++++++ Public methods +++++++++++++++++++++++++++++++++++++++++
    /////////////////////////////////////////////////////////////////////////////////////////////
    /**
    *
    * @description load the configuration
    * @return true, if the configuration was loaded
    */
    public Boolean load() {
        return true;
    } // end of load
    /**
    *
     * @description get a value based on the name from the <name,value> pair
     *
     * @param name key name
     * @return object ( must be cast appropriately)
     */
    public Object get(String name) {
        return accc_CustomSettings.getEntity(name);
    } // end of get
    /////////////////////////////////////////////////////////////////////////////////////////////
    //++++++++++++++++++++++++++++++++++ Public Static methods ++++++++++++++++++++++++++++++++++
    /////////////////////////////////////////////////////////////////////////////////////////////
    /**
    * @description get an entity based on our hierarchy
    *
    * @param value String
    * @return Object result
    */
    public static Object getEntity(String value) {
        Object result = null;

        if ( string.isBlank(value)) {
            return result;
        }
        // get resources
        Map<String, Object> resources = accc_CustomSettings.getKnownResourceSettings();

        return resources.get(value);

    } // end of getEntity

    /**
      * @description Data being cached for this labelled item
      *
      * @param String label
      * @return accc_DataCachingDataModel.CacheInformation
      */
    public static boolean caching (String label) {
        Boolean result = false;
        accc_ApexCacheMgr mgr = new accc_ApexCacheMgr();
        accc_DataCachingDataModel.CacheInformation datum = mgr.cacheInformation(label);
        if ( datum != null ) {
            result = datum.isCachingEnabled;
        }
        return result;
    } // end of caching
    /**
    * @description determine if we are using caching strategy
    * @return true, if using caching strategy
    */
    public static boolean useCachingStrategy() {
        boolean result = true;

        accc_CrossCuttingUtilityDataModel.CrossCuttingUtilityInformation info = accc_CustomSettings.crossCuttingInformation();
        if ( info != null ) {
            result = (boolean)info.useCachingStrategy;
        }

        return result;
    } // end of useCachingStrategy

    /**
    * @description  using soft asserts for testing
    * @return true, if using soft asserts for testing
    */
    public static boolean usingSoftAssert() {
        boolean result = false;

        accc_CrossCuttingUtilityDataModel.CrossCuttingUtilityInformation info = accc_CustomSettings.crossCuttingInformation();
        if ( info != null ) {
            result = (boolean)info.assertTypeIsSoft;
        }

        return result;
    } // end of usingSoftAssert
    /**
    * @description get the environment class
    * @return class name of the environment
    */
    public static String environmentClass() {
        string result = '';

        accc_CrossCuttingUtilityDataModel.CrossCuttingUtilityInformation info = accc_CustomSettings.crossCuttingInformation();
        if ( info != null ) {
            result = info.environmentClass;
        }

        return result;
    } // end of environmentClass
    /**
     *
     * @description default max. number of items in a chunk/packet sent to the external systems (via apex batch)
     * @return default size
     */
    public static integer defaultMaxNumberOfItemsInChunks() {
        integer maxNumberOfItems = accc_ApexConstants.DEFAULT_MAX_NUMBER_OF_ITEMS_IN_CHUNK;

        accc_CrossCuttingUtilityDataModel.CrossCuttingUtilityInformation info = accc_CustomSettings.crossCuttingInformation();
        if ( info != null ) {
            maxNumberOfItems = (Integer)info.maxNumberOfItemsInChunks;
        }

        return maxNumberOfItems;
    } // end of defaultMaxNumberOfItemsInChunks
    /**
    *
     * @description triggers enable
     * @return boolean, true if triggers are enable
     */
    public static boolean triggersEnable() {
        boolean result = true;

        accc_CrossCuttingUtilityDataModel.CrossCuttingUtilityInformation info = accc_CustomSettings.crossCuttingInformation();
        if ( info != null ) {
            result = (boolean)info.triggersAreEnable;
        }

        return result;
    } // end of triggersEnable

    /**
     * @description cross cutting information
     * @return CrossCuttingUtilityInformation
     */
    public static accc_CrossCuttingUtilityDataModel.CrossCuttingUtilityInformation crossCuttingInformation() {
        accc_CrossCuttingUtilityDataModel.CrossCuttingUtilityInformation info = null;
        try {
            string env = accc_ApexUtilities.getEnvironment();
            accc_CrossCuttingUtilityDataModel ccudm = accc_CustomSettings.crossCuttingUtilityModel();
            List<accc_CrossCuttingUtilityDataModel.CrossCuttingUtilityInformation> cclist = (List<accc_CrossCuttingUtilityDataModel.CrossCuttingUtilityInformation>) ccudm.findByLabel(env);
            info = cclist != null && cclist.size() > 0 ? cclist[0] : null;
        } catch (Exception excp) {
            // process exception
            accc_ApexRunEnvironmentSingleton.getInstance().exceptionHandler().process(excp);
        }
        return info;
    } // end of crossCuttingInformation
    /**
     * @description get the data caching model
     * @return accc_DataCachingDataModel, data caching model
     */
    public static accc_DataCachingDataModel cachingModel() {
        // local copy available
        if ( accc_CustomSettings.dataCachingModel == null) {
            accc_CustomSettings.dataCachingModel = new accc_DataCachingDataModel();
        }
        return accc_CustomSettings.dataCachingModel;
    } // end of cachingModel


    /**
     * @description get the cross-cutting configuration class
     * @return accc_CrossCuttingConfigDataModel, cross-cutting configuration class
     */
    public static accc_CrossCuttingConfigDataModel crossCuttingConfigModel() {
        // local copy available
        if ( accc_CustomSettings.ccConfigModel == null) {
            accc_CustomSettings.ccConfigModel = new accc_CrossCuttingConfigDataModel();
        }
        return accc_CustomSettings.ccConfigModel;
    } // end of crossCuttingConfigModel

    /**
     * @description get the cross-cutting UTILITY information
     * @return accc_CrossCuttingUtilityDataModel, cross-cutting UTILITY information
     */
    public static accc_CrossCuttingUtilityDataModel crossCuttingUtilityModel() {
        // local copy available
        if ( accc_CustomSettings.ccUtilityDataModel == null) {
            accc_CustomSettings.ccUtilityDataModel = new accc_CrossCuttingUtilityDataModel();
        }
        return accc_CustomSettings.ccUtilityDataModel;
    } // end of crossCuttingUtilityModel

    /////////////////////////////////////////////////////////////////////////////////////////////
    //++++++++++++++++++++++++++++++++++ Private Static methods +++++++++++++++++++++++++++++++++
    /////////////////////////////////////////////////////////////////////////////////////////////
    /**
     * @description get the known resource settings, do this once to cut back on access limits.
     * Not applicable to custom MDT, but saves work!
     * @return Map<String, Object>, our known resources
     */
    static Map<String, Object> getKnownResourceSettings() {
        // seed the known resources with values using what we know.
        if ( accc_CustomSettings.knownSettings.size() == 0 ) {
            accc_CustomSettings.knownSettings.put(accc_ApexConstants.UseCachingStrategy_r,
                                                  accc_CustomSettings.useCachingStrategy());
            accc_CustomSettings.knownSettings.put(accc_ApexConstants.TriggersEnabled_r,
                                                  accc_CustomSettings.triggersEnable());
            accc_CustomSettings.knownSettings.put(accc_ApexConstants.MaxChunkSize_r,
                                                  accc_CustomSettings.defaultMaxNumberOfItemsInChunks());
            accc_CustomSettings.knownSettings.put(accc_ApexConstants.SoftAsserts_r,
                                                  accc_CustomSettings.usingSoftAssert());
            accc_CustomSettings.knownSettings.put(accc_ApexConstants.EnvironmentClass_r,
                                                  accc_CustomSettings.environmentClass());
            accc_CustomSettings.knownSettings.put(accc_ApexConstants.CrossCuttingUtility_r,
                                                  accc_CustomSettings.crossCuttingInformation());
            accc_CustomSettings.knownSettings.put(accc_ApexConstants.DataCachingConfiguration_r,
                                                  accc_CustomSettings.cachingModel());
            accc_CustomSettings.knownSettings.put(accc_ApexConstants.CrossCuttingConfiguration_r,
                                                  accc_CustomSettings.crossCuttingConfigModel());
        }
        return accc_CustomSettings.knownSettings;
    } // end of getKnownResourceSettings

} // end of accc_CustomSettings