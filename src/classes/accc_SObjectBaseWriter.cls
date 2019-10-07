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
 * @author Bill anderson
 * @desciption  Encapsulates all behaviour logic relating to the SObject Writing
 *
 * @group Common Layer
 **/
public virtual without sharing class accc_SObjectBaseWriter implements  Database.RaisesPlatformEvents  {
	///////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// Data Members
	///////////////////////////////////////////////////////////////////////////////////////////////////////
	
	@TestVisible
	static final String EXCEPTION_MESG_FOR_TEST = 'accc_SObjectBaseWriter caused Exception';

	@TestVisible
	private List<SObject> m_entries;
	@TestVisible
	private Boolean m_removeAction = false;
	@TestVisible
	private Boolean m_isBigObject = false;
	@TestVisible
	private Exception m_exception = null;
	@TestVisible
	static Boolean m_testToCaseException = false;

	///////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// Ctors
	///////////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	* @description ctor to insert/or remove SObjects
	*
	* @param sentries data entries
	*/
	public accc_SObjectBaseWriter(List<SObject> sentries) {
		this(sentries, false);
	}// end ctor

	/**
	 * @description ctor to insert/or remove items/sobjects
	 *
	 * @param entries data entries
	 * @param remove true if to remove data; otherwise insert
	 *
	 */
	public accc_SObjectBaseWriter(List<SObject> sentries, boolean remove) {
		this.entries = sentries;
		this.actions = remove;
	}// end ctor

	/////////////////////////////////////////////////////////////////////////
	// Public Properties
	/////////////////////////////////////////////////////////////////////////
	/**
	 * Getter/sSetter for the exception, if any
	 */
	@TestVisible
	public Exception theException {
		get { return this.m_exception;}
		protected set { this.m_exception = value;}
	} // end of theException

	/**
	 * Getter/sSetter of SObject collection
	 */
	@TestVisible
	public  List<SObject> entries {
		get { return this.m_entries;}
		protected set { this.m_entries = value;}
	} // end of entries

	/**
	 * Getter/sSetter of the action ( add/remove)
	 */
	@TestVisible
	public  Boolean actions {
		get { return this.m_removeAction;}
		set { this.m_removeAction = value;}
	} // end of actions

	/**
	* Indicatator on whether to perform I/O with Big Object
	*/
	@TestVisible
	public Boolean isBigObject {
		get { return this.m_isBigObject;}
		set { this.m_isBigObject = value;}
	} // end of isBigObject
	/////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////

	/*
	* Here we insert/remove records,
	* or log an error if insertion fails.
	*/
	public virtual void execute() {

		if ( this.entries == null || this.entries.size() == 0 ) {
			return;
		}
		// all checks out, go process
		this.process();

	} // end of execute

	/**
	 * @description create a queuable writer based on settings
	 * @param entries data entries
	 * @param remove true if to remove data; otherwise insert
	 * @param isThisABigObject is a big object type
	 *
	 * @return either a Big Object writer or regular SObject writer
	 */
	public static accc_SObjectBaseWriter queuableWriter(List<SObject> sentries,
	        boolean remove,
	        Boolean isThisABigObject) {
		accc_SObjectBaseWriter writer = null;
		// have to treat operations differently ... REFACTOR in order to avoid the 'if'
		if ( isThisABigObject ) {
			writer = new accc_QueableBigObjects(sentries, remove);
		} else {
			writer = new accc_QueableSObjects(sentries, remove);
		}
		return writer;
	} // end of queuableWriter

	/////////////////////////////////////////////////////////////////////////
	// Protcted Methods
	/////////////////////////////////////////////////////////////////////////
	/**
	 * @description process the db operation
	 */
	@TestVisible
	protected virtual void process() {

		try {
			// used for testing
			if (accc_ApexConstants.UnitTestsRunning) {
				// testing -- cause an exception
				if ( accc_SObjectBaseWriter.m_testToCaseException) {
					throw new accc_ApexApplicationException(EXCEPTION_MESG_FOR_TEST);
				}
			}
			// perform the sobject action ( add/remove) and process errors, if any
			// we catch the exception and process , if necessary
			this.performDatabaseOperation();

		} catch (Exception excp) {
			this.theException = excp;
			// Exception occurred, output the exception message
			accc_ApexUtilities.log(excp);
		}
		//return this.theException == null;
	} // end of process
	/**
	 * @description perform the db op
	 * @return db handler accc_GenericDbResultHandler
	 */
	@TestVisible
	protected virtual accc_GenericDbResultHandler  performDatabaseOperation() {
		accc_GenericDbResultHandler result =  this.isBigObject ? this.dataIOBigObject(this.actions) : this.dataIOSObject(this.actions);

		// process errors, if any
		if ( result != null && result.hasErrors() ) {
			List<String> errors = result.processErrors();
			errors.remove(null);
			this.theException = new accc_ApexApplicationException( string.join(errors, ','));
		}

		return result;
	} // end of performDatabaseOperation
	/**
	 * @description data io for SObject
	 *
	 * @param action if true, remove otherwise insert
	 * @return accc_GenericDbResultHandler Db Result
	 */
	@TestVisible
	protected virtual accc_GenericDbResultHandler dataIOSObject(boolean action) {
		accc_GenericDbResultHandler result = null;
		if ( !this.isBigObject ) {
			// ++++ Inserting
			if ( action == false ) {
				// We upsert, this way we cover insert or update.
				result = new accc_GenericDbResultHandler( Database.upsert(this.entries));
				// Deleting
			} else {
				// Use appropriate function for BO
				result = new accc_GenericDbResultHandler( Database.delete(this.entries));
			}
		}
		return result;
	} // end of dataIOSObject
	/**
	 * @description data io for BigObject
	 *
	 * @param action if true, remove otherwise insert
	 * @return accc_GenericDbResultHandler Db Result
	 */
	@TestVisible
	protected virtual accc_GenericDbResultHandler dataIOBigObject(boolean action) {
		accc_GenericDbResultHandler result = null;
		// ensure we are dealing with Big Object
		if ( this.isBigObject ) {
			// are we testing
			if ( accc_ApexConstants.UnitTestsRunning ) {
				result = getTestResultsForBigObject();
			} else {
				// ++++ Inserting
				if ( action == false ) {
					result = new accc_GenericDbResultHandler( Database.insertImmediate(this.entries));
					// Deleting
				} else {
					// Use appropriate function for BO
					result = new accc_GenericDbResultHandler( Database.deleteImmediate(this.entries));
				}
			}
		}

		return result;
	} // end of dataIOBigObject

	/**
	 * @description used for testing big objects results
	 *
	 * @return  accc_GenericDbResultHandler Db Results
	 */
	@TestVisible
	private static accc_GenericDbResultHandler getTestResultsForBigObject() {
		accc_GenericDbResultHandler results = null;
		if ( accc_ApexConstants.UnitTestsRunning ) {
			// SIMULATING RESULTS
			results = new accc_GenericDbResultHandler( new  List<Database.SaveResult> {
				(Database.SaveResult)JSON.deserialize('{"id":"000000000000000AAA","success":true,"errors":[]}', Database.SaveResult.class),
				(Database.SaveResult)JSON.deserialize('{"id":"000000000000000BAA","success":true,"errors":[]}', Database.SaveResult.class),
				(Database.SaveResult)JSON.deserialize('{"id":"000000000000000CAA","success":true,"errors":[]}', Database.SaveResult.class)

			});
		}
		return results;

	}// end of getTestResultsForBigObject

} // end of accc_SObjectBaseWriter