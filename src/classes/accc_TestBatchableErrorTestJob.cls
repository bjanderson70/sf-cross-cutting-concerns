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
 * @description Used to test accc_BatchApexErrorEventHandlerTest [FOR TESTING ONLY]
 * Class MUST BE public for visibility (creation)
 * @group Common Test Layer
 */
@isTest
public class accc_TestBatchableErrorTestJob implements Database.Batchable<SObject>, Database.RaisesPlatformEvents {

    public static final String EXCEPTION_MESSAGE = 'Test exception';
    public static final String CAUSE_BAD_FLOW_NAME = 'Bad-Batch';
    public static final String CAUSE_BAD_ASYNC_FLOW_NAME = 'Bad-Async';
    public static final String CAUSE_GOOD_FLOW_NAME = 'All good';

    private List<Account> accounts;
    private Boolean IS_BATCH_EXCEPTION = false;

    public accc_TestBatchableErrorTestJob(List<Account> accounts) {
        this.accounts = accounts;
    }

    public List<Account> start(Database.BatchableContext ctx) {
        return accounts;
    }

    public void execute(Database.BatchableContext ctx, List<Account> scope) {
        try {
            // Query accounts
            Set<Id> accountIds = new Map<Id, Account>(scope).keySet();
            List<Account> accounts = [select Id, Name from Account where id in :accountIds];

            // Throw a test exception?
            if (accounts[0].Name == CAUSE_BAD_FLOW_NAME) {
                IS_BATCH_EXCEPTION = true;
                throw new TestJobException(EXCEPTION_MESSAGE);
            } else if ( accounts[0].Name == CAUSE_BAD_ASYNC_FLOW_NAME ) {
                throw new TestJobException(EXCEPTION_MESSAGE);
            }
            // Update account if all good
            for (Account account : accounts) {
                account.Name = CAUSE_GOOD_FLOW_NAME;
            }
            update accounts;
        } catch (Exception excp) {
            SObject event = null;
            if ( !IS_BATCH_EXCEPTION ) {
                AsyncOperationEvent aevent = new AsyncOperationEvent();
                aevent.OperationId = '12345';
                event = aevent;
            } else {
                // We emulate BatchApexErrorEvent firing if running in test mode (subject to change once the feature GA's)
                BatchApexErrorEvent bevent = new BatchApexErrorEvent();
                bevent.AsyncApexJobId = ctx.getJobId();
                bevent.DoesExceedJobScopeMaxLength = false;
                bevent.ExceptionType =  'Error';
                bevent.JobScope = String.join((Iterable<Id>) new Map<Id, SObject>(scope).keySet(), ',');
                bevent.Message = excp.getMessage();
                bevent.RequestId = null; // Not currently acccessibe via Apex
                bevent.StackTrace = excp.getStackTraceString();
                event = bevent;
            }
            EventBus.publish(event);
        }
    }

    public void finish(Database.BatchableContext ctx) {
    }
    public class TestJobException extends Exception { }
}// end of accc_TestBatchableErrorTestJob