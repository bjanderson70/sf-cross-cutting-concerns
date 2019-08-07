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
 * @description handle database results
 * @group Test Layer
 */
@isTest
private class accc_GenericDbResultHandlerTest {
	@isTest
	static void testCtoraccc_GenericDbResultHandlerDelete() {
		// assign
		List<Database.DeleteResult> result = new List<Database.DeleteResult>();

		// act
		accc_GenericDbResultHandler ctor = new accc_GenericDbResultHandler(result);
		//assert
		System.assertEquals( accc_GenericDbResultHandler.ResultType.DELETE_RESULT, ctor.theResultType);
		System.assertEquals( 0, ctor.dbErrors.size());
		System.assertEquals( false, ctor.hasErrors());
	} // end of testCtoraccc_GenericDbResultHandlerDelete
	@isTest
	static void testCtoraccc_GenericDbResultHandlerInsert() {
		// assign
		List<Database.SaveResult> result = new List<Database.SaveResult>();

		// act
		accc_GenericDbResultHandler ctor = new accc_GenericDbResultHandler(result);
		//assert
		System.assertEquals( accc_GenericDbResultHandler.ResultType.INSERT_RESULT, ctor.theResultType);
		System.assertEquals( 0, ctor.dbErrors.size());
		System.assertEquals( false, ctor.hasErrors());
	} // end of testCtoraccc_GenericDbResultHandlerInsert
	@isTest
	static void testCtoraccc_GenericDbResultHandlerUnDelete() {
		// assign
		List<Database.UnDeleteResult> result = new List<Database.UnDeleteResult>();

		// act
		accc_GenericDbResultHandler ctor = new accc_GenericDbResultHandler(result);
		//assert
		System.assertEquals( accc_GenericDbResultHandler.ResultType.UNDELETE_RESULT, ctor.theResultType);
		System.assertEquals( 0, ctor.dbErrors.size());
		System.assertEquals( false, ctor.hasErrors());
	} // end of testCtoraccc_GenericDbResultHandlerUnDelete
	@isTest
	static void testCtoraccc_GenericDbResultHandlerUpdate() {
		// assign
		List<Database.UpsertResult> result = new List<Database.UpsertResult>();

		// act
		accc_GenericDbResultHandler ctor = new accc_GenericDbResultHandler(result);
		//assert
		System.assertEquals( accc_GenericDbResultHandler.ResultType.UPDATE_RESULT, ctor.theResultType);
		System.assertEquals( 0, ctor.dbErrors.size());
		System.assertEquals( false, ctor.hasErrors());
	} // end of testCtoraccc_GenericDbResultHandlerUpdate

	@isTest
	static void testprocessErrors() {
		// assign
		List<Database.UpsertResult> result = new List<Database.UpsertResult>();

		// act
		accc_GenericDbResultHandler ctor = new accc_GenericDbResultHandler(result);
		List<String> results = ctor.processErrors();
		//assert);
		System.assertEquals( 0, results.size());
	} // end of testprocessErrors

	@isTest
	static void testprocessErrorsWithErrors() {
		// assign
		List<Database.SaveResult> results = new  List<Database.SaveResult> {
			(Database.SaveResult)JSON.deserialize('{"success":false,"errors":[{"message":"You fool what are you doing...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class)
		};
		// act
		accc_GenericDbResultHandler ctor = new accc_GenericDbResultHandler(results);
		List<String> errors = ctor.processErrors();
		//assert;
		System.assertEquals( true, errors.size() > 0);
		System.assertEquals( true, ctor.dbErrors.size() > 0);
		System.assertEquals( true, ctor.hasErrors());
	} // end of testprocessErrorsWithErrors
 
	@isTest
	static void testdbErrorsSetter() {
		// assign
		List<Database.SaveResult> results = new  List<Database.SaveResult> {
			(Database.SaveResult)JSON.deserialize('{"success":false,"errors":[{"message":"You fool what are you doing...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class)
		};
		// act
		accc_GenericDbResultHandler ctor = new accc_GenericDbResultHandler(results);
		List<String> errors = ctor.processErrors();
		//assert;
		System.assertEquals( true, errors.size() > 0);
		System.assertEquals( true, ctor.dbErrors.size() > 0);
		System.assertEquals( true, ctor.hasErrors());
		// act
		ctor.dbErrors = null;
		// assert
		System.assertEquals( true, ctor.dbErrors == null);
	} // end of testprocessErrorsWithErrors
} // end of accc_GenericDbResultHandlerTest