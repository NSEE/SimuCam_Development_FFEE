/*
 * meb.h
 *
 *  Created on: 11/01/2019
 *      Author: Tiago-Low
 */

#ifndef MEB_H_
#define MEB_H_

#include "../simucam_definitions.h"
#include "fee_controller.h"
#include "data_controller.h"
#include "ffee.h"
#include "ccd.h"
#include "lut_handler.h"

/* Used to get the priorities needed for the sync-reset function [bndky] */
#include "../rtos/tasks_configurations.h"


/* Simucam operation modes */
typedef enum { sInternal = 0, sExternal } tSimucamSync;
typedef enum { sNormalFEE = 0, sFastFEE } tFeeType;


/* MASK LOGIC
 * think in bit ---> end[7] end[6] end[5] end[4] end[3] end[2] end[1] end[0] => 7: always zero; 6: is the DataController; 0..1: FFEE0 to FFEE1
 * */

/*Moved to simucam definitions*/
typedef struct Simucam_MEB {
    tFeeType        eType;                  /* Normal or Fast FEE */
    tSimucamStates  eMode;                  /* Mode of operation for the Simucam */
    TMebRealStates  eMebRealMode;           /* Meb "real" operating mode, for status purposes */
    unsigned char ucActualDDR;              /* Control the swap mechanism of DDRs ( 0: DDR0 or 1: DDR1 ) */
    unsigned char ucNextDDR;              /* Control the swap mechanism of DDRs ( 0: DDR0 or 1: DDR1 ) */
    /* Note 3: The EP and RT parameters are common to all the N-FEE simulation entities. */
    alt_u16 usiEP;                    			/* Exposure period */
    alt_u16 usiRT;                    			/* CCD readout time */
    unsigned short int usiDelaySyncReset;
    float fLineTransferTime;
    float fPixelTransferTime;
    tSimucamSync  eSync;                    /* Internal or external sync */
    bool bEnablePusMasterSync;				/* Enable for the synchronization PUS after a Master Sync */
    alt_u8 ucSyncNRepeat;
    alt_u8 ucSyncRepeatCnt;
    bool    bAutoResetSyncMode;              /* Auto Reset Sync Mode */
    /* todo: estruturas de controle para o simucam */
    TData_Control xDataControl;
    TFFee_Control xFeeControl;
    TLUTStruct xLut;
} TSimucam_MEB;

extern TSimucam_MEB xSimMeb;
extern OS_EVENT *xQueueSyncReset;   /*[bndky]*/

void vSimucamStructureInit( TSimucam_MEB *xMeb );

void vLoadDefaultEPValue( TSimucam_MEB *xMeb );
void vChangeEPValue( TSimucam_MEB *xMeb, alt_u16 usiValue );
void vChangeDefaultEPValue( TSimucam_MEB *xMeb, alt_u16 usiValue );
void vLoadDefaultRTValue( TSimucam_MEB *xMeb );
void vChangeRTValue( TSimucam_MEB *xMeb, alt_u16 usiValue );
void vChangeDefaultRTValue( TSimucam_MEB *xMeb, alt_u16 usiValue );
void vLoadDefaultSyncSource( TSimucam_MEB *xMeb );
void vChangeSyncSource( TSimucam_MEB *xMeb, tSimucamSync eSource );
void vChangeDefaultSyncSource( TSimucam_MEB *xMeb, tSimucamSync eSource );
void vLoadDefaultSyncRepeat( TSimucam_MEB *xMeb );
void vChangeSyncRepeat( TSimucam_MEB *xMeb, alt_u8 ucSyncNRepeat );
void vLoadDefaultAutoResetSync( TSimucam_MEB *xMeb );
void vChangeAutoResetSync( TSimucam_MEB *xMeb, bool bAutoReset );
void vChangeDefaultAutoResetSync( TSimucam_MEB *xMeb, bool bAutoReset );
void vSyncReset( unsigned short int ufSynchDelay, TFFee_Control *pxFeeCP ); /* [bndky] */

void vSendCmdQToFeeCTRL( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
void vSendCmdQToFeeCTRL_PRIO( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
void vSendCmdQToDataCTRL( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );
void vSendCmdQToDataCTRL_PRIO( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );

void vSendCmdQToFeeCTRL_GEN( unsigned char usiFeeInstP,unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue );

#endif /* MEB_H_ */
