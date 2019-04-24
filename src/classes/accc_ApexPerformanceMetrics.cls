/**
 * Copyright (c) 2016-2018, Bill anderson.  All rights reserved.
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
 * @description Encapsulates the functionality to determine performance based on the limits.
 * This is a simple performance mettric class. It performs a start and stop and reset; nothing more
 * gathering all the metrics. This is something you will enable on testing but not in production.
 *
 *
 * @group Common Layer
 **/
public without sharing class accc_ApexPerformanceMetrics {

	// our default user message
	public static final String PERF_MESSAGE = 'PerformanceMetrics';

	// our simple stop watch
	@TestVisible
	accc_StopWatch m_watch = new accc_StopWatch();
	// user message
	@TestVisible
	String m_message = null;

	public accc_ApexPerformanceMetrics() {
		this(PERF_MESSAGE);
	} // end of ctor
	/**
	 * @description ctor passing in the message to display along with the metrics
	 *
	 */
	public accc_ApexPerformanceMetrics(String userMessage) {
		this.message = userMessage;
	}// end of ctor
	/**
	 * @description get/set the message to display to the user upon calling toString
	 *
	 * @return message string
	 */
	public String message {
		get {
			return this.m_message;
		}
		set {
			this.m_message = !string.isBlank(value) ? value : PERF_MESSAGE;
		}
	} // end of message
	/**
	 * @description override the toString operation to get the result
	 *
	 * @return string of limits
	 */
	public override String toString() {
		String data = '++++ ' + this.message + ' ++++' + accc_ApexConstants.NewLine +
		              'Limits.getDMLRows:' + Limits.getDMLRows() + accc_ApexConstants.NewLine +
		              'Limits.getDMLStatements:' + Limits.getDMLStatements() + accc_ApexConstants.NewLine +
		              'Limits.getEmailInvocations:' + Limits.getEmailInvocations() + accc_ApexConstants.NewLine +
		              'Limits.getFutureCalls:' + Limits.getFutureCalls() + accc_ApexConstants.NewLine +
		              'Limits.getMobilePushApexCalls:' + Limits.getMobilePushApexCalls() + accc_ApexConstants.NewLine +
		              'Limits.getQueries:' + Limits.getQueries() + accc_ApexConstants.NewLine +
		              'Limits.getQueryLocatorRows: ' + Limits.getQueryLocatorRows() + accc_ApexConstants.NewLine +
		              'Limits.getQueryRows: ' + Limits.getQueryRows() +  accc_ApexConstants.NewLine +
		              'Limits.getQueueableJobs: ' + Limits.getQueueableJobs() + accc_ApexConstants.NewLine +
		              'Limits.getSoslQueries:' + Limits.getSoslQueries() + accc_ApexConstants.NewLine +
		              'Limits.getHeapSize:' + Limits.getHeapSize() + accc_ApexConstants.NewLine +
		              'Limits.getCpuTime:' + Limits.getCpuTime() + accc_ApexConstants.NewLine +
		              'Duration: ' + m_watch.toString();
		m_watch.reset();
		return data;
	}
} // end of accc_ApexPerformanceMetrics
