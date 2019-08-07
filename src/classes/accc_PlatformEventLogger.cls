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
 * @author Bill Anderson
 * @description Platform Event Logger (Singleton for the public; not so for protected/children)
 * @group Logging
 */
public virtual without sharing class accc_PlatformEventLogger {

	/////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////

	public static final string CHECK_FOR_ACCC = 'SELECT COUNT() FROM ApexClass where name=\'accc_ApexUtilities\'';

	@TestVisible
	static final String PLATFORM_FORMAT = '++++ PL-EVT OUT ++++ [{0}] -- {1} ';
	@TestVisible
	static final String NILL_INFORMATION = ' (null) ' ;
	@TestVisible
	static List<String> m_logInformation = new List<String>();
	@TestVisible
	static accc_PlatformEventLogger m_instance ;


	/**
	 * @description static initialization
	 * 
	 */
	static {
		accc_PlatformEventLogger.m_instance = new accc_PlatformEventLogger();
	}
	/////////////////////////////////////////////////////////////////////////
	// Public Virtual Methods (for overriding)
	/////////////////////////////////////////////////////////////////////////

	/**
	 * @description log information (overridable)
	 *
	 * @param level Logging level
	 * @param message message to send out
	 */
	public virtual void log(LoggingLevel level, String message) {
		this.logToSystem(message);
	} // end of log
	/**
	 * @description format log information (overridable)
	 *
	 * @param level Logging level
	 * @param message message to send out
	 */
	public virtual String format(LoggingLevel level, String message) {
		return accc_PlatformEventLogger.formatForOutput(level, message);
	}
	/**
	 * @description log information
	 *
	 * @param message message to send out
	 */
	public virtual void log(String message) {
		// Integration w/ ACCC - need to figure a better way to integrate
		//
		this.logToSystem(message);
	} // end of log
	/**
	 * @description log exception
	 *
	 * @param message exception message to send out
	 */
	public virtual void log(Exception message) {
		if ( message != null ){
			this.logToSystem(message.getMessage());
		}
	} // end of log

	/**
	 * @description log information
	 *
	 * @param level Logging level
	 * @param message message to send out
	 */
	public virtual void logAsPlatformEvent(LoggingLevel level, String message) {
		this.logToSystem(message);
	} // end of logAsPlatformEvent

	/////////////////////////////////////////////////////////////////////////
	// Public Static Methods
	/////////////////////////////////////////////////////////////////////////

	public static accc_PlatformEventLogger myInstance() {

		return accc_PlatformEventLogger.m_instance;

	}// end of myInstance

	/////////////////////////////////////////////////////////////////////////
	// Protected Ctors
	/////////////////////////////////////////////////////////////////////////
	/**
	* @description ctor 
	*
	*/
	protected accc_PlatformEventLogger() {

	} // end of ctor

	/////////////////////////////////////////////////////////////////////////
	// Protected Methods
	/////////////////////////////////////////////////////////////////////////

	/////////////////////////////////////////////////////////////////////////
	// Private  Methods
	/////////////////////////////////////////////////////////////////////////

	/**
	 * @description Formats data for output
	 *
	 * @param level Logging level
	 * @param message message to send out
	 *
	 * @return String, formatted delimiter of '^'
	 */
	private static String formatForOutput(LoggingLevel level, String message) {
		String msg = string.isBlank(message) ? NILL_INFORMATION : message;
		List<String> fillers = new String[] {level.name(), msg };
		return String.format(PLATFORM_FORMAT, fillers);

	} // end of formatForOutput
		
	/**
	 * @description log information
	 *
	 * @param message message to send out
	 */
	@TestVisible
	private  void logToSystem(String message) {
		accc_ApexUtilities.log(message);
		if ( message != null ){
			accc_PlatformEventLogger.m_logInformation.add(message);
		}
	} // end of logToSystem
	/**
	 * @description getting the log container
	 *
	 * @return value string value
	 */
	@TestVisible
	private  String getInLog() {
		String data = '';
		if ( Test.isRunningTest() ) {
			data = String.join(accc_PlatformEventLogger.m_logInformation, '^');
		}
		return data;
	}

} // end of accc_PlatformEventLogger