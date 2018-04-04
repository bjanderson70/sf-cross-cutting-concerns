/**
 * Copyright (c) 2016-2018, Bill Anderson. All rights reserved.
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
 * @description default logger uses the system debug, error, warn, info, etc.
 *     The default logging level is DEBUG. This is the default logger used by 'ApexRunEnvironmentSingleton'.
 *     In addition to this Logger, there are three other loggers, which inherit the base behavior :
 *
 *     * ApexObjectLogger       - writes logging data to the custom object ApplicationLog__c
 *     * ApexPublishEventLogger - publishes a Log__e event (there is a sample trigger to catch and write to ApplicationLog__c)
 *     * ApexNoOpLogger         - does not write anything
 *
 * @group Common Layer
 */
global virtual without sharing class accc_ApexLogger implements accc_ILogger {

    ////////////////////////////////////////////////////////////////////////////////
    /// Data Members
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description Holds the Log Informaiton (class name, method name, stacktrace, line number)
     */
    @TestVisible
    protected accc_ApexLogDataModel dataModel = null;

    /**
     * @description Last message written
     */
    @TestVisible
    private String theLastMessage = null;

    /**
     * @description  log level to use for 'write' (default is INFO)
     */
    @TestVisible
    private LoggingLevel theLevel;
    /**
     * @description the log formatter
     */
    @TestVisible
    private final static accc_IDataFormat logFormatter = new accc_ApexLogFormatter();


    ////////////////////////////////////////////////////////////////////////////////
    /// Ctors
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description default ctor of Apex Logger -- set the LoggingLevel to INFO
     *
     */
    public accc_ApexLogger() {
        this(LoggingLevel.INFO);
    } // end of ctor

    /**
     *
     * @description ctor of Apex Logger
     *
     * @param level LoggingLevel to use for 'write'
     */
    public accc_ApexLogger(LoggingLevel level) {
        this.logLevel(level);
    } // end of ctor

    ////////////////////////////////////////////////////////////////////////////////
    ///  Public Methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description  last written message
     */
    public String lastMessage() {
        return this.theLastMessage;
    } // end of lastMessage
    /**
     * @description write out message to sink based on the  log level setting
     *
     * @param Object msg to write
     */
    public void write(Object msg) {
        this.dataModel = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(this.logLevel(), accc_ApexLogger.logFormatter.format(msg , this.dataModel));
    } // end of write
    /**
     * @description write out messages to sink based on the  log level setting
     *
     * @param msgs Objects to write
     */
    public void write(List<Object> msgs) {
        this.dataModel = new accc_ApexLogDataModel( new DmlException().getStackTraceString());
        this.write(this.logLevel(), msgs);
    } // end of write
    /**
     * @description info log level
     *
     * @param Object msg to write
     */
    public void info(Object msg) {
        this.dataModel = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(LoggingLevel.INFO, accc_ApexLogger.logFormatter.format(msg , this.dataModel));

    } // end of info

    /**
     * @description debug log level
     *
     * @param Object msg to write
     */
    public void debug(Object msg) {
        this.dataModel = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(LoggingLevel.DEBUG, accc_ApexLogger.logFormatter.format(msg , this.dataModel));
    } // end of debug

    /**
     * @description warn log level
     *
     * @param Object msg to write
     */
    public void warn(Object msg) {
        this.dataModel  = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(LoggingLevel.WARN, accc_ApexLogger.logFormatter.format(msg, this.dataModel));
    } // end of warn

    /**
     * @description error log level
     *
     * @param Object msg to write
     */
    public void error(Object msg) {
        this.dataModel = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(LoggingLevel.ERROR, accc_ApexLogger.logFormatter.format(msg, this.dataModel));
    } // end of error

    /**
     * @description fine log level
     *
     * @param Object msg to write
     */
    public void fine(Object msg) {
        this.dataModel  = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(LoggingLevel.FINE, accc_ApexLogger.logFormatter.format(msg, this.dataModel));
    } // end of fine

    /**
     * @description fine log level
     *
     * @param Object msg to write
     */
    public void finer(Object msg) {
        this.dataModel  = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(LoggingLevel.FINER, accc_ApexLogger.logFormatter.format(msg, this.dataModel));
    } // end of finer

    /**
     * @description finest log level
     *
     * @param Object to write
     */
    public void finest(Object msg) {
        this.dataModel  = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(LoggingLevel.FINEST, accc_ApexLogger.logFormatter.format(msg, this.dataModel));
    } // end of finest

    /**
     * @description get the current logging level
     * @return LoggingLevel
     */
    public LoggingLevel logLevel() {
        return this.theLevel;
    } // end of logLevel

    /**
     * @description set the current logging level
     *
     * @param LoggingLevel LoggingLevel
     */
    public void logLevel(LoggingLevel level) {
        this.theLevel = level;
    } // end of logLevel

    ////////////////////////////////////////////////////////////////////////////////
    /// Protected methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description write message
     *
     * @param LoggingLevel log-level
     * @param String the message
     */
    @TestVisible
    protected virtual void write(LoggingLevel level, Object message) {
        this.write(level, message, true);
    } // end of write
    /**
     * @description write messages
     *
     * @param LoggingLevel log-level
     * @param String the messages
     */
    @TestVisible
    protected virtual void write(LoggingLevel level, List<Object> messages) {
        if ( messages != null ) {
            integer sz = messages.size();
            for (integer inx = 0; inx < sz; inx++) {
                this.write(level, messages[inx], true);
            }
        }
    } // end of write
    /**
     * @description write message
     *
     * @param LoggingLevel log-level
     * @param String the message
     * @param boolean, true it write to the debug log
     */
    @TestVisible
    protected virtual void write(LoggingLevel level, Object message, boolean sendToLogger) {
        // toString returns a '' value if null
        String result = accc_ApexUtilities.toString(message);

        // remember last value
        this.setLastMessage(level, result);
        // print out to debug log, if any
        if ( sendToLogger && !String.isBlank(result) ) {
            // information is logged internally or controlled by sys-admin
            // write it
            system.debug(level, result);
        }
       
    } // end of write
    /**
     * @description write message
     *
     * @param LoggingLevel log-level
     * @param String the message
     * @param boolean, true it write to the debug log
     */
    @TestVisible
    protected virtual void write(LoggingLevel level, List<Object> messages, boolean sendToLogger) {

        // sending to the logger
        if ( sendToLogger && messages != null) {
            List<String> msgs = new List<String>();
            integer sz = messages.size();
            // iterate over the messages
            for (integer inx = 0; inx < sz; inx++) {
                // format it
                msgs.add((String)accc_ApexLogger.logFormatter.format( messages[inx], this.dataModel));
            }
            // write once
            this.write(level, String.join(msgs, '\n'), sendToLogger);
        }
    } // end of write
    /**
     * @description Last written message
     *
     * @param LoggingLevel LoggingLevel
     * @param String the message
     */
    @TestVisible
    protected virtual void setLastMessage(LoggingLevel level, String message) {
        String msg = message != null ? message : accc_ApexConstants.EmptyString;
        this.theLastMessage = String.format('{0} : {1}', new String[] { String.valueOf(level), msg });
    } // end of setLastMessage


} // end of accc_ApexLogger