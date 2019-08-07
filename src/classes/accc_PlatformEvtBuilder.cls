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
 * @description platform event publisher/consumer builder
 * NOTE: This class does too much -- refactor!
 * @group Common Layer
 */

public without sharing class accc_PlatformEvtBuilder {


	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Data Members
	//
	/////////////////////////////////////////////////////////////////////////////////////////

	@TestVisible
	enum PubSubType { CONSUMER, PUBLISHER}
	@TestVisible
	boolean m_isActiveEvent = true;
	@TestVisible
	boolean m_isBadEventName = false;
	@TestVisible
	string m_eventName = null;
	@TestVisible
	string m_environment = null;
	@TestVisible
	List<accc_PlatformEvtMdtDataModel.PEDataModelInformation> m_elements = null;

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Ctors
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @brief ctor
	 * @description ctor
	 *
	 */
	public accc_PlatformEvtBuilder(string theEventName) {
		// look for event in the production (custom metadata) environment
		this(theEventName, accc_ApexConstants.PRODUCTION_CATEGORY);
	} // end of ctor
	/**
	 * @description ctor
	 *
	 * @param theEventName the event name
	 * @param enviroment environment to look for the event in the custom metadata
	 *
	 */
	public accc_PlatformEvtBuilder(string theEventName, string enviroment) {

		this.eventName = theEventName;
		// what type of environment (test, debug, prod)?
		this.eventEnvironment = accc_ApexEnvironment.ensureEnviromentIsCorrectOtherwiseDebug(enviroment);
		// here we go read the custom metadata information
		this.m_elements =  (new accc_PlatformEvtMdtDataModel()).findByEnvironmentAndLabel(this.m_environment, this.m_eventName);
		// check for later
		this.validEventName = accc_ApexUtilities.validEventName(this.m_eventName) == false;
		// is this event active
		this.eventActive = accc_PlatformEvtBuilder.isEventActive(this.m_elements);
	} // end of ctor

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Public Properties
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * is the event name valid
	 */
	public Boolean validEventName {
		get { return this.m_isBadEventName;}
		private set { this.m_isBadEventName = value;}
	} // end of validEventName
	/**
	 * is the event active
	 */
	public Boolean eventActive {
		get { return this.m_isActiveEvent;}
		private set {this.m_isActiveEvent = value;}
	} // end of eventActive
	/**
	 * The event name
	 */
	public String eventName {
		get { return this.m_eventName;}
		private set { this.m_eventName = value;}
	} // end of eventName
	/**
	 * The event environment
	 */
	public String eventEnvironment {
		get { return this.m_environment;}
		private set { this.m_environment = value;}
	} // end of eventEnvironment
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Public Methods
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	* @description build the event consumer
	*
	* @return the event consumer
	*/
	public virtual accc_IEventHandler buildConsumer() {
		// build pub/sub handlers
		return  accc_PlatformEvtBuilder.buildEventHandler(this.m_elements, null, this.m_eventName, PubSubType.CONSUMER);
	}
	/**
	* @description build the event publisher
	*
	* @return the event publisher
	*/
	public virtual accc_IEventHandler buildPublisher() {
		// build pub/sub handlers
		return  accc_PlatformEvtBuilder.buildEventHandler(this.m_elements, null, this.m_eventName, PubSubType.PUBLISHER);
	}
	/**
	* @description build the event model
	*
	* @return the event model
	*/
	public virtual accc_IPlatformEventModel build() {
		return this.build(null, null, null);
	}
	/**
	 * @description build the event model
	 *
	 * @param attributes attributes controlling behavior
	 * @return the event model
	 */
	public virtual accc_IPlatformEventModel build(accc_PlatformEventAttrs attributes) {
		return this.build(null, null, attributes);
	}
	/**
	* @description build the event model
	*
	* @param thePublisherConsumer publisher or consumer
	* @return the event model
	*/
	public virtual accc_IPlatformEventModel build(accc_IEventHandler thePublisherConsumer) {
		return this.build(thePublisherConsumer, null, null);
	}
	/**
	* @description build the event model
	*
	* @param thePublisherConsumer publisher or consumer
	* @param attributes attributes controlling behavior
	* @return the event model
	*/
	public virtual accc_IPlatformEventModel build(accc_IEventHandler thePublisherConsumer, accc_PlatformEventAttrs attributes) {
		return this.build(thePublisherConsumer, null, attributes);
	}
	/**
	 * @description build the event model
	 *
	 * @param thePublisherConsumer publisher or consumer
	 * @param handlers the log, success, error, alert handlers
	 * @param attributes attributes controlling behavior
	 * @return the event model
	 */
	public virtual accc_IPlatformEventModel build(accc_IEventHandler thePublisherConsumer, accc_IProcessEventHandlers handlers, accc_PlatformEventAttrs attributes) {

		accc_PlatformEventAttrs l_attributes = attributes == null ? new accc_PlatformEventAttrs() : attributes;
		// build pub/sub handlers
		accc_IEventHandler pubsub = accc_PlatformEvtBuilder.buildEventHandler(this.m_elements, thePublisherConsumer, this.m_eventName, PubSubType.PUBLISHER);
		// build handlers
		accc_IProcessEventHandlers myHandlers = accc_PlatformEvtBuilder.buildProcessHandlers(this.m_elements, handlers);

		// we throw an exception if the event name is not found
		// and the attributes indicate us to throw
		if ( this.validEventName  && l_attributes.checkEvent() ) {
			throw new accc_PlatformEventException('accc_PlatformEvtBuilder - Error: Platform Event is not found, check spelling [' + this.m_eventName + ']');
		}

		return new accc_DefaultPlatformEventModel(pubsub, myHandlers, l_attributes);
	} // end of build


	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Private Methods
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description build the event handler (consumer / publisher )
	 *
	 * @param elements custom metadata
	 * @param thePublisherConsumer the publisher or consumer, if known; otherwise will create default publisher
	 * @param psType Type of event handler ( publisher or consumer )
	 * @return accc_IEventHandler ( publisher or consumer )
	 */
	@TestVisible
	static accc_IEventHandler buildEventHandler(List<accc_PlatformEvtMdtDataModel.PEDataModelInformation> elements
	        , accc_IEventHandler thePublisherConsumer
	        , String theEventName
	        , PubSubType psType) {

		accc_IEventHandler result = thePublisherConsumer;
		accc_PlatformEvtMdtDataModel.PEDataModelInformation element = elements != null && elements.size() > 0 ? elements[0] : null;
		if ( result == null ) {
			if ( element != null ) {
				String index = accc_PlatformEvtBuilder.getEventHandlerValue(element, psType);
				result = accc_PlatformEvtBuilder.createEventHandler(index, theEventName, element.serializeEvent);
			}
		}


		return result;
	} // end of buildEventHandler

	/**
	 * @description  build the process container, look at user input, and then look at custom metadata, if needed
	 *
	 * @param elements custom metadata holder of known handlers
	 * @param handlers user passed in handlers
	 *
	 * @return instance of a process handler container
	 */
	@TestVisible
	static accc_IProcessEventHandlers buildProcessHandlers(List<accc_PlatformEvtMdtDataModel.PEDataModelInformation> elements
	        , accc_IProcessEventHandlers handlers) {

		accc_PlatformEvtMdtDataModel.PEDataModelInformation element = elements != null && elements.size() > 0 ? elements[0] : null;
		accc_IProcessEventHandlers result = handlers;
		// no handlers, use the defaults
		if ( result == null ) {
			result = accc_PlatformEvtBuilder.createProcessHandlers(element);
		}
		return result;
	} // end of buildProcessHandlers

	/**
	 * @description create the process handlers container
	 *
	 * @param elements custom metadata of the handlers
	 * @return instance of a process handlers container
	 */
	@TestVisible
	static accc_IProcessEventHandlers createProcessHandlers(accc_PlatformEvtMdtDataModel.PEDataModelInformation elements) {

		Map<String, accc_IProcessEventHandler> instances = new Map<String, accc_IProcessEventHandler>  {
			// success handler
			accc_DefaultProcessHandler.DEFAULT_SUCCESS_NAME => accc_PlatformEvtBuilder.createProcessHandler(elements == null ? null : elements.successHandlerClass
			,accc_DefaultProcessHandler.DEFAULT_SUCCESS_NAME)
			// Log handler
			, accc_DefaultProcessHandler.DEFAULT_LOG_NAME => accc_PlatformEvtBuilder.createProcessHandler(elements == null ? null : elements.logHandlerClass
			, accc_DefaultProcessHandler.DEFAULT_LOG_NAME)
			// Error Handler
			, accc_DefaultProcessHandler.DEFAULT_ERROR_NAME => accc_PlatformEvtBuilder.createProcessHandler(elements == null ? null : elements.errorHandlerClass
			, accc_DefaultProcessHandler.DEFAULT_ERROR_NAME)
			// Alert Handler
			, accc_DefaultProcessHandler.DEFAULT_ALERT_NAME  => accc_PlatformEvtBuilder.createProcessHandler(elements == null ? null : elements.alertHandlerClass
			, accc_DefaultProcessHandler.DEFAULT_ALERT_NAME )
			// Store Handler
			, accc_DefaultProcessHandler.DEFAULT_STORE_NAME => accc_PlatformEvtBuilder.createProcessHandler(elements == null ? null : elements.storeHandlerClass
			, accc_DefaultProcessHandler.DEFAULT_STORE_NAME )
		};
		// default handlers
		return new accc_DefaultProcessEventHandlers(
		           instances.get(accc_DefaultProcessHandler.DEFAULT_LOG_NAME)
		           , instances.get(accc_DefaultProcessHandler.DEFAULT_ERROR_NAME)
		           , instances.get(accc_DefaultProcessHandler.DEFAULT_SUCCESS_NAME)
		           , instances.get(accc_DefaultProcessHandler.DEFAULT_ALERT_NAME)
		           , instances.get(accc_DefaultProcessHandler.DEFAULT_STORE_NAME )
		       );

	} // end of createProcessHandlers
	/**
	* @description create the process handler from the FQDN (the default is a publisher)
	*
	* @param fqdn fully qualified domain name
	* @param theEventName the event name
	* @param serializeEvent serialize the event
	*
	* @return instance of a event handler (i.e. publisher or consumer)
	*/
	@TestVisible
	static accc_IEventHandler createEventHandler(string fqdn, String theEventName, Boolean serializeEvent) {
		accc_IEventHandler result = (accc_IEventHandler) accc_ApexUtilities.getClassInstance(fqdn);

		if ( result != null ) {
			result.handlerEventName(theEventName);
			result.handlerToSerialize(serializeEvent);
		}
		return result == null ? new accc_DefaultPEPublisher(theEventName , serializeEvent)  : result;
	}// end of createEventHandler
	/**
	 * @description create the process handler from the FQDN
	 *
	 * @param fqdn fully qualified domain name
	 * @param defaultIndex name index into known process handlers
	 *
	 * @return instance of a process handler
	 */
	@TestVisible
	static accc_IProcessEventHandler createProcessHandler(string fqdn, string defaultIndex) {
		accc_IProcessEventHandler result = (accc_IProcessEventHandler) accc_ApexUtilities.getClassInstance(fqdn);
		if ( result != null ) {
			result.handlerName(defaultIndex);
		}
		return result == null ? accc_DefaultProcessEventHandlers.defaultHandlerByName(defaultIndex) : result;
	} // end of createProcessHandler

	/**

	 * @description get the event handler name
	 *
	 * @param element data from the custom metadata
	 * @param psType enumeration, publisher or consumer
	 * @return name of the class instance
	 */
	@TestVisible
	static string getEventHandlerValue(accc_PlatformEvtMdtDataModel.PEDataModelInformation element
	                                   , PubSubType psType) {

		String name = null;

		if ( psType == PubSubType.PUBLISHER) {
			name = element == null ? accc_ApexConstants.DEFAULT_PUBLISHER_NAME : element.publisherClass;
		} else {
			name = element == null ? accc_ApexConstants.DEFAULT_CONSUMER_NAME : element.consumerClass;
		}

		return name;
	} // end of getEventHandlerValue
	/**
	 * @description is the event active (ONLY checking the first one!!)
	 *
	 * @param element data from the custom metadata
	 * @return is the event active
	 */
	@TestVisible
	static Boolean isEventActive(List<accc_PlatformEvtMdtDataModel.PEDataModelInformation> elements) {
		Boolean isActive = true;
		accc_PlatformEvtMdtDataModel.PEDataModelInformation element = elements != null && elements.size() > 0 ? elements[0] : null;

		if ( element != null) {
			isActive = element.isActive;
		}

		return isActive;
	} // end of isEventActive

} // end of accc_PlatformEvtBuilder