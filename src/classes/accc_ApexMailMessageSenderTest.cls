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
 * @author Bill Anderson
 * @description Test Mail message sender
 * @group Common Test Layer
 */
@isTest
private class accc_ApexMailMessageSenderTest {

    
     /**
     * @decription Test with invalid data
     */
    @isTest
    static void testSendWithInvalidData() {
        accc_ApexMessagePayload payload = setupMailPayload();
        accc_IApexMessageSender sender = new accc_ApexMailMessageSender();

        accc_ApexMessageSendResponse response = sender.send(payload);

        System.assert(response != null, 'testSendWithInvalidData , accc_ApexMessageSendResponse == null');
        System.assert(response.getResponse() == null, 'testSendWithInvalidData , response.getResponse != null');
    }

    
     /**
     * @decription Test sending valida data
     */
    @isTest
    static void testSendWithValidData() {
        accc_ApexMessagePayload payload = setupMailPayload();

        accc_IApexMessageSender sender = new accc_ApexMailMessageSender();
        payload.attributes.put('Reply', 'replyto@test.com');
        accc_ApexMessageSendResponse response = sender.send(payload);

        System.assert(response != null, 'testSendWithValidData , accc_ApexMessageSendResponse == null');
        System.assert(response.getResponse() != null, 'testSendWithValidData , response.getResponse == null , exception=' + response.getException());
    } // end of testSendWithValidData

    //==============================================================================================
    // Private Methods
    //==============================================================================================

    static accc_ApexMessagePayload setupMailPayload() {
        accc_ApexMessagePayload payload = new accc_ApexMessagePayload();

        payload.attributes.put('Recipients', new List<String> {'test@nowhere.com'});
        payload.attributes.put('CC', new List<String> {'testcc@nowhere.com'});
        payload.attributes.put('BCC', new List<String> {'testbcc@nowhere.com'});
        payload.attributes.put('Subject', 'Testing');
        payload.attributes.put('DisplayName', 'Ms Testing');
        payload.attributes.put('Body', 'Test Body of Email');

        return payload;
    } // end of setupMailPayload

}