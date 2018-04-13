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
 *
 * @author Bill Anderson
 * @description  Manages the cross cutting concerns via custom MDT
 *
 *   The Configuration is broken down as follows (name/value pairs), and subject to augmentation:
 *
 *       Label (Category) --> name/value pairs:
 *                  Cache Class, Value
 *                  Exception Handling Class, Value
 *                  Fallback Resources Class, Value
 *                  Logging Class, Value
 *
 *       Where Label is the category such as 'debug', 'production', etc.
 *
 *       The ASSUMPTION is that the following is true:
 *
 *          Cache Class inherits from ICache,
 *          Exception Handling Class inherits from IExceptionHandler,
 *          Fallback Resources Class inherits from IFallbackResources
 *          Logging Class inherits from ILogger
 *
 *      For example,
 *
 *      'debug' --> map <string,string> :
 *                                      'cacheClass' : 'ApexCache',
 *                                      'loggerClass': 'ApexLogger'
 *                                          :
 *                                          :
 *      'production' --> map <string,string> :
 *                                      'cacheClass' : 'ApexSessionCache',
 *                                      'loggerClass': 'ApexObjectLogger'
 *                                          :
 *                                          :
 *
 *              :
 *
 * @group Common Layer
 */
public virtual without sharing  class accc_CrossCuttingConfigMgr {

    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Data Members
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    /*
    * the cross cutting container
    */
    private static accc_BaseMdtDataModel CC_CONFIG = null;

    static {
        // BE Careful ... daemons, exists ...

        // create the manager. Note, the manager is invoked by 'accc_ApexObjectFactory' to
        // grab ALL known configurations. This is the bad part of the design as the custom MDT
        // is expected to hold the appropriate name/value pair! The 'accc_CrossCuttingConfigMgrTest'
        // is responsible for checking the configurations. Unfortunately, there still needs to
        // be a UI to validate the 'on-the-fly' changes a non-technical person can make!
        //
        accc_CrossCuttingConfigMgr.CC_CONFIG = (accc_BaseMdtDataModel) new accc_CrossCuttingConfigDataModel();
    }
    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Ctors
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    /**
     * @description default ctor
     *
     **/
    public accc_CrossCuttingConfigMgr() {
        this(null);
    } // end of ctor
    /**
     * @description the ctor taking the category
     *
     * @param userCategory the category
     */
    public accc_CrossCuttingConfigMgr(string userCategory) {
        this.category = userCategory;
    } // end of ctor
    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Properties
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    /**
     * @description the category getter/setter
     *
     * @param  string category
     * @return string category
     */
    public string category { get; private set;}

    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Public Methods
    //
    /////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @description create a list of instances based on a category as defined in the MDT (label)
     *
     * The label is defined to be 'debug', 'production' and 'test'. Additional ones
     * can be added as needed in the managed custom MDT.
     *
     * @return List<accc_ApexClassInstanceMgr> list of creators for the classes based on category
     */
    public List<accc_ApexClassInstanceMgr> getInstanceCreators() {
        return this.getInstanceCreators(this.category);
    } // end of getInstanceCreators
    /**
     * @description create a list of instances based on a category as defined in the MDT (label)
     *
     * The label is defined to be 'debug', 'production' and 'test'. Additional ones
     * can be added as needed in the managed custom MDT.
     *
     * @param userCategory string name,ie, 'debug', 'production' and 'test', etc.
     * @return List<accc_ApexClassInstanceMgr> list of creators for the classes based on category
     */
    public List<accc_ApexClassInstanceMgr> getInstanceCreators(string userCategory) {
        List<accc_ApexClassInstanceMgr> instances = new List<accc_ApexClassInstanceMgr>();
        String categoryName = !string.isBlank(userCategory) ? userCategory : this.category;

        try {

            // any work to do ( valid 'categoryName' )
            if ( !string.isBlank(categoryName)) {
                // set the category if different
                if ( this.category != categoryName) {
                    this.category = categoryName;
                }

                Map<String, Map<String, String> > classes = this.getClasses(categoryName);
                // any classes ??
                if ( classes != null ) {
                    Map<String, String> items = classes.get(categoryName);

                    //
                    // here we will find the known interfaces, and class names
                    // and create instances for consumption by the 'ApexObjectFactory'
                    //
                    if ( items != null && items.size() > 0 ) {
                        for (String referenceName : items.keyset()) {
                            this.addToInstanceList( referenceName, items, instances);
                        }
                    }
                }
            }
        } catch (Exception excp) {
            // process exception
            accc_ApexRunEnvironmentSingleton.getInstance().exceptionHandler().process(excp, true);
        }
        return instances;

    } // end of getInstanceCreators

    /**
     * @description get instance creator
     *
     * @param String, Class to construct
     * @return accc_ApexClassInstanceMgr, constructs the instance (user responsible for casting appropriately)
     */
    public accc_ApexClassInstanceMgr getInstanceCreator(string className) {
        return this.getInstanceCreator(className, className);
    } // end of getInstanceCreator

    /**
     * @description get instance creator
     *
     * @param String, Class to construct
     * @param String, Interface type
     * @return accc_ApexClassInstanceMgr, constructs the instance (user responsible for casting appropriately)
     */
    public accc_ApexClassInstanceMgr getInstanceCreator(string className, string interfaceName) {
        // need to have at least a class name
        if ( String.isBlank(className) ) {
            return null;
        }
        return new accc_ApexClassInstanceMgr(className, interfaceName);
    } // end of getInstanceCreator

    /**
      * @description get the known classes ( looking in all categories; debug, production, etc.)
      * @return map of classes by interface by category
      */
    public Map<String, Map<String, String> > getClasses(string category) {
        Map<String, Map<String, String> >results = new Map<String, Map<String, String> >();

        // get the configuration information
        List<accc_BaseMdtDataModel.BaseDataModelInformation> dmList = CC_CONFIG.findbyCategory(category);
        // process the information into manageable chunks
        if ( dmList != null && dmList.size() > 0 ) {
            // iterate over map
            for ( accc_BaseMdtDataModel.BaseDataModelInformation dmodel : dmList ) {
                // populate the results with the config values, break if error
                if ( !this.addToMap(dmodel.Label,
                                    (accc_CrossCuttingConfigDataModel.CrossCuttingConfigInformation) dmodel,
                                    results) ) {
                    break;
                }
            }
        }

        return results;
    } // end of getClasses
    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Protected Methods
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    /**
     * @description add new items to cc config map
     *
     * @param String, the category this list is associated with (i.e debug, prod, uat, etc.)
     * @param CrossCuttingConfigInformation cross cutting concerns information
     * @param Map<String, Map<String, String> > map of configuration based on category of entries
     *
     * @return true, if added to results map
     */
    @TestVisible
    protected boolean addToMap(String category,
                               accc_CrossCuttingConfigDataModel.CrossCuttingConfigInformation cinfo,
                               Map<String, Map<String, String> >results) {
        Boolean added = false;
        try {
            Map<String, String> items  = this.addKnownConfigurationItems(cinfo);
            results.put(category, items);
            added = true;
        } catch (Exception excp) {
            // process exception
            accc_ApexRunEnvironmentSingleton.getInstance().exceptionHandler().process(excp, true);
        }
        return added;
    } // end of addToMap
    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Private Methods
    //
    /////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @description add new instance
     *
     * @param String reference name
     * @param Map<String,String> map of reference and class-name
     * @param List<accc_ApexClassInstanceMgr> instance to add to
     *
     * @return boolean true if added
     */
    @TestVisible
    private boolean addToInstanceList( string referenceName, Map<String, String> items , List<accc_ApexClassInstanceMgr> instances ) {

        String classValue = items.get(referenceName);
        Boolean haveAddedInstance = false;

        // was a class name not supplied.
        if ( string.isBlank(classValue)) {
            // no class, let's fallback to known resource implementations
            Type ctype = this.getFallbackType(accc_ApexConstants.CategoryConcrete_s, referenceName);

            classValue = cType != null ? cType.getName() : null;
        }

        // do we have a class to add, we have enough information
        if ( classValue != null ) {
            String theInterface =  this.getInterfaceNameFrom(accc_ApexConstants.CategoryInterface_s, classValue, referenceName);

            haveAddedInstance = true;
            // now create the 'creator' for this type
            instances.add(new accc_ApexClassInstanceMgr(classValue, theInterface, referenceName));
        }
        return haveAddedInstance;
    } // end of addToInstanceList

    /**
     * @description get the resource fallback type
     *
     * @param String name of the resource
     * @return Type resource type
     */
    @TestVisible
    private Type getFallbackType(string category, string resource) {
        return accc_ApexUtilities.getTypeByName((String)accc_ApexUtilities.getRuntimeFallbackResources().get(category, resource));
    } // end of getFallbackType
    /**
     * @description get the interface name
     *
     * @param string the category to search
     * @param string the class name
     * @param string the reference name
     * @return string, the interface name
     */
    @TestVisible
    private String getInterfaceNameFrom(string category, string className, String referenceName) {
        Boolean validCategory = !string.isBlank(category);
        String result = validCategory && string.isBlank(referenceName)  ? null : (String)accc_ApexUtilities.getRuntimeFallbackResources().get(category, referenceName) ;

        // this may not be applicable, but bec/ others CAN change the fallback resources, we will still check
        // what we are wanting is the INTERFACE
        if ( result == null && validCategory && !string.isBlank(className) ) {
            result = (String)accc_ApexUtilities.getRuntimeFallbackResources().get(category, className) ;
        }
        // are we still NULL, use the class name
        if ( result == null ) {
            result =  className;
        }
        return result;
    } // end of getInterfaceNameFrom
    /**
     * @description add known configuration information to map from the Custom MDT
     *
     * @param accc_CrossCuttingConfigDataModel.CrossCuttingConfigInformation cross cutting concern items (from Custom MDT)
     * @return Map<String, String> translated reference mapping
     */
    @TestVisible
    private Map<String, String>  addKnownConfigurationItems(accc_CrossCuttingConfigDataModel.CrossCuttingConfigInformation cinfo) {
        Map<String, String> items = new Map<String, String>();

        // Step 7. Assign retrieved resource to our cross-cutting (known) references

        items.put(accc_ApexConstants.CacheResource, cinfo.cacheClass);
        items.put(accc_ApexConstants.CacheStrategy, cinfo.cacheStrategyClass);
        items.put(accc_ApexConstants.CacheStrategyInvocation, cinfo.cacheStrategyInvocationClass);
        items.put(accc_ApexConstants.ExceptionHandler, cinfo.exceptionHandlerClass);
        items.put(accc_ApexConstants.ExceptionFormatter, cinfo.exceptionFormatterClass);
        items.put(accc_ApexConstants.ExceptionPolicyHandler, cinfo.exceptionPolicyHandlerClass);
        items.put(accc_ApexConstants.FactoryResource, cinfo.factoryClass);
        items.put(accc_ApexConstants.FallbackResource, cinfo.fallbackResourcesClass);
        items.put(accc_ApexConstants.LoggerResource, cinfo.loggingClass);
        items.put(accc_ApexConstants.LogFormatter, cinfo.logFormatterClass);
        items.put(accc_ApexConstants.PreviousTransactionResultResource, cinfo.previousTransactionResultResourceClass);
        items.put(accc_ApexConstants.RuntimeEnvironment, cinfo.runtimeEnvironmentClass);
        items.put(accc_ApexConstants.SendEmailChannel, cinfo.sendEmailChannelClass);
        items.put(accc_ApexConstants.ConfigurationResource, cinfo.configurationClass);

        return items;
    } // end of addKnownConfigurationItems

} // end of accc_CrossCuttingConfigMgr