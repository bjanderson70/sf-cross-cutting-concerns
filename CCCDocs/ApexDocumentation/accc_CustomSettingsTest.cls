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
 * @description  Custom Setting test
 * @group Common Test Layer
 */
@isTest
private class accc_CustomSettingsTest {

    @isTest
    static void testdefaultMaxNumberOfItemsInChunks() {
        // assign
        integer defaultSz = -1;
        // act
        defaultSz = accc_CustomSettings.defaultMaxNumberOfItemsInChunks();
        // assert
        system.assertEquals(accc_ApexConstants.DEFAULT_MAX_NUMBER_OF_ITEMS_IN_CHUNK, defaultSz);
    } // end of testdefaultMaxNumberOfItemsInChunks

    @isTest
    static void testtriggersAreEnable() {
        accc_CrossCuttingUtilityDataModel ctor = new accc_CrossCuttingUtilityDataModel();
        accc_CrossCuttingUtilityDataModel.CrossCuttingUtilityInformation info = ( accc_CrossCuttingUtilityDataModel.CrossCuttingUtilityInformation)ctor.getTestInformationByLookup();

        // assign
        boolean expected = info.triggersAreEnable;

        // act
        boolean result = accc_CustomSettings.triggersEnable();
        // assert
        system.assertEquals(expected , result);
    } // end of triggersAreEnable

    @isTest
    static void testcrossCuttingInformation() {
        // assign / act
        accc_CrossCuttingUtilityDataModel.CrossCuttingUtilityInformation result = accc_CustomSettings.crossCuttingInformation();
        // assert
        system.assertNotEquals(null, result);
    } // end of testcrossCuttingInformation

    @isTest
    static void testget() {
        // assign
        Object result = null;
        accc_IConfigurationProvider settings = new accc_CustomSettings();
        List<String> knowns = new List<String> {
            accc_ApexConstants.UseCachingStrategy_r,
            accc_ApexConstants.TriggersEnabled_r,
            accc_ApexConstants.MaxChunkSize_r,
            accc_ApexConstants.SoftAsserts_r,
            accc_ApexConstants.EnvironmentClass_r,
            accc_ApexConstants.TraceFlagOn_r,
            accc_ApexConstants.TraceLogLevel_r ,
            accc_ApexConstants.ShowCCTraceInfo_r
        };
        // act
        for ( String item : knowns ) {
            result = settings.get(item);
            // assert
            system.assertNotEquals(null, result);
        }

    } // end of testget

    @isTest
    static void testcaching() {
        // assign / act
        boolean result  = accc_CustomSettings.caching(accc_CrossCuttingUtilityDataModel.TestLabel2018);
        // assert
        system.assertEquals(true, result);

    } // end of testcaching

    @isTest
    static void testload() {
        // assign
        boolean result;
        accc_IConfigurationProvider settings = new accc_CustomSettings();

        // act
        result = settings.load();
        // assert
        system.assertEquals(true, result);

    } // end of testload

    @isTest
    static void testbadGetEntity() {
        // assign / act
        Object result  = accc_CustomSettings.getEntity(null);
        // assert
        system.assertEquals(null, result);

    } // end of testbadGetEntity


    @isTest
    static void testbadNameForGetEntity() {
        // assign /act
        Object result  = accc_CustomSettings.getEntity('null');
        // assert
        system.assertEquals(null, result);

    } // end of testbadNameForGetEntity

} // end of accc_CustomSettingsTest