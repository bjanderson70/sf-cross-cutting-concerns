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
 * @description  Test message transformation
 * @group Common Test Layer
 */
@isTest
private class accc_MessageTransformationTest {

	@isTest
	static void testtranslateToLogE() {
		String msg = 'testtranslateToLogE';
		AcccApplicationLog__c apl = new AcccApplicationLog__c(Message__c = msg);
		accc_Log__e loge = accc_MessageTransformation.translate(apl);
		system.assertEquals(true, loge.Message__c.contains(msg));
	} // end of testtranslateToLogE

	@isTest
	static void testtranslateFromObjectToApplicationLog() {
		String msg = 'testtranslateToApplicationLog';
		accc_Log__e loge = new accc_Log__e(Message__c = msg);
		AcccApplicationLog__c apl = accc_MessageTransformation.translate(loge);
		
		system.assertEquals(true, apl.Message__c.contains(msg));
	} // end of testtranslateFromObjectToApplicationLog

	@isTest
	static void testtranslateToApplicationLog() {
		String msg = 'testtranslateToApplicationLog';
		Object loge = msg;
		AcccApplicationLog__c apl = accc_MessageTransformation.translate(LoggingLevel.DEBUG, loge);
		system.assertEquals(true, apl.DebugLevel__c == LoggingLevel.DEBUG.name());
		system.assertEquals(true, apl.Message__c.contains(msg));
	} // end of testtranslateToApplicationLog

	@isTest
	static void testtranslateToListLogE() {
		String msg = 'testtranslateToListLogE';
		List<AcccApplicationLog__c> apl = new List<AcccApplicationLog__c> { new AcccApplicationLog__c(Message__c = msg)};
		List<accc_Log__e> loge = accc_MessageTransformation.translate(apl);
		system.assertEquals(true, loge[0].Message__c.contains(msg));
	} // end of testtranslateToListLogE

	@isTest
	static void testtranslateListObjectToApplList() {
		String msg = 'testtranslateToListLogE';
		integer inx = 0;
		List<Object> apl = new List<Object> { '1', '2', '3'};
		List<AcccApplicationLog__c> alog = accc_MessageTransformation.translate(LoggingLevel.INFO, apl);
		for ( Object aMsg : apl) {
			system.assertEquals(true, alog[inx].Message__c.contains((String)aMsg));
			inx++;
		}
	} // end of testtranslateListObjectToApplList

	@isTest
	static void testtranslateToListApplicationLog() {
		String msg = 'testtranslateToListApplicationLog';
		List<accc_Log__e> loge = new List<accc_Log__e> {new accc_Log__e(Message__c = msg)};
		List<AcccApplicationLog__c> apl = accc_MessageTransformation.translate(loge);
		system.assertEquals(true, apl[0].Message__c.contains(msg));
	} // end of testtranslateToListApplicationLog

	@isTest
	static void testtranslateToListApplicationLogWithNull() {

		List<accc_Log__e> loge = null;
		List<AcccApplicationLog__c> apl = accc_MessageTransformation.translate(loge);
		system.assertEquals(true, apl == null);
	} // end of testtranslateToListApplicationLogWithNull

	@isTest
	static void testtranslateToListLogEWithNull() {

		List<AcccApplicationLog__c> apl = null;
		List<accc_Log__e> loge = accc_MessageTransformation.translate(apl);
		system.assertEquals(true, loge == null);
	} // end of testtranslateToListLogEWithNull

	@isTest
	static void testtranslateLogEntry() {

		List<ACCC_Log_Event__e> apl = generateLogEvent(10);
		List<AcccApplicationLog__c> loge = accc_MessageTransformation.translate(apl);
		system.assertEquals(true, loge.size() == apl.size());
	} // end of testtranslateLogEntry

	static List<ACCC_Log_Event__e> generateLogEvent(integer count){
		List<ACCC_Log_Event__e> entries = new List<ACCC_Log_Event__e>();
		ACCC_Log_Event__e datum;
		Integer ctSize = accc_CDCEventBase.CDC_KNOWN_CHANGE_TYPES.size()-1, 
		index=0;
		Id userId = UserInfo.getUserId();
		String uname = UserInfo.getName();
		Account acct= new Account();
 
		for ( integer inx=0; inx < count; inx++){
			entries.add( new ACCC_Log_Event__e(	Action__c= accc_CDCEventBase.CDC_KNOWN_CHANGE_TYPES[index++],
                                      	External_Id__c=accc_ApexUtilities.newGuid(),
                                      	TransactionId__c = accc_ApexUtilities.newGuid(),
                                      	Exception__c = (index == 3) ? 'accc_ApexApplicationException {}' : '',
                                      	Payload__c = JSON.serialize(acct),
                                    	UserId__c = userId,
									 	Version__c = '1.0.0.0',
										Sequence_Number__c = 1,
										Total_Number__c=1,
										DateTime__c = DateTime.now()
									)
						);
			index = index > ctSize ? 0 : index;
		}
		return entries;
	}
} // end of accc_MessageTransformationTest