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
 * @description attributes for the pub/sub of platform events
 * @group Common Layer
 */
public  without sharing  class accc_PlatformEventAttrs {

	/////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////

	public static final String SERIALIZE_EVENTS_s = 'SerializeEvents';
	public static final String EVENT_LOGGING_s = 'EventLogging';
	public static final String RETRY_COUNT_s = 'RetryEvent';
	public static final String CHECK_EVENT_NAME_s = 'CheckEventName';
	public static final String ADD_INSTRUMENTATION_s = 'Instrumentation';
	public static final String ALLOW_RETRY_AFTER_EXCEPTION_s = 'AllowRetry';
	public static final String COMPRESS_EVENT_FOR_STORAGE_s = 'CompressEventForStorage';
	public static final String EVENT_STORING_s = 'EventStoring';

	public static final integer DEFAULT_RETRY_COUNT = 5;
	public static final integer RETRY_COUNT_MAX = 9;

	public  enum EventLogging {
		ALL,
		ON_ERROR,
		ON_SUCCESS,
		ON_LOG
	}
	// holds attributes for the platform events
	private Map<String, Object> m_attributes;


	/////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////
	/**
	 * @description default ctor
	 *
	 */
	public accc_PlatformEventAttrs() {
		this.setAttributes(accc_PlatformEventAttrs.getDefaultAttributes());
	}
	/**
	 * @brief ctor
	 * @details initiate the platform events
	 *
	 * @param attributes mapped collection
	 */
	public accc_PlatformEventAttrs(Map<String, Object> attributes) {
		this.setAttributes(attributes);
	}

	/////////////////////////////////////////////////////////////////////////
	// Properties (Syntactic Sugar) getter/setters
	/////////////////////////////////////////////////////////////////////////

	/**
	* @description turn on audit or no -- audit saves the json of the parameters
	* @return Boolean, default false
	*/
	public Boolean serializeData() {

		Object result = this.get(SERIALIZE_EVENTS_s);
		Boolean defaultValue = false;

		if ( result != null && result instanceof Boolean) {
			defaultValue = (Boolean)result;
		}
		return defaultValue;
	}// end of serializeData
	/**
	* @description Setter to turn on audit or no
	*/
	public void serializeData(Boolean serializeTheData) {
		this.put(SERIALIZE_EVENTS_s, serializeTheData);
	} // end of serializeData
	/**
	* @description when to log
	* @return EventLogging, default EventLogging.ON_ERROR
	*/
	public EventLogging loggingStatus() {
		Object result = this.get(EVENT_LOGGING_s);
		EventLogging defaultValue = EventLogging.ON_ERROR;

		if ( result != null && result instanceof EventLogging) {
			defaultValue = (EventLogging)result;
		}
		return defaultValue;
	} // end of loggingStatus
	/**
	* @description Setter configure how to handle event log
	*/
	public void loggingStatus(EventLogging evts) {
		this.put(EVENT_LOGGING_s, evts);
	}
	/**
	* @description check the validity of the event name
	* @return Boolean, default false
	*/
	public Boolean checkEvent() {
		Object result = this.get(CHECK_EVENT_NAME_s);
		Boolean defaultValue = false;

		if ( result != null && result instanceof Boolean ) {
			defaultValue = (Boolean)result;
		}
		return defaultValue;
	} // end of checkEvent
	/**
	* @description Setter to check event validatity
	*/
	public void checkEvent(Boolean checkEvt) {
		this.put(CHECK_EVENT_NAME_s, checkEvt);
	}
	/**
	* @description store event
	* @return Boolean, default true
	*/
	public Boolean storeEvent() {
		Object result = this.get(EVENT_STORING_s);
		Boolean defaultValue = true;

		if ( result != null && result instanceof Boolean ) {
			defaultValue = (Boolean)result;
		}
		return defaultValue;
	} // end of storeEvent
	/**
	* @description Setter to store event validatity
	*/
	public void storeEvent(Boolean checkEvt) {
		this.put(EVENT_STORING_s, checkEvt);
	}
	/**
	 * @description do instrumentation
	 * @return Boolean, default false
	 */
	public Boolean instrumentation() {
		Object result = this.get(ADD_INSTRUMENTATION_s);
		Boolean defaultValue = false;

		if ( result != null && result instanceof Boolean ) {
			defaultValue = (Boolean)result;
		}
		return defaultValue;

	}// end of instrumentation
	/**
	* @description Setter to turn instrumentation
	*/
	public void instrumentation(Boolean theInstrumentation) {
		this.put(ADD_INSTRUMENTATION_s, theInstrumentation);
	}
	/**
	 * @description retry count
	 * @return integer, default DEFAULT_RETRY_COUNT
	 */
	public integer retryCount() {
		Object result = this.get(RETRY_COUNT_s);
		integer defaultValue = DEFAULT_RETRY_COUNT;

		if ( result != null && result instanceof Integer ) {
			defaultValue = (integer)result;
		}
		return defaultValue;

	}// end of retryCount
	/**
	* @description Setter to set retry for the consumer
	*/
	public void retryCount(integer retryCount) {
		if ( retryCount <= 0 ) {
			retryCount = 1;
		} else if ( retryCount > RETRY_COUNT_MAX ) {
			retryCount = RETRY_COUNT_MAX;
		}
		this.put(RETRY_COUNT_s, retryCount);
	} // end of retryCount

	/**
	* @description turn on audit or no -- audit saves the json of the parameters
	* @return Boolean, default false
	*/
	public Boolean allowRetryAfterException() {

		Object result = this.get(ALLOW_RETRY_AFTER_EXCEPTION_s);
		Boolean defaultValue = true;

		if ( result != null && result instanceof Boolean) {
			defaultValue = (Boolean)result;
		}
		return defaultValue;
	}// end of allowRetryAfterException
	/**
	 * @description do we allow a retry after an exception in the consumer model
	 *
	 * @param allowRetry set to true if you allow consumers to retry after an exception
	 */
	public void allowRetryAfterException(Boolean allowRetry) {
		this.put(ALLOW_RETRY_AFTER_EXCEPTION_s, allowRetry);
	} // end of allowRetryAfterException
	////////////////////////////////////////////////////////////////////////
	// Properties (Primary)
	/////////////////////////////////////////////////////////////////////////


	public Object get(String key) {
		if ( string.isBlank(key) ||
		        this.m_attributes == null ) {
			return null;
		}
		return this.m_attributes.get(key);
	}

	public Object put(String key, Object value) {
		if ( string.isBlank(key) ||
		        this.m_attributes == null) {
			return false;
		}
		return this.m_attributes.put(key, value);
	}
	/**
	 * @description getter for attributes
	 * @return attribute collection
	 */
	public Map<String, Object> getAttributes() {
		return this.m_attributes;
	} // end of getAttributes

	/**
	 * @description setter for attributes
	 *
	 * @param pe_attributes attribute collection (merge)
	 */
	public void setAttributes(Map<String, Object> pe_attributes) {
		// ensure we have the base
		if ( this.m_attributes == null ) {
			this.m_attributes = accc_PlatformEventAttrs.getDefaultAttributes();
		}
		// merge
		if (pe_attributes != null ) {
			this.m_attributes.putAll(pe_attributes);
		}
	} // end of setAttributes
	/**
	 * @description get our default attribute setting
	 * @return our default attribute settin
	 */
	static Map<String, Object>  getDefaultAttributes() {
		return new Map<String, Object> {
			SERIALIZE_EVENTS_s => true
			, EVENT_LOGGING_s => EventLogging.ALL
			, RETRY_COUNT_s => DEFAULT_RETRY_COUNT
			, CHECK_EVENT_NAME_s => true
			, ADD_INSTRUMENTATION_s => true
			, ALLOW_RETRY_AFTER_EXCEPTION_s => true
			, EVENT_STORING_s => true
		};
	} // end of getDefaultAttributes

} // end of accc_PlatformEventAttrs