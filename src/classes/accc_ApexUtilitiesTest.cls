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
 * @description  Test class for the  accc_ApexUtilities methods
 * @group Test Layer
 */
@isTest
private class accc_ApexUtilitiesTest {

    static final String ExceptedEventLabelInCustomMDT = 'pe_test__e';

    /**
     * @description Test is sandbox
     */
    @isTest static void testIsSandbox() {
        //assign
        Boolean expected = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        // act
        Boolean result = accc_ApexUtilities.isSandbox();
        // assert
        System.assertEquals(expected, result);
    } // end of testIsSandbox
    /**
     * @description Test a valid class name
     */
    @isTest static void testgetClassName() {
        //assign
        String expected = 'accc_ApexUtilities';
        accc_ApexUtilities obj = new accc_ApexUtilities();

        String result = accc_ApexUtilities.getClassName(obj);
        // assert
        System.assertEquals(expected, result);
    } // end of testgetClassName

    @isTest static void testgetSobjectName() {
        //assign
        String expected = 'Account';
        // act
        String result = accc_ApexUtilities.getSobjectName(new Account());
        // assert
        System.assertEquals(expected, result);
    } // end of testgetSobjectName


    @isTest static void testloglevel() {
        //assign
       LoggingLevel expected= (LoggingLevel)accc_ApexEnvironment.getRuntimeEnvironment().provider().get(accc_ApexConstants.TraceLogLevel_r);

        // act
        LoggingLevel result = accc_ApexUtilities.loglevel();
        // assert
        System.assertEquals(expected, result);
    } // end of testloglevel

    @isTest
    static void testgetSobjectNameWithSet() {
        //assign
        String expected = 'Account';
        Set<SObject> accounts = new Set<SObject>();
        accounts.add(new Account());
        // act
        String result = accc_ApexUtilities.getSobjectName(accounts);
        // assert
        System.assertEquals(expected, result);
    } // end of testgetSobjectNameWithSet
    @isTest
    static void testgetTypeFromSObjectCollectionWithNoContacts() {
        //assign
        List<SObject> sob = new List<Contact>();
        Type expected = Contact.class;
        // act
        Type ns = accc_ApexUtilities.getTypeFromSObject(sob);
        // assert
        System.assertEquals(expected, ns);
    } // end of testgetTypeFromSObjectCollectionContact
    @isTest
    static void testgetTypeFromSObjectSet() {
        //assign
        Set<SObject> sob = new Set<SObject>();
        sob.add(new Contact());
        Type expected = Contact.class;
        // act
        Type ns = accc_ApexUtilities.getTypeFromSObject(sob);
        // assert
        System.assertEquals(expected, ns);
    } // end of testgetTypeFromSObjectCollectionContact

    @isTest static void testgetSobjectNameWithBadParams() {
        //assign
        String expected = accc_ApexConstants.EmptyString;
        SObject data = null;
        // act
        String result = accc_ApexUtilities.getSobjectName(data);
        // assert
        System.assertEquals(expected, result);
    } // end of testgetSobjectNameWithBadParams

    @isTest static void testgetSobjectNameWithList() {
        //assign
        String expected = 'Account';
        List<SObject> alist = new List<Account> {
            new account(Name = 'Acme', Description = 'Acme Account')
        };
        insert alist;
        // act
        String result = accc_ApexUtilities.getSobjectName(alist);
        // assert
        System.assertEquals(expected, result);
    } // end of testgetSobjectName

    @isTest static void testgetSobjectNameWithNullList() {
        //assign
        String expected = accc_ApexConstants.EmptyString;
        List<SObject> alist = null;
        // act
        String result = accc_ApexUtilities.getSobjectName(alist);
        // assert
        System.assertEquals(expected, result);
    } // end of testgetSobjectNameWithNullList


