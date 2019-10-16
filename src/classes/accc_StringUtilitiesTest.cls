/**
 * Copyright (c) 2016-2018, Bill anderson.  All rights reserved.
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
 * @author Bill anderson
 *
 * @description Test the string utilities
 *
 * @group Test Layer
 */
@isTest
private class accc_StringUtilitiesTest {

    @isTest
    static void testconvertListCollectionIntoString () {
        List<String> operationIds = new List<String> {
        };
        List<String> expectedStrings = new List<String> {
        };
        // assert
        for (String item : expectedStrings) {
            System.assertEquals(item,
                                accc_StringUtilities.convertListCollectionIntoString(operationIds, item.length() + 1, accc_ApexConstants.CommaDelimiter)
                                );
            System.assertEquals(item,
                                accc_StringUtilities.convertListCollectionIntoString(operationIds, item.length() + 1, null)
                                );
            System.assertEquals(expectedStrings[0],
                                accc_StringUtilities.convertListCollectionIntoString(operationIds, -1, null)
                                );
        }
        System.assertEquals(accc_ApexConstants.EmptyString,
                            accc_StringUtilities.convertListCollectionIntoString(null, 1, null)
                            );
        System.assertEquals(accc_ApexConstants.EmptyString,
                            accc_StringUtilities.convertListCollectionIntoString(new List<String>(), 1, null)
                            );
        System.assertEquals(accc_ApexConstants.EmptyString,
                            accc_StringUtilities.convertListCollectionIntoString(new List<String> {accc_ApexConstants.EmptyString}, 1000, null)
                            );
    } // end of testconvertListCollectionIntoString


    @isTest
    static void testconvertDayToString() {
        //assign
        // act
        // assert
        System.assertEquals('01', accc_StringUtilities.convertDayToString(1));
        System.assertEquals('01', accc_StringUtilities.convertDayToString(0));
        System.assertEquals('31', accc_StringUtilities.convertDayToString(32));
        System.assertEquals('31', accc_StringUtilities.convertDayToString(31));
        System.assertEquals('30', accc_StringUtilities.convertDayToString(30));
        System.assertEquals('10', accc_StringUtilities.convertDayToString(10));
        System.assertEquals('12', accc_StringUtilities.convertDayToString(12));
        System.assertEquals('21', accc_StringUtilities.convertDayToString(21));
        System.assertEquals('15', accc_StringUtilities.convertDayToString(15));
    } // end of testconvertDayToString

    @isTest
    static void testconvertMonthToString() {
        //assign
        // act
        // assert
        System.assertEquals('01', accc_StringUtilities.convertMonthToString(1));
        System.assertEquals('01', accc_StringUtilities.convertMonthToString(0));
        System.assertEquals('12', accc_StringUtilities.convertMonthToString(32));
        System.assertEquals('12', accc_StringUtilities.convertMonthToString(12));

        System.assertEquals('10', accc_StringUtilities.convertMonthToString(10));
        System.assertEquals('01', accc_StringUtilities.convertMonthToString(-1));
        System.assertEquals('02', accc_StringUtilities.convertMonthToString(2));
        System.assertEquals('10', accc_StringUtilities.convertMonthToString(10));
    } // end of convertMonthToString

    @isTest
    static void testmakeCacheIdentifier() {
        final String label = 'label',
                     category = 'category';
        List<String> expected = new List<String> {
            category +  accc_ApexConstants.Period + label,
            category,
            label
        };

        system.assertEquals(expected[0], accc_StringUtilities.makeCacheIdentifier(category, label));
        system.assertEquals(expected[1], accc_StringUtilities.makeCacheIdentifier(category, null));
        system.assertEquals(expected[2], accc_StringUtilities.makeCacheIdentifier(null, label));

    } // end of testmakeCacheIdentifier
    @isTest
    static void testgetNamespace() {
        string ns = 'highlevel',
               section = 'caching',
               hier = accc_StringUtilities.formProviderNameAccess (ns, section);
        string result = accc_StringUtilities.getNamespace(hier);
        system.assertEquals(ns, result);

    }     // end of testgetNamespace

    @isTest
    static void testsection() {
        string ns = 'highlevel',
               section = 'caching',
               hier =  accc_StringUtilities.formProviderNameAccess (ns, section);
        string result = accc_StringUtilities.getSection(hier);
        system.assertEquals(section, result );

    }     // end of testsection

