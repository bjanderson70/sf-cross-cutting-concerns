/**
 * Copyright (c) 2016-2019, Bill anderson.  All rights reserved.
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
 *   * Neither the name of Bill anderson nor the names of its
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
 * @author Bill anderson
 * @description Encapsulates the simple performance metrics around timing and limits
 *
 * @group Test Layer
 **/
@isTest
private class accc_ApexPerformanceMetricsTest {
	@isTest
	static void testdefaultCtor() {
		// arrange / act
		accc_ApexPerformanceMetrics perf = new accc_ApexPerformanceMetrics();
		// assert
		system.assertEquals(true, perf.message == accc_ApexPerformanceMetrics.PERF_MESSAGE);

	}
	@isTest
	static void testCtorWithMessage() {
		// arrange / act
		accc_ApexPerformanceMetrics perf = new accc_ApexPerformanceMetrics('testCtorWithMessage');
		// assert
		system.assertEquals(true, perf.message == 'testCtorWithMessage');

	}

	@isTest
	static void testtoString() {
		// arrange / act
		accc_ApexPerformanceMetrics perf = new accc_ApexPerformanceMetrics('testCtorWithMessage');
		String theString = perf.toString();
		// assert
		system.assertEquals(true, perf.message == 'testCtorWithMessage');
		System.assertEquals(true, theString.contains('testCtorWithMessage'));
		System.assertEquals(true, theString.contains('getDMLRows'));
		System.assertEquals(true, theString.contains('getCpuTime'));
	}
} // end of accc_ApexPerformanceMetricsTest