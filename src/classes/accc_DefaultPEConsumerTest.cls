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
 * @description defines the consumer platform event test
 * @group Test Layer
 */
@isTest
private class accc_DefaultPEConsumerTest {
    static final String ExceptedEventLabelInCustomMDT = 'pe_test__e';

    // class to excercise the default consumer
    public class accc_ConsumerTest extends accc_DefaultPEConsumer {
        public Boolean didHandle = false;
        public boolean throwException = false;
        public Integer consumedEvents = 0;

        public accc_ConsumerTest() {

            super(null);

        }
        public accc_ConsumerTest(string evt) {

            super(evt);

        }
        public accc_ConsumerTest(string evt, Boolean serialization) {

            super(evt,serialization);

        }
        protected override void handleCompletion(List<SObject> events
                                                 , Boolean state
                                                 , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult
                                                 , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theData
                                                 , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData
                                                 , accc_PlatformEventAttrs attributes) {
            didHandle = true;
        }
        protected override boolean consumePlatformEvent(List<SObject> parameter,
                                                        accc_IProcessEventHandlers handlers,
                                                        accc_PlatformEventAttrs attributes,
                                                        List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult,
                                                        List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData) {
            consumedEvents = 0;
            if ( this.throwException) {
                throw new EventBus.RetryableException('accc_ConsumerTest');
            }
            consumedEvents = parameter.size();
            return true;

        } // end of accc_ConsumerTest
    }

    @isTest
    static void testBasicConsumerCtor() {
        // assign / act
        accc_ConsumerTest consumer = new accc_ConsumerTest();
        // assert
        System.assertEquals(true, consumer.handlerEventName() == null);
        System.assertEquals(true, consumer.handlerToSerialize() == true);

    }
    @isTest
    static void testBasicConsumerCtorWithSerialization() {
        // assign / act
        final String name = 'mytest_pe';
        accc_ConsumerTest consumer = new accc_ConsumerTest(name,true);
        // assert
        System.assertEquals(true, consumer.handlerEventName() == name);
        System.assertEquals(true, consumer.handlerToSerialize() == true);

    }
    @isTest
    static void testBasicConsumerCtorWithJustEvent() {
        // assign / act
        final String name = 'mytest_pe';
        accc_ConsumerTest consumer = new accc_ConsumerTest(name);
        // assert
        System.assertEquals(true, consumer.handlerEventName() == name);
        System.assertEquals(true, consumer.handlerToSerialize() == true);

    }
    @isTest
    static void testBasicConsumer() {

        final String eventName = ExceptedEventLabelInCustomMDT;
        Boolean result;
        accc_PlatformEvtBuilder ctor = new accc_PlatformEvtBuilder(eventName, accc_ApexConstants.TEST_CATEGORY);
        accc_IEventHandler Consumer = ctor.buildConsumer();
        List<SObject> evt = new List<SObject> { new pe_test__e()};
        accc_DefaultProcessEventHandlers handlers = new accc_DefaultProcessEventHandlers();
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs();

        Test.startTest();
        // Consumer test event
        result = Consumer.process(evt, handlers, attrs);
        Test.stopTest();

        // Verify results value
        System.assertEquals(true, result);

    }
    @isTest
    static void testConsumerTest() {

        final String eventName = ExceptedEventLabelInCustomMDT;
        Boolean result;
        accc_ConsumerTest Consumer = new accc_ConsumerTest(eventName);
        accc_DefaultProcessEventHandlers handlers = new accc_DefaultProcessEventHandlers();
        List<SObject> evt = new List<SObject> { new pe_test__e()};
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs();

        Test.startTest();
        // Consumer test event
        result = Consumer.process(evt, handlers, attrs);
        Test.stopTest();

        // Verify SaveResult value
        System.assertEquals(true, result);
        System.assertEquals(true, Consumer.eventName == eventName);
        System.assertEquals(true, Consumer.didHandle);
    }
    @isTest
    static void testConsumerTestNoEvent() {

        final String eventName = ExceptedEventLabelInCustomMDT;
        Boolean result;
        accc_ConsumerTest Consumer = new accc_ConsumerTest(eventName);
        accc_DefaultProcessEventHandlers handlers = new accc_DefaultProcessEventHandlers();
        List<SObject> evt = new List<SObject> { };
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs();

        Test.startTest();
        try {
            // Consumer test event
            result = Consumer.process(evt, handlers, attrs);
        } catch (Exception excp) {
            result = false;
        }
        Test.stopTest();

        // Verify results
        System.assertEquals(false, result);
        System.assertEquals(true, Consumer.eventName == eventName);
        System.assertEquals(false, Consumer.didHandle);
    }

