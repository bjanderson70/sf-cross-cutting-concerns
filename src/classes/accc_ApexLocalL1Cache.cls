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
 * @description (Encapsulate) Use a local L1-like cache to speedup and reduce lookups.
 * The local cache is broken down into different categories to avoid possible collision.
 * By default, all information will be in the 'All' category, i.e.
 *
 *    	All --> name/value, name2/value2, name3/value3 ...
 *
 *    If there are additional categories, i.e., 'Fallback',
 *
 *    	Fallback --> name/value, name2/value2, name3/value3 ...
 *    		:
 *    	All --> name/value, name2/value2, name3/value3 ...
 * @group Common Layer
 */
public without sharing class accc_ApexLocalL1Cache {
    /*---------------------------------------------------------------------------------------
    * DATA MEMBERS
    *---------------------------------------------------------------------------------------
    */

    // holds our local l1 cache
    static Map<String, Map<String, Object> > catCache = new Map<String, Map<String, Object> > ();

    /*---------------------------------------------------------------------------------------
    * CTORS
    *---------------------------------------------------------------------------------------
    */

    /**
    * @description default ctor
    */
    public accc_ApexLocalL1Cache() {
        this(accc_ApexConstants.All_s);
    } // end of ctor
    /**
     * @description ctor
     * @param string data category
     */
    public accc_ApexLocalL1Cache(string inputCategory) {
        string categoryName = string.isBlank(inputCategory) ? accc_ApexConstants.All_s : inputCategory;
        // which section of the local L1 are we using
        Map<String, Object> l1Cache = accc_ApexLocalL1Cache.catCache.get(categoryName);
        if ( l1Cache == null ) {
            accc_ApexLocalL1Cache.catCache.put(categoryName, new  Map<String, Object>());
        }
        this.category = categoryName;

    } // end of ctor

    /*---------------------------------------------------------------------------------------
    * PUBLIC PROPERTIES
    *---------------------------------------------------------------------------------------
    */

    /**
     * description the category name
     *
     * @param string data category
     * @return string category
     */
    public string category { get; private set;}

    /*---------------------------------------------------------------------------------------
    * PUBLIC METHODS
    *---------------------------------------------------------------------------------------
    */
    /**
    * @description get data from the store
    *
    * @param string the key to the store
    * @return Object data stored
    */
    public Object get(String key) {
        Object result = null;
        if (  !string.isBlank(key)) {
            Map<String, Object> cacheLookup = accc_ApexLocalL1Cache.catCache.get(this.category);
            if ( cacheLookup != null && cacheLookup.size() > 0) {
                result = cacheLookup.get(key);
            }
        }
        return result;
    } // end of get
    /**
     * @description store the data by key
     *
     * @param string key to lookup in the category
     * @param Object value to store
     * @return Object return the added value
     */
    public Object put(String key, Object value) {

        if (  !string.isBlank(key) && value != null) {
            Map<String, Object> cacheLookup = accc_ApexLocalL1Cache.catCache.get(this.category);
            if ( cacheLookup != null ) {
                cacheLookup.put(key, value);
            }
        }
        return value;

    } // end of put
    /**
     * @description reset the key/value pair for the constructed category
     */
    public void reset() {
        Map<String, Object> cacheLookup = accc_ApexLocalL1Cache.catCache.get(this.category);
        if ( cacheLookup != null ) {
            for ( string key : cacheLookup.keyset() ) {
                cacheLookup.remove(key);
            }
        }
    } // end of reset

    /**
     * @description size of the local lookup (only 1-dimension, not depth / entry)
     *    If there are additional categories, i.e., 'Fallback',
     *
     *    	Fallback --> name/value, name2/value2, name3/value3 ...
     *    		:
     *    	All --> name/value, name2/value2, name3/value3 ...
     *
     *    	size will be 2
     */
    public integer size() {
        integer sz = 0;
        Map<String, Object> cacheLookup = catCache.get(this.category);
        if ( cacheLookup != null ) {
            sz = cacheLookup.size();
        }
        return sz;
    } // end of size

} // end of accc_ApexLocalL1Cache