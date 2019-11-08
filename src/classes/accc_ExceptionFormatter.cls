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
 * @description Implementation of the exception formatter.
 * @group Exception Handling
 */
public without sharing class accc_ExceptionFormatter implements accc_IDataFormat {
    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // CTORS
    //
    /////////////////////////////////////////////////////////////////////////////////////////


    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Public Methods
    //
    /////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @description Data to format
     *
     * @param  input data to format (Exception)
     * @return a formatted object
     */
    public Object format(Object information) {
        return this.format(information, accc_ApexExceptionPolicyEnum.Top);
    } // end of format
    /**
     * @description Data to format
     *
     * @param  input data to format (Exception)
     * @param  addtional information ( maybe null)
     * @return a formatted object
     */
    public Object format(Object information, Object misc) {
        String message = '';
        Exception excp = this.getExceptionFromObject(information);
        if ( excp != null ) {

            message = String.format('\nException Policy: {0}\nException type caught: {1}\nMessage: {2}\nCause: {3}\nLine number: {4}\nStack trace: {5}', new String[] {
                                        this.getPolicy(misc)
                                        , excp.getTypeName()
                                        , excp.getMessage()
                                        , String.valueOf(excp.getCause())
                                        , String.valueOf(excp.getLineNumber())
                                        , excp.getStackTraceString()
                                    });
        }
        return message;
    } // end of format
    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Private Methods
    //
    /////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @description Determine the policy
     *
     * @param misc the accc_ApexExceptionPolicyEnum
     * @return converted policy (accc_ApexExceptionPolicyEnum) into a string
     */
    @TestVisible
    private String getPolicy(Object misc) {
        accc_ApexExceptionPolicyEnum policy = accc_ApexExceptionPolicyEnum.Top;
        String result = policy.name();
        try {
            policy = (accc_ApexExceptionPolicyEnum) misc;
            result = policy.name();
        } catch (Exception excp) {}
        return  result;
    } // end of getPolicy
    /**
     * @description Get Exception from object
     *
     * @param theException. An object that should be an exception
     * @return a converted exception
     */
    @TestVisible
    private Exception getExceptionFromObject(Object theException) {
        Exception excp = null;
        try {
            excp = (Exception) theException;
        } catch (Exception ignoreExcp) {}
        return  excp;
    } // end of getExceptionFromObject
} // end of accc_ExceptionFormatter