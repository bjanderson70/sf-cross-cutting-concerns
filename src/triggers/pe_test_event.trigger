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
 * @description test for platform event event -- This is ONLY used for TESTING!!! -- Do Not Delete
 * @group Test Layer
 */
trigger pe_test_event on pe_test__e (after insert) {
    // only for testing -- no need to do anthing if someone mistakenly calls in production!
    if ( accc_ApexConstants.UnitTestsRunning ) {
        accc_ApexUtilities.log('++++ TEST Trigger Called - pe_test__e');
        // defining the attribute is not neccessary ( as the default would have been used)
        // The one attribute changed,CHECK_EVENT_NAME_s, as we are certain of the name; no need to check
        //
        // Also note: via the attribute 'EVENT_PROCESSING_BATCH_SIZE_s' can control
        // how many SObjects you will process (handle). This allows you to control aspects
        // such as CPU, HEAP, DML Limits within a trigger by reducing the load. The trigger
        // will continue to be called ( assuming NO exceptions [ then you have to fix and save])
        // until the number of events are successfully processed/drained.
        //
        // Best Practice: Has all this functionality is provided to the user. However,
        // best practice is to INHERIT from 'accc_DefaultPEConsumer' and OVERRIDE at least
        // one method, 'consumePlatformEvent'. There you perform your work and return. You
        // DO NOT NEED to worry about setting the replay ids, exceptions, retries, etc. !
        //
        // The other method you may wish to override is 'handleCompletion'. This allows one
        // to perform any clean-up or what is needed to close out the processing. It is there
        // for use; otherwise, do not override.
        //
        // ************************************************************************************
        //
        // A sample Platform Event Consumer (and now you would TEST ONLY one METHOD -- 'consumePlatformEvent'):
        //
        // public with sharing class mySamplePEConsumer extends accc_DefaultPEConsumer {
        //
        //
        //   @TestVisible
        //   protected override boolean consumePlatformEvent(List<SObject> collectionOfEvents
        //                                                , accc_IProcessEventHandlers handlers
        //                                                , accc_PlatformEventAttrs attributes
        //                                                , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult
        //                                                , List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData) {
        //
        //       // PERFORM YOUR PROCESSING.
        //
        //		 // The 'collectionOfEvents' are the events (note, if you specified a Batch Size, via attributes), it will conform to that size
        //       // The 'handlers' can be used to send to the log, store information, alert, exception, ...
        //		 // The 'attributes' indicate informaiton on how to deal with events
        //		 // The 'errResult' allows you to write error information, if needed, the parent will handle the results appropriately
        //		 // The 'theLogData' logs information (similar to system.debug) but the sink is controlled by custom metadata
        //       // If all is ok, return true; otherwise return false
        //
        //       return true;
        //    } // end of consumePlatformEvent
        // } // end of mySamplePEConsumer
        // ************************************************************************************
        //
        // set the attributes to help control the steps/processes perform in the consumer
        // NOTE: some tests EXPECT the BATCH SIZE to be 10 !!!
        Map<String, Object> attr = new Map<String, Object> {
            accc_PlatformEventAttrs.EVENT_LOGGING_s => accc_PlatformEventAttrs.EventLogging.ALL
            , accc_PlatformEventAttrs.RETRY_COUNT_s => 9
            , accc_PlatformEventAttrs.CHECK_EVENT_NAME_s => false // no need to check
            , accc_PlatformEventAttrs.ADD_INSTRUMENTATION_s => true
            , accc_PlatformEventAttrs.SERIALIZE_EVENTS_s => true
            , accc_PlatformEventAttrs.EVENT_PROCESSING_BATCH_SIZE_s => 10
        };

        // [Did NOT need to create] could have used default ctor; just showing for completeness
        // ( however, some tests EXPECT the BATCH SIZE to be 10!!!)
        accc_PlatformEventAttrs attributes = new accc_PlatformEventAttrs(attr);
        // build  the handlers and  event processor
        accc_PlatformEvtBuilder theBuilder = new accc_PlatformEvtBuilder('pe_test__e', accc_ApexConstants.TEST_CATEGORY);
        // we want the consumer [Note, you how have your OWN then do not use the default below] ie,  accc_IEventHandler consumer =mySamplePEConsumer();
		// I would suggest implementing a factory of the consumers based on the event !
        accc_IEventHandler consumer = theBuilder.buildConsumer();
        // build our platform event model [Note: 'attributes' is created above, but could have used default], i.e, accc_IPlatformEventModel model = theBuilder.build (consumer);
        accc_IPlatformEventModel model = theBuilder.build(consumer, attributes);
        // go handle/process our canonical form
		// Note, we pass in the collection ( as this allows us to control out Unit tests)
        accc_ApexUtilities.log('++++ TEST Done pe_test__e result =' + model.process(Trigger.New));

    }
} // end of pe_test_event