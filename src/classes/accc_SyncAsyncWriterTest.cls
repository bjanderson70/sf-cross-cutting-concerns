/**
 * Copyright (c) 2016-2019, Bill anderson.  All rights reserved.
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
 *   * Neither the name of Bill anderson nor the names of its
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
 *
 * @description  Test class for the  accc_SyncAsyncWriter methods
 * @group Test Layer
 */
@isTest
private class accc_SyncAsyncWriterTest {
	@isTest
	static  void testSyncAsyncWriterAdd() {
		// arrange
		final String name = 'Testaccc_QueableSObjectsTest';

		Boolean isAsyncDone = false;

		// startTest/stopTest block to force async processes
		//   to run in the test.
		Test.startTest();
		Account acct =  createAccount(name, true);
		// act
		accc_SyncAsyncWriter writer = new accc_SyncAsyncWriter(new List<Account> {acct }, false);
		writer.execute();
		Test.stopTest();

		// Validate that the job has run
		// by verifying that the record was created.
		// This query returns only the account created in test context by the
		// Queueable class method.
		// assert
		List<Account> returnedAccts = [SELECT Name  FROM Account WHERE Name = :name];
		System.assertNotEquals(null, returnedAccts);
		System.assertEquals(1, returnedAccts.size());
		System.assertEquals(name, returnedAccts[0].Name);

		System.assertEquals(isAsyncDone, writer.isAsyncWrite);
		System.assertEquals(true, writer.theException == null);
	}

	@isTest
	static  void testSyncAsyncWriterRemove() {
		// arrange
		final String name = 'Testaccc_QueableSObjectsTest';

		Boolean isAsyncDone = false;


		// startTest/stopTest block to force async processes
		//   to run in the test.
		Test.startTest();
		Account acct =  createAccount(name, true);
		List<Account> returnedAccts = [SELECT Name  FROM Account WHERE Name = :name];
		// assert
		System.assertNotEquals(null, returnedAccts);
		System.assertEquals(1, returnedAccts.size());
		System.assertEquals(name, returnedAccts[0].Name);
		// act
		accc_SyncAsyncWriter writer = new accc_SyncAsyncWriter(new List<Account> {acct }, true);

		writer.execute();

		Test.stopTest();

		// Validate that the job has run
		// by verifying that the record was created.
		// This query returns only the account created in test context by the
		// Queueable class method.
		// assert
		returnedAccts = [SELECT Name FROM Account WHERE Name = :name];
		System.assertEquals(0, returnedAccts.size());

		System.assertEquals(isAsyncDone, writer.isAsyncWrite);
		System.assertEquals(true, writer.theException == null);

	}

	@isTest
	static  void testSyncAsyncWriterBadData() {
		// arrange
		final String name = 'Testaccc_QueableSObjectsTest';

		Boolean isAsyncDone = false;

		// startTest/stopTest block to force async processes
		//   to run in the test.
		Test.startTest();
		// act
		accc_SyncAsyncWriter writer = new accc_SyncAsyncWriter(null);

		writer.execute();

		Test.stopTest();

		// Validate that the job
		System.assertEquals(isAsyncDone, writer.isAsyncWrite);
		System.assertEquals(true, writer.theException == null);
	}
	//
	@isTest
	static  void testSyncAsyncWriterAddAsync() {
		// arrange
		final String name = 'Testaccc_QueableSObjectsTest';

		Boolean isAsyncDone = true;

		// startTest/stopTest block to force async processes
		//   to run in the test.
		Test.startTest();
		Account acct = createAccount(name, false);
		// act
		accc_SyncAsyncWriter writer = new accc_SyncAsyncWriter(new List<Account> {acct }, false);
		accc_SyncAsyncWriter.m_makeAsync = true;
		writer.execute();
		writer.theException = new accc_ApexApplicationException('Test');
		Test.stopTest();

		// Validate that the job has run
		// by verifying that the record was created.
		// This query returns only the account created in test context by the
		// Queueable class method.
		// assert
		List<Account> returnedAccts = [SELECT Name  FROM Account WHERE Name = :name ];
		System.assertNotEquals(null, returnedAccts);
		System.assertEquals(1, returnedAccts.size());
		System.assertEquals(name, returnedAccts[0].Name);

		System.assertEquals(isAsyncDone, writer.isAsyncWrite);
		System.assertEquals(true, writer.theException != null);
	}

	@isTest
	static  void testSyncAsyncWriterForceSyncCauseException() {
		// arrange
		final String name = 'Testaccc_QueableSObjectsTest';

		Boolean isAsyncDone = true;

		// startTest/stopTest block to force async processes
		// to run in the test.
		Test.startTest();
		Account acct =  createAccount(name, false);

		// act
		accc_SyncAsyncWriter writer = new accc_SyncAsyncWriter(new List<Account> {acct }, false, true);
		accc_SyncAsyncWriter.m_makeAsync = true;
		writer.execute();

		Test.stopTest();

		// Validate that the job has run
		// by verifying that the record was created.
		// This query returns only the account created in test context by the
		// Queueable class method.
		// assert
		List<Account> returnedAccts = [SELECT Name  FROM Account WHERE Name = :name];
		System.assertEquals(0, returnedAccts.size());
		System.assertEquals(true, writer.theException != null);
	}
	/**
	 * @description create an account -- may need to plug into your account creator for tests
	 *
	 * @param name name for the account
	 * @param doInsert do insert
	 *
	 * @return an account
	 */
	static Account createAccount(String name, Boolean doInsert) {
		Account acct = new Account (Name = name );
		if ( doInsert ) {
			insert acct;
		}
		return acct;
	} // end of createAccount
}