    /**
     * @description Try a bad/invalid name
     */
    @isTest static void testgetClassNameNull() {
        //assign
        String expected =  accc_ApexConstants.EmptyString;
        String result = accc_ApexUtilities.getClassName(null);
        // assert
        System.assertEquals(expected, result);
    } // end of testgetClassNameNull

    @isTest static void testgetTypeFromSObjectCollection() {
        //assign
        List<SObject> sob = new List<Contact>();
        Type expected = Contact.class;
        // act
        Type ns = accc_ApexUtilities.getTypeFromSObject(sob);
        // assert
        System.assertEquals(expected, ns);
    } // end of testgetTypeFromSObjectCollection

    @isTest static void testgetTypeFromSObject() {
        //assign
        SObject sob = new account(Name = 'Acme', Description = 'Acme Account');
        Type expected = Account.class;
        // act
        Type ns = accc_ApexUtilities.getTypeFromSObject(sob);
        // assert
        System.assertEquals(expected, ns);
    } // end of testgetTypeFromSObject



    @isTest static void testgetRecordIds() {
        //assign
        List<SObject> sObjectsList = new List<SObject> {
            new account(Name = 'Acme-0', Description = 'Acme Account')
            , new account(Name = 'Acme-1', Description = 'Acme Account')
            , new account(Name = 'Acme-2', Description = 'Acme Account')
        };

        Test.startTest();
        insert sObjectsList;
        Test.stopTest();
        Map<Id, SObject> mapOfIds = new Map<Id, SObject> ();
        for (Sobject lObject : sObjectsList) {
            mapOfIds.put(lObject.Id, lObject);
        }
        // act
        List<Id> results = accc_ApexUtilities.getRecordIds(sObjectsList);

        // assert
        System.assertNotEquals(results, null);
        System.assertEquals(results.size(), sObjectsList.size());

    } // end of testgetRecordIds

    @isTest static void testconvertMapOfIdsToListOfIds() {
        //assign
        List<SObject> sObjectsList = new List<SObject> {
            new account(Name = 'Acme-0', Description = 'Acme Account')
            , new account(Name = 'Acme-1', Description = 'Acme Account')
            , new account(Name = 'Acme-2', Description = 'Acme Account')
        };

        Test.startTest();
        insert sObjectsList;
        Test.stopTest();
        Map<Id, SObject> mapOfIds = new Map<Id, SObject> ();
        for (Sobject lObject : sObjectsList) {
            mapOfIds.put(lObject.Id, lObject);
        }
        // act
        List<Id> results = accc_ApexUtilities.convertMapOfIdsToListOfIds(mapOfIds);

        // assert
        System.assertNotEquals(results, null);
        System.assertEquals(results.size(), sObjectsList.size());

    } // end of testconvertMapOfIdsToListOfIds


    @isTest static void testconvertMapOfValuesToListOfValues() {
        //assign
        List<SObject> sObjectsList = new List<SObject> {
            new account(Name = 'Acme-0', Description = 'Acme Account')
            , new account(Name = 'Acme-1', Description = 'Acme Account')
            , new account(Name = 'Acme-2', Description = 'Acme Account')
        };

        Test.startTest();
        insert sObjectsList;
        Test.stopTest();
        Map<Id, SObject> mapOfObjects = new Map<Id, SObject> ();
        for (Sobject lObject : sObjectsList) {
            mapOfObjects.put(lObject.Id, lObject);
        }
        // act
        List<SObject> results = accc_ApexUtilities.convertMapOfValuesToListOfValues(mapOfObjects);

        // assert
        System.assertNotEquals(results, null);
        System.assertEquals(results.size(), sObjectsList.size());

    } // end of testconvertMapOfValuesToListOfValues

