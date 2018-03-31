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
 * @description default factory used for creating new objects. Can add creators via 'add'.
 *     Will look up the type based on name to create and instance
 * @group Common Interface Layer
 */
public virtual  interface accc_IApexFactory {

    /**
	*
     * @description create instance from name
     *
     * @param fqn Fully-Qualified-Name of object to create
     * @return Object instance
     */
    Object create(String fqn);

    /**
	*
     * @description create instance from namespace and name
     *
     * @param namespace of the object
     * @param name instance name
     *
     * @return Object instance
     */
    Object create(String namespace, String name);

    /**
	*
     * @description Add an instance based on the Type. The name will be the Type name
     *
     * @param objType Type of object , i.e. Integer.class
     * @return Object instance
     */
    Object create(Type objType);

    /**
	*
     * @description Add an instance based on the Fully-Qualified-Name and Type
     *
     * @param name instance name
     * @param objType Type of object , i.e. Integer.class
     */
    void add(String name, Type objType);

    /**
	*
     * @description Add an instance based on the Fully-Qualified-Name. The Type will be looked up and added to the create mapping.
     *
     * @param fqn Fully-Qualified-Name of object to create
     */
    void add(String fqn);
    /**
     * @description Add an instance creator
     *
     * @param accc_IApexObjectGetter, the instance creator
     */
    void add(accc_IApexObjectGetter creator);
    /**
     * @description Add an instance creator
     *
     * @param accc_ApexClassInstanceMgr, the instance creator
     */
    void add(accc_ApexClassInstanceMgr creator);
    /**
     * @description find the instance creator by name
     *
     * @param String instance creator by name
     * @return accc_IApexObjectGetter the instance creator
     */
    accc_IApexObjectGetter findByName(string creatorName);
    /**
     * @description Get the list of keys in the factory
     *
     * @return Set of keys
     */
    Set<String> keys();

} // end of accc_IApexFactory