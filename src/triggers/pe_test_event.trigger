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
	// only for testing -- no need to do anthing if someone mistakenly calls/users in production!
	if ( Test.isRunningTest() ) {
		accc_ApexUtilities.log('++++ TEST Trigger Called - pe_test__e');
		// defining the attribute is not neccessary ( as the default would have been used)
		// The one attribute changed,CHECK_EVENT_NAME_s, as we are certain of the name; no need to check
		Map<String, Object> attr = new Map<String, Object> {
			accc_PlatformEventAttrs.EVENT_LOGGING_s => accc_PlatformEventAttrs.EventLogging.ALL
			, accc_PlatformEventAttrs.RETRY_COUNT_s => 3
			, accc_PlatformEventAttrs.CHECK_EVENT_NAME_s => false // no need to check
			, accc_PlatformEventAttrs.ADD_INSTRUMENTATION_s => true
			, accc_PlatformEventAttrs.SERIALIZE_EVENTS_s => true
		};
		// [Did NOT need to create] could have used default ctor; just showing for completeness
		accc_PlatformEventAttrs attributes = new accc_PlatformEventAttrs(attr);
		// build create the handlers and  event processor
		accc_PlatformEvtBuilder theBuilder = new accc_PlatformEvtBuilder('pe_test__e', accc_ApexConstants.TEST_CATEGORY);
		// we want the consumer
		accc_IEventHandler consumer = theBuilder.buildConsumer();
		// build our platform event model [Note: 'attributes' is created above, but could have used default]
		accc_IPlatformEventModel model = theBuilder.build(consumer, attributes);
		// go handle/process our canonical form
		accc_ApexUtilities.log('++++ TEST Done pe_test__e result =' + model.process(Trigger.New));
	}
} // end of pe_test_event