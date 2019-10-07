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
 * @description common Platform Event Helper ensuring the event is published along with
 * encapsulating required actions pre/post. Will also ensure it is re-entrant (i.e. mock can be called multiple
 * times within the test).
 *
 *  Provider is invoked as follows (assuming bubba__e is a created platform event:
 *
 *      List<SObject> events = accc_SendPlatformEventNotificationTest.createBubbaEvents(100);
 *		accc_PlatformEventTestServiceHelper mockPE = (accc_PlatformEventTestServiceHelper)accc_MockPlatformEventServiceUtil.createMock(accc_PlatformEventTestServiceHelper.class);
 *
 *		System.assertEquals(true, mockPE.publish(events).successful);
 *		System.assertEquals(false,mockPE.publish((SObject)null).successful);
 *
 *  NOTE: Success if based on the published event ( from SaveResult) as well as any errors
 *  returned from the subscriber
 *
 *  Event Bus Class -- https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_System_eventbus.htm
 *  Test Platform Events -- https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/platform_event_apex_tests.htm
 *
 * @group Test Layer
 */
@isTest
public with sharing class accc_PlatformEventTestServiceHelper {
	static boolean instantiated = false;

	/*
	 * Our Test Exception
	 */
	public class PlatformEventTestException extends Exception {}

	/*
	 * Our event subscribers [DAO] (mirrors EventBusSubscriber)
	 * [see https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/sforce_api_objects_eventbussubscriber.htm]
	 */
	public class PlatformEventSubscribers {
		String externalId;
		String lastError;
		String name;
		Integer position;
		Integer retries;
		String status;
		String topic;
		String type;
		public PlatformEventSubscribers(EventBusSubscriber item) {

			this.externalId = item.ExternalId;
			this.name = item.Name;
			this.type = item.Type;
			this.topic = item.Topic;
			this.position = item.Position;
			this.status = item.Status;
			this.retries = item.Retries;
			this.lastError = item.LastError;

		}
	}
	/**
	 * @description our results [DAO]
	 *
	 */
	public class PlatformEventResults {
		public List<Database.SaveResult> saveResults;
		public List<PlatformEventSubscribers> subscribers;
		public Boolean successful = true;
		public Boolean hasSubscriber = false;
		public Exception exceptions = null;

	}
	/*
	 * Our results
	 */
	PlatformEventResults results = new PlatformEventResults();

	/**
	 * @description publish event (override as needed)
	 *
	 * @param record an event
	 * @return results of the publishing
	 */
	public  PlatformEventResults publish(SObject record) {
		if ( accc_ApexConstants.UnitTestsRunning ) {
			if ( record == null ) {
				this.results.successful = false;
				this.results.exceptions = new PlatformEventTestException('null pointer passed into publisher');
				return this.results;
			}
		}
		return this.publish(new List<SObject> {record});
	} // end of publish

	/**
	 * @description publish events (override as needed)
	 *
	 * @param records colleciton of events
	 * @return results of the publishing
	 */
	public  PlatformEventResults publish(List<SObject> records) {
		if ( accc_ApexConstants.UnitTestsRunning ) {
			try {
				if ( !instantiated ) {
					Test.startTest();
				}

				Test.enableChangeDataCapture();

				String topicName = accc_PlatformEventTestServiceHelper.getSobjectName(records);

				this.results.saveResults = EventBus.publish(records);
				// Deliver the test event before Test.stopTest()
				Test.getEventBus().deliver();
				if ( !instantiated ) {
					// publish events
					Test.stopTest();
					instantiated = true;
				}

				// get the subscribers, if any
				this.results.subscribers = this.getPublishedInformation(topicName);
				// set overall state
				accc_PlatformEventTestServiceHelper.setSuccessState(this.results);
			} catch (Exception excp) {

				this.results.exceptions = excp;
				this.results.successful = false;
			}
			return this.results;
		}
		return null;
	}// end of publish

	/**
	 * @description get our subscribers to the event topic
	 *
	 * @param topicName name of event (i.e. someevt__e)
	 * @return collection of subscribers
	 */
	private  EventBusSubscriber[]  getPublishedEvents(String topicName) {
		// Get info about all subscribers to the event
		return [SELECT ExternalId, Name, Type, Topic, Position, Status, Retries, LastError
		        FROM EventBusSubscriber WHERE Topic = :topicName];

	}// end of getPublishedEvents

	/**
	 * @description get the published event information; check status of the subscribers
	 *
	 * @param topicName our event
	 * @return colleciton of subscriber information
	 */
	private  List<PlatformEventSubscribers> getPublishedInformation (String topicName) {
		List<PlatformEventSubscribers> subscribers = new List<PlatformEventSubscribers>();
		// iterate over known subscribers ( if any)
		for ( EventBusSubscriber item : this.getPublishedEvents(topicName)) {
			// save results
			subscribers.add( new PlatformEventSubscribers(item));
			// let's check now if there were any issues publishing the event ( assuming a listener)
			if ( item.LastError != null
			        && this.results.successful ) {
				this.results.successful = false;
				this.results.exceptions = new PlatformEventTestException(item.LastError);
			}
			// if we are in the loop, we have a subscriber
			if (false == this.results.hasSubscriber ) {
				this.results.hasSubscriber = true;
			}

		}
		return subscribers;
	}// end of getPublishedInformation
	/**
	 * @description check the results of the SaveResults; set the 'succesful' state
	 *
	 * @param resultsProvided results we have
	 */
	private static void setSuccessState(PlatformEventResults resultsProvided) {

		for ( Database.SaveResult result : resultsProvided.saveResults) {
			if ( !result.isSuccess() ) {
				resultsProvided.successful = false;
				Database.Error[] errors = result.getErrors();
				resultsProvided.exceptions = new PlatformEventTestException(errors[0].getMessage());	 
				break;
			}
		}
	} // end of setSuccessState

	//+++++++++++++++++++++++++ Asumming one does not have these methods ++++++++++++++++++++++++++++
	//
	// NOTE - These methods are ONLY provided here for COMPLETENESS and are best encapsulated in another
	// Utility class!!!
	//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	/**
	*
	* @description get the name of the sobject
	*
	* @param mySobject SObject
	* @return String - name of the sobject
	*/
	public static String getSobjectName(SObject mySobject) {
		return mySobject != null ? mySobject.getsObjectType().getDescribe().getName() : '';
	} // end of getSobjectName
	/**
	 *  @description  get the Type from the SObject collection
	 *
	 * @param theSObject type we want
	 * @return System Type
	 */
	public static Type getTypeFromSObject(List<SObject> theSObject) {
		Type result = null;

		try {
			// can only assume ALL the same
			if ( theSObject != null ) {
				Schema.SObjectType sType = theSObject.getSobjectType();
				result = Type.forName(sType.getdescribe().getName());
				if ( result == null && theSObject.size() > 0) {
					sType = theSObject[0].getSobjectType();
					result = Type.forName(sType.getdescribe().getName());
				}
			}
		} catch  (Exception excp) {
			// ignored at this time
		}
		return result;
	} // end of getTypeFromSObject
	/**
	 *  @description  get the Type from the SObject
	 *
	 * @param theSObject type we want
	 * @return System Type
	 */
	public static Type getTypeFromSObject(SObject theSObject) {
		Type result = null;

		try {
			if ( theSObject != null ) {
				Schema.SObjectType sType = theSObject.getSobjectType();
				result = Type.forName(sType.getdescribe().getName());
			}

		} catch  (Exception excp) {
			// ignored at this time
		}
		return result;
	} // end of getTypeFromSObject
	/**
	*
	* @description get the name of the sobject
	*
	* @param mySobject List<SObject>
	* @return String - name of the sobject
	*/
	public static String getSobjectName(List<SObject> mySobject) {
		String result = '';
		if ( mySobject != null ) {
			Type sType = accc_PlatformEventTestServiceHelper.getTypeFromSObject(mySobject);
			if ( sType != null ) {
				result = sType.getName();
			}
		}
		return result;
	} // end of getSobjectName
}// end of accc_PlatformEventTestServiceHelper