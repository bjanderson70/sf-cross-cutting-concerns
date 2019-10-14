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
 * @description Encapsulates all behaviour logic relating to testing trigger manager. The
 * manager is used in the base domain for invoking the active trigger handlers
 *
 * @group Test Layer
 **/
@isTest
private class accc_TriggerHandlerChainManagerTest {

	static final String ExpectedTHEnvironmentCustomMDT = accc_ApexConstants.TEST_CATEGORY;

	@isTest
	static void testCtor() {
		// arrange/act
		accc_TriggerHandlerChainManager ctor = new accc_TriggerHandlerChainManager(ExpectedTHEnvironmentCustomMDT);
		// assert
		System.assertEquals(ExpectedTHEnvironmentCustomMDT, ctor.triggerEnvironment);
		// default is true
		System.assertEquals(true, ctor.continueIfException);

	}
	@isTest
	static void testcreateHandlerChainByDomain() {
		// arrange
		final String domain = 'Account';
		final String madeUpDomain = 'MyJunk*';

		accc_TriggerHandlerChainManager ctor = new accc_TriggerHandlerChainManager(ExpectedTHEnvironmentCustomMDT);
		// assert
		System.assertEquals(true, ctor.createHandlerChainByDomain(domain) != null);
		System.assertEquals(true, accc_TriggerHandlerChainManager.cache(domain) != null);
		System.assertEquals(true, accc_TriggerHandlerChainManager.cache('') == null);
		// default is true
		System.assertEquals(true, ctor.continueIfException);
		accc_TriggerHandlerChainManager.cache(madeUpDomain, ctor.createHandlerChainByDomain(domain));
		System.assertEquals(true, accc_TriggerHandlerChainManager.cache(madeUpDomain) != null);
	}

	@isTest
	static void testcreateHandlerChainByDomainWithBadEnvironment() {
		// arrange
		final String domain = 'Account';
		// note, even though the environment is incorrect, the manager/builder will set to TEST
		accc_TriggerHandlerChainManager ctor = new accc_TriggerHandlerChainManager('NONE');
		// assert
		System.assertEquals(true, ctor.createHandlerChainByDomain(domain) != null);
		System.assertEquals(true, accc_TriggerHandlerChainManager.cache(domain) != null);
		System.assertEquals(true, ctor.continueIfException);
		System.assertEquals(true, ctor.performanceMetrics);
	}


	@isTest
	static void testcreateHandlerChainByDomainBuildCauseException() {
		// arrange
		final String domain = 'Account';
		// note, even though the environment is incorrect, the manager/builder will set to TEST
		accc_TriggerHandlerChainManager ctor = new accc_TriggerHandlerChainManager('NONE');
		// cause an exceptio ( for testing only)
		ctor.m_causeException = true;
		// assert
		System.assertEquals(true, ctor.createHandlerChainByDomain(domain) == null);
		System.assertEquals(true, accc_TriggerHandlerChainManager.cache(domain) == null);
		System.assertEquals(false, ctor.continueIfException);
		System.assertEquals(false, ctor.performanceMetrics);
		System.assertEquals(true, ctor.buildException != null );
	}


	@isTest
	static void testcache() {
		// arrange
		final String domain = 'Account';
		final String madeUpDomain = '*MyJunk*';
		accc_IHandlerChain chain = null;

		accc_TriggerHandlerChainManager ctor = new accc_TriggerHandlerChainManager(ExpectedTHEnvironmentCustomMDT);
		chain = ctor.createHandlerChainByDomain(domain) ;
		// assert

		System.assertEquals(true, accc_TriggerHandlerChainManager.cache(domain) != null);
		System.assertEquals(true, accc_TriggerHandlerChainManager.cache('ksksks-1-1') == null);
		accc_TriggerHandlerChainManager.cache(madeUpDomain, chain);
		System.assertEquals(true, accc_TriggerHandlerChainManager.cache(madeUpDomain) != null);
	}
}