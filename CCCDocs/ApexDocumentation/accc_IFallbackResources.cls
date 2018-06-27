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
 * @description Fallback resources in the event a custom setting/static resource is not set in SF
 * @group Common Interface Layer
 */
public virtual  interface accc_IFallbackResources {

    /**
     * @description Get Fallback Resources
     * @return Object - fallback resource
     */
    Object fallbackResource();

    /**
     * @description get fallback resource as a string
     * @return get fallback resource as a string
     */
    String toString();

    /**
     * @description get fallback resource as a Map<String,String>
     * @return get fallback resource as a Map<String,Object>, or  <name,value> pair
     */
    Map<String, Object> toMap();
    /*******************************************************************************************************
    * @description Get a resource by name
    * @param String name of the resource, the common names are in accc_ApexConstants
    * @return Object the result. The common names will detail the return type
    * @example
    * Example code usage. This will be wrapped in  tags to preserve whitespace
    */
    Object get(string name);
    /*******************************************************************************************************
    * @description Get a resource by name and category { category: { name1: value1, name2: value2} }
    * @param String category of the resource, the common names are in accc_ApexConstants
    * @param String name of the resource, the common names are in accc_ApexConstants
    * @return Object the result. The common names will detail the return type
    * @example
    * Example code usage. This will be wrapped in  tags to preserve whitespace
    */
    Object get(string category,string name);
} // end of accc_IFallbackResources