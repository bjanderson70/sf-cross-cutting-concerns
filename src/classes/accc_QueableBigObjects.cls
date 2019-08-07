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
 * @description Queuable for Big Objects
 * @group Common Layer
 */
public virtual without sharing class accc_QueableBigObjects extends accc_QueableSObjects {

	/////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////

	/////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////
	/**
	* @description ctor to insert/or remove SObjects
	*
	* @param sentries data entries
	*/
	public accc_QueableBigObjects(List<SObject> sentries) {
		super(sentries, false);
		super.isBigObject = true;
	}// end ctor

	/**
	 * @description ctor to insert/or remove items/sobjects
	 *
	 * @param sentries data entries
	 * @param remove true if to remove data; otherwise insert
	 *
	 */
	public accc_QueableBigObjects(List<SObject> sentries, boolean remove) {
		super(sentries, remove);
		super.isBigObject = true;
	}// end ctor

	
	/////////////////////////////////////////////////////////////////////////
	// Private Methods
	/////////////////////////////////////////////////////////////////////////
	@TestVisible
	private static List<Database.SaveResult> getTestResultsForBigObject() {
		List<Database.SaveResult> results = null;
		if ( Test.isRunningTest() ) {
			// SIMULATING RESULTS
			results = new  List<Database.SaveResult> {
				(Database.SaveResult)JSON.deserialize('{"id":"000000000000000AAA","success":true,"errors":[]}', Database.SaveResult.class),
				(Database.SaveResult)JSON.deserialize('{"id":"000000000000000BAA","success":true,"errors":[]}', Database.SaveResult.class),
				(Database.SaveResult)JSON.deserialize('{"id":"000000000000000CAA","success":true,"errors":[]}', Database.SaveResult.class)

			};
		}
		return results;

	}// end of getTestResultsForBigObject

} // end of accc_QueableBigObjects