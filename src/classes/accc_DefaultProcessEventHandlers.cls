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
 * @description define the default implementation of the core platform event event handlers container
 * @group Common  Layer
 */
public without sharing class accc_DefaultProcessEventHandlers implements accc_IProcessEventHandlers {

	/////////////////////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////////////////////

	// use to index into the user-defined name
	enum Handler_Type {
		LOG,
		ERROR,
		SUCCESS,
		ALERT,
		STORE
	}
	// default handlers and names
	@TestVisible
	static Map<String, accc_IProcessEventHandler> m_DefaultHandlers = new  Map<String, accc_IProcessEventHandler> {
		accc_DefaultProcessHandler.DEFAULT_LOG_NAME => new accc_DefaultProcessHandler(accc_DefaultProcessHandler.DEFAULT_LOG_NAME)
		, accc_DefaultProcessHandler.DEFAULT_ERROR_NAME => new accc_DefaultProcessHandler(accc_DefaultProcessHandler.DEFAULT_ERROR_NAME)
		, accc_DefaultProcessHandler.DEFAULT_SUCCESS_NAME => new accc_DefaultProcessHandler(accc_DefaultProcessHandler.DEFAULT_SUCCESS_NAME)
		, accc_DefaultProcessHandler.DEFAULT_ALERT_NAME => new accc_DefaultProcessHandler(accc_DefaultProcessHandler.DEFAULT_ALERT_NAME)
		, accc_DefaultProcessHandler.DEFAULT_STORE_NAME => new accc_DefaultProcessHandler(accc_DefaultProcessHandler.DEFAULT_STORE_NAME)
	};
	// user-defined handlers ( initially, same as default)
	@TestVisible
	static Map<String, accc_IProcessEventHandler> m_DefineHandlers = new  Map<String, accc_IProcessEventHandler>(m_DefaultHandlers);
	// user reference type to find user-defined name
	static Map<Handler_Type, String> m_referenceByType = new Map<Handler_Type, String>();
	/////////////////////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * @brief ctor
	 * @description ctor
	 *
	 */
	public accc_DefaultProcessEventHandlers() {
		this(null, null, null, null, null);
	} // end of ctor
	/**
	 * @description ctor (chaining to account for various handlers)
	 *
	 */
	public accc_DefaultProcessEventHandlers(accc_IProcessEventHandler theLogHandler) {
		this(theLogHandler, null, null, null, null);
	} // end of ctor

	public accc_DefaultProcessEventHandlers(accc_IProcessEventHandler theLogHandler
	                                       , accc_IProcessEventHandler theErrorHandler) {
		this(theLogHandler, theErrorHandler, null, null, null);
	} // end of ctor

	public accc_DefaultProcessEventHandlers(accc_IProcessEventHandler theLogHandler
	                                       , accc_IProcessEventHandler theErrorHandler
	                                       , accc_IProcessEventHandler theSuccessHandler) {
		this(theLogHandler, theErrorHandler, theSuccessHandler, null, null);
	} // end of ctor

	public accc_DefaultProcessEventHandlers(accc_IProcessEventHandler theLogHandler
	                                       , accc_IProcessEventHandler theErrorHandler
	                                       , accc_IProcessEventHandler theSuccessHandler
	                                       , accc_IProcessEventHandler theAlertHandler ) {
		this(theLogHandler, theErrorHandler, theSuccessHandler, theAlertHandler, null);
	}// end of ctor

	public accc_DefaultProcessEventHandlers(accc_IProcessEventHandler theLogHandler
	                                       , accc_IProcessEventHandler theErrorHandler
	                                       , accc_IProcessEventHandler theSuccessHandler
	                                       , accc_IProcessEventHandler theAlertHandler
	                                       , accc_IProcessEventHandler theStoreHandler ) {
		accc_IProcessEventHandler myLogHandler = theLogHandler == null ? m_DefaultHandlers.get(accc_DefaultProcessHandler.DEFAULT_LOG_NAME) : theLogHandler;
		accc_IProcessEventHandler myErrorHandler = theErrorHandler == null ? m_DefaultHandlers.get(accc_DefaultProcessHandler.DEFAULT_ERROR_NAME) : theErrorHandler;
		accc_IProcessEventHandler mySuccessHandler = theSuccessHandler == null ? m_DefaultHandlers.get( accc_DefaultProcessHandler.DEFAULT_SUCCESS_NAME ) : theSuccessHandler;
		accc_IProcessEventHandler myAlertHandler = theAlertHandler == null ? m_DefaultHandlers.get(accc_DefaultProcessHandler.DEFAULT_ALERT_NAME) : theAlertHandler;
		accc_IProcessEventHandler myStoreHandler = theStoreHandler == null ? m_DefaultHandlers.get( accc_DefaultProcessHandler.DEFAULT_STORE_NAME ) : theStoreHandler;

		m_DefineHandlers.put(myAlertHandler.handlerName().toLowerCase(), myAlertHandler);
		m_DefineHandlers.put(mySuccessHandler.handlerName().toLowerCase(), mySuccessHandler);
		m_DefineHandlers.put(myErrorHandler.handlerName().toLowerCase(), myErrorHandler);
		m_DefineHandlers.put(myLogHandler.handlerName().toLowerCase(), myLogHandler);
		m_DefineHandlers.put(myStoreHandler.handlerName().toLowerCase(), myStoreHandler);

		m_referenceByType.put(Handler_Type.LOG, myLogHandler.handlerName().toLowerCase());
		m_referenceByType.put(Handler_Type.STORE, myStoreHandler.handlerName().toLowerCase());
		m_referenceByType.put(Handler_Type.ERROR, myErrorHandler.handlerName().toLowerCase());
		m_referenceByType.put(Handler_Type.SUCCESS, mySuccessHandler.handlerName().toLowerCase());
		m_referenceByType.put(Handler_Type.ALERT, myAlertHandler.handlerName().toLowerCase());

	} // end of ctor

	/////////////////////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////////////////////

	// getters

	// log information on the event
	public accc_IProcessEventHandler logHandler() {
		return accc_DefaultProcessEventHandlers.m_DefineHandlers.get(m_referenceByType.get(Handler_Type.LOG));
	}
	// process errors
	public accc_IProcessEventHandler errorHandler() {
		return accc_DefaultProcessEventHandlers.m_DefineHandlers.get(m_referenceByType.get(Handler_Type.ERROR));
	}
	// process successes
	public accc_IProcessEventHandler successHandler() {
		return accc_DefaultProcessEventHandlers.m_DefineHandlers.get(m_referenceByType.get(Handler_Type.SUCCESS));
	}
	// process alerts/notifcations
	public accc_IProcessEventHandler alertHandler() {
		return accc_DefaultProcessEventHandlers.m_DefineHandlers.get(m_referenceByType.get(Handler_Type.ALERT));
	}
	// process store handler
	public accc_IProcessEventHandler storeHandler() {
		return accc_DefaultProcessEventHandlers.m_DefineHandlers.get(m_referenceByType.get(Handler_Type.STORE));
	}
	/**
	 * @description find the process event handler by name
	 *
	 * @param name name stored as (default names found here 'accc_DefaultProcessHandler' )
	 * @return accc_IProcessEventHandler, porcess event handler
	 */
	public static accc_IProcessEventHandler defaultHandlerByName(String name) {
		accc_IProcessEventHandler result = null;
		if ( !string.isBlank(name)) {
			String lcName = name.toLowerCase();
			accc_IProcessEventHandler current = null;
			
			for ( String item : accc_DefaultProcessEventHandlers.m_DefineHandlers.keyset() ) {
				current = accc_DefaultProcessEventHandlers.m_DefineHandlers.get(item);
				if (  current.handlerName() == lcName ) {
					result = current;
					break;
				}
			}
		}
		return result;
	} // end of defaultHandlerByName

} // end of accc_DefaultProcessEventHandlers