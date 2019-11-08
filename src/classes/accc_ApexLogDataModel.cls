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
 * @description The data captured when you 'write' to the logger
 * @group Log Aspects
 */
global without sharing class accc_ApexLogDataModel {

    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Public Data Members
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    /**
     * Data we capture at log time
     *
     */
    public string className,
           methodName,
           lineNumber,
           stackTrace;
    public LoggingLevel logLevel;
    public long startTime;
    public boolean isCrossCutting;
    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Ctor
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    /**
    * @description default ctor
    *
    */
    public accc_ApexLogDataModel() {
        this(null, null, null, null, LoggingLevel.DEBUG, System.currentTimeMillis());
    } // end of ctor
    /**
    * @description ctor
    *
    * @param trace stack trace
    *
    */
    public accc_ApexLogDataModel( string trace) {
        this(trace, null, null, null, LoggingLevel.DEBUG, System.currentTimeMillis());
    } // end of ctor
    /**
    * @description ctor
    *
    * @param LoggingLevel log level
    *
    */
    public accc_ApexLogDataModel(  LoggingLevel lvl) {
        this(null, null, null, null, lvl, System.currentTimeMillis());
    } // end of ctor
    /**
    * @description ctor
    *
    * @param trace stack trace
    * @param LoggingLevel log level
    *
    */
    public accc_ApexLogDataModel( string trace, LoggingLevel lvl) {
        this(trace, null, null, null, lvl, System.currentTimeMillis());
    } // end of ctor
    /**
    * @description ctor
    *
    * @param trace stack trace
    * @param LoggingLevel log level
    * @param startTime in Millseconds
    *
    */
    public accc_ApexLogDataModel( string trace, LoggingLevel lvl, long startTime) {
        this(trace, null, null, null, lvl, startTime);
    } // end of ctor
    /**
     * @description ctor
     *
     * @param trace stack trace
     * @param clsname class name
     * @param mthname method name
     * @param lineno line number
     * @param LoggingLevel log level
     * @param startTime in Millseconds
     *
     */
    public accc_ApexLogDataModel( string trace, string clsname, string mthname, string lineno, LoggingLevel lvl, long startTime) {
        this.initialize(trace, clsname, mthname, lineno, lvl, startTime);
    } // end of ctor

    /**
     * @description initialize the data
     *
     * @param trace stack trace
     * @param clsname class name
     * @param mthname method name
     * @param lineno line number
     * @param LoggingLevel log level
     * @param startTime in Millseconds
     */
    private void initialize(string strace, string clsname, string mthname, string lineno, LoggingLevel lvl, long startTime) {
        this.stackTrace = accc_Apexutilities.normalizeString(strace);
        this.className =  accc_Apexutilities.normalizeString(clsname);
        this.methodName = accc_Apexutilities.normalizeString(mthname);
        this.lineNumber =  accc_Apexutilities.normalizeString(lineno);
        this.logLevel = lvl;
        this.startTime = startTime;
        this.isCrossCutting = false;
 
        if ( !string.isBlank(this.stackTrace) ) {
            // pop the exception stack, to get the true callee
            String trace = accc_ApexUtilities.popStack(this.stackTrace);

            this.className = accc_ApexUtilities.getExecutingClassName(trace);
            this.methodName = accc_ApexUtilities.getExecutingMethod(trace);
            this.lineNumber = accc_ApexUtilities.getExecutingLineNumber(trace);
            this.isCrossCutting = this.className.startsWithIgnoreCase('accc_');
        }
      
    }// end of initialize

} // end of accc_ApexLogDataModel