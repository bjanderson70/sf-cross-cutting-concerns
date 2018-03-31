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
 * @description Send information base on the channel (base class)
 * @group Common Layer
 *
 * TBD -- localization
 */
public without sharing abstract class accc_ApexBaseMessageSender implements accc_IApexMessageSender {

    ////////////////////////////////////////////////////////////////////////////////
    /// Data Members
    ////////////////////////////////////////////////////////////////////////////////
    @TestVisible
    protected accc_ApexApplicationException sendException = null;


    ////////////////////////////////////////////////////////////////////////////////
    /// Public Methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description  Get the exception if any
     * @return null if successful, Exception otherwise
     */
    public Exception getException() {
        return this.sendException;
    } // end of getException

    /**
     * @description Send information
     *
     * @param messagePayload broken into parts
     * @return Object ApexMessageSendResponse Response
     */
    public abstract accc_ApexMessageSendResponse send(accc_ApexMessagePayload messagePayload);

    ////////////////////////////////////////////////////////////////////////////////
    /// Protected Methods
    ////////////////////////////////////////////////////////////////////////////////

   /**
     * @description  reset state -- set exception back to null
     */
    @TestVisible
    protected void reset() {
        this.sendException = null;
    } // end of reset

    /**
     * @description get a string from the payload based on the index
     *
     * @param messagePayload payload
     * @param index into the payload
     * @param errorMesg error to set in the exception , if any
     * @return a string value
     */
    @TestVisible
    protected String getStringFromPayload(accc_ApexMessagePayload messagePayload, String index, String errorMesg) {
        return this.getStringFromPayload(messagePayload, index, errorMesg, false);
    } // end of getStringFromPayload

    /**
     * @description get a string[] from the payload based on the index
     *
     * @param messagePayload payload
     * @param index into the payload
     * @param errorMesg error to set in the exception , if any
     * @param ignoreException ignore the exception
     * @return a string[] value
     */
    @TestVisible
    protected List<String> getStringArrayFromPayload(accc_ApexMessagePayload messagePayload, String index, String errorMesg) {
        return this.getStringArrayFromPayload(messagePayload, index, errorMesg, false);
    } // end of getStringArrayFromPayload

    /**
     * @description get a string from the payload based on the index
     *
     * @param messagePayload payload
     * @param index into the payload
     * @param errorMesg error to set in the exception , if any
     * @param ignoreException ignore the exception
     * @return a string value
     */
    @TestVisible
    protected virtual String getStringFromPayload(accc_ApexMessagePayload messagePayload, String index, String errorMesg, Boolean ignoreException) {
        return (String )this.getEntity(messagePayload, index, errorMesg, ignoreException);
    } // end of getStringFromPayload

    /**
     * @description get a string[] from the payload based on the index
     *
     * @param messagePayload payload
     * @param index into the payload
     * @param errorMesg error to set in the exception , if any
     * @param ignoreException ignore the exception
     * @return a string[] value
     */
    @TestVisible
    protected virtual List<String> getStringArrayFromPayload(accc_ApexMessagePayload messagePayload, String index, String errorMesg, Boolean ignoreException) {
        return (List<String> )this.getEntity(messagePayload, index, errorMesg, ignoreException);
    } // end of getStringArrayFromPayload

    /**
     * @description Get the entity from the payload
     *
     * @param messagePayload payload
     * @param index into the payload
     * @param errorMesg error to set in the exception , if any
     * @param ignoreException ignore the exception
     *
     * @return Object
     */
    @TestVisible
    protected virtual Object getEntity(accc_ApexMessagePayload messagePayload, String index, String errorMesg, Boolean ignoreException) {
        Object results = null;

        try {
            if ( messagePayload != null &&
                    this.sendException == null &&
                    messagePayload.attributes != null ) {
                Map<String, Object> nvop = messagePayload.attributes;

                if ( nvop != null ) {
                    results = nvop.get(index);
                }
            }
        } catch (Exception excp) {
            this.handleException(messagePayload,excp, errorMesg, ignoreException);
        }

        return results;
    } // end of getEntity

    /**
     * @description handle the exception
     *
     * @param accc_ApexMessagePayload message Payload
     * @param Exception the Exception
     * @param String the error message
     * @param String additional error message
     * @return boolean true if ignore exception
     */
    @TestVisible
    private boolean handleException(accc_ApexMessagePayload messagePayload,Exception excp, String eMesg, boolean ignoreException) {
        if ( !ignoreException && excp != null) {
            String errorMesg = string.IsBlank(eMesg) ? 'Exception occurred in accc_ApexBaseMessageSender' : eMesg;
            this.sendException = new accc_ApexApplicationException(errorMesg, excp);
            messagePayload.payloadException = this.sendException;
            // process exception
            accc_ApexRunEnvironmentSingleton.getInstance().exceptionHandler().process(excp);
        }
        return !ignoreException && excp != null;
    } // end of handleException

}// end of accc_ApexBaseMessageSender