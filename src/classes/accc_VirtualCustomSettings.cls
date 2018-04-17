/**
 * Copyright (c) 2016-2018, Bill Anderson. All rights reserved.
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
 * Encapsulates all behaviour logic relating to the custom settings
 * @author Bill Anderson
 * @description Encapsulates all behaviour logic relating to the custom settings.
 *  If there are additions specific to different Organizations that deviate from the
 *  core, then subclass this class and augment accordingly.
 *
 * @group Common Layer
 */
public virtual class accc_VirtualCustomSettings implements accc_IConfigurationProvider {


    /**
     * @description load the configuration
     * @return true, if the configuration was loaded
     */
    public virtual Boolean load() {
        return true;
    } // end of load

    /**
     *
     * @description get a value based on the name from the <name,value> pair
     *
     * @param name key name
     * @return object ( must be cast appropriately)
     */
    public virtual Object get(String name) {
        return accc_CustomSettings.getEntity(name);
    } // end of get
    /**
    *
    * @description is caching enabled for this label
    *
    * @param string identifier/label
    * @return true, if caching is enabled for this  identifier/label
    */
    public virtual  boolean caching (String label) {
        return accc_CustomSettings.caching(label);
    } // end of caching
    /**
     * @description triggers enable
     * @return boolean, true if triggers are enable
     */
    public virtual boolean triggersEnable() {
        return accc_CustomSettings.triggersEnable();
    } // end of triggersEnable
    /**
    * @description trace flag is on
    * @return boolean, true if trace flag is on
    */
    public virtual boolean traceFlagOn() {
        return accc_CustomSettings.traceFlagOn();
    } // end of traceFlagOn

    /**
     * @description trace flag is on
     * @return boolean, true if trace flag is on
     */
    public virtual LoggingLevel traceLogLevel() {
        return accc_CustomSettings.traceLogLevel();
    } // end of traceLogLevel
    /**
    * @description show the trace information for CC type files
    * @return boolean, true if  trace information for CC type files is shown
    */
    public virtual boolean showCCTraceInfo() {
        return accc_CustomSettings.showCCTraceInfo();
    } // end of showCCTraceInfo
    /**
     * @description determine if we are using caching strategy
     * @return true, if using caching strategy
     */
    public virtual boolean useCachingStrategy() {
        return accc_CustomSettings.useCachingStrategy();
    } // end of useCachingStrategy
    /**
    * @description get the environment class
    * @return class name of the environment
    */
    public virtual String environmentClass() {
        return accc_CustomSettings.environmentClass();
    } // end of environmentClass

    /**
     * @description default max. number of items in a chunk/packet sent to external systems (via apex batch)
     * @return default size
     */
    public virtual integer defaultMaxNumberOfItemsInChunks() {
        return accc_CustomSettings.defaultMaxNumberOfItemsInChunks();
    } // end of environmentClass
    /**
     * @description get the data caching model
     * @return accc_DataCachingDataModel, data caching model
     */
    public virtual accc_DataCachingDataModel cachingModel() {
        return accc_CustomSettings.cachingModel();
    } // end of cachingModel

    /**
     * @description get the cross-cutting configuration class
     * @return accc_CrossCuttingConfigDataModel, cross-cutting configuration class
     */
    public virtual accc_CrossCuttingConfigDataModel crossCuttingConfigModel() {
        return accc_CustomSettings.crossCuttingConfigModel();
    } // end of crossCuttingConfigModel


    /**
    * @description get the cross-cutting UTILITY information
    * @return accc_CrossCuttingUtilityDataModel, cross-cutting UTILITY information
    */
    public virtual accc_CrossCuttingUtilityDataModel crossCuttingUtilityModel() {
        return accc_CustomSettings.crossCuttingUtilityModel();
    } // end of crossCuttingUtilityModel
} // end of accc_VirtualCustomSettings