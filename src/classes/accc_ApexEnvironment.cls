/**
 * Copyright (c) 2016-2019, Bill anderson.  All rights reserved.
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
 * @description common environment utilities.
 * TBD: Needs to be revisited; consider use of a factory!!
 * 
 * Modification : BJA , Added ensureEnviromentIsCorrectOtherwiseDebug to allow specification of environment
 * @group Miscellaneous
 */
public without sharing class accc_ApexEnvironment {

	////////////////////////////////////////////////////////////////////////////////
	/// Data Members
	////////////////////////////////////////////////////////////////////////////////

	/*
	 * Known environments
	 */
	public static final Set<String> KNOWN_ENVIRONMENTS = new Set<String> {
		accc_ApexConstants.DEBUG_CATEGORY
		, accc_ApexConstants.PRODUCTION_CATEGORY
		, accc_ApexConstants.TEST_CATEGORY
	}; // end of KNOWN_ENVIRONMENTS
	@TestVisible
	private static accc_IApexRunEnvironment runtimeEnvironment =  null;
	@TestVisible
	private static accc_IFallbackResources runtimeFallback =  null;
	@TestVisible
	private static accc_IApexExceptionHandler runtimeFallbackHandler =  null;

	////////////////////////////////////////////////////////////////////////////////
	/// Public Static Methods
	////////////////////////////////////////////////////////////////////////////////

	/**
	 * @brief get the API version
	 * @description get the API version of the framework
	 * @return major.minor.revision string, i.e 0.9.5; note, may change to day,month,year TBD
	 */
	public static string getVersion() {
		return accc_ApexConstants.CURRENT_VERSION;
	} // end of getVersion
	/**
	* @description the environment
	* @return either 'production', 'debug' (in sandbox) or 'test'
	*/
	public static string getEnvironment() {
		string environment = accc_ApexConstants.PRODUCTION_CATEGORY;

		if ( accc_ApexConstants.UnitTestsRunning  ) {
			environment = accc_ApexConstants.TEST_CATEGORY;
		} else if (accc_ApexUtilities.isSandbox() ) {
			environment = accc_ApexConstants.DEBUG_CATEGORY;
		}

		return environment;
	} // end of getEnvironment
	/**
	 * @description just ensuring correct environment
	 *
	 * @param currentEnv user wants a particular environment
	 * @return environment, otherwise , 'accc_ApexConstants.DEBUG_CATEGORY'
	 */
	public static string ensureEnviromentIsCorrectOtherwiseDebug(string currentEnv) {
		String env = currentEnv == null ? accc_ApexConstants.DEBUG_CATEGORY : currentEnv;
		if ( !accc_ApexEnvironment.KNOWN_ENVIRONMENTS.contains(env.toLowerCase()) ) {
			env = accc_ApexConstants.DEBUG_CATEGORY;
		}
		return env;
	} // end of ensureEnviromentIsCorrectOtherwiseDebug
	/**
	* @description get the runtime environment based on sandbox or test running.
	* If there is a need for more control, then perhaps a custom setting/type [tbd]
	* @return accc_IApexRunEnvironment which runtime environment
	*/
	public static accc_IApexRunEnvironment getRuntimeEnvironment() {
		if ( accc_ApexEnvironment.runtimeEnvironment == null ) {
			accc_ApexEnvironment.runtimeEnvironment = accc_ApexRunEnvironmentSingleton.getInstance();
			// TBD -- May consider accc_ApexEnvironment.runtimeEnvironment = accc_TestEnvironmentSingleton.getInstance();
		}

		return accc_ApexEnvironment.runtimeEnvironment;
	}  // end of getRuntimeEnvironment
	/**
	 * @description get the runtime fallback based on test running or not.
	 * The reason we DO NOT use the runtime environment is chicken-egg. As
	 * ConfigMgr is used by the runtime at creation of the object factory (thus, never can created). And,
	 * ConfgMgr uses fallback resources in the event it cannot find a resource; otherwise,
	 * we get a stack overflow. [TBD - Need to re-evaluate]
	 *
	 * @return accc_IFallbackResources how runtime environment fallback resources
	 */
	public static accc_IFallbackResources getRuntimeFallbackResources() {
		if ( accc_ApexEnvironment.runtimeFallback == null ) {

			if ( accc_ApexConstants.UnitTestsRunning ) {
				accc_ApexEnvironment.runtimeFallback = new accc_ApexTestJSONDataFallback();
			} else {
				accc_ApexEnvironment.runtimeFallback = new accc_ApexKnownCCConcernsFallback();
			}
		}

		return accc_ApexEnvironment.runtimeFallback;
	}  // end of getRuntimeFallbackResources

	/**
	* @description get the runtime fallback excp handler based on sandbox or test running.
	* The reason we DO NOT use the runtime environment is chicken-egg. As
	* ConfigMgr is used by the runtime at creation of the object factory. And,
	* ConfgMgr uses fallback excp handler in the event it cannot find a resource; otherwise,
	* we get a stack overflow. [TBD - Need to re-evaluate]
	*
	* @return accc_IApexExceptionHandler  runtime environment fallback exception handler
	*/
	public static accc_IApexExceptionHandler getRuntimeFallbackExceptionHandler() {
		if ( accc_ApexEnvironment.runtimeFallbackHandler == null ) {
			accc_ApexEnvironment.runtimeFallbackHandler = new accc_ApexExceptionHandler();
		}

		return accc_ApexEnvironment.runtimeFallbackHandler;
	}  // end of getRuntimeFallbackExceptionHandler
} // end of accc_ApexEnvironment