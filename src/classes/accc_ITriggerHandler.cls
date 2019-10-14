/**
 * Copyright (c) 2016-2018, Bill anderson.  All rights reserved.
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
 * @author Bill anderson
 * @description Encapsulates all behaviour logic relating to trigger handling in
 * children of the Domains
 *
 * @group Domain Layer
 **/
public interface accc_ITriggerHandler {
    /*
     * Represents the data pass thru to subsequent calls
     * Pay attention to #5 in this link ( https ://developer.salesforce.com/index.php?title=Apex_Code_Best_Practices&oldid=26951 )
     */
    accc_TriggerHandlerResources handlerResources();
	/**
	 * @description add an error on the sobject. When used on Trigger.new
	 * in before insert and before update triggers, and on Trigger.old in
	 * before delete triggers, the error message is displayed in the application
	 * interface.
	 *
	 * @param triggerObject the salesforce object (from the trigger invocation) to see the error message
	 * @param errorMessage error message
	 */
	void addError(SObject triggerObject, String errorMessage);
	/**
	 * @description OnBefore Delete Event
	 * @param records the current records associated with the event
	 **/
	void onBeforeDeleteChild(List<SObject> records);
	/**
	 * @description On After Delete Event
	 * @param records the current records associated with the event
	 **/
	void onAfterDeleteChild(List<SObject> records);
	/**
	 * @description On Before Insert Event
	 * @param records the current records associated with the event
	 **/
	void onBeforeInsertChild(List<SObject> records);
	/**
	 * @description on Before Update Event
	 * @param records the current records associated with the event
	 * @param existingRecords the old records associated with the event
	 **/
	void onBeforeUpdateChild(List<SObject> records, Map<Id, SObject> existingRecords);
	/**
	 * @description On After Insert Event
	 * @param records the current records associated with the event
	 **/
	void onAfterInsertChild(List<SObject> records);
	/**
	 * @description On After Update Event
	 * @param records the current records associated with the event
	 * @param existingRecords the old records associated with the event
	 **/
	void onAfterUpdateChild(List<SObject> records, Map<Id, SObject> existingRecords);
	/**
	 * @description On After Undelete Event
	 * @param records the current records associated with the event
	 **/
	void onAfterUndeleteChild(List<SObject> records);

} // end of accc_ITriggerHandler