    @isTest
    static void testmakeLocalCacheKey() {
        final string cat = 'highlevel',
                     label = 'caching';
        string result = cat + '.' + label;

        system.assertEquals(result, accc_StringUtilities.makeLocalCacheKey (cat, label) );
        system.assertEquals(cat, accc_StringUtilities.makeLocalCacheKey (cat, null) );
        system.assertEquals(label, accc_StringUtilities.makeLocalCacheKey (null, label) );
    }     // end of testmakeLocalCacheKey
    @isTest
    static void testformatNumberIntoUSTelephone() {
        String expected = '(111) 111-1111',
               converted = '1111111111';
        // assign/act/assert
        System.assertEquals(accc_StringUtilities.formatNumberIntoUSTelephone(converted), expected);
        System.assertEquals(accc_ApexConstants.EmptyString, accc_StringUtilities.formatNumberIntoUSTelephone(null));

    }    // end of testformatNumberIntoUSTelephone
    @isTest
    static void testconvertStringOfNumbersIntoUSTelephone() {
        String expected = '(111) 111-1111',
               converted = '1111111111';
        // assign/act/assert
        System.assertEquals(accc_StringUtilities.convertStringOfNumbersIntoUSTelephone(converted), expected);
    }    // end of testconvertStringOfNumbersIntoUSTelephone

    @isTest
    static void testsplitStringOnWhitespacesCommaOrSemiColon() {
        // assign
        Map<String, Integer> testOracle = new Map<String, Integer> {
            'a b;c    d, e' => 5,
            'a' => 1,
            'a; b' => 2,
            'sadsadasd     ;    b,    f' => 3,
            's@sa.com, asd@as.com;asd@awww.com' => 3
        };
        //  act
        for ( string input : testOracle.keyset() ) {
            List<String> result = accc_StringUtilities.splitStringOnWhitespacesCommaOrSemiColon(input);
            // assert
            system.assertNotEquals(null, result);
            system.assertEquals(testOracle.get(input), result.size());
        }
        List<String> result = accc_StringUtilities.splitStringOnWhitespacesCommaOrSemiColon(null);
        // assert
        system.assertEquals(0, result.size());
    }// end of testsplitStringOnWhitespacesCommaOrSemiColon

    @isTest static void testgenerateRandomNumberString() {
        //assign
        integer size = 10;
        string value = accc_StringUtilities.generateRandomNumberString(size);
        // assert
        System.assertNotEquals(value, null);
        System.assertEquals(value.length(), size);
    }
    @isTest
    static void testsplitStringOnExpression() {
        // assign
        Map<String, Integer> testOracle = new Map<String, Integer> {
            'a b c d e' => 5,
            'a ' => 1,
            'a;b' => 2,
            'sadsadasd;b,f' => 3,
            's@sa.com,asd@as.com,asd@awww.com' => 3
        };
        Map< Integer, String> expresion = new Map<Integer, String>  {
            0 => '\\s+',
            1 => '\\s+',
            2 => '\\s+|;|,',
            3 => '\\s+|;|,',
            4 => ','
        };
        integer inx = 0;
        //  act
        for ( string input : testOracle.keyset() ) {

            List<String> result = accc_StringUtilities.splitStringOnExpression(input, expresion.get(inx));
            // assert
            system.assertEquals(testOracle.get(input), result.size());
            inx++;
        }
    }     // end of testsplitStringOnExpression
    /**
     * @description Try a bad/invalid name
     */
    @isTest static void testnewGuid() {
        //assign
        String expected = accc_StringUtilities.newGuid();
        String result = accc_StringUtilities.newGuid();
        // assert
        System.assertNotEquals(expected, result);
    }    // end of testnewGuid

    @isTest static void testgetSection() {
        //assign
        String known = 'DataCaching.All';
        // act
        String ns = accc_StringUtilities.getSection(known);
        // assert
        System.assertNotEquals(accc_ApexConstants.All_s, ns);
    }    // end of testgetSection
    @isTest
    static void testsplitStringOnExpressionWithBadParams() {
        // assign
        integer inx = 0;
        //  act

        List<String> result = accc_StringUtilities.splitStringOnExpression(null, null);
        // assert
        system.assertNotEquals(null, result);
        system.assertEquals(0, result.size());

    }     // end of testsplitStringOnExpressionWithBadParams


