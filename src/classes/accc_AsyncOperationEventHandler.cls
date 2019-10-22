/**
 * Copyright (c) 2016-2019, Bill Anderson.
 * All rights reserved.
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
 * @description Handles AsyncOperationEvent errors. This simple mechanism just logs the data.
 *
 * Notes:
 *  If logging into the Big Object was not done, then this will NOT WORK.
 *  In order to log to Big Object for publishing platform events, you must
 *  either use the default settings for PlatformEventAttrs 'getDefaultAttributes' )
 *  or ensure the following:
 *
 *     1). event storing is true
 *     2). serialization is true
 *
 * Logging to Big Object allows us to retrieve the Operation Ids.
 *
 * @group Platform Events Handling
 */
public with sharing class accc_AsyncOperationEventHandler extends accc_EventBase {

    /////////////////////////////////////////////////////////////////////////
    // Data Members
    /////////////////////////////////////////////////////////////////////////
    // use for testing exception
    @TestVisible
    static Boolean useForTestingException=false;
    @TestVisible
    static final string FOR_TESTING_EXCEPTION = 'accc_AsyncOperationEventHandler:accc_ApexApplicationException';
    @TestVisible
    static final string TEST_MESSAGE = '++++ TEST Trigger Called - accc_AsyncOperationEventHandler';

    /////////////////////////////////////////////////////////////////////////
    // Public Methods
    /////////////////////////////////////////////////////////////////////////

    /**
     * @description Platform events only supports after insert
     *
     * @param List<SObject> list of new sobjects
     */
    public virtual override void onAfterInsertChild(List<SObject> newItems) {
        /*
         * TBD
         * We have some events that did not get published .
         * The publisher writes the data into the BigObject
         */
        try {
            /*******************************************************
             * START : FOR Testing
             */
            if ( accc_ApexConstants.UNIT_TEST_RUNNING ) {
                accc_ApexUtilities.log(TEST_MESSAGE);
                if (useForTestingException ) {
                    throw new accc_ApexApplicationException(FOR_TESTING_EXCEPTION);
                }
            }
            /*
             * END: FOR Testing
             *******************************************************/

            // We have events that did not get published ( though, enqueued).
            //
            // If logging into the Big Object was not done, then this will NOT WORK.
            // In order to log to Big Object for publishing platform events, you must
            // either use the default settings for PlatformEventAttrs 'getDefaultAttributes' )
            // or ensure the following:
            //
            //     1). event storing is true [Attributes]
            //     2). serialization is true [Attributes]
            //     3) platform event binding for the event 
            //         a) correct run time environment
            //         b) Using the accc_DefaultProcessStoreHandler for the Store Handlere
            // TBD
            // for ( SObject event : newItems) {
            //
            // }

        } catch (Exception excp) {
            // process exception, handle w/ care
            accc_ApexEnvironment.getRuntimeEnvironment().exceptionHandler().process(excp, true);
            /*******************************************************
             * START : FOR Testing
             */
            if ( useForTestingException && accc_ApexConstants.UNIT_TEST_RUNNING ) {
                // ensure we are write internally (static array)
                accc_ApexUtilities.log(excp);
            }
            /*
             * END: FOR Testing
             *******************************************************/
        }

    }// end of onAfterInsertChild

} // end of accc_AsyncOperationEventHandler