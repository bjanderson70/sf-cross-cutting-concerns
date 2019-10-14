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
 * @description Encapsulates all behaviour logic relating to the handlers in the chain
 *
 * For more guidelines and details see
 *   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Domain_Layer
 * @group Common Trigger Layer
 **/
public virtual with sharing class accc_VirtualTriggerHandlerChain implements accc_IHandlerChain {

	////////////////////////////////////////////////////////////////////////////////
	/// Data Member
	////////////////////////////////////////////////////////////////////////////////

	// the next handler to call
	@TestVisible
	accc_ITriggerHandler m_handler = null;
	@TestVisible
	accc_IHandlerChain m_chain = null;

	////////////////////////////////////////////////////////////////////////////////
	/// Ctor
	////////////////////////////////////////////////////////////////////////////////

	/**
	 * @description ctor to define the handler in the chain
	 *
	 * @param handler trigger handler
	 */
	public accc_VirtualTriggerHandlerChain(accc_ITriggerHandler handler) {
		this.m_handler = handler;
	}// end of ctor
	////////////////////////////////////////////////////////////////////////////////
	/// Public Methods
	////////////////////////////////////////////////////////////////////////////////

	/**
	 * @description set the next link in the chain
	 *
	 * @param nextInChain accc_IHandlerChain
	 */
	public virtual void setNext(accc_IHandlerChain nextInChain) {
		this.m_chain = nextInChain;
	}// end of setNext
	/**
	* @description get the next link in the chain
	*/
	public virtual accc_IHandlerChain getNext() {
		return this.m_chain;
	}// en dof getNext
	/**
	 * @description the next handler in the chain
	 *
	 * @return accc_ITriggerHandler
	 */
	public virtual accc_ITriggerHandler getHandler() {
		return this.m_handler;
	}// end of getHandler

} // end of accc_VirtualTriggerHandlerChain