    @isTest static void testconvertListToMapOfValues() {
        //assign
        List<SObject> sObjectsList = new List<SObject> {
            new account(Name = 'Acme-0', Description = 'Acme Account')
            , new account(Name = 'Acme-1', Description = 'Acme Account')
            , new account(Name = 'Acme-2', Description = 'Acme Account')
        };

        Test.startTest();
        insert sObjectsList;
        Test.stopTest();

        // act
        Map<Id, SObject> results = accc_ApexUtilities.convertListToMapOfValues(sObjectsList);
        Map<Id, SObject> nullResults = accc_ApexUtilities.convertListToMapOfValues(null);

        // assert
        System.assertNotEquals(results, null);
        System.assertEquals(sObjectsList.size(), results.size());
        System.assertEquals(0, nullResults.size());

    } // end of testconvertListToMapOfValues

    @isTest static void testuserProfileName() {
        // assign
        // act
        String result = accc_ApexUtilities.userProfileName();
        // assert
        System.assertNotEquals(result, accc_ApexConstants.EmptyString);
        System.assertNotEquals(result.length(), 0);

    }

    @isTest static void testgetRecordByName() {
        // assign
        SObject acct = new account(Name = 'Acme-0', Description = 'Acme Account');
        // act
        String result = accc_ApexUtilities.getRecordByName(acct, 'Name');
        // assert
        System.assertNotEquals(result, accc_ApexConstants.EmptyString);
        System.assertNotEquals(result.length(), 0);
        System.assertNotEquals(acct, null);
        System.assertEquals(accc_ApexUtilities.getRecordByName(null, 'Name'), accc_ApexConstants.EmptyString);
    }


    @isTest static void testcontainsInTestLog() {
        // assign
        String result = 'This is a Test';
        // assign/act
        accc_ApexUtilities.log(result,true);
        // assert
        System.assertEquals(accc_ApexUtilities.containsInTestLog(result), true);
    } // end of testcontainsInTestLog


    @isTest static void testgetClassInstance() {
        // assign
        String className = 'accc_ApexUtilities';
        // assign/act

        // assert
        System.assertEquals(true, accc_ApexUtilities.getClassInstance(className) != null);
        // assert
        System.assertEquals(true, accc_ApexUtilities.getClassInstance('') == null);
    } // end of testgetClassInstance

    @isTest static void testcontainsExceptionInApplicationLog() {
        // assign
        String msg = 'This is an Exception Test';
        accc_ApexApplicationException result = new accc_ApexApplicationException(msg);
        // act
        accc_ApexUtilities.log(result);
        // assert
        System.assertEquals(true, accc_ApexUtilities.containsInTestLog(msg));
    } // end of testcontainsExceptionInApplicationLog

    @isTest
    static void testcontainsFieldInSObjectWithNull() {
        // assign / act
        Boolean result = accc_ApexUtilities.containsFieldInSObject(null, null);
        // assert
        System.assertEquals(false, result);
    } // end of testcontainsFieldInSObjectWithNull

    @isTest
    static void testcontainsFieldInSObjectWithBadField() {
        // assign
        SObject acct = new account(Name = 'Acme-0', Description = 'Acme Account');
        // act
        Boolean result = accc_ApexUtilities.containsFieldInSObject(acct, '12312312');
        // assert
        System.assertEquals(false, result);
    } // end of testcontainsFieldInSObjectWithBadField

    @isTest
    static void testlog() {
        // assign
        Boolean expected = true;
        Boolean result;
        accc_ApexApplicationException aae = new accc_ApexApplicationException('test');

        // act
        accc_ApexUtilities.log(aae);
        result = accc_ApexUtilities.containsInTestLog('test');
        // assert
        System.assertEquals(true, result);

    } // end of testlog

    @isTest
    static void testgetSObjectFieldsInformation() {
        // assign / act
        Map<String, SObjectField>  result = accc_ApexUtilities.getSObjectFieldsInformation('Account');
        // assert
        System.assertEquals(true, result.size() > 0);
        System.assertEquals(true, result.get('Name') != null);
    } // end of getSObjectFieldsInformation

