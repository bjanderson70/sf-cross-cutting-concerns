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
 * @description Test the Exception Policy
 * @group Common Test Layer
 */
@isTest
private class accc_ApexExceptionPolicyStrategyTest {

    // test exception
    private class TestStrategyException extends Exception {}
    // our strategy
    private final static accc_IApexExceptionPolicyStrategy policyStrategy = (accc_IApexExceptionPolicyStrategy)  accc_ApexEnvironment.getRuntimeEnvironment().objectFactory().create(accc_ApexConstants.ExceptionPolicyHandler);

    /**
     * @description Test to make sure the SAME exception IS returned
     */
    @isTest static void testRethrowShouldBeSameException() {
        // assign
        TestStrategyException excp = new TestStrategyException('my test');
        // act
        Exception returned = policyStrategy.rethrow( excp);
        // assert
        system.assertEquals(returned.getMessage(), excp.getMessage());
    } // end of testRethrowShouldBeSameException


    /**
     * @description Test to make sure the exception IS re-translated based on policy
     *
     */
    @isTest static void testRethrowShouldNotBeSameException() {
        // assign
        NullPointerException excp = accc_ApexExceptionPolicyStrategyTest.getException();
        // act
        Exception returned = policyStrategy.rethrow( excp, accc_ApexExceptionPolicyEnum.Top);
        // assert
        system.assertNotEquals(returned.getTypeName(), excp.getTypeName());
    } // end of testRethrowShouldNotBeSameException


    /**
     * @description Test to make sure the exception is not re-translated
     */
    @isTest static void testRethrowShouldReturnNullPointerExcpDueToPolicy() {
        //  assign
        NullPointerException excp = accc_ApexExceptionPolicyStrategyTest.getException();
        // act
        NullPointerException returned = (NullPointerException)policyStrategy.rethrow( excp, accc_ApexExceptionPolicyEnum.Data);
        // assert
        system.assertNotEquals(null, returned);
    } // end of testRethrowShouldReturnNullPointerExcpDueToPolicy


    /**
     * @description Create a null exception
     * @return NullPointerException
     */
    private static NullPointerException getException() {
        NullPointerException returned = null;

        try {
            String myNull = null;
            Integer len = myNull.length();
        } catch (NullPointerException excp) {
            returned = excp;
        }

        return returned;
    } // end of getException

} // end of accc_ApexExceptionPolicyStrategyTest