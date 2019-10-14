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
 * @author Bill Anderson
 * @description Encapsulates all behaviour logic relating to the management of Trigger Resources
 * @group Trigger Layer
 */
public without sharing class accc_TriggerHandlerResources {

    //==============================================================
    // Data Members
    //==============================================================
    /*
     * Represents the exception key of the handler for inspection by other
     * handlers in the chain
     */
    public static final String EXCEPTION_KEY = 'exception';
    /*
     * Data Pass Thru Information (Data Access Object)
     * This provides the container and manager of Pass Thru data betw/ handlers.
     * Thus, the data is freely available going from one handler to the next.
     *
     * The trigger resource allows passing information from one handler (in the chain)
     * to another.
     */
    public class PassThruResourceDAO {
        public Object triggerData;
        public Exception triggerException;
        /*
         * @description ctor
         * @param data (Object of anything)
         */
        public PassThruResourceDAO(Object data){
            this(data,null);
        }
        /*
         * @description ctor
         * @param data (Object of anything)
         * @param Exception ( if any)
         */
        public PassThruResourceDAO(Object data,Exception theException){
            this.triggerData = data;
            this.triggerException = theException;
        }
        /*
         * @description Property determine if successful
         */
        public Boolean isSuccessful {
            get { return this.triggerException ==null;}
        }
    }// end of PassThruResourceDAO
    /*
     * container for pass thru data for the trigger
     */
    @TestVisible
    static Map<String, PassThruResourceDAO > mMapData=null;

    //==============================================================
    // Ctors
    //==============================================================
    /**
     * @description default ctor
     *
     */
    public accc_TriggerHandlerResources() {

    }// end of ctor


    //==============================================================
    // Properties
    //==============================================================

    //==============================================================
    // Public Members
    //==============================================================

    /**
     * @description add the list collection by name
     * @param name resource name
     * @param data the data (list)
     * @return void
     **/
    public void add(String name,  Object data){
        if (!string.isEmpty(name) ) {
            this.addMap(name, data);
        }
    }
    /**
     * @description add the list collection by name
     * @param name resource name
     * @param data the data (PassThruResourceDAO)
     * @return void
     **/
    public void add(String name,  PassThruResourceDAO data){
        if (!string.isEmpty(name) ) {
            this.addMap(name, data);
        }
    }
    /**
     * @description remove the list collection by name
     * @param name resource name
     * @return void
     **/
    public boolean remove(String name){
        return string.isEmpty(name) ? false : this.removeItem(name);
    }

    /**
     * @description get the list collection by name
     * @param name resource name
     * @return PassThruResourceDAO
     **/
    public PassThruResourceDAO get(String name) {
        return string.isEmpty(name) ? null : this.getItem(name);
    }

    /**
     * @description get the list count
     * @return Integer
     **/
    public Integer count() {
        return this.getLazyResource().size();
    }
    /**
     * @description get the collection of keys
     * @return Integer
     **/
    public Set<String> keys() {
        return this.getLazyResource().keySet();
    }
    /**
     * @description reset collection to empty
     * @return Integer
     **/
    public void reset() {
        this.getLazyResource().clear();
    }

    //==============================================================
    // Private Members
    //==============================================================

    /**
     * @description remove object by name
     * @param name string name
     * @return boolean true, if found and remove
     **/
    @TestVisible
    private boolean removeItem(String key){
        boolean result= this.getLazyResource().containsKey(key);
        // MapKey key = new MapKey(name,DataType.DataList);
        if ( result) {
            this.getLazyResource().remove(key);
        }

        return result;
    }   // end of removeItem

    /**
     * @description get item by key
     * @return PassThruResourceDAO
     **/
    @TestVisible
    private PassThruResourceDAO getItem(String key){
        return this.getLazyResource().get(key);
    } // end of getItem

    /**
     * @description get ours list by key
     * @return void
     **/
    @TestVisible
    private void addMap(String key,Object data){
        this.addMap(key,new PassThruResourceDAO(data));
    }// end of addMap

    /**
     * @description get ours list by key
     * @return void
     **/
    @TestVisible
    private void addMap(String key,PassThruResourceDAO data){
        this.getLazyResource().put(key,data);
    } // end of addMap

    /**
     * @description get our container ( lazy create)
     * @return Map<String, Object>
     **/
    @TestVisible
    private Map<String, PassThruResourceDAO > getLazyResource(){
        if (accc_TriggerHandlerResources.mMapData==null ) {
            accc_TriggerHandlerResources.mMapData = new Map<String, PassThruResourceDAO >();
        }
        return accc_TriggerHandlerResources.mMapData;
    }// end of getLazyResource

}// end of accc_TriggerHandlerResources