    @isTest
    static void testEventTrigger() {
        String logData = '';
        Test.startTest();
        Test.enableChangeDataCapture();
        List<pe_Test__e> pe = new List<pe_test__e> { new pe_test__e()};
        EventBus.publish(pe);
        Test.getEventBus().deliver();
        Test.stopTest();

        // check the log
        System.assertEquals(true, accc_ApexUtilities.containsInTestLog('++++ TEST Done pe_test__e result =true'));
    }

    @isTest
    static void testConsumerTestCauseThrow() {

        final String eventName = ExceptedEventLabelInCustomMDT;
        Boolean result = true;
        accc_ConsumerTest Consumer = new accc_ConsumerTest(eventName);
        accc_DefaultProcessEventHandlers handlers = new accc_DefaultProcessEventHandlers();
        List<SObject> evt = new List<SObject> {new pe_test__e() };
        accc_PlatformEventAttrs attrs = new accc_PlatformEventAttrs();
        integer count = 1;
        Consumer.throwException = true;

        Test.startTest();
        while ( Consumer.throwException == true) {
            try {

                // Consumer test event
                result = Consumer.process(evt, handlers, attrs);

            } catch ( EventBus.RetryableException retryExcp) {
                Consumer.throwException = false;
            } catch (Exception excp) {
                result = false;
                Consumer.throwException = false;
            }
        }


        Test.stopTest();

        // Verify results
        System.assertEquals(true, result);
        System.assertEquals(true, Consumer.eventName == eventName);
        System.assertEquals(true, Consumer.didHandle);
    }

    @isTest
    static void testConsumerTestEventBatchSizeCauseRetry() {

        // This test has to PUBLISH the events ( via EventBus.publish)
        // bec/ the test trigger ( pe_test_event) has the batch size == 10
        // we will process increments of 10 ( thus, 2 passes in the handler)
        List<SObject> evt = new List<SObject>();
        final Integer NUM_EVTS = 20;
        // set to 20 bec/ within the test trigger ( pe_test_event) the  batch size == 10!!
        for ( integer inx=0; inx < NUM_EVTS; inx++) {
            evt.add(new pe_test__e());
        }
      
        Test.startTest();
        // act ( publish)
        List<Database.SaveResult>results=EventBus.publish(evt);
        // validate ALL were sent.
        for (Database.SaveResult sr : results) {
            System.assertEquals(true, sr.isSuccess());
        }
        // deliver the first 10
        Test.getEventBus().deliver();
 
        // Get old position of this subscriber
        EventBusSubscriber subOld =
        [SELECT Name, Position, Topic
         FROM EventBusSubscriber
         WHERE Topic='pe_test__e' AND Name='pe_test_event'];
       
        // Verify results ( first 10 processed)
        System.assertEquals(NUM_EVTS/2,subOld.Position);
        // process the next 10 items
        Test.getEventBus().deliver();
        // VERIFICATION of last position
        // Get new position of this subscriber
        EventBusSubscriber subNew =
        [SELECT Name, Position, Topic
         FROM EventBusSubscriber
         WHERE Topic='pe_test__e' AND Name='pe_test_event'];
        System.assertEquals(NUM_EVTS, subNew.Position);

        Test.stopTest();
    }


    @isTest
    static void testformatRetryMessage() {
        String msg = 'testing [{0}]', result, expected = 'testing [5]';
        integer retryCount = 5;
        accc_ConsumerTest consumer = new accc_ConsumerTest();
        system.assertEquals(expected, consumer.formatRetryMessage(msg, retryCount));
    }
    @isTest
    static void testformatRetryMessageWithNull() {
        String msg = null, result, expected = 'Platform Event message [5]';
        integer retryCount = 5;
        accc_ConsumerTest consumer = new accc_ConsumerTest();
        system.assertEquals(expected, consumer.formatRetryMessage(msg, retryCount));
    }
    @isTest
    static void testformatRetryMessageWithSingleInteger() {
        String msg = null, result, expected = 'Platform Event condition is not met, so retrying the trigger again [5]';
        integer retryCount = 5;
        accc_ConsumerTest consumer = new accc_ConsumerTest();
        system.assertEquals(expected, consumer.formatRetryMessage(retryCount));
    }

}