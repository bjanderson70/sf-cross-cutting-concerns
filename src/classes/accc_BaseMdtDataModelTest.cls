/**
 * Copyright (c) 2016-2019, Bill Anderson. All rights reserved.
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
 *   * Neither the name of Bill Anderson , Bill Anderson nor the names of its
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
 * @description Test accc_BaseMdtDataModelTest
 * @group Common Test Layer
 */
@isTest
private class accc_BaseMdtDataModelTest {
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Data Members
	//
	/////////////////////////////////////////////////////////////////////////////////////////

	@TestVisible
	static private final string TestLabel2018 = 'test';
	@TestVisible
	static private final string TestName2018 = 'test';
	@TestVisible
	static private final string TestCategory = 'test';
	@TestVisible
	static private final string TEST_MDT_Name = 'accc_Apex_Code_Configuration__mdt';
	@TestVisible
	// none, as this is just testing
	static private final string COLUMN_FIELD = 'Category__c';
	//
	// Test base mdt model
	//
	@TestVisible
	private without sharing class Testaccc_BaseMdtDataModel extends accc_BaseMdtDataModel {

		public Testaccc_BaseMdtDataModel(string name, string category) {
			super(name, category);
		}
		public Testaccc_BaseMdtDataModel(string name) {
			super(name);
		}
		@TestVisible
		protected override List<accc_BaseMdtDataModel.BaseDataModelInformation> populateFromDataObjectChild(List<SObject> mdt) {
			List<accc_BaseMdtDataModel.BaseDataModelInformation> results = new List<accc_BaseMdtDataModel.BaseDataModelInformation> ();

			// just insert one
			accc_BaseMdtDataModel.BaseDataModelInformation result = new accc_BaseMdtDataModel.BaseDataModelInformation();
			result.label = TestLabel2018;
			result.namespacePrefix = '';
			result.developerName = TestName2018;
			results.add(result);
 
			return results;
		}
		 protected override List<BaseDataModelInformation> getInformationByLookup(String category, String lookup, accc_ControlPolicySearchEnum controlType) {
   			List<accc_BaseMdtDataModel.BaseDataModelInformation> results = new List<accc_BaseMdtDataModel.BaseDataModelInformation> ();

			// just insert one
			accc_BaseMdtDataModel.BaseDataModelInformation result = new accc_BaseMdtDataModel.BaseDataModelInformation();
			result.label = TestLabel2018;
			result.namespacePrefix = '';
			result.developerName = TestName2018;
			results.add(result);
			 return results;
		 }	
		/**
		 *
		 * @description allow the child to return their custom fields to select
		 * @return collection of field name
		 */
		@TestVisible
		protected override List<String> getSelectFields() {
			return null;//new List<String> {COLUMN_FIELD} ;
		}
		/**
		 *
		 * @description get the data object for testing from the child
		 * @return the data object for testing
		 */
		@TestVisible
		protected override accc_BaseMdtDataModel.BaseDataModelInformation getTestInformationByLookup() {
			List<accc_BaseMdtDataModel.BaseDataModelInformation> results = super.getInformationByLookup(accc_BaseMdtDataModelTest.TestLabel2018,
			        accc_BaseMdtDataModel.accc_ControlPolicySearchEnum.byLabel);
			return results != null && results.size() > 0 ? results[0] : null;
		}

	}// end of Testaccc_BaseMdtDataModel

	@isTest
	static void testCtor() {
		boolean didExcep = false;
		try {
			accc_BaseMdtDataModel ctor = new Testaccc_BaseMdtDataModel('null', null);
		} catch (accc_ApexApplicationException execp) {
			didExcep = true;
		}
		system.assertEquals(false, didExcep);

	} // end of testCtor

	@isTest
	static void testCtorWithBadDataFirstParameter() {
		boolean didExcep = false;
		try {
			accc_BaseMdtDataModel ctor = new Testaccc_BaseMdtDataModel(null, null);
		} catch (accc_ApexApplicationException execp) {
			didExcep = true;
		}
		system.assertEquals(true, didExcep);

	} // end of testCtorWithBadDataFirstParameter
	@isTest
	static void testfindAll() {
		accc_BaseMdtDataModel ctor = new Testaccc_BaseMdtDataModel(TEST_MDT_Name);
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = ctor.findAll();
		system.assertEquals(false, result == null);

	} // end of testfindAll

	@isTest
	static void testfindByLabel() {
		accc_BaseMdtDataModel ctor = new Testaccc_BaseMdtDataModel(TEST_MDT_Name);
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = ctor.findByLabel(null);
		system.assertEquals(true, result == null);

	}// end of testfindByLabel
	@isTest
	static void testfindByLabelWithValidLabel() {
		accc_BaseMdtDataModel ctor = new Testaccc_BaseMdtDataModel(TEST_MDT_Name);
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = ctor.findByLabel(accc_BaseMdtDataModelTest.TestLabel2018);
		system.assertEquals(true, result.size() > 0);

	}// end of testfindByLabelWithValidLabel

	@isTest
	static void testfindByName() {
		accc_BaseMdtDataModel ctor = new Testaccc_BaseMdtDataModel(TEST_MDT_Name);
		// act
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = ctor.findByName(null);
		// assert
		system.assertEquals(true, result == null);
		// act
		result = ctor.findByName('');
		// assert
		system.assertEquals(true, result == null);

	} // end of testfindByName

	@isTest
	static void testfindByNameWithValidName() {
		accc_BaseMdtDataModel ctor = new Testaccc_BaseMdtDataModel(TEST_MDT_Name);
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = ctor.findByName(accc_BaseMdtDataModelTest.TestName2018);
		system.assertEquals(false, result == null);

	} // end of testfindByNameWithValidName

