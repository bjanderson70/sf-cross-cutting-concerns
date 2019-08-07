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
 * @description Platform Event Data Access Object to log. Encapsulates the handling of data
 * into the Big Object and Back out again
 * @group Logging Data Access Object
 */
public virtual without sharing class accc_PlatformEventDAOLog {

	/////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////
	public static final String DEFAULT_STRING_RESULT = '';
	public static final String DEFAULT_DELIMITER = ',';
	public static final String EVENT_TYPE_TAG_s = '__e';

	private String m_JsonData;
	private String m_eventName;
	private integer m_count;
	private Datetime m_timestamp;
	private Boolean m_truncated;
	private List<String> m_replayIds;
	private List<String> m_operationIds;

	/////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////
	public accc_PlatformEventDAOLog(string name) {
		this(name, accc_ApexConstants.EMPTY_JSON_s, Datetime.Now(), 1);
	} // end of ctor
	/**
	 * @description ctor to intake all values of the big object
	 *
	 * @param theName name of event
	 * @param theJson json of event ( assume 1 event)
	 *
	 */
	public accc_PlatformEventDAOLog(string theName,
	                               string theJson) {
		this(theName, theJson, Datetime.Now(), 1, null, null);
	} // end of ctor
	/**
	 * @description ctor to intake all values of the big object
	 *
	 * @param theName name of event
	 * @param theJson json of event (assumes 1 event)
	 * @param theTimestamp timestamp
	 *
	 */
	public accc_PlatformEventDAOLog(string theName,
	                               string theJson,
	                               Datetime theTimestamp ) {
		this(theName, theJson, theTimestamp, 1, null, null);

	} // end of ctor
	/**
	 * @description ctor to intake all values of the big object
	 *
	 * @param theName name of event
	 * @param theJson json of event
	 * @param eventCount number of items in json
	 *
	 */
	public accc_PlatformEventDAOLog(string theName,
	                               string theJson,
	                               integer eventCount ) {
		this(theName, theJson, Datetime.Now(), eventCount, null, null);

	} // end of ctor

	/**
	 * @description ctor to intake all values of the big object
	 *
	 * @param theName name of event
	 * @param theJson json of event
	 * @param theTimestamp timestamp
	 * @param eventCount number of items in json
	 *
	 */
	public accc_PlatformEventDAOLog(string theName,
	                               string theJson,
	                               Datetime theTimestamp,
	                               integer eventCount ) {
		this(theName, theJson, theTimestamp, eventCount, null, null);

	} // end of ctor

	/**
		 * @description ctor to intake all values of the big object
		 *
		 * @param theName name of event
		 * @param theJson json of event
		 * @param theTimestamp timestamp
		 * @param eventCount number of items in json
		 * @param theReplayIds replay Ids -- used for replay of bad events
		 * @param theOperationIds operation Ids -- used for replay of bad events
		 *
		 */
	public accc_PlatformEventDAOLog(string theName,
	                               string theJson,
	                               Datetime theTimestamp,
	                               integer eventCount,
	                               List<String> theReplayIds,
	                               List<String> theOperationIds ) {
		this.truncated = 0;
		this.timestamp = theTimestamp;
		// must be after truncated as the size may be truncated from property set
		this.json = theJson;
		this.name = string.isBlank(theName) ? this.timestamp.format() + accc_ApexConstants.EVENT_TYPE_TAG_s : theName;
		this.count = eventCount < 0 ? 1 : eventCount;
		this.operationIds = theOperationIds;
		this.replayIds = theReplayIds;
	} // end of ctor

	/////////////////////////////////////////////////////////////////////////
	// Public Properties
	/////////////////////////////////////////////////////////////////////////

	/**
	 * Name of Event
	 */
	public string name {
		get { return this.m_eventName;}
		protected set { this.m_eventName = value;}
	} // end of name
	/**
	 * JSON of Event(s)
	 *
	 */
	public string json {
		get { return this.m_JsonData;}
		protected set {
			final integer maxSize = accc_ApexConstants.MAX_JSON_SIZE - 1 ;
			this.m_JsonData = string.isBlank(value) ? accc_ApexConstants.EMPTY_JSON_s : value;

			// check the json data, do we need to meet size requirement
			if ( this.m_JsonData.length() > maxSize) {
				this.m_JsonData = this.m_JsonData.Substring(0, maxSize);
				this.truncated = 1;
			}
		}
	}// end of json
	/**
	 * JSON of Event(s) is truncated
	 *
	 */
	public integer truncated {
		get { return this.m_truncated ? 1 : 0;}
		protected set { this.m_truncated = value != 0 ? true : false;}
	} // end of truncated
	/**
	 * DateTime of event
	 *
	 */
	public DateTime timestamp {
		get { return this.m_timestamp;}
		protected set { this.m_timestamp = value == null ? Datetime.now() : value;}
	}// end of timestamp
	/**
	 * ReplayIds for recovery
	 *
	 */
	public List<string> replayIds {
		get { return this.m_replayIds;}
		protected set { this.m_replayIds = value;}
	} // end of replayIds
	/**
	 * Operation Ids for recovery
	 *
	 */
	public List<string> operationIds {
		get { return this.m_operationIds;}
		protected set { this.m_operationIds = value;}
	} // end of operationIds

	/**
	 * Number of JSON of Event(s)
	 *
	 */
	public integer count {
		get { return this.m_count;}
		protected set { this.m_count =  value ;}
	}// end of count
	/**
	 * Day event occurred
	 *
	 */
	public integer day {
		get { return this.m_timestamp.day();}
	} // end of day
	/**
	 * Month event occurred
	 *
	 */
	public integer month {
		get { return this.m_timestamp.month();}
	}// end of month
	/**
	 * Year event occurred
	 *
	 */
	public integer year {
		get { return this.m_timestamp.year();}
	}// end of year

	/////////////////////////////////////////////////////////////////////////
	// Public Static Methods
	/////////////////////////////////////////////////////////////////////////

	/**
	 * @description map from big objects
	 *
	 * @param entries collection of accc_PlatformEventDAOLog
	 * @return collection of accc_Org_Events__b
	 */
	public static List<accc_Org_Events__b> mapFrom(List<accc_PlatformEventDAOLog> entries) {
		List<accc_Org_Events__b> results = new List<accc_Org_Events__b>();
		if ( entries != null && entries.size() > 0) {
			for (accc_PlatformEventDAOLog item : entries) {
				results.add(new accc_Org_Events__b(
				                Event_Name__c = item.name,
				                Event_Date__c =  item.timestamp,
				                Event_Date_Day__c = item.timestamp.day(),
				                Event_Date_Month__c = item.timestamp.month(),
				                Event_Date_Year__c = item.timestamp.year(),
				                Event_Json__c =  item.json,
				                Event_Truncated__c = item.truncated,
				                Number_Of_Events__c = item.count,
				                Replay_Ids__c =  accc_PlatformEventDAOLog.convertListCollectionIntoString(item.replayIds,
				                                 accc_ApexConstants.MAX_TEXT_LONG_SIZE,
				                                 accc_ApexConstants.CommaDelimiter ),
				                Operation_Ids__c = accc_PlatformEventDAOLog.convertListCollectionIntoString(item.operationIds,
				                                   accc_ApexConstants.MAX_TEXT_LONG_SIZE,
				                                   accc_ApexConstants.CommaDelimiter )
				            )
				           );

			}
		}

		return results;
	}// end of mapFrom
	/**
	 * @description map from big objects
	 *
	 * @param entries collection of accc_Org_Events__b
	 * @return collection of accc_PlatformEventDAOLog
	 */
	public static List<accc_PlatformEventDAOLog> mapFrom(List<accc_Org_Events__b> entries) {
		List<accc_PlatformEventDAOLog> results = new List<accc_PlatformEventDAOLog>();
		if ( entries != null && entries.size() > 0) {
			for (accc_Org_Events__b item : entries) {

				results.add(new accc_PlatformEventDAOLog(
				                item.Event_Name__c,
				                item.Event_Json__c,
				                item.Event_Date__c,
				                item.Number_Of_Events__c == null ? 1 : (integer)item.Number_Of_Events__c,
				                item.Replay_Ids__c == null ? null : item.Replay_Ids__c.split(accc_PlatformEventDAOLog.DEFAULT_DELIMITER),
				                item.Operation_Ids__c == null ? null : item.Operation_Ids__c.split(accc_PlatformEventDAOLog.DEFAULT_DELIMITER)
				            )
				           );
			}
		}

		return results;
	} // end of mapFrom

	/////////////////////////////////////////////////////////////////////////
	// Private Static Methods
	/////////////////////////////////////////////////////////////////////////
	/**
	 * @description convert a list into a max. string, delimiter by some value
	 *
	 * @param theList the list to convert
	 * @param theMaxSize maximum size ( if <= 0, do not shrink)
	 * @param theDelimiter delimiter, defaults to comma
	 * @return stringified value
	 */
	@TestVisible
	private static String convertListCollectionIntoString(List<String> theList,
	        Integer theMaxSize,
	        String theDelimiter) {
		String result = DEFAULT_STRING_RESULT,
		       delimiter = theDelimiter == null ? DEFAULT_DELIMITER : theDelimiter;
		// any data to convert
		if (theList != null && theList.size() > 0 ) {
			result =  string.join(theList, delimiter);
			if ( theMaxSize > 1
			        && result.length() > theMaxSize) {
				result = result.Substring(0, theMaxSize - 1);
			}
		}
		return  result;
	} // end of convertListCollectionIntoString
} // end of accc_PlatformEventDAOLog