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
 * @description defines the default process handlers ( log, success, error, alert). Each process
 * handler is responsible for different aspects of the platform event sequence. For example, when a platform
 * event goes into an alert phase (i.e. an exception occurred) do you want to alert (email, text) ?
 * Or, if an error occurs, it may be subtle enough that you ignore; however, if not, then you may wish to log.
 * While the log handler is more for logging the payload for a restart/redo of the event. For example, High Volume
 * you may NOT attempt to restart, though, Standard Event, you may want to place in a queuable process.
 *
 * It may appear that these handlers overlap, but it is better to have a separation than none at all!
 *
 * @group Common Layer
 */
public virtual without sharing class accc_DefaultProcessHandler implements accc_IProcessEventHandler {

	/////////////////////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////////////////////

	public static final String DEFAULT_NAME = 'Unknown';
	public static final String DEFAULT_LOG_NAME = 'Log Handler';
	public static final String DEFAULT_ALERT_NAME = 'Alert Handler';
	public static final String DEFAULT_ERROR_NAME = 'Error Handler';
	public static final String DEFAULT_SUCCESS_NAME = 'Success Handler';
	public static final String DEFAULT_STORE_NAME = 'Store Handler';

	@TestVisible
	string m_name = null;
	@TestVisible
	Exception m_exception = null;
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Ctors
	//
	/////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * @brief ctor
	 * @description ctor
	 *
	 */
	public accc_DefaultProcessHandler() {
		this(DEFAULT_NAME);
	} // end of ctor

	/**
	 * @brief ctor
	 * @description ctor
	 *
	 */
	public accc_DefaultProcessHandler(string name) {
		this.handlerName(name);
	} // end of ctor

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Public Methods
	//
	/////////////////////////////////////////////////////////////////////////////////////////

	/**
	* @description getter of the exception, if any
	*
	* @return the handler exception
	*/
	public Exception handlerException() {
		return this.caughtException;
	} // end of handlerException
	/**
	* @description set the handler name
	*
	* @return the handler name
	*/
	public String handlerName() {
		return this.m_name;
	}// end of handlerName
	/**
	 * @description set the handler name
	 *
	 * @param name string
	 */
	public void handlerName(String name) {
		this.m_name = String.isBlank(name) ? DEFAULT_NAME : name;
	}// end of handlerName
	/**
	 * @description process the log,error, success, alert, etc.
	 * @details [long description]
	 *
	 * @param parameter object to work on
	 * @param attributes platform attributes
	 *
	 * @return the object information
	 */
	public Object process(Object parameter, accc_PlatformEventAttrs attributes) {
		accc_PlatformEventAttrs attrs = attributes == null ? new accc_PlatformEventAttrs() : attributes;
		if ( parameter == null ) {
			this.caughtException = new accc_PlatformEventException('accc_DefaultProcessHandler.process requires valid data for all parameters [Object]');
			throw this.caughtException;
		}
		return this.childProcess(parameter, attrs);
	} // end of process

	/**
	 * @description override to String to show contents
	 * @return string of accc_DefaultProcessHandler contents
	 */
	public virtual override String toString() {

		return
		    'accc_DefaultProcessHandler\n' +
		    '{' + '\n' +
		    '   this.m_name       : ' + this.m_name + '\n' +
		    '   this.m_exception  : ' + this.m_exception + '\n' +
		    '}';
	} //  end of toString

	/**
	 * Any caught exception
	 */
	public Exception caughtException {
		get { return this.m_exception;}
		protected set { this.m_exception = value;}
	} // end of caughtException
	/**
	 * @description make the results from the list
	 *
	 * @param data collection of various data information on the event
	 * @return String
	 */
	public static String makeResultsFromList(List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> data) {
		String result = '****';
		if ( data != null) {
			result = '';
			integer count = data.size();
			for ( accc_DefaultPlatformEvent.PlatformEvtResultPOAC item : data) {
				result += count + ').' + item.toString() + '\n';
				count--;
				if ( count > 0 ) {
					result += '\n-----------------------\n';
				}
			}
		}
		return result;
	} // end of makeResultsFromList
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Protected Methods
	//
	/////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * @description Override this method if needed
	 *
	 * @param parameter data to the log,error, success, alert, etc.
	 * @param attributes  platform attributes
	 *
	 * @return object information
	 */
	@TestVisible
	protected virtual Object childProcess(Object parameter, accc_PlatformEventAttrs attributes) {
		String result = '';
		// clear exception
		this.caughtException = null;

		try {
			// valid data
			if ( parameter == null ) {
				// accc_DefaultProcessHandler Error: Calling "childProcess" with a NULL "parameter"'
				throw new NullPointerException();
			}
			List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> data = (List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> )parameter;
			String placeholder = '++++ MESSAGE ++++ [{0}] : accc_DefaultProcessHandler.childProcess called\n {1}';
			String results = accc_DefaultProcessHandler.makeResultsFromList(data);
			List<String> fillers = new String[] { this.handlerName(),  results };
			result = String.format(placeholder, fillers);

		} catch (Exception excp) {
			this.caughtException = new accc_PlatformEventException(excp);
			accc_PlatformEventLogger.myInstance().log('accc_DefaultProcessHandler - Exception: ' + excp.getMessage());
			throw this.caughtException;
		}
		accc_PlatformEventLogger.myInstance().log(result);

		return result;
	} // end of childProcess


	////////////////////////////////////////////////////////////////////////
	// Private Methods
	/////////////////////////////////////////////////////////////////////////


} // end of accc_DefaultProcessHandler