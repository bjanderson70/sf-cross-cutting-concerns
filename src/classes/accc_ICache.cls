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
 * @description  Caching Interface
 * @group Common Interface Layer
 */
public virtual interface accc_ICache {

    /**
    * @description cache partition
    * @return the cache partition, generally, 'work'
    */
    String theCachePartition();
    /**
     * @description cache namespace
     * @return the cache namespace, generally, 'local'
     */
    String theCacheNamespace();
    /**
     * @description cache partition name == namespace + . + partition
     * @return String
     */
    String partitionName();

    /**
     * @description is cache available
     * @return Boolean
     */
    Boolean isAvailable();

    /**
     * @description get an item from cache
     * @return Object
     */
    Object get(String name);

    /**
     * @description item in the cache
     * @return Boolean
     */
    Boolean contains(String name);

    /**
     * @description get cache keys
     * @return Boolean
     */
    Set<String> getKeys();

    /**
     * @description put value into cache
     * @return void
     */
    void put(String key, Object value);

    /**
     * @description put value into cache
     *
     * @param key String name
     * @param value object value
     * @param ttlSecstime to live in seconds (max. in 8 hrs == 28,800 secs - min is 300 secs) MAX_TTL_SECS
     */
    void put(String key, Object value, Integer ttlSecs);

    /**
     * @description remove case sensitive key value from cache
     *
     * @param key case sensitive string name
     * @return Boolean true if removed
     */
    Boolean remove(String key);

    //////////////////////////////////////////////////////////////////////////////////
    // Now allow for by Partition
    //////////////////////////////////////////////////////////////////////////////////
    /**
    * @description get an item from cache
    * @param String the cache partition
    * @return Object
    */
    Object get(String partition, String name);

    /**
     * @description item in the cache
     * @param String the cache partition
     * @return Boolean
     */
    Boolean contains(String partition, String name);

    /**
     * @description get cache keys
     * @param String the cache partition
     * @return Boolean
     */
    Set<String> getKeys(String partition);

    /**
     * @description put value into cache
     * @param String the cache partition
     * @return void
     */
    void put(String partition, String key, Object value);

    /**
     * @description put value into cache
     *
     * @param String the cache partition
     * @param key String name
     * @param value object value
     * @param ttlSecstime to live in seconds (max. in 8 hrs == 28,800 secs - min is 300 secs) MAX_TTL_SECS
     */
    void put(String partition, String key, Object value, Integer ttlSecs);

    /**
     * @description remove case sensitive key value from cache
     *
     * @param String the cache partition
     * @param key case sensitive string name
     * @return Boolean true if removed
     */
    Boolean remove(String partition, String key);

} // end of accc_ICache