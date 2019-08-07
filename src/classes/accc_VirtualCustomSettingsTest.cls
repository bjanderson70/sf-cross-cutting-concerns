/**
 * Copyright (c) 2016-2019, Bill Anderson  All rights reserved.
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
 * @description  Virtual Custom Setting test
 * @group Common Test Layer
 */
@isTest
private class accc_VirtualCustomSettingsTest {

    static final string TestNameForEnvClass = 'accc_TestEnvironmentSingleton';
    static final integer MyMaxChunkSize = 10;

    // test the virtual/override of the class
    public class testCustomSettings extends accc_VirtualCustomSettings {

        public override Boolean load() {
            return true;
        } // end of load


        public override Object get(String name) {
            return name;
        } // end of get

        public override  boolean caching (String label) {
            return !string.isBlank(label);
        } // end of caching

        public override boolean triggersEnable() {
            return false;
        } // end of triggersEnable


        public override boolean useCachingStrategy() {
            return false;
        } // end of useCachingStrategy

        public override String environmentClass() {
            return TestNameForEnvClass;
        } // end of environmentClass

        /**
         *
         * @description default max. number of items in a chunk/packet sent to external systems (via apex batch)
         * @return default size
         */
        public override integer defaultMaxNumberOfItemsInChunks() {
            return MyMaxChunkSize;
        } // end of environmentClass
    } // end of testCustomSettings

    @isTest
    static void testload() {
        // assign
        boolean result;
        accc_VirtualCustomSettings settings = new accc_VirtualCustomSettings();

        // act
        result = settings.load();
        // assert
        system.assertEquals(true, result);
    } // end of testload

    @isTest
    static void testget() {
        // assign
        Object result = null;
        accc_VirtualCustomSettings settings = new accc_VirtualCustomSettings();
        // these are the default setting in 'test' custom metadata. if these are CHANGED
        // in the MDT, then some of these tests will FAIL.
        //
        Map<String, Object> knowns = new Map<String, Object> {
            accc_ApexConstants.UseCachingStrategy_r => true
            , accc_ApexConstants.TriggersEnabled_r => true
            , accc_ApexConstants.MaxChunkSize_r => accc_ApexConstants.DEFAULT_MAX_NUMBER_OF_ITEMS_IN_CHUNK
            , accc_ApexConstants.SoftAsserts_r => false
            , accc_ApexConstants.EnvironmentClass_r => TestNameForEnvClass
            , accc_ApexConstants.TraceFlagOn_r => true
           // , accc_ApexConstants.TraceLogLevel_r => LoggingLevel.FINER
            , accc_ApexConstants.ShowCCTraceInfo_r => true
        };
        // act
        for ( String key : knowns.keyset() ) {
            result = settings.get(key);
            // assert
            system.assertEquals(knowns.get(key), result);
        }
    } // end of testget

    @isTest
    static void testActions() {
        // assign
        final string key = '!hello!';
        accc_VirtualCustomSettings settings = new accc_VirtualCustomSettings();
        // act / assert
        system.assertEquals(false, settings.caching(key));
        system.assertEquals(true, settings.triggersEnable());
        system.assertEquals(true, settings.useCachingStrategy());
        system.assertEquals(TestNameForEnvClass, settings.environmentClass());
        system.assertEquals(accc_ApexConstants.DEFAULT_MAX_NUMBER_OF_ITEMS_IN_CHUNK,  settings.defaultMaxNumberOfItemsInChunks());

        system.assertEquals(true, settings.showCCTraceInfo());
       // system.assertEquals(LoggingLevel.FINER, settings.traceLogLevel());
        system.assertEquals(true, settings.traceFlagOn());
    } // end of testActions

    @isTest
    static void testClassOverrides() {
        // assign
        final string expected = 'hello';
        accc_VirtualCustomSettings settings = new testCustomSettings();
        // act / assert
        system.assertEquals(expected, settings.get(expected));
        system.assertEquals(true, settings.caching(expected));
        system.assertEquals(false, settings.triggersEnable());
        system.assertEquals(false, settings.useCachingStrategy());
        system.assertEquals(TestNameForEnvClass, settings.environmentClass());
        system.assertEquals(MyMaxChunkSize,  settings.defaultMaxNumberOfItemsInChunks());
    } // end of testClassOverrides

    @isTest
    static void testGetModels() {
        // assign
        accc_VirtualCustomSettings settings = new testCustomSettings();
        // act / assert
        system.assertNotEquals(null, settings.cachingModel());
        system.assertNotEquals(null, settings.crossCuttingConfigModel());
        system.assertNotEquals(null, settings.crossCuttingUtilityModel());

    } // end of testGetModels


} // end of accc_VirtualCustomSettingsTest