	@isTest
	static void testfindByCategoryAndLabel() {
		accc_BaseMdtDataModel ctor = new Testaccc_BaseMdtDataModel(TEST_MDT_Name,accc_BaseMdtDataModelTest.TestCategory);
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = ctor.findByCategoryAndLabel(accc_BaseMdtDataModelTest.TestCategory,
		        accc_BaseMdtDataModelTest.TestLabel2018);
		system.assertEquals(true, result.size() > 0);

	} // end of testfindByCategoryAndLabel

	@isTest
	static void testfindByCategory() {
		accc_BaseMdtDataModel ctor = new Testaccc_BaseMdtDataModel(TEST_MDT_Name,accc_BaseMdtDataModelTest.TestCategory);
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = ctor.findByCategory(accc_BaseMdtDataModelTest.TestCategory);
		system.assertEquals(true, result.size() > 0);
	} // end of testfindByCategoryAndLabel
	
	@isTest
	static void testfindByCategoryAndLabelWithNullCategory() {
		accc_BaseMdtDataModel ctor = new Testaccc_BaseMdtDataModel(TEST_MDT_Name);
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = ctor.findByCategoryAndLabel(null,
		        accc_BaseMdtDataModelTest.TestLabel2018);
		system.assertEquals(true, result.size() > 0);

	} // end of testfindByCategoryAndLabelWithNullCategory
	@isTest
	static void  testgetValidChildList() {
		accc_BaseMdtDataModel ctor = new Testaccc_BaseMdtDataModel(TEST_MDT_Name);
		Map<String, Boolean> checkChildList = new Map<String, Boolean> {
			null => false
		};
		for (String key : checkChildList.keyset()) {
			List<String> myList = key != null ? key.split(',') : null,
			             result = ctor.getValidChildList(myList) ;
			system.assertEquals((Boolean)checkChildList.get(key),
			                    key != null ? result.size() > 0 : false);
		}
	}// end of testgetValidChildList
	@isTest
	static void testfindByCategoryAndLabelWithNullLabel() {
		accc_BaseMdtDataModel ctor = new Testaccc_BaseMdtDataModel(TEST_MDT_Name);
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = ctor.findByCategoryAndLabel(accc_BaseMdtDataModelTest.TestCategory,
		        null);
		system.assertEquals(true, result == null);

	} // end of testfindByCategoryAndLabelWithNullLabel

	@isTest
	static void testmakeSoqlSelect() {
		accc_BaseMdtDataModel ctor = new Testaccc_BaseMdtDataModel(TEST_MDT_Name);
		string result = ctor.makeSoqlSelect();
		system.assertEquals(true, result == accc_BaseMdtDataModel.SELECT_FIELDS);

	} // end of testmakeSoqlSelect

	@isTest
	static void testsetValues() {
		accc_BaseMdtDataModel baseM = new Testaccc_BaseMdtDataModel(TEST_MDT_Name);
		List<String> labels = new List<String> {
			accc_ApexUtilities.generateRandomNumberString(accc_ApexConstants.MAX_STRING_SIZE - 1),
			accc_ApexUtilities.generateRandomNumberString(accc_ApexConstants.MAX_STRING_SIZE),
			accc_ApexUtilities.generateRandomNumberString(accc_ApexConstants.MAX_STRING_SIZE + 1),
			accc_ApexUtilities.generateRandomNumberString(accc_ApexConstants.MAX_STRING_SIZE + 2)
		};
		List<String> names = new List<String> {
			accc_ApexUtilities.generateRandomNumberString(accc_ApexConstants.MAX_STRING_SIZE - 1),
			accc_ApexUtilities.generateRandomNumberString(accc_ApexConstants.MAX_STRING_SIZE),
			accc_ApexUtilities.generateRandomNumberString(accc_ApexConstants.MAX_STRING_SIZE + 1),
			accc_ApexUtilities.generateRandomNumberString(accc_ApexConstants.MAX_STRING_SIZE + 2)
		};
		List<String> prefixes = new List<String> {
			accc_ApexUtilities.generateRandomNumberString(accc_ApexConstants.MAX_STRING_SIZE - 1),
			accc_ApexUtilities.generateRandomNumberString(accc_ApexConstants.MAX_STRING_SIZE),
			accc_ApexUtilities.generateRandomNumberString(accc_ApexConstants.MAX_STRING_SIZE + 1),
			accc_ApexUtilities.generateRandomNumberString(accc_ApexConstants.MAX_STRING_SIZE + 2)
		};
		Map<Integer, Integer> mapTruth = new Map<Integer, Integer> {
			0 => accc_ApexConstants.MAX_STRING_SIZE - 1,
			1 => accc_ApexConstants.MAX_STRING_SIZE,
			2 => accc_ApexConstants.MAX_STRING_SIZE,
			3 => accc_ApexConstants.MAX_STRING_SIZE
		};
		accc_BaseMdtDataModel.BaseDataModelInformation info = new accc_BaseMdtDataModel.BaseDataModelInformation();
		for ( Integer inx : mapTruth.keyset() ) {
			baseM.setValues(info,
			                labels[inx],
			                prefixes[inx],
			                names[inx]
			               );
			system.assertEquals(true, (integer)mapTruth.get(inx) == info.namespacePrefix.length());
			system.assertEquals(true, (integer)mapTruth.get(inx) == info.developerName.length());
			system.assertEquals(true, (integer)mapTruth.get(inx) == info.label.length());
		}
	} // end of testsetValues
	
}// end of accc_BaseMdtDataModelTest