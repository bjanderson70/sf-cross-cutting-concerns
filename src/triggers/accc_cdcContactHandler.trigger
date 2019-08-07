/**
 * @File Name          : accc_cdcContactHandler.trigger
 * @Description        : CDC for Contact
 * @Author             : Bill Anderson
 * @Group              : 
 * @Last Modified By   : Bill Anderson
 * @Last Modified On   : 8/1/2019, 10:41:14 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    7/31/2019, 12:56:36 PM   Bill Anderson     Initial Version
**/
trigger accc_cdcContactHandler on ContactChangeEvent (after insert) {
    accc_ApexPlatformEventDispatcher.run(new accc_CDCEventBase( ) );
}