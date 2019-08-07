/**
 * @File Name          : accc_cdcAccountHandler.trigger
 * @Description        : CDC for Account
 * @Author             : Bill Anderson
 * @Group              : 
 * @Last Modified By   : Bill Anderson
 * @Last Modified On   : 8/1/2019, 10:42:07 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    7/31/2019, 12:56:00 PM   Bill Anderson     Initial Version
**/
trigger accc_cdcAccountHandler on AccountChangeEvent (after insert) {
    accc_ApexPlatformEventDispatcher.run(new accc_CDCEventBase( ) );
}