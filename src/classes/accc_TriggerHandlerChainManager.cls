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
 * @description Encapsulates all behaviour logic relating to the managing the trigger handler chains
 * Will attempt to cache information.
 *
 * The manager is best used in a base domain class which overrides the trigger events (before/after).
 * Then all that is needed it to have all your trigger handlers inherit from accc_TriggerHandlerBase,
 * overriding appropriate trigger events and updating the custom metadata entry.
 *
 * The base domain class can then regulate the trigger events. Bec/ the base domain class will be the
 * receiver of the trigger events, it can then invoke this manager to execute the chain of trigger events.
 * For example,
 *
 *
 *     // Override this to perform child processing
 *
 *	 public virtual void onBeforeDeleteChild() {
 *	     // use the this manager to get the chain, i.e. 'createHandlerChainByDomain'
 *	     // the method 'theTriggerChain' is just a wrapper to perform caching of chain
 *       accc_IHandlerChain chain = this.theTriggerChain();
 *
 *		// invoke trigger handlers -- this methods, looks at the state and iterates over the 'chain'
 *		this.triggerHandlerInvocation(chain,
 *		                              accc_TriggerHelperClass.TriggerState.BeforeDelete,
 *		                              null,
 *		                              this.theTriggerManager().continueIfException
 *		                             );
 *   } // end of onBeforeDeleteChild
 *
 *   The method, 'triggerHandlerInvocation' performs the following task ...
 *
 *       :
 *       :
 *   if ( chain != null ) {
 *			accc_ITriggerHandler handler = null;
 *			// iterate over the chain of trigger handlers
 *			while ( chain != null ) {
 *				// get our current handler
 *				handler = (accc_ITriggerHandler) chain.getHandler();
 *				// if the trigger handler was valid (of type accc_ITriggerHandler ) continue
 *				if ( handler != null ) {
 *					//
 *					// Here we check which trigger event to perform; if get an exception
 *					// we check the continue-if-exception flag to determine whether to log and
 *					// continue or log and break
 *					//
 *					try {
 *						if ( state == accc_TriggerHelperClass.TriggerState.BeforeInsert ) {
 *							handler.onBeforeInsertChild(this.Records);
 *						} else if ( state == accc_TriggerHelperClass.TriggerState.BeforeUpdate ) {
 *							handler.onBeforeUpdateChild(this.Records, existingRecords);
 *						} else if ( state == accc_TriggerHelperClass.TriggerState.BeforeDelete ) {
 *							handler.onBeforeDeleteChild(this.Records);
 *						} else if ( state == accc_TriggerHelperClass.TriggerState.AfterInsert ) {
 *							handler.onAfterInsertChild(this.Records);
 *						} else if ( state == accc_TriggerHelperClass.TriggerState.AfterUpdate ) {
 *							handler.onAfterUpdateChild(this.Records, existingRecords);
 *						} else if ( state == accc_TriggerHelperClass.TriggerState.AfterDelete ) {
 *							handler.onAfterDeleteChild(this.Records);
 *						} else if ( state == accc_TriggerHelperClass.TriggerState.AfterUndelete ) {
 *							handler.onAfterUndeleteChild(this.Records);
 *						}
 *					} catch (Exception excp) {
 *						accc_ApexUtilities.log(excp.getMessage() + ', Exception Msg:' + excpMsg + ', Trigger Handler:' + handler + ', Trigger State:' + state );
 *						// do we continue or just get out
 *						if ( !continueIfException ) {
 *							return;
 *						}
 *					}
 *				} else {
 *					// our handler was bad ( probably inherited from the wrong type or
 *					// incorrectly entered by name )
 *					accc_ApexUtilities.log(excpMsg + chain);
 *				}// end if handler
 *				// get the next trigger handler in the chain
 *				chain = chain.getNext();
 *
 *			} // end while
 *     } // end if 'chain'
 *
 *       :
 *       :
 *
 * For more guidelines and details see
 *   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Domain_Layer
 * @group Common Trigger Layer
 **/
