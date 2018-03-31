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
 * @description Factory to Creates test objects (Mocks)
 * This shows you a way to change behavior of the runtime environment by inheriting from
 * 'accc_ApexObjectFactory' should there be a need. However, you have the ability to change behavior
 * via the custom metadata, Apex Code Configurations.
 */
public without sharing class accc_ApexTestObjectFactory extends accc_ApexObjectFactory {

    ////////////////////////////////////////////////////////////////////////////////
    /// Ctors
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description default ctor
     */
    public accc_ApexTestObjectFactory() {
        this.initialize();
    } // end of ctor

    ////////////////////////////////////////////////////////////////////////////////
    /// Private Methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description Initialize what the factory knows how to create
     */
    private void initialize() {

        // The base class has already initialized these resources; however,
        // here we override them
 
        this.addToCollection(accc_ApexConstants.ConfigurationResource, accc_ConfigurationTestProvider.class);
        this.addToCollection(accc_ApexTestUtilities.FallbackTestResource, accc_ApexTestJSONDataFallback.class);
        // want informaiton going to 'debug log ', i.e system.debug
        this.addToCollection(accc_ApexConstants.LoggerResource, accc_ApexLogger.class);
        
    } // end of initialize

} // end of accc_ApexTestObjectFactory