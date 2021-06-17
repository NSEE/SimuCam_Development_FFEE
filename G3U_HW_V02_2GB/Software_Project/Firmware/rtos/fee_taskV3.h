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

void vFeeTaskV3(void *task_data);
void vQCmdFEEinPreLoadBuffer( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdWaitFinishingTransmission( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdFEEinReadoutSync( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdFEEinWaitingSync( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdFEEinStandBy( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdFEEinOn( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdFEEinConfig( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdFEEinWaitingMemUpdate( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdWaitBeforeSyncSignal( TFFee *pxFFeeP, unsigned int cmd );
void vInitialConfig_RMAPCodecConfig( TFFee *pxFFeeP );
void vInitialConfig_DpktPacket( TFFee *pxFFeeP );
void vInitialConfig_RmapMemArea( TFFee *pxFFeeP );
void vSendMessageNUCModeFeeChange( unsigned char usIdFee, unsigned short int mode );
void vWaitUntilBufferEmpty( unsigned char ucId );
unsigned long int uliReturnMaskR( unsigned char ucChannel );
unsigned long int uliReturnMaskG( unsigned char ucChannel );
bool bSendRequestFeeCtrl( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
bool bSendMSGtoMebTask( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
bool bDisAndClrDbBuffer( TFeebChannel *pxFeebCh );
void vConfigTinMode( TFFee *pxFFeeP , TtInMode *xTinModeP, unsigned ucTxin);
bool bEnableDbBuffer( TFFee *pxFFeeP, TFeebChannel *pxFeebCh );
bool bEnableSPWChannel( TSpwcChannel *xSPW, unsigned char ucFee );
bool bDisableSPWChannel( TSpwcChannel *xSPW, unsigned char ucFee );
bool bEnableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId );
bool bDisableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId );
void vQCmdFeeRMAPWaitingSync( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdFeeRMAPinStandBy( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdFeeRMAPinModeOn( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdFeeRMAPinWaitingMemUpdate( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdFeeRMAPBeforeSync( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdFeeRMAPReadoutSync( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdFeeRMAPinReadoutTrans( TFFee *pxFFeeP, unsigned int cmd );
void vQCmdFeeRMAPinPreLoadBuffer( TFFee *pxFFeeP, unsigned int cmd );
void vUpdateFeeHKValue ( TFFee *pxFFeeP, alt_u16 usiRmapHkID, alt_u32 uliRawValue );
void vActivateContentErrInj( TFFee *pxFFeeP );
void vActivateDataPacketErrInj( TFFee *pxFFeeP );

#endif /* RTOS_FEE_TASKV3_H_ */
