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
 * @description Implementation of the log formatter.
 * @group Log Aspects
 */
public virtual without sharing class accc_ApexLogFormatter implements accc_IDataFormat {

    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Public Methods
    //
    /////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @description Data to format
     *
     * @param  input data to format (message)
     * @return a formatted object
     */
    public virtual Object format(Object information) {
        return this.format(information, null);
    } // end of format
    /**
     * @description Data to format
     *
     * @param  input data to format (message)
     * @param  addtional information [accc_ApexLogDataModel]( maybe null)
     * @return a formatted object
     */
    public virtual Object format(Object information, Object misc) {
        String message = accc_ApexUtilities.toString(information);
        accc_ApexLogDataModel dataModel = (accc_ApexLogDataModel)misc;

        // need a data model (minimal information), if null then it did not
        // come from one of the ILogger classes
        if (  dataModel == null ) {
            dataModel = new accc_ApexLogDataModel(LoggingLevel.INFO);
        }
        //
        // more detail information
        //
        if ( message != null ) {
            LoggingLevel theLogLevel = dataModel.logLevel;
            //
            // Depending on the Logging Level show varying degree of information
            //
            if ( theLogLevel == LoggingLevel.ERROR ||
                    theLogLevel == LoggingLevel.INTERNAL ||
                    theLogLevel == LoggingLevel.FINEST) {
                message = this.finest(message, dataModel, theLogLevel);
            } else if ( theLogLevel == LoggingLevel.FINER) {
                message = this.finer(message, dataModel, theLogLevel);
            } else if ( theLogLevel == LoggingLevel.FINE ) {
                message = this.fine(message, dataModel, theLogLevel);
            } else if ( theLogLevel == LoggingLevel.DEBUG) {
                message = this.debug(message, dataModel, theLogLevel);
            } else {
                message = this.other(message, dataModel, theLogLevel);
            }
        }
        return message;
    } // end of format
    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Protected Methods (Virtual to allow one to override)
    //
    /////////////////////////////////////////////////////////////////////////////////////////


    /**
     * @description finest format
     *
     * @param String the message
     * @param accc_ApexLogDataModel the log data model
     * @param LoggingLevel the log level
     * @return formatted data
     */
    @TestVisible
    protected virtual  string finest(String message, accc_ApexLogDataModel dataModel, LoggingLevel theLogLevel) {
        return String.format('[{0}] [{1}] [{2}] [{3}] {4}\n [Start Time (ms)] {5} - {6} [Stack Trace] {7}', new String[] {
                                 theLogLevel.name()
                                 , dataModel.className
                                 , dataModel.methodName
                                 , dataModel.lineNumber
                                 , message
                                 , string.valueOf(dataModel.startTime)
                                 , DateTime.newInstance(dataModel.startTime).formatLong()
                                 , dataModel.stackTrace
                             });
    } // end of finest
    /**
     * @description fine format
     *
     * @param String the message
     * @param accc_ApexLogDataModel the log data model
     * @param LoggingLevel the log level
     * @return formatted data
     */
    @TestVisible
    protected virtual  string fine(String message, accc_ApexLogDataModel dataModel, LoggingLevel theLogLevel) {
        return String.format('[{0}] [{1}] [{2}] [{3}] {4}', new String[] {
                                 theLogLevel.name()
                                 , dataModel.className
                                 , dataModel.methodName
                                 , dataModel.lineNumber
                                 , message
                             });
    } // end of fine
    /**
     * @description finer format
     *
     * @param String the message
     * @param accc_ApexLogDataModel the log data model
     * @param LoggingLevel the log level
     * @return formatted data
     */
    @TestVisible
    protected virtual  string finer(String message, accc_ApexLogDataModel dataModel, LoggingLevel theLogLevel) {
        return String.format('[{0}] [{1}] [{2}] [{3}] {4}\n[Stack Trace] {5}', new String[] {
                                 theLogLevel.name()
                                 , dataModel.className
                                 , dataModel.methodName
                                 , dataModel.lineNumber
                                 , message
                                 , dataModel.stackTrace
                             });
    } // end of finer
    /**
     * @description debug format
     *
     * @param String the message
     * @param accc_ApexLogDataModel the log data model
     * @param LoggingLevel the log level
     * @return formatted data
     */
    @TestVisible
    protected virtual  string debug(String message, accc_ApexLogDataModel dataModel, LoggingLevel theLogLevel) {
        return String.format('[{0}] [{1}] [{2}] {3}', new String[] {
                                 theLogLevel.name()
                                 , dataModel.className
                                 , dataModel.methodName
                                 , message
                             });
    } // end of debug
    /**
     * @description default format
     *
     * @param message the message
     * @param dataModel the log data model
     * @param LoggingLevel the log level
     * @return formatted data
     */
    @TestVisible
    protected virtual  string other(String message, accc_ApexLogDataModel dataModel, LoggingLevel theLogLevel) {
        return String.format('[{0}] {1}', new String[] {
                                 theLogLevel.name()
                                 , message
                             });
    } // end of other
} // end of accc_ApexLogFormatter