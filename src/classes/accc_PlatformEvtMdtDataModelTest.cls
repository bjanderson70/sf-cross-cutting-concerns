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
 * @description platform event custom MDT data model (DAO) Tests
 * @group Test Layer
 */
@isTest
private class accc_PlatformEvtMdtDataModelTest {
	// This test event MUST BE PRESENT
	static final String ExceptedEventLabelInCustomMDT = 'pe_test__e';
	static final String ExceptedEventNameInCustomMDT = 'pe_test_e';


	@isTest
	static void testCtor() {
		// assign/act
		accc_PlatformEvtMdtDataModel ctor = new accc_PlatformEvtMdtDataModel();
		// assert
		system.assertEquals(accc_PlatformEvtMdtDataModel.MDT_Name,
		                    ctor.CustomMDTName);

	} // end of testCtor

	@isTest
	static void testfindAll() {
		// assign
		accc_PlatformEvtMdtDataModel ctor = new accc_PlatformEvtMdtDataModel();
		// act
		List<accc_PlatformEvtMdtDataModel.PEDataModelInformation> result = ctor.findAll();
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);

	} // end of testfindAll

	@isTest
	static void testfindbyEnvironmentAndLabelWithNullLabel() {
		// assign
		accc_PlatformEvtMdtDataModel ctor = new accc_PlatformEvtMdtDataModel();
		// act
		List<accc_PlatformEvtMdtDataModel.PEDataModelInformation> result = ctor.findbyEnvironmentAndLabel(accc_ApexConstants.TEST_CATEGORY, null);
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);

	} // end of testfindbyEnvironmentAndLabelWithNullLabel

	@isTest
	static void testfindEnvironment() {
		// assign
		accc_PlatformEvtMdtDataModel ctor = new accc_PlatformEvtMdtDataModel();
		// act
		List<accc_PlatformEvtMdtDataModel.PEDataModelInformation> result = ctor.findByEnvironment(accc_ApexConstants.TEST_CATEGORY);
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);

	} // end of testfindEnvironment
	@isTest
	static void testfindbyEnvironmentAndLabel() {
		// assign
		accc_PlatformEvtMdtDataModel ctor = new accc_PlatformEvtMdtDataModel();
		// act
		List<accc_PlatformEvtMdtDataModel.PEDataModelInformation> result = ctor.findbyEnvironmentAndLabel(accc_ApexConstants.TEST_CATEGORY
		        , ExceptedEventLabelInCustomMDT);
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);
		system.assertEquals(true, result[0].isActive==true);
	}
	@isTest
	static void testfindByLabel() {
		// assign
		accc_PlatformEvtMdtDataModel ctor = new accc_PlatformEvtMdtDataModel();
		//act
		List<accc_PlatformEvtMdtDataModel.PEDataModelInformation> result = ctor.findByLabel(ExceptedEventLabelInCustomMDT);
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);

	}// end of testfindByLabel

	@isTest
	static void testfindByName() {
		// assign
		accc_PlatformEvtMdtDataModel ctor = new accc_PlatformEvtMdtDataModel();
		// act
		List<accc_PlatformEvtMdtDataModel.PEDataModelInformation> result = ctor.findByName(ExceptedEventNameInCustomMDT);
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);

	}// end of testfindByName
	@isTest
	static void testfindByNameWithNull() {
		// assign
		accc_PlatformEvtMdtDataModel ctor = new accc_PlatformEvtMdtDataModel();
		// act
		List<accc_PlatformEvtMdtDataModel.PEDataModelInformation> result = ctor.findByName(null);
		// assert
		system.assertEquals(true, result == null);

	}// end of testfindByNameWithNull

	@isTest
	static void testdefaultProcessHandler() {
		// assign/act
		String result = accc_PlatformEvtMdtDataModel.defaultProcessHandler(null, 'no');
		// assert
		system.assertEquals(true, result == 'no');
	}

	@isTest
	static void testsetValues() {
		// assign
		accc_PlatformEvtMdtDataModel.PEDataModelInformation info = new accc_PlatformEvtMdtDataModel.PEDataModelInformation();
		String seed = '';

		accc_PlatformEvtMdtDataModel ctor = new accc_PlatformEvtMdtDataModel();
		for (integer inx = 0; inx < accc_ApexConstants.MAX_STRING_SIZE; inx++) {
			seed += '*';
		}
		// act
		ctor.setValues(info, 'testLabel' + seed, 'testns' + seed, 'testDevName' + seed);
		// assert
		system.assertEquals(info.label.length(), accc_ApexConstants.MAX_STRING_SIZE );
		system.assertEquals(info.namespacePrefix.length(), accc_ApexConstants.MAX_STRING_SIZE);
		system.assertEquals(info.developerName.length(), accc_ApexConstants.MAX_STRING_SIZE);
		system.assertEquals(info.developerName.startsWith('testDevName'), true);

	} // end of testsetValues
}