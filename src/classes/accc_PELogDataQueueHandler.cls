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
 * @description Platform Event queuable to insert or delete into/from BO
 * @group Data
 */
public class accc_PELogDataQueueHandler extends accc_QueableBigObjects {
	/////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////

	/////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////

	/**
	* @description ctor to insert/or remove items from big object
	*
	* @param entries data entries
	*/
	public accc_PELogDataQueueHandler(List<accc_PlatformEventDAOLog> entries) {
		super(accc_PlatformEventDAOLog.mapFrom(entries), false);
	}
	/**
	* @description ctor to insert/or remove items from big object
	*
	* @param entries data entries
	*
	*/
	public accc_PELogDataQueueHandler(List<accc_Org_Events__b> entries) {
		super(entries, false);
	}
	/**
	 * @description ctor to insert/or remove items from big object
	 *
	 * @param entries data entries
	 * @param remove true if to remove data; otherwise insert
	 *
	 */
	public accc_PELogDataQueueHandler(List<accc_PlatformEventDAOLog> entries, boolean remove) {
		super(accc_PlatformEventDAOLog.mapFrom(entries), remove);
	}
	/**
	* @description ctor to insert/or remove items from big object
	*
	* @param entries data entries
	* @param remove true if to remove data; otherwise insert
	*
	*/
	public accc_PELogDataQueueHandler(List<accc_Org_Events__b> entries, boolean remove) {
		super(entries, remove);
	}
	/////////////////////////////////////////////////////////////////////////
	// Private Methods
	/////////////////////////////////////////////////////////////////////////

	/**
	* @description this is redundant ; used for testing
	* @author Bill Anderson 
	* @return List<Database.SaveResult>
	*/
	@TestVisible
	private static List<Database.SaveResult> getTestResultsForBigObject() {
		List<Database.SaveResult> results = null;
		if ( accc_ApexConstants.UnitTestsRunning ) {
			// SIMULATING RESULTS
			results = new  List<Database.SaveResult> {
				(Database.SaveResult)JSON.deserialize('{"id":"000000000000000AAA","success":true,"errors":[]}', Database.SaveResult.class),
				(Database.SaveResult)JSON.deserialize('{"id":"000000000000000BAA","success":true,"errors":[]}', Database.SaveResult.class),
				(Database.SaveResult)JSON.deserialize('{"id":"000000000000000CAA","success":true,"errors":[]}', Database.SaveResult.class)

			};
		}
		return results;

	}// end of getTestResultsForBigObject
} // end of accc_PELogDataQueueHandler