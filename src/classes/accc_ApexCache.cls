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
 * @description Caching -- the default is to use Cache Org and not session. This may change
 *
 * See https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_cache_Org.htm#apex_cache_Org_methods
 *
 * !!!!!!!! Note: The cache MUST BE SETUP FIRST!!!
 *  Partition for testing MUST have a 'work'
 *
 *  The cache handler attempts to use the default cache partition 'local.work'. However,
 *  different partitions may be setup; as such, there are methods to get/put/etc. aspects
 *  as related to the specific partition.
 *
 * !!!!!!!! Note, those partitions MUST first be setup prior to access. Otherwise, caching does not work!
 *
 * https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_cache_partition_setup.htm
 * @group Cache Aspects
 */
public virtual without sharing class accc_ApexCache implements accc_ICache {

    ///////////////////////////////////////////////////////////////////////////////////////////////
    // Data Members
    ///////////////////////////////////////////////////////////////////////////////////////////////

    public static final Integer DEFAULT_TTL_IN_SECS = 600;
    public static final Integer DEFAULT_MIN_TTL_IN_SECS = 300;
    // Name of our partition -- must be created in Org (Setup) First!!!
    // TODO : Pull from custom metadata!!
    public static final String CACHE_NS = 'local';

    // Our Org partition object
    @TestVisible
    private static Map<String, Cache.OrgPartition> orgPartition = new Map<String, Cache.OrgPartition>();
    @TestVisible
    private String orgPartitionName = null;
    // is cached enabled
    @TestVisible
    private Boolean cacheEnabled = true;
    // is the parition available ( already created in Org)
    @TestVisible
    private Boolean cacheIsAvailable = false;

    ///////////////////////////////////////////////////////////////////////////////////////////////
    // Ctors
    ///////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @description default ctor
     */
    public accc_ApexCache() {
        this(CACHE_NS, accc_ApexConstants.DefaultCachePartitionName_s);
    }// end of ctor
    /**
     * @description ctor based on partition
     *
     * @param partition name of the partition, defaults to 'work'
     */
    public accc_ApexCache(String partition) {
        this(CACHE_NS, partition);
    } // end of ctor
    /**
     * @description get specific cache by namespace and partition
     *
     * @param String cache namespace, defaults to 'local'
     * @param String cache partition, defaults to 'work'
     *
     */
    public accc_ApexCache(String namespace, String partition) {
        String nsInput = String.isBlank(namespace) ? CACHE_NS : namespace;
        String partitionInput = String.isBlank(partition) ? accc_ApexConstants.DefaultCachePartitionName_s : partition;
        String orgPartitionNameInput = accc_ApexCache.getCachePartitionName(nsInput, partitionInput);

        this.orgPartitionName = orgPartitionNameInput;
        this.cacheNamespace = nsInput;
        this.cachePartition = partitionInput;
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // MUST BE DONE -- Otherwise, ALL subsequent cache calls fail
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

        // now go check that this partition is already created ( setup->cache in the Org)
        // Note, this is normally the Default cache partition ('local.work')
        this.cacheIsAvailable = this.getPartition(this.cacheNamespace, this.cachePartition) != null;

        accc_ApexEnvironment.getRuntimeEnvironment().logger().trace('Entered partition=' + partition + ', this.cacheIsAvailable=' + this.cacheIsAvailable );
    } // end of ctor

    /**
     * cache namespace
     */
    public String cacheNamespace {get; protected set;}
    /**
     * cache partition name
     */
    public String cachePartition {get; protected set;}

    ///////////////////////////////////////////////////////////////////////////////////////////////
    // Public Methods
    ///////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @description cache partition
     * @return the cache partition, generally, 'work'
     */
    public String theCachePartition() {
        return this.cachePartition;
    } // end of theCachePartition
    /**
     * @description cache namespace
     * @return the cache namespace, generally, 'local'
     */
    public String theCacheNamespace() {
        return this.cacheNamespace;
    } // end of theCacheNamespace
    /**
     * @description cache partition name
     * @return String, the partition name
     */
    public String partitionName() {
        return this.orgPartitionName;
    } // end of partitionName

    /**
     * @description toggle on/off the cache
     * @return current value of the cache enablement
     */
    public Boolean toggleEnabled() { // Use for testing misses
        cacheEnabled = !cacheEnabled;
        return cacheEnabled;
    } // end of toggleEnabled

    /**
     * @description is cache available (always for 'Org')
     * @return Boolean true, if available
     */
    public Boolean isAvailable() {

        if ( !this.cacheIsAvailable  ) {
            return false;
        }
        return true;
    } // end of isAvailable

    /**
     * @description get an item from cache
     * @return Object
     */
    public Object get(String key) {
        Object results = null;

        if ( !string.isBlank(key) && this.isAvailable()  ) {
            results =  this.getPartition().get(key);
        }

        return results;
    } // end of get

    /**
     * @description get an item from cache
     * @param string the partition
     * @param string the key
     * @return Object
     */
    public Object get(String partition, String key) {
        Object results = null;

        if ( !string.isBlank(key)
             && !string.isBlank(partition)
             && this.isAvailable()  ) {
            results=this.getPartition(this.cacheNamespace, partition).get(key);
        }

        return results;
    } // end of get

    /**
     * @description item in the cache
     * @param string the key
     * @return Boolean true if present
     */
    public Boolean contains(String key) {
        Boolean results = false;

        if ( !string.isBlank(key) && this.isAvailable() ) {
            results = this.getPartition().contains(key);
        }

        return results;
    } // end of contains
    /**
     * @description item in the cache
     *
     * @param string the partition
     * @param string the key
     * @return Boolean true if present
     */
    public Boolean contains(String partition, String key) {
        Boolean results = false;

        if ( !string.isBlank(key)
             && !string.isBlank(partition)
             && this.isAvailable() ) {
            results=  this.getPartition(this.cacheNamespace, partition).contains(key);
        }

        return results;
    } // end of contains
    /**
     * @description get cache keys
     * @return Boolean
     */
    public Set<String> getKeys() {
        Set<String>  results = null;
        if ( this.isAvailable() ) {
            results = this.getKeys(this.cachePartition);
        }
        return results;
    } // end of getKeys

    /**
     * @description get cache keys
     * @param string the cache partition
     * @return Boolean
     */
    public Set<String> getKeys(String partition) {
        Set<String> data = null;

        if (  !string.isBlank(partition)  && this.isAvailable() ) {
            data = this.getPartition(this.cacheNamespace, partition).getKeys();
        }
        return data;
    }// end of getKeys

    /**
     * @description put value into cache
     * @return void
     */
    public void put(String key, Object value) {
        this.put(key, value, DEFAULT_TTL_IN_SECS);
    }// end of put

    /**
     * @description put value into cache
     *
     * @param key String name
     * @param value object value
     * @param ttlSecstime to live in seconds (max. in 8 hrs == 28,800 secs - min is 300 secs) MAX_TTL_SECS
     */
    public void put(String key, Object value, Integer ttlSecs) {
        if ( !string.isBlank(key) && value != null &&  this.isAvailable() ) {
            Integer ttl = ttlSecs < DEFAULT_MIN_TTL_IN_SECS ? DEFAULT_MIN_TTL_IN_SECS : ttlSecs;
            this.getPartition().put(key, value, ttl);
        }
    }// end of put

    /**
     * @description put value into cache (by partition)
     *
     * @param String the partition name
     * @param key String name
     * @param value object value
     * @param ttlSecstime to live in seconds (max. in 8 hrs == 28,800 secs - min is 300 secs) MAX_TTL_SECS
     */
    public void put(String partition, String key, Object value) {
        this.put(partition, key, value, DEFAULT_TTL_IN_SECS);
    }// end of put

    /**
     * @description put value into cache
     *
     * @param String the partition name
     * @param key String name
     * @param value object value
     * @param ttlSecstime to live in seconds (max. in 8 hrs == 28,800 secs - min is 300 secs) MAX_TTL_SECS
     */
    public void put(String partition, String key, Object value, Integer ttlSecs) {
        if ( !string.isBlank(key) && value != null
             && !string.isBlank(partition)
             &&  this.isAvailable()) {
            Integer ttl = ttlSecs < DEFAULT_MIN_TTL_IN_SECS ? DEFAULT_MIN_TTL_IN_SECS : ttlSecs;
            this.getPartition(this.cacheNamespace, partition).put(key, value, ttl);
        }
    }// end of put
    /**
     * @description remove case sensitive key value from cache
     *
     * @param key case sensitive string name
     * @return Boolean true if removed
     */
    public Boolean remove(String key) {
        Boolean results = false;

        if ( !string.isBlank(key) &&  this.isAvailable() ) {
            results = this.getPartition().remove(key);
        }

        return results;
    }// end of remove

    /**
     * @description remove case sensitive key value from cache by partition
     *
     * @param partition
     * @param key case sensitive string name
     * @return Boolean true if removed
     */
    public Boolean remove(String partition, String key) {
        Boolean results = false;

        if ( !string.isBlank(partition)
             && !string.isBlank(key)
             &&  this.isAvailable() ) {
            results = this.getPartition(this.cacheNamespace, partition).remove(key);
        }

        return results;
    }// end of remove

    /**
     * @description create a cache partition name from ns and partition
     *
     * @param string cache namespace
     * @param string cache partition
     *
     * @return string cache partition name
     */
    public static string getCachePartitionName(string namespace, string partition) {
        string thePartition = string.isBlank(partition) ? accc_ApexConstants.DefaultCachePartitionName_s : partition;
        String nsInput = String.isBlank(namespace) ? CACHE_NS : namespace;

        return nsInput + accc_ApexConstants.Period + thePartition;
    }// end of getCachePartitionName
    ///////////////////////////////////////////////////////////////////////////////////////////////
    // Private Methods
    ///////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @description Get/Create the Org partition
     * @return Cache.OrgPartition
     */
    @TestVisible
    private Cache.OrgPartition getPartition() {
        return this.getPartition(this.cacheNamespace, this.cachePartition);
    }// end of getPartition

    /**
     * @description Get/Create the Org partition based on namespace and partition.
     * Note, the  namespace and partition must already exists in SF Platform Cache :-0
     *
     * @param String cache namespace
     * @param String cache partition
     * @return Cache.OrgPartition
     */
    @TestVisible
    private Cache.OrgPartition getPartition(String namespace, String partition) {
        Cache.OrgPartition result = null;

        try {
            String cachePartition = accc_ApexCache.getCachePartitionName(namespace, partition);
            if ( false == accc_ApexCache.orgPartition.containsKey(cachePartition)  ) {

                result = Cache.Org.getPartition(cachePartition);
                if ( result != null ) {
                    accc_ApexCache.orgPartition.put(cachePartition, result);
                }

            } else {
                result = (Cache.OrgPartition )accc_ApexCache.orgPartition.get(cachePartition);
            }
        } catch (Cache.Org.OrgCacheException excp) {
            // if there is no data by the key, the parition may not have been created
            accc_ApexEnvironment.getRuntimeEnvironment().exceptionHandler().process(excp);
        }
        return result;

    }// end of getPartition

}// end of accc_ApexCache