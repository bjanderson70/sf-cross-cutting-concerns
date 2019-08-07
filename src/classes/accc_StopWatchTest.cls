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
 * @description Used to clock time. A very rudimentary/simple encapsulation
 *  @group Common Test Layer
 */
@isTest
private class accc_StopWatchTest {
	@isTest
	static void testaccc_StopWatch() {
		// assign // act
		accc_StopWatch sw = new accc_StopWatch();
		// assert
		system.assertEquals(true, sw != null);
		system.assertEquals(true, sw.startTime != 0);
	} // end of testaccc_StopWatch

	@isTest
	static void teststartTime() {
		// assign // act
		accc_StopWatch sw = new accc_StopWatch();
		long result = sw.start();
		// assert
		system.assertEquals(true, sw != null);
		system.assertEquals(true, sw.startTime == result);
	} // end of teststartTime

	@isTest
	static void testreset() {
		// assign // act
		accc_StopWatch sw = new accc_StopWatch();
		sw.start();
		system.assertEquals(false, sw.startTime == 0);
		// act
		sw.reset();
		// assert
		system.assertEquals(true, sw != null);
		system.assertEquals(true, sw.startTime == 0);
	} // end of testreset

	@isTest
	static void testgetDuration() {
		// assign // act
		accc_StopWatch sw = new accc_StopWatch();
		system.assertEquals(false, sw.startTime == 0);
		for (integer inx = 0; inx < 100000; inx++) {
			// passig time
		}
		// act
		long duration = sw.getDuration();
		// assert
		system.assertEquals(true, sw != null);
		system.assertEquals(true, duration != 0);
	} // end of testgetDuration

	@isTest
	static void testtoString() {
		// assign // act
		accc_StopWatch sw = new accc_StopWatch();
		// assert
		system.assertEquals(true, sw != null);
		system.assertEquals(true, sw.toString() != null);
	} // end of testtoString


	@isTest
	static void testtoStringWithParam() {
		// assign // act
		accc_StopWatch sw = new accc_StopWatch();
		// act
		long duration = sw.getDuration();
		// assert
		system.assertEquals(true, sw != null);
		system.assertEquals(true, sw.toString(duration) != null);
	} // end of testtoStringWithParam

} // end of accc_StopWatchTest