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
 * @description Creates singleton for accc_ApexBaseRuntimeEnvironment
 * @group Common Layer
 */
public without sharing class accc_ApexRunEnvironmentSingleton extends accc_ApexBaseRuntimeEnvironment {

    ////////////////////////////////////////////////////////////////////////////////
    /// Data Members
    ////////////////////////////////////////////////////////////////////////////////


    /**
     * @description  our run environment
     */
    @TestVisible
    private static final accc_ApexRunEnvironmentSingleton classInstance = null;

    ////////////////////////////////////////////////////////////////////////////////
    /// Static Initializer
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description static initializer
     */
    static {
        accc_ApexRunEnvironmentSingleton.classInstance = new accc_ApexRunEnvironmentSingleton();
    } // end  of static initializer

    ////////////////////////////////////////////////////////////////////////////////
    /// Ctors
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description private ctor of the singleton -- one instance (DO NOT DELETE!!!)
     */
    private accc_ApexRunEnvironmentSingleton() {

    } // end of default ctor
    ////////////////////////////////////////////////////////////////////////////////
    /// Public Methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description get the singleton instance of the test environment
     * @return accc_IApexRunEnvironment
     */
    public static accc_IApexRunEnvironment getInstance() {
        return accc_ApexRunEnvironmentSingleton.classInstance;
    } // end of getInstance

} // end of accc_ApexRunEnvironmentSingleton