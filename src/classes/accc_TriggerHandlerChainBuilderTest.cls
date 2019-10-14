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
 *
 * @description Test the trigger handler  builder class.
 * Tests depend on custom metadata being set properly !!
 * Domains, Account and Contact, each have one Test class defined in the
 * custom metadata. DO NOT DELETE them; otherwise, these tests will FAIL
 *
 * The test classes :
 *  Contact ---> accc_TestTriggerHandlerForContactTest
 *  Account ---> accc_TestTriggerHandlerForAccountTest, accc_TestTriggerHandlerForAccountTwoTest
 *
 * @group Test Layer
 */
@isTest
private class accc_TriggerHandlerChainBuilderTest {


	@isTest
	static void testctorWithDomain() {
		// assign
		final String domainName = '*no_event_domain_junk';
		// act
		accc_TriggerHandlerChainBuilder ctor = new accc_TriggerHandlerChainBuilder(domainName);
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(domainName, ctor.domainName);
		System.assertEquals(accc_ApexConstants.PRODUCTION_CATEGORY.toLowerCase(), ctor.triggerEnvironment.toLowerCase() );
		System.assertEquals(false, ctor.validDomainName == null);
		System.assertEquals(true, ctor.theElements == null);
		System.assertEquals(false, ctor.continueIfException);
	}
	@isTest
	static void testctorWithDomainAndEnv() {
		// assign
		final String domainName = '*no_event_domain_junk';
		// act
		accc_TriggerHandlerChainBuilder ctor = new accc_TriggerHandlerChainBuilder(domainName, accc_ApexConstants.DEBUG_CATEGORY);
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(domainName, ctor.domainName);
		System.assertEquals(accc_ApexConstants.DEBUG_CATEGORY.toLowerCase(), ctor.triggerEnvironment.toLowerCase() );
		System.assertEquals(false, ctor.validDomainName);
		System.assertEquals(true, ctor.theElements == null);
		System.assertEquals(false, ctor.continueIfException);
	}
	@isTest
	static void testctorWithValidDomain() {
		// assign
		final String domainName = 'Account';
		// act
		accc_TriggerHandlerChainBuilder ctor = new accc_TriggerHandlerChainBuilder(domainName,
		        accc_ApexConstants.TEST_CATEGORY);
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(domainName, ctor.domainName);
		System.assertEquals(accc_ApexConstants.TEST_CATEGORY.toLowerCase(), ctor.triggerEnvironment.toLowerCase() );
		System.assertEquals(true, ctor.validDomainName);
		// Note, this ASSUMES the TEST metadata is LEFT INTACT (It SHOULD)
		System.assertEquals(true, ctor.theElements != null);
		// we have not try to create a chain, thus we have not read yet
		System.assertEquals(false, ctor.continueIfException);
	}

	@isTest
	static void testctorWithValidDomainAndEnv() {
		// assign
		final String domainName = 'Account';
		// act
		accc_TriggerHandlerChainBuilder ctor = new accc_TriggerHandlerChainBuilder(domainName, accc_ApexConstants.DEBUG_CATEGORY);
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(domainName, ctor.domainName);
		System.assertEquals(accc_ApexConstants.DEBUG_CATEGORY.toLowerCase(), ctor.triggerEnvironment.toLowerCase() );
		System.assertEquals(true, ctor.validDomainName);
		System.assertEquals(false, ctor.domainActive);
		System.assertEquals(true, ctor.theElements == null);
		System.assertEquals(false, ctor.continueIfException);

	}// end of testctorWithValidDomainAndEnv

	@isTest
	static void testfindbyEnvironmentAndDomainIsNull() {
		// assign
		final String domainName = null;
		// act
		accc_TriggerHandlerChainBuilder ctor = new accc_TriggerHandlerChainBuilder(domainName, accc_ApexConstants.TEST_CATEGORY);
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(true, string.isBlank(ctor.domainName));
		System.assertEquals(accc_ApexConstants.TEST_CATEGORY.toLowerCase(), ctor.triggerEnvironment.toLowerCase() );
		System.assertEquals(false, ctor.validDomainName);
		System.assertEquals(false, ctor.domainActive);
		// gets all elements for that environment ( but no domain specific)
		System.assertEquals(true, ctor.theElements != null);
		System.assertEquals(false, ctor.continueIfException);

	}// end of testfindbyEnvironmentAndDomainIsNull

