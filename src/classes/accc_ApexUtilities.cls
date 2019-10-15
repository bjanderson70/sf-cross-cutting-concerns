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
 * @author Bill anderson
 * @description common utilities to separate mundane task. This may be refactor to segragate category (strings, objects, etc.)
 *
 ** Modification : BJA , Support for Platform Events routines added
 *
 * @group Miscellaneous
 */
public without sharing class accc_ApexUtilities {

    ////////////////////////////////////////////////////////////////////////////////
    /// Data Members
    ////////////////////////////////////////////////////////////////////////////////

    public static final integer MAX_DAY_IN_MONTH = 31;
    public static final integer MAX_NUM_OF_MONTH = 12;

    /**
     * Month Index to 2 char string
     */
    private static Map<Integer, String> MonthIndex = new Map<Integer, String> {
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
    };
    /**
     * Day indexto 2 char string
     */
    private static Map<Integer, String> DayIndex = new Map<Integer, String> {
        1 => '01', 2 => '02', 3 => '03', 4 => '04', 5 => '05', 6 => '06', 7 => '07', 8 => '08', 9 => '09', 10 => '10'
        , 11 => '11', 12 => '12', 13 => '13', 14 => '14', 15 => '15', 16 => '16', 17 => '17', 18 => '18', 19 => '19', 20 => '20'
        , 21 => '21', 22 => '22', 23 => '23', 24 => '24', 25 => '25', 26 => '26', 27 => '27', 28 => '28', 29 => '29', 30 => '30'
        , 31 => '31'
    };

    @TestVisible
    private static List<String> logTestData = null;
    // simple mechanism to cache last id
    @TestVisible
    private static String lastProfileName =  null;
    // imple cache of last profile id
    @TestVisible
    private static Id lastProfileId = null;
    // determine if sandbox
    @TestVisible
    private static final Boolean isSandboxBool = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    // holds valid domain names
    @TestVisible
    private static Set<String> m_domainNames = new  Set<String>();
    // holds valid event names
    @TestVisible
    private static Set<String> m_eventNames = new  Set<String>();

    ////////////////////////////////////////////////////////////////////////////////
    /// Public Methods
    ////////////////////////////////////////////////////////////////////////////////
    /**
     *
     * @description is this a sanbox
     * @return true, if sandbox
     */
    public static Boolean isSandbox() {
        return accc_ApexUtilities.isSandboxBool;
    }
    /**
     *
     * @description Method Name of the caller
     *
     * @param thisClass the object
     * @return String - Method name
     */
    public static String getClassName(Object thisClass) {
        String currentClassName = accc_ApexConstants.EmptyString;
        if ( thisClass != null ) {
            List<String> items = String.valueOf(thisClass).split(accc_ApexConstants.ColonDelimiter);
            if ( items.size() > 0 ) {
                currentClassName = items[0];
            }
        }
        return currentClassName;
    } // end of getClassName
    /**
     *
     * @description get the name of the sobject
     *
     * @param mySobject SObject
     * @return String - name of the sobject
     */
    public static String getSobjectName(SObject mySobject) {
        return mySobject != null ? mySobject.getsObjectType().getDescribe().getName() : accc_ApexConstants.EmptyString;
    } // end of getSobjectName
    /**
     *
     * @description get the name of the sobject
     *
     * @param mySobject List<SObject>
     * @return String - name of the sobject
     */
    public static String getSobjectName(List<SObject> mySobject) {
        String result = accc_ApexConstants.EmptyString;
        if ( mySobject != null ) {
            Type sType = accc_ApexUtilities.getTypeFromSObject(mySobject);
            if ( sType != null ) {
                result = sType.getName();
            }
        }
        return result;
    } // end of getSobjectName
    /**
     *
     * @description get the name of the sobject
     *
     * @param mySobject Set<SObject>
     * @return String - name of the sobject
     */
    public static String getSobjectName(Set<SObject> mySobject) {
        String result = accc_ApexConstants.EmptyString;
        if ( mySobject != null ) {
            Type sType = accc_ApexUtilities.getTypeFromSObject(mySobject);
            if ( sType != null ) {
                result = sType.getName();
            }
        }
        return result;
    } // end of getSobjectName

    /**
     *  @description form the provder name for entity access
     *
     * @param namespace String
     * @param section String
     *
     * @return String -- 'ns:section'
     */
    public static String formProviderNameAccess(String namespace, String section) {
        String ns = namespace == null ? accc_ApexConstants.EmptyString : namespace;
        String sct = section == null ? accc_ApexConstants.EmptyString : section;

        return ns + accc_ApexConstants.ColonDelimiter + sct;
    } // end of formProviderNameAccess
    /**
     *  @description get namespace  ( w/ delimiter of ':')
     *
     * @param value String
     * @return String namespace
     */
    public static String getNamespace(String value) {
        return accc_ApexUtilities.getNamespace(value, accc_ApexConstants.ColonDelimiter);
    } // end of getNamespace

    /**
     *  @description get namespace
     *
     * @param value String
     * @param delimiter String
     *
     * @return String namespace
     */
    public static String getNamespace(String value, String delimiter) {
        return accc_ApexUtilities.getSection(value, delimiter, 0);
    } // end of getNamespace

    /**
     *  @description get section ( w/ delimiter of ':')
     *
     * @param value String
     * @return String
     */
    public static String getSection(String value) {
        return accc_ApexUtilities.getSection(value, accc_ApexConstants.ColonDelimiter, 1);
    } // end of getSection
    /**
     * @description get section
     *
     * @param value String
     * @param delimiter String
     *
     * @return string section
     */
    public static String getSection(String value, String delimiter, Integer index) {
        String result = null;
        if ( !String.isBlank(value) ) {
            List<String> items = value.split(delimiter);
            if ( items.size() > index ) {
                result = items[index];
            }
        }
        return result;
    } // end of getSection
    /**
     * @description Unique Guid
     * @return String unique
     */
    public static String newGuid() {

        Blob crytoBlob = Crypto.GenerateAESKey(128);
        return EncodingUtil.ConvertTohex(crytoBlob);
    } // end of newGuid
    /**
     * @description get the string of the value
     *
     * @param obj object you want the string value
     * @return string value of object
     */
    public static String toString(Object obj) {

        return accc_ApexUtilities.toString(obj, accc_ApexConstants.EmptyString);
    } // end of toString

    /**
     * @description get the string of the value
     *
     * @param obj object you want the string value
     * @param defaultValue default string value
     * @return string value of object
     */
    public static String toString(Object obj, String defaultValue) {
        String result = defaultValue;
        if ( obj != null ) {
            result = String.valueOf(obj);
        }
        return result == null ? accc_ApexConstants.EmptyString : result;
    } // end of toString

    /**
     * @description convert a maps of ids to a list of ids
     *
     * @param mapOfIds Map<Id,SObject>
     * @return List<Id>
     */
    public static List<Id> convertMapOfIdsToListOfIds(Map<Id, SObject> mapOfIds) {
        List<Id> idList = new List<Id>();
        if ( mapOfIds != null && mapOfIds.size() > 0 ) {
            idList.addAll(mapOfIds.keyset());
        }
        return idList;
    } // end of convertMapOfIdsToListOfIds
    /**
     *  @description convert a maps of values to a list of values
     *
     * @param mapOfIds Map<Id,SObject>
     * @return List<SObject>
     */
    public static List<SObject> convertMapOfValuesToListOfValues(Map<Id, SObject> mapOfValues) {
        List<SObject> valueList = new List<SObject>();
        if ( mapOfValues != null && mapOfValues.size() > 0 ) {
            valueList.addAll(mapOfValues.values());
        }
        return valueList;
    } // end of convertMapOfValuesToListOfValues

    /**
     * @description convert a list of values to a map of values
     *
     * @param listOfValues List<SObject>
     * @return Map<Id, SObject>
     */
    public static Map<Id, SObject> convertListToMapOfValues(List<SObject> listOfValues) {
        Map<Id, SObject> mapValues = new Map<Id, SObject> ();
        if ( listOfValues != null && listOfValues.size() > 0 ) {
            mapValues.putAll(listOfValues);
        }
        return mapValues;
    } // end of convertListToMapOfValues
    /**
     * @description  get ids from a list of records
     *
     * @param sObjects  container of the records
     * @return  collection of Ids
     */
    public static List<Id> getRecordIds(List<SObject> sObjects) {
        List<Id> ids = new List<Id>();
        if ( sObjects  != null && sObjects.size() > 0 ) {
            for (SObject myId : sObjects) {
                ids.add(myId.id);
            }
        }

        return ids;
    } // end of getRecordIds
    /**
     * @description safe field extaction from sobject
     *
     * @param sobj SObject
     * @param fieldName
     *
     * @return [description]
     */
    public static String getFieldFromSObjectSafe(SObject theSObject, String fieldName) {
        String result = accc_ApexConstants.EmptyString;
        try {
            result = (String)theSObject.get(fieldName);
        } catch (Exception excp) {
            // process exception
            accc_ApexEnvironment.getRuntimeEnvironment().exceptionHandler().process(excp);
        }
        return result;
    }// end of getFieldFromSObjectSafe

    /**
     * @description Get the user's profile name
     * @return profile string name
     */
    public static String userProfileName() {
        Id profileId = userinfo.getProfileId();
        if ( accc_ApexUtilities.lastProfileId != profileId) {
            accc_ApexUtilities.lastProfileName = [Select Id, Name from Profile where Id = :profileId].Name;
            accc_ApexUtilities.lastProfileId = profileId;
        }
        return accc_ApexUtilities.lastProfileName == null ? accc_ApexConstants.EmptyString : accc_ApexUtilities.lastProfileName;
    }// end of userProfileName
    /**
     * @description create the cache identifier
     *
     * @param category category of the cache entry, if any ( can be null or empty)
     * @param label label of the cache entry
     *
     * @return a formatted string for the cach entry identifier
     */
    public static String makeCacheIdentifier(String category, String label) {
        string identifier = category == null ? accc_ApexConstants.EmptyString : category,
               normalizeLbl  = label == null ? accc_ApexConstants.EmptyString : label;

        if (normalizeLbl.length() > 0 ) {
            if (identifier.length() > 0 ) {
                identifier += accc_ApexConstants.Period;
            }
            identifier += normalizeLbl;
        }
        return identifier;

    } // end of makeCacheIdentifier
    /**
     *  @description iterate over field names getting value from the SOBject
     *
     * @param sobj SObject
     * @param fieldName fields (comma separate, perhaps)
     *
     * @return [description]
     */
    public static String iterateOverFieldNamesInSObject(SObject sobj, String fieldName) {
        String result = accc_ApexConstants.EmptyString;
        if ( fieldName != null
             && sobj != null ) {
            List<String> fields = fieldName.split(accc_ApexConstants.CommaDelimiter);
            Integer sz = fields.size();

            for (String item : fields ) {
                // get the name of the sobject, if any
                result += accc_ApexUtilities.getFieldFromSObjectSafe(sobj, item);
                if ( sz > 0 ) {
                    result += ' ';
                }
            } // endfor
        } // endif
        return result.trim();
    } // end of iterateOverFieldNamesInSObject

    /**
     *  @description Does the Sobject contain a field
     *
     * @param theSObject the object to check the field on
     * @return True, if the field exists
     */
    public static Boolean containsFieldInSObject(SObject theSObject, string fieldName) {

        Boolean result = false;

        if ( theSObject == null ) {
            return result;
        }

        try {
            // if the field is invalid, and exception is thrown
            theSObject.get(fieldName);
            result = true;
        } catch (Exception excp ) {
            // ignored at this time
        }

        return result;

    } // end of containsFieldInSObject
    /**
     *  @description get the fields information based on a sobject name (i.e. account, contact, etc.)
     *
     * @param objName sobject name
     * @return map of field information
     */
    public static Map<String, SObjectField> getSObjectFieldsInformation(String objName) {
        Map<String, SObjectField> results = null;
        if ( objName != null) {
            SObjectType objToken = Schema.getGlobalDescribe().get(objName);
            if ( objToken != null ) {
                DescribeSObjectResult objDef = objToken.getDescribe();
                results = objDef.fields.getMap();
            }
        }
        return results;
    } // end of getSObjectFieldsInformation
    /**
     *  @description get a record index by name
     *
     * @param rec SObject
     * @param index , string name
     *
     * @return string value of record indexed at location index
     */
    public static String getRecordByName(SObject rec, String index) {
        String returnValue = accc_ApexConstants.EmptyString;
        try {
            Object value = rec.get(index);
            returnValue = value == null ? accc_ApexConstants.EmptyString : accc_ApexUtilities.toString(value);
        } catch (Exception excp) {
            // ignored at this time
        }
        return returnValue;

    } // end of getRecordByName
      /**
       *
       * @description use to generate a random number/string by size
       *
       * @param sizeOfString size of string returned
       * @return string by size 'sizeOfString'
       */

    public static String generateRandomNumberString(integer sizeOfString) {

        final string characters = '0123456789';
        final integer charactersLen = characters.length();
        string randonString = accc_ApexConstants.EmptyString;
        integer index = 0;

        while ( randonString.length() < sizeOfString) {
            index = Math.Mod(Math.abs(Crypto.getRandomInteger()), charactersLen);
            randonString += characters.substring(index, index + 1);
        }
        return randonString;
    } // end of generateRandomNumberString

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
            // process exception
            accc_ApexUtilities.log(excp);
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

            // can only assume ALL the same
            if ( theSObject != null ) {
                Schema.SObjectType sType = theSObject.getSobjectType();
                if ( sType != null ) {
                    result = Type.forName(sType.getdescribe().getName());
                }
                if ( result == null && theSObject.size() > 0) {
                    sType = theSObject[0].getSobjectType();
                    if ( sType != null ) {
                        result = Type.forName(sType.getdescribe().getName());
                    }
                }
            }
        } catch  (Exception excp) {
            accc_ApexUtilities.log(excp);
        }
        return result;
    } // end of getTypeFromSObject

    /**
     *  @description  get the Type from the SObject collection
     *
     * @param theSObject type we want
     * @return System Type
     */
    public static Type getTypeFromSObject(Set<SObject> theSObject) {
        Type result = null;
        try {
            // can only assume ALL the same
            if ( theSObject != null ) {
                result= accc_ApexUtilities.getTypeFromSObject(new List<SObject>(theSObject));
            }
        } catch  (Exception excp) {
             accc_ApexUtilities.log(excp);
        }
        return result;
    } // end of getTypeFromSObject
    /*
     * Get executing class and method name borrowed (with slight modifications)
     * https://salesforce.stackexchange.com/questions/153835/get-currently-executing-class-method-name
     */
    /**
     *  @description get executing class name
     * @return executing class name
     */
    public static String getExecutingClassName() {
        string trace = accc_ApexUtilities.popStack(new DmlException().getStackTraceString());

        return accc_ApexUtilities.getExecutingClassName(trace);
    }
    /**
     *  @description get the executing method name
     * @return method name
     */
    public static String getExecutingMethod() {
        string trace = accc_ApexUtilities.popStack(new DmlException().getStackTraceString());

        return accc_ApexUtilities.getExecutingMethod(trace);
    }
    /**
     *  @description get the executing class name from an stack trace
     *
     * @param string stack trace
     * @return string class name
     */
    public static String getExecutingClassName(String line) {
        String result = accc_ApexConstants.EmptyString;
        if ( !string.isblank(line) ) {
            final string tag = 'Class.';
            if (line.startsWith(tag)) {
                line = line.substringAfter(tag);
                if ( !string.isblank(line) ) {
                    result = line.substringBefore(':').substringBeforeLast('.');
                }
            }
        }
        return result;
    } // end of getExecutingClassName

    /**
     *  @description get the executing lineno from an stack trace
     *
     * @param String stack trace
     * @return string line number
     */
    public static String getExecutingLineNumber(String line) {
        String result = accc_ApexConstants.EmptyString;
        if ( !string.isblank(line) ) {
            final string tag = 'Class.';
            if (line.startsWith(tag)) {
                line = line.substringAfter(tag);
                if ( !string.isblank(line) ) {
                    result = line.substringBetween('line', ',');
                }
            }
        }
        return result;
    } // end of getExecutingLineNumber

    /**
     *  @description get the executing method name from an stack trace
     *
     * @param line from the stack trace
     * @return method name
     */
    public static String getExecutingMethod(String line) {
        String result = accc_ApexConstants.EmptyString;
        if ( !string.isblank(line) ) {
            line = line.substringBefore(':');
            if ( !string.isblank(line) ) {
                result = line.substringAfterLast('.');
            }
        }
        return result;
    } // end of getExecutingMethod

    /**
     *
     * @description Log Information, makes it easier to refactor for a logger later
     * @param String message
     * @param Boolean controlOutput control whether to output or not
     */
    public static void log(String theMessage, Boolean controlOutput) {
        if (  controlOutput ) {
            accc_ApexUtilities.log(theMessage);
        }
    } // end of log
    /**
     *
     * @description Log Information, makes it easier to refactor for a logger later
     * @param String message
     */
    public static void log(String message) {
        if ( message != null ) {
            accc_IApexRunEnvironment runtime = accc_ApexEnvironment.getRuntimeEnvironment();

            // used to test information sent from a test
            accc_ApexUtilities.logForTesting(message);

            // information is logged internally or controlled by sys-admin

            String trace = accc_ApexUtilities.popStack(new DmlException().getStackTraceString()),
                   className = accc_ApexUtilities.getExecutingClassName(trace),
                   methodName = accc_ApexUtilities.getExecutingMethod(trace),
                   logMsg = '+++ [' + className + '] [' + methodName + '] ' + message;
            // log it
            runtime.logger().write(logMsg);

        }
    } // end of log

    /**
     *  @description convience routine to log exceptions via ApplicationLog
     *
     * @param excp Exception
     */
    public static void log(Exception excp) {
        if (excp != null) {
            accc_IApexRunEnvironment runtime = accc_ApexEnvironment.getRuntimeEnvironment();
            // used to test information sent from a test
            accc_ApexUtilities.logForTesting(excp.getMessage());
            // handle execptions
            runtime.exceptionHandler().process(excp);

        }
    } // end of log
    /**
     *
     * @description Trace Information, makes it easier to refactor for a logger later
     * @param String message
     */
    public static void trace(String message) {
        if ( message != null ) {
            accc_IApexRunEnvironment runtime = accc_ApexEnvironment.getRuntimeEnvironment();

            // used to test information sent from a test
            accc_ApexUtilities.logForTesting(message);

            // information is logged internally or controlled by sys-admin

            String trace = accc_ApexUtilities.popStack(new DmlException().getStackTraceString()),
                   className = accc_ApexUtilities.getExecutingClassName(trace),
                   methodName = accc_ApexUtilities.getExecutingMethod(trace),
                   logMsg = '+++ [' + className + '] [' + methodName + '] ' + message;
            // log it
            runtime.logger().trace(logMsg);

        }
    } // end of trace
    /**
     *
     * @description Log Information for testing
     */
    public static void logForTesting(String message) {
        if ( message != null && accc_ApexConstants.UNIT_TEST_RUNNING ) {
            // used to test information sent from a test
            accc_ApexUtilities.writeDataForTesting(message);
        }
    } // end of logForTesting

    /**
     *  @description convert string of numbers to telephone #
     *
     * @param phone string of numbers '1111111111' or '(111) 111-1111'
     * @return converted to telephone (111) 111-1111
     */
    public static String formatNumberIntoUSTelephone(String phone) {
        // valid number
        if ( string.isBlank(phone) ) {
            return accc_ApexConstants.EmptyString;
        }

        // strip to numbers
        String formatphone = phone.replaceAll('\\D', accc_ApexConstants.EmptyString);
        // now format accordingly
        return accc_ApexUtilities.convertStringOfNumbersIntoUSTelephone(formatphone);

    } // end of formatNumberIntoUSTelephone
    /**
     *  @description convert string of numbers to telephone #
     *
     * @param stringOfNums string of numbers '1111111111'
     * @return converted to telephone (111) 111-1111
     */
    public static String convertStringOfNumbersIntoUSTelephone(String stringOfNums) {

        if (stringOfNums != null &&
            stringOfNums.length() == accc_ApexConstants.US_TELEPHONE_SIZE) {
            stringOfNums = '('
                           + stringOfNums.substring(0, 3)
                           + ') '
                           + stringOfNums.substring(3, 6)
                           + '-'
                           + stringOfNums.substring(6);
        }
        return stringOfNums;

    } // end of convertStringOfNumbersIntoUSTelephone

    /**
     *  @description  Is this incoming number a valid telephone number
     *
     * @param phoneNumber what is considered a telephone
     * @return true if valid us or international #
     */
    public static Boolean isValidTelephoneUSorInternational(string phoneNumber) {
        return accc_ApexUtilities.isStringOfNumbersValidTelephoneWithRegex(phoneNumber, accc_ApexConstants.ALL_TELEPHONE_REGEX);
    } // end of isValidTelephoneUSorInternational
    /**
     *
     * @description convert string of numbers to  us or international telephone #
     *
     * @param stringOfNums string of numbers '1111111111'
     * @param userRegex regular expression
     * @return Boolean true, if valid
     */
    public static Boolean isStringOfNumbersValidTelephoneWithRegex(String stringOfNums, String userRegex) {

        Boolean results = false;
        if ( !string.IsBlank(stringOfNums)
             && !string.isBlank(userRegex)) {
            Pattern phoneFormatPattern = Pattern.compile(userRegex);
            Matcher myFormatMatcher = phoneFormatPattern.matcher(stringOfNums);
            results = myFormatMatcher.matches();

        }
        return results;

    } // end of isStringOfNumbersValidTelephoneWithRegex
    /**
     *  @description split a string on whitespace, comma or semi-colon
     *
     * @param input string to split
     * @return collection of split strings or empty collection
     */
    public static List<String> splitStringOnWhitespacesCommaOrSemiColon(String input) {
        List<String> result = null;
        // this regex will treat pre/post whitespace as a single whitespace; thus,
        // '   a  ,  b ;c' ==> returns collection size of 3 [a,b,c]
        if ( input != null && input.length() > 0 ) {
            // replace ALL expressions with a single whitespace (' ')
            string extraneous = input.replaceAll('[,;\\s+]', accc_ApexConstants.WhitespaceString);
            // now all we have to do is split on a single whitespace
            result = accc_ApexUtilities.splitStringOnExpression(extraneous, '\\s+');
        } else {
            result = new List<String>();
        }
        return result;
    } // end of splitStringOnWhitespacesCommaOrSemiColon


    /**
     *  @description get a list of ids in a string format delimited by 'delimiter'
     *
     * @param sList collection of SObject
     * @param delimiter string value, ie. comma, space, etc.
     *
     * @return string delimited data
     */
    public static String returnDelimiterSeparatedStringOfIds(List<SObject> sList, string delimiter) {
        String result = accc_ApexConstants.EmptyString;
        if ( sList != null  && sList.size() > 0 ) {
            Set<Id> mySet = new Map<Id, SObject>(sList).keyset();
            result = returnDelimiterSeparatedStringOfIds(new List<Id>(mySet), delimiter);
        }
        return result;
    } // end of returnDelimiterSeparatedString
    /**
     *  @description get a list of ids in a string format delimited by 'delimiter'
     *
     * @param sList collection of SObject
     * @param delimiter string value, ie. comma, space, etc.
     *
     * @return string delimited data
     */
    public static String returnDelimiterSeparatedStringOfIds(List<Id> sList, string delimiter) {
        String result = accc_ApexConstants.EmptyString,
               mydelimiter = delimiter == null ? accc_ApexConstants.CommaDelimiter : delimiter;

        if ( sList != null  && sList.size() > 0 ) {
            result = String.join(sList, mydelimiter);
        }
        return result;
    } // end of returnDelimiterSeparatedString

    /**
     *  @description convert string to integer
     *
     * @param value string to convert
     * @param defaultValue default value in the event the value string is bad
     *
     * @return integer converted string
     */
    public static integer convertStringToInt(string value, integer defaultValue) {
        integer val = defaultValue;
        if ( !string.isBlank(value)) {
            try {
                val = Integer.valueOf(value);
            } catch (Exception excp) {
                // process exception
                accc_ApexEnvironment.getRuntimeEnvironment().exceptionHandler().process(excp);
            }
        }
        return val;
    } // end of convertStringToInt

    /**
     *
     * @description get the type by name
     *
     * @param name the name of the type
     * @return Type
     */
    public static Type getTypeByName(String name) {
        return accc_ApexUtilities.getTypeByName(accc_ApexConstants.EmptyString, name);
    } // end of getTypeByName
    /**
     *  @description get the type by namespace and name
     *
     * @param String, the namespace of the type
     * @param String the name of the type
     * @return Type
     */
    public static Type getTypeByName(String namespace, String name) {
        Type objType = null;

        if ( !string.isBlank(name) ) {
            String ns = namespace == null ? accc_ApexConstants.EmptyString : namespace;

            objType = Type.forName(name);
            if ( objType == null ) {
                objType = Type.forName(ns, name);
            }
        }

        return objType;
    } // end of getTypeByName

    /**
     *  @description normalize the data
     *
     * @param datum string to inspect
     * @return string, normalize string
     */
    public static string normalizeString(String datum) {
        return accc_ApexUtilities.normalizeString(datum, false);
    } // end of normalizeString
    /**
     *
     * @description normalize the data and trim
     *
     * @param string data to inspect
     * @param boolean, true if trim
     * @return string, normalize string
     */
    public static string normalizeString(String datum, Boolean dotrim) {
        string result = accc_ApexConstants.EmptyString;
        if ( !string.isBlank(datum) ) {
            if ( dotrim ) {
                result = datum.trim();
            } else {
                result = datum;
            }
        }

        return result;
    } // end of normalizeString
    /**
     *
     * @description normalize the data
     *
     * @param datum string to inspect
     * @return string, normalize string
     */
    public static string normalizeString(String datum, integer maxSize) {
        integer maxSz = maxSize <= -1 ? 1 : maxSize;
        String result = string.isBlank(datum) ? accc_ApexConstants.EmptyString : datum;
        if ( result.length() > maxSize ) {
            result = result.substring(0, maxSz);
        }
        return result;
    } // end of normalizeString

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

        if ( !string.isBlank(datum) ) {
            if ( dotrim ) {
                result = datum.trim();
            } else {
                result = datum;
            }
            result = accc_ApexUtilities.normalizeString(result, size);
        }
        return result;
    } // end of normalizeString
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
        String result = accc_ApexConstants.EmptyString,
               delimiter = theDelimiter == null ? accc_ApexConstants.CommaDelimiter : theDelimiter;
        // any data to convert
        if (theList != null && theList.size() > 0 ) {
            result =  string.join(theList, delimiter);
            if ( theMaxSize > 1
                 && result.length() > theMaxSize) {
                result = result.Substring(0, theMaxSize - 1);
            }
        }
        return result;
    } // end of convertListCollectionIntoString

    /**
     * @description make the local cache key
     *
     * @param String local cache category
     * @param String local cache label
     *
     * @return string local cache key
     */
    public static string makeLocalCacheKey(String category, String label) {
        String partition = string.isBlank(category) ? '' : category;
        if ( !string.isBlank(label) ) {
            if (!string.isBlank(partition) ) {
                partition = partition + '.' + label;
            } else {
                partition = label;
            }
        }
        return partition;
    } // end of makeLocalCacheKey

    /**
     *
     * @description pop the stack to get to the right level of the stack
     *
     * @param strack trace
     * @return second level of the stack
     */
    public static string popStack(string trace) {
        string popTrace = '';

        if ( !string.isBlank(trace) ) {
            popTrace = trace.substringAfter('\n');
            if ( string.isBlank(popTrace) ) {
                popTrace = trace;
            }
        }
        return popTrace;
    } // end of popStack

    /**
     * @description slice an array ( borrow from Adrian Larson)
     * @param input array to slice
     * @param start where to start ( >= 0)
     * @return List<Object>
     **/
    public static List<Object> slice(List<Object> input, Integer start)
    {
        List<Object> output = null;
        if ( input != null ) {
            output= accc_ApexUtilities.slice(input,start,input.size());
        }
        return output;
    }// end of slice
    /**
     * @description slice an array ( borrow from Adrian Larson)
     * @param input arry to slice
     * @param start where to start ( >= 0)
     * @param end  where to end ( > 1)
     * @return List<Object>
     **/
    public static List<Object> slice(List<Object> input, Integer start, Integer last)
    {
        List<Object> output = null;
        if ( input != null
             && start < last) {
            output = input.clone();
            for (Integer inx = 0; inx < start; inx++) {
                output.remove(0);
            }
            Integer elements = last - start;
            while (output.size() > elements) {
                output.remove(elements);
            }
        }
        return output;

    }// end of slice
    /**
     * @description validate that this is an domain name
     *
     * @param domainToValidate name of an domain (i.e. Account)
     * @return true if present
     */
    public static Boolean validDomainName(String domainToValidate) {

        if ( string.isBlank(domainToValidate)) {
            return false;
        }
        // see if we already have the data
        if ( accc_ApexUtilities.m_domainNames.size() == 0) {
            accc_ApexUtilities.updateDomainInformation();
        }
        return accc_ApexUtilities.m_domainNames.contains(domainToValidate.toLowerCase());
    }    // end of validDomainName

    /**
     * @description validate that this is an event
     *
     * @param eventToValidate name of an event (i.e. My_Event__e)
     * @return true if present
     */
    public static Boolean validEventName(String eventToValidate) {
        if ( string.isBlank(eventToValidate)) {
            return false;
        }
        if ( accc_ApexUtilities.m_eventNames.size() == 0) {
            accc_ApexUtilities.updateDomainInformation();
        }
        return accc_ApexUtilities.m_eventNames.contains(eventToValidate.toLowerCase());
    }    // end of validEventName
    /**
     * @description get the class instance
     * @return Object, class instance which must be casted appropriately
     */
    public static Object getClassInstance(String className) {
        Object result = null;
        try {
            // Get the Type corresponding to the class name
            Type cacheType = accc_ApexUtilities.getTypeByName(className);

            // Instantiate the type.
            // The type of the instantiated object is the interface.
            if ( cacheType != null ) {
                result = (Object)cacheType.newInstance();
            }
        } catch (Exception excp) {
            // process exception
            accc_Apexutilities.log(excp);
        }

        return result;

    }// end of getClassInstance

    /**
     * @brief get the Type from the SObject collection (does not handle MIXed SOBject)
     * @description  get the Type from the SObject collection
     *
     * @param theSObject type we want
     * @return System Type
     */
    public static Schema.SObjectType getSobjectTypeFromSObject(List<SObject> theSObject) {
        Schema.SObjectType sType = null;

        try {
            boolean isValid = theSObject != null;
            if ( isValid ) {
                sType = theSObject.getSobjectType();
            }
            // still can't figure it out, then ONLY look at the first one!
            if ( sType == null
                 && isValid
                 && theSObject.size() > 0 ) {
                sType = accc_Apexutilities.getSobjectTypeFromSObject(theSObject[0]);
            }
        } catch  (Exception excp) {

        }

        return sType;
    }     // end of getSobjectTypeFromSObject

    /**
     * @brief get the Type from the SObject collection
     * @description  get the Type from the SObject collection
     *
     * @param theSObject type we want
     * @return System Type
     */
    public static Schema.SObjectType getSobjectTypeFromSObject(SObject theSObject) {
        Schema.SObjectType sType = null;

        try {
            if ( theSObject != null ) {
                sType = theSObject.getSobjectType();
            }
        } catch  (Exception excp) {

        }

        return sType;
    }     // end of getSobjectTypeFromSObject
    /**
     * @description have we exceeded our governor limts?
     *
     * @param excp the exception to analyze to determine if we continue
     * @return true, if we violated a governor limit
     */
    public static Boolean exceededGovernorLimits(Exception excp) {
        // if we get any of these exceptions, then whatever was going
        // on will fail due to limits exceeded -- can't catch some exceptions
        return excp instanceof DmlException ||
               excp instanceof AsyncException ||
               excp instanceof CalloutException;

    }     // end of exceededGovernorLimits
    /**
     *  @description split a string based on expression ( ie. whitespace \s)
     *
     * @param input string to split
     * @param expression expressions (i.e., \s | , | ;)
     *
     * @return collection of strings split by expression
     */
    public static List<String> splitStringOnExpression(string input, string expression) {

        List<String> result = null;
        // we split on whitespace, comma or semi-colon
        if ( !string.isBlank(input)
             && !string.isBlank(expression)
             && input.length() > 0
             && expression.length() > 0) {
            result = input.split(expression);
        } else {
            result = new List<String>();
        }
        return result;
    }     // end of splitStringOnExpression

    /**
     * @description get month string
     *
     * @param value month values 1 to 12
     * @return two char string, 1 == '01'
     */
    public static String convertMonthToString(integer value) {
        integer index = value <= 0 ?  1 : value > MAX_NUM_OF_MONTH ? MAX_NUM_OF_MONTH : value;
        return MonthIndex.get(index);
    }     // end of convertMonthToString

    /**
     * @description get month string
     *
     * @param value month values 1 to 31
     * @return two char string, 1 == '01'
     */
    public static String convertDayToString(integer value) {
        integer index = value <= 0 ?  1 : value > MAX_DAY_IN_MONTH ? MAX_DAY_IN_MONTH : value;
        return DayIndex.get(index);
    }     // end of convertDayToString
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Private Static Methods
    //
    ///////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @description get domain and event information
     */
    @TestVisible
    private static void updateDomainInformation() {
        Map<String, Schema.SObjectType> globalSchemaDesc = Schema.getGlobalDescribe();
        Set<String> objNames = globalSchemaDesc.keySet();
        // any data
        if ( objNames != null && objNames.size() > 0 ) {
            for (String objName : objNames) {
                accc_ApexUtilities.m_domainNames.add(objName.toLowerCase());
                if ( objName.endsWith(accc_ApexConstants.EVENT_TYPE_TAG_s)) {
                    m_eventNames.add(objName.toLowerCase());
                }
            }
        }

    }     // end of updateDomainInformation
    /**
     *  @description write data to the test list
     *
     * @param string the message to write to the list
     */
    @TestVisible
    private static void writeDataForTesting(String message) {
        // used to test information sent from a test
        if ( accc_ApexConstants.UNIT_TEST_RUNNING && message != null) {
            // need to create out internal storage unit
            if ( accc_ApexUtilities.logTestData == null ) {
                accc_ApexUtilities.logTestData = new List<String>();
            }
            accc_ApexUtilities.logTestData.add(message);
        }
    }     // end of writeDataForTesting
    /**
     *  @description check for a string in the test log
     *
     * @param item string to look for
     * @return true, if found
     */
    @TestVisible
    private static Boolean containsInTestLog(String lookFor) {
        Boolean found = false;
        if ( accc_ApexConstants.UNIT_TEST_RUNNING && accc_ApexUtilities.logTestData != null ) {
            for (String item : accc_ApexUtilities.logTestData) {
                if ( (found = item.contains(lookFor)) == true) {
                    break;
                }
            }
        }
        return found;
    }     // end of containsInTestLog

}     // end of accc_ApexUtilities