    @isTest
    static void testcontainsFieldInSObject() {
        // assign
        SObject acct = new account(Name = 'Acme-0', Description = 'Acme Account');
        // act
        Boolean result = accc_ApexUtilities.containsFieldInSObject(acct, 'Description');
        // assert
        System.assertEquals(true, result);
    } // end of testcontainsFieldInSObject

    @isTest
    static void testgetFieldFromSObjectSafe() {

        // assign/act/assert
        System.assertEquals(accc_ApexUtilities.getFieldFromSObjectSafe(null, null), accc_ApexConstants.EmptyString);
        System.assertEquals(accc_ApexUtilities.getFieldFromSObjectSafe(null, 'Subject'), accc_ApexConstants.EmptyString);
    } // end of testgetFieldFromSObjectSafe

    @isTest
    static void testgetExecutingClassName() {
        // assign/act/assert
        System.assertNotEquals(accc_ApexUtilities.getExecutingClassName(), accc_ApexConstants.EmptyString);
    } // end of testgetExecutingClassName

    @isTest
    static void testgetExecutingMethod() {
        // assign/act/assert
        System.assertEquals(accc_ApexUtilities.getExecutingMethod(), 'testgetExecutingMethod');

    }// end of testgetExecutingMethod

    @isTest
    static void testvalidEventName() {
        Boolean result = accc_ApexUtilities.validEventName('accc_ApexUtilities');
        System.assertEquals(false, result);
        result = accc_ApexUtilities.validEventName(ExceptedEventLabelInCustomMDT);
        System.assertEquals( true, result );
        result = accc_ApexUtilities.validEventName(null);
        System.assertEquals(false, result);
    } // end of testvalidEventName

    @isTest
    static void testiterateOverFieldNamesInSObject() {
        final List<SObject> myObjects = new List<SObject> {
            new account(Name = 'Acme-0', Description = 'Acme Account'),
            new account(Name = 'Acme-2', Description = 'Acme Account2'),
            new account(Name = 'Acme-3', Description = 'Acme Account3')

        };

        for (SObject item : myObjects) {
            system.assertEquals(((Account)item).Name, accc_ApexUtilities.iterateOverFieldNamesInSObject(item, 'Name') );
        }

    } // end of testiterateOverFieldNamesInSObject

    @isTest
    static void testpopStack() {
        // assign
        string trace = new DmlException().getStackTraceString(),
               theClass =  accc_ApexConstants.EmptyString;
        // act / assert
        system.assertNotEquals(theClass, accc_ApexUtilities.popStack(trace));
    } // end of testpopStack

    @isTest
    static void testreturnDelimiterSeparatedStringOfIds() {
        // assign
        final List<Id> myObjects = new List<Id> {
            accc_TestUtility.getFakeId(Task.SObjectType),
            accc_TestUtility.getFakeId(Account.SObjectType),
            accc_TestUtility.getFakeId(Contact.SObjectType)
        };

        List<String> splitList = null;
        // act
        String result = accc_ApexUtilities.returnDelimiterSeparatedStringOfIds(myObjects, accc_ApexConstants.CommaDelimiter);
        splitList = result.split(',');

        // assert ( there are three values, 2 commas)
        system.assertEquals(3, splitList.size());
    }     // end of testreturnDelimiterSeparatedStringOfIds

    @isTest
    static void testreturnDelimiterSeparatedStringOfIdsViaSObject() {
        // assign
        final List<SObject> myObjects = new List<SObject> {
            new account(Name = 'Acme-0', Description = 'Acme Account'),
            new account(Name = 'Acme-2', Description = 'Acme Account2'),
            new account(Name = 'Acme-3', Description = 'Acme Account3')

        };
        for (SObject item : myObjects) {
            item.id =  accc_TestUtility.getFakeId(Account.SObjectType);
        }

        List<String> splitList = null;
        // act
        String result = accc_ApexUtilities.returnDelimiterSeparatedStringOfIds(myObjects, accc_ApexConstants.CommaDelimiter);
        splitList = result.split( accc_ApexConstants.CommaDelimiter);

        // assert ( there are three values, 2 commas)
        system.assertEquals(3, splitList.size());
    }// end of testreturnDelimiterSeparatedStringOfIdsViaSObject

