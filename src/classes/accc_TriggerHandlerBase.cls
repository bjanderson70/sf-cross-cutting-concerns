/**
 * Copyright (c) 2016-2018, Bill anderson.  All rights reserved.
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
 *   * Neither the name of Bill anderson nor the names of its
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
 * @author Bill anderson
 * @description Encapsulates all behaviour logic relating to the generic trigger handling by
 * children called from the Domain class (Domain class is Account, Contact, etc.). Following
 * the Apex Enterprise Framework (fflib); the domain object ( i.e. Account) inherits from fflib_SObjectDomain.
 * Here to simplify usage create a base class (i.e. AEFDomainBase) to control the trigger events. Then
 * have your AccountDomain, ContactDomain, etc. inherit from AEFDomainBase. This way the common
 * functionality ( triggers enabled/disabled, etc.) can be encapsulated in the base (AEFDomainBase).
 *
 * Then any developer wishing to inject their trigger handler (for Account, Contact, etc) would have to
 * perform 2 steps:
 *    1) Inherit from this class; overriding appropriate methods
 *    2) Update the custom metadata (accc_Trigger_Handler_MetaData_Model__mdt) in Salesforce to register
 *       there class. 'accc_TriggerHandlerChainManager' takes care of the rest (by reading the data model and
 *       creating the chain of handlers).
 *
 *
 *
 *
 * @group Common Trigger Layer
 **/
public virtual with sharing class accc_TriggerHandlerBase implements accc_ITriggerHandler {

    ////////////////////////////////////////////////////////////////////////////////
    /// Data Members
    ////////////////////////////////////////////////////////////////////////////////

    @TestVisible
    private accc_ITriggerHandlerResources m_parameters = null;

    @TestVisible
    private Object for_testing = null;
    /*
     * Used for testing
     */
    public static final String OBIC ='++++++++++++++On Before Insert';
    public static final String OBUC ='++++++++++++++On Before Update';
    public static final String OAIC ='++++++++++++++On After Insert';
    public static final String OAUC ='++++++++++++++On After Update';
    public static final String OBDC='++++++++++++++On Before Delete';
    public static final String OADC = '++++++++++++++On After Delete';
    public static final String OAUDC ='++++++++++++++On After UnDelete';
    public static final Boolean UNIT_TESTING = System.Test.isRunningTest();

    ////////////////////////////////////////////////////////////////////////////////
    /// Ctors
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description default ctor
     *
     */
    public accc_TriggerHandlerBase() {
        this((accc_ITriggerHandlerResources)null);
    } // end of ctor

    /**
     * @description ctor
     *
     * @param parameters information for the children
     */
    public accc_TriggerHandlerBase(accc_ITriggerHandlerResources parameters) {
        this.theParameters = parameters;
    }// end of ctor

    ////////////////////////////////////////////////////////////////////////////////
    /// Properties
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * The paramters (resources) for this handler.
     * Used to pass information between handlers
     */
    @TestVisible
    protected accc_ITriggerHandlerResources theParameters {
        get {
            if ( this.m_parameters == null ) {
                this.m_parameters=new accc_TriggerHandlerResources();
            }
            return this.m_parameters;
        }
        protected set {
            if ( value != null) {
                this.m_parameters = value;
            }
        }
    } // end of theParameters

    ////////////////////////////////////////////////////////////////////////////////
    /// Public Methods
    ////////////////////////////////////////////////////////////////////////////////

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //
    // If you need to handle after/before events, override the following methods
    // Note, current records from the trigger are in 'records'
    //

    /**
     * @description holds parameters passed between handlers
     * @return accc_ITriggerHandlerResources
     **/
    public accc_ITriggerHandlerResources handlerResources() {
        return this.theParameters;
    }// end of handlerResources

    /**
     * @description setter to allow resources to passed between handlers
     * @return void
     **/
    public void handlerResources(accc_ITriggerHandlerResources resources) {
        this.theParameters=resources;
    } // end of handlerResources
    /**
     * @description add an error on the sobject. When used on Trigger.new
     * in before insert and before update triggers, and on Trigger.old in
     * before delete triggers, the error message is displayed in the application
     * interface.
     *
     * @param triggerObject the salesforce object (from the trigger invocation) to see the error message
     * @param errorMessage error message
     */
    public virtual void addError(SObject triggerObject, String errorMessage) {
        // is this valid data
        if ( triggerObject != null
             && !string.isBlank(errorMessage)
             ) {
            // validate information coming in for test
            if ( UNIT_TESTING) {
                this.for_testing = errorMessage;
            }

            //try {
            triggerObject.addError(errorMessage);
            //} catch (Exception) {
            // TBD -- ensure it is on a trigger sobject
            //}
        }
    } // end of addError
    /**
     * @description On Before Insert - Override this to perform  processing
     * @param records the current records associated with the event
     **/
    public virtual void onBeforeInsertChild(List<SObject> records) {
        if ( UNIT_TESTING) {
            accc_ApexUtilities.log(OBIC );
        }
    } // end of onBeforeInsertChild
    /**
     * @description on Before Update - Override this to perform  processing
     * @param records the current records associated with the event
     * @param existingRecords the old records associated with the event
     **/
    public virtual void onBeforeUpdateChild(List<SObject> records, Map<Id, SObject> existingRecords) {
        if ( UNIT_TESTING) {
            accc_ApexUtilities.log(OBUC );
        }
    }// end of onBeforeUpdateChild
    /**
     * @description On After Insert - Override this to perform  processing
     * @param records the current records associated with the event
     **/
    public virtual void onAfterInsertChild(List<SObject> records) {
        if ( UNIT_TESTING) {
            accc_ApexUtilities.log(OAIC );
        }
    }// end of onAfterInsertChild
    /**
     * @description On After Update - Override this to perform  processing
     * @param records the current records associated with the event
     * @param existingRecords the old records associated with the event
     **/
    public virtual void onAfterUpdateChild(List<SObject> records, Map<Id, SObject> existingRecords) {
        if ( UNIT_TESTING) {
            accc_ApexUtilities.log(OAUC );
        }
    }// end of onAfterUpdateChild
    /**
     * @description On Before Delete - Override this to perform  processing
     * @param records the current records associated with the event
     *
     **/
    public virtual void onBeforeDeleteChild(List<SObject> records) {
        if ( UNIT_TESTING) {
            accc_ApexUtilities.log(OBDC );
        }
    }// end of onBeforeDeleteChild
    /**
     * @description On After Delete - Override this to perform  processing
     * @param records the current records associated with the event
     *
     **/
    public virtual void onAfterDeleteChild(List<SObject> records) {
        if ( UNIT_TESTING) {
            accc_ApexUtilities.log(OADC );
        }
    }// end of onAfterDeleteChild
    /**
     * @description On After Undelete - Override this to perform  processing
     * @param records the current records associated with the event
     **/
    public virtual void onAfterUndeleteChild(List<SObject> records) {
        if ( UNIT_TESTING) {
            accc_ApexUtilities.log(OAUDC );
        }
    } // end of onAfterUndeleteChild

} // end of accc_TriggerHandlerBase