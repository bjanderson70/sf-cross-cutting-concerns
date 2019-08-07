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
 * @description platform event common utilities tests
 * @group Test Layer
 */
@isTest
private class accc_PlatformEvtUtilitiesTest {
	static final String ExceptedEventLabelInCustomMDT = 'pe_test__e';


	@isTest
	static void testnormalizeString() {
		String data = '  1221  ';
		String expected = '1221';
		String maxString = '';
		String result = accc_PlatformEvtUtilities.normalizeString(data, true, accc_PlatformEvtUtilities.MIN_STRING_SIZE);
		System.assertEquals(result, expected);
		result = accc_PlatformEvtUtilities.normalizeString(data, false, accc_PlatformEvtUtilities.MIN_STRING_SIZE);
		System.assertEquals(result, '  12');

		for (integer inx = 0; inx < accc_PlatformEvtUtilities.MAX_STRING_SIZE + 2; inx++) {
			maxString += 'a';
		}
		result = accc_PlatformEvtUtilities.normalizeString(maxString, true);
		System.assertEquals(result.length(), accc_PlatformEvtUtilities.MAX_STRING_SIZE);


	} // end of testnormalizeString

	@isTest
	static void testgetClassInstance() {
		Object obj = accc_PlatformEvtUtilities.getClassInstance('accc_PlatformEvtUtilities');
		System.assertEquals( obj != null , true);
		obj = accc_PlatformEvtUtilities.getClassInstance(null);
		System.assertEquals( obj == null , true);
	} // end of testgetClassInstance

	@isTest
	static void testensureEnviromentIsCorrectOtherwiseDebug() {
		String env = accc_PlatformEvtUtilities.ensureEnviromentIsCorrectOtherwiseDebug('accc_PlatformEvtUtilities');
		System.assertEquals( accc_PlatformEvtUtilities.DEBUG_ENVIRONMENT == env , true);
		env = accc_PlatformEvtUtilities.ensureEnviromentIsCorrectOtherwiseDebug(accc_PlatformEvtUtilities.TEST_ENVIRONMENT);
		System.assertEquals( accc_PlatformEvtUtilities.TEST_ENVIRONMENT == env , true);

	} // end of testensureEnviromentIsCorrectOtherwiseDebug
	@isTest
	static void testvalidEventName() {
		Boolean result = accc_PlatformEvtUtilities.validEventName('accc_PlatformEvtUtilities');
		System.assertEquals(false, result);
		result = accc_PlatformEvtUtilities.validEventName(ExceptedEventLabelInCustomMDT);
		System.assertEquals( true, result );
		result = accc_PlatformEvtUtilities.validEventName(null);
		System.assertEquals(false, result);

	} // end of testvalidEventName

	@isTest
	static void testgetSobjectName() {
		//assign
		String expected = 'Account';
		// act
		String result = accc_PlatformEvtUtilities.getSobjectName(new Account());
		// assert
		System.assertEquals(expected, result);
		// act
		result = accc_PlatformEvtUtilities.getSobjectName((List<SObject>)null);
		// assert
		System.assertEquals(true, result == '');
		// act
		result = accc_PlatformEvtUtilities.getSobjectName((SObject)null);
		// assert
		System.assertEquals(true, result == '');
	}
	@isTest
	static void testgetTypeFromSObjectCollectionWithNoContacts() {
		//assign
		List<SObject> sob = new List<Contact>();
		Type expected = Contact.class;
		// act
		Type ns = accc_PlatformEvtUtilities.getTypeFromSObject(sob);
		// assert
		System.assertEquals(expected, ns);
	} // end of testgetTypeFromSObjectCollectionContact
	@isTest
	static void testgetSobjectNameWithBadParams() {
		//assign
		String expected = '';
		SObject data = null;
		// act
		String result = accc_PlatformEvtUtilities.getSobjectName(data);
		// assert
		System.assertEquals(expected, result);
	} // end of testgetSobjectNameWithBadParams

	@isTest
	static void testgetSobjectNameWithList() {
		//assign
		String expected = 'Account';
		List<Account> alist = new List<Account> {
			new account(Name = 'Acme', Description = 'Acme Account')
		};
		insert alist;
		// act
		String result = accc_PlatformEvtUtilities.getSobjectName(alist);
		// assert
		System.assertEquals(expected, result);
	} // end of testgetSobjectName
	@isTest
	static void testgetTypeFromSObjectCollection() {
		//assign
		List<SObject> sob = new List<Contact> {
			new Contact()
			, new Contact()
		};
		Type expected = Contact.class;
		// act
		Type ns = accc_PlatformEvtUtilities.getTypeFromSObject(sob);
		// assert
		System.assertEquals(expected, ns);
	} // end of testgetTypeFromSObjectCollection

