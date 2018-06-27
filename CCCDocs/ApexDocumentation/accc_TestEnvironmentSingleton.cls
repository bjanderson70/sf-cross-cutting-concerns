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
 * @description provide a single source of truth for the test environment
 * @group Common Test Layer
 */
public without sharing class accc_TestEnvironmentSingleton extends  accc_ApexBaseRuntimeEnvironment {

    ////////////////////////////////////////////////////////////////////////////////
    /// Data Members
    ////////////////////////////////////////////////////////////////////////////////

    // our test environment
    private static accc_TestEnvironmentSingleton classInstance ;

    ////////////////////////////////////////////////////////////////////////////////
    /// Static Initializer
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description static initializer
     */
    static {
        accc_TestEnvironmentSingleton.classInstance = new accc_TestEnvironmentSingleton();
    } // end  of static initializer

    ////////////////////////////////////////////////////////////////////////////////
    /// Ctors
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description private ctor of the singleton -- one instance (DO NOT DELETE CTOR)
     */
    private accc_TestEnvironmentSingleton() {
    } // end of default ctor

    ////////////////////////////////////////////////////////////////////////////////
    /// Public Methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description get the singleton instance of the test environment
     * @return accc_IApexRunEnvironment
     */
    public static  accc_IApexRunEnvironment getInstance() {
        return accc_TestEnvironmentSingleton.classInstance;
    } // end of getInstance

    /**
     * @description created the objects from the known list
     * @return a factory to create objects
     */
    public override  accc_IApexFactory objectFactory() {
         if ( this.theFactory == null ) {
            // default test factory, subject to change
            super.objectFactory(  new  accc_ApexTestObjectFactory());
        }
        return this.theFactory;
    } // end of objectFactory

} // end of accc_TestEnvironmentSingleton