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
 * @description Manager to create class instances. Lazy create
 * @group Common Layer
 */
public virtual without sharing class accc_ApexClassInstanceMgr implements accc_IApexObjectGetter {
    /*---------------------------------------------------------------------------------------
    * PUBLIC PROPERTIES
    *---------------------------------------------------------------------------------------
    **/

    /**
    * @description getter/setter of the class name
    *
    * @param String , the class name
    * @return return class instance name
    */
    public string className { get; protected  set;}

    /**
    * @description getter/setter of the interface class type
    *
    * @param String the interface type, if any. May be a concrete class and type is the class name
    * @return String the interface name, if any. May be a concrete class and type is the class name
    */
    public string classInterfaceType { get; protected  set;}

    /**
    * @description getter/setter of the reference name used internally within the package
    *
    * @param string the reference name
    * @return string reference name
    */
    public string referenceName { get; protected  set;}

    /*---------------------------------------------------------------------------------------
    * CTORS
    *---------------------------------------------------------------------------------------
    **/

    /**
    * @description ctor
    * @param String the class name
    */
    public accc_ApexClassInstanceMgr(string usrClassName) {
        this(usrClassName, usrClassName, null);

    } // end of ctor

    /**
    * @description ctor
    * @param String the class name
    * @param String the interface name
    */
    public accc_ApexClassInstanceMgr(string usrClassName, string interfaceName) {
        this(usrClassName, interfaceName, null);
    } // end of ctor


    /**
    * @description manage the creation of instances
    * @param string user class name (i.e. accc_Cache )
    * @param string the interface name (i.e. accc_ICache )
    * @param string the user-specific reference name (alias, myCache)
    */
    public accc_ApexClassInstanceMgr(string usrClassName, string interfaceName, string reference) {
        if ( string.isBlank(usrClassName)) {
            throw new accc_ApexApplicationException('accc_ApexApplicationException: classname cannot be null or empty');
        }
        this.className = usrClassName;
        this.classInterfaceType = interfaceName == null ? usrClassName : interfaceName;
        this.referenceName = reference == null ? usrClassName : reference;

    } // end of ctor

    /**
    * @description create an instance from a type
    * @param classType the Type
    */
    public accc_ApexClassInstanceMgr(Type classType) {
        if ( classType == null ) {
            throw new accc_ApexApplicationException('accc_ApexApplicationException: classType cannot be null or empty');
        }

        this.className = classType.getName();
        this.classInterfaceType = this.className;
        this.referenceName = this.className;
    } // end of ctor

    /*---------------------------------------------------------------------------------------
    * PUBLIC METHODS
    *---------------------------------------------------------------------------------------
    **/

    /**
    * @description get the class type
    * @return Type, the class type
    */
    public Type getClassType() {
        return accc_ApexUtilities.getTypeByName(this.className);
    } // end of getClassType

    /**
     * @details get the instance ( syntactic sugar)
     * @return Object the instance object
     */
    public Object get() {
        return this.getClassInstance();
    } // end of get
    /**
     * @description get the object name
     * @return String the object name
     */
    public String name() {
        return this.classname;
    }// end of name
    /**
    * @description get the class instance
    * @return Object, class instance which must be casted appropriately
    */
    public Object getClassInstance() {
        Object result = null;
        try {
            // Get the Type corresponding to the class name
            Type cacheType = this.getClassType();

            // Instantiate the type.
            // The type of the instantiated object is the interface.
            if ( cacheType != null ) {
                result = (Object)cacheType.newInstance();
            }
        } catch (Exception excp) {
            // process exception
            accc_ApexRunEnvironmentSingleton.getInstance().exceptionHandler().process(excp);
        }
        return result;

    } // end of getClassInstance

} // end of accc_ApexClassInstanceMgr