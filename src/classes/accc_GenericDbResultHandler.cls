/**
 * Copyright (c) 2016-2018, Bill Anderson.  All rights reserved.
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
 * @description handle database results. Salesforce needs to refactor this result class to make more polymorphic!
 * @group Common Layer
 */
public without sharing class accc_GenericDbResultHandler {


	////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////
	// result type
	//
	public enum ResultType {
		DELETE_RESULT
		, UPDATE_RESULT
		, UNDELETE_RESULT
		, INSERT_RESULT
	}
	// database errors
	@TestVisible
	List<Database.Error> m_errors = new List<Database.Error>();
	// type of result set
	@TestVisible
	ResultType m_resultType;
	@TestVisible
	integer m_size = 0;
	/*
	* Misc strings for error messages
	**/
	@TestVisible
	static final String TOP_LEVEL_MESG = 'The following error has occurred.';
	@TestVisible
	static final String FIELD_LEVEL_MESG = 'Fields that affected this error: ';

	////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////

	/**
	* @description use for insert
	*
	* @param result collection of insert results
	*/
	public accc_GenericDbResultHandler(List<Database.SaveResult> result) {
		this.theResultType = ResultType.INSERT_RESULT;
		this.size = result != null ? result.size() : 0;
		for ( integer inx = 0; inx < this.size; inx++) {
			this.processErrors(result[inx].getErrors());
		}
	}// end of ctor
	/**
	* @description use for upsert
	*
	* @param result collection of upsert results
	*/
	public accc_GenericDbResultHandler(List<Database.UpsertResult> result) {
		this.theResultType = ResultType.UPDATE_RESULT;
		this.size = result != null ? result.size() : 0;
		for ( integer inx = 0; inx < this.size; inx++) {
			this.processErrors(result[inx].getErrors());
		}
	}// end of ctor
	/**
	* @description use for delete
	*
	* @param result collection of delete results
	*/
	public accc_GenericDbResultHandler(List<Database.DeleteResult> result) {
		this.theResultType = ResultType.DELETE_RESULT;
		this.size = result != null ? result.size() : 0;
		for ( integer inx = 0; inx < this.size; inx++) {
			this.processErrors(result[inx].getErrors());
		}
	}// end of ctor
	/**
	 * @description use for undelete
	 *
	 * @param result collection of undelete results
	 */
	public accc_GenericDbResultHandler(List<Database.UndeleteResult> result) {
		this.theResultType = ResultType.UNDELETE_RESULT;
		this.size = result != null ? result.size() : 0;
		for ( integer inx = 0; inx < this.size; inx++) {
			this.processErrors(result[inx].getErrors());
		}
	}// end of ctor

	////////////////////////////////////////////////////////////////////////
	// Public Properties
	/////////////////////////////////////////////////////////////////////////
	@TestVisible
	public integer size {
		get {return this.m_size; }
		protected set { this.m_size = value;}
	} // end of size

	@TestVisible
	public List<Database.Error> dbErrors {
		get {return this.m_errors; }
		protected set { this.m_errors = value;}
	} // end of dbErrors
	@TestVisible
	public ResultType theResultType {
		get { return this.m_resultType;}
		protected set { this.m_resultType = value;}
	} // end of theResultType

	////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////
	/**
	 * @description we have db errors
	 * @return true if errors
	 */
	public boolean hasErrors() {
		return this.dbErrors.size() != 0;
	} // end of hasErrors
	/**
	 * @description process errors
	 * @return List  of strings (errors)
	 */
	public List<String> processErrors() {
		List<String> loggedErrors = new List<String>();
		// Operation failed, so get all errors
		for (Database.Error err : this.dbErrors) {
			loggedErrors.add(TOP_LEVEL_MESG);
			loggedErrors.add(err.getStatusCode() + ': ' + err.getMessage());
			loggedErrors.add(FIELD_LEVEL_MESG + err.getFields());
		}
		if ( loggedErrors.size() > 0 ) {
			accc_ApexUtilities.log(string.join(loggedErrors, '\n'));
		}

		return loggedErrors;
	} // end of processErrors
	////////////////////////////////////////////////////////////////////////
	// Private Methods
	/////////////////////////////////////////////////////////////////////////
	/**
	 * @description process the incoming errors from the result set
	 *
	 * @param errors colleciton of database errors
	 */
	@TestVisible
	private void processErrors(Database.Error[] errors ) {
		integer size = errors != null ? errors.size() : 0;
		if ( size > 0 ) {
			this.dbErrors.addAll(errors);
		}
	} // end of processErrors

} // end of accc_GenericDbResultHandler