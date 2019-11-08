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
 * @description This class is called when an event is needed to be logged.
 *
 * @group Common Layer
 */
public virtual without sharing class accc_DefaultProcessLogHandler  extends accc_DefaultProcessHandler {


	////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////

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
	public accc_DefaultProcessLogHandler() {
		super(accc_DefaultProcessHandler.DEFAULT_LOG_NAME);
	} // end of ctor

	/**
	 * @brief ctor
	 * @description ctor
	 *
	 */
	public accc_DefaultProcessLogHandler(string name) {
		super(name);
	} // end of ctor
	/**
	* @description override to String to show contents
	* @return string of accc_DefaultProcessHandler contents
	*/
	public  override String toString() {

		return
		    super.toString() + '\n' +
		    'accc_DefaultProcessLogHandler\n' +
		    '{' +
		    '\n' +
		    '}';
	} //  end of toString
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
	protected override Object childProcess(Object parameter, accc_PlatformEventAttrs attributes) {
		String result = '';
		this.caughtException = null;

		try {
			if ( parameter == null ) {
				throw new NullPointerException();
			}
			
			List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> data = (List<accc_DefaultPlatformEvent.PlatformEvtResultPOAC> )parameter;

			String placeholder = '++++ MESSAGE ++++ [{0}] : accc_DefaultProcessStoreHandler.childProcess called\n {1}';
			String results = accc_DefaultProcessHandler.makeResultsFromList(data);
			List<String> fillers = new String[] { this.handlerName(),  results };
			result = String.format(placeholder, fillers);

			accc_ApexUtilities.log(result);
			List<String> items = new List<String>();

			if ( data != null ) {
				integer size = data.size();
				for ( integer inx = 0; inx < size; ++inx ) {
					items.add(data[inx].toString());
				}
				result = String.join(items, '\n++++++++++++++++\n');
			}
			accc_ApexUtilities.log(result);

		} catch (Exception excp) {
			this.caughtException = excp;
			result = excp.getMessage();
			accc_ApexUtilities.log(excp);
		}

		return result;
	} // end of childProcess

} // end of accc_DefaultProcessLogHandler