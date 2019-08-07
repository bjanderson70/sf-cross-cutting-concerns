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
 * @description Platform Event Logger Tester (Singleton for the public; not so for protected/children)
 * @group Test Layer
 */
@isTest
private  class accc_PlatformEventLoggerTest {
	@isTest
	static void testlog() {
		accc_PlatformEventLogger.myInstance().log('test me');
		System.assertEquals( true, accc_PlatformEventLogger.myInstance().inLog('test me'));
		accc_PlatformEventLogger.m_logInformation.clear();
		accc_PlatformEventLogger.myInstance().log((String)null);
		System.assertEquals( accc_PlatformEventLogger.m_logInformation.size(), 1);
	}
	@isTest
	static void testlogWithException() {
		accc_PlatformEventException excp = new accc_PlatformEventException('test me');

		accc_PlatformEventLogger.myInstance().log(excp);
		System.assertEquals( true, accc_PlatformEventLogger.myInstance().inLog('test me'));
		accc_PlatformEventLogger.m_logInformation.clear();
		accc_PlatformEventLogger.myInstance().log((Exception)null);
		System.assertEquals(true, accc_PlatformEventLogger.m_logInformation.size() == 0);
	} // end of testlogWithException

	@isTest
	static void testinLog() {
		accc_PlatformEventLogger.myInstance().log('test me');
		System.assertEquals( true, accc_PlatformEventLogger.myInstance().inLog('test me'));
		accc_PlatformEventLogger.m_logInformation.clear();
		accc_PlatformEventLogger.myInstance().log((String)null);
		System.assertEquals( accc_PlatformEventLogger.myInstance().inLog(null), false);
	}
	@isTest
	static void testlogAsPlatformEvent() {
		//assign/act
		accc_PlatformEventLogger.myInstance().logAsPlatformEvent(LoggingLevel.DEBUG, 'test');
		//assert
		System.assertEquals( true, accc_PlatformEventLogger.myInstance().getInLog().contains('test'));
	}

	@isTest
	static void testusingACCC(){
		integer expected = Database.countQuery(accc_PlatformEventLogger.CHECK_FOR_ACCC);
		//assert
		System.assertEquals( expected > 0, accc_PlatformEventLogger.usingACCC());
	}
} // end of accc_PlatformEventLoggerTest