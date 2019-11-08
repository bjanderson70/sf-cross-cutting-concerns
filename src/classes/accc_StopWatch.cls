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
 * @description Used to clock time; very rudimentary/simple encapsulation
 * @group Common Layer
 */
public without sharing class accc_StopWatch {

	/////////////////////////////////////////////////////////////////////////
	// Properties
	/////////////////////////////////////////////////////////////////////////
	public long startTime {get; private set;}

	/////////////////////////////////////////////////////////////////////////
	// ctors
	/////////////////////////////////////////////////////////////////////////
	/**
	 * @description ctor
	 */
	public accc_StopWatch() {
		this.start();
	} // end of ctor

	/////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////
	/**
	 * @description set start time, returning value
	 * @return long, current time
	 */
	public long start() {
		this.startTime = System.currentTimeMillis();
		return this.startTime;
	} // end of start
	/**
	 * @description get the duration time, returning time since last start or ctor
	 * @return long, current time
	 */
	public long getDuration() {
		return System.currentTimeMillis() - this.startTime;
	}// end of getDuration
	/**
	 * @description reset the time to System.currentTimeMillis()
	 */
	public void reset() {
		this.startTime = System.currentTimeMillis();
	} // end of reset
	/**
	 * @description string version of the duration time
	 * @return string version of the duration time
	 */
	public override String toString() {
		return string.valueOf(this.getDuration()) + 'ms';
	}// end of toString
	/**
	* @description string version of the time
	* @param long the duration time
	* @return string version of the time
	*/
	public String toString(long value) {
		return string.valueOf(value) + 'ms';
	} // end of toString

} // end of accc_StopWatch