    // 0689912549, +33698912549, +33 6 79 91 25 49,+33-6-79-91-25-49 ,(555)-555-5555
    // 555-555-5555, +1-238 6 79 91 25 49, +1-555-532-3455, +15555323455, 55555555555555555555555555
    // +7 06 79 91 25 49
    @isTest
    static void testAllTelephoneNumbers() {
        // assign
        Map<String, Boolean> testOracle = new Map<String, Boolean> {
            '+33698912549' => true,
            '+33 6 79 91 25 49' => true,
            '+33-6-79-91-25-49' => true,
            '(555)-555-5555' => true,
            '555-555-5555' => true,
            '+1-238 6 79 91 25 49' => true,
            '+1-555-532-3455' => true,
            '+15555323455' => true,
            '0689912549' => true,
            '-1-238 6 79 91 25 49' => false,
            '+1-555-532-' => false,
            '+1555' => false,
            '+155' => false,
            '+15' => false,
            '+1' => false,
            '+' => false
        };
        integer inx = 0;
        //  act
        for ( string input : testOracle.keyset() ) {
            Boolean result = accc_StringUtilities.isValidTelephoneUSorInternational(input);
            // assert
            system.assertEquals(testOracle.get(input), result, 'error at ' + inx);
            inx++;
        }
    }     // end of testAllTelephoneNumbers


    @isTest
    static void testconvertStringToInt() {
        String val = '100';
        Integer result = accc_StringUtilities.convertStringToInt(val, -1);
        system.assertEquals(true, 100 == result);
    }     // end of testconvertStringToInt


    @isTest
    static void testconvertStringToIntWithBadValue() {

        Integer result = accc_StringUtilities.convertStringToInt(null, -1);
        system.assertEquals(true, -1 == result);
    }     // end of testconvertStringToIntWithBadValue

    @isTest
    static void testconvertStringToIntWithBadValueString() {
        string val = 'hello';
        Integer result = accc_StringUtilities.convertStringToInt(val, -1);
        system.assertEquals(true, -1 == result);
    }     // end of testconvertStringToIntWithBadValueString

    @isTest
    static void testnormalizeString() {
        string val = null;
        string result = accc_StringUtilities.normalizeString(val);
        system.assertEquals(true, accc_ApexConstants.EmptyString == result);
    }     // end of testnormalizeString

    @isTest
    static void testnormalizeStringWithFalse() {
        final string val = ' 123 ';
        string result = accc_StringUtilities.normalizeString(val, false);
        system.assertEquals(val, result);
    }     // end of testnormalizeStringWithFalse

    @isTest
    static void testnormalizeStringWithTrue() {
        final string val = ' 123 ';
        final string expected = '123';
        string result = accc_StringUtilities.normalizeString(val, true);
        system.assertEquals(expected, result);
    }     // end of testnormalizeStringWithTrue

    @isTest
    static void testnormalizeStringValidString() {
        final string expected = 'hello';
        string result = accc_StringUtilities.normalizeString(expected);
        system.assertEquals(true, expected == result);
    }     // end of testnormalizeStringValidString

    @isTest
    static void testnormalizeStringValidStringWithSize() {
        final string expected = 'hello';
        string result = accc_StringUtilities.normalizeString(expected, 1);
        system.assertEquals(true, 'h' == result);
    }     // end of testnormalizeStringValidStringWithSize

    @isTest
    static void testnormalizeStringWithTrim() {
        String data = '  1221  ';
        String expected = '1221';
        String maxString = '';
        String result = accc_StringUtilities.normalizeString(data, true,expected.length() );
        System.assertEquals( expected,result);
        result = accc_StringUtilities.normalizeString(data, false, '  12'.length());
        System.assertEquals('  12',result);
        for (integer inx = 0; inx < accc_ApexConstants.MAX_STRING_SIZE + 2; inx++) {
            maxString += 'a';
        }
        result = accc_StringUtilities.normalizeString(maxString, true,accc_ApexConstants.MAX_STRING_SIZE);
        System.assertEquals(result.length(), accc_ApexConstants.MAX_STRING_SIZE);
    }     // end of testnormalizeStringWithTrim


    /**
    * @description test toString
    */
    @isTest static void testtoString() {
        //assign
        Boolean expected = true;
        // act
        Boolean result = accc_StringUtilities.toString(new accc_StringUtilities()).contains('accc_StringUtilities');
        // assert
        System.assertEquals(expected, result);
    } // end of testtoString
    /**
    * @description test empty toString
    */
    @isTest static void testtoStringNull() {
        //assign
        String expected =  accc_ApexConstants.EmptyString;
        // act
        String result = accc_StringUtilities.toString(null, expected);
        // assert
        System.assertEquals(expected, result);
    } // end of testtoStringNull
}// end of accc_StringUtilitiesTest