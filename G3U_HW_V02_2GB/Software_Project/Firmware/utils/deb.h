/*
 * deb.h
 *
 *  Created on: 27 de jun de 2020
 *      Author: Tiago-note
 */

#ifndef UTILS_DEB_H_
#define UTILS_DEB_H_


#include "../simucam_definitions.h"
#include "ccd.h"
#include "../driver/comm/comm_channel.h"



/* FEE operation modes */
typedef enum { sInit = 0, sOFF, sOFF_Enter, sOn, sStandBy, sFullPattern, sWinPattern, sFullImage, sWindowing,
		sOn_Enter, sStandBy_Enter, sConfig_Enter,
		sFullPattern_Enter, sFullPattern_Out, sWinPattern_Enter, sWinPattern_Out,
		sFullImage_Enter, sFullImage_Out, sWindowing_Enter, sWindowing_Out,
		sWaitSync, redoutWaitSync,
		redoutCycle_Enter, redoutCycle_Out, redoutWaitBeforeSyncSignal, redoutCheckDTCUpdate, redoutCheckRestr, redoutConfigureTrans, redoutPreLoadBuffer,
		redoutTransmission, redoutEndSch, readoutWaitingFinishTransmission} tDebStates;

 /* Error Injection Control Register Struct */
typedef struct DpktErrorCopy {
	volatile bool bEnabled;		/*Is error injection Enabled?*/
	volatile bool bTxDisabled; /* Error Injection Tx Disabled Enable */
	volatile bool bMissingPkts; /* Error Injection Missing Packets Enable */
	volatile bool bMissingData; /* Error Injection Missing Data Enable */
	volatile alt_u8 ucFrameNum; /* Error Injection Frame Number of Error */
	volatile alt_u16 usiSequenceCnt; /* Error Injection Sequence Counter of Error */
	volatile alt_u16 usiDataCnt; /* Error Injection Data Counter of Error */
	volatile alt_u16 usiNRepeat; /* Error Injection Number of Error Repeats */
} TDpktErrorCopy;



typedef struct DebControl{
    unsigned char ucTimeCode;               /* Timecode [NFEESIM-UR-488]*/
    unsigned char ucTimeCodeSpwChannel;		/* 0.. 4*/

    unsigned char ucTxInMode[8];			/*DTC_IN_MOD p.44 ICD DLR*/

    volatile tDebStates eState;                   /* Real State of NFEE */
    tDebStates eLastMode;
    tDebStates eMode;
    tDebStates eNextMode;
} TDebControl;


#endif /* UTILS_DEB_H_ */
