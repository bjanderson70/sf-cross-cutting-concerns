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
 * @description Implementation of the exception handler. This could be logging the exception thru various channels and/or returning
 * a more secure exception.
 * @group Exception Handling
 */
public virtual without sharing class accc_ApexExceptionHandler implements accc_IApexExceptionHandler {

    /*---------------------------------------------------------------------------------------
    * DATA MEMBERS
    *---------------------------------------------------------------------------------------
    **/

    /**
     * @description handles the logger diferently (normally, forces output to system.debug)
     */
    @TestVisible
    boolean handlingLoggingWithCare = false;

    /**
     * @description send to the log -- specifically for 'handlingLoggingWithCare'
     */
    @TestVisible
    static accc_ILogger logger = null;

    ////////////////////////////////////////////////////////////////////////////////
    /// Public Methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
    * @description Process the exception (defaults to Global policy)
    *
    * @param excp  Exception
    */
    public virtual void process(Exception excp) {
        this.process(excp, accc_ApexExceptionPolicyEnum.Top);
    } // end of process
    /**
    * @description Process the exception (w/ special handling of the data logged)
    *
    * @param Exception
    * @param Boolean handle Log Output Carefully
    */
    public virtual void process(Exception excp, boolean handleLogOutputCarefully) {
        this.process(excp, accc_ApexExceptionPolicyEnum.Top, true, handleLogOutputCarefully);
    } // end of process
    //
    // Process the exception and the associate policy
    //
    public virtual void process(Exception excp, accc_ApexExceptionPolicyEnum policy) {
        this.process(excp, policy, true, false);
    } // end of process

    /**
    * @description Process the exception and the associate policy
    * @param excp Exception
    * @param policy accc_ApexExceptionPolicyEnum
    */
    public virtual void process(Exception excp, accc_ApexExceptionPolicyEnum policy, Boolean logException) {
        this.process(excp, policy, logException, false);
    } // end of process

    /**
    * @description rethrow the exception less revealing
    * @param excp Exception
    */
    public virtual Exception rethrow(Exception excp) {
        return this.rethrow(excp, accc_ApexExceptionPolicyEnum.Top);
    } // end of rethrow

    /**
    * @description rethrow the exception less revealing
    * @param excp Exception
    * @param policy accc_ApexExceptionPolicyEnum
    */
    public virtual Exception rethrow(Exception excp, accc_ApexExceptionPolicyEnum policy) {
        Exception returned = excp;
        // do the normal processing of the exception
        this.process(excp, policy);
        // get the rethrow exception, if any
        try {
            accc_IApexExceptionPolicyStrategy policyStrategy = (accc_IApexExceptionPolicyStrategy)accc_ApexRunEnvironmentSingleton.getInstance().objectFactory().create(accc_ApexConstants.ExceptionPolicyHandler);
            // what to do with an exception, translate it or returned null [meaning no need to rethrow]
            returned = policyStrategy.rethrow( excp, policy);
        } catch (Exception iexcp) {
            this.handleException(iexcp);
        }

        return returned;
    } // end of rethrow

    ////////////////////////////////////////////////////////////////////////////////
    /// Protected Methods (can be overridden by child)
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description process the exception
     * @param Exception the exception
     * @param accc_ApexExceptionPolicyEnum policy layer
     * @param Boolean log Exception
     * @param Boolean handle Carefully , if true
     */
    @TestVisible
    protected virtual void process(Exception excp, accc_ApexExceptionPolicyEnum policy, Boolean logException, boolean handleCarefully) {
        Boolean previous = this.handlingLoggingWithCare;
        // handle information appropriatel (if true)
        this.handlingLoggingWithCare = handleCarefully;
        if ( logException ) {
            // just log the exception. For more elaborate strategy, call 'rethrow'
            this.performDefineSteps(excp, policy);
        }
        this.handlingLoggingWithCare = previous;
    } // end of process
    /**
     * @description write exception to the logger
     * @param excp the  exception
     */
    @TestVisible
    protected virtual void performDefineSteps(Exception excp, accc_ApexExceptionPolicyEnum policy) {
        // just log the exception. For more elaborate strategy, call 'rethrow'
        this.writeExceptionToLogger(excp, policy);
        // now notify personnel (if overridden)
        this.notifyAppropriatePersonnel(excp);
    } // end of performDefineSteps

    /**
     * @description write exception to the logger
     * @param excp the  exception
     */
    @TestVisible
    protected virtual void writeExceptionToLogger(Exception excp, accc_ApexExceptionPolicyEnum policy) {
        if ( excp != null ) {
            final string mesg = this.formatExceptionMessage(excp, policy);
            this.getLogger().error(mesg);
        }
    } // end of writeExceptionToLogger
    /**
     * @description notify appropriate users
     * @param excp the exception
     */
    @TestVisible
    protected virtual void notifyAppropriatePersonnel(Exception excp) {
        // defined by the child
    } // end of notifyAppropriatePersonnel

    /**
     * @description format the exception message
     * @param excp the thrown exception
     * @param policy policy of the exception
     *
     * @return String. Formatted string to output
     */
    @TestVisible
    protected virtual String formatExceptionMessage(Exception excp, accc_ApexExceptionPolicyEnum policy) {
        String message = accc_ApexConstants.EmptyString;
        accc_IDataFormat formatter = this.getDataFormatter();

        try {
            message = (String)formatter.format( excp, policy);
        } catch (Exception iexcp) {
            this.handleException(iexcp);
        }

        return message;
    } // end of formatExceptionMessage
    ////////////////////////////////////////////////////////////////////////////////
    /// Private Methods
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description handle the exception appropriately
     * @param Exception we chose not to ignore
     * @return void
     */
    @TestVisible
    private void handleException(Exception excp) {
        // send to the debug log
        this.getLogger().error(excp.getMessage());
    } // end of handleException

    /**
     * @description get the logger
     * @return accc_ILogger, will return accc_ApexLogger if special
     */
    @TestVisible
    private accc_ILogger getLogger() {
        accc_ILogger logger =  null;
        try {
            if ( this.handlingLoggingWithCare == false ) {
                logger = accc_ApexRunEnvironmentSingleton.getInstance().logger();
            } else {
                logger = this.systemDebugLogger();
            }
        } catch (Exception excp) {
            logger = this.systemDebugLogger();
        }
        return logger;
    } // end of getLogger


    /**
     * @description get the data formatter
     * @return accc_IDataFormat, will return accc_ExceptionFormatter if special
     */
    @TestVisible
    private accc_IDataFormat getDataFormatter() {
        accc_IDataFormat formatter = null;

        try {
            if ( this.handlingLoggingWithCare == false ) {
                formatter = (accc_IDataFormat)accc_ApexRunEnvironmentSingleton.getInstance().objectFactory().create(accc_ApexConstants.ExceptionFormatter);
            } else {
                formatter = new accc_ExceptionFormatter();
            }
        } catch (Exception iexcp) {
            formatter = new accc_ExceptionFormatter();
        }
        return formatter;
    } // end of getDataFormatter
    /**
     * @description handle the exception appropriately
     * @param Exception we chose not to ignore
     * @return accc_ILogger debug logger
     */
    @TestVisible
    private accc_ILogger systemDebugLogger() {

        // send to the debug log
        if ( accc_ApexExceptionHandler.logger == null ) {
            // explicitly using the Apex Logger bec/ it writes
            // to the system.debug ; do not want to get into a loop
            // on exception handling -- [Fallback resource -- TBD]
            accc_ApexExceptionHandler.logger = new accc_ApexLogger(LoggingLevel.ERROR);
        }
        return accc_ApexExceptionHandler.logger;
    } // end of systemDebugLogger

} // end of accc_ApexExceptionHandler