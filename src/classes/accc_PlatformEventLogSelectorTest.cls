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
 * @description Platform Event Data Access Object to log testing
 * @group Test Layer
 */
@isTest
private class accc_PlatformEventLogSelectorTest {

	@isTest
	static void testformatYearMonthDay() {
		// assign
		// act
		// assert
		System.assertEquals('2012-01-01T00:00:00-00:00', accc_PlatformEventLogSelector.formatYearMonthDay(2012, 1, 1));
		System.assertEquals('1999-01-01T00:00:00-00:00', accc_PlatformEventLogSelector.formatYearMonthDay(1999, 0, 0));
		System.assertEquals('1999-10-10T00:00:00-00:00', accc_PlatformEventLogSelector.formatYearMonthDay(1999, 10, 10));
		System.assertEquals('2018-12-12T00:00:00-00:00', accc_PlatformEventLogSelector.formatYearMonthDay(2018, 12, 12));

	} // end of testformatYearMonthDay

	@isTest
	static void testcreateQuery() {
		// assign
		List<String> starts =  new List<String> {
			'2012-01-01T00:00:00-00:00'
			, '2012-11-01T00:00:00-00:00'
			, '2012-12-01T00:00:00-00:00'
			, '2012-10-01T00:00:00-00:00'
			, '2012-01-11T00:00:00-00:00'
			, '2002-01-11T00:00:00-00:00'
		};
		// act
		for ( String start : starts) {
			// assert
			System.assertEquals(accc_PlatformEventLogSelector.SELECT_CLAUSE + accc_PlatformEventLogSelector.WHERE_CLAUSE + accc_PlatformEventLogSelector.GREATER_THAN_EQUAL_CLAUSE +  start + accc_PlatformEventLogSelector.LIMIT_CLAUSE, accc_PlatformEventLogSelector.createQuery(start, null));
		}
		for ( integer inx = 0; inx < starts.size() / 2; ++inx) {
			// assert
			System.assertEquals(accc_PlatformEventLogSelector.SELECT_CLAUSE + accc_PlatformEventLogSelector.WHERE_CLAUSE + accc_PlatformEventLogSelector.GREATER_THAN_EQUAL_CLAUSE +  starts[inx] + accc_PlatformEventLogSelector.AND_LESS_THAN_CLAUSE + starts[inx + 1] + accc_PlatformEventLogSelector.LIMIT_CLAUSE, accc_PlatformEventLogSelector.createQuery(starts[inx], starts[inx + 1]));
		}
		// assert
		System.assertEquals(accc_PlatformEventLogSelector.SELECT_CLAUSE + accc_PlatformEventLogSelector.LIMIT_CLAUSE, accc_PlatformEventLogSelector.createQuery(null, null));

	} // end of testcreateQuery

	@isTest
	static void testgetBigObjectInformation() {
		// assign
		String theStart =  '1900-01-11T00:00:00-00:00',
		       theEnd =  '1901-01-11T00:00:00-00:00';
		List<accc_PlatformEventDAOLog> result = null;

		// act
		result = accc_PlatformEventLogSelector.getBigObjectInformation(accc_PlatformEventLogSelector.createQuery(theStart, theEnd));
		// assert
		System.assertEquals(3, result.size());

	} // end of testgetBigObjectInformation

	@isTest
	static void testselectByMonthYear() {
		// assign
		integer expectedYear = 2017,
		        expectedMonth = 2;
		//act

		List<accc_PlatformEventDAOLog>  result = accc_PlatformEventLogSelector.selectByMonthYear(expectedMonth, expectedYear);
		// assert
		System.assertEquals(3, result.size());

	} // end of testselectByMonthYear

	@isTest
	static void testselectByYear() {
		// assign
		integer expectedYear = 2018;
		//act

		List<accc_PlatformEventDAOLog>  result = accc_PlatformEventLogSelector.selectByYear( expectedYear);
		// assert
		System.assertEquals(3, result.size());


	} // end of testselectByYear

	@isTest
	static void testselectByDayMonthYear() {
		// assign
		integer expectedDay = 2,
		        expectedYear = 2016,
		        expectedMonth = 2;
		//act

		List<accc_PlatformEventDAOLog>  result = accc_PlatformEventLogSelector.selectByDayMonthYear(expectedDay, expectedMonth, expectedYear);
		// assert
		System.assertEquals(3, result.size());

	} // end of testselectByDayMonthYear
	@isTest
	static void testUseRowLimit() {
		// assign
		String theStart = '2012-01-01T00:00:00-00:00',
		       theEnd = '2012-01-02T00:00:00-00:00';
		//act
		accc_PlatformEventLogSelector.UseRowLimit = true;
		String result = accc_PlatformEventLogSelector.createQuery(theStart, theEnd);
		String expression = accc_PlatformEventLogSelector.LIMIT_CLAUSE ;
		Pattern MyPattern = Pattern.compile(expression);
		Matcher MyMatcher = MyPattern.matcher(result);

		// assert
		System.assertEquals(true, MyMatcher.find());

		// act
		accc_PlatformEventLogSelector.UseRowLimit = false;
		result = accc_PlatformEventLogSelector.createQuery(theStart, theEnd);

		MyMatcher = MyPattern.matcher(result);

		// assert
		System.assertEquals(false, MyMatcher.find());

	} // end of testUseRowLimit

}