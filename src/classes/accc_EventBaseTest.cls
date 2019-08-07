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
 * @description Test PE , accc_EventBase functionality. 
 *
 * @group Test Layer
 **/
@isTest
private class accc_EventBaseTest {
   
   // Used for testing
   public with sharing class myEventTestClass extends accc_EventBase    {
       @TestVisible
       Boolean afterCalled = false;
       @TestVisible
       Integer numOfItems = 0;
       @TestVisible
       Boolean setException = false;
       
       public myEventTestClass(List<SObject> incoming, Type theEventType){
           super(incoming,theEventType);
       }
       public  override void onAfterInsertChild(List<SObject> newItems) {
           this.afterCalled=true;
           this.numOfItems = newItems == null ? 0 : newItems.size();
           if ( this.setException){
               this.processException = new accc_ApexApplicationException('myEventTestClass');
           }
       }
   }

   @isTest
   static void testaccc_EventBaseDefaultCtor(){
        // arrange / act
        accc_EventBase ctor = new accc_EventBase();
        // assert
        system.assertEquals(true, ctor != null);
        system.assertEquals(true, ctor.records()==null);
        system.assertEquals(true, ctor.eventType==null);
        system.assertEquals(true, ctor.processException==null);
   }
    @isTest
   static void testaccc_EventBaseCtorWithType(){
        // arrange / act
        Type theExpectedType = Account.class;
        accc_EventBase ctor = new accc_EventBase(theExpectedType);
        // assert
        system.assertEquals(true, ctor != null);
        system.assertEquals(true, ctor.records()==null);
        system.assertEquals(true, ctor.eventType==theExpectedType);
   }
    @isTest
   static void testaccc_EventBaseCtorWithRecords(){
        // arrange / act
        Type theExpectedType = Account.class;
        List<Account> theRecords = new List<Account> {
            new Account(),
            new Account()
        };
        accc_EventBase ctor = new accc_EventBase(theRecords);
        // assert
        system.assertEquals(true, ctor != null);
        system.assertEquals(true, ctor.records().size()==theRecords.size());
        system.assertEquals(true, ctor.eventType==theExpectedType);
   }
    @isTest
   static void testaccc_EventBaseCtorWithRecordsAndType(){
       // arrange / act
        Type theExpectedType = Account.class;
        List<Account> theRecords = new List<Account> {
            new Account(),
            new Account()
        };
        accc_EventBase ctor = new accc_EventBase(theRecords,theExpectedType);
        // assert
        system.assertEquals(true, ctor != null);
        system.assertEquals(true, ctor.records().size()==theRecords.size());
        system.assertEquals(true, ctor.eventType==theExpectedType);
   }
     @isTest
   static void testaccc_EventBaseOnAfter(){
       // arrange / act
        Type theExpectedType = Account.class;
        List<Account> theRecords = new List<Account> {
            new Account(),
            new Account()
        };
        myEventTestClass ctor = new myEventTestClass(theRecords,theExpectedType);
        
        // assert
        system.assertEquals(true, ctor != null);
        system.assertEquals(true, ctor.records().size()==theRecords.size());
        system.assertEquals(true, ctor.eventType==theExpectedType);
        system.assertEquals(false, ctor.afterCalled);
        system.assertEquals(true, ctor.numOfItems==0);
        // act
        ctor.onAfterInsertChild(theRecords);
        // assert
        system.assertEquals(true, ctor.afterCalled);
        system.assertEquals(true, ctor.numOfItems==theRecords.size());
        system.assertEquals(true, ctor.processException == null);

        // act
        ctor.setException=true;
        ctor.onAfterInsertChild(theRecords);
        // assert
        system.assertEquals(true, ctor.processException != null);

   }

}// end of accc_EventBaseTest