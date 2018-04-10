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
 * @description test fallback json data
 * @group Common Test Layer
 */
@isTest
private class accc_ApexTestJSONDataFallbackTest {

    // ctor
    @isTest
    static void testCtorNullParam() {
        boolean wasCaught = false;
        try {
            accc_IFallbackResources  fallback = new accc_ApexTestJSONDataFallback(null);
        } catch (accc_ApexApplicationException caught) {
            wasCaught = true;

        }

        System.assertEquals(true, wasCaught);
    } // end of testCtorNullParam

    // default resource
    @isTest
    static void testDefaultResource() {
        accc_IFallbackResources  fallback = new accc_ApexTestJSONDataFallback();

        System.assertNotEquals(null, fallback.fallbackResource());
    } // end of testDefaultResource

    // valid to string
    @isTest
    static void testToString() {
        accc_IFallbackResources  fallback = new accc_ApexTestJSONDataFallback();

        System.assertNotEquals(null, fallback.toString());
    }// end of testToString

    // get a resource
    @isTest
    static void testget() {
        accc_IFallbackResources  fallback = new accc_ApexTestJSONDataFallback();

        System.assertEquals(accc_ApexConstants.DEFAULT_MAX_NUMBER_OF_ITEMS_IN_CHUNK,
                            integer.valueof(fallback.get(accc_ApexConstants.MaxChunkSize_r)));
    } // end of testget

    // valid Map
    @isTest
    static void testToSMap() {
        accc_IFallbackResources  fallback = new accc_ApexTestJSONDataFallback ();

        Map<String, Object> nvPair = fallback.toMap();
        System.assertNotEquals(null, nvPair);
        System.assertNotEquals(0, nvPair.size());
    } // end of testToSMap

} // end of accc_ApexTestJSONDataFallbackTest