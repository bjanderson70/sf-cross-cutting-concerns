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
 *
 * @author Bill Anderson
 * @description  Translate messages from one type to another
 * @group Common Layer
 */
public without sharing class accc_MessageTransformation {

    /**
     * @description translate a ApplicationLog to a accc_Log__e
     *
     * @param appLog Application Log
     * @return accc_Log__e
     */
    public static accc_Log__e translate(ApplicationLog__c datum) {
        accc_Log__e result = null;

        if ( datum != null ) {
            result = new accc_Log__e(LogCode__c = string.valueOf(datum.LogCode__c),
                                Message__c = accc_MessageTransformation.mergeApplicationLogData(datum),
                                Username__c = UserInfo.getUserId());
        }
        return result;

    } // end of translate
    /**
     * @description translate a log record into an ApplicationLog__c
     *
     * @param LoggingLevel logging level
     * @param Object the message
     * @return ApplicationLog__c
     */
    public static ApplicationLog__c translate(LoggingLevel level, Object message) {
        ApplicationLog__c result = null;

        if ( message != null ) {
            result = new ApplicationLog__c(LogCode__c = string.valueOf(level),
                                           DebugLevel__c = level.name(),
                                           Message__c =  string.valueOf(message),
                                           Source__c = 'ApplicationLog__c',
                                           OwnerId = UserInfo.getUserId(),
                                           Username__c = UserInfo.getUserId());
        }
        return result;
    } // end of translate

    /**
     * @description translate a log record into an ApplicationLog__c
     *
     * @param LoggingLevel logging level
     * @param List<Object> the messages
     * @return List<ApplicationLog__c>
     */
    public static List<ApplicationLog__c> translate(LoggingLevel level, List<Object> messages) {
        List<ApplicationLog__c> result = null;
        ApplicationLog__c item = null;

        if ( messages != null && messages.size() > 0) {
            result = new List<ApplicationLog__c> ();
            for ( integer inx = 0; inx < messages.size(); inx++) {
                item = accc_MessageTransformation.translate(level, messages[inx]);
                if ( item != null ) {
                    result.add(item);
                }
            }
        }
        return result;
    } // end of translate

    /**
     * @description translate a ApplicationLog to a accc_Log__e
     *
     * @param appLog Application Log
     * @return accc_Log__e
     */
    public static List<accc_Log__e> translate(List<ApplicationLog__c> listDatum) {
        List<accc_Log__e> result = null;

        if ( listDatum != null && listDatum.size() > 0) {
            accc_Log__e elog;
            result = new List<accc_Log__e>();
            for (ApplicationLog__c datum : listDatum) {
                elog = accc_MessageTransformation.translate(datum);
                if ( elog != null) {
                    result.add(elog);
                }
            }
        }
        return result;

    } // end of translate

    /**
     * @description translate a accc_Log__e to a ApplicationLog__c
     *
     * @param eLog accc_Log__e
     * @return ApplicationLog__c
     */
    public static ApplicationLog__c translate(accc_Log__e datum) {
        ApplicationLog__c result = null;

        if ( datum != null ) {
            result = new ApplicationLog__c(LogCode__c = string.valueOf(datum.LogCode__c),
                                           Message__c =  string.valueOf(datum.Message__c),
                                           Source__c = 'Log Platform Event',
                                           OwnerId = UserInfo.getUserId(),
                                           Username__c = UserInfo.getUserId());
        }
        return result;

    } // end of translate
    /**
     * @description translate a accc_Log__e to a ApplicationLog__c
     *
     * @param List<accc_Log__e> list of log events
     * @return List<ApplicationLog__c> list of applicationLog
     */
    public static List<ApplicationLog__c> translate(List<accc_Log__e> listDatum) {
        List<ApplicationLog__c> result = null;

        if ( listDatum != null && listDatum.size() > 0 ) {
            ApplicationLog__c appLog;
            result = new List<ApplicationLog__c>();
            for (accc_Log__e datum : listDatum ) {
                appLog = accc_MessageTransformation.translate(datum);
                if ( appLog != null) {
                    result.add(appLog);
                }
            }
        }
        return result;

    } // end of translate
    /**
     * @description  merge all fields into a single string for consumption
     *
     * @param ApplicationLog__c the application log
     * @return string, merge data of ApplicationLog
     */
    public static string mergeApplicationLogData(ApplicationLog__c datum) {
        String result = '';
        String placeholder = 'User Role Id: {0}\n,Debug Level: {1},\nMessage: {2},\nException: {3},\nIntegration Payload: {4},\nProfile Id: {5},\nReference Id: {6},\nReference Info: {7},\nSource: {8},\nSource Function: {9},\nStack Trace: {10}\nStatistics: {11}\n';

        if ( datum != null ) {
            List<String> fillers = new List<String> {
                datum.UserRoleId__c
                , datum.DebugLevel__c
                , datum.Message__c
                , datum.Exception__c
                , datum.IntegrationPayload__c
                , datum.InvocationType__c
                , datum.profileId__c
                , datum.ReferenceId__c
                , datum.ReferenceInfo__c
                , datum.Source__c
                , datum.SourceFunction__c
                , datum.StackTrace__c
                , datum.Statistics__c
            };

            result = String.format(placeholder, fillers);
        }
        return result;

    } // end of mergeApplicationLogData

} // end of accc_MessageTransformation