public with sharing class accc_TriggerHandlerChainManager {
	////////////////////////////////////////////////////////////////////////////////
	/// Data Members
	////////////////////////////////////////////////////////////////////////////////

	// our environment ( test, debug, prod)
	@TestVisible
	final string m_environment;
	// used for testing exception
	@TestVisible
	Boolean m_causeException = false;

	// contains the handlers (chained) indexed by domain
	@TestVisible
	static final Map<String, accc_IHandlerChain> m_domainChain = new Map<String, accc_IHandlerChain>();

	////////////////////////////////////////////////////////////////////////////////
	/// ctors
	////////////////////////////////////////////////////////////////////////////////

	/**
	 * @brief ctor
	 * @description ctor
	 *
	 * @param environment is this test, debug or production
	 */
	public accc_TriggerHandlerChainManager(string environment) {
		// what type of environment (test, debug, prod)?
		this.m_environment = environment;
		this.continueIfException = true;
		// default is performance is off
		this.performanceMetrics = false;
		this.buildException = null;

	} // end of ctor
	////////////////////////////////////////////////////////////////////////////////
	/// Properties
	////////////////////////////////////////////////////////////////////////////////

	/**
	 * The domain environment
	 */
	public String triggerEnvironment {
		get { return this.m_environment;}
	} // end of triggerEnvironment

	/**
	 * @description Continue if an exception on triggler handler (default to true)
	 */
	@TestVisible
	public Boolean continueIfException { get; private set;}
	/**
	 * @description  gathering performance metric for the handler
	 */
	@TestVisible
	public Boolean performanceMetrics  { get; private set;}
	/**
	 * Did we get a build exception
	 */
	@TestVisible
	public Exception buildException { get; private set;}

	////////////////////////////////////////////////////////////////////////////////
	/// Public Methods
	////////////////////////////////////////////////////////////////////////////////

	/**
	 * @description create a trigger chain handler by domain
	 *
	 * @param theDomainName required domain name ( i.e. Account, Lead, Contact, etc.)
	 * @return return the trigger chain
	 */
	public  accc_IHandlerChain createHandlerChainByDomain(String theDomainName) {
		// check to see if it is cached
		accc_IHandlerChain chain = accc_TriggerHandlerChainManager.cache(theDomainName);
		// did we find the chain in cache, if not build and add
		if ( chain == null
		        && !string.isBlank(theDomainName) ) {

			try {
				// *************** [START] used for testing *****************
				if ( System.Test.IsRunningTest() ) {
					// did we invoke an exception
					if ( this.m_causeException ) {
						throw new accc_ApexApplicationException('Test Caused Exception');
					}
				}
				// *************** [END] used for testing *******************

				// the builder ensures a Good Environment (test, debug or prod)
				accc_TriggerHandlerChainBuilder builder = new accc_TriggerHandlerChainBuilder(theDomainName, this.triggerEnvironment);

				// build chain based on domain and environment
				chain = builder.build();
				// validate chain
				if ( chain != null ) {
					// cache for later
					accc_TriggerHandlerChainManager.cache(theDomainName, chain);
					// set value after build
					this.continueIfException = builder.continueIfException;
					// gathering metrics
					this.performanceMetrics = builder.performanceMetrics;
				} else {
					// the default it is true
					this.continueIfException = false;
				}
			} catch (Exception excp) {
				chain = null;
				// the default it is true
				this.continueIfException = false;
				// keep exception for caller reference
				this.buildException = excp;
				// process exception -- whatever is configured for process
				accc_ApexEnvironment.getRuntimeEnvironment().exceptionHandler().process(excp, true);
			}
		}
		return chain;
	}// end of createHandlerChainByDomain
	////////////////////////////////////////////////////////////////////////////////
	/// Private Methods
	////////////////////////////////////////////////////////////////////////////////

	/**
	 * @description see if we have already done this
	 * @details see if we have already done this
	 *
	 * @param theDomainName the domain name
	 * @return chain by domain
	 */
	@TestVisible
	private static accc_IHandlerChain cache(String theDomainName) {
		accc_IHandlerChain chain = null;
		// if valid domain, look for a cached chain
		if ( !string.isBlank(theDomainName)) {
			chain = accc_TriggerHandlerChainManager.m_domainChain.get(theDomainName);
		}
		return chain;
	} // end of cache
	/**
	 * @description cahce the chain by domain name
	 *
	 * @param theDomainName the domain name
	 * @param chain chain trigger handlers
	 */
	@TestVisible
	private static void cache(String theDomainName, accc_IHandlerChain chain) {
		// can we cache the chain by domain name
		if ( !string.isBlank(theDomainName)
		        && chain != null) {
			accc_TriggerHandlerChainManager.m_domainChain.put(theDomainName, chain);
		}
	} // end of cache

} // end of accc_TriggerHandlerChainManager