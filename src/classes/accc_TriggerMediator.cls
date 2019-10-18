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
 * @description This calls is the Trigger Mediator. It is responsible for managing the
 * underlying trigger handling functionality.
 *
 * Below is an example of how to use this class:
 *
        static accc_TriggerMediator triggerMediator = new accc_TriggerMediator(Account.class);
        //
        // :
        //
        // invoke trigger handlers related to the BeforeDelete ( this is just one example)
        Boolean result = triggerMediator.execute(accc_TriggerHelperClass.TriggerState.BeforeDelete);
        // returns true if successful; false if an exception occurs and not handled
        //

        // Also, look in the Unit Test - 'accc_TriggerMediatorTest' for more information

 * @group Common Layer
 **/
public virtual without sharing class accc_TriggerMediator {
    //==============================================================
    // Data members
    //==============================================================
    @TestVisible
    private static final String EXCEPTION_ON_BAD_HANDLER_CHAIN = ' had a bad handler in chain ';
    @TestVisible
    static final String USED_FOR_EXCEPTION_MSG = 'Testing accc_TriggerMediator';

    /*
     * Current new Records
     */
    @TestVisible
    private List<SObject> mRecords=null;
    /*
     * changed records
     */
    @TestVisible
    private Map<Id, SObject> mExistingRecords=null;

    /*
     * Holds the trigger handler mechanism
     */
    @TestVisible
    static accc_TriggerHandlerChainManager mTriggerManager = null;
    /*
     * The Trigger Handler Chain
     */
    @TestVisible
    static Map<String, accc_IHandlerChain> mTriggerChain = new Map<String, accc_IHandlerChain>();
    /*
     * Used for Testing
     */
    @TestVisible
    static Boolean mCauseException = false;
    //==============================================================
    // Ctors
    //==============================================================
    /**
     * @description ctor (will determine the environment)
     * @param Type sobjectType type of sobject
     */
    public accc_TriggerMediator(Type sobjectType) {
        this(sobjectType,accc_ApexEnvironment.getEnvironment(),Trigger.New, Trigger.OldMap);
    }// end of ctor
     /**
      * @description ctor (will determine the environment)
      * @param Type sobjectType type of sobject
      * Param String the environment (test,debug,production)
      */
    public accc_TriggerMediator(Type sobjectType, String environment) {
        this(sobjectType,environment,Trigger.New, Trigger.OldMap);
    }// end of ctor
    /**
     * @description ctor (will determine the environment)
     * @param Type sobjectType type of sobject
     * @param theRecords the new Records
     */
    public accc_TriggerMediator(Type sobjectType, List<SObject> theRecords) {
        this(sobjectType,accc_ApexEnvironment.getEnvironment(),theRecords, Trigger.OldMap);
    }// end of ctor
    /**
     * @description ctor (will determine the environment)
     * @param Type sobjectType type of sobject
     * @param theRecords the existing Records
     */
    public accc_TriggerMediator(Type sobjectType,Map<Id, SObject> existingRecords) {
        this(sobjectType,accc_ApexEnvironment.getEnvironment(),Trigger.New, existingRecords);
    }// end of ctor
    /**
     * @description ctor (will determine the environment)
     * @param Type sobjectType type of sobject
     * @param theRecords the new Records
     * params existingRecords the existing Records
     */
    public accc_TriggerMediator(Type sobjectType,
                                List<Sobject> theRecords,
                                Map<Id, SObject> existingRecords) {
        this(sobjectType,accc_ApexEnvironment.getEnvironment(),theRecords, existingRecords);
    }// end of ctor
    /**
     * @description ctor
     * @param Type sobjectType type of sobject
     * @param String the environment (test, debug, production)
     */
    public accc_TriggerMediator(Type sobjectType,
                                String environment,
                                List<Sobject> theRecords,
                                Map<Id, SObject> existing) {

        if ( sobjectType == null ) {
            throw new accc_ApexApplicationException('Null Type passed to accc_TriggerMediator');
        }
        if ( string.isBlank(environment)) {
            environment = accc_ApexEnvironment.getEnvironment();
        }
        this.triggerType = sobjectType;
        this.theEnvironment = environment;
        this.records = theRecords;
        this.existingRecords = existing;
    }// end of ctor

    //==============================================================
    // Properties
    //==============================================================
    /*
     * Type of SObject (getter/setter)
     */
    @TestVisible
    public Type triggerType {
        get;
        protected set;
    }// end of triggerType

    /*
     * The environment (test,debug, production)
     * (getter/setter)
     */
    @TestVisible
    public String theEnvironment {
        get;
        private set;
    }// end of theEnvironment
    /*
     * The new records
     * (getter/setter)
     */
    public List<SObject> records {
        get {
            if ( this.mRecords == null) {
                this.mRecords = Trigger.New;
            }
            return this.mRecords;
        }
        protected set {
            this.mRecords = value;
        }
    }// end of records

    /*
     * The old records
     * (getter/setter)
     */
    public Map<Id,SObject> existingRecords {
        get {
            if ( this.mExistingRecords == null) {
                this.mExistingRecords = Trigger.OldMap;
            }
            return this.mExistingRecords;
        }
        protected set {
            this.mExistingRecords = value;
        }
    }// end of existingRecords
     //==============================================================
     // Public Methods
     //==============================================================

    /**
     * @description invoke the trigger handler (chain)
     * @param accc_TriggerHelperClass.TriggerState state , Before/After
     * @return Boolean
     */
    public Boolean execute(accc_TriggerHelperClass.TriggerState state){
        // invoke trigger handlers
        return this.triggerHandlerInvocation(this.theTriggerChain(),
                                             state,
                                             this.existingRecords,
                                             this.theTriggerManager().continueIfException,
                                             this.theTriggerManager().performanceMetrics
                                             );
    }// end of execute
     /**
      * @brief Trigger Manager
      * @description Trigger Manager
      * @return return the trigger manager based on environment (test, debug, ...)
      */
    public accc_TriggerHandlerChainManager theTriggerManager() {
        // act as a singleton, getting when needed
        if ( accc_TriggerMediator.mTriggerManager == null ) {
            // if we are in test mode, make sure the trigger handler uses Test
            accc_TriggerMediator.mTriggerManager = new accc_TriggerHandlerChainManager(this.theEnvironment);
        }

        return accc_TriggerMediator.mTriggerManager;
    } // end of theTriggerManager

    /**
     * @brief Trigger Handler
     * @description Trigger Handler Chain based on the Domain
     * @return return the chain based on the domain; we already have a manager in the right environment
     */
    public accc_IHandlerChain theTriggerChain() {
        accc_IHandlerChain chain=null;

        String typeName = this.triggerType.getName();
        // check cached value
        chain = accc_TriggerMediator.mTriggerChain.get(typeName);
        // if not in cache, get it then add
        if ( chain == null ) {
            chain = this.theTriggerManager().createHandlerChainByDomain(typeName);
            // add to cache
            if ( chain != null ) {
                accc_TriggerMediator.mTriggerChain.put(typeName, chain);
            }
        }
        // informational regarding chain ( means, type not found in the metadata)
        if ( chain == null ) {
            accc_ApexUtilities.log('Warning: Unable to find chain for type ( ' + typeName +' )');
        }
        return chain;
    } // end of theTriggerChain
    //==============================================================
    // Protected Methods
    //==============================================================
    /**
     * @description Call the trigger handlers in the chain
     * @details Call the trigger handlers in the chain
     *
     * @param chain the trigger handler chain
     * @param state which trigger event
     * @param existingRecords existing records, if any
     * @param continueIfException continue if trigger handler exception
     */
    @TestVisible
    protected virtual Boolean triggerHandlerInvocation(accc_IHandlerChain chain,
                                                       accc_TriggerHelperClass.TriggerState state,
                                                       Map<Id, SObject> existingRecords,
                                                       Boolean continueIfException,
                                                       Boolean performanceMetrics ) {
        Boolean status=false;

        // was a chain found ( we do not log information as it is done elsewhere)
        if ( chain != null ) {
            // invoke
            status= this.triggerHandlerInvocation(chain,
                                                  state,
                                                  existingRecords,
                                                  continueIfException,
                                                  performanceMetrics,
                                                  EXCEPTION_ON_BAD_HANDLER_CHAIN);
        }
        return status;
    } // end of triggerHandlerInvocation

    /**
     * @description Call the trigger handlers based on which event state ( before/after)
     * **** NEEDS REFACTORING
     *
     * @param chain the trigger handler chain chain
     * @param state which trigger event
     * @param existingRecords existing records, if any
     * @param continueIfException continue if trigger handler exception
     * @param performanceMetrics getting performance metrics for each handler
     * @param exceptionMessage exception message if trigger handler chain not created
     */
    @TestVisible
    protected virtual Boolean triggerHandlerInvocation(accc_IHandlerChain chain,
                                                       accc_TriggerHelperClass.TriggerState state,
                                                       Map<Id, SObject> existingRecords,
                                                       Boolean continueIfException,
                                                       Boolean performanceMetrics,
                                                       String exceptionMessage) {

        Boolean successful = false;
        string excpMsg = string.isBlank(exceptionMessage) ? EXCEPTION_ON_BAD_HANDLER_CHAIN : exceptionMessage;
        Exception hasException = null;
        accc_ITriggerHandler handler = null;

        // iterate over the chain of trigger handlers
        while ( chain != null ) {
            // get our current handler
            handler = (accc_ITriggerHandler) chain.getHandler();
            // if the trigger handler was valid (of type accc_ITriggerHandler ) continue
            if ( handler != null ) {
                // we have a handler, then true, this resets
                // the state as the user sets 'continueIfException' to true
                successful = true;
                // call the handler in the chain, return the exception, if any
                hasException = this.callHandler(handler, state, existingRecords, performanceMetrics);
                // set our state
                successful= hasException == null;
                // set internal handler's  resource state ( handlers in the following chain can determine state better, if continuing)
                // as the handler that follows (should we continue) can determine corrective measures
                handler.handlerResources().add(accc_TriggerHandlerResources.EXCEPTION_KEY,
                                               hasException);
                // do we continue after an exception
                if ( !successful && !continueIfException ) {
                    return successful;
                }

            } else {
                // we have no handler
                successful = false;
                // our handler was bad ( probably inherited from the wrong type or
                // incorrectly entered by name ). This is why we TEST
                accc_ApexUtilities.log(excpMsg + '-' + chain);
                // we DO NOT break at this point (as someone may have put in a bad handler name)
            }// end if handler
            // get the next trigger handler in the chain
            chain = chain.getNext();

        }// end while

        return successful;
    }// end of triggerHandlerInvocation
    /**
     * @description we have a trigger handler; invoke the operation
     *
     * @param state which trigger event
     * @param existingRecords existing records, if any
     * @param continueIfException continue if trigger handler exception
     * @param performanceMetrics getting performance metrics for each handler
     * @return Exception, if any from the handler
     */
    protected virtual Exception callHandler( accc_ITriggerHandler handler,
                                             accc_TriggerHelperClass.TriggerState state,
                                             Map<Id, SObject> existingRecords,
                                             Boolean performanceMetrics) {
        String className = accc_StringUtilities.getClassName(handler);
        accc_ApexPerformanceMetrics metrics = performanceMetrics ? new accc_ApexPerformanceMetrics('Start :' + className) : null;
        Exception handlerException = null;

        // log start of our handler's performance
        if ( performanceMetrics) {
            accc_ApexUtilities.log(metrics.toString());
        }
        //
        // Here we check which trigger event to perform; if we get an exception
        // we check the continue-if-exception flag to determine whether to log and
        // continue or log and break
        //
        try {

            if ( state == accc_TriggerHelperClass.TriggerState.BeforeInsert ) {
                handler.onBeforeInsertChild(this.records);
            } else if ( state == accc_TriggerHelperClass.TriggerState.BeforeUpdate ) {
                handler.onBeforeUpdateChild(this.records, existingRecords);
            } else if ( state == accc_TriggerHelperClass.TriggerState.BeforeDelete ) {
                handler.onBeforeDeleteChild(this.records);
            } else if ( state == accc_TriggerHelperClass.TriggerState.AfterInsert ) {
                handler.onAfterInsertChild(this.records);
            } else if ( state == accc_TriggerHelperClass.TriggerState.AfterUpdate ) {
                handler.onAfterUpdateChild(this.records, existingRecords);
            } else if ( state == accc_TriggerHelperClass.TriggerState.AfterDelete ) {
                handler.onAfterDeleteChild(this.records);
            } else if ( state == accc_TriggerHelperClass.TriggerState.AfterUndelete ) {
                handler.onAfterUndeleteChild(this.records);
            }

            // ***************** START use for testing
            if ( accc_TriggerMediator.mCauseException == true ) {
                throw new accc_ApexApplicationException(USED_FOR_EXCEPTION_MSG);
            }
            // ***************** END use for testing
        } catch (Exception excp) {
            handlerException = excp;
            // log exception
            accc_ApexUtilities.log(excp.getMessage()
                                   + ', '
                                   + '\nTrigger Handler:' + handler
                                   + ', '
                                   + 'Trigger State:' + state );
        } finally {
            // log the end of the handlers' performance
            if ( performanceMetrics) {
                metrics.message ='End :' +className;
                accc_ApexUtilities.log(metrics.toString());
            }
        }
        return handlerException;
    } // end of callHandler

} // end of accc_TriggerMediatortriggerMediator