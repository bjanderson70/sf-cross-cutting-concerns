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
 * @description use as a wrapper around the application log
 * @group Log Aspects
 */
public without sharing class accc_ApplicationLog {

    //////////////////////////////////////////////////////////////////////////////////////
    // Data Members
    //////////////////////////////////////////////////////////////////////////////////////

    // the text strings can only have a max. size of (unicode)
    public static final Integer MAX_TEXT_SIZE = 254;

    // record to log
    @TestVisible
    private AcccApplicationLog__c entry = null;
    // record id, if logged
    @TestVisible
    private Id entryId = null;
    // log exception
    @TestVisible
    private Exception logExcp = null;
    // number of items logged
    @TestVisible
    private integer itemsLogged = 0;

    //////////////////////////////////////////////////////////////////////////////////////
    // Ctors / Ctors Chaining
    //////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * @description default ctor
     */
    public accc_ApplicationLog() {
        this(null, null, null, null, null);

    } // end of ctor
    /**
    *
    * @description ctor (copy ctor, no automatic logging)
    * @param appLogEntry the application log
    */
    public accc_ApplicationLog(AcccApplicationLog__c appLogEntry) {
        this.entry = appLogEntry;
    }// end of ctor
    /**
     *
     * @description ctor (no automatic logging)
     * @param message the message to log
     */
    public accc_ApplicationLog(String message) {
        this( message, false);
    } // end of ctor

    /**
     *
     * @description ctor (no automatic logging)
     * @param excp The exception
     */
    public accc_ApplicationLog(Exception excp) {
        this( excp, accc_ApexConstants.Unknown, accc_ApexConstants.Unknown);
    } // end of ctor
    /**
    *
    * @description ctor (no automatic logging)
    * @param className the class name
    * @param methodName the method name
    */
    public accc_ApplicationLog(String className, String methodName) {
        this(null, className, methodName, null, null);
    } // end of ctor

    /**
     *
     * @description ctor
     * @param excp The exception
     * @param message the message to log
     * @param true to log automatically
     */
    public accc_ApplicationLog(Exception excp, String message, Boolean logIt) {
        this( excp, accc_ApexConstants.Unknown, accc_ApexConstants.Unknown, null, message, logIt);
    } // end of ctor

    /**
     *
     * @description ctor
     * @param message the message to log
     * @param true to log automatically
     */
    public accc_ApplicationLog(String message, Boolean logIt) {
        this(null, null, null, accc_ApexUtilities.newGuid(), message, logIt);
    } // end of ctor
    /**
     * @description ctor (no automatic logging))
     *
     * @param excp The exception
     * @param className the class name
     * @param methodName the method name
     */
    public accc_ApplicationLog(Exception excp
                               , String className
                               , String methodName) {
        this(excp, className, methodName, null, null);

    }// end of ctor
    /**
     * @description ctor (no automatic logging)
     *
     * @param excp The exception
     * @param className the class name
     * @param methodName the method name
     * @param referenceId reference string
     * @param referenceInfo reference context/information
     */
    public accc_ApplicationLog(Exception excp
                               , String className
                               , String methodName
                               , String referenceId
                               , String referenceInfo) {
        this(excp, className, methodName, referenceId, referenceInfo, false);
    } // end of ctor
    /**
     * @description ctor
     *
     * @param excp The exception
     * @param className the class name
     * @param methodName the method name
     * @param referenceId reference string
     * @param referenceInfo reference context/information
     * @param true to log automatically
     */
    public accc_ApplicationLog(Exception excp
                               , String className
                               , String methodName
                               , String referenceId
                               , String referenceInfo
                               , Boolean logIt) {
        this.entry = new AcccApplicationLog__c();

        this.setLogLevel(this.entry, LoggingLevel.INFO);
        this.setMesssage(referenceInfo);
        this.setUserInfo();
        this.setLimitsInfo();
        this.setInvocationInfo();
        this.setExceptionInfo(excp);
        this.setSourceInfo(className, methodName);
        this.setReference(referenceId, referenceInfo);
        // log the entry
        if ( logIt == true) {
            this.log();
        }
    } // end of ctor
    //////////////////////////////////////////////////////////////////////////////////////
    // Public Methods
    //////////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////////
    // Getters
    ////////////////////////////////////////////////////////////////////////////////////
    /**
     * @description number of entries logged after calling log()
     * @return record count
     */
    public integer entriesLogged() {
        return this.itemsLogged;
    } // end of entriesLogged
    /**
     *
     * @description log exception caught, if attempting to write to database
     * @return Exception
     */
    public Exception logException() {
        return this.logExcp;
    } // end of logException
    /**
     *
     * @description the entry id of the inserted record
     * @return Id
     */
    public Id entryIdentifier() {
        return this.entryId;
    } // end of entryIdentifier
    /**
     *
     * @description get the current application log entry
     * @return AcccApplicationLog__c
     */
    public AcccApplicationLog__c entry() {
        return this.entry;
    } // end of entry

    ////////////////////////////////////////////////////////////////////////////////////
    // Setters
    ////////////////////////////////////////////////////////////////////////////////////
    /**
     * @description st the intergration payload
     *
     * @param string payload
     */
    public void setIntegrationPayload(String payload) {
        //this.entry.IntegrationPayload__c = payload;
    } // end of setIntegrationPayload
    /**
     * @description set the resource information
     *
     * @param referenceId reference if
     * @param referenceInfo reference information
     */
    public void setReference(String referenceId, String referenceInfo) {
        //this.entry.ReferenceId__c = referenceId;
        //this.entry.ReferenceInfo__c = referenceInfo;
    } // end of setReference

    /**
     *
     * @description set the messsage
     *
     * @param message string message
     */
    public void setMesssage(String message) {
      //  this.entry.Message__c = message;
    } // end of setMessage

    ////////////////////////////////////////////////////////////////////////////////////
    // Log Methods
    ////////////////////////////////////////////////////////////////////////////////////
    /**
     *
     * @description log an application entry
     * @return true, if saved
     */
    public Boolean log() {

        return this.log(this.entry);
    } // end of log

    /**
     *
     * @description log an application entry
     *
     * @param logEntry a record in AcccApplicationLog__c
     * @return true, if logged
     */
    public Boolean log(AcccApplicationLog__c logEntry) {
        Boolean result = logEntry == null ? false : true;

        try {
            // if we have an entry, log it
            if ( result == true ) {
                // reset the previous logged exception
                this.logExcp = null;
                // now prove we added the information
                result = this.logApplicationEntries(logEntry);
            }
        } catch (Exception excp) {
            this.logExcp = excp;
        }

        // was there an exception
        if ( this.logExcp != null ) {
            this.handleExceptionResults(logEntry, LoggingLevel.ERROR, this.logExcp);
        }

        return result;
    } // end of log

    /**
     *
     * @description log an application enties
     *
     * @param logEntries a list of AcccApplicationLog__c
     * @return true, if logged
     */
    public Boolean log(List<AcccApplicationLog__c> logEntries) {
        Boolean result = logEntries == null || logEntries.size() == 0 ? false : true;

        try {
            // if we have an entry, log it
            if ( result == true ) {
                // reset the previous logged exception
                this.logExcp = null;
                // now prove we added the information
                result = this.logApplicationEntries(logEntries);
            }
        } catch (Exception excp) {
            this.logExcp = excp;
        }

        // was there an exception
        if ( this.logExcp != null ) {
            this.handleExceptionResults(logEntries, LoggingLevel.ERROR, this.logExcp);
        }

        return result;
    } // end of log
    //////////////////////////////////////////////////////////////////////////////////////
    //
    // Private Methods
    //
    //////////////////////////////////////////////////////////////////////////////////////
    /**
     *
     * @description log application entry
     *
     * @param entry Application__c
     * @return true, if inserted
     */
    @TestVisible
    private Boolean logApplicationEntries(AcccApplicationLog__c entry) {
        List<AcccApplicationLog__c> entries = new List<AcccApplicationLog__c> { entry};
        return this.logApplicationEntries(entries);
    } // end of logApplicationEntries
    /**
     *
     * @description log application entries
     *
     * @param logEntries List of Application__c
     * @return true, if inserted
     */
    @TestVisible
    private Boolean logApplicationEntries(List<AcccApplicationLog__c> logEntries) {
        Boolean result = false;
        // any work to do
        if ( logEntries == null || logEntries.size() == 0) {
            return result;
        }

        // items logged ( saved)
        this.itemsLogged = 0;
        // ensure string correctness
        this.ensureStringCorrectness(logEntries);
        accc_IApexRunEnvironment runtime = accc_ApexUtilities.getRuntimeEnvironment();

        if ( (Limits.getDMLRows() < Limits.getLimitDMLRows()) &&
                (Limits.getDMLStatements() < Limits.getLimitDMLStatements()) ) {
            List<Database.SaveResult> savedResults = null;
            // will only check the first entry id
            this.entryId = logEntries[0].Id;

            if ( this.entryId == null) {
                // insert the information
                savedResults = Database.insert(logEntries, true);
            } else {
                // someone must have insert this before as it already has an Id
                savedResults = Database.update(logEntries, true);
            }
            // set the db results
            runtime.transactionResult().databaseResult(savedResults);
            // process errors, if any; if we did not have errors, 'processErrors' returns false
            result = runtime.transactionResult().processErrors(true) == false;
            // no errors process ( atomic )
            if ( result == true) {
                this.itemsLogged = logEntries.size();
            }
        } else {
            final string dmlMsg = 'DML Limits on Application Log exceeded';
            this.logExcp = new accc_ApexApplicationException(dmlMsg);
            this.handleExceptionResults(logEntries,
                                        LoggingLevel.ERROR,
                                        new accc_ApexApplicationException(dmlMsg)
                                       );
        }
        return result;
    } // end of logApplicationEntries
    /**
     *
     * @description set the source information (class and method)
     *
     * @param className executing class
     * @param methodName executing method
     */
    @TestVisible
    private void setSourceInfo(String className, String methodName) {
        //this.entry.Source__c = className == null ? accc_ApexConstants.EmptyString : className;
        //this.entry.SourceFunction__c = methodName == null ? accc_ApexConstants.EmptyString : methodName;
    } // end of setSourceInfo
    /**
     *
     * @description set the exception information
     *
     * @param excp Exception
     */
    @TestVisible
    private void setExceptionInfo(Exception excp) {
        if (excp != null) {
            //this.entry.Exception__c = String.valueof(excp.getTypeName());
            //this.entry.LogCode__c = LoggingLevel.ERROR.name();
            //this.entry.Message__c = excp.getMessage();
            //this.entry.StackTrace__c = excp.getStackTraceString();
            //this.setLogLevel(this.entry, LoggingLevel.ERROR);
        }
    } // end of setExceptionInfo
    /**
     *
     * @description set the invocation type
     */
    @TestVisible
    private void setInvocationInfo() {
        //this.entry.InvocationType__c = 'Is Batch? ' + System.isBatch()
        //                               + ', Is Scheduled? ' + System.isScheduled()
        //                               + ', Is Future? ' + System.isFuture()
        //                               + ', Is Queueable? ' + System.isQueueable()
        //                               + ', Is Page? ' + System.currentPageReference();
    } // end of setInvocationInfo

    /**
     *
     * @description set the limits
     */
    @TestVisible
    private void setLimitsInfo() {
        String formatted = '\nAggregateQueries {0}\n, Callouts {1}\n, CpuTime {2}\n, DMLRows {3}\n, DML Statements {4}\n, HeapSize {5}\n,Queries {6}\n';
        List<String> data = new String[] {
            String.valueof(Limits.getAggregateQueries())
            , String.valueof(Limits.getCallouts())
            , String.valueof(Limits.getCpuTime())
            , String.valueof(Limits.getDMLRows())
            , String.valueof(Limits.getDMLStatements())
            , String.valueof(Limits.getHeapSize())
            , String.valueof(Limits.getQueries())
        };

       // this.entry.Statistics__c = string.format(formatted, data);
    } // end of setLimitsInfo
    /**
     *
     * @description  set user and profile information
     */
    private void setUserInfo() {
        //this.entry.Username__c = UserInfo.getUserName();
        //this.entry.profileId__c = UserInfo.getProfileId();
        //this.entry.UserRoleId__c = UserInfo.getUserRoleId();
    } // end of setUserInfo

    /**
     *
     * @description log the information
     *
     * @param item , the record
     * @param level logging level
     * @param excp the exception
     */
    @TestVisible
    private void handleExceptionResults(AcccApplicationLog__c item, LoggingLevel level, Exception excp) {

        this.setLogLevel(item, level);
        accc_ApexRunEnvironmentSingleton.getInstance().exceptionHandler().process(excp, true);

    } // end of handleExceptionResults
    /**
     *
     * @description log the information
     *
     * @param items , the records
     * @param level logging level
     * @param excp the exception
     */
    @TestVisible
    private void handleExceptionResults(List<AcccApplicationLog__c> items, LoggingLevel level, Exception excp) {
        this.handleExceptionResults(items[0], level, excp);
    } // end of handleExceptionResults
    /**
     *
     * @description  set log level of application entry
     *
     * @param entry log entry
     * @param level log level
     */
    @TestVisible
    private void setLogLevel(AcccApplicationLog__c entry, LoggingLevel level) {
        if ( entry != null ) {
           // entry.DebugLevel__c = level.name();
        }
    } // end of setLogLevel

    /**
     *
     * @description need to ensure the text fields do no exceed the MAX_TEXT_SIZE in entries
     *
     * @param entries , List<ApplicaitonLog__c>
     */
    @TestVisible
    private void ensureStringCorrectness(List<AcccApplicationLog__c> entries) {
        for (AcccApplicationLog__c entry : entries) {
            this.ensureStringCorrectness(entry);
        }
    } // end of ensureStringCorrectness

    /**
     *
     * @description need to ensure the text fields do no exceed the MAX_TEXT_SIZE
     *
     * @param entry , ApplicaitonLog__c
     */
    @TestVisible
    private void ensureStringCorrectness(AcccApplicationLog__c entry) {

        // before saving to the database
        if ( entry != null ) {

            //entry.InvocationType__c = this.correctString(entry.InvocationType__c);
            //entry.LogCode__c = this.correctString(entry.LogCode__c);
            //entry.ReferenceId__c = this.correctString(entry.ReferenceId__c);
            //entry.ReferenceInfo__c = this.correctString(entry.ReferenceInfo__c);
            //entry.SourceFunction__c = this.correctString(entry.SourceFunction__c);
            //entry.Source__c = this.correctString(entry.Source__c);
            //entry.UserRoleId__c = this.correctString(entry.UserRoleId__c);
            //entry.Username__c = this.correctString(entry.Username__c);
            //entry.profileId__c = this.correctString(entry.profileId__c);
        }
    } // end of ensureStringCorrectness
    /**
     * @description make the value empty or abbreviate appropriately
     *
     * @param  value the value to fix
     * @return value fixed string
     */
    @TestVisible
    private String correctString(String value) {
        String result = accc_ApexConstants.EmptyString;
        if ( value != null ) {
            result = value.abbreviate(MAX_TEXT_SIZE);
        }
        return result;
    }// end of correctString
} // end of accc_ApplicationLog