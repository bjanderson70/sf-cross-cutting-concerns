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
 * @description Encapsulates all behaviour logic relating to testing trigger handling in
 * children of the Domains
 *
 * For more guidelines and details see
 *   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Domain_Layer
 * @group Test Layer
 **/
@isTest
private class accc_TriggerHandlerMetaDataModelTest {
	// This test name MUST BE PRESENT (TH == Trigger Handler)
	static final String ExpectedTHLabelInCustomMDT = 'th_leave_for_test_account';
	static final String ExpectedTHNameInCustomMDT = 'th_leave_for_test_account';
	static final String ExpectedTHClassNameInCustomMDT = 'accc_TestTriggerHandlerForAccount';
	static final String ExpectedTHDomainInCustomMDT = 'Account';
	static final Integer EXPECTED_NUMBER_OF_ACCOUNT_TRIGGERS_INC_CMDT = 2;
	static final String ExpectedTHEnvironmentCustomMDT = accc_ApexConstants.TEST_CATEGORY;

	@isTest
	static void testCtor() {
		// assign/act
		accc_BaseMdtDataModel ctor = new accc_TriggerHandlerMetaDataModel();
		// assert
		system.assertEquals(accc_TriggerHandlerMetaDataModel.MDT_Name,
		                    ctor.CustomMDTName);

	} // end of testCtor

