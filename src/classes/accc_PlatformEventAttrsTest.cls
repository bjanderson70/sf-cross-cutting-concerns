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
 * @description unit test attributes
 * @group Common Test Layer
 */
@isTest
private class accc_PlatformEventAttrsTest {

    static final integer EXPECTED_ATTR_COUNT = 8;
    @isTest
    static void testGetterserializeData() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.SERIALIZE_EVENTS_s => false
        };
        // act
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
        Boolean ae = attrs.serializeData();
        // assert
        system.assertEquals(ae, false);
        system.assertEquals(true, attrs.instrumentation());

    }
    @isTest
    static void testGetterserializeDataNoPreset() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.ADD_INSTRUMENTATION_s => true
        };
        // act
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
        // assert
        system.assertEquals(true, attrs.serializeData());
        system.assertEquals(true, attrs.instrumentation());
    }
    @isTest
    static void testSetterserializeData() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.SERIALIZE_EVENTS_s => false
        };
        // act
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
        // assert
        System.assertEquals(false, attrs.serializeData());
        attrs.serializeData(true);
        // assert
        System.assertEquals(true, attrs.serializeData());

    }

    @isTest
    static void testGetterloggingStatus() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.EVENT_LOGGING_s => accc_PlatformEventAttrs.EventLogging.ALL
        };
        // act
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
        accc_PlatformEventAttrs.EventLogging ae = attrs.loggingStatus();
        // assert
        system.assertEquals(ae, accc_PlatformEventAttrs.EventLogging.ALL);
        system.assertNotEquals(ae, accc_PlatformEventAttrs.EventLogging.ON_SUCCESS);

    }
    @isTest
    static void testGetterloggingStatusNoPreset() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.ADD_INSTRUMENTATION_s => true
        };
        // act
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);

        // asseert
        system.assertEquals(accc_PlatformEventAttrs.EventLogging.ALL, attrs.loggingStatus());
        system.assertEquals(true, attrs.checkEvent());

    }
    @isTest
    static void testSetterloggingStatus() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.EVENT_LOGGING_s => accc_PlatformEventAttrs.EventLogging.ALL
        };
        // act
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
        attrs.loggingStatus(accc_PlatformEventAttrs.EventLogging.ON_SUCCESS);
        accc_PlatformEventAttrs.EventLogging ae = attrs.loggingStatus();
        // assert
        System.assertEquals(ae, accc_PlatformEventAttrs.EventLogging.ON_SUCCESS);

    }
    @isTest
    static void testGettercheckEvent() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.CHECK_EVENT_NAME_s => true
        };
        // act
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);

        // assert
        system.assertEquals(true, attrs.checkEvent());

    }
    @isTest
    static void testGettercheckEventNoPresets() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.ADD_INSTRUMENTATION_s => false
        };
        // act
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);

        // assert
        system.assertEquals(true, attrs.checkEvent());
        system.assertEquals(false, attrs.instrumentation());

    }
    @isTest
    static void testSettercheckEvent() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.CHECK_EVENT_NAME_s => false
        };
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
        // assert
        system.assertEquals(false, attrs.checkEvent());
        // act

        attrs.checkEvent(true);

        // assert
        system.assertEquals(true, attrs.checkEvent());
        system.assertEquals(true, attrs.instrumentation());

    }
    @isTest
    static void testGetterinstrumentation() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.ADD_INSTRUMENTATION_s => true
        };
        // act
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);

        // assert
        system.assertEquals(true, attrs.instrumentation());


    }
    @isTest
    static void testGetterinstrumentationNoPreset() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.CHECK_EVENT_NAME_s => false
        };
        // act
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);

        // assert
        system.assertEquals(true, attrs.instrumentation());
        system.assertEquals(false, attrs.checkEvent());


    }
    @isTest
    static void testSetterinstrumentation() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.ADD_INSTRUMENTATION_s => false
        };

        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
        // assert
        system.assertEquals(false, attrs.instrumentation());
        // act
        attrs.instrumentation(true);

        // assert
        system.assertEquals(true, attrs.instrumentation());


    }
    @isTest
    static void testGetterallowretryNoPreset() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.ALLOW_RETRY_AFTER_EXCEPTION_s => false
        };
        // act
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);

        Boolean ce = attrs.allowRetryAfterException();
        // assert
        system.assertEquals(ce, false);


    }
    @isTest
    static void testSetterallowretry() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.ALLOW_RETRY_AFTER_EXCEPTION_s => false
        };

        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
        Boolean ctorStatus = attrs.allowRetryAfterException();
        // act

        attrs.allowRetryAfterException(true);

        // assert
        system.assertEquals(true, attrs.allowRetryAfterException());
        system.assertEquals(false, ctorStatus);

    }
    @isTest
    static void testGetterretryCount() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.RETRY_COUNT_s => 1
        };

        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
        // actt
        Integer ce = attrs.retryCount();
        // asser
        system.assertEquals(1, ce);
        system.assertNotEquals(2, ce);

    }
    @isTest
    static void testGetterretryCountNoPreset() {
        // assign
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs();
        //act
        Integer ce = attrs.retryCount();
        // assert
        system.assertEquals(ce, accc_PlatformEventAttrs.DEFAULT_RETRY_COUNT);

    }
    @isTest
    static void testSetterretryCount() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.RETRY_COUNT_s => 1
        };
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);

        attrs.retryCount(accc_PlatformEventAttrs.RETRY_COUNT_MAX + 1);
        //act
        Integer ce = attrs.retryCount();
        // assert
        system.assertEquals(ce, accc_PlatformEventAttrs.RETRY_COUNT_MAX);
        system.assertNotEquals(ce, accc_PlatformEventAttrs.RETRY_COUNT_MAX + 1);
        // act
        attrs.retryCount(-1);
        ce = attrs.retryCount();
        // assert
        system.assertEquals(1, ce);

    }
    @isTest
    static void testget() {
        // assign
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs();
        // act
        Object ce = attrs.get(null);
        // assert
        system.assertEquals(null, ce);

    }
    @isTest
    static void testput() {
        // assign
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs();
        // act
        Boolean rce = (Boolean)attrs.put(null, 1);
        // assert
        system.assertEquals(rce, false);
        system.assertNotEquals(rce, true);
        // act
        attrs.put('test', 1);
        integer ce = (integer)attrs.get('test');
        // assert
        system.assertEquals(1, ce);


    }
    @isTest
    static void testgetAttributes() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.RETRY_COUNT_s => 1
        };
        Map<String, Object> copyAttrs = null;
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
        // act
        copyAttrs = attrs.getAttributes();
        // assert
        system.assertEquals(EXPECTED_ATTR_COUNT, copyAttrs.size());
        system.assertEquals(1, (integer)copyAttrs.get(accc_PlatformEventAttrs.RETRY_COUNT_s));

    }

    @isTest
    static void teststoreEvent() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.EVENT_STORING_s => true
        };

        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
        // act
        Boolean ce = attrs.storeEvent();
        // asser
        system.assertEquals(true, ce);
        attrs.storeEvent(false);
        system.assertNotEquals(false, ce);

    }
    /// Event Batch Size

    @isTest
    static void testGetterBatchSizeCount() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.EVENT_PROCESSING_BATCH_SIZE_s => 1
        };

        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);
        // actt
        Integer ce = attrs.eventBatchSize();
        // asser
        system.assertEquals(1, ce);
        system.assertNotEquals(2, ce);

    }
    @isTest
    static void testGetterBatchSizeCountNoPreset() {
        // assign
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs();
        //act
        Integer ce = attrs.eventBatchSize();
        // assert
        system.assertEquals(ce, accc_PlatformEventAttrs.DEFAULT_EVENT_BATCH_SIZE);

    }
    @isTest
    static void testSetterEventBatchSizeCount() {
        // assign
        Map<String, Object> attributes = new Map<String, Object> {
            accc_PlatformEventAttrs.EVENT_PROCESSING_BATCH_SIZE_s => 1
        };
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs(attributes);

        attrs.eventBatchSize(accc_PlatformEventAttrs.MAX_EVENT_BATCH_SIZE + 1);
        //act
        Integer ce = attrs.eventBatchSize();
        // assert
        system.assertEquals(ce, accc_PlatformEventAttrs.MAX_EVENT_BATCH_SIZE);
        system.assertNotEquals(ce, accc_PlatformEventAttrs.MAX_EVENT_BATCH_SIZE + 1);
        // act
        attrs.eventBatchSize(-1);
        ce = attrs.eventBatchSize();
        // assert
        system.assertEquals(accc_PlatformEventAttrs.MIN_EVENT_BATCH_SIZE, ce);

    }
}