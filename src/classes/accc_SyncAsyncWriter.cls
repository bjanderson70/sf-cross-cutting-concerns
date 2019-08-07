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
 * @description Encapsulates all behaviour logic relating to the Synchronous or Asynchronous writes of SObjects
 *
 * @group Common Layer
 **/
public without sharing class accc_SyncAsyncWriter extends accc_SObjectBaseWriter {

	///////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// Data Members
	///////////////////////////////////////////////////////////////////////////////////////////////////////
	@TestVisible
	static final Integer USE_FOR_TESTING_DATASIZE = 1000000;
	// for testing,
	@TestVisible
	static Boolean m_makeAsync = false;
	// number of DML statements we make
	@TestVisible
	static final Integer NUMBER_OF_DML_STMTS = 1;

	///////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// Ctors
	///////////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	* @description ctor to insert/or remove SObjects
	*
	* @param entries data entries
	*/
	public accc_SyncAsyncWriter(List<SObject> entries) {
		this(entries, false, false, false, false);
	}// end ctor

	/**
	 * @description ctor to insert/or remove items/sobjects
	 *
	 * @param entries data entries
	 * @param remove true if to remove data; otherwise insert
	 *
	 */
	public accc_SyncAsyncWriter(List<SObject> entries, boolean remove) {
		this(entries, remove, false, false, false);
	}// end ctor

	/**
	 * @description ctor to insert/or remove items/sobjects
	 *
	 * @param entries data entries
	 * @param remove true if to remove data; otherwise insert
	 * @param synchronousOnly only do synchronous mode ( no async)
	 */
	public accc_SyncAsyncWriter(List<SObject> entries, boolean remove,  boolean synchronousOnly) {
		this(entries, remove, synchronousOnly, false, false);
	}// end ctor

	/**
	 * @description ctor to insert/or remove items/sobjects
	 *
	 * @param entries data entries
	 * @param remove true if to remove data; otherwise insert
	 * @param synchronousOnly only do synchronous mode ( no async)
	 * @param isBigObjectOnly is this a Big Object type?
	 */
	public accc_SyncAsyncWriter(List<SObject> entries, boolean remove,  boolean synchronousOnly, boolean isBigObjectOnly) {
		this(entries, remove, synchronousOnly, isBigObjectOnly, false);
	}// end ctor

	/**
	 * @description ctor to insert/or remove items/sobjects
	 *
	 * @param entries data entries
	 * @param remove true if to remove data; otherwise insert
	 * @param synchronousOnly only do synchronous mode ( no async)
	 * @param isBigObjectOnly is this a Big Object type?
	 * @param forceAsync force to enqueue the operation
	 */
	public accc_SyncAsyncWriter(List<SObject> entries,
	                            boolean remove,
	                            boolean synchronousOnly,
	                            boolean isBigObjectOnly,
	                            boolean forceAsync) {
		super(entries, remove);
		this.isSynchronousOnly = synchronousOnly;
		this.isAsyncWrite = false;
		this.forceAsyncWrite = forceAsync;
		super.isBigObject = isBigObjectOnly;
	}// end ctor

	/////////////////////////////////////////////////////////////////////////
	// Public Properties
	/////////////////////////////////////////////////////////////////////////

	/**
	 * Indicatator on whether to perform I/O with Big Object
	 */
	@TestVisible
	public Boolean forceAsyncWrite { get; protected set;}

	/**
	 * Indicatator on whether to perform I/O synchronously
	 */
	@TestVisible
	public Boolean isSynchronousOnly { get; protected set;}
	/**
	 * Getter/Setter indicating async or sync write behaviour
	 */
	@TestVisible
	public Boolean isAsyncWrite { get; protected set;}
	/////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////

	/////////////////////////////////////////////////////////////////////////
	// Private Methods
	/////////////////////////////////////////////////////////////////////////

	/**
	 * @description process the db operation
	 */
	@TestVisible
	protected override void process() {
		try {
			integer size = this.entries.size();
			// used for testing
			if (Test.isRunningTest()) {
				// testing async ??
				if ( accc_SyncAsyncWriter.m_makeAsync) {
					size = USE_FOR_TESTING_DATASIZE;
				}
			}

			// determine the best course ;
			// Check to see if user wants async ...
			// Or, write synchronously assuming  DML limits (150) are not exceeded,
			// Or do so asynchronously assuming the Queueable limit (50) is abided by;
			// Otherwise, exception
			if ( !this.forceAsyncWrite
			        && !super.isBigObject
			        && ( (Limits.getDMLRows() + size) < Limits.getLimitDMLRows()) &&
			        ( (Limits.getDMLStatements() + NUMBER_OF_DML_STMTS) < Limits.getLimitDMLStatements()) ) {

				this.isAsyncWrite = false;
				// perform the upsert/update or remove action
				this.performDatabaseOperation();

				// are we asynch and not exceeded out limits
			} else if ( !this.isSynchronousOnly
			            && Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()) {
				// we would exceed out governor limits, so process in separate transaction
				this.isAsyncWrite = true;
				// enqueue the writer
				System.enqueueJob(accc_SObjectBaseWriter.queuableWriter(this.entries,
				                  										this.actions,
				                  										super.isBigObject
				                                                       )
				                 );

			} else {
				String excpMsg = '+++ Not Written - Governor Limit exception would occur. +++ '
				                 + accc_ApexConstants.NewLine
				                 + '{ getLimitQueueableJobs:' + Limits.getLimitQueueableJobs()
				                 + ', getQueueableJobs:' + Limits.getQueueableJobs()
				                 + ', getLimitDMLStatements:' + Limits.getLimitDMLStatements()
				                 + ', getDMLStatements: ' + Limits.getDMLStatements()
				                 + ', NumberOfEntries:' + size
				                 + ', getDMLRows:' + Limits.getDMLRows()
				                 + ', is BigObject:' + this.isBigObject
				                 + ', is SynchronousOnly:' + this.isSynchronousOnly
				                 + ', force Async write:' + this.forceAsyncWrite
				                 + '}';

				throw new accc_ApexApplicationException(excpMsg);
			}
		} catch (Exception excp) {

			// more than likely, Governor limts hit
			this.theException = excp;
			// process exception
			accc_ApexEnvironment.getRuntimeEnvironment().exceptionHandler().process(excp);
		}

	} // end of process

} // end of accc_SyncAsyncWriter