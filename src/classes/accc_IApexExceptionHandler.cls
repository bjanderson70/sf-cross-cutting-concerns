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
 * @description Handles the exception. This could be logging the exception thru various channels
 *     and/or returning a more secure exception.
 * @group Common Interface Layer
 */
public virtual  interface accc_IApexExceptionHandler {

    /**
     * @description Process the exception (defaults to Global policy)
     *
     * @param excp  Exception
     */
    void process(Exception excp);
    /**
     * @description Process the exception (w/ special handling of the data logged)
     *
     * @param Exception
     * @param Boolean handle Log Output Carefully (this attempts to send information to system.debug when logging is enabled)
     */
    void process(Exception excp, boolean handleLogOutputCarefully);
    /**
     *
     * @description Process the exception and the associate policy
     *
     * @param excp Exception
     * @param policy accc_ApexExceptionPolicyEnum
     */
    void process(Exception excp, accc_ApexExceptionPolicyEnum policy);

    /**
     *
     * @description Process the exception and the associated policy; and log it if needed
     *
     * @param excp Exception
     * @param policy accc_ApexExceptionPolicyEnum
     * @param logException Boolean
     */
    void process(Exception excp, accc_ApexExceptionPolicyEnum policy, Boolean logException);

    /**
     *
     * @description Determine if we rethrow the same exception (defaults to Global policy), or a new one
     *
     * @param excp Exception
     * @return Exception the exception to rethrow
     */
    Exception rethrow(Exception excp);

    /**
     *
     * @description Determine if we rethrow the same exception (defaults to Global policy), or a new one
     *
     * @param excp Exception
     * @param policy accc_ApexExceptionPolicyEnum
     *
     * @return [Exception the exception to rethrow
     */
    Exception rethrow(Exception excp, accc_ApexExceptionPolicyEnum policy);

} // end of accc_IApexExceptionHandler