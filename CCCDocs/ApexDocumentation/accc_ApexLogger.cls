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
 *     The default logging level is DEBUG. This is the default logger used by 'accc_ApexEnvironment.getRuntimeEnvironment()'.
 *     In addition to this Logger, there are three other loggers, which inherit the base behavior :
 *
 *     * ApexObjectLogger       - writes logging data to the custom object ApplicationLog__c
 *     * ApexPublishEventLogger - publishes a accc_Log__e event (there is a sample trigger to catch and write to ApplicationLog__c)
 *     * ApexNoOpLogger         - does not write anything
 *
 * @group Log Aspects
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
    private  accc_IDataFormat alogFormatter = null;
    /**
     * is tracing on
     */
    @TestVisible
    private Object tracingIsOn = null;

    ////////////////////////////////////////////////////////////////////////////////
    ///  Protected Properties
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description The log formatter
     *
     * @return accc_IDataFormat log formatter
     */
    protected  accc_IDataFormat logFormatter {
        get {
            if ( this.alogFormatter == null ) {
                this.alogFormatter = (accc_IDataFormat)accc_ApexEnvironment.getRuntimeEnvironment().objectFactory().create(accc_ApexConstants.LogFormatter);
            }
            return this.alogFormatter;
        }
        private set {}
    } // end of theLogFormatter
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
     * @param level LoggingLevel to use for 'write', the higher granularity the more information
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
        if ( msg != null ) {
            this.dataModel = new accc_ApexLogDataModel( new DmlException().getStackTraceString());
            this.write(this.logLevel(), this.logFormatter.format(msg , this.dataModel));
        }
    } // end of write
    /**
     * @description write out messages to sink based on the  log level setting
     *
     * @param List<Object> Objects to write
     */
    public void write(List<Object> msgs) {
        if ( msgs != null ) {
            this.dataModel = new accc_ApexLogDataModel( new DmlException().getStackTraceString());
            this.write(this.logLevel(), this.logFormatter.format(String.valueOf(msgs) , this.dataModel));
        }
    } // end of write
    /**
    * @description trace message behaves like a write,but only if trace flag is on.
    * In addition, if this is a cross-cutting type (i.e. 'accc_') and the show CC flag is off, then the trace
    * for cross-cutting data is NOT display. Why? for the system debug log, will fill at @2M and you may not want
    * to see the cross-cutting information.
    *
    * @param Object Object to write
    */
    public void trace(Object msg) {

        if ( msg != null && this.isTracingOn()  ) {
            LoggingLevel lvl = (LoggingLevel) accc_ApexEnvironment.getRuntimeEnvironment().provider().get(accc_ApexConstants.TraceLogLevel_r);
            this.dataModel = new accc_ApexLogDataModel( new DmlException().getStackTraceString(), lvl);
            
            if ( this.isTheTraceNotCCandShowAllowed() ) {
                this.write(lvl, this.logFormatter.format(msg, this.dataModel));
            }
        }
    }// end of trace
    /**
    * @description trace messages behaves like a write,but only if trace flag is on.
    * In addition, if this is a cross-cutting type (i.e. 'accc_') and the show CC flag is off, then the trace
    * for cross-cutting data is NOT display. Why? for the system debug log, will fill at @2M and you may not want
    * to see the cross-cutting information.
    * 
    * @param List<Object> Objects to write
    */
    public void trace(List<Object> msgs) {

        if (  msgs != null && this.isTracingOn() ) {
            LoggingLevel lvl = (LoggingLevel) accc_ApexEnvironment.getRuntimeEnvironment().provider().get(accc_ApexConstants.TraceLogLevel_r);
            this.dataModel = new accc_ApexLogDataModel( new DmlException().getStackTraceString(), lvl);
            string allstring = string.join(msgs, ',');

            if ( this.isTheTraceNotCCandShowAllowed() ) {
                this.write(lvl,  this.logFormatter.format(allstring, this.dataModel) ) ;
            }
        }
    } // end of trace
    /**
     * @description info log level
     *
     * @param Object msg to write
     */
    public void info(Object msg) {
        this.dataModel = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(LoggingLevel.INFO, this.logFormatter.format(msg , this.dataModel));

    } // end of info

    /**
     * @description debug log level
     *
     * @param Object msg to write
     */
    public void debug(Object msg) {
        this.dataModel = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(LoggingLevel.DEBUG, this.logFormatter.format(msg , this.dataModel));
    } // end of debug

    /**
     * @description warn log level
     *
     * @param Object msg to write
     */
    public void warn(Object msg) {
        this.dataModel  = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(LoggingLevel.WARN, this.logFormatter.format(msg, this.dataModel));
    } // end of warn

    /**
     * @description error log level
     *
     * @param Object msg to write
     */
    public void error(Object msg) {
        this.dataModel = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(LoggingLevel.ERROR, this.logFormatter.format(msg, this.dataModel));
    } // end of error

    /**
     * @description fine log level
     *
     * @param Object msg to write
     */
    public void fine(Object msg) {
        this.dataModel  = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(LoggingLevel.FINE, this.logFormatter.format(msg, this.dataModel));
    } // end of fine

    /**
     * @description fine log level
     *
     * @param Object msg to write
     */
    public void finer(Object msg) {
        this.dataModel  = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(LoggingLevel.FINER, this.logFormatter.format(msg, this.dataModel));
    } // end of finer

    /**
     * @description finest log level
     *
     * @param Object to write
     */
    public void finest(Object msg) {
        this.dataModel  = new accc_ApexLogDataModel( new DmlException().getStackTraceString());

        this.write(LoggingLevel.FINEST, this.logFormatter.format(msg, this.dataModel));
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
            string allstring = string.join(messages, ',');
            // bulk it ...  revisit - TBD
            this.write(level, allstring, true);
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
            // write it to SF Debug Log
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
                msgs.add((String)this.logFormatter.format( messages[inx], this.dataModel));
            }
            // write once
            this.write(level, String.join(msgs, accc_ApexConstants.NewLine), sendToLogger);
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
        this.theLastMessage = String.format('{0} : {1}', new String[] { level.name(), msg });
    } // end of setLastMessage

    /**
     * @description is the tracing on
     * @return trus, if tracing is on
     */
    @TestVisible
    protected boolean isTracingOn() {

        if ( this.tracingIsOn == null) {
            this.tracingIsOn = accc_ApexEnvironment.getRuntimeEnvironment().provider().get(accc_ApexConstants.TraceFlagOn_r);
        }
        return (boolean)this.tracingIsOn;

    } // end of isTracingOn

    /**
     * @description If the information is cross-cutting type and the user DOES NOT want to show the
     * cross-cutting information/trace data then return false; other true
     * @return Boolean false, is a cross-cutting concern and the user doe snot want to see the cross-cutting information
     */
    @TestVisible
    protected boolean isTheTraceNotCCandShowAllowed() {
        boolean showCCTracing = (boolean) accc_ApexEnvironment.getRuntimeEnvironment().provider().get(accc_ApexConstants.ShowCCTraceInfo_r);
        boolean result = true;

        if ( this.dataModel != null &&
                this.dataModel.isCrossCutting &&
                !showCCTracing ) {
            result = false;
        }
        return result;
    } // end of isTheTraceNotCCandShowAllowed
} // end of accc_ApexLogger