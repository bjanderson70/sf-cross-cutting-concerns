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
 * @author Bill Anderson
 * @description Encapsulates all behaviour logic relating to the Trigger invocation
 * @group Common Layer
 */
public without sharing class accc_TriggerHelperClass {

    // Trigger states
    public enum TriggerState {
        BeforeInsert, BeforeUpdate, BeforeDelete,
        AfterInsert, AfterUpdate, AfterDelete, AfterUndelete
    }

    // trigger event per object
    private static Map<String, Map<TriggerState, Boolean> > triggerActionPerObject = new  Map<String, Map<TriggerState, Boolean> >();
    // default trigger state
    private  static Map<TriggerState, Boolean> triggerAction = new Map<TriggerState, Boolean> {
        TriggerState.BeforeInsert  => true
        , TriggerState.BeforeUpdate => true
        , TriggerState.BeforeDelete => true
        , TriggerState.AfterInsert => true
        , TriggerState.AfterUpdate  => true
        , TriggerState.AfterDelete  => true
        , TriggerState.AfterUndelete => true
    };

    /**
     * @description toggle the event state of the object
     *
     * @param objectName the object name
     * @param action trigger event
     *
     * @return true, if first time; false otherwise
     */
    public static  Boolean toggleRunState(String objectName, TriggerState action) {
        Boolean result = false;
        // note, put returns the Previous value at that location
        if (  string.IsBlank(objectName) ) {
            return result;
        }
        Map<TriggerState, Boolean> triggerMap = accc_TriggerHelperClass.getTriggerMap(objectName);
        if ( triggerMap != null) {
            // set to false now, the FIRST value is current setting (first time, will be true)
            result = triggerMap.put(action, false);
        }
        return result;

    } // end of toggleRunState
  
    /**
     * @description is this a known action
     *
     * @param actionName name of the action BeforeInsert, etc.
     * @return true, if valid
     */
    public static Boolean isKnownAction(TriggerState eventName) {
        Boolean status = false;
        if (accc_TriggerHelperClass.triggerAction.containsKey(eventName) ) {
            status = accc_TriggerHelperClass.triggerAction.get(eventName);
        }
        return status;
    } // end of isKnownAction
    /**
     * @description based on the object name, ie Lead, Contact, and the action, ie. before insert, after insert,
     *          return back true if it has been called, false otherwise
     *
     * @param objectName Lead,Contact, etc.
     * @param action one of the defined actions in accc_TriggerHelperClass ( before insert, after updated, etc.)
     *
     * @return true, if the object / action has executed before
     */
    public static Boolean hasBeenCalled(String objectName, TriggerState action) {
        Boolean result = false;

        // note, put returns the Previous value at that location
        if (   string.IsBlank(objectName) ) {
            return result;
        }
        Map<TriggerState, Boolean> triggerMap = accc_TriggerHelperClass.getTriggerMap(objectName);
        if ( triggerMap != null) {
            result = triggerMap.get(action) == false;
        }
        return result;

    } // end of hasBeenCalled
    /**
     * @description reset the trigger check
     */
    // @deprecated
    public static void reset() {

        for (String objectname : accc_TriggerHelperClass.triggerActionPerObject.keyset() ) {
            accc_TriggerHelperClass.reset(objectname);
        }
    } // end of reset

    /**
     * @description reset the trigger check based on the object name
     * @param String the SObject name
     */
    public static void reset(String objectName) {

        if ( string.IsBlank(objectName) ) {
            return;
        }
        // get the trigger map based on object name
        Map<TriggerState, Boolean> triggerMap = accc_TriggerHelperClass.getTriggerMap(objectName);
        if ( triggerMap != null) {
            for (TriggerState action : triggerMap.keyset() ) {
                triggerMap.put(action, true);
            }
        }
    } // end of reset

    /**
     * @description get the trigger map for this object
     *
     * @param objectName the name of the object
     * @return map of actions
     */
    @TestVisible
    private static Map<TriggerState, Boolean> getTriggerMap(String objectName) {
        // valid name
        if (   string.IsBlank(objectName) ) {
            return null;
        }
        // first time it will be null
        Map<TriggerState, Boolean>  triggerMap = accc_TriggerHelperClass.triggerActionPerObject.get(objectName);
        if ( triggerMap == null ) {
            // clone/copy the triggerAction Map ( as ALL values start at 'true')
            triggerMap = new Map<TriggerState, Boolean>(accc_TriggerHelperClass.triggerAction);
            // add to container for reference
            accc_TriggerHelperClass.triggerActionPerObject.put(objectName, triggerMap);
        }
        return triggerMap;

    } // end of getTriggerMap
} // end of accc_TriggerHelperClass