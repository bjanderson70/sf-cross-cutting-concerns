/**
 * Copyright (c) 2016-2018, Bill Anderson All rights reserved.
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
 *   * Neither the name of Bill Andersonnor Bill Anderson nor the names of its
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
 * @description base class for fallback resources
 *
 * @group Fallback Resources
 */
public virtual without sharing class accc_ApexBaseFallback implements accc_IFallbackResources {

    ////////////////////////////////////////////////////////////////////////////////
    /// Data Members
    ////////////////////////////////////////////////////////////////////////////////
    static  Map<String, Object> dataPair = null;

    // holds the default resource
    private String defaultResource = null;

    ////////////////////////////////////////////////////////////////////////////////
    /// Ctor
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description default ctor
     */
    public accc_ApexBaseFallback() {
        this(accc_ApexConstants.EmptyString);
    } // end of ctor

    ////////////////////////////////////////////////////////////////////////////////
    /// Public Methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description ctor , holds json data of resources
     *
     * @param defaultValue holds json data of resources
     */
    public accc_ApexBaseFallback(String defaultValue) {
        this.defaultResource = defaultValue;
      
        if ( string.isBlank(this.defaultResource) ) {
            throw new accc_ApexApplicationException('accc_ApexBaseFallback: Bad default resource passed to ctor');
        }
    } // end of ctor

    /**
     * @description Get Fallback Resources
     * @return Object - holds json data of resources (String)
     */
    public virtual Object fallbackResource() {
        return this.defaultResource ;
    } // end of fallbackResource

    /**
     * @description get fallback resource as a string
     * @return get fallback resource as a string
     */
    public override String toString() {
        return this.defaultResource ;
    } // end of toString
    /**
     * @description get fallback resource
     * @return get fallback resource by name
     */
    public virtual Object get(string name) {
        return this.get(null, name) ;
    } // end of get
    /**
    * @description Get a resource by name and category { category: { name1: value1, name2: value2} }
    * @param String category of the resource, the common names are in accc_ApexConstants
    * @param String name of the resource, the common names are in accc_ApexConstants
    * @return Object the result. The common names will detail the return type
    * @example
    * Example code usage. This will be wrapped in  tags to preserve whitespace
    */
    public virtual Object get(string category, string name) {
        String catNormalized = string.isBlank(category) ? accc_ApexConstants.EmptyString : category;

        return this.getSubResource(this.toMap(), catNormalized, name);

    } // end of get
    /**
     * @description get fallback resource as a Map<String,Object>
     * @return get fallback resource as a Map<String,Object>
     */
    public virtual Map<String, Object> toMap() {
       
        try {
            if ( accc_ApexBaseFallback.dataPair == null ) {
                accc_ApexBaseFallback.dataPair =  (Map<String, Object>) JSON.deserializeUntyped(this.defaultResource );
            }
        } catch (Exception excp) {
            this.handleException(excp);
        }

        return accc_ApexBaseFallback.dataPair;
    } // end of toMap

    /**
     * @description get fallback sub resource as a Object
     * @param Map<String, Object> highlevel container
     * @param String object resource
     *
     * @return get fallback resource as Object
     */
    @TestVisible
    protected virtual Object getSubResource(Map<String, Object> mainMap, string category, string name) {
        Object result = null;
       
        // second check for the data, in the event child calls us
        if ( !String.isBlank(name) && category != null && mainMap != null)  {
            try {
                // get the map, may need to dig into the json to get the right collection
                Map<String, Object> jsonMap = this.getJsonMap(category, mainMap);
                // was one found
                if ( jsonMap != null) {
                    result =  jsonMap.get(name);
                }
            } catch (Exception excp) {
                this.handleException(excp);
            }

        }
        return result;
    } // end of getSubResource

    /**
     * @description If the main map is already drilled down into the category may reference a high-level
     * 'production' or 'debug', and these fallback resources are lower at the interface and concrete level,
     * so just return the 'mainmap' back
     *
     * @param category category to drill further down in
     * @param mainMap the resource map
     *
     * @return collection of resources
     */
    private Map<String, Object> getJsonMap(string category, Map<String, Object> mainMap) {

        Map<String, Object> jsonMap = !String.isBlank(category) ? (Map<String, Object>) mainMap.get(category) : mainMap;
      
        if ( jsonMap == null) {
            jsonMap =  mainMap;
        }
        return jsonMap;
    } // end of getJsonMap
    /**
     * @description handle the exception. We have to be careful here. Why?
     * If this represents Fallback exceptions and the factory uses fallback exceptions then
     * the runtime singleton can get into an infinite loop. So, here we just use 'accc_IApexExceptionHandler'
     * which handles exceptions appropriately
     *
     * @param excp Exception
     */
    @TestVisible
    private void handleException(Exception excp) {
        accc_IApexExceptionHandler handler = accc_ApexEnvironment.getRuntimeFallbackExceptionHandler();
        handler.process(excp, true);
    } // end of handleException

} // end of accc_ApexBaseFallback