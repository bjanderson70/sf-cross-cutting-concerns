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
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE
 *
 * @author Bill Anderson
 * @description Common Constants
 * @group Miscellaneous
 * 
 * To Added New Resouce classes  :Step 5a: Ensure Fallback Resources have the Resource Name ( i.e. LogFormatter)
 *
 */
public class accc_ApexConstants {


    // use by the custom MDT for configuration categories
    static public final string DEBUG_CATEGORY = 'debug';
    static public final string PRODUCTION_CATEGORY = 'production';
    static public final string TEST_CATEGORY = 'test';
    /************************************************************************************
     *
     * Object Factory Identifiers
     ************************************************************************************/
    //
    // These names are used by the Object Factory as well-known types to create
    // [the names are self-explanatory]
    //

    public static final String ObjectFactory = 'ObjectFactory';
    public static final String CacheStrategy = 'CacheStrategy';
    public static final String CacheResource = 'CacheResource';
    public static final String CacheStrategyInvocation = 'CacheStrategyInvocation';
    public static final String ConfigurationResource = 'Configuration';

    public static final String ExceptionHandler = 'ExceptionHandler';
    public static final String ExceptionFormatter = 'ExceptionFormatter';
    public static final String ExceptionPolicyHandler = 'ExceptionPolicyHandler';

    public static final String FactoryResource = 'FactoryResource';
    public static final String FallbackResource = 'FallbackResource';
    public static final String LoggerResource = 'Logger';
    public static final String LogFormatter = 'LogFormatter';
    public static final String RuntimeEnvironment = 'RuntimeEnvironment';
    public static final String SendEmailChannel = 'SendEmailChannel';
    public static final String PreviousTransactionResultResource = 'PreviousTransactionResultResource';

    //
    // List of ALL cross-cutting resource names
    //
    public static final List<String> CC_AllResourceNames = new List<String> {
        ObjectFactory
        , CacheStrategy
        , CacheResource
        , CacheStrategyInvocation
        , ConfigurationResource
        , ExceptionHandler
        , ExceptionFormatter
        , ExceptionPolicyHandler
        , FactoryResource
        , FallbackResource
        , LoggerResource
        , LogFormatter
        , RuntimeEnvironment
        , SendEmailChannel
        , PreviousTransactionResultResource
    };
    /************************************************************************************
     *
     * Resource Identifiers
     ************************************************************************************/
    // Cache Partition Name
    public static final String DefaultCachePartitionName_s = 'work';

    //
    // The first part of the resources are the category
    //
    public static final String CategoryCaching_s = 'Caching';
    public static final String CategoryConfiguration_s = 'Config';
    public static final String CategorySystem_s = 'System';
    public static final String CategoryTest_s = 'Test';
    public static final String CategoryTriggers_s = 'Triggers';
    public static final String CategoryInterface_s = 'Interfaces';
    public static final String CategoryConcrete_s = 'Concrete';
    //
    // The second part of the resources are the identifiers. Identifiers have the _r extension
    // denoting a resource
    //
    //  Resource                    |   Type
    //  ============================|============================================
    //  UseCachingStrategy_r        | Boolean
    //  TriggersEnabled_r           | Boolean
    //  SoftAsserts_r               | Boolean
    //  TraceFlagOn_r               | Boolean
    //  EnvironmentClass_r          | String
    //  MaxChunkSize_r              | Integer
    //  CrossCuttingConfiguration_r | accc_CrossCuttingConfigDataModel
    //  DataCachingConfiguration_r  | accc_DataCachingDataModel
    //  CrossCuttingUtility_r       | accc_CrossCuttingUtilityDataModel
    //
    //===========================================================================
    public static final String UseCachingStrategy_r = CategoryCaching_s + accc_ApexConstants.ColonDelimiter + 'UseCachingStrategy';
    public static final string TriggersEnabled_r = CategoryTriggers_s + accc_ApexConstants.ColonDelimiter + 'TriggersEnabled';
    public static final String SoftAsserts_r = CategoryTest_s + accc_ApexConstants.ColonDelimiter + 'SoftAsserts';
    public static final String EnvironmentClass_r = CategorySystem_s + accc_ApexConstants.ColonDelimiter + 'EnvironmentClass';
    public static final String MaxChunkSize_r = CategorySystem_s + accc_ApexConstants.ColonDelimiter + 'MaxChunkSize';
    public static final String TraceFlagOn_r = CategoryConfiguration_s + accc_ApexConstants.ColonDelimiter + 'TraceFlagOn';
    public static final String TraceLogLevel_r = CategoryConfiguration_s + accc_ApexConstants.ColonDelimiter + 'TraceLogLevel';
    public static final String ShowCCTraceInfo_r = CategoryConfiguration_s + accc_ApexConstants.ColonDelimiter + 'ShowCCTraceInfo';

