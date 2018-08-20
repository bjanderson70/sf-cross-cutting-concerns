/**
 * Copyright (c) 2016-2018, Bill Anderson  All rights reserved.
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
 * @description  External representation of the cross cutting concerns metadata. Providing a
 * wrapper around the internal data mapper allows one to vary the metadata w/o having to
 * change ALL dependencies. [Added layer of indirection to adjust for change]
 * @group Common Test Layer
 */
@isTest
private class accc_CrossCuttingConfigDataModelTest {
	
	@isTest
	static void testCtor() {
		// act/assign
		accc_CrossCuttingConfigDataModel ctor = new accc_CrossCuttingConfigDataModel();
		// assert
		System.assertNotEquals(ctor, null);
	} // end of testCtor

	@isTest
	static void testCtorWithName() {
		// act/assign
		accc_CrossCuttingConfigDataModel ctor = new accc_CrossCuttingConfigDataModel();
		// assert
		System.assertEquals(ctor.CustomMDTName, accc_CrossCuttingConfigDataModel.MDT_Name);
	} // end of testCtorWithName

	@isTest
	static void testfindByLabel() {
		// act/assign
		accc_CrossCuttingConfigDataModel ctor = new accc_CrossCuttingConfigDataModel();
		List<accc_BaseMdtDataModel.BaseDataModelInformation> results = (List<accc_BaseMdtDataModel.BaseDataModelInformation> )ctor.findByLabel(accc_ApexConstants.TEST_CATEGORY);
		// assert
		System.assertNotEquals(0, results.size());
	} // end of testfindByLabel

	@isTest
	static void testgetTestInformationByLookup() {
		// act/assign
		accc_CrossCuttingConfigDataModel ctor = new accc_CrossCuttingConfigDataModel();
		accc_BaseMdtDataModel.BaseDataModelInformation result = ctor.getTestInformationByLookup();
		// assert
		System.assertEquals(accc_ApexConstants.TEST_CATEGORY, result.Label);
	} // end of testgetTestInformationByLookup

	@isTest
	static void testfindByName() {
		// act/assign
		accc_CrossCuttingConfigDataModel ctor = new accc_CrossCuttingConfigDataModel();
		List<accc_BaseMdtDataModel.BaseDataModelInformation> results = (List<accc_BaseMdtDataModel.BaseDataModelInformation> )ctor.findByName(accc_ApexConstants.TEST_CATEGORY);
		accc_BaseMdtDataModel.BaseDataModelInformation result = results != null && results.size() > 0 ? results[0] : null;
		// assert
		System.assertEquals(accc_ApexConstants.TEST_CATEGORY, result.DeveloperName);
	} // end of testfindByName

	@isTest
	static void testfindByCategory() {
		// act/assign
		accc_CrossCuttingConfigDataModel ctor = new accc_CrossCuttingConfigDataModel();
		List<accc_BaseMdtDataModel.BaseDataModelInformation> results = (List<accc_BaseMdtDataModel.BaseDataModelInformation> )ctor.findByCategory(accc_ApexConstants.TEST_CATEGORY);
		accc_BaseMdtDataModel.BaseDataModelInformation result = results != null && results.size() > 0 ? results[0] : null;
		// assert
		System.assertEquals(accc_CrossCuttingConfigDataModel.CATEGORY_FIELD, ctor.categoryField);
		System.assertEquals(true, result != null);
	} // end of testfindByCategory

} // end of CrossCuttingConfigInformationTest