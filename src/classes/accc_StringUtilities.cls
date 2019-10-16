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
 * @description common string utilities to separate mundane task.
 * This may be refactor to segragate category (strings, objects, etc.)
 * Currently, we delegate to accc-ApexUtilities until factored out.
 *
 ** Modification :
 *
 * @group Miscellaneous
 */
public without sharing class accc_StringUtilities {
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
    /**
     *  @description form the provder name for entity access
     * [deprecating to accc_StringUtilities]
     * @param namespace String
     * @param section String
     *
     * @return String -- 'ns:section'
     */
    public static String formProviderNameAccess(String namespace, String section) {
        String ns = namespace == null ? accc_ApexConstants.EmptyString : namespace;
        String sct = section == null ? accc_ApexConstants.EmptyString : section;

        return ns + accc_ApexConstants.ColonDelimiter + sct;
    }  // end of formProviderNameAccess
    /**
     *  @description get namespace  ( w/ delimiter of ':')
     * @param value String
     * @return String namespace
     */
    public static String getNamespace(String value) {
        return accc_StringUtilities.getNamespace(value, accc_ApexConstants.ColonDelimiter);
    }  // end of getNamespace

    /**
     *  @description get namespace
     * @param value String
     * @param delimiter String
     *
     * @return String namespace
     */
    public static String getNamespace(String value, String delimiter) {
        return accc_StringUtilities.getSection(value, delimiter, 0);
    }  // end of getNamespace

    /**
     *  @description get section ( w/ delimiter of ':')
     * @param value String
     * @return String
     */
    public static String getSection(String value) {
        return accc_StringUtilities.getSection(value, accc_ApexConstants.ColonDelimiter, 1);
    }  // end of getSection
    /**
     * @description get section
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
    }  // end of getSection
    /**
     * @description Unique Guid
     * @return String unique
     */
    public static String newGuid() {

        Blob crytoBlob = Crypto.GenerateAESKey(128);
        return EncodingUtil.ConvertTohex(crytoBlob);
    }  // end of newGuid
    /**
     * @description get the string of the value
     *
     * @param obj object you want the string value
     * @return string value of object
     */
    public static String toString(Object obj) {

        return accc_StringUtilities.toString(obj, accc_ApexConstants.EmptyString);
    }  // end of toString

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
    }  // end of toString
    /**
     * @description create the cache identifier
     * [deprecating to accc_StringUtilities]
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

    }  // end of makeCacheIdentifier
    /**
     * @description use to generate a random number/string by size
     * [deprecating to accc_StringUtilities]
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
    }// end of generateRandomNumberString

    /**
     *  @description convert string of numbers to telephone #
     * [deprecating to accc_StringUtilities]
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
        return accc_StringUtilities.convertStringOfNumbersIntoUSTelephone(formatphone);

    } // end of formatNumberIntoUSTelephone
    /**
     *  @description convert string of numbers to telephone #
     * [deprecating to accc_StringUtilities]
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
     * [deprecating to accc_StringUtilities]
     *
     * @param phoneNumber what is considered a telephone
     * @return true if valid us or international #
     */
    public static Boolean isValidTelephoneUSorInternational(string phoneNumber) {
        return accc_StringUtilities.isStringOfNumbersValidTelephoneWithRegex(phoneNumber, accc_ApexConstants.ALL_TELEPHONE_REGEX);
    } // end of isValidTelephoneUSorInternational
    /**
     *
     * @description convert string of numbers to  us or international telephone #
     * [deprecating to accc_StringUtilities]
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
     * [deprecating to accc_StringUtilities]
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
            result = accc_StringUtilities.splitStringOnExpression(extraneous, '\\s+');
        } else {
            result = new List<String>();
        }
        return result;
    } // end of splitStringOnWhitespacesCommaOrSemiColon

    /**
     *  @description split a string based on expression ( ie. whitespace \s)
     * [deprecating to accc_StringUtilities]
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
    }// end of splitStringOnExpression
    /**
     * @description make the local cache key
     * [deprecating to accc_StringUtilities]
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
    }// end of makeLocalCacheKey
     /**
      * @description convert a list into a max. string, delimiter by some value
      * [deprecating to accc_StringUtilities]
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
    }// end of convertListCollectionIntoString
    /**
     * @description get month string
     * [deprecating to accc_StringUtilities]
     *
     * @param value month values 1 to 12
     * @return two char string, 1 == '01'
     */
    public static String convertMonthToString(integer value) {
        integer index = value <= 0 ?  1 : value > MAX_NUM_OF_MONTH ? MAX_NUM_OF_MONTH : value;
        return MonthIndex.get(index);
    }// end of convertMonthToString

    /**
     * @description get month string
     * [deprecating to accc_StringUtilities]
     *
     * @param value month values 1 to 31
     * @return two char string, 1 == '01'
     */
    public static String convertDayToString(integer value) {
        integer index = value <= 0 ?  1 : value > MAX_DAY_IN_MONTH ? MAX_DAY_IN_MONTH : value;
        return DayIndex.get(index);
    }// end of convertDayToString


    /**
     *  @description normalize the data
     *
     * @param datum string to inspect
     * @return string, normalize string
     */
    public static string normalizeString(String datum) {
        return accc_StringUtilities.normalizeString(datum, false);
    } // end of normalizeString
      /**
       *
       * @description normalize the data and trim
       * [deprecating to accc_StringUtilities]
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
     * [deprecating to accc_StringUtilities]
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
     * [deprecating to accc_StringUtilities]
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
            result = accc_StringUtilities.normalizeString(result, size);
        }
        return result;
    } // end of normalizeString

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
    }  // end of returnDelimiterSeparatedString
    /**
     *  @description convert string to integer
     * [deprecating to accc_StringUtilities]
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
    }// end of convertStringToInt
}// end of accc_StringUtilities