	@isTest
	static void testbuildTriggerEventHandlerChain() {
		// assign
		final String domainName = 'Contact';
		// act
		accc_TriggerHandlerChainBuilder ctor = new accc_TriggerHandlerChainBuilder(domainName, accc_ApexConstants.TEST_CATEGORY);
		accc_IHandlerChain chain = ctor.buildTriggerEventHandlerChain(ctor.theElements, domainName);
		// assert
		System.assertEquals(true, chain != null);
		System.assertEquals(true, ctor.theElements != null);
		System.assertEquals(true, chain.getHandler() != null);
		System.assertEquals(true, ctor.continueIfException);
	}

	@isTest
	static void testbuild() {
		// assign --
		// we are expecting at least 1 account in the CMDT. This DOES NOT
		// include DUPLICATES as we remove them
		final String domainName = 'Account';
		accc_TriggerHandlerChainBuilder ctor = new accc_TriggerHandlerChainBuilder(domainName, accc_ApexConstants.TEST_CATEGORY);

		// act
		accc_IHandlerChain triggerHandlers = ctor.build();

		// assert
		System.assertEquals(true, triggerHandlers != null);
		System.assertEquals(1, ctor.theElements.size());
		System.assertEquals(true, triggerHandlers.getHandler() != null);
		System.assertEquals(true, triggerHandlers.getNext().getHandler() != null);
		System.assertEquals(true, triggerHandlers.getNext() != null);
		// NOTE: there are 2 accounts handlers; thus, getNext() == 1, getNext().getNext() == 2
		System.assertEquals(true, triggerHandlers.getNext().getNext() == null);

		System.assertEquals(true, ctor.continueIfException);


	}// end of testbuild

	@isTest
	static void testbuildWithContactTest() {
		// assign
		final String domainName = 'Contact';
		accc_TriggerHandlerChainBuilder ctor = new accc_TriggerHandlerChainBuilder(domainName, accc_ApexConstants.TEST_CATEGORY);

		// act
		accc_IHandlerChain triggerHandlers = ctor.build();

		// assert
		System.assertEquals(true, triggerHandlers != null);
		System.assertEquals(true, triggerHandlers.getHandler() != null);
		System.assertEquals(true, ctor.continueIfException);

	}// end of testbuildWithContactTest

	@isTest
	static void testtriggerEnvironment() {
		// assign
		final String domainName = 'Account';
		// act
		accc_TriggerHandlerChainBuilder ctor = new accc_TriggerHandlerChainBuilder(domainName, accc_ApexConstants.DEBUG_CATEGORY);
		// assert
		System.assertEquals(accc_ApexConstants.DEBUG_CATEGORY.toLowerCase(), ctor.triggerEnvironment.toLowerCase() );
		// set bogus ... should default to test
		ctor = new accc_TriggerHandlerChainBuilder(domainName, 'junk');
		// assert
		System.assertEquals(accc_ApexConstants.TEST_CATEGORY.toLowerCase(), ctor.triggerEnvironment.toLowerCase() );
		// set bogus ... should default to test
		ctor = new accc_TriggerHandlerChainBuilder(domainName, '');
		// assert
		System.assertEquals(accc_ApexConstants.TEST_CATEGORY.toLowerCase(), ctor.triggerEnvironment.toLowerCase() );
		// set bogus ... should default to test
		ctor = new accc_TriggerHandlerChainBuilder(domainName, null);
		// assert
		System.assertEquals(accc_ApexConstants.TEST_CATEGORY.toLowerCase(), ctor.triggerEnvironment.toLowerCase() );
		// set valid name w/ spaces ... should default to debug
		ctor = new accc_TriggerHandlerChainBuilder(domainName, 'DEBUG    ');
		// assert
		System.assertEquals(accc_ApexConstants.DEBUG_CATEGORY.toLowerCase(), ctor.triggerEnvironment.toLowerCase() );

	} // end of testtriggerEnvironment

	@isTest
	static void testBadBuild() {
		// assign
		boolean gotException = false;
		final String domainName = 'Account';
		try {
			accc_TriggerHandlerChainBuilder ctor = new accc_TriggerHandlerChainBuilder(domainName, accc_ApexConstants.TEST_CATEGORY);

			// make a bad domain
			ctor.m_validDomainName = false;

			// act
			accc_IHandlerChain triggerHandlers = ctor.build();
		} catch (Exception excp) {
			gotException = true;
		}

		// assert
		System.assertEquals(true, gotException);


	}// end of testBadBuild


} // end of accc_TriggerHandlerChainBuilderTest