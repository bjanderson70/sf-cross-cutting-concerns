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
 * @description default logger uses the system debug, error, warn, info, etc.
 *     The default logging level is DEBUG. This logger will write information to
 *     Application Log (AcccApplicationLog__c)
 * @group Log Aspects
 */
global virtual without sharing class accc_ApexObjectLogger extends accc_ApexLogger {

    // pass information to the logger -- will only use one; if needed, instantiate when used TBD
    final static accc_ApplicationLog theAppLog = new accc_ApplicationLog();
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //
    // CTORS
    ///////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @description default ctor of accc_ApexObjectLogger -- set the LoggingLevel to DEBUG
     */
    public accc_ApexObjectLogger() {
        super(accc_ApexUtilities.logLevel());
    } // end of ctor

    /**
     * @description ctor of ApexObject Logger
     *
     * @param level LoggingLevel to use for 'write'
     */
    public accc_ApexObjectLogger(LoggingLevel level) {
        super(level);
    } // end of ctor

    ////////////////////////////////////////////////////////////////////////////////
    /// Protected methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * @description get the Apex Object Logger; for children
     *
     */
    @TestVisible
    protected virtual accc_ApplicationLog theObjectLogger() {
        return accc_ApexObjectLogger.theAppLog;
    }// end of theObjectLogger


    /**
     *
     * @description write message
     *
     * @param level log-level
     * @param message the message
     */
    @TestVisible
    protected override void write(LoggingLevel level, Object message) {
        this.write(level, message, true);
    }
    /**
     *
     * @description write message
     *
     * @param level log-level
     * @param message the message
     * @param write to debug logger
     */
    @TestVisible
    protected override void write(LoggingLevel level, Object message, boolean sendToLogger) {

        if ( message == null ) {
            return;
        }
        this.write(level,new List<Object> { message}, sendToLogger);

    } // end of write
      /**
       *
       * @description write message
       *
       * @param LoggingLevel level log-level
       * @param List<Object> messages the messages
       * @return void
       */
    @TestVisible
    protected override void write(LoggingLevel level, List<Object> messages) {
        this.write(level, messages, true);
    }
    /**
     *
     * @description write message
     *
     * @param LoggingLevel level log-level
     * @param List<Object> messages the messages
     * @param sendToLogger, true it write to the application log
     * @return void
     */
    @TestVisible
    protected override void write(LoggingLevel level, List<Object> messages, boolean sendToLogger) {
   
        // any messsages
        if ( messages == null || messages.size() == 0 ) {
            return;
        }

        // toString returns a '' value if null
        String result = string.valueOf(messages);
        // remember last value
        this.setLastMessage(level, result);
        // write it
        this.writeOutput(level, result, sendToLogger);


    } // end of write

    /**
     * @description write output to log
     *
     * @param LoggingLevel log level
     * @param Object data output
     * @param sendToLogger, true it write to the application log
     * @return collection of AcccApplicationLog__c
     */
    @TestVisible
    protected virtual List<AcccApplicationLog__c> writeOutput(LoggingLevel level, Object result, boolean sendToLogger) {
        // no check for result being null, done in public/protected methods
        return this.writeOutput(level, new List<Object> {result}, sendToLogger);
    } // end of writeOutput
    /**
     * @description write output to log
     *
     * @param LoggingLevel log level
     * @param List<Object> data output
     * @param sendToLogger, true it write to the application log
     * @return collection of AcccApplicationLog__c
     */
    @TestVisible
    protected virtual List<AcccApplicationLog__c> writeOutput(LoggingLevel level, List<Object> result, boolean sendToLogger) {

        // check again due to inheritance on result being null;
        List<AcccApplicationLog__c> appLogs = new List<AcccApplicationLog__c>();
        integer size = result != null ? result.size() : 0;
       
        // create  log
        for ( integer inx = 0; inx < size; ++inx) {
            appLogs.add(accc_MessageTransformation.translate(level, result[inx]));
        }

        // write data to the application log object
        if ( sendToLogger
             && !this.theObjectLogger().log(appLogs) ) {
            // let parent handle it as we could not
            super.write(level, result, true);
        }
        return appLogs;

    } // end of writeOutput

    ////////////////////////////////////////////////////////////////////////////////
    /// Private methods
    ////////////////////////////////////////////////////////////////////////////////


} // end of accc_ApexObjectLogger