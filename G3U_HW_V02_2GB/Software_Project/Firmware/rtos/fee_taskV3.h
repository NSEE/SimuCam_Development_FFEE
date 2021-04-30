/*
 * fee_taskV3.h
 *
 *  Created on: 22 de ago de 2019
 *      Author: Tiago-note
 */

#ifndef RTOS_FEE_TASKV3_H_
#define RTOS_FEE_TASKV3_H_


#include "../simucam_definitions.h"
#include "tasks_configurations.h"
#include "../utils/ccd.h"
#include "../utils/ffee.h"
#include "../utils/meb.h"
#include "../driver/comm/spw_controller/spw_controller.h"
#include "../driver/comm/comm_channel.h"
#include "../utils/queue_commands_list.h"
#include "../api_driver/simucam_dma/simucam_dma.h"
#include "../driver/comm/data_packet/data_packet.h"
#include "../driver/comm/rmap/rmap.h"
#include "../driver/leds/leds.h"
#include "../utils/communication_configs.h"
#include "../utils/communication_utils.h"
#include "../utils/error_handler_simucam.h"
#include "../utils/defaults.h"
#include "../driver/comm/windowing/windowing.h"
#include "../driver/ftdi/ftdi.h"
#include "../driver/sync/sync.h"

/* HK values enum */
enum FeeHKValues{
	eRmapHkTouSense1 = 0, eRmapHkTouSense2, eRmapHkTouSense3, eRmapHkTouSense4, eRmapHkTouSense5, eRmapHkTouSense6,
	eRmapHkCcd1Ts, eRmapHkCcd2Ts, eRmapHkCcd3Ts, eRmapHkCcd4Ts, eRmapHkPrt1, eRmapHkPrt2, eRmapHkPrt3, eRmapHkPrt4,
	eRmapHkPrt5, eRmapHkZeroDiffAmp, eRmapHkCcd1VodMon, eRmapHkCcd1VogMon, eRmapHkCcd1VrdMonE, eRmapHkCcd2VodMon,
	eRmapHkCcd2VogMon, eRmapHkCcd2VrdMonE, eRmapHkCcd3VodMon, eRmapHkCcd3VogMon, eRmapHkCcd3VrdMonE, eRmapHkCcd4VodMon,
	eRmapHkCcd4VogMon, eRmapHkCcd4VrdMonE, eRmapHkVccd, eRmapHkVrclkMon, eRmapHkViclk, eRmapHkVrclkLow, eRmapHk5vbPosMon,
	eRmapHk5vbNegMon, eRmapHk3v3bMon, eRmapHk2v5aMon, eRmapHk3v3dMon, eRmapHk2v5dMon, eRmapHk1v5dMon, eRmapHk5vrefMon,
	eRmapHkVccdPosRaw, eRmapHkVclkPosRaw, eRmapHkVan1PosRaw, eRmapHkVan3NegMon, eRmapHkVan2PosRaw, eRmapHkVdigRaw,
	eRmapHkVdigRaw2, eRmapHkViclkLow, eRmapHkCcd1VrdMonF, eRmapHkCcd1VddMon, eRmapHkCcd1VgdMon, eRmapHkCcd2VrdMonF,
	eRmapHkCcd2VddMon, eRmapHkCcd2VgdMon, eRmapHkCcd3VrdMonF, eRmapHkCcd3VddMon, eRmapHkCcd3VgdMon, eRmapHkCcd4VrdMonF,
	eRmapHkCcd4VddMon, eRmapHkCcd4VgdMon, eRmapHkIgHiMon, eRmapHkIgLoMon, eRmapHkTsenseA, eRmapHkTsenseB,
	eRmapHkFpgaMinVer, eRmapHkFpgaMajVer, eRmapHkBoardId
} EFeeHKValues;

void vFeeTaskV3(void *task_data);
void vQCmdFEEinPreLoadBuffer( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdWaitFinishingTransmission( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinReadoutSync( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinWaitingSync( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinStandBy( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinOn( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinConfig( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdFEEinWaitingMemUpdate( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdWaitBeforeSyncSignal( TFFee *pxNFeeP, unsigned int cmd );
void vInitialConfig_RMAPCodecConfig( TFFee *pxNFeeP );
void vInitialConfig_DpktPacket( TFFee *pxNFeeP );
void vSendMessageNUCModeFeeChange( unsigned char usIdFee, unsigned short int mode );
void vWaitUntilBufferEmpty( unsigned char ucId );
unsigned long int uliReturnMaskR( unsigned char ucChannel );
unsigned long int uliReturnMaskG( unsigned char ucChannel );
bool bSendRequestNFeeCtrl( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
bool bSendMSGtoMebTask( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
bool bDisAndClrDbBuffer( TFeebChannel *pxFeebCh );
void vConfigTinMode( TFFee *pxNFeeP , TtInMode *xTinModeP, unsigned ucTxin);
bool bEnableDbBuffer( TFFee *pxNFeeP, TFeebChannel *pxFeebCh );
bool bEnableSPWChannel( TSpwcChannel *xSPW );
bool bDisableSPWChannel( TSpwcChannel *xSPW );
bool bEnableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId );
bool bDisableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId );
void vQCmdFeeRMAPWaitingSync( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPinStandBy( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPinModeOn( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPinWaitingMemUpdate( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPBeforeSync( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPReadoutSync( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPinReadoutTrans( TFFee *pxNFeeP, unsigned int cmd );
void vQCmdFeeRMAPinPreLoadBuffer( TFFee *pxNFeeP, unsigned int cmd );
//void vUpdateFeeHKValue ( TFFee *pxNFeeP, alt_u8 ucRmapHkID, alt_u32 uliRawValue );



#endif /* RTOS_FEE_TASKV3_H_ */
