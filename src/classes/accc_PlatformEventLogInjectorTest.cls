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
 * @author Bill Anderson
 * @description Test the Platform Event Data Access Object to work on (enque to process asynchronously)
 * @group Test Layer
 */
@isTest
private class accc_PlatformEventLogInjectorTest {
    @isTest
    static void testCtoraccc_PlatformEventLogInjector() {
        // assign
        String name = 'logInfo';
        accc_PlatformEventDAOLog dao = new accc_PlatformEventDAOLog(name);
        // act
        accc_PlatformEventLogInjector ctor = new accc_PlatformEventLogInjector(dao);
        // assert
        system.assertEquals(true, ctor.m_entries.size() == 1);
    }
    @isTest
    static void testCtoraccc_PlatformEventLogInjectorWithNull() {
        // assign
        // act
        accc_PlatformEventLogInjector ctor = new accc_PlatformEventLogInjector((accc_PlatformEventDAOLog)null);
        // assert
        system.assertEquals(true, ctor.m_entries.size() == 0);
    }
    @isTest
    static void testCtoraccc_PlatformEventLogInjectorList() {
        // assign
        String name = 'logInfo';
        List<accc_PlatformEventDAOLog> daolist = new List<accc_PlatformEventDAOLog> {
            new accc_PlatformEventDAOLog(name)
        };
        // act
        accc_PlatformEventLogInjector ctor = new accc_PlatformEventLogInjector(daolist);
        // assert
        system.assertEquals(true, ctor.m_entries.size() == 1);
    }

    @isTest
    static void teststore() {
        // assign
        String name = 'logInfo';
        List<accc_PlatformEventDAOLog> daolist = new List<accc_PlatformEventDAOLog> {
            new accc_PlatformEventDAOLog(name)
        };
        Test.startTest();
        // act
        accc_PlatformEventLogInjector ctor = new accc_PlatformEventLogInjector(daolist);
        Boolean result = ctor.store();
        Test.stopTest();
        // assert
        system.assertEquals(true, result);
    }
    @isTest
    static void testremove() {
        // assign
        String name = 'logInfo';
        List<accc_PlatformEventDAOLog> daolist = new List<accc_PlatformEventDAOLog> {
            new accc_PlatformEventDAOLog(name)
        };
        Test.startTest();
        // act
        accc_PlatformEventLogInjector ctor = new accc_PlatformEventLogInjector(daolist);
        Boolean result = ctor.remove();
        Test.stopTest();
        // assert
        system.assertEquals(true, result);
    }

    @isTest
    static void testGetHandler() {
        // assign
        String name = 'logInfo';
        List<accc_PlatformEventDAOLog> daolist = new List<accc_PlatformEventDAOLog> {
            new accc_PlatformEventDAOLog(name)
        };
        
        accc_PlatformEventLogInjector ctor = new accc_PlatformEventLogInjector(daolist);
		 // act
        accc_PELogDataQueueHandler handler = ctor.getHandler(false);
        // assert
        system.assertEquals(true, handler != null);
    }

    @isTest
    static void testprocessAction() {
        // assign
        String name = 'logInfo';
        List<accc_PlatformEventDAOLog> daolist = new List<accc_PlatformEventDAOLog> {
            new accc_PlatformEventDAOLog(name)
        };
        Boolean exceptionOccurred = false;
       
        accc_PlatformEventLogInjector ctor = new accc_PlatformEventLogInjector(daolist);
        accc_PlatformEventLogInjector.mForceException = true;
        try {
			 // act
            Boolean result = ctor.processAction(false);
        } catch (Exception excp) {
            exceptionOccurred=true;
        }
        // assert
        system.assertEquals(true, exceptionOccurred);
    }
}