    @isTest
    static void testvalidDomainName() {
        // assign
        Map<String, Boolean> validDomain = new Map<String, Boolean> {
            'Account' => true,
            'jsajsawsksks' => false,
            '*asdiwl*' => false,
            'Contact' => true,
            'Lead' => true,
            'Opportunity' => true,
            'my*-once*' => false,
            '' => false,
            '   ' => false,
            null => false
        };

        for ( String name : validDomain.keyset()) {
            // act/assert
            system.assertEquals(validDomain.get(name),
                                accc_ApexUtilities.validDomainName(name));
        }
    }

    @isTest static void testgetTypeByName() {
        // assign
        Map<String, Boolean> validType = new Map<String, Boolean> {
            'Account' => true,
            'jsajsawsksks' => false,
            '*asdiwl*' => false,
            'Contact' => true,
            'Lead' => true,
            'Opportunity' => true,
            'my*-once*' => false,
            '' => false,
            '   ' => false,
            null => false
        };

        for ( String name : validType.keyset()) {
            // assert
            system.assertEquals(validType.get(name), accc_ApexUtilities.getTypeByName(name) != null);
        }
    }
    @isTest static void testgetTypeFromSObjectList() {
        //assign
        Account sob = new account(Name = 'Acme', Description = 'Acme Account');
        List<Account> sobs = new List<Account> { sob};
        Type expected = Account.class;
        // act
        Type ns = accc_ApexUtilities.getTypeFromSObject(sobs);
        // assert
        System.assertEquals(expected, ns);
    } // end of testgetTypeFromSObject

    @isTest static void testgetSobjectTypeFromSObject() {
        //assign
        SObject sob = new account(Name = 'Acme', Description = 'Acme Account');
        Schema.SObjectType expected = Account.getSobjectType();
        // act
        Schema.SObjectType ns = accc_ApexUtilities.getSobjectTypeFromSObject(sob);
        // assert
        System.assertEquals(expected, ns);
        System.assertEquals(expected, accc_ApexUtilities.getSobjectTypeFromSObject(new List<SObject> {sob}));
        System.assertEquals(null, accc_ApexUtilities.getSobjectTypeFromSObject((SObject)null));
    } // end of testgetSobjectTypeFromSObject

    @isTest
    static void testexceededGovernorLimits() {
        //assign
        // act

        System.assertEquals(true,
                            accc_ApexUtilities.exceededGovernorLimits(new DmlException()));

        System.assertEquals(true,
                            accc_ApexUtilities.exceededGovernorLimits(new AsyncException()));

        System.assertEquals(true,
                            accc_ApexUtilities.exceededGovernorLimits(new CalloutException()));

        System.assertEquals(false,
                            accc_ApexUtilities.exceededGovernorLimits(new NoAccessException()));

        System.assertEquals(false,
                            accc_ApexUtilities.exceededGovernorLimits(new JSONException()));
    } // end of testexceededGovernorLimits

    @isTest static void testTrace() {
        // assign
        String result = 'This is a Test';
        // assign/act
        accc_ApexUtilities.trace(result);
        // assert
        System.assertEquals(accc_ApexUtilities.containsInTestLog(result), true);
    } // end of testTrace
    @isTest
    static void testgetDMLLimitsInStringForm() {
        //assign
        // act
        // assert
        System.assertEquals(true, accc_ApexUtilities.getDMLLimitsInStringForm() != null);
    }// end of testgetDMLLimitsInStringForm

