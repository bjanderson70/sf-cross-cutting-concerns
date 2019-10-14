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
 * @description Tests Trigger Resources
 * @group Test Layer
 */
@isTest
private class accc_TriggerHandlerResourcesTest {

    @isTest
    static void testCtor(){
        accc_TriggerHandlerResources res = new accc_TriggerHandlerResources();
        System.assertEquals(null, accc_TriggerHandlerResources.mMapData);
        System.assertEquals(true, res.getLazyResource()!=null);

    }

    @isTest
    static void testAddCountReset(){
        accc_TriggerHandlerResources res = new accc_TriggerHandlerResources();
        List<String> slist = new List<String> { '1','2','3'};
        Set<String> sset = new Set<String> { '4','5','6'};
        Set<String> expectedKeys = new Set<String> { 'list','set','string'};
        res.add('list', slist);
        res.add('set', sset);
        res.add('string', 'test');

        Set<String> setRes = (Set<String>)res.get('set').triggerData;
        List<String> listRes = (List<String>)res.get('list').triggerData;
        String stringRes = (String)res.get('string').triggerData;


        System.assertEquals(sset,setRes);
        System.assertEquals(slist,listRes);
        System.assertEquals('test',stringRes);

        Set<String> keys = res.keys();
        System.assertEquals(3,keys.size());
        System.assertEquals(expectedKeys,keys);

        System.assertEquals(3,res.count());

        res.reset();
        System.assertEquals(0,res.count());


    }

    @isTest
    static void testRemove(){
        accc_TriggerHandlerResources res = new accc_TriggerHandlerResources();
        List<String> slist = new List<String> { '1','2','3'};
        Set<String> sset = new Set<String> { '4','5','6'};

        res.add('list', slist);
        res.add('set', sset);
        res.add('string', 'test');

        Set<String> setRes = (Set<String>)res.get('set').triggerData;
        List<String> listRes = (List<String>)res.get('list').triggerData;
        String stringRes = (String)res.get('string').triggerData;


        System.assertEquals(sset,setRes);
        System.assertEquals(slist,listRes);
        System.assertEquals('test',stringRes);

        res.remove('list');
        res.remove('set');
        res.remove('string');

        accc_TriggerHandlerResources.PassThruResourceDAO setResDAO = res.get('set'),
                            listResDAO = res.get('list'),
                            stringResDAO = res.get('string');


        System.assertEquals(null,setResDAO);
        System.assertEquals(null,listResDAO);
        System.assertEquals(null,stringResDAO);
    }

    @isTest
    static void testCollectonActivities(){
        accc_TriggerHandlerResources res = new accc_TriggerHandlerResources();
        final Integer count = 30;

        for ( integer inx=0; inx < count; inx++) {
            res.add(''+inx,inx);
        }
        for ( integer jnx=0; jnx < count; jnx++) {
            System.assertEquals (jnx,(integer)res.get(''+jnx).triggerData);
        }

        System.assertEquals(count,res.count());
        for ( integer knx=0; knx < count; knx++) {
            System.assertEquals (true,res.remove(''+knx));
        }
        System.assertEquals(0,res.count());

    }
}// end of accc_TriggerHandlerResourcesTest