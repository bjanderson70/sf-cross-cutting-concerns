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
 * @description Factory to create our cross-cutting runtime objects. It contains
 * all our Known (as well as not known classes/types). The
 * @group Common Layer
 */
public virtual without sharing class accc_ApexObjectFactory implements accc_IApexFactory {

    ////////////////////////////////////////////////////////////////////////////////
    /// Data Members
    ////////////////////////////////////////////////////////////////////////////////

    // the collection of object creation
    private final static Map<String, accc_IApexObjectGetter> theObjectCollection = new Map<String, accc_IApexObjectGetter>();

    ////////////////////////////////////////////////////////////////////////////////
    /// Ctors
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description default ctor
     */
    public accc_ApexObjectFactory() {
        this.initializeBase();
    } // end of ctor

    ////////////////////////////////////////////////////////////////////////////////
    /// Public Methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description create an instance by name
     *
     * @param fqn fully-qualified-name, if needed
     * @return object instance
     */
    public virtual Object create(String fqn) {
        Object result = null;
        if ( !string.isBlank(fqn) ) {
            Type tfqn = accc_ApexUtilities.getTypeByName(fqn);
            result = this.createFromType(tfqn, fqn);

        }
        return result;
    } // end of create

    /**
     * @description create an object based on the namespace and name
     *
     * @param namespace the namespace of the class/type
     * @param name the name of the class/type
     *
     * @return object instance
     */
    public virtual Object create(String namespace, String name) {
        String ns = namespace == null ? '' : namespace;
        Type tfqn = accc_ApexUtilities.getTypeByName(namespace, name);

        return this.createFromType(tfqn, name);
    } // end of create

    /**
     * @description create an object based on the type
     *
     * @param objType Type of the object
     * @return the object -- must be cast accordingly
     */
    public virtual Object create(Type objType) {
        return objType == null ? null : this.createFromType(objType, null);
    } // end of create

    /**
     * @description associate 'name' to object type for creation
     *
     * @param name. name used to reference type
     * @param objType. type to create
     */
    public virtual void add(String name, Type objType) {
        this.addToCollection(name, objType);
    } // end of add

    /**
     * @description Add a type by name; if match, overwrite
     * @param fqn fully-qualified-name
     */
    public virtual void add(String fqn) {
        // valid string
        if ( !string.isBlank(fqn)) {
            Type objType = accc_ApexUtilities.getTypeByName(fqn);
            if ( objType != null ) {
                this.addToCollection(fqn, objType);
            }
        }
    } // end of add
    /**
    * @description Add an instance creator
    * @param accc_ApexClassInstanceMgr, the instance creator
    */
    public virtual void add(accc_ApexClassInstanceMgr creator) {
        if ( creator != null ) {
            this.addToCollection(creator);
        }
    } // end of add
    /**
    * @description Add an instance creator
    * @param accc_IApexObjectGetter, the instance creator
    */
    public virtual void add(accc_IApexObjectGetter creator) {
        if ( creator != null ) {
            this.addToCollection(creator.name(), creator);
        }
    }// end of add
    /**
     * @description keys in the collection of creators
     * @return collection of string of keys Set<String>
     */
    public virtual Set<String> keys() {
        return accc_ApexObjectFactory.theObjectCollection.keySet();
    } // end of keys

    /**
    * @description find the instance creator by name (case insensitive)
    * @param String instance creator by name
    * @return accc_IApexObjectGetter the instance creator
    */
    public accc_IApexObjectGetter findByName(string creatorName) {
        accc_IApexObjectGetter result = null;

        if ( !string.isBlank(creatorName) &&
                accc_ApexObjectFactory.theObjectCollection.size() > 0) {
            string key = creatorName.toLowerCase();
            result = accc_ApexObjectFactory.theObjectCollection.get(key);
        }
        return result;
    } // end of findByName

    ////////////////////////////////////////////////////////////////////////////////
    /// Protected Methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * TO BE DEPRECATED
     * @description add look up and type to the known classes we create (case insensitive)
     *
     * @param name Name used to invoke the creator
     * @param classType class type -- what we are creating
     */
    @TestVisible
    protected virtual void addToCollection(String name, Type classType) {
        // valid data
        if ( !string.isBlank(name) &&
                classType != null ) {
            String key = name.toLowerCase();
            accc_ApexObjectFactory.theObjectCollection.put(key, new accc_ApexClassInstanceMgr(classType));
        }
    } // end of addToCollection

    /**
     * TO BE DEPRECATED
     *
     * @description add look up and type to the known classes we create  (case insensitive)
     *
     * @param name Name used to invoke the creator
     * @param classType class type -- what we are creating
     */
    @TestVisible
    protected virtual void addToCollection(String name, accc_IApexObjectGetter classInstance) {
        // valid data
        if ( !string.isBlank(name) && classInstance != null ) {
            String key = name.toLowerCase();
            accc_ApexObjectFactory.theObjectCollection.put(key, classInstance);
        }
    } // end of addToCollection
    /**
    * @description add look up and type to the known classes we create  (case insensitive)
    *
    *  Note: We use reference name here as 'initializeBase' expects this. If
    *  you need to have it use classname, then assign class name to reference name
    *
    * @param accc_ApexClassInstanceMgr instance used to invoke the creator
    */
    @TestVisible
    protected virtual void addToCollection( accc_ApexClassInstanceMgr classInstance) {
        // valid data
        if ( classInstance != null ) {
            // the names from 'accc_ApexClassInstanceMgr' are never null
            String  refKey = classInstance.referenceName.toLowerCase(),
                    classKey = classInstance.className.toLowerCase() ;
            // add by reference
            accc_ApexObjectFactory.theObjectCollection.put(refKey, classInstance);
            //
            // NOW, let's add the classname for cross reference (if no the same) as the
            // reference name and class name do NOT need to be the same
            //
            if ( classKey != refKey &&
                    !accc_ApexObjectFactory.theObjectCollection.containsKey(classKey)) {
                accc_ApexObjectFactory.theObjectCollection.put(classKey, classInstance);
            }
        }
    } // end of addToCollection
    /**
     * @description  create the type by name (Fully-Qualified-Name or within the local namespace)
     *
     * @param foundType the found type
     * @param name string name (Fully-Qualified-Name or within the local namespace)
     *
     * @return Object created instance
     */
    @TestVisible
    protected virtual Object createFromType(Type foundType, String name) {
        Object result = null;
        boolean validToProcessOnName = foundType == null && !string.isBlank(name) ;

        // we check the name if NO type
        if ( validToProcessOnName ) {
            // get the instance creator
            accc_IApexObjectGetter instance = this.findByName(name);

            // if we have it , let's create/get the object
            if ( instance != null  ) {
                result = instance.get();
            }
            // no name in our collection but there is a
            // type. So, let's create it (if possible) and
            // add to our collection for future reference
        } else if ( foundType != null ) {
            result = foundType.newInstance();
            // should not be NULL, lets remember it
            this.addToCollection(new accc_ApexClassInstanceMgr(foundType));
        }

        return result;
    } // end of createFromType

    /**
     * @description get the object collection ( for children)
     * @return Map<String, accc_IApexObjectGetter>, the list of creators
     */
    @TestVisible
    protected  Map<String, accc_IApexObjectGetter> objectCollection() {
        return accc_ApexObjectFactory.theObjectCollection;
    } // end of objectCollection

    ////////////////////////////////////////////////////////////////////////////////
    /// Private Methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description Initialize what the factory knows how to create -- these are the well-known types (in the event a null is used)
     */
    @TestVisible
    private void initializeBase() {

        // this is static data, grab it ONCE
        if (  accc_ApexObjectFactory.theObjectCollection.size() == 0 ) {
            // what environment we are working in ('debug','production',etc)
            String environment = accc_ApexUtilities.getEnvironment();
            // don't use singleton, 'accc_ApexRunEnvironmentSingleton' chicken-egg issue
            accc_CrossCuttingConfigMgr configMgr =  new accc_CrossCuttingConfigMgr(environment);
            // if we have the cc configuration manager, let us get all the creators
            List<accc_ApexClassInstanceMgr> items = configMgr.getInstanceCreators() ;
            // add these creators to our static lookup
            for (accc_ApexClassInstanceMgr classInstance : items) {
                this.addToCollection(classInstance);
            }
        }
    } // end of initializeBase

} // end of accc_ApexObjectFactory