    @isTest
    static void testslice(){
        // assign
        List<String> data = new List<String> { 'John', 'Mary', 'Susie', 'Igor', 'Jake' };
        List<String> sliced = (List<String>)accc_ApexUtilities.slice(data, 1, 3);
        // act /assert
        system.assertEquals (2, sliced.size()); // 2
        system.assertEquals ('Mary', (String)sliced[0]);
        system.assertEquals ('Susie', (String)sliced[1]);
        // act
        sliced = (List<String>)accc_ApexUtilities.slice(data, 0, 1);
        // assert
        system.assertEquals(1,sliced.size());
        system.assertEquals('John',(String)sliced[0]);
        // act
        sliced = (List<String>)accc_ApexUtilities.slice(data, 2);
        // assert
        system.assertEquals(3,sliced.size());
        system.assertEquals('Susie',(String)sliced[0]);
        system.assertEquals('Igor',(String)sliced[1]);
        system.assertEquals('Jake',(String)sliced[2]);
        // act
        sliced = (List<String>)accc_ApexUtilities.slice(null, 2);
        // assert
        system.assertEquals(null,sliced);
    } // end of testslice

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //+ START
    // These tests below will be deprecated once the delegated fuctionality is moved out of
    // accc_ApexUtilities and rest completely in accc_ApexUtilities
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    @isTest
    static void testconvertListCollectionIntoString () {
        List<String> operationIds = new List<String> {
        };
        List<String> expectedStrings = new List<String> {
        };
        // assert
        for (String item : expectedStrings) {
            System.assertEquals(item,
                                accc_ApexUtilities.convertListCollectionIntoString(operationIds, item.length() + 1, accc_ApexConstants.CommaDelimiter)
                                );
            System.assertEquals(item,
                                accc_ApexUtilities.convertListCollectionIntoString(operationIds, item.length() + 1, null)
                                );
            System.assertEquals(expectedStrings[0],
                                accc_ApexUtilities.convertListCollectionIntoString(operationIds, -1, null)
                                );
        }
        System.assertEquals(accc_ApexConstants.EmptyString,
                            accc_ApexUtilities.convertListCollectionIntoString(null, 1, null)
                            );
        System.assertEquals(accc_ApexConstants.EmptyString,
                            accc_ApexUtilities.convertListCollectionIntoString(new List<String>(), 1, null)
                            );
        System.assertEquals(accc_ApexConstants.EmptyString,
                            accc_ApexUtilities.convertListCollectionIntoString(new List<String> {accc_ApexConstants.EmptyString}, 1000, null)
                            );
    } // end of testconvertListCollectionIntoString


    @isTest
    static void testconvertDayToString() {
        //assign
        // act
        // assert
        System.assertEquals('01', accc_ApexUtilities.convertDayToString(1));
        System.assertEquals('01', accc_ApexUtilities.convertDayToString(0));
        System.assertEquals('31', accc_ApexUtilities.convertDayToString(32));
        System.assertEquals('31', accc_ApexUtilities.convertDayToString(31));
        System.assertEquals('30', accc_ApexUtilities.convertDayToString(30));
        System.assertEquals('10', accc_ApexUtilities.convertDayToString(10));
        System.assertEquals('12', accc_ApexUtilities.convertDayToString(12));
        System.assertEquals('21', accc_ApexUtilities.convertDayToString(21));
        System.assertEquals('15', accc_ApexUtilities.convertDayToString(15));
    } // end of testconvertDayToString

