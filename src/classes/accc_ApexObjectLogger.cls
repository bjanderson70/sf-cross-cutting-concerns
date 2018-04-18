/**
 * Copyright (c) 2016-2018, Bill Anderson.  All rights reserved.
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
 *     The default logging level is DEBUG. This is logger is also wired into
 *     'ApexRunEnvironmentSingleton'. This logger will write information to
 *     Application Log (AcccApplicationLog__c)
 * @group Common Layer
 */
global without sharing class accc_ApexObjectLogger extends accc_ApexLogger {

    // pass information to the logger
    private final static accc_ApplicationLog theAppLog = new accc_ApplicationLog();
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //
    // CTORS
    ///////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @description default ctor of accc_ApexObjectLogger -- set the LoggingLevel to DEBUG
     */
    public accc_ApexObjectLogger() {
        super(LoggingLevel.DEBUG);
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
        // toString returns a '' value if null
        String result = accc_ApexUtilities.toString(message);
        // remember last value
        this.setLastMessage(level, result);

        // save, if we can
        if ( sendToLogger ) {
            // write it
            this.writeOutput(level, result);
        }

    } // end of write
    /**
      *
      * @description write message
      *
      * @param level log-level
      * @param List<Object> the messages
      * @param boolean, true it write to the application log
      */
    @TestVisible
    protected override void write(LoggingLevel level, List<Object> messages, boolean sendToLogger) {

        // any messsages
        if ( messages == null || messages.size() == 0 ) {
            return;
        }
        // toString returns a '' value if null
        String result = accc_ApexUtilities.toString(messages[ messages.size() - 1]);
        // remember last value
        this.setLastMessage(level, result);

        // save, if we can
        if ( sendToLogger ) {
            // write it
            this.writeOutput(level, result);
        }

    } // end of write
    ////////////////////////////////////////////////////////////////////////////////
    /// Private methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description write output to log
     *
     * @param LoggingLevel log level
     * @param Object data output
     */
    @TestVisible
    private void writeOutput(LoggingLevel level, Object result) {
        // no check for result being null, done in public/protected methods
        this.writeOutput(level, new List<Object> {result});
    } // end of writeOutput
    /**
     * @description write output to log
     *
     * @param LoggingLevel log level
     * @param List<Object> data output
     */
    @TestVisible
    private void writeOutput(LoggingLevel level, List<Object> result) {

        // no check for result being null, done in public/protected methods
        List<AcccApplicationLog__c> appLogs = new List<AcccApplicationLog__c>();
        integer size = result.size();

        // create and write the log
        for ( integer inx = 0; inx < size; ++inx) {
            appLogs.add(accc_MessageTransformation.translate(level, result[inx]));
        }

        // write data to the application log object
        if ( !accc_ApexObjectLogger.theAppLog.log(appLogs) ) {
            // let parent handle it as we could not
            super.write(level, result, true);
        }

    } // end of writeOutput

} // end of accc_ApexObjectLogger