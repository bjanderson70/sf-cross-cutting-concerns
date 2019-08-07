/**
 * @File Name          : accc_cdcLeadHandler.trigger
 * @Description        : CDC for Lead
 * @Author             : Bill Anderson
 * @Group              : 
 * @Last Modified By   : Bill Anderson
 * @Last Modified On   : 8/1/2019, 10:41:41 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    7/31/2019, 12:56:54 PM   Bill Anderson     Initial Version
**/
trigger accc_cdcLeadHandler on LeadChangeEvent (after insert) {
     accc_ApexPlatformEventDispatcher.run(new accc_CDCEventBase( ) );
}