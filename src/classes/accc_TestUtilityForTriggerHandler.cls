/**
 * Copyright (c) 2016-2019, Bill Anderson. All rights reserved.
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
 * @description Utilities for testing trigger handler functionality
 * @group Test Layer
 */
@TestVisible
@isTest
private class accc_TestUtilityForTriggerHandler {
    /**
     * @description used to fire the trigger handler. Normally,
     * this is fire when the handler function is wired into your trigger framework
     *
     * @param domain name
     */
    @TestVisible
    static void cannotAssumeWeAreWireIntoTriggerHandler(String domain) {
        accc_TriggerHandlerChainManager mgr = new accc_TriggerHandlerChainManager(accc_ApexEnvironment.getEnvironment());
        accc_IHandlerChain chain = mgr.createHandlerChainByDomain(domain);
        List<SObject> records = null;
        accc_ITriggerHandlerResources resources=null;
        while (chain != null ) {
            // invoke the events --  we will invoke all for simplicity of testing
            accc_ITriggerHandler handler = chain.getHandler();
            // pass previous resources from trigger to next handler
            handler.handlerResources(resources);
            
            handler.onBeforeInsertChild(records);
            handler.onAfterInsertChild(records);
            handler.onBeforeUpdateChild(records, null);
            handler.onAfterUpdateChild(records, null);
            handler.onBeforeDeleteChild(records);
            handler.onAfterUndeleteChild(records);
            handler.onAfterDeleteChild(records);
            // pass resources onto next
            resources=handler.handlerResources();

            // get next handler in the chain
            chain = chain.getNext();
        }
    }// end of cannotAssumeWeAreWireIntoTriggerHandler
}