    @isTest
    static void testconvertMonthToString() {
        //assign
        // act
        // assert
        System.assertEquals('01', accc_ApexUtilities.convertMonthToString(1));
        System.assertEquals('01', accc_ApexUtilities.convertMonthToString(0));
        System.assertEquals('12', accc_ApexUtilities.convertMonthToString(32));
        System.assertEquals('12', accc_ApexUtilities.convertMonthToString(12));

        System.assertEquals('10', accc_ApexUtilities.convertMonthToString(10));
        System.assertEquals('01', accc_ApexUtilities.convertMonthToString(-1));
        System.assertEquals('02', accc_ApexUtilities.convertMonthToString(2));
        System.assertEquals('10', accc_ApexUtilities.convertMonthToString(10));
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

        system.assertEquals(expected[0], accc_ApexUtilities.makeCacheIdentifier(category, label));
        system.assertEquals(expected[1], accc_ApexUtilities.makeCacheIdentifier(category, null));
        system.assertEquals(expected[2], accc_ApexUtilities.makeCacheIdentifier(null, label));

    } // end of testmakeCacheIdentifier
    @isTest
    static void testgetNamespace() {
        string ns = 'highlevel',
               section = 'caching',
               hier = accc_ApexUtilities.formProviderNameAccess (ns, section);
        string result = accc_ApexUtilities.getNamespace(hier);
        system.assertEquals(ns, result);

    }     // end of testgetNamespace

    @isTest
    static void testsection() {
        string ns = 'highlevel',
               section = 'caching',
               hier =  accc_ApexUtilities.formProviderNameAccess (ns, section);
        string result = accc_ApexUtilities.getSection(hier);
        system.assertEquals(section, result );

    }     // end of testsection

