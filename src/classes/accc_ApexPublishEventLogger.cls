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
 * @description publishes a log event
 * @group Log Aspects
 */
public without sharing class accc_ApexPublishEventLogger  extends accc_ApexLogger {
  ///////////////////////////////////////////////////////////////////////////////////////////////
  //
  // Data Members
  ///////////////////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //
  // Protected methods
  ///////////////////////////////////////////////////////////////////////////////////////////////

  /**
   * @description write message
   *
   * @param level log-level
   * @param message the message
   */
  @TestVisible
  protected override void write(LoggingLevel level, Object message) {
    // any work
    if ( message == null) {
      return;
    }
    // write information
    this.write(level, new List<Object> {message});
  } // end of write

  /**
  * @description write messages
  *
  * @param LoggingLevel log-level
  * @param List of the messages
  */
  @TestVisible
  protected override void write(LoggingLevel level, List<Object> messages) {
    // any work
    if ( messages == null || messages.size() == 0) {
      return;
    }
    // toString returns a '' value if null
    String result = accc_ApexUtilities.toString(messages);
    // remember last value
    this.setLastMessage(level, result);
    // publish the event
    if ( !this.publishLogEvent(level, messages) ) {
      // let parent handle it
      super.write(level, messages);
    }

  } // end of write
  /**
   * @description publish the log event
   *
   * @param LoggingLevel log level
   * @param Object the log message
   *
   * @return boolean returns true if published
   */
  @TestVisible
  private boolean publishLogEvent(LoggingLevel level, Object message) {
    // any work
    if ( message == null ) {
      return false;
    }
    // publish events
    return this.publishLogEvent(level, new List<Object> {message});

  } // end of publishLogEvent
  /**
    * @description publish the log events
    *
    * @param LoggingLevel log level
    * @param List<Object> the list of messages
    *
    * @return boolean returns true if published
    */
  @TestVisible
  private boolean publishLogEvent(LoggingLevel level, List<Object> messages) {
    // any work
    if ( messages == null || messages.size() == 0) {
      return false;
    }

    accc_IPreviousTransactionResult result = accc_ApexEnvironment.getRuntimeEnvironment().transactionResult();
    String uid = UserInfo.getUserId(),
           loglvl = level.name();
    SObject logEvt = null;
    List<SObject> logEvts = new List<SObject>();

    // iterate of messages
    for (Object message : messages ) {
      logEvt = new accc_Log__e(LogCode__c = loglvl,
                               Message__c = accc_ApexUtilities.toString(message),
                               Username__c = uid);
      logEvts.add(logEvt);
    }
    this.processEvent(result, logEvts);
    // process errors, if any; if we did not have errors, 'processErrors' returns false
    return result.processErrors(true) == false;

  } // end of publishLogEvent
  /**
   * @description process the log event
   *
   * @param accc_IPreviousTransactionResult transaction processor
   * @param List<logEvt> list to publish
   */
  @TestVisible
  private void processEvent(accc_IPreviousTransactionResult result,
                            List<SObject> logEvts) {

    // Call method to publish events
    List<Database.SaveResult> savedResults =  EventBus.publish(logEvts);

    // set the results
    result.databaseResult(savedResults);

  } // end of processEvent

} // end of accc_ApexPublishEventLogger