	@isTest
	static void testfindAll() {
		// assign
		accc_BaseMdtDataModel ctor = new accc_TriggerHandlerMetaDataModel();
		// act
		List<accc_BaseMdtDataModel.BaseDataModelInformation>  result = (List<accc_BaseMdtDataModel.BaseDataModelInformation> )ctor.findAll();
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);

	} // end of testfindAll

	@isTest
	static void testfindbyEnvironmentAndLabelWithNullLabel() {
		// assign
		accc_TriggerHandlerMetaDataModel ctor = new accc_TriggerHandlerMetaDataModel();
		// act
		List<accc_BaseMdtDataModel.BaseDataModelInformation>  result = (List<accc_BaseMdtDataModel.BaseDataModelInformation> )ctor.findbyEnvironmentAndLabel(ExpectedTHEnvironmentCustomMDT, null);
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);

	} // end of testfindbyEnvironmentAndLabelWithNullLabel

	@isTest
	static void testfindEnvironment() {
		// assign
		accc_TriggerHandlerMetaDataModel ctor = new accc_TriggerHandlerMetaDataModel();
		// act
		List<accc_BaseMdtDataModel.BaseDataModelInformation>  result = (List<accc_BaseMdtDataModel.BaseDataModelInformation> )ctor.findByEnvironment(ExpectedTHEnvironmentCustomMDT);
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);

	} // end of testfindEnvironment

	@isTest
	static void testfindbyEnvironmentAndLabel() {
		// assign
		accc_TriggerHandlerMetaDataModel ctor = new accc_TriggerHandlerMetaDataModel();
		// act
		List<accc_BaseMdtDataModel.BaseDataModelInformation> data = (List<accc_BaseMdtDataModel.BaseDataModelInformation>  )ctor.findbyEnvironmentAndLabel(ExpectedTHEnvironmentCustomMDT
		        , ExpectedTHLabelInCustomMDT);
		List<accc_TriggerHandlerMetaDataModel.THDataModelInformation> result = (List<accc_TriggerHandlerMetaDataModel.THDataModelInformation>) data;
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);
		system.assertEquals(true, result[0].isActive == true);
		system.assertEquals(true, result[0].continueIfException);
	}// end of testfindbyEnvironmentAndLabel

	@isTest
	static void testfindbyEnvironmentAndDomain() {
		// assign
		accc_TriggerHandlerMetaDataModel ctor = new accc_TriggerHandlerMetaDataModel();
		// act
		List<accc_BaseMdtDataModel.BaseDataModelInformation> data = ctor.findbyEnvironmentAndDomain(ExpectedTHEnvironmentCustomMDT
		        , ExpectedTHDomainInCustomMDT);
		List<accc_TriggerHandlerMetaDataModel.THDataModelInformation> result = (List<accc_TriggerHandlerMetaDataModel.THDataModelInformation>) data;

		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);
		system.assertEquals(true, result[0].domain == ExpectedTHDomainInCustomMDT);
		system.assertEquals(true, result[0].isActive == true);
		system.assertEquals(true, result[0].continueIfException);
		system.assertEquals(true, result[0].performanceMetrics);
	}// end of testfindbyEnvironmentAndDomain

	@isTest
	static void testfindbyEnvironmentAndDomainWithNoEnv() {
		// assign
		accc_TriggerHandlerMetaDataModel ctor = new accc_TriggerHandlerMetaDataModel();
		// act
		List<accc_BaseMdtDataModel.BaseDataModelInformation> data = ctor.findbyEnvironmentAndDomain(null, ExpectedTHDomainInCustomMDT);
		List<accc_TriggerHandlerMetaDataModel.THDataModelInformation> result = (List<accc_TriggerHandlerMetaDataModel.THDataModelInformation>) data;

		// assert
		system.assertEquals(true, result != null);
		system.assertEquals(true, result.size() > 0);
		system.assertEquals(true, result[0].domain == ExpectedTHDomainInCustomMDT);
		system.assertEquals(true, result[0].isActive == true);
		system.assertEquals(true, result[0].continueIfException);
		system.assertEquals(true, result[0].performanceMetrics);
	}// end of testfindbyEnvironmentAndDomainWithNoEnv

	@isTest
	static void testfindbyEnvironmentAndDomainNoDomain(){
		// assign
		accc_TriggerHandlerMetaDataModel ctor = new accc_TriggerHandlerMetaDataModel();
		// act
		List<accc_BaseMdtDataModel.BaseDataModelInformation> data = ctor.findbyEnvironmentAndDomain(ExpectedTHEnvironmentCustomMDT, null);
		List<accc_TriggerHandlerMetaDataModel.THDataModelInformation> result = (List<accc_TriggerHandlerMetaDataModel.THDataModelInformation>) data;

		// assert
		system.assertEquals(true, result != null);
		system.assertEquals(true, result.size() > 0);
		system.assertEquals(true, result[0].domain != null);
		system.assertEquals(true, result[0].isActive == true);
		system.assertEquals(true, result[0].continueIfException);
		system.assertEquals(true, result[0].performanceMetrics);
	} // end of testfindbyEnvironmentAndDomainNoDomain

	@isTest
	static void testgetTestInformationByLookup(){
		// assign
		accc_TriggerHandlerMetaDataModel ctor = new accc_TriggerHandlerMetaDataModel();
		// act
		accc_TriggerHandlerMetaDataModel.THDataModelInformation result = (accc_TriggerHandlerMetaDataModel.THDataModelInformation)ctor.getTestInformationByLookup();
		
		// assert
		system.assertEquals(true, result != null);
		system.assertEquals(accc_ApexConstants.TEST_CATEGORY.toLowerCase(), result.environment.toLowerCase());
	}

	@isTest
	static void testfindbyTestValues() {
		// assign
		accc_TriggerHandlerMetaDataModel ctor = new accc_TriggerHandlerMetaDataModel();
		// act
		List<accc_BaseMdtDataModel.BaseDataModelInformation> data = (List<accc_BaseMdtDataModel.BaseDataModelInformation> ) ctor.findbyEnvironmentAndLabel(ExpectedTHEnvironmentCustomMDT
		        , ExpectedTHLabelInCustomMDT);
		List<accc_TriggerHandlerMetaDataModel.THDataModelInformation> result = (List<accc_TriggerHandlerMetaDataModel.THDataModelInformation>) data;

		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);
		system.assertEquals(true, result[0].domain == ExpectedTHDomainInCustomMDT);
		system.assertEquals(true, result[0].classes.containsAll(new  Set<String> {ExpectedTHClassNameInCustomMDT}));
		system.assertEquals(true, result[0].classes.size() >= EXPECTED_NUMBER_OF_ACCOUNT_TRIGGERS_INC_CMDT);
		system.assertEquals(true, result[0].isActive == true);
		system.assertEquals(true, result[0].continueIfException);
	}

	@isTest
	static void testfindByLabel() {
		// assign
		accc_BaseMdtDataModel ctor = new accc_TriggerHandlerMetaDataModel();
		//act
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = (List<accc_BaseMdtDataModel.BaseDataModelInformation> )ctor.findByLabel(ExpectedTHLabelInCustomMDT);
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);


	}// end of testfindByLabel

	@isTest
	static void testfindByName() {
		// assign
		accc_TriggerHandlerMetaDataModel ctor = new accc_TriggerHandlerMetaDataModel();
		// act
		List<accc_TriggerHandlerMetaDataModel.THDataModelInformation> result = (List<accc_TriggerHandlerMetaDataModel.THDataModelInformation> )ctor.findByName(ExpectedTHNameInCustomMDT);
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);

	}// end of testfindByName

	@isTest
	static void testfindByNameWithNull() {
		// assign
		accc_BaseMdtDataModel ctor = new accc_TriggerHandlerMetaDataModel();
		// act
		List<accc_TriggerHandlerMetaDataModel.THDataModelInformation> result = (List<accc_TriggerHandlerMetaDataModel.THDataModelInformation> )ctor.findByName(null);
		// assert
		system.assertEquals(true, result == null);

	}// end of testfindByNameWithNull


	@isTest
	static void testsetValues() {
		// assign
		accc_TriggerHandlerMetaDataModel.THDataModelInformation info = new accc_TriggerHandlerMetaDataModel.THDataModelInformation();
		String seed = '';

		accc_TriggerHandlerMetaDataModel ctor = new accc_TriggerHandlerMetaDataModel();
		for (integer inx = 0; inx < accc_ApexConstants.MAX_STRING_SIZE; inx++) {
			seed += '*';
		}
		// act
		ctor.setValues(info, 'testLabel' + seed, 'testns' + seed, 'testDevName' + seed);
		// assert
		system.assertEquals(accc_ApexConstants.MAX_STRING_SIZE, info.label.length());
		system.assertEquals(accc_ApexConstants.MAX_STRING_SIZE, info.namespacePrefix.length());
		system.assertEquals(accc_ApexConstants.MAX_STRING_SIZE, info.developerName.length());
		system.assertEquals(true, info.developerName.startsWith('testDevName'));

	} // end of testsetValues

}// end of accc_TriggerHandlerMetaDataModelTest