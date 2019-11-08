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
 * @description test previous transaction result
 * @group Common Test Layer
 */
@isTest
private class accc_ApexPreviousTransactionResultTest {

    @isTest
    static void Testctor() {
        // assign
        accc_IPreviousTransactionResult result = new accc_ApexPreviousTransactionResult();
        // act
        List<Database.SaveResult>  db = result.databaseResult();
        // assert
        System.assert(db == null, 'accc_ApexPreviousTransactionResultTest ctor null');
    } // end of Testctor

    @isTest
    static void TestctorInjection() {
        // assign
        List<Database.SaveResult>  db = new List<Database.SaveResult>();
        accc_IPreviousTransactionResult result = new accc_ApexPreviousTransactionResult(db);
        // act
        List<Database.SaveResult>  dbResult = result.databaseResult();
        // assert
        System.assert(dbResult != null, 'accc_ApexPreviousTransactionResultTest  databaseResult != null');
    } // end of TestctorInjection
    @isTest
    static void TestprocessError() {
        // assign
        List<Database.SaveResult>  db = new List<Database.SaveResult>();
        accc_IPreviousTransactionResult trans = new accc_ApexPreviousTransactionResult(db);
        // act
        Boolean result = trans.processErrors();
        // assert
        System.assert(result == false, 'accc_ApexPreviousTransactionResultTest  result != false');
    } // end of TestprocessError

    @isTest
    static void TestprocessErrorWithSavedResult() {
        // assign
        Account[] accts = new List<Account> {
            new Account(Name = 'Account1'),
            new Account(),
            new Account()
        };
        Database.SaveResult[] srList = Database.insert(accts, false);
        accc_IPreviousTransactionResult trans = new accc_ApexPreviousTransactionResult(srList);
        // act ( expect errors to be processed)
        Boolean result = trans.processErrors(true);
        // assert
        System.assert(result == true, 'accc_ApexPreviousTransactionResultTest  result != true');
    } // end of TestprocessErrorWithSavedResult

} // end of accc_ApexPreviousTransactionResultTest