    @isTest
    static void testmakeLocalCacheKey() {
        final string cat = 'highlevel',
                     label = 'caching';
        string result = cat + '.' + label;

        system.assertEquals(result, accc_ApexUtilities.makeLocalCacheKey (cat, label) );
        system.assertEquals(cat, accc_ApexUtilities.makeLocalCacheKey (cat, null) );
        system.assertEquals(label, accc_ApexUtilities.makeLocalCacheKey (null, label) );
    }     // end of testmakeLocalCacheKey
    @isTest
    static void testformatNumberIntoUSTelephone() {
        String expected = '(111) 111-1111',
               converted = '1111111111';
        // assign/act/assert
        System.assertEquals(accc_ApexUtilities.formatNumberIntoUSTelephone(converted), expected);
        System.assertEquals(accc_ApexConstants.EmptyString, accc_ApexUtilities.formatNumberIntoUSTelephone(null));

    }    // end of testformatNumberIntoUSTelephone
    @isTest
    static void testconvertStringOfNumbersIntoUSTelephone() {
        String expected = '(111) 111-1111',
               converted = '1111111111';
        // assign/act/assert
        System.assertEquals(accc_ApexUtilities.convertStringOfNumbersIntoUSTelephone(converted), expected);
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
            List<String> result = accc_ApexUtilities.splitStringOnWhitespacesCommaOrSemiColon(input);
            // assert
            system.assertNotEquals(null, result);
            system.assertEquals(testOracle.get(input), result.size());
        }
        List<String> result = accc_ApexUtilities.splitStringOnWhitespacesCommaOrSemiColon(null);
        // assert
        system.assertEquals(0, result.size());
    } // end of testsplitStringOnWhitespacesCommaOrSemiColon

    @isTest static void testgenerateRandomNumberString() {
        //assign
        integer size = 10;
        string value = accc_ApexUtilities.generateRandomNumberString(size);
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

            List<String> result = accc_ApexUtilities.splitStringOnExpression(input, expresion.get(inx));
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
        String expected = accc_ApexUtilities.newGuid();
        String result = accc_ApexUtilities.newGuid();
        // assert
        System.assertNotEquals(expected, result);
    }    // end of testnewGuid

    @isTest static void testgetSection() {
        //assign
        String known = 'DataCaching.All';
        // act
        String ns = accc_ApexUtilities.getSection(known);
        // assert
        System.assertNotEquals(accc_ApexConstants.All_s, ns);
    }    // end of testgetSection
    @isTest
    static void testsplitStringOnExpressionWithBadParams() {
        // assign
        integer inx = 0;
        //  act

        List<String> result = accc_ApexUtilities.splitStringOnExpression(null, null);
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
            Boolean result = accc_ApexUtilities.isValidTelephoneUSorInternational(input);
            // assert
            system.assertEquals(testOracle.get(input), result, 'error at ' + inx);
            inx++;
        }
    }     // end of testAllTelephoneNumbers


    @isTest
    static void testconvertStringToInt() {
        String val = '100';
        Integer result = accc_ApexUtilities.convertStringToInt(val, -1);
        system.assertEquals(true, 100 == result);
    }     // end of testconvertStringToInt


    @isTest
    static void testconvertStringToIntWithBadValue() {

        Integer result = accc_ApexUtilities.convertStringToInt(null, -1);
        system.assertEquals(true, -1 == result);
    }     // end of testconvertStringToIntWithBadValue

    @isTest
    static void testconvertStringToIntWithBadValueString() {
        string val = 'hello';
        Integer result = accc_ApexUtilities.convertStringToInt(val, -1);
        system.assertEquals(true, -1 == result);
    }     // end of testconvertStringToIntWithBadValueString

    @isTest
    static void testnormalizeString() {
        string val = null;
        string result = accc_ApexUtilities.normalizeString(val);
        system.assertEquals(true, accc_ApexConstants.EmptyString == result);
    }     // end of testnormalizeString

    @isTest
    static void testnormalizeStringWithFalse() {
        final string val = ' 123 ';
        string result = accc_ApexUtilities.normalizeString(val, false);
        system.assertEquals(val, result);
    }     // end of testnormalizeStringWithFalse

    @isTest
    static void testnormalizeStringWithTrue() {
        final string val = ' 123 ';
        final string expected = '123';
        string result = accc_ApexUtilities.normalizeString(val, true);
        system.assertEquals(expected, result);
    }     // end of testnormalizeStringWithTrue

    @isTest
    static void testnormalizeStringValidString() {
        final string expected = 'hello';
        string result = accc_ApexUtilities.normalizeString(expected);
        system.assertEquals(true, expected == result);
    }     // end of testnormalizeStringValidString

    @isTest
    static void testnormalizeStringValidStringWithSize() {
        final string expected = 'hello';
        string result = accc_ApexUtilities.normalizeString(expected, 1);
        system.assertEquals(true, 'h' == result);
    }     // end of testnormalizeStringValidStringWithSize

    @isTest
    static void testnormalizeStringWithTrim() {
        String data = '  1221  ';
        String expected = '1221';
        String maxString = '';
        String result = accc_ApexUtilities.normalizeString(data, true,expected.length() );
        System.assertEquals( expected,result);
        result = accc_ApexUtilities.normalizeString(data, false, '  12'.length());
        System.assertEquals('  12',result);
        for (integer inx = 0; inx < accc_ApexConstants.MAX_STRING_SIZE + 2; inx++) {
            maxString += 'a';
        }
        result = accc_ApexUtilities.normalizeString(maxString, true,accc_ApexConstants.MAX_STRING_SIZE);
        System.assertEquals(result.length(), accc_ApexConstants.MAX_STRING_SIZE);
    }     // end of testnormalizeStringWithTrim


    /**
     * @description test toString
     */
    @isTest static void testtoString() {
        //assign
        Boolean expected = true;
        // act
        Boolean result = accc_ApexUtilities.toString(new accc_ApexUtilities()).contains('accc_ApexUtilities');
        // assert
        System.assertEquals(expected, result);
    }     // end of testtoString
    /**
     * @description test empty toString
     */
    @isTest static void testtoStringNull() {
        //assign
        String expected =  accc_ApexConstants.EmptyString;
        // act
        String result = accc_ApexUtilities.toString(null, expected);
        // assert
        System.assertEquals(expected, result);
    } // end of testtoStringNull

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+ END
// These tests above will be deprecated once the delegated fuctionality is moved out of
// accc_ApexUtilities and rest completely in accc_ApexUtilities
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

} // end of accc_ApexUtilitiesTest