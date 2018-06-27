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
 * @description Holder of the last transaction operations
 * @group Common Interface Layer
 */
public virtual interface accc_IPreviousTransactionResult {

  /**
     * @description et last database result
     * @return  SaveResult
     */
    List<Database.SaveResult> databaseResult();

  /**
     * @description set last database result
     * 
     * @param result SaveResult
     */
    void databaseResult(List<Database.SaveResult> result);
    /**
      * @description process the errors from the saved results. This functionality usually means
      * wrting the information to the active logger ( as found in the factory). Bec/ we may
      * be writing to a loger (via the logger), indicated to the method to redirect output to SF debug log
      * @return boolean, true if errors were processed
      */
    boolean processErrors();
    /**
      * @description process the errors from the saved results. This functionality usually means
      * wrting the information to the active logger ( as found in the factory). Bec/ we may
      * be writing to a loger (via the logger), indicated to the method to redirect output to SF debug log
      *
      * @param boolean, true if writing to the SF debug log
      * 
      * @return boolean, true if errors were processed
      */
    boolean processErrors(boolean toSFDebugLogger);
} // end of accc_IPreviousTransactionResult