	@isTest
	static void testgetTypeFromSObject() {
		//assign
		SObject sob = new account(Name = 'Acme', Description = 'Acme Account');
		Type expected = Account.class;
		// act
		Type ns = accc_PlatformEvtUtilities.getTypeFromSObject(sob);
		// assert
		System.assertEquals(expected, ns);
	} // end of testgetTypeFromSObject

	@isTest
	static void testconvertDayToString() {
		//assign
		// act
		// assert
		System.assertEquals('01', accc_PlatformEvtUtilities.convertDayToString(1));
		System.assertEquals('01', accc_PlatformEvtUtilities.convertDayToString(0));
		System.assertEquals('31', accc_PlatformEvtUtilities.convertDayToString(32));
		System.assertEquals('31', accc_PlatformEvtUtilities.convertDayToString(31));
		System.assertEquals('30', accc_PlatformEvtUtilities.convertDayToString(30));
		System.assertEquals('10', accc_PlatformEvtUtilities.convertDayToString(10));
		System.assertEquals('12', accc_PlatformEvtUtilities.convertDayToString(12));
		System.assertEquals('21', accc_PlatformEvtUtilities.convertDayToString(21));
		System.assertEquals('15', accc_PlatformEvtUtilities.convertDayToString(15));
	}// end of testconvertDayToString

	@isTest
	static void testconvertMonthToString() {
		//assign
		// act
		// assert
		System.assertEquals('01', accc_PlatformEvtUtilities.convertMonthToString(1));
		System.assertEquals('01', accc_PlatformEvtUtilities.convertMonthToString(0));
		System.assertEquals('12', accc_PlatformEvtUtilities.convertMonthToString(32));
		System.assertEquals('12', accc_PlatformEvtUtilities.convertMonthToString(12));

		System.assertEquals('10', accc_PlatformEvtUtilities.convertMonthToString(10));
		System.assertEquals('01', accc_PlatformEvtUtilities.convertMonthToString(-1));
		System.assertEquals('02', accc_PlatformEvtUtilities.convertMonthToString(2));
		System.assertEquals('10', accc_PlatformEvtUtilities.convertMonthToString(10));
	}// end of convertMonthToString

	@isTest
	static void testgetDMLLimitsInStringForm() {
		//assign
		// act
		// assert
		System.assertEquals(true, accc_PlatformEvtUtilities.getDMLLimitsInStringForm() != null);
	}// end of testgetDMLLimitsInStringForm
	@isTest
	static void testformatForOutput() {
		//assign
		// act
		// assert
		System.assertEquals(true, accc_PlatformEvtUtilities.formatForOutput(LoggingLevel.DEBUG, 'test') != null );
	}// end of testformatForOutput

	@isTest
	static void testconvertListCollectionIntoString () {
		List<String> operationIds = new List<String> {
			'1',
			'2',
			'3'
		};
		List<String> expectedStrings = new List<String> {
			'1,2,3',
			'1,2',
			'1'
		};

		// assert
		for (String item : expectedStrings) {
			System.assertEquals(item,
			                    accc_PlatformEvtUtilities.convertListCollectionIntoString(operationIds, item.length() + 1, accc_PlatformEvtUtilities.DEFAULT_DELIMITER)
			                   );

			System.assertEquals(item,
			                    accc_PlatformEvtUtilities.convertListCollectionIntoString(operationIds, item.length() + 1, null)
			                   );
			System.assertEquals(expectedStrings[0],
			                    accc_PlatformEvtUtilities.convertListCollectionIntoString(operationIds, -1, null)
			                   );
		}
		System.assertEquals(accc_PlatformEvtUtilities.DEFAULT_STRING_RESULT,
		                    accc_PlatformEvtUtilities.convertListCollectionIntoString(null, 1, null)
		                   );
		System.assertEquals(accc_PlatformEvtUtilities.DEFAULT_STRING_RESULT,
		                    accc_PlatformEvtUtilities.convertListCollectionIntoString(new List<String>(), 1, null)
		                   );
		System.assertEquals(accc_PlatformEvtUtilities.DEFAULT_STRING_RESULT,
		                    accc_PlatformEvtUtilities.convertListCollectionIntoString(new List<String> {accc_PlatformEvtUtilities.DEFAULT_STRING_RESULT}, 1000, null)
		                   );
	}// end of testconvertListCollectionIntoString
}