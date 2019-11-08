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
 * @description Handles Log Event for Logging.
 *    This handler is associated with ACCC_Log_Event__e events.
 *    Currently, there is NO trigger enable bec/ if you use the Platform Event Publish/Consumer
 *    functionality, the data is logged into a Big Object by default.
 *
 *    If you DID NOT use the aforemention functionality, and want to process/log ACCC_Log_Event__e.
 *     1). Go to 'trigger' directory and create  the following (name it 'accc_LogEventTrigger'):
 *
 *               trigger accc_LogEventTrigger on ACCC_Log_Event__e (after insert) {
 *                    accc_ApexPlatformEventDispatcher.run(new accc_LogEventHandler());
 *               }
 *
 * @group Log Aspects
 */
public without sharing class accc_LogEventHandler extends accc_EventBase {

    /////////////////////////////////////////////////////////////////////////
    // Data Members
    /////////////////////////////////////////////////////////////////////////
    // use for testing exception
    @TestVisible
    static Boolean useForTestingException=false;
    @TestVisible
    static final string FOR_TESTING_EXCEPTION = 'accc_LogEventHandler:accc_ApexApplicationException';
    @TestVisible
    static final string TEST_MESSAGE = '++++ TEST Trigger Called - accc_LogEventHandler';

    /////////////////////////////////////////////////////////////////////////
    // Public Methods
    /////////////////////////////////////////////////////////////////////////
    /**
     * @description Capture the ACCC_Log_Event__e events -- only supports after insert
     *
     * @param List<SObject> list of new sobjects
     */
    public override void onAfterInsertChild(List<SObject> newItems) {

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
            List<ACCC_Log_Event__e> elogs = (List<ACCC_Log_Event__e>)newItems;
            List<AcccApplicationLog__c> theApplicationLogs = accc_MessageTransformation.translate(elogs);
            // any data to add
            if ( theApplicationLogs != null && theApplicationLogs.size() > 0) {
                accc_SObjectBaseWriter writer = new accc_QueableSObjects(theApplicationLogs);
                writer.execute();
            }

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

    } // end of onAfterInsertChild

} // end of accc_LogEventHandler