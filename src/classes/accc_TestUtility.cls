/**
 * Copyright (c) 2016-2018, Bill Anderson. All rights reserved.
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
 * @description Utilities for testing
 * @group Common Test Layer
 */
@TestVisible
@isTest
private class accc_TestUtility {

	static Integer s_num = 1;
	/**
	*
	 * @description create a fake id / sobject
	 *
	 * @param Schema.SObjectType, type of sobject, i.e. Account.SObjectType
	 * @return String , fake id
	 */
	@TestVisible
	static String getFakeId(Schema.SObjectType sot) {
		String result = String.valueOf(s_num++);
		return sot.getDescribe().getKeyPrefix() +
		       '0'.repeat(12 - result.length()) + result;
	} // end of getFakeId

	@TestVisible
	User getSysAdminRunAsUser() {
		return accc_TestUtility.getRunAsUserByName('System Administrator');
	} // end of getSysAdminRunAsUser
	@TestVisible
	User getStandardRunAsUser() {
		return accc_TestUtility.getRunAsUserByName('Standard User');

	} // end of getStandardRunAsUser

	@TestVisible
	static User getRunAsUserByName(string profileName) {

		String uniqueUserName = 'definedUser' + DateTime.now().getTime() + '@salesforcetestorg.com';
		// This code runs as the system user
		Profile prf = [SELECT Id FROM Profile WHERE Name = :profileName];
		return new User(Alias = 'standt',
		                Email = 'standarduser@salesforcetestorg.com',
		                EmailEncodingKey = 'UTF-8',
		                LastName = 'Testing',
		                LanguageLocaleKey = 'en_US',
		                LocaleSidKey = 'en_US',
		                ProfileId = prf.Id,
		                TimeZoneSidKey = 'America/Los_Angeles',
		                UserName = uniqueUserName);
	} // end of getRunAsUserByName

	//------------------------------------------------------------------------------------
	// Method Name: createTask
	// Arguments  :
	// Purpose    : To Create new Task for testing
	//------------------------------------------------------------------------------------
	@TestVisible
	static  List<Task> createTask(integer count) {

		List<Task> tasks = new List<Task>();
		for (integer inx = 0; inx < count; inx++ ) {
			tasks.add(new Task(
			              ActivityDate = Date.today().addDays(inx + 1),
			              Subject = 'Sample Task -- id' + inx,
			              OwnerId = UserInfo.getUserId(),
			              Status = 'In Progress'));
		}
		return tasks;
	} // end of createTask

} // end of accc_TestUtility