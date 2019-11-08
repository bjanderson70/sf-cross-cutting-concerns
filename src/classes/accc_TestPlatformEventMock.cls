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
 * @description common Platform Event Stub Provider
 *
 *  Provider is invoked as follows (assuming bubba__e is a created platform event:
 *  
 *      SObject event = new bubba__e();
 *		accc_PlatformEventTestServiceHelper mockPE = (accc_PlatformEventTestServiceHelper)accc_MockPlatformEventServiceUtil.createMock(accc_PlatformEventTestServiceHelper.class);
 *	 
 *		System.assertEquals(true, mockPE.publish(event).successful);
 *		System.assertEquals(false,mockPE.publish((List<SObject>)null).successful);
 *  
 *  NOTE: Success if based on the published event ( from SaveResult) as well as any errors
 *  returned from the subscriber
 *  
 *  Mocking/Sub -- https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_stub_api.htm
 *
 * @group Test Layer
 */
@isTest
public class accc_TestPlatformEventMock implements System.StubProvider {


	accc_PlatformEventTestServiceHelper.PlatformEventResults results = null;
	/**
	 * @description stub to handle publishing platform event
	 * 
	 * @param stubbedObject object stubbed
	 * @param stubbedMethodName method stubed
	 * @param returnType return results
	 * @param listOfArgs passed in user arguments
	 * @return the results of the platform event 'PlatformEventTestServiceHelper.PlatformEventResults'
	 */
	public Object handleMethodCall(Object stubbedObject,
	                               String stubbedMethodName,
	                               Type returnType,
	                               List<Type> listOfParamTypes,
	                               List<String> listOfParamNames,
	                               List<Object> listOfArgs) {

		Boolean isList = listOfArgs[0] instanceof List<SObject>;
		List<SObject> records = null;
		// check the data and determine list or sobject; otherwise, null
		if ( isList ) {
			records = (List<SObject> ) listOfArgs[0];
		} else if ( listOfArgs[0] != null ) {
			records = new List<SObject> {(SObject)listOfArgs[0] };
		}


		//++++++++++++++++++++++++++++[START] Additional Information (if wanted) +++++++++++++++++++++++++++
		// The following debug statements show an example of logging
		// the invocation of a mocked method.

		// You can use the method name and return type to determine which method was called.
		//System.debug('+++Name of stubbed method: ' + stubbedMethodName);
		//System.debug('+++Return type of stubbed method: ' + returnType.getName());

		// You can also use the parameter names and types to determine which method
		// was called.
		//for (integer i = 0; i < listOfParamNames.size(); i++) {
		//	System.debug('+++ parameter name: ' + listOfParamNames.get(i));
		//	System.debug('+++ parameter type: ' + listOfParamTypes.get(i).getName());

		//}

		// This shows the actual parameter values passed into the stubbed method at runtime.
		//System.debug('+++ number of parameters passed into the mocked call: ' + listOfArgs.size());
		//System.debug('+++ parameter(s) sent into the mocked call: ' + listOfArgs);
		//++++++++++++++++++++++++++++[END] Additional Information (if wanted) +++++++++++++++++++++++++++

		if ( stubbedObject instanceof accc_PlatformEventTestServiceHelper) {
			accc_PlatformEventTestServiceHelper helper = new accc_PlatformEventTestServiceHelper();
			results = helper.publish(records);
		}

		return results;
	} // end of handleMethodCall

}// end of accc_TestPlatformEventMock