/**
 * Copyright (c) 2016-2018, Bill Anderson. All rights reserved.
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
 * @description this logger does not write out anything. Assuming good test cases and performance testing,
 * this no op logger will save time of writes. However, in the event additional information is needed
 * consider the other 3 loggers (ApexObjectLogger, ApexPublishEventLogger and accc_ApexLogger). The
 * loggers can be changed via the custom metadata type 'Apex Code Configurations'.
 * @group Common Layer
 */
global without sharing class accc_ApexNoOpLogger extends accc_ApexLogger {
	///////////////////////////////////////////////////////////////////////////////////////////////
	//
	// CTORS
	///////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * @description default ctor of accc_ApexNoOpLogger -- set the LoggingLevel to DEBUG
	 */
	public accc_ApexNoOpLogger() {
		super(LoggingLevel.DEBUG);
	} // end of ctor

	/**
	 * @description ctor of ApexObject Logger
	 *
	 * @param level LoggingLevel to use for 'write'
	 */
	public accc_ApexNoOpLogger(LoggingLevel level) {
		super(level);
	} // end of ctor

	////////////////////////////////////////////////////////////////////////////////
	/// Protected methods
	////////////////////////////////////////////////////////////////////////////////

	/**
	 * @description write message
	 *
	 * @param level log-level
	 * @param message the message
	 */
	@TestVisible
	protected override void write(LoggingLevel level, Object message) {
		// Do Nothing
	} // end of write
	/**
	 * @description write messages
	 *
	 * @param level log-level
	 * @param messages the messages
	 */
	@TestVisible
	protected override void write(LoggingLevel level, List<Object> message) {
		// Do Nothing
	} // end of write
	/**
	 * @description write message
	 *
	 * @param level log-level
	 * @param message the message
	 * @param write to debug logger
	 */
	@TestVisible
	protected override void write(LoggingLevel level, Object message, boolean sendToLogger) {
		// Do Nothing
	} // end of write
	/**
	 * @description  do nothing on saving last message
	 *
	 * @param LoggingLevel log level
	 * @param String message
	 */
	@TestVisible
	protected override void setLastMessage(LoggingLevel level, String message) {
		// Do Nothing
	} // end of setLastMessage
} // end of accc_ApexNoOpLogger