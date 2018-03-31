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
 * @description This class provides access to static resource for testing. The resource
 *     is used to determine if we use soft-assertions and if we are testing a particular method.
 * @group Common Test Layer
 */
public without sharing class accc_ConfigurationTestProvider implements accc_IConfigurationProvider {

    ////////////////////////////////////////////////////////////////////////////////
    /// Data Members
    ////////////////////////////////////////////////////////////////////////////////

    // our class used to map name-value pairs
    @TestVisible
    private static Map<String, Object> mapping = null;

    ////////////////////////////////////////////////////////////////////////////////
    /// Ctor
    ////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////
    /// Public Methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description load the custom setting resource
     * @return true, if loaded
     */
    public Boolean load() {
        if ( accc_ConfigurationTestProvider.mapping == null ) {
            accc_ConfigurationTestProvider.mapping = this.getFallbackResource();
        }

        return accc_ConfigurationTestProvider.mapping != null;
    } // end of load

    /**
     * @description Find the <name,value> pair of static resources. Controls
     *              the tests, and resources
     *
     * @param String look up by name
     * @return Object resource
     */
    public  Object get( String name) {
        Object result = null;
        if ( !this.load() || string.IsBlank(name) ) {
            return result;
        }

        try {
            // is there a resource
            result = accc_ConfigurationTestProvider.mapping.get(name);
        } catch (Exception excp) {
            accc_TestEnvironmentSingleton.getInstance().logger().write('EXCEPTION in get :' + excp.getMessage());
        }

        return result;
    } // end of get

    ////////////////////////////////////////////////////////////////////////////////
    /// Private Methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description get fallback resources
     * @return Map<String,Object> name/value pair
     */
    @TestVisible
    private Map<String, Object> getFallbackResource() {
        Map<String, Object> resource = accc_ConfigurationTestProvider.mapping;

        try {
            if ( accc_ConfigurationTestProvider.mapping == null ) {
                // get the fallback resources for tests
                accc_IFallbackResources fallback = accc_TestEnvironmentSingleton.getInstance().fallbackResources();
                if ( fallback != null && fallback.toMap() != null ) {
                    accc_ConfigurationTestProvider.mapping =  fallback.toMap().clone();
                    resource = accc_ConfigurationTestProvider.mapping;
                }
            }

        } catch (Exception excp) {
            accc_TestEnvironmentSingleton.getInstance().logger().write('EXCEPTION in getFallbackResource :' + excp.getMessage());
        }

        return resource;
    } // end of getFallbackResource

} // end of accc_ConfigurationTestProvider