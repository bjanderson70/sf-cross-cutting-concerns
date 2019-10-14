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
 * @description Encapsulates all behaviour logic relating to the building and managing the
 * trigger handling for the domains
 *
 * For more guidelines and details see
 *   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Domain_Layer
 * @group Common Trigger Layer
 **/
public without sharing class accc_TriggerHandlerChainBuilder {

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Data Members
	//
	/////////////////////////////////////////////////////////////////////////////////////////

	// is the domain used active as marked in the CMDT
	@TestVisible
	boolean m_isActiveDomain = true;
	// is the domain valid
	@TestVisible
	boolean m_validDomainName = false;
	// domain type ( account, lead, affiliation__c, contact, etc.)
	@TestVisible
	string m_domainName = null;
	//  environment (test, debug, prod)
	@TestVisible
	string m_environment = null;
	// collection of custom metadata type
	@TestVisible
	List<accc_TriggerHandlerMetaDataModel.THDataModelInformation> m_elements = null;
	// continue if exception in trigger handler
	@TestVisible
	Boolean m_continueIfException = false;
	// perf metrics trigger handler
	@TestVisible
	Boolean m_performanceMetrics = false;

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Ctors
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @brief create a chain based on the domain name; environment is considerd production
	 * @description create a chain based on the domain name;environment is considerd production
	 *
	 */
	public accc_TriggerHandlerChainBuilder(string theDomainName) {
		// look for domain in the production (custom metadata) environment
		this(theDomainName, accc_ApexConstants.PRODUCTION_CATEGORY);
	} // end of ctor
	/**
	 * @description create a chain based on the domain name and environment
	 *
	 * @param theDomainName the domain name
	 * @param environment environment to look for the domain in the custom metadata
	 *
	 */
	public accc_TriggerHandlerChainBuilder(string theDomainName, string environment) {

		this.domainName = theDomainName;
		// what type of environment (test, debug, prod)? Will ensure correctness
		this.triggerEnvironment = environment;
		// here we go read the custom metadata information
		this.theElements =  ( List<accc_TriggerHandlerMetaDataModel.THDataModelInformation>)(new accc_TriggerHandlerMetaDataModel()).findbyEnvironmentAndDomain(this.m_environment, this.m_domainName);
		// check for later
		this.validDomainName = !string.isBlank(theDomainName) ? accc_ApexUtilities.validDomainName(this.m_domainName) : false;
		// is this domain active
		this.domainActive = this.isDomainActive(this.theElements);
	} // end of ctor

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Public Properties
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description is the domain name valid
	 * @return true, if domain is valid ( i.e. Account, Contact, etc.)
	 */
	@TestVisible
	public Boolean validDomainName {
		get {
			return this.m_validDomainName;
		}
		private set {
			this.m_validDomainName = value;
		}
	} // end of validDomainName

	/**
	 * @description the elements
	 * @return list of elements for the domain and environment
	 */
	@TestVisible
	public List<accc_TriggerHandlerMetaDataModel.THDataModelInformation> theElements {
		get {
			return this.m_elements;
		}
		private set {
			this.m_elements = value;
		}
	} // end of theElements
	/**
	 * @description any data results
	 * @return true, if there is data
	 */
	@TestVisible
	public Boolean anyResults {
		get { return this.m_elements != null && this.m_elements.size() > 0;}
		private set {}
	}// end of anyResults
	/**
	 * @description is the domain active
	 * @return true, if domain is marker active
	 */
	@TestVisible
	public Boolean domainActive {
		get {
			return this.m_isActiveDomain;
		}
		private set {
			this.m_isActiveDomain = value;
		}
	} // end of domainActive
	/**
	 * @description The domain name
	 * @return domain name
	 */
	@TestVisible
	public String domainName {
		get {
			return this.m_domainName;
		}
		private set {
			this.m_domainName = value;
		}
	} // end of domainName
	/**
	 * @description The domain environment
	 * @return trigger environment (test debug, etc.)
	 */
	@TestVisible
	public String triggerEnvironment {
		get {
			return this.m_environment;
		}
		private set {
			String known = accc_ApexEnvironment.getEnvironment(),
			env = string.isBlank(value) ? known : value.toLowerCase().trim();
			if ( !accc_ApexConstants.SUPPORTED_CATEGORY_SET.contains(env)) {
				env = known;
			}
			this.m_environment = env;
		}
	} // end of triggerEnvironment

	/**
	 * @description Continue if an exception on triggler handler
	 * @return true, if we continue thru exceptions in the handler
	 */
	@TestVisible
	public Boolean continueIfException {
		get {
			return this.m_continueIfException;
		}
		private set {
			this.m_continueIfException = value;
		}
	} // end of continueIfException
	//
	/**
	 * @description Continue if an exception on triggler handler
	 * @return true, if we continue thru exceptions in the handler
	 */
	@TestVisible
	public Boolean performanceMetrics {
		get {
			return this.m_performanceMetrics;
		}
		private set {
			this.m_performanceMetrics = value;
		}
	} // end of performanceMetrics
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Public Methods
	//
	/////////////////////////////////////////////////////////////////////////////////////////

	/**
	* @description build the trigger domain model
	*
	* @return the trigger domain model
	*/
	public virtual accc_IHandlerChain build() {

		// we throw an exception if the domain name is not found
		// and the attributes indicate us to throw
		if ( !this.m_validDomainName  ) {
			throw new accc_ApexApplicationException('accc_TriggerHandlerChainBuilder - Error: Domain is not found, check spelling [' + this.m_domainName + ']');
		}

		return  this.buildTriggerEventHandlerChain(this.m_elements, this.domainName);
	} // end of build


	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Private Methods
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description build the trigger handler
	 *
	 * @param elements custom metadata
	 * @param theDomainName the domain object
	 * @return accc_IHandlerChain ( for trigger handler )
	 */
	@TestVisible
	private accc_IHandlerChain buildTriggerEventHandlerChain(List<accc_TriggerHandlerMetaDataModel.THDataModelInformation> elements
	        , String theDomainName) {

		// here is the head
		accc_IHandlerChain result = null;
		// any work
		if ( elements == null || elements.size() == 0 ) {
			return result;
		}

		Boolean lcontinueIfException = true,
		        lperformanceMetrics = false;
		// define the instance we want to create
		accc_ITriggerHandler instance;

		// iterate over the elements

		for ( accc_TriggerHandlerMetaDataModel.THDataModelInformation element : elements) {
			// we work on the domain object that are active
			if ( element.domain == theDomainName &&
			        element.isActive ) {

				// continue on exception for trigger handlers
				lcontinueIfException = element.continueIfException;
				lperformanceMetrics = element.performanceMetrics;
				// we have to reverse the order of the classes bec/
				// when we iterate, we start with the first which will be
				// placed at the end as we traverse the list
				// Note: 'element.classes' is guaranteed to be non-null!!
				List<String> toReverseOrder = new List<String>(element.classes);
				Integer sizeOfList = element.classes.size();
				String theClass = null;

				// iterate over the classes and create the chain
				for ( integer inx = sizeOfList - 1; inx >= 0; inx--) {
					// start with the last
					theClass = toReverseOrder[inx];
					// attempt to create an instance of the class (must have default ctor)
					instance = (accc_ITriggerHandler)accc_ApexUtilities.getClassInstance(theClass);
					// was an instance created
					if ( instance != null ) {
						// get the next item in the chain
						accc_IHandlerChain next = result != null ? result : null;
						result = new accc_VirtualTriggerHandlerChain(instance);
						// we already have part of the chain, add to it
						result.setNext(next);
					}
				}// end for
			} // end if
		}// end for

		// there SHOULD be ONLY one Domain / Environment but we CANNOT assume this will
		// be abided. Thus, we can only set what the LAST value was after the loop.
		this.continueIfException = lcontinueIfException;
		this.performanceMetrics = lperformanceMetrics;

		return result;
	} // end of buildTriggerEventHandlerChain

	/**
	 * @description is the domain active
	 *
	 * @param element data from the custom metadata
	 * @return is the domain active
	 */
	@TestVisible
	private Boolean isDomainActive(List<accc_TriggerHandlerMetaDataModel.THDataModelInformation> elements) {
		Boolean isActive = true;

		// valid domain and elements to process
		if ( !this.validDomainName || !this.anyResults ) {
			return false;
		}
		// The assumption is that there is ONLY one element / object (domain)
		// This SHOULD be true for manageability. In addition, there is
		// enough space to add Trigger Handlers and control order
		//
		// iterate over the values, once we find inactive; we break
		// may need to revisit; is this all-or-nothing scenario ??
		//
		for ( accc_TriggerHandlerMetaDataModel.THDataModelInformation element : elements) {
			if ( !element.isActive) {
				isActive = false;
				break;
			}
		}

		return isActive;
	} // end of isDomainActive
} // end of accc_TriggerHandlerChainBuilder