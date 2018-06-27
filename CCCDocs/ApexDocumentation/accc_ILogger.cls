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
 * @description Each debug level includes one of the following log levels for each log category. The levels are listed from lowest to highest.
 * Specific events are logged based on the combination of category and levels. Most events start being logged at the INFO level. The level is cumulative,
 * that is, if you select FINE, the log also includes all events logged at the DEBUG, INFO, WARN, and ERROR levels.
 * @group Common Interface Layer
 */
public virtual interface accc_ILogger {

    /**
     * @description  last written message
     */
    String lastMessage();
    /**
    * @description trace message behaves like a write,but only if trace flag is on
    *
    * @param msg Object to write
    */
    void trace(Object msg);
    /**
    * @description trace messages behaves like a write,but only if trace flag is on
    *
    * @param msg Objects to write
    */
    void trace(List<Object> msg);
    /**
    * @description write out message to sink based on the  log level setting
    *
    * @param msg Object to write
    */
    void write(Object msg);
    /**
    * @description write out messages to sink based on the  log level setting
    *
    * @param msg Objects to write
    */
    void write(List<Object> msg);
    /**
    * @description info log level
    *
    * @param msg Object to write
    */
    void info(Object msg);

    /**
    * @description debug log level
    *
    * @param msg Object to write
    */
    void debug(Object msg);

    /**
    * @description warn log level
    *
    * @param msg Object to write
    */
    void warn(Object msg);

    /**
    * @description error log level
    *
    * @param msg Object to write
    */
    void error(Object msg);

    /**
    * @description fine log level
    *
    * @param msg Object to write
    */
    void fine(Object msg);
    /**
    * @description finer log level
    *
    * @param msg Object to write
    */
    void finer(Object msg);
    /**
    * @description finest log level
    *
    * @param msg Object to write
    */
    void finest(Object msg);
    /**
     * @description get the current logging level
     * @return LoggingLevel
     */
    LoggingLevel logLevel();
    /**
    * @description set the current logging level
    *
    * @param level LoggingLevel
    */
    void logLevel(LoggingLevel level);

} // end of accc_ILogger