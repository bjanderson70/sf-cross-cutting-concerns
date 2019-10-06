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
 * @description define the concrete implementation of the core platform event model
 * @group Common Layer
 */
public virtual without sharing class accc_DefaultPlatformEventModel implements accc_IPlatformEventModel {

    ////////////////////////////////////////////////////////////////////////
    // Data Members
    /////////////////////////////////////////////////////////////////////////

    // any exception that may occur
    @TestVisible
    Exception m_exception = null;
    // either a consumer or publisher
    @TestVisible
    accc_IEventHandler m_eventHandler = null;
    // attributes associated with platform events
    @TestVisible
    accc_PlatformEventAttrs m_attributes = null;
    // process handlers ( error, success and log handlers)
    @TestVisible
    accc_IProcessEventHandlers m_processHandlers = null;

    ////////////////////////////////////////////////////////////////////////
    // Ctors
    /////////////////////////////////////////////////////////////////////////

    /**
     * @description default ctor -- defines the based platform event model
     *
     */
    public accc_DefaultPlatformEventModel() {
        this(null, null, null);
    } // end of ctor
    /**
     * @description define the pub-sub handler, the handlers to provide hooks and attributes to control behaviour
     *
     * @param thePublisherConsumer the event handler
     * @param handlers the handlers (log,success, error, alert)
     * @param attributes attributes from platform events
     */
    public accc_DefaultPlatformEventModel(accc_IEventHandler thePublisherConsumer
                                          , accc_IProcessEventHandlers handlers
                                          , accc_PlatformEventAttrs attributes) {
        this.m_eventHandler = thePublisherConsumer;
        this.m_processHandlers = handlers;
        this.m_attributes = attributes;

        // define default attributes
        if ( this.m_attributes == null ) {
            this.m_attributes = new accc_PlatformEventAttrs();
        }
        // define default handlers
        if ( this.m_processHandlers == null ) {
            this.m_processHandlers = new accc_DefaultProcessEventHandlers();
        }
        // define default event handler (publisher)
        if ( this.m_eventHandler == null ) {
            this.m_eventHandler = new accc_DefaultPEPublisher();
        }

    } // end of ctor

    ////////////////////////////////////////////////////////////////////////
    // Public Methods
    /////////////////////////////////////////////////////////////////////////

    /**
     * @description process the event (publish/subscribe)
     *
     * @param platformEvent the events
     * @return true on process status
     */
    public virtual boolean process(List<SObject> platformEvent) {
        Boolean status = false;

        if ( platformEvent != null && platformEvent.size() > 0) {
            try {
                accc_IEventHandler handler = this.eventHandler();
                if ( handler != null ) {
                    status = handler.process(platformEvent,
                                             this.processHandlers(),
                                             this.attributes() );
                    // bubble exception on false
                    if ( status == false) {
                        this.setException(handler.handlerException());
                    }
                }
            } catch (Exception excp) {
                this.setException (excp);
                // cause a retry of the trigger, if necessary
                // looks to see if the child marked for retry and then throw a RetryException
                this.eventHandler().handlerRequiredRetry();
            }
        }
        return status;
    }// end of process

    /**
     * @description get the event handler (publisher / consumer)
     * @return accc_IEventHandler
     */
    public accc_IEventHandler eventHandler() {
        return this.m_eventHandler;
    }
    /**
     * @description get the handlers (log, success, error, ...)
     * @return accc_IProcessEventHandlers
     */
    public accc_IProcessEventHandlers processHandlers() {
        return this.m_processHandlers;
    }
    /**
     * @description get the attributes
     * @return accc_PlatformEventAttrs
     */
    public accc_PlatformEventAttrs attributes() {
        return this.m_attributes;
    }
    /**
     * @description get the exception
     * @return Exception
     */
    public Exception getException() {
        return this.m_exception;
    }
    ////////////////////////////////////////////////////////////////////////
    // Protected Methods
    /////////////////////////////////////////////////////////////////////////

    /**
     * @description set the exception
     *
     * @param theException the exception
     */
    @TestVisible
    protected void setException(Exception theException) {
        this.m_exception = theException;
    }
} // end of accc_DefaultPlatformEventModel