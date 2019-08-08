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
 * @description Handles Platform Events Disptaching (after insert only)
 * @group Common Layer
 */
public without sharing class accc_ApexPlatformEventDispatcher {

    /**
     * @description run the platform event handler
     *
     * @param accc_ITriggerHandler apex platform event handler
     */
    public static void run(accc_ITriggerHandler handler) {
        // keep -- as this will log to an internal set during testing; otherwise, no-op
        accc_ApexUtilities.logForTesting('accc_ApexPlatformEventDispatcher handler=' + handler);

        // valid handler (Trigger.New can be null if calling from non-trigger [testing])
        // only handle after insert for dispatching platform events
        if (handler != null
                && Trigger.New != null
                && Trigger.IsAfter
                && Trigger.IsInsert) {
            String name = accc_ApexUtilities.getClassName(handler);
            // keep -- as this will log to an internal set during testing; otherwise, no-op
            accc_ApexUtilities.logForTesting('accc_ApexPlatformEventDispatcher.name=' + name);

            // protect against recursion
            if ( !accc_TriggerHelperClass.hasBeenCalled(name, accc_TriggerHelperClass.TriggerState.AfterInsert) ) {
                // toggle our state
                accc_TriggerHelperClass.toggleRunState(name, accc_TriggerHelperClass.TriggerState.AfterInsert);
                // call handler
                handler.onAfterInsertChild(Trigger.New);
            }
        }
    } // end of run
} // end of accc_ApexPlatformEventDispatcher
