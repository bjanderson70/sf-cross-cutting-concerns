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
 * @description Handles Platform Events for Logging.
 *    This handler is associated with 'accc_ApexPublishEventLogger'. If this logger is
 *    wired into 'ApexRunEnvironmentSingleton', a trigger fires (after insert Log__e).
 *    The trigger, 'accc_LogPlatformEventTrigger', fires and instantiates this class.
 *    The dispatcher calls 'run' and run invokes 'afterInsert'
 *
 * @group Common Layer
 */
public without sharing class accc_LogPlatformEventHandler implements accc_IApexPlatformEventHandler {

    /**
     * @description Platform events only supports after insert
     *
     * @param List<SObject> list of new sobjects
     */

    public void afterInsert(List<SObject> newItems) {

        try {
            List<Log__e> elogs = (List<Log__e>)newItems;
            List<ApplicationLog__c> theApplicationLogs = accc_MessageTransformation.translate(elogs);
            // any data to add
            if ( theApplicationLogs != null && theApplicationLogs.size() > 0) {
                insert theApplicationLogs;
            }
        } catch (Exception excp) {
            // process exception, handle w/ care
            accc_ApexRunEnvironmentSingleton.getInstance().exceptionHandler().process(excp, true);
        }

    } // end of afterInsert

} // end of accc_LogPlatformEventHandler