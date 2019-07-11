/**
 * Copyright (c) 2016-2018, Bill Anderson.  All rights reserved.
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
 * @description Platform Event Data Access Object to log
 * @group Logging Data Access Object
 */
public class accc_PlatformEventLogSelector {


	/////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////
	@TestVisible
	static final string SELECT_CLAUSE = 'select event_date__c,Event_Date_Year__c,Event_Date_Month__c,Event_Date_Day__c,Event_Truncated__c,Event_Name__c,Number_Of_Events__c,Event_JSON__c,Operation_Ids__c,Replay_Ids__c  from accc_Org_Events__b';
	@TestVisible
	static final string WHERE_CLAUSE = ' where event_date__c ';
	@TestVisible
	static final string LIMIT_CLAUSE = ' LIMIT 2000';
	@TestVisible
	static final string AND_LESS_THAN_CLAUSE = ' AND event_date__c < ';
	@TestVisible
	static final string GREATER_THAN_EQUAL_CLAUSE = ' >= ';
	/**
	 * @description use limit
	 *
	 */
	static Boolean m_use_Limit = true;
	/////////////////////////////////////////////////////////////////////////
	// Public Properties
	/////////////////////////////////////////////////////////////////////////
	/**
	 * Use row limit ( max # of rows returned is 2000) -- default is true
	 */
	public static Boolean UseRowLimit {
		get { return accc_PlatformEventLogSelector.m_use_Limit;}
		set { accc_PlatformEventLogSelector.m_use_Limit = value;}
	} // end of UseRowLimit

	/////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////

	public static List<accc_PlatformEventDAOLog> selectByMonthYear(integer month, integer year) {
		String startDateFormat = accc_PlatformEventLogSelector.formatYearMonthDay(year, month, 1),
		       endDateFormat = accc_PlatformEventLogSelector.formatYearMonthDay(year, month , date.daysInMonth(year, month));
		return accc_PlatformEventLogSelector.getBigObjectInformation(accc_PlatformEventLogSelector.createQuery(startDateFormat, endDateFormat));

	}// end of selectByMonthYear

	public static List<accc_PlatformEventDAOLog> selectByYear(integer year) {
		String startDateFormat = accc_PlatformEventLogSelector.formatYearMonthDay(year , 1, 1),
		       endDateFormat = accc_PlatformEventLogSelector.formatYearMonthDay(year, 12 , date.daysInMonth(year, 12));
		return accc_PlatformEventLogSelector.getBigObjectInformation(accc_PlatformEventLogSelector.createQuery(startDateFormat, endDateFormat));
	}// end of selectByYear

	public static List<accc_PlatformEventDAOLog> selectByDayMonthYear(integer day, integer month, integer year) {
		Date  myDate = date.newinstance(year, month, day),
		      newDate = mydate.addDays(1);

		String startDateFormat = accc_PlatformEventLogSelector.formatYearMonthDay(year, month, day),
		       endDateFormat = accc_PlatformEventLogSelector.formatYearMonthDay(newDate.year(), newDate.month(), newDate.day());

		return accc_PlatformEventLogSelector.getBigObjectInformation(accc_PlatformEventLogSelector.createQuery(startDateFormat, endDateFormat));
	} // end of selectByDayMonthYear

	/////////////////////////////////////////////////////////////////////////
	// Private Methods
	/////////////////////////////////////////////////////////////////////////

	/**
	 * @description get the big object data
	 *
	 * @param query database query
	 * @return collection of accc_PlatformEventDAOLog
	 */
	@TestVisible
	private static List<accc_PlatformEventDAOLog> getBigObjectInformation(string query) {
		List<accc_Org_Events__b> items = null;

		if ( !Test.isRunningTest() ) {
			items = Database.query(String.escapeSingleQuotes(query));
			accc_ApexUtilities.log('++++++++ getBigObjectInformation.query=' + query);

		} else {
			/*************************************************************
			* START of TESTING PORTION !!!
			* Here we create 3 records for the testing based on the query input
			**/
			integer year = Datetime.now().year(), month = 1, day = 1;
			String expression = '([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}:[0-9]{2}:[0-9]{2})';
			Pattern MyPattern = Pattern.compile(expression);
			Matcher MyMatcher = MyPattern.matcher(query);

			if ( MyMatcher.find() ) {
				year = Integer.valueOf(MyMatcher.group(1));
				month = Integer.valueOf(MyMatcher.group(2));
				day = Integer.valueOf(MyMatcher.group(3));

			}

			items = new List<accc_Org_Events__b>();
			for ( integer inx = 0; inx < 3; inx++) {
				items.add(new accc_Org_Events__b (Event_Date__c = date.newinstance(year, month, day + inx),
				                                 Event_Date_Day__c = day + inx,
				                                 Event_Json__c = JSON.serialize(new pe_test__e()),
				                                 Event_Date_Month__c = month,
				                                 Event_Name__c = 'pe_test__e',
				                                 Event_Truncated__c = 0,
				                                 Event_Date_Year__c = year,
				                                 Number_Of_Events__c = 1));

			}
			/*************************************************************
			* END of TESTING PORTION !!!
			**/
		}
		return accc_PlatformEventDAOLog.mapFrom(items);
	} // end of getBigObjectInformation

	/**
	 * @description create the Db Query
	 *
	 * @param startValue start of year-month-day format
	 * @param endValue end  of year-month-day format
	 * @return big object query
	 */
	@TestVisible
	private static String createQuery(String startValue, String endValue) {
		String theQuery = SELECT_CLAUSE;
		final Boolean hasStart = !string.isBlank(startValue) ,
		        hasEnd = !string.isBlank(endValue) ;

		if ( hasStart || hasEnd ) {
			theQuery += WHERE_CLAUSE;
		}
		if ( hasStart  ) {
			theQuery += GREATER_THAN_EQUAL_CLAUSE + startValue;
		}
		if ( hasEnd ) {
			theQuery += AND_LESS_THAN_CLAUSE + endValue;
		}
		// using row limit
		if ( accc_PlatformEventLogSelector.UseRowLimit ) {
			theQuery += LIMIT_CLAUSE ;
		}
		return theQuery;
	} // end of createQuery
	/**
	 * @description format the year month and day
	 *
	 * @param year
	 * @param month
	 * @param day
	 * @return format of year,month and day
	 */
	@TestVisible
	private static string formatYearMonthDay(integer year, integer month, integer day) {
		String yearValue = String.valueOf(year),
		       monthValue = accc_PlatformEvtUtilities.convertMonthToString(month),
		       dayValue = accc_PlatformEvtUtilities.convertDayToString(day),
		       dateFormat = yearValue + '-' + monthValue + '-' + dayValue + 'T00:00:00-00:00';
		return dateFormat;
	} // end of formatYearMonthDay

} // end of accc_PlatformEventLogSelector