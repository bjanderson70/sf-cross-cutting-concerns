/**
 * Copyright (c) 2016-2018, Bill Anderson.
 * All rights reserved.
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
 * @description platform event common utilities
 * @group Common Layer
 */
public without sharing class accc_PlatformEvtUtilities {

	/////////////////////////////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////////////////////////////
	public static final string EMPTY_JSON_s = '{}';
	public static final integer MAX_JSON_SIZE = 131072;
	public static final integer MAX_TEXT_LONG_SIZE = 131072;

	public static final integer MAX_STRING_SIZE = 254;
	public static final integer MIN_STRING_SIZE = 4;
	public static final integer MAX_DAY_IN_MONTH = 31;
	public static final integer MAX_NUM_OF_MONTH = 12;

	public static final String DEFAULT_PUBLISHER_NAME = 'accc_DefaultPEPublisher' ;
	public static final String DEFAULT_CONSUMER_NAME = 'accc_DefaultPEConsumer' ;

	public static final String DEFAULT_DELIMITER = ',';
	public static final String DEFAULT_STRING_RESULT = '';
	public static final String EVENT_TYPE_TAG_s = '__e';

	public static final String DEBUG_ENVIRONMENT = 'debug';
	public static final String PROD_ENVIRONMENT = 'production';
	public static final String TEST_ENVIRONMENT = 'test';
	public static final Set<String> KNOWN_ENVIRONMENTS = new Set<String> {
		DEBUG_ENVIRONMENT
		, PROD_ENVIRONMENT
		, TEST_ENVIRONMENT

	}; // end of KNOWN_ENVIRONMENTS
	/**
	 * Month Index to 2 char string
	 */
	private static  Map<Integer, String> MonthIndex = new Map<Integer, String> {
		1 => '01'
		, 2 => '02'
		, 3 => '03'
		, 4 => '04'
		, 5 => '05'
		, 6 => '06'
		, 7 => '07'
		, 8 => '08'
		, 9 => '09'
		, 10 => '10'
		, 11 => '11'
		, 12 => '12'
	} ;
	/**
	 * Day indexto 2 char string
	 */
	private static  Map<Integer, String> DayIndex = new Map<Integer, String> {
		1 => '01', 2 => '02', 3 => '03', 4 => '04', 5 => '05', 6 => '06', 7 => '07', 8 => '08', 9 => '09', 10 => '10'
		, 11 => '11', 12 => '12', 13 => '13', 14 => '14', 15 => '15', 16 => '16', 17 => '17', 18 => '18', 19 => '19', 20 => '20'
		, 21 => '21', 22 => '22', 23 => '23', 24 => '24', 25 => '25', 26 => '26', 27 => '27', 28 => '28', 29 => '29', 30 => '30'
		, 31 => '31'
	} ;


	@TestVisible
	private static Set<String> m_eventNames = new  Set<String>();

	/////////////////////////////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * @description normalize the string (trim and size accordingly)
	 *
	 * @param datum string to normalize
	 * @param dotrim true, if need to trim
	 *
	 * @return normalize string
	 */
	public static string normalizeString(String datum, Boolean dotrim) {
		return accc_PlatformEvtUtilities.normalizeString(datum, dotrim, accc_PlatformEvtUtilities.MAX_STRING_SIZE);
	}
	/**
	 * @description normalize the string (trim and size accordingly)
	 *
	 * @param datum string to normalize
	 * @param dotrim true, if need to trim
	 * @param size size the string should be
	 *
	 * @return normalize string
	 */
	public static string normalizeString(String datum, Boolean dotrim, integer size) {
		string result = '';
		integer minSize = size < accc_PlatformEvtUtilities.MIN_STRING_SIZE ? accc_PlatformEvtUtilities.MIN_STRING_SIZE : size > accc_PlatformEvtUtilities.MAX_STRING_SIZE ? accc_PlatformEvtUtilities.MAX_STRING_SIZE : size ;

		if ( !string.isBlank(datum) ) {
			if ( dotrim ) {
				result = datum.trim();
			} else {
				result = datum;
			}
			if ( result.length() > minSize ) {
				// ensure size correctness
				result = result.substring(0, minSize);
			}
		}

		return result;
	} // end of normalizeString

	/**
	 * @description get the class instance
	 * @param fqdn fully qualified domain name
	 * @return class instance
	 */
	public static Object getClassInstance(string fqdn) {
		Object result = null;
		try {
			// valid data
			if ( string.isBlank(fqdn)) {
				return result;
			}
			// Get the Type corresponding to the class name
			Type objType = Type.forName(fqdn);

			// Instantiate the type.
			// The type of the instantiated object is the interface.
			if ( objType != null ) {
				result = (Object)objType.newInstance();
			}
		} catch (Exception excp) {
			// process exception
			accc_PlatformEventLogger.myInstance().log('+++ EXCEPTION +++ accc_PlatformEvtBuilder.getClassInstance fqdn=' + fqdn);
		}

		return result;

	} // end of getClassInstance

	public static string ensureEnviromentIsCorrectOtherwiseDebug(string currentEnv) {
		String env = currentEnv == null ? accc_PlatformEvtUtilities.DEBUG_ENVIRONMENT : currentEnv;

		if ( !accc_PlatformEvtUtilities.KNOWN_ENVIRONMENTS.contains(env.toLowerCase()) ) {
			env = accc_PlatformEvtUtilities.DEBUG_ENVIRONMENT;
		}
		return env;
	} // end of ensureEnviromentIsCorrectOtherwiseDebug
	/**
	 * @description validate that this is an event
	 *
	 * @param eventToValidate name of an event (i.e. My_Event__e)
	 * @return true if present
	 */
	public static Boolean validEventName(String eventToValidate) {

		if ( accc_PlatformEvtUtilities.m_eventNames.size() == 0) {
			Map<String, Schema.SObjectType> globalSchemaDesc = Schema.getGlobalDescribe();
			Set<String> objNames = globalSchemaDesc.keySet();
			// any data
			if ( objNames != null && objNames.size() > 0 ) {
				for (String objName : objNames) {
					if ( objName.endsWith(accc_PlatformEvtUtilities.EVENT_TYPE_TAG_s)) {
						m_eventNames.add(objName.toLowerCase());
					}
				}
			}
		}

		if ( string.isBlank(eventToValidate)) {
			return false;
		}
		return accc_PlatformEvtUtilities.m_eventNames.contains(eventToValidate.toLowerCase());
	}// end of validEventName

	/**
	*
	* @description get the name of the sobject
	*
	* @param mySobject SObject
	* @return String - name of the sobject
	*/
	public static  String getSobjectName(SObject mySobject) {
		String result = '';
		try {
			result = mySobject != null ? mySobject.getsObjectType().getDescribe().getName() : '';
		} catch (Exception excp) {
			// ignored at this time - TBD
		}
		return result;
	} // end of getSobjectName

	/**
	 *  @description  get the Type from the SObject
	 *
	 * @param theSObject type we want
	 * @return System Type
	 */
	public static Type getTypeFromSObject(SObject theSObject) {
		Type result = null;

		try {
			if ( theSObject != null ) {
				Schema.SObjectType sType = theSObject.getSobjectType();
				result = Type.forName(sType.getdescribe().getName());
			}

		} catch  (Exception excp) {
			// ignored at this time
		}
		return result;
	} // end of getTypeFromSObject
	/**
	*  @description  get the Type from the SObject collection
	*
	* @param theSObject type we want
	* @return System Type
	*/
	public static Type getTypeFromSObject(List<SObject> theSObject) {
		Type result = null;

		try {
			if ( theSObject != null ) {
				Schema.SObjectType sType = theSObject.getSobjectType();
				if ( sType != null ) {
					result = Type.forName(sType.getdescribe().getName());
				}
				if ( result == null && theSObject.size() > 0 && theSObject[0] != null) {
					sType = theSObject[0].getSobjectType();
					if ( sType != null ) {
						result = Type.forName(sType.getdescribe().getName());
					}
				}
			}
		} catch  (Exception excp) {
			// ignored at this time - TBD
		}
		return result;
	} // end of getTypeFromSObject
	/**
	*  @description  get the Name from the SObject collection
	*
	* @param theSObject type we want
	* @return String name
	*/
	public static String getSobjectName(List<SObject> mySobject) {
		String result = '';
		if ( mySobject != null ) {
			Type sType = accc_PlatformEvtUtilities.getTypeFromSObject(mySobject);
			if ( sType != null ) {
				result = sType.getName();
			}
		}
		return result;
	} // end of getSobjectName
	/**
	 * @description DML limits in string form for output
	 * @return string
	 */
	public static String getDMLLimitsInStringForm() {
		return
		    '{' + '\n' +
		    ' getDMLStatements     : ' + Limits.getDMLStatements() + '\n' +
		    ' getLimitAsyncCalls   : ' + Limits.getLimitAsyncCalls() + '\n' +
		    ' getLimitQueueableJobs: ' + Limits.getLimitQueueableJobs() + '\n' +
		    ' getCpuTime           : ' + Limits.getCpuTime() + '\n' +
		    ' getLimitCpuTime      : ' + Limits.getLimitCpuTime() + '\n' +
		    ' getLimitDMLRows      : ' + Limits.getLimitDMLRows() + '\n' +
		    ' getDMLRows           : ' + Limits.getDMLRows() + '\n' +
		    '}';
	} // end of getDMLLimitsInStringForm
	/**
	 * @description get month string
	 *
	 * @param value month values 1 to 12
	 * @return two char string, 1 == '01'
	 */
	public static String convertMonthToString(integer value) {
		integer index = value <= 0 ?  1 : value > MAX_NUM_OF_MONTH ? MAX_NUM_OF_MONTH : value;
		return MonthIndex.get(index);
	} // end of convertMonthToString

	/**
	 * @description get month string
	 *
	 * @param value month values 1 to 31
	 * @return two char string, 1 == '01'
	 */
	public static String convertDayToString(integer value) {
		integer index = value <= 0 ?  1 : value > MAX_DAY_IN_MONTH ? MAX_DAY_IN_MONTH : value;
		return DayIndex.get(index);
	} // end of convertDayToString

	/**
	 * @description convert a list into a max. string, delimiter by some value
	 *
	 * @param theList the list to convert
	 * @param theMaxSize maximum size ( if <= 0, do not shrink)
	 * @param theDelimiter delimiter, defaults to comma
	 * @return stringified value
	 */
	public static String convertListCollectionIntoString(List<String> theList,
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

	/////////////////////////////////////////////////////////////////////////////////////////////////
	// Private Methods
	/////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * @description Formats data for output
	 *
	 * @param level Logging level
	 * @param message message to send out
	 *
	 * @return String, formatted
	 */
	@TestVisible
	private static String formatForOutput(LoggingLevel level, String message) {
		String msg = string.isBlank(message) ? ' (null) ' : message,
		       myformat = '++++ EVT OUT ++++ [{0}] -- {1} ';
		List<String> fillers = new String[] {level.name(), msg };
		return String.format(myformat, fillers);

	} // end of formatForOutput

} // end of accc_PlatformEvtUtilities