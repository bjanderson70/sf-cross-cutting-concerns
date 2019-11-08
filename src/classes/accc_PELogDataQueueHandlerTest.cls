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
 * @description Platform Event queuable to insert or delete into/from BO
 * @group Test Layer
 */
@isTest
private class accc_PELogDataQueueHandlerTest {
    @isTest
    static void testPlatformEventLogDataQueueHandlerEnque() {
        // assign
        DateTime now = DateTime.Now();
        String name = 'my-test-pe-test-today';

        // act
        List<accc_PlatformEventDAOLog> daoList = accc_PELogDataQueueHandlerTest.getPEData();

        // startTest/stopTest block to force async processes
        //   to run in the test.
        Test.startTest();
        // act
        System.enqueueJob(new accc_PELogDataQueueHandler(daoList));
        Test.stopTest();
        // assert -- this is bogus !

        // the queueable calls database.insertImmediate which does not error out but then does not
        // add the items via Test. Thus, the class, 'accc_PELogDataQueueHandler' simulates
        // the results
        System.assertEquals(true, accc_PELogDataQueueHandler.getTestResultsForBigObject().size() > 0);

    }

    @isTest
    static void testctorWithNULLDAOList() {
        // assign
        List<accc_PlatformEventDAOLog> daoList = null;

        accc_PELogDataQueueHandler handler = new accc_PELogDataQueueHandler(daoList);

        System.assertEquals(0, handler.entries.size());
        System.assertEquals(false, handler.actions );
    }

    @isTest
    static void testctorWithNULLDAOListAndRemoval() {
        // assign
        List<accc_PlatformEventDAOLog> daoList = null;

        accc_PELogDataQueueHandler handler = new accc_PELogDataQueueHandler(daoList, true);

        System.assertEquals(0, handler.entries.size());
        System.assertEquals(true, handler.actions );
    }

    @isTest
    static void testctorWithNULLDAOListCallingExecute() {
        // assign
        List<accc_PlatformEventDAOLog> daoList = null;

        accc_PELogDataQueueHandler handler = new accc_PELogDataQueueHandler(daoList);
        handler.execute(null);
        System.assertEquals(0, handler.entries.size());
        System.assertEquals(false, handler.actions );
    }

    @isTest
    static void testctorWithDAOList() {
        // assign
        List<accc_PlatformEventDAOLog> daoList = accc_PELogDataQueueHandlerTest.getPEData();

        accc_PELogDataQueueHandler handler = new accc_PELogDataQueueHandler(daoList);

        System.assertEquals(daoList.size(), handler.entries.size());
        System.assertEquals(false, handler.actions );
    }

    @isTest
    static void testprocessWithException() {
        // assign
        List<accc_PlatformEventDAOLog> daoList = accc_PELogDataQueueHandlerTest.getPEData();

        accc_PELogDataQueueHandler handler = new accc_PELogDataQueueHandler(daoList);
        accc_SObjectBaseWriter.m_testToCaseException = true;
        // startTest/stopTest block to force async processes
        //   to run in the test.
        Test.startTest();
        // act
        System.enqueueJob(handler);
        Test.stopTest();
        System.assertEquals(true, accc_ApexUtilities.containsInTestLog(accc_SObjectBaseWriter.EXCEPTION_MESG_FOR_TEST));

    }

    @isTest
    static void testctorWithBigObjectList() {
        // assign
        List<accc_Org_Events__b> daoList = accc_PELogDataQueueHandlerTest.getBigPEData();

        accc_PELogDataQueueHandler handler = new accc_PELogDataQueueHandler(daoList);

        System.assertEquals(daoList.size(), handler.entries.size());
        System.assertEquals(false, handler.actions );
    }

    @isTest
    static void testctorWithBigObjectListWithTwoParams() {
        // assign
        List<accc_Org_Events__b> daoList = accc_PELogDataQueueHandlerTest.getBigPEData();
		// act
        accc_PELogDataQueueHandler handler = new accc_PELogDataQueueHandler(daoList,true);

        System.assertEquals(daoList.size(), handler.entries.size());
        System.assertEquals(true, handler.actions );
    }

    /////////////////////////////////////////////////////////////////////////////////////
    //
    // Private Methods
    /////////////////////////////////////////////////////////////////////////////////////
    static List<accc_PlatformEventDAOLog> getPEData() {
        DateTime now = DateTime.Now();
        String name = 'my-test-pe-test-today';

        List<accc_PlatformEventDAOLog> daoList = new List<accc_PlatformEventDAOLog> {
            new accc_PlatformEventDAOLog(name, JSON.serialize(new pe_test__e()), now),
            new accc_PlatformEventDAOLog(name, JSON.serialize(new pe_test__e()), now + 1),
            new accc_PlatformEventDAOLog(name, JSON.serialize(new pe_test__e()), now + 2)
        };
        return daoList;
    } // end of getPEData

    static List<accc_Org_Events__b> getBigPEData() {
        return accc_PlatformEventDAOLog.mapFrom(accc_PELogDataQueueHandlerTest.getPEData());
    } // end of getBigPEData

} // end of accc_PELogDataQueueHandlerTest