    //
    // Custom MDT - Note, Custom MDT data schema is NOT (should NOT be) exposed to external sources. The reason for this
    // is to ALLOW the custom MDT to be changed w/o impacting consumers (i.e. DAO -- data access object)
    //
    //    + accc_CrossCuttingConfigDataModel == CrossCuttingConfiguration_r
    //    + accc_DataCachingDataModel == DataCachingConfiguration_r
    //    + accc_CrossCuttingUtilityDataModel == CrossCuttingUtility_r
    //
    public static final String CrossCuttingConfiguration_r = CategorySystem_s + accc_ApexConstants.ColonDelimiter + 'CrossCuttingConfiguration';
    public static final String DataCachingConfiguration_r = CategoryCaching_s + accc_ApexConstants.ColonDelimiter + 'DataCachingConfiguration';
    public static final String CrossCuttingUtility_r = CategorySystem_s + accc_ApexConstants.ColonDelimiter + 'CrossCuttingUtility';

    /************************************************************************************
     *
     * Special Name values
     ************************************************************************************/
    public static final String All_s = 'All';
    public static final string Delete_s = 'Delete';
    public static final String FROM_s = ' FROM ';
    public static final String WHERE_s = ' WHERE ';
    public static final String SELECT_s = ' SELECT ';

    /************************************************************************************
     *
     * Misc Strings
     ************************************************************************************/
    public static final String Unknown = 'Unknown';
    public static final String EmptyString = '';
    public static final String WhitespaceString = ' ';
    public static final String ORString = 'OR';
    public static final String ANDString = 'AND';
    public static final String ColonDelimiter = ':';
    public static final String Period = '.';
    public static final String CommaDelimiter = ',';
    public static final string TabDelimiter = '\t';
    public static final string NewLine = '\n';

    /************************************************************************************
     *
     * REGEX
     ************************************************************************************/
    // Matches US Only ... (111) 222-3333 | 1112223333 | 111-222-3333 |
    public static final string TELEPHONE_REGEX = '^\\D?(\\d{3})\\D?\\D?(\\d{3})\\D?(\\d{4})$';
    // Matches a range of international and local telephone numbers:
    // 0689912549, +33698912549, +33 6 79 91 25 49,+33-6-79-91-25-49 ,(555)-555-5555
    // 555-555-5555, +1-238 6 79 91 25 49, +1-555-532-3455, +15555323455, 55555555555555555555555555
    // +7 06 79 91 25 49
    public static final string ALL_TELEPHONE_REGEX = '((?:\\+|00)[17](?: |\\-)?|(?:\\+|00)[1-9]\\d{0,2}(?: |\\-)?|(?:\\+|00)1\\-\\d{3}(?: |\\-)?)?(0\\d|\\([0-9]{3}\\)|[1-9]{0,3})(?:((?: |\\-)[0-9]{2}){4}|((?:[0-9]{2}){4})|((?: |\\-)[0-9]{3}(?: |\\-)[0-9]{4})|([0-9]{7}))';
    // number of numbers in an US telephone #
    public static final integer US_TELEPHONE_SIZE = 10;

    /************************************************************************************
     *
     * Default Max. number of items/records in a chunk ( sent via Apex Batch)
     ************************************************************************************/
    public static final integer DEFAULT_MAX_NUMBER_OF_ITEMS_IN_CHUNK = 100;

} // end of accc_ApexConstants