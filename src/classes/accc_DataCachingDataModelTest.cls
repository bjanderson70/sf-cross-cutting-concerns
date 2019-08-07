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
 * @description  External representation of the data cached metadata. Providing a
 * wrapper around the internal data mapper allows one to vary the metadata w/o having to
 * change ALL dependencies. [Added layer of indirection to adjust for change]
 * @group Common Test Layer
 */
@isTest
private class accc_DataCachingDataModelTest {
	@isTest
	static void testCtor() {
		// act/assign
		accc_BaseMdtDataModel octor = (accc_BaseMdtDataModel) accc_ApexEnvironment.getRuntimeEnvironment().provider().get(accc_ApexConstants.DataCachingConfiguration_r);
		accc_DataCachingDataModel ctor = new accc_DataCachingDataModel();
		// assert
		System.assertNotEquals(ctor, null);
		System.assertNotEquals(octor, null);
	} // end of testCtor

	@isTest
	static void testCtorWithName() {
		// act/assign
		accc_DataCachingDataModel ctor = new accc_DataCachingDataModel();

		// assert
		System.assertEquals(ctor.CustomMDTName, accc_DataCachingDataModel.MDT_Name);
	} // end of testCtorWithName

	@isTest
	static void testfindByLabel() {
		// act/assign
		accc_DataCachingDataModel ctor = new accc_DataCachingDataModel();
		accc_BaseMdtDataModel octor = (accc_BaseMdtDataModel) accc_ApexEnvironment.getRuntimeEnvironment().provider().get(accc_ApexConstants.DataCachingConfiguration_r);

		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = ctor.findByLabel(accc_DataCachingDataModel.TestLabel2018);
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result2 = octor.findByLabel(accc_DataCachingDataModel.TestLabel2018);

		// assert
		System.assertNotEquals(null, result );
		System.assertNotEquals(null, result2 );
	} // end of testfindByLabel

	@isTest
	static void testgetTestInformationByLookup() {
		// act/assign
		accc_DataCachingDataModel ctor = new accc_DataCachingDataModel();
		 
		accc_BaseMdtDataModel.BaseDataModelInformation result = ctor.getTestInformationByLookup();
 
		// assert
		System.assertEquals(accc_DataCachingDataModel.TestLabel2018, result.Label);

	} // end of testgetTestInformationByLookup

	@isTest
	static void testfindByName() {
		// act/assign
		accc_DataCachingDataModel ctor = new accc_DataCachingDataModel();
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = ctor.findByName(accc_DataCachingDataModel.TestName2018);
		// assert
		System.assertEquals(accc_DataCachingDataModel.TestName2018, result[0].DeveloperName);
	} // end of testfindByName

	@isTest
	static void testfindByCategoryAndLabel() {
		// act/assign
		accc_DataCachingDataModel ctor = new accc_DataCachingDataModel();
		List<accc_BaseMdtDataModel.BaseDataModelInformation> result = ctor.findByCategoryAndLabel(accc_DataCachingDataModel.TestCategory, accc_DataCachingDataModel.TestLabel2018);
		// assert
		System.assertEquals(accc_DataCachingDataModel.TestLabel2018, result[0].Label);
	} // end of testfindByCategoryAndLabel

} // end of accc_DataCachingDataModelTest