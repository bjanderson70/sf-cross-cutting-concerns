/**
 * Copyright (c) 2016-2019, Bill anderson.  All rights reserved.
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
 *   * Neither the name of Bill anderson nor the names of its
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
 * @description  Test class for the  accc_QueableBigObjects methods
 * @group Test Layer
 */
@isTest
private class accc_QueableBigObjectsTest {

	@isTest
	static  void testQueueableAdd() {
		// arrange
		// startTest/stopTest block to force async processes
		//   to run in the test.
		Test.startTest();
		List<accc_Org_Events__b>  bos = createBigObject();
		accc_QueableBigObjects obj = new accc_QueableBigObjects(bos);
		final integer expectedSize = accc_QueableBigObjects.getTestResultsForBigObject().size();
		// act
		System.enqueueJob(obj);
		Test.stopTest();

		// Validate that the job has run
		// by verifying that the record was created.
		// This query returns only the account created in test context by the
		// Queueable class method.
		// assert
		System.assertEquals(null, obj.theException);
		System.assertEquals(expectedSize, obj.entries.size());
		System.assertEquals(true, obj.isBigObject);
	}

	@isTest
	static  void testQueueableRemove() {
		// arrange
		// startTest/stopTest block to force async processes
		//   to run in the test.
		Test.startTest();
		List<accc_Org_Events__b>  bos = createBigObject();
		accc_QueableBigObjects obj = new accc_QueableBigObjects(bos, true);
		final integer expectedSize = accc_QueableBigObjects.getTestResultsForBigObject().size();
		// act
		System.enqueueJob(obj);
		Test.stopTest();

		// Validate that the job has run
		// by verifying that the record was created.
		// This query returns only the big-object created in test context by the
		// Queueable class method.

		// assert

		System.assertEquals(null, obj.theException);
		System.assertEquals(expectedSize, obj.entries.size());
		System.assertEquals(true, obj.isBigObject);

	}

	@isTest
	static  void testQueueableAddBadData() {
		// arrange
		accc_QueableBigObjects qobject = new accc_QueableBigObjects(null);
		// startTest/stopTest block to force async processes
		//   to run in the test.
		Test.startTest();
		// act
		System.enqueueJob(qobject);
		Test.stopTest();

		// Validate that the job had no entries and no exception
		System.assertEquals(null, qobject.entries);
		System.assertEquals(null, qobject.theException);
		System.assertEquals(true, qobject.isBigObject);
	}

	/**
	 * @description create an big-object --
	 *
	 * @return List<accc_Org_Events__b>
	 */
	static List<accc_Org_Events__b> createBigObject() {

		integer year = Datetime.now().year(), month = 1, day = 1;
		String startDateFormat = accc_PlatformEventLogSelector.formatYearMonthDay(year, month, 1),
		       endDateFormat = accc_PlatformEventLogSelector.formatYearMonthDay(year, month , date.daysInMonth(year, month)),
		       query = accc_PlatformEventLogSelector.createQuery(startDateFormat, endDateFormat);


		String expression = '([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}:[0-9]{2}:[0-9]{2})';
		Pattern MyPattern = Pattern.compile(expression);
		Matcher MyMatcher = MyPattern.matcher(query);

		if ( MyMatcher.find() ) {
			year = Integer.valueOf(MyMatcher.group(1));
			month = Integer.valueOf(MyMatcher.group(2));
			day = Integer.valueOf(MyMatcher.group(3));

		}

		List<accc_Org_Events__b> items = new List<accc_Org_Events__b>();
		for ( integer inx = 0; inx < 3; inx++) {
			items.add(new accc_Org_Events__b (Event_Date__c = date.newinstance(year, month, day + inx),
			                                  Event_Date_Day__c = day + inx,
			                                  Event_Json__c = JSON.serialize(new Account(Name = 'test')),
			                                  Event_Date_Month__c = month,
			                                  Event_Name__c = 'Account',
			                                  Event_Truncated__c = 0,
			                                  Event_Date_Year__c = year,
			                                  Number_Of_Events__c = 1));


		}
		return items;
	} // end of createBigObject
}// end of accc_QueableBigObjectsTest