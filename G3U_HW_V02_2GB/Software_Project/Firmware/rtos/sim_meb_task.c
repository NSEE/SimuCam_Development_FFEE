/*
 * sim_meb_task.c
 *
 *  Created on: 13/01/2019
 *      Author: TiagoLow
 */


#include "sim_meb_task.h"

/* All commands should pass through the MEB, it is the instance that hould know everything,
and also know the self state and what is allowed to be performed or not */

volatile TImgWinContentErr *vpxImgWinContentErr = NULL;
volatile TDataPktError *vpxDataPktError = NULL;

void vSimMebTask(void *task_data) {
	TSimucam_MEB *pxMebC;
	unsigned char ucIL,ucJL;
	volatile tQMask uiCmdMeb;
	INT8U error_code;


	pxMebC = (TSimucam_MEB *) task_data;

	#if DEBUG_ON
	if ( xDefaults.ucDebugLevel <= dlMajorMessage )
        fprintf(fp,"MEB Controller Task. (Task on)\n");
    #endif


	for (;;) {
		switch ( pxMebC->eMode ) {
			case sMebInit:
				/* Turn on Meb */
				vMebInit( pxMebC );
				xGlobal.ucEP0_1 = 0;
				pxMebC->eMode = sMebToConfig;
				break;

			case sMebToConfig:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage )
					fprintf(fp,"MEB Task: Config Mode\n");
				#endif

				/* Send Event Log */
				vSendEventLogArr(EVT_MEBFEE_MEB_ID, cucEvtListData[eEvtMebInConfigMode]);

				vEnterConfigRoutine( pxMebC );
				pxMebC->eMode = sMebConfig;
				pxMebC->eMebRealMode = eMebRealStConfig;
				break;

			case sMebToRun:

				bEnableIsoDrivers();
				bEnableLvdsBoard();

				pxMebC->ucActualDDR = 1;
				pxMebC->ucNextDDR = 0;

				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage )
					fprintf(fp,"\nMEB Task: Going to Run Mode\n");
				#endif

				/*Send Event Log*/
				vSendEventLogArr(EVT_MEBFEE_MEB_ID, cucEvtListData[eEvtMebInRunMode]);

				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage )
					fprintf(fp,"MEB Task: First DTC will load at least one full sky from SSD.\n");
					fprintf(fp,"MEB Task: All other modules will wait until DTC finishes.\n");
				#endif

				/*Time to read, remover later*/ //todo: Remove later releases
				OSTimeDlyHMSM(0, 0, 3, 0);


				vSendCmdQToDataCTRL_PRIO( M_DATA_RUN_FORCED, 0, 0 );

				OSSemPend(xSemCommInit, 0, &error_code); /*Blocking*/
				if ( error_code == OS_ERR_NONE ) {

					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlMajorMessage )
						fprintf(fp,"MEB Task: FEE Controller and FEEs to RUN.\n");
					#endif


					/* Transition to Run Mode (Starting the Simulation) */
					vSendCmdQToNFeeCTRL_PRIO( M_NFC_RUN_FORCED, 0, 0 );

					/* Give time to DTC and NFEE controller to start all processe before the first master sync */
					OSTimeDlyHMSM(0, 0, 0, 250);
					//vSendMessageNUCModeMEBChange( 2 ); /*2: Running*/
					/* Give time to all tasks receive the command */
					//OSTimeDlyHMSM(0, 0, 0, pxMebC->usiDelaySyncReset);

					/* Clear the timecode of the channel SPW (for now is for spw channel) */
					for (ucIL = 0; ucIL < N_OF_FastFEE; ++ucIL) {
						for (ucJL = 0; ucJL < N_OF_CCD; ++ucJL) {
							bSpwcClearTimecode(&pxMebC->xFeeControl.xFfee[ucIL].xChannel[ucJL].xSpacewire);
						}
						pxMebC->xFeeControl.xFfee[ucIL].xControl.xDeb.ucTimeCode = 0;
					}

					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlMajorMessage )
						fprintf(fp,"\nMEB Task: Releasing Sync Module in 5 seconds\n");
					#endif

					OSTimeDlyHMSM(0, 0, 5, 200);

					/* [rfranca] */
					if (sInternal == pxMebC->eSync) {
						bSyncCtrIntern(TRUE); /*TRUE = Internal*/
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlMajorMessage )
							fprintf(fp,"\nMEB Task: Sync Module Released\n");
						#endif
					} else {
						bSyncCtrIntern(FALSE); /*TRUE = Internal*/
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlMajorMessage )
							fprintf(fp,"\nMEB Task: Waiting external Sync signal\n");
						#endif
					}

					xGlobal.ucEP0_1 = 0;

					/*This sequence start the HW sync module*/
					bSyncCtrReset();
					vSyncClearCounter();
					bStartSync();

					vEvtChangeMebMode();
					pxMebC->eMode = sMebRun;
					pxMebC->eMebRealMode = eMebRealStRun;
				} else {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
						fprintf(fp,"MEB Task: CRITICAL! Could no receive the sync semaphore from DTC, backing to Config Mode\n");
					#endif
					pxMebC->eMode = sMebToConfig;
				}

				break;

			case sMebConfig:

/*				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage )
					fprintf(fp,"MEB Task: sMebConfig - Waiting for command.");
				#endif
				break;*/

				uiCmdMeb.ulWord = (unsigned int)OSQPend(xMebQ, 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					/* Threat the command received in the Queue Message */
					vPerformActionMebInConfig( uiCmdMeb.ulWord, pxMebC);
				} else {
					/* Should never get here (blocking operation), critical failure */
					vCouldNotGetCmdQueueMeb();
				}
				break;

			case sMebRun:

/*				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMinorMessage )
					fprintf(fp,"MEB Task: sMebRun - Waiting for command.");
				#endif
				break;*/

				uiCmdMeb.ulWord = (unsigned int)OSQPend(xMebQ, 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {

					/* Threat the command received in the Queue Message */
					vPerformActionMebInRunning( uiCmdMeb.ulWord, pxMebC);

				} else {
					/* Should never get here (blocking operation), critical fail */
					vCouldNotGetCmdQueueMeb();
				}
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					debug(fp,"MEB Task: Unknown state, backing to Config Mode\n");
				#endif
				/* todo:Aplicar toda logica de mudança de esteado aqui */
				pxMebC->eMode = sMebToConfig;
		}
	}
}


void vPerformActionMebInRunning( unsigned int uiCmdParam, TSimucam_MEB *pxMebCLocal ) {
	tQMask uiCmdLocal;
	unsigned char ucIL =0;

	uiCmdLocal.ulWord = uiCmdParam;

	/* Check if the command is for MEB */
	if ( uiCmdLocal.ucByte[3] == M_MEB_ADDR ) {
		/* Parse the cmd that comes in the Queue */
		switch (uiCmdLocal.ucByte[2]) {
			/* Receive a PUS command */
			case Q_MEB_PUS:
				vPusMebTask( pxMebCLocal );
				break;

			case M_MASTER_SYNC:
				/* Perform memory SWAP */
				vSwapMemmory(pxMebCLocal);
				vTimeCodeMissCounter(pxMebCLocal);
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"\n============== Master Sync ==============\n\n");
					volatile TCommChannel *vpxCommAChannel = (TCommChannel *) COMM_CH_1_BASE_ADDR;
					fprintf(fp,"Channels TimeCode = %d\n", (alt_u8)vpxCommAChannel->xSpacewire.xSpwcTimecodeStatus.ucTime);
				}
				#endif
				vDebugSyncTimeCode(pxMebCLocal);
				vManageSyncGenerator(pxMebCLocal);
				break;

			case Q_MEB_DATA_MEM_UPD_FIN:

				/*Check if is already the sync before Master Sync*/
				if ( xGlobal.bPreMaster == TRUE ) {
					/*Maybe have some FEE instances locked in reading queue, waiting for a message that DTC finishes the upload of the memory*/
					/*So, need to send them a message to inform*/
					/* Using QMASK send to NfeeControl that will foward */
					for (ucIL = 0; ucIL < N_OF_FastFEE; ucIL++) {
						if ( TRUE == pxMebCLocal->xFeeControl.xFfee[ucIL].xControl.bUsingDMA ) {
							vSendCmdQToNFeeCTRL_GEN(ucIL, M_FEE_CAN_ACCESS_NEXT_MEM, 0, ucIL );
						}
					}
				}
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp,"MEB Task: Unknown command (%hhu)\n", uiCmdLocal.ucByte[2]);
				#endif
		}
	} else {
		#if DEBUG_ON
		if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
			fprintf(fp,"MEB Task: Command Ignored wrong address (ADDR= %hhu)\n", uiCmdLocal.ucByte[3]);
		#endif
	}
}



void vPerformActionMebInConfig( unsigned int uiCmdParam, TSimucam_MEB *pxMebCLocal ) {
	tQMask uiCmdLocal;

	uiCmdLocal.ulWord = uiCmdParam;

#if DEBUG_ON
if ( xDefaults.ucDebugLevel <= dlMinorMessage )
	fprintf(fp,"MEB Task: vPerformActionMebInConfig - CMD.ulWord:0x%08x ",uiCmdLocal.ulWord );
#endif

	/* Check if the command is for MEB */
	if ( uiCmdLocal.ucByte[3] == M_MEB_ADDR ) {

		/* Parse the cmd that comes in the Queue */
		switch ( uiCmdLocal.ucByte[2] ) {
			/* Receive a PUS command */
			case Q_MEB_PUS:
				vPusMebTask( pxMebCLocal );
				break;
			case M_MASTER_SYNC:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp,"MEB Task: WARNING Should not have sync in Meb Config Mode (Check it please)");
				#endif
				break;
			case Q_MEB_DATA_MEM_UPD_FIN:
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp,"MEB Task: Unknown command for the Config Mode (Queue xMebQ, cmd= %hhu)\n", uiCmdLocal.ucByte[2]);
				#endif
		}
	} else {
		#if DEBUG_ON
		if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
			fprintf(fp,"MEB Task: Command Ignored wrong address (ADDR= %hhu)\n", uiCmdLocal.ucByte[3]);
		#endif
	}
}


void vDebugSyncTimeCode( TSimucam_MEB *pxMebCLocal ) {
//	INT8U ucFrameNumber;
//	unsigned char tCode;
//	unsigned char tCodeNext;


//	#if DEBUG_ON
//	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
//		bSpwcGetTimecode(&pxMebCLocal->xFeeControl.xNfee[0].xChannel.xSpacewire);
//		tCode = ( pxMebCLocal->xFeeControl.xNfee[0].xChannel.xSpacewire.xSpwcTimecodeStatus.ucTime);
//		tCodeNext = ( tCode ) % 4;
//		fprintf(fp,"TC: %hhu ( %hhu )\n ", tCode, tCodeNext);
//		bRmapGetRmapMemCfgArea(&pxMebCLocal->xFeeControl.xNfee[0].xChannel.xRmap);
//		ucFrameNumber = pxMebCLocal->xFeeControl.xNfee[0].xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucFrameNumber;
//		fprintf(fp,"MEB TASK:  Frame Number: %hhu \n ", ucFrameNumber);
//	}
//	#endif
}




void vPusMebTask( TSimucam_MEB *pxMebCLocal ) {
	bool bSuccess;
	INT8U error_code;
	unsigned char ucIL;
	static tTMPus xPusLocal;

	#if DEBUG_ON
	if ( xDefaults.ucDebugLevel <= dlMinorMessage )
		fprintf(fp,"MEB Task: vPusMebTask\n");
	#endif

	bSuccess = FALSE;
	OSMutexPend(xMutexPus, 2, &error_code);
	if ( error_code == OS_ERR_NONE ) {
	    /*Search for the PUS command*/
	    for(ucIL = 0; ucIL < N_PUS_PIPE; ucIL++)
	    {
            if ( xPus[ucIL].bInUse == TRUE ) {
                /* Need to check if the performance is the same as memcpy*/
            	xPusLocal = xPus[ucIL];
            	xPus[ucIL].bInUse = FALSE;
            	bSuccess = TRUE;
                break;
            }
	    }
	    OSMutexPost(xMutexPus);
	} else {
		vCouldNotGetMutexMebPus();
	}

	if ( bSuccess == TRUE ) {
		switch (pxMebCLocal->eMode) {
			case sMebConfig:
			case sMebToConfig:
				vPusMebInTaskConfigMode(pxMebCLocal, &xPusLocal);
				break;
			case sMebRun:
			case sMebToRun:
				vPusMebInTaskRunningMode(pxMebCLocal, &xPusLocal);
				break;
			default:
				break;
		}
	} else {
		#if DEBUG_ON
		if ( xDefaults.ucDebugLevel <= dlMinorMessage )
			fprintf(fp,"MEB Task: vPusMebTask - Don't found Pus command in xPus.");
		#endif
	}
}


/* This function should treat the PUS command in the Config Mode, need check all the things that is possible to update in this mode */
/* In the Config Mode the MEb takes control and change all values freely */
void vPusMebInTaskConfigMode( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {

	switch (xPusL->usiType) {
		/* srv-Type = 250 */
		case 250:
			vPusType250conf(pxMebCLocal, xPusL);
			break;
		/* srv-Type = 251 */
		case 251:
			vPusType251conf(pxMebCLocal, xPusL);
			break;
		/* srv-Type = 252 */
		case 252:
			vPusType252conf(pxMebCLocal, xPusL);
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: Srv-Type not allowed in this mode (CONFIG)\n\n" );
			#endif
	}
}

void vPusType250conf( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {
	unsigned char ucShutDownI = 0;
	unsigned short int param1 = 0;
	unsigned char ucFeeParamL,ucFFeeInstL,ucAebInstL;
	alt_u32 ulEP, ulStart, ulPx, ulLine;
	unsigned char ucDTSourceL;
	alt_u16 usiCfgPxColX       = 0;
	alt_u16 usiCfgPxRowY       = 0;
	alt_u16 usiCfgPxSide       = 0;
	alt_u16 usiCfgCountFrames  = 0;
	alt_u16 usiCfgFramesActive = 0;
	alt_u16 usiCfgPxValue      = 0;
	bool bPixelAlreadyExist = FALSE;

	#if DEBUG_ON
	if ( xDefaults.ucDebugLevel <= dlMinorMessage )
		fprintf(fp,"MEB Task: vPusType250conf - Command: %hhu.", xPusL->usiSubType);
	#endif


	switch (xPusL->usiSubType) {
		/* TC_SCAMxx_FEE_FGS_ON */
		case 86:
		/* TC_SCAMxx_FEE_FGS_OFF */
		case 87:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: Can't turn on/off the FGS feature while in MEB Config. Mode \n" );
			}
			#endif
		break;
		/* TC_SYNCH_SOURCE */
		case 29:
			/* Set sync source */
			param1 = xPusL->usiValues[0];
			if (0 == param1) {
				/*TRUE = Internal*/
				vChangeSyncSource( pxMebCLocal, sInternal );
				xDefaults.ucSyncSource = sInternal;
			} else {
				vChangeSyncSource( pxMebCLocal, sExternal );
				xDefaults.ucSyncSource = sExternal;
			}
			break;
		/* TC_SCAMxx_RMAP_ECHO_ENABLE */
		case 36:
//			usiFeeInstL = xPusL->usiValues[0];
//			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingModeEn = TRUE;
//			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingIdEn = xPusL->usiValues[1];
//			bRmapSetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);
//			#if DEBUG_ON
//			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ){
//				fprintf(fp, "usiValues[0]: %hu;\n", xPusL->usiValues[0] );
//				fprintf(fp, "usiValues[1]: %hu;\n", xPusL->usiValues[1] );
//				fprintf(fp, "usiFeeInstL : %hu;\n", usiFeeInstL 		);
//			}
//			#endif
		break;
		/* TC_SCAMxx_RMAP_ECHO_DISABLE */
		case 37:
//			usiFeeInstL = xPusL->usiValues[0];
//			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingModeEn = FALSE;
//			bRmapSetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);
//			#if DEBUG_ON
//			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ){
//				fprintf(fp, "usiValues[0]: %hu;\n", xPusL->usiValues[0] );
//				fprintf(fp, "usiFeeInstL : %hu;\n", usiFeeInstL 		);
//			}
//			#endif
		break;
		/* TC_SCAMxx_EP_UPDATE  */
		case 44:
			pxMebCLocal->xDataControl.usiUpdatedEPn = xPusL->usiValues[0];
			pxMebCLocal->xDataControl.bEPnUpdated = TRUE;
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ){
				fprintf(fp, "MEB Task: Exposure Number updated to %u\n", xPusL->usiValues[0]);
			}
			#endif
			break;
		/* TC_SCAM_FEE_HK_UPDATE_VALUE [bndky] */
		case 58:
			vSendHKUpdate(pxMebCLocal, xPusL);
			break;
		/* TC_SCAM_ERR_OFF */
		case 53:
			ucFeeParamL = (unsigned char)xPusL->usiValues[0];
			ucFFeeInstL = ucFeeParamL / N_OF_CCD;
			ucAebInstL = ucFeeParamL % N_OF_CCD;
			vErrorInjOff(pxMebCLocal, ucFFeeInstL, ucAebInstL);
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
				fprintf(fp,"TC_SCAM_ERR_OFF\n");
			#endif
			break;
		/* TC_SCAMXX_SPW_ERR_TRIG */
		case 46:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: Can't configure SpaceWire errors while in MEB Config. Mode \n" );
			}
			#endif
			break;
		/* TC_SCAMXX_RMAP_ERR_TRIG */
		case 47:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: Can't configure RMAP errors while in MEB Config. Mode \n" );
			}
			#endif
			break;
		/* TC_SCAMXX_TICO_ERR_TRIG */
		case 48:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: Can't configure TimeCode errors while in MEB Config. Mode \n" );
			}
			#endif
			break;
		/* TC_SCAM_IMAGE_ERR_MISS_PKT_TRIG */
		case 49:
		/* TC_SCAM_IMAGE_ERR_NOMOREPKT_TRIG */
		case 50:
		/* TC_SCAM_IMAGE_ERR_MISSDATA_TRIG */
		case 67:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: Can't configure Image Transmission errors while in MEB Config. Mode \n" );
			}
			#endif
			break;
		/* TC_SCAM_WIN_ERR_MISS_PKT_TRIG */
		case 51:
		/* TC_SCAM_WIN_ERR_NOMOREPKT_TRIG */
		case 52:
		/* TC_SCAM_WIN_ERR_MISSDATA_TRIG */
		case 72:
		/* TC_SCAM_WIN_ERR_DISABLE_WIN_PROG */
		case 63:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: Can't configure Windowing Transmission errors while in MEB Config. Mode \n" );
			}
			#endif
			break;

		/* TC_SCAM_RUN */
		case 61:
			pxMebCLocal->eMode = sMebToRun;
			break;

		/* TC_SCAM_TURNOFF */
		case 66:
			/*todo: Do nothing for now */
			/* Animate LED */
			/* Wait for N seconds */
			for (ucShutDownI = 0; ucShutDownI < N_SEC_WAIT_SHUTDOWN; ucShutDownI++) {

				bSetPainelLeds( LEDS_OFF , LEDS_ST_ALL_MASK );
				bSetPainelLeds( LEDS_ON , (LEDS_ST_1_MASK << ( ucShutDownI % 4 )) );

				OSTimeDlyHMSM(0,0,1,0);
			}

			/* Sinalize that can safely shutdown the Simucam */
			bSetPainelLeds( LEDS_ON , LEDS_ST_ALL_MASK );
			break;

		/* TC_SCAM_FEE_TIME_CONFIG */
		case 64:
			ulEP= (alt_u32)( (alt_u32)(xPusL->usiValues[0] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[1] & 0x0000ffff) );
			ulStart= (alt_u32)( (alt_u32)(xPusL->usiValues[2] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[3] & 0x0000ffff) );
			ulPx= (alt_u32)( (alt_u32)(xPusL->usiValues[4] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[5] & 0x0000ffff) );
			ulLine= (alt_u32)( (alt_u32)(xPusL->usiValues[6] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[7] & 0x0000ffff) );

			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "---TIME_CONFIG: EP: %lu (ms)\n", ulEP);
				fprintf(fp, "---TIME_CONFIG: Start Delay: %lu (ms)\n", ulStart);
				fprintf(fp, "---TIME_CONFIG: Px Delay: %lu (ns)\n", ulPx);
				fprintf(fp, "---TIME_CONFIG: Line Delay: %lu (ns)\n", ulLine);
			}
			#endif

			/*Configure EP*/
			//bSyncConfigFFeeSyncPeriod( (alt_u16)ulEP ); // Change to update usiEP em xMeb for STATUS REPORT
			if (bSyncConfigFFeeSyncPeriod( (alt_u16)ulEP ) == true) {
				vChangeEPValue(pxMebCLocal, (alt_u16)ulEP);
				xDefaults.usiExposurePeriod = (alt_u16)ulEP;
			}

			for (ucFFeeInstL=0; ucFFeeInstL < N_OF_FastFEE; ucFFeeInstL++) {
				for (ucAebInstL=0; ucAebInstL < N_OF_CCD; ucAebInstL++) {
					bDpktGetPixelDelay(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktPixelDelay.uliStartDelay = uliPxDelayCalcPeriodMs( ulStart );
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktPixelDelay.uliAdcDelay = uliPxDelayCalcPeriodNs( ulPx );
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktPixelDelay.uliLineDelay = uliPxDelayCalcPeriodNs( ulLine );
					bDpktSetPixelDelay(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
				}
			}

			break;

	/* TC_SCAM_FEE_DATA_SOURCE */
	case 70:
		ucFFeeInstL = (unsigned char)xPusL->usiValues[0];
		ucDTSourceL = (unsigned char)xPusL->usiValues[1];
		#if DEBUG_ON
		if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
			fprintf(fp,"MEB Task: DATA_SOURCE ucFeeInstL= %hhu, ucDTSourceL= %hhu\n",ucFFeeInstL,ucDTSourceL  );
		#endif
		vSendCmdQToNFeeCTRL_GEN(ucFFeeInstL, M_FEE_DT_SOURCE, ucDTSourceL, ucDTSourceL );
		break;

	/* TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG */
	case 73:
		//ucFFeeInstL = (unsigned char)xPusL->usiValues[0];
		ucFeeParamL = (unsigned char)xPusL->usiValues[0];
		ucFFeeInstL = ucFeeParamL/N_OF_CCD;
		ucAebInstL = ucFeeParamL%N_OF_CCD;

		usiCfgPxColX       = xPusL->usiValues[1];
		usiCfgPxRowY       = xPusL->usiValues[2];
		usiCfgPxSide       = xPusL->usiValues[3];
		usiCfgCountFrames  = xPusL->usiValues[4];
		usiCfgFramesActive = xPusL->usiValues[5];
		usiCfgPxValue      = xPusL->usiValues[6];

		bPixelAlreadyExist = FALSE;

		vpxImgWinContentErr = &(pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xImgWinContentErr);

		if (usiCfgFramesActive == 0) {
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] [AEB %u] TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG ERROR: invalid frames active parameter (0)\n", ucFFeeInstL, ucAebInstL);
			}
			#endif
		} else if (100 <= (vpxImgWinContentErr->ucLeftErrorCnt + vpxImgWinContentErr->ucRightErrorCnt)) {
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] [AEB %u] TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG ERROR: Already have 100 content errors \n", ucFFeeInstL, ucAebInstL);
			}
			#endif
			break;
		} else {
			// Side: 0 = Left; 1 = Right; 2 = Both
			if ((usiCfgPxSide == 0) || (usiCfgPxSide == 2)) {
				bPixelAlreadyExist = FALSE;
				if (vpxImgWinContentErr->ucLeftErrorCnt > 0){
					for (int iSeekEquals = 0; iSeekEquals < vpxImgWinContentErr->ucLeftErrorCnt; iSeekEquals++) {
						if  ( (vpxImgWinContentErr->xLeftErrorList[iSeekEquals].usiPxColX == usiCfgPxColX) && (vpxImgWinContentErr->xLeftErrorList[iSeekEquals].usiPxRowY == usiCfgPxRowY)) {
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp, "MEB Task: [FEE %u] [AEB %u] TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG ERROR: Left Position X, Y already exists\n", ucFFeeInstL, ucAebInstL);
							}
							#endif
							bPixelAlreadyExist = TRUE;
							break;
						}
					}
				}
				if (FALSE == bPixelAlreadyExist) {
					vpxImgWinContentErr->xLeftErrorList[vpxImgWinContentErr->ucLeftErrorCnt].usiPxColX       = usiCfgPxColX;
					vpxImgWinContentErr->xLeftErrorList[vpxImgWinContentErr->ucLeftErrorCnt].usiPxRowY       = usiCfgPxRowY;
					vpxImgWinContentErr->xLeftErrorList[vpxImgWinContentErr->ucLeftErrorCnt].usiCountFrames  = usiCfgCountFrames;
					vpxImgWinContentErr->xLeftErrorList[vpxImgWinContentErr->ucLeftErrorCnt].usiFramesActive = usiCfgCountFrames + usiCfgFramesActive - 1;
					vpxImgWinContentErr->xLeftErrorList[vpxImgWinContentErr->ucLeftErrorCnt].usiPxValue      = usiCfgPxValue;

					vpxImgWinContentErr->ucLeftErrorCnt++;
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] [AEB %u] TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG LEFT: %u\n", ucFFeeInstL, ucAebInstL, vpxImgWinContentErr->ucLeftErrorCnt);
					}
					#endif
				}
			}
			// Side: 0 = Left; 1 = Right; 2 = Both
			if ( (usiCfgPxSide == 1) || (usiCfgPxSide == 2)){
				bPixelAlreadyExist = FALSE;
				if (vpxImgWinContentErr->ucRightErrorCnt > 0){
					for (int iSeekEquals = 0; iSeekEquals < vpxImgWinContentErr->ucRightErrorCnt; iSeekEquals++) {
						if  ( (vpxImgWinContentErr->xRightErrorList[iSeekEquals].usiPxColX == usiCfgPxColX) && (vpxImgWinContentErr->xRightErrorList[iSeekEquals].usiPxRowY == usiCfgPxRowY)) {
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp, "MEB Task: [FEE %u] [AEB %u] TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG ERROR: Right Position X, Y already exists\n", ucFFeeInstL, ucAebInstL);
							}
							#endif
							bPixelAlreadyExist = TRUE;
							break;
						}
					}
				}
				if (FALSE == bPixelAlreadyExist) {
					vpxImgWinContentErr->xRightErrorList[vpxImgWinContentErr->ucRightErrorCnt].usiPxColX       = usiCfgPxColX;
					vpxImgWinContentErr->xRightErrorList[vpxImgWinContentErr->ucRightErrorCnt].usiPxRowY       = usiCfgPxRowY;
					vpxImgWinContentErr->xRightErrorList[vpxImgWinContentErr->ucRightErrorCnt].usiCountFrames  = usiCfgCountFrames;
					vpxImgWinContentErr->xRightErrorList[vpxImgWinContentErr->ucRightErrorCnt].usiFramesActive = usiCfgCountFrames + usiCfgFramesActive - 1;
					vpxImgWinContentErr->xRightErrorList[vpxImgWinContentErr->ucRightErrorCnt].usiPxValue      = usiCfgPxValue;

					vpxImgWinContentErr->ucRightErrorCnt++;
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] [AEB %u] TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG RIGHT: %u\n", ucFFeeInstL, ucAebInstL, vpxImgWinContentErr->ucRightErrorCnt);
					}
					#endif
				}
			}
		}
		#if DEBUG_ON
		if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
			fprintf(fp, "MEB Task: [FEE %u] [AEB %u] TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG\n", ucFFeeInstL, ucAebInstL);
		}
		#endif
		break;

	/* TC_SCAMxx_IMGWIN_CONTENT_ERR_CONFIG_FINISH */
	case 74:
		ucFeeParamL = (unsigned char)xPusL->usiValues[0];
		ucFFeeInstL = ucFeeParamL/N_OF_CCD;
		ucAebInstL = ucFeeParamL%N_OF_CCD;

		vpxImgWinContentErr = &(pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xImgWinContentErr);

		usiCfgPxSide = xPusL->usiValues[1];

		// Side: 0 = Left; 1 = Right; 2 = Both
		if ((0 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
			qsort((TImgWinContentErrData *)(vpxImgWinContentErr->xLeftErrorList), vpxImgWinContentErr->ucLeftErrorCnt, sizeof(TImgWinContentErrData), iCompareImgWinContent);
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content error list sorted (left side)\n", ucFFeeInstL, ucAebInstL);
			}
			#endif

			if (bDpktContentErrInjClearEntries(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket, eDpktCcdSideE)) {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content error list cleared (left side)\n", ucFFeeInstL, ucAebInstL);
				}
				#endif
				if (bDpktContentErrInjOpenList(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket, eDpktCcdSideE)) {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content error list opened (left side)\n", ucFFeeInstL, ucAebInstL);
					}
					#endif
					if (vpxImgWinContentErr->ucLeftErrorCnt > 0) {
						for (int iListCount=0; iListCount < vpxImgWinContentErr->ucLeftErrorCnt; iListCount++) {
							ucDpktContentErrInjAddEntry( &pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket,
														 eDpktCcdSideE,
														 vpxImgWinContentErr->xLeftErrorList[iListCount].usiCountFrames,
														 vpxImgWinContentErr->xLeftErrorList[iListCount].usiFramesActive,
														 vpxImgWinContentErr->xLeftErrorList[iListCount].usiPxColX,
														 vpxImgWinContentErr->xLeftErrorList[iListCount].usiPxRowY,
														 vpxImgWinContentErr->xLeftErrorList[iListCount].usiPxValue);
//							#if DEBUG_ON
//							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
//								fprintf(fp, "\nHW LEFT ucDpktContentErrInjAddEntry Data\n" );
//								fprintf(fp, "HW Position X :%i\n", vpxImgWinContentErr->xLeftErrorList[iListCount].usiPxColX);
//								fprintf(fp, "HW Position Y :%i\n", vpxImgWinContentErr->xLeftErrorList[iListCount].usiPxRowY);
//								fprintf(fp, "HW Start Frame:%i\n", vpxImgWinContentErr->xLeftErrorList[iListCount].usiCountFrames);
//								fprintf(fp, "HW Stop  Frame:%i\n", vpxImgWinContentErr->xLeftErrorList[iListCount].usiFramesActive);
//								fprintf(fp, "HW Pixel Value:%i\n", vpxImgWinContentErr->xLeftErrorList[iListCount].usiPxValue);
//							}
//							#endif
						}
					}
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Finished adding image and window content error list to HW (left side)\n", ucFFeeInstL, ucAebInstL);
					}
					#endif
					if (bDpktContentErrInjCloseList(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket, eDpktCcdSideE)){
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content error list closed (left side)\n", ucFFeeInstL, ucAebInstL);
						}
						#endif
					} else {
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content error list closing problems (left side)\n", ucFFeeInstL, ucAebInstL);
						}
						#endif
					}
					bDpktGetLeftContentErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content number of entries = %u (left side)\n", ucFFeeInstL, ucAebInstL, (alt_u8)pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktLeftContentErrInj.ucErrorsCnt);
					}
					#endif
				}
			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content error list clear problem (left side)\n", ucFFeeInstL, ucAebInstL);
				}
				#endif
			}
		}

		// Side: 0 = Left; 1 = Right; 2 = Both
		if ((1 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
			qsort((TImgWinContentErrData *)(vpxImgWinContentErr->xRightErrorList), vpxImgWinContentErr->ucRightErrorCnt, sizeof(TImgWinContentErrData), iCompareImgWinContent);
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content error list sorted (right side)\n", ucFFeeInstL, ucAebInstL);
			}
			#endif

			if (bDpktContentErrInjClearEntries(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket, eDpktCcdSideF)) {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content error list cleared (right side)\n", ucFFeeInstL, ucAebInstL);
				}
				#endif
				if (bDpktContentErrInjOpenList(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket, eDpktCcdSideF)) {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content error list opened (right side)\n", ucFFeeInstL, ucAebInstL);
					}
					#endif
					if (vpxImgWinContentErr->ucRightErrorCnt > 0) {
						for (int iListCount=0; iListCount < vpxImgWinContentErr->ucRightErrorCnt; iListCount++) {
							ucDpktContentErrInjAddEntry( &pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket,
														 eDpktCcdSideF,
														 vpxImgWinContentErr->xRightErrorList[iListCount].usiCountFrames,
														 vpxImgWinContentErr->xRightErrorList[iListCount].usiFramesActive,
														 vpxImgWinContentErr->xRightErrorList[iListCount].usiPxColX,
														 vpxImgWinContentErr->xRightErrorList[iListCount].usiPxRowY,
														 vpxImgWinContentErr->xRightErrorList[iListCount].usiPxValue);
//							#if DEBUG_ON
//							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
//								fprintf(fp, "\nHW RIGHT ucDpktContentErrInjAddEntry Data\n" );
//								fprintf(fp, "HW Position X :%i\n", vpxImgWinContentErr->xRightErrorList[iListCount].usiPxColX);
//								fprintf(fp, "HW Position Y :%i\n", vpxImgWinContentErr->xRightErrorList[iListCount].usiPxRowY);
//								fprintf(fp, "HW Start Frame:%i\n", vpxImgWinContentErr->xRightErrorList[iListCount].usiCountFrames);
//								fprintf(fp, "HW Stop  Frame:%i\n", vpxImgWinContentErr->xRightErrorList[iListCount].usiFramesActive);
//								fprintf(fp, "HW Pixel Value:%i\n", vpxImgWinContentErr->xRightErrorList[iListCount].usiPxValue);
//							}
//							#endif
						}
					}
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Finished adding image and window content error list to HW (right side)\n", ucFFeeInstL, ucAebInstL);
					}
					#endif
					if (bDpktContentErrInjCloseList(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket, eDpktCcdSideF)){
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content error list closed (right side)\n", ucFFeeInstL, ucAebInstL);
						}
						#endif
					} else {
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content error list closing problems (right side)\n", ucFFeeInstL, ucAebInstL);
						}
						#endif
					}
					bDpktGetRightContentErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content number of entries = %u (right side)\n", ucFFeeInstL, ucAebInstL, (alt_u8)pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktRightContentErrInj.ucErrorsCnt);
					}
					#endif
				}
			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content error list clear problem (right side)\n", ucFFeeInstL, ucAebInstL);
				}
				#endif
			}
		}

		break;

	/* TC_SCAMxx_IMGWIN_CONTENT_ERR_CLEAR */
	case 75:
		ucFeeParamL = (unsigned char)xPusL->usiValues[0];
		ucFFeeInstL = ucFeeParamL/N_OF_CCD;
		ucAebInstL = ucFeeParamL%N_OF_CCD;
		vpxImgWinContentErr = &(pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xImgWinContentErr);

		usiCfgPxSide = xPusL->usiValues[1];

		// Side: 0 = Left; 1 = Right; 2 = Both
		if ((0 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
			if (bDpktContentErrInjClearEntries(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket, eDpktCcdSideE)) {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window error list cleared (left side)\n", ucFFeeInstL, ucAebInstL);
				}
				#endif

			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window error list not cleared in HW (left side)\n", ucFFeeInstL, ucAebInstL);
				}
				#endif
			}
			vpxImgWinContentErr->ucLeftErrorCnt = 0;
		}

		// Side: 0 = Left; 1 = Right; 2 = Both
		if ((1 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
			if (bDpktContentErrInjClearEntries(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket, eDpktCcdSideF)) {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window error list cleared (right side)\n", ucFFeeInstL, ucAebInstL);
				}
				#endif

			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window error list not cleared in HW (right side)\n", ucFFeeInstL, ucAebInstL);
				}
				#endif
			}
			vpxImgWinContentErr->ucRightErrorCnt = 0;
		}

		break;

	/* TC_SCAMxx_DATA_PKT_ERR_CONFIG */
	case 78:
		ucFeeParamL = (unsigned char)xPusL->usiValues[0];
		ucFFeeInstL = ucFeeParamL/N_OF_CCD;
		ucAebInstL = ucFeeParamL%N_OF_CCD;
		vpxDataPktError = &(pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xDataPktError);

		alt_u16 usiCfgFrameCounter    = xPusL->usiValues[1];
		alt_u16 usiCfgSequenceCounter = xPusL->usiValues[2];
		alt_u16 usiCfgFieldId         = xPusL->usiValues[3];
		alt_u16 usiCfgFieldValue      = xPusL->usiValues[4];

		if (10 >= vpxDataPktError->ucErrorCnt) {
			vpxDataPktError->xErrorList[vpxDataPktError->ucErrorCnt].usiFrameCounter    = usiCfgFrameCounter;
			vpxDataPktError->xErrorList[vpxDataPktError->ucErrorCnt].usiSequenceCounter = usiCfgSequenceCounter;
			vpxDataPktError->xErrorList[vpxDataPktError->ucErrorCnt].usiFieldId         = usiCfgFieldId;
			vpxDataPktError->xErrorList[vpxDataPktError->ucErrorCnt].usiFieldValue      = usiCfgFieldValue;
			vpxDataPktError->ucErrorCnt++;
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Data packet error added to list. Number of entries = %u\n", ucFFeeInstL, ucAebInstL, vpxDataPktError->ucErrorCnt);
			}
			#endif
		} else {
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Data packet error list already have 10 entries\n", ucFFeeInstL, ucAebInstL);
			}
			#endif
		}
		break;

	/* TC_SCAMxx_DATA_PKT_ERR_CONFIG_FINISH */
	case 79:
		ucFeeParamL = (unsigned char)xPusL->usiValues[0];
		ucFFeeInstL = ucFeeParamL/N_OF_CCD;
		ucAebInstL = ucFeeParamL%N_OF_CCD;
		vpxDataPktError = &(pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xDataPktError);

		if (vpxDataPktError->ucErrorCnt > 0){
			qsort ((TDataPktErrorData *)(vpxDataPktError->xErrorList), vpxDataPktError->ucErrorCnt, sizeof(TDataPktErrorData), iCompareDataPktError);
		}
		if (bDpktHeaderErrInjClearEntries(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket)) {
			if (bDpktHeaderErrInjOpenList(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket)) {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Data packet error list opened\n", ucFFeeInstL, ucAebInstL);
				}
				#endif
				for (int iListCount = 0 ; iListCount < vpxDataPktError->ucErrorCnt; iListCount++){
					ucDpktHeaderErrInjAddEntry(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket,
												vpxDataPktError->xErrorList[iListCount].usiFrameCounter,
												vpxDataPktError->xErrorList[iListCount].usiSequenceCounter,
												vpxDataPktError->xErrorList[iListCount].usiFieldId,
												vpxDataPktError->xErrorList[iListCount].usiFieldValue);

				}
				if (&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket){
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Data packet error list closed. Finished adding errors to HW\n", ucFFeeInstL, ucAebInstL);
					}
					#endif
				}
			}
		} else {
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Data packet error list clear problem\n", ucFFeeInstL, ucAebInstL);
			}
			#endif
		}
		break;

	/* TC_SCAMxx_DATA_PKT_ERR_CLEAR */
	case 80:
		ucFeeParamL = (unsigned char)xPusL->usiValues[0];
		ucFFeeInstL = ucFeeParamL/N_OF_CCD;
		ucAebInstL = ucFeeParamL%N_OF_CCD;
		vpxDataPktError = &(pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xDataPktError);

		if (bDpktHeaderErrInjClearEntries(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket)) {
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Data packet error list cleared\n", ucFFeeInstL, ucAebInstL);
			}
			#endif
			vpxDataPktError->ucErrorCnt = 0;
		} else {
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Data packet error list clear problem\n", ucFFeeInstL, ucAebInstL);
			}
			#endif
		}
		break;
		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp, "MEB Task: Command not allowed in this mode\n\n" );
			}
			#endif
	}
}

void vPusType251conf( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {
	#if DEBUG_ON
	if ( xDefaults.ucDebugLevel <= dlMajorMessage )
		fprintf(fp, "MEB Task: Can't change the mode of the NFEE while MEB is Config mode\n\n" );
	#endif
}

void vPusType252conf( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {
	unsigned char ucFeeInstL;
	unsigned char ucAeb;

	ucFeeInstL = (unsigned char)xPusL->usiValues[0];
	switch (xPusL->usiSubType) {
		case 3: /* TC_SCAM_SPW_LINK_ENABLE */
		case 4: /* TC_SCAM_SPW_LINK_DISABLE */
		case 5: /* TC_SCAM_SPW_LINK_RESET */
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMajorMessage )
				fprintf(fp,"MEB Task: Can't perform this operation in the Link while Meb is Config mode \n\n");
			#endif
			break;
		case 2: /* TC_SCAM_SPW_RMAP_CONFIG_UPDATE */

			/* Update SpW Configurations */
			if (0 == xPusL->usiValues[1]) {
				/* Mode: Auto-Start */
				xConfSpw[ucFeeInstL].bSpwLinkStart = FALSE;
				xConfSpw[ucFeeInstL].bSpwLinkAutostart = TRUE;
			} else {
				/* Mode: Link Start */
				xConfSpw[ucFeeInstL].bSpwLinkStart = TRUE;
				xConfSpw[ucFeeInstL].bSpwLinkAutostart = TRUE;
			}
			xConfSpw[ucFeeInstL].ucSpwLinkSpeed = (alt_u8) xPusL->usiValues[2];
			xConfSpw[ucFeeInstL].ucLogicalAddr = (alt_u8) xPusL->usiValues[3];
			xConfSpw[ucFeeInstL].ucDpuLogicalAddr = (alt_u8) xPusL->usiValues[4];
			xConfSpw[ucFeeInstL].bTimeCodeTransmissionEn = (bool) xPusL->usiValues[5];
			xConfSpw[ucFeeInstL].ucRmapKey = (alt_u8) xPusL->usiValues[6];

			for (ucAeb = 0; N_OF_CCD > ucAeb; ucAeb++){
				/* Configure Spw Link */
				bSpwcGetLinkConfig(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire);
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire.xSpwcLinkConfig.bDisconnect = TRUE;
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire.xSpwcLinkConfig.bLinkStart = xConfSpw[ucFeeInstL].bSpwLinkStart;
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire.xSpwcLinkConfig.bAutostart = xConfSpw[ucFeeInstL].bSpwLinkAutostart;
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire.xSpwcLinkConfig.ucTxDivCnt = ucSpwcCalculateLinkDiv( xConfSpw[ucFeeInstL].ucSpwLinkSpeed );
				bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire);

				/* Configure Data Packet */
				bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xDataPacket);
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xConfSpw[ucFeeInstL].ucDpuLogicalAddr;
				bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xDataPacket);

				/* Configure TimeCode Transmission */
				bSpwcEnableTimecodeTrans(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire, xConfSpw[ucFeeInstL].bTimeCodeTransmissionEn );

				/* Disable the RMAP interrupt */
				bRmapGetIrqControl(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap);
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap.xRmapIrqControl.bWriteConfigEn = FALSE;
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap.xRmapIrqControl.bWriteWindowEn = FALSE;
				bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap);

				/* Change the RMAP configuration */
				bRmapGetCodecConfig( &pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap );
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap.xRmapCodecConfig.ucKey = xConfSpw[ucFeeInstL].ucRmapKey;
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap.xRmapCodecConfig.ucLogicalAddress = xConfSpw[ucFeeInstL].ucLogicalAddr;
				bRmapSetCodecConfig( &pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap );

				/* Enable the RMAP interrupt */
				bRmapGetIrqControl(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap);
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap.xRmapIrqControl.bWriteConfigEn = TRUE;
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap.xRmapIrqControl.bWriteWindowEn = TRUE;
				bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap);
			}

			/* todo: Need to treat all the returns */
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMinorMessage )
				fprintf(fp,"MEB Task: [FEE %u] SpaceWire/RMAP configurations changed - LINK_STARTED: %hu, LINK_AUTOSTART: %hu, LINK_SPEED: %hu, LOGICAL_ADDR: 0x%02X, DEST_NODE_ADDR: 0x%02X, TIME_CODE_GEN: %hu, RMAP_KEY: 0x%02X\n",
						ucFeeInstL, xConfSpw[ucFeeInstL].bSpwLinkStart, xConfSpw[ucFeeInstL].bSpwLinkAutostart, xConfSpw[ucFeeInstL].ucSpwLinkSpeed, xConfSpw[ucFeeInstL].ucLogicalAddr, xConfSpw[ucFeeInstL].ucDpuLogicalAddr, xConfSpw[ucFeeInstL].bTimeCodeTransmissionEn, xConfSpw[ucFeeInstL].ucRmapKey);
			#endif
			break;

		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: Command not allowed in this mode\n\n" );
			#endif
	}
}

/* This function should treat the PUS command in the Running Mode, need check all the things that is possible to update in this mode */
void vPusMebInTaskRunningMode( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {

	switch (xPusL->usiType) {
		/* srv-Type = 250 */
		case 250:
			vPusType250run(pxMebCLocal, xPusL);
			break;
		/* srv-Type = 251 */
		case 251:
			if ( xGlobal.bSyncReset == FALSE ) {
				vPusType251run(pxMebCLocal, xPusL);
			}
			break;
		/* srv-Type = 252 */
		case 252:
			vPusType252run(pxMebCLocal, xPusL);
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: Srv-Type not allowed in this mode (RUN)\n\n" );
			#endif
	}
}


void vPusType250run( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {
	unsigned char ucFeeParamL,ucFFeeInstL,ucAebInstL;
	unsigned char ucDTSourceL;
	unsigned char ucShutDownI = 0;
	alt_u16 usiCfgPxSide       = 0;

	switch (xPusL->usiSubType) {
		/* TC_SCAMxx_FEE_FGS_ON */
		case 86:
			vFtdiEnableImagettes(TRUE);
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMinorMessage )
				fprintf(fp, "MEB Task: FGS feature is on\n\n" );
			#endif
		break;
		/* TC_SCAMxx_FEE_FGS_OFF */
		case 87:
			vFtdiEnableImagettes(FALSE);
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMinorMessage )
				fprintf(fp, "MEB Task: FGS feature is off\n\n" );
			#endif
		break;
		/* TC_SCAMxx_SYNCH_RST [bndky] */
		case 31:
			if ( xGlobal.bSyncReset == FALSE ) {
				/* Send the wait time info to the sync reset function*/
				vSyncReset( xPusL->usiValues[0], &(pxMebCLocal->xFeeControl)  );
			}
		break;
		/* TC_SCAMxx_RMAP_ECHO_ENABLE */
		case 36:
//			usiFeeInstL = xPusL->usiValues[0];
//			pxMebCLocal->xFeeControl.xFfee[usiFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingModeEn = TRUE;
//			pxMebCLocal->xFeeControl.xFfee[usiFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingIdEn = xPusL->usiValues[1];
//			bRmapSetEchoingMode(&pxMebCLocal->xFeeControl.xFfee[usiFeeInstL].xChannel.xRmap);
//			#if DEBUG_ON
//			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ){
//				fprintf(fp, "usiValues[0]: %hu;\n", xPusL->usiValues[0] );
//				fprintf(fp, "usiValues[1]: %hu;\n", xPusL->usiValues[1] );
//				fprintf(fp, "usiFeeInstL : %hu;\n", usiFeeInstL 		);
//			}
//			#endif
		break;
		/* TC_SCAMxx_RMAP_ECHO_DISABLE */
		case 37:
//			usiFeeInstL = xPusL->usiValues[0];
//			pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap.xRmapEchoingModeConfig.bRmapEchoingModeEn = FALSE;
//			bRmapSetEchoingMode(&pxMebCLocal->xFeeControl.xNfee[usiFeeInstL].xChannel.xRmap);
//			#if DEBUG_ON
//			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ){
//				fprintf(fp, "usiValues[0]: %hu;\n", xPusL->usiValues[0] );
//				fprintf(fp, "usiFeeInstL : %hu;\n", usiFeeInstL 		);
//			}
//			#endif
		break;
		/* TC_SCAMxx_EP_UPDATE  */
		case 44:
			pxMebCLocal->xDataControl.usiUpdatedEPn = xPusL->usiValues[0];
			pxMebCLocal->xDataControl.bEPnUpdated = TRUE;
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ){
				fprintf(fp, "MEB Task: Exposure Number updated to %u\n", xPusL->usiValues[0]);
			}
			#endif
			break;
		/* TC_SCAMXX_SPW_ERR_TRIG */
		case 46:
			ucFeeParamL = (unsigned char)xPusL->usiValues[0];
			ucFFeeInstL = ucFeeParamL/N_OF_CCD;
			ucAebInstL = ucFeeParamL%N_OF_CCD;
			/* Disconnect Error Injection */
			switch (xPusL->usiValues[3])
			{

				/* Exchange Level Error: Parity Error */
				case 0:
					/* Stop others SpW Errors */
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					/* Stop and correct SpW Destination Address Error */
					if (TRUE == pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn){
						pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn = FALSE;
						bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
						pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.ucOriginalDestAddr;
						bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					}
					/* Force the stop of any ongoing SpW Codec Errors */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					/* Wait SpW Codec Errors controller to be ready */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					while (FALSE == pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bErrInjReady) {
						bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					}
					/* Inject the selected SpW Codec Error */
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdParity;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Exchange Level Error - Parity Error\n" );
					}
					#endif
					break;

				/* Exchange Level Error: Disconnect Error */
				case 1:
					/* Stop others SpW Errors */
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					/* Stop and correct SpW Destination Address Error */
					if (TRUE == pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn){
						pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn = FALSE;
						bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
						pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.ucOriginalDestAddr;
						bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					}
					/* Force the stop of any ongoing SpW Codec Errors */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					/* Wait SpW Codec Errors controller to be ready */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					while (FALSE == pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bErrInjReady) {
						bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					}
					/* Inject the selected SpW Codec Error */
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdDiscon;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Exchange Level Error - Disconnect Error\n" );
					}
					#endif
					break;

				/* Exchange Level Error: Escape Sequence Error */
				case 2:
					/* Stop others SpW Errors */
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					/* Stop and correct SpW Destination Address Error */
					if (TRUE == pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn){
						pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn = FALSE;
						bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
						pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.ucOriginalDestAddr;
						bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					}
					/* Force the stop of any ongoing SpW Codec Errors */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					/* Wait SpW Codec Errors controller to be ready */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					while (FALSE == pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bErrInjReady) {
						bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					}
					/* Inject the selected SpW Codec Error */
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdEscape;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Exchange Level Error - Escape Sequence Error\n" );
					}
					#endif
					break;

				/* Exchange Level Error: Character Sequence Error */
				case 3:
					/* Stop others SpW Errors */
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					/* Stop and correct SpW Destination Address Error */
					if (TRUE == pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn){
						pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn = FALSE;
						bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
						pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.ucOriginalDestAddr;
						bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					}
					/* Force the stop of any ongoing SpW Codec Errors */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					/* Wait SpW Codec Errors controller to be ready */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					while (FALSE == pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bErrInjReady) {
						bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					}
					/* Inject the selected SpW Codec Error */
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdChar;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Exchange Level Error - Character Sequence Error\n" );
					}
					#endif
					break;

				/* Exchange Level Error: Credit Error */
				case 4:
					/* Stop others SpW Errors */
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					/* Stop and correct SpW Destination Address Error */
					if (TRUE == pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn){
						pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn = FALSE;
						bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
						pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.ucOriginalDestAddr;
						bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					}
					/* Force the stop of any ongoing SpW Codec Errors */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					/* Wait SpW Codec Errors controller to be ready */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					while (FALSE == pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bErrInjReady) {
						bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					}
					/* Inject the selected SpW Codec Error */
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdCredit;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Exchange Level Error - Character Sequence Error\n" );
					}
					#endif
					break;

				/* Network Level Error: EEP Received */
				case 5:
					/* Force the stop of any ongoing SpW Codec Errors */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					/* Stop and correct SpW Destination Address Error */
					if (TRUE == pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn){
						pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn = FALSE;
						bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
						pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.ucOriginalDestAddr;
						bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					}
					/* Inject selected SpW Error */
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = xPusL->usiValues[2];
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = xPusL->usiValues[1];
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Network Level Error - EEP Received\n" );
					}
					#endif
					break;

				/* Network Level Error: Invalid Destination Address */
				case 6:
					/* Force the stop of any ongoing SpW Codec Errors */
					bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
					bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					/* Stop others SpW Errors */
					bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
					bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					/* Stop and correct SpW Destination Address Error */
					if (TRUE == pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn){
						pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn = FALSE;
						bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
						pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.ucOriginalDestAddr;
						bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					}
					/* Inject selected SpW Error */
					bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.ucOriginalDestAddr = pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = (alt_u8)xPusL->usiValues[1];
					bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xSpacewireErrInj.bDestinationErrorEn = TRUE;
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Network Level Error - Invalid Destination Address\n" );
					}
					#endif
					break;

				default:
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "TC_SCAMxx_SPW_ERR_TRIG : Invalid Error\n" );
					}
					#endif
					break;
			}
			break;
		/* TC_SCAMXX_RMAP_ERR_TRIG */
		case 47:
				ucFeeParamL = (unsigned char)xPusL->usiValues[0];
				ucFFeeInstL = ucFeeParamL/N_OF_CCD;
				ucAebInstL = ucFeeParamL%N_OF_CCD;
				bDpktGetRmapErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
				pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktRmapErrInj.bTriggerErr = TRUE;
				pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktRmapErrInj.ucErrorId   = xPusL->usiValues[1];
				pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktRmapErrInj.uliValue    = (alt_u32)( (alt_u32)(xPusL->usiValues[2] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[3] & 0x0000ffff) );
				pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket.xDpktRmapErrInj.usiRepeats  = xPusL->usiValues[4];
				bDpktSetRmapErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket);
				#if DEBUG_ON
					fprintf(fp, "TC_SCAMxx_RMAP_ERR_TRIG\n" );
				#endif
			break;
		/* TC_SCAMXX_TICO_ERR_TRIG */
		case 48:
				ucFeeParamL = (unsigned char)xPusL->usiValues[0];
				ucFFeeInstL = ucFeeParamL/N_OF_CCD;
				ucAebInstL = ucFeeParamL%N_OF_CCD;

				switch (xPusL->usiValues[5]) {

				/* Time-Code Missing Error */
				case 0:
					bSpwcEnableTimecodeTrans(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire, FALSE);
					bSpwcGetTimecodeStatus(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xTimeCodeErrInj.bMissTC = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xTimeCodeErrInj.usiMissCount = xPusL->usiValues[4];
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_TICO_ERR_TRIG : Time-Code Missing Error\n" );
					}
					#endif
					break;

				/* Wrong Time-Code Error */
				case 1:
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire.xSpwcTimecodeConfig.ucTimeOffset = xPusL->usiValues[1];
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire);
					bSpwcGetTimecodeStatus(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xTimeCodeErrInj.bWrongTC = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xTimeCodeErrInj.usiWrongCount = xPusL->usiValues[4];
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xTimeCodeErrInj.usiWrongOffSet = xPusL->usiValues[1];
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_TICO_ERR_TRIG : Wrong Time-Code Error\n" );
					}
					#endif
					break;

				/* Unexpected Time-Code Error */
				case 2:
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire.xSpwcTimecodeConfig.uliSyncDelayValue = uliTimecodeCalcDelayMs((alt_u32)( (alt_u32)(xPusL->usiValues[2] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[3] & 0x0000ffff) ));
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xTimeCodeErrInj.usiWrongCount =   xPusL->usiValues[4];
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xTimeCodeErrInj.bUxp = TRUE;
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_TICO_ERR_TRIG : Unexpected Time-Code Error\n" );
					}
					#endif
					break;

				/* Jitter on Time-Code Error */
				case 3:
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire.xSpwcTimecodeConfig.uliSyncDelayValue = uliTimecodeCalcDelayMs((alt_u32)( (alt_u32)(xPusL->usiValues[2] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[3] & 0x0000ffff) ));
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xSpacewire);
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xTimeCodeErrInj.bJitter = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xTimeCodeErrInj.usiJitterCount = xPusL->usiValues[4];
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlMajorMessage ){
						fprintf(fp, "TC_SCAMxx_TICO_ERR_TRIG : Jitter on Time-Code Error\n" );
					}
					#endif
					break;

				/* Invalid Error Code */
				default:
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp, "TC_SCAMxx_TICO_ERR_TRIG : Invalid Error\n" );
					}
					#endif
					break;
				}

			break;
		/* TC_SCAM_FEE_HK_UPDATE_VALUE [bndky] */
		case 58:
			vSendHKUpdate(pxMebCLocal, xPusL);
			break;

		/* TC_SCAM_IMAGE_ERR_MISS_PKT_TRIG */
		case 49:
			ucFeeParamL = (unsigned char)xPusL->usiValues[0];
			ucFFeeInstL = ucFeeParamL/N_OF_CCD;
			ucAebInstL = ucFeeParamL%N_OF_CCD;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.bMissingPkts = TRUE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.usiSequenceCnt = xPusL->usiValues[2];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.usiNRepeat = xPusL->usiValues[3];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.usiDataCnt = xPusL->usiValues[4];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.bTxDisabled = FALSE;
			break;

		/* TC_SCAM_IMAGE_ERR_NOMOREPKT_TRIG  */
		case 50:
			ucFeeParamL = (unsigned char)xPusL->usiValues[0];
			ucFFeeInstL = ucFeeParamL/N_OF_CCD;
			ucAebInstL = ucFeeParamL%N_OF_CCD;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.bTxDisabled = TRUE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			break;

		/* TC_SCAM_WIN_ERR_MISS_PKT_TRIG */
		case 51:
			ucFeeParamL = (unsigned char)xPusL->usiValues[0];
			ucFFeeInstL = ucFeeParamL/N_OF_CCD;
			ucAebInstL = ucFeeParamL%N_OF_CCD;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.bMissingPkts = TRUE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.usiSequenceCnt = xPusL->usiValues[2];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.usiNRepeat = xPusL->usiValues[3];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.usiDataCnt = xPusL->usiValues[4];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.bTxDisabled = FALSE;
			// Enable Window List
			bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xFeeBuffer);
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xFeeBuffer.xFeebMachineControl.bWindowListEn = TRUE;
			bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xFeeBuffer);
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
				fprintf(fp,"\nTC_SCAM_WIN_ERR_MISS_PKT_TRIG\n");
			#endif
			break;

		/* TC_SCAM_WIN_ERR_NOMOREPKT_TRIG */
		case 52:
			ucFeeParamL = (unsigned char)xPusL->usiValues[0];
			ucFFeeInstL = ucFeeParamL/N_OF_CCD;
			ucAebInstL = ucFeeParamL%N_OF_CCD;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.bTxDisabled = TRUE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.bMissingData = FALSE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			// Enable Window List
			bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xFeeBuffer);
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xFeeBuffer.xFeebMachineControl.bWindowListEn = TRUE;
			bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xFeeBuffer);
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
				fprintf(fp,"\n TC_SCAM_WIN_ERR_NOMOREPKT_TRIG\n");
			#endif
			break;

		/* TC_SCAM_ERR_OFF */
		case 53:
			ucFeeParamL = (unsigned char)xPusL->usiValues[0];
			ucFFeeInstL = ucFeeParamL / N_OF_CCD;
			ucAebInstL = ucFeeParamL % N_OF_CCD;
			vErrorInjOff(pxMebCLocal, ucFFeeInstL, ucAebInstL);
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
				fprintf(fp,"TC_SCAM_ERR_OFF\n");
			#endif
			break;
		/* TC_SCAM_WIN_ERR_DISABLE_WIN_PROG */
		case 63:
			ucFeeParamL = (unsigned char)xPusL->usiValues[0];
			ucFFeeInstL = ucFeeParamL/N_OF_CCD;
			ucAebInstL = ucFeeParamL%N_OF_CCD;
			bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xFeeBuffer);
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xFeeBuffer.xFeebMachineControl.bWindowListEn = FALSE;
			bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xFeeBuffer);
			// Disable others windowing errors
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.bTxDisabled = FALSE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.bMissingData = FALSE;
			#if DEBUG_ON
				fprintf(fp, "\nTC_SCAM_WIN_ERR_DISABLE_WIN_PROG:%i\n", pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xFeeBuffer.xFeebMachineControl.bWindowListEn);
			#endif
			break;

		/* TC_SCAM_IMAGE_ERR_MISSDATA_TRIG */
		case 67:
			ucFeeParamL = (unsigned char)xPusL->usiValues[0];
			ucFFeeInstL = ucFeeParamL/N_OF_CCD;
			ucAebInstL = ucFeeParamL%N_OF_CCD;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.bMissingData = TRUE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.usiSequenceCnt = xPusL->usiValues[2];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.usiNRepeat = xPusL->usiValues[3];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.usiDataCnt = xPusL->usiValues[4];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlFull.bTxDisabled = FALSE;
			break;

		/* TC_SCAM_CONFIG */
		case 60:
			if ( xGlobal.bSyncReset == FALSE ) {
				pxMebCLocal->eMode = sMebToConfig;
			}
			break;
		/* TC_SCAM_TURNOFF */
		case 66:
			/*todo: Do nothing for now */
			/* Force all go to Config Mode */
			vEnterConfigRoutine(pxMebCLocal);

			/* Animate LED */
			/* Wait for N seconds */
			for (ucShutDownI = 0; ucShutDownI < N_SEC_WAIT_SHUTDOWN; ucShutDownI++) {

				bSetPainelLeds( LEDS_OFF , LEDS_ST_ALL_MASK );
				bSetPainelLeds( LEDS_ON , (LEDS_ST_1_MASK << ( ucShutDownI % 4 )) );

				OSTimeDlyHMSM(0,0,1,0);
			}

			/* Sinalize that can safely shutdown the Simucam */
			bSetPainelLeds( LEDS_ON , LEDS_ST_ALL_MASK );
			break;

		/* TC_SCAM_FEE_TIME_CONFIG */
		case 64:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: Command not allowed in this mode (RUN)\n" );
			#endif

			/* Code for test purposes, should always be disabled in a release! */
			#if DEV_MODE_ON
			//			ulEP= (alt_u32)( (alt_u32)(xPusL->usiValues[0] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[1] & 0x0000ffff) );
			//			ulStart= (alt_u32)( (alt_u32)(xPusL->usiValues[2] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[3] & 0x0000ffff) );
			//			ulPx= (alt_u32)( (alt_u32)(xPusL->usiValues[4] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[5] & 0x0000ffff) );
			//			ulLine= (alt_u32)( (alt_u32)(xPusL->usiValues[6] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[7] & 0x0000ffff) );

			vRmapDummyCmd(RMAP_DCC_DTC_FEE_MOD_ADR);
			pxMebCLocal->xFeeControl.xFfee[0].xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod = (alt_u8)((alt_u32)( (alt_u32)(xPusL->usiValues[2] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[3] & 0x0000ffff) ));

			pxMebCLocal->xFeeControl.xFfee[0].xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc = (alt_u8)((alt_u32)( (alt_u32)(xPusL->usiValues[2] & 0x0000ffff)<<16 | (alt_u32)(xPusL->usiValues[3] & 0x0000ffff) ));
			vRmapDummyCmd(RMAP_DGC_DTC_TRG_25S_ADR);
			fprintf(fp, "Data: %u\n", (alt_u8)(pxMebCLocal->xFeeControl.xFfee[0].xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc) );
			#endif

			break;

		/* TC_SCAM_FEE_DATA_SOURCE */
		case 70:
			ucFFeeInstL = (unsigned char)xPusL->usiValues[0];
			ucDTSourceL = (unsigned char)xPusL->usiValues[1];
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
				fprintf(fp,"MEB Task: DATA_SOURCE usiFeeInstL= %hhu, ucDTSourceL= %hhu\n",ucFFeeInstL,ucDTSourceL  );
			#endif
			vSendCmdQToNFeeCTRL_GEN(ucFFeeInstL, M_FEE_DT_SOURCE, ucDTSourceL, ucDTSourceL );
			break;

		/* TC_SCAM_WIN_ERR_MISSDATA_TRIG */
		case 72:
			ucFeeParamL = (unsigned char)xPusL->usiValues[0];
			ucFFeeInstL = ucFeeParamL/N_OF_CCD;
			ucAebInstL = ucFeeParamL%N_OF_CCD;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.bMissingData = TRUE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.ucFrameNum = (unsigned char)xPusL->usiValues[1];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.usiSequenceCnt = xPusL->usiValues[2];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.usiNRepeat = xPusL->usiValues[3];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.usiDataCnt = xPusL->usiValues[4];
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.bMissingPkts = FALSE;
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xErrorSWCtrlWin.bTxDisabled = FALSE;
			// Enable Window List
			bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xFeeBuffer);
			pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xFeeBuffer.xFeebMachineControl.bWindowListEn = TRUE;
			bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xFeeBuffer);
			#if DEBUG_ON
				fprintf(fp, "\nTC_SCAM_WIN_ERR_MISSDATA_TRIG\n" );
			#endif
			break;

		case 76: /* TC_SCAMxx_IMGWIN_CONTENT_ERR_START_INJ */
			ucFeeParamL = (unsigned char)xPusL->usiValues[0];
			ucFFeeInstL = ucFeeParamL/N_OF_CCD;
			ucAebInstL = ucFeeParamL%N_OF_CCD;
			vpxImgWinContentErr = &(pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xImgWinContentErr);

			usiCfgPxSide = xPusL->usiValues[1];

			// Side: 0 = Left; 1 = Right; 2 = Both
			if ((0 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
				vpxImgWinContentErr->bStartLeftErrorInj = TRUE;

				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content error injection scheduled (left side)\n", ucFFeeInstL, ucAebInstL);
				#endif
			}

			// Side: 0 = Left; 1 = Right; 2 = Both
			if ((1 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
				vpxImgWinContentErr->bStartRightErrorInj = TRUE;

				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window content error injection scheduled (right side)\n", ucFFeeInstL, ucAebInstL);
				#endif
			}

			break;

		case 77: /* TC_SCAMxx_IMGWIN_CONTENT_ERR_STOP_INJ */
			ucFeeParamL = (unsigned char)xPusL->usiValues[0];
			ucFFeeInstL = ucFeeParamL/N_OF_CCD;
			ucAebInstL = ucFeeParamL%N_OF_CCD;

			usiCfgPxSide = xPusL->usiValues[1];

			// Side: 0 = Left; 1 = Right; 2 = Both
			if ((0 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
				if ( bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket, eDpktCcdSideE) ) {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
						fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window error injection stopped (left side)\n", ucFFeeInstL, ucAebInstL);
					#endif
				} else {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
						fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window error was not injecting or injection had finished (left side)\n", ucFFeeInstL, ucAebInstL);
					#endif
				}
			}

			// Side: 0 = Left; 1 = Right; 2 = Both
			if ((1 == usiCfgPxSide) || (2 == usiCfgPxSide)) {
				if ( bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket, eDpktCcdSideF) ) {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
						fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window error injection stopped (right side)\n", ucFFeeInstL, ucAebInstL);
					#endif
				} else {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
						fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Image and window error was not injecting or injection had finished (right side)\n", ucFFeeInstL, ucAebInstL);
					#endif
				}
			}

			break;

		case 81: /* TC_SCAMxx_DATA_PKT_ERR_START_INJ */
			ucFeeParamL = (unsigned char)xPusL->usiValues[0];
			ucFFeeInstL = ucFeeParamL/N_OF_CCD;
			ucAebInstL = ucFeeParamL%N_OF_CCD;
			vpxDataPktError = &(pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xErrorInjControl[ucAebInstL].xDataPktError);

			vpxDataPktError->bStartErrorInj = TRUE;

			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Data packet error injection scheduled\n", ucFFeeInstL, ucAebInstL);
			#endif

			break;

		case 82: /* TC_SCAMxx_DATA_PKT_ERR_STOP_INJ */
			ucFeeParamL = (unsigned char)xPusL->usiValues[0];
			ucFFeeInstL = ucFeeParamL/N_OF_CCD;
			ucAebInstL = ucFeeParamL%N_OF_CCD;
			if ( bDpktHeaderErrInjStopInj(&pxMebCLocal->xFeeControl.xFfee[ucFFeeInstL].xChannel[ucAebInstL].xDataPacket) ) {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Data packet error injection stopped\n", ucFFeeInstL, ucAebInstL);
				#endif
			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp, "MEB Task: [FEE %u] [AEB %u] Data packet error was not injecting or injection had finished\n", ucFFeeInstL, ucAebInstL);
				#endif
			}
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: Command not allowed in this mode (RUN)\n\n" );
			#endif
	}
}

void vPusType251run( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {
	unsigned char usiFeeInstL, ucAebInst, ucAebState;

	usiFeeInstL = (unsigned char)xPusL->usiValues[0];
	switch (xPusL->usiSubType) {
		/* TC_SCAM_FEE_CONFIG_ENTER */
		case 1:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(usiFeeInstL, M_FEE_CONFIG, 0, usiFeeInstL );
			break;
		/* TC_SCAM_FEE_STANDBY_ENTER */
		case 2:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(usiFeeInstL, M_FEE_STANDBY, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_FULLIMAGE_ENTER */
		case 3:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(usiFeeInstL, M_FEE_FULL, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_WINDOWING _ENTER */
		case 4:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(usiFeeInstL, M_FEE_WIN, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_FULLIMAGE_PATTERN_ENTER */
		case 5:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(usiFeeInstL, M_FEE_FULL_PATTERN, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_WINDOWING_PATTERN_ENTER */
		case 6:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(usiFeeInstL, M_FEE_WIN_PATTERN, 0, usiFeeInstL );
			break;
		/* NFEE_ON */
		case 11:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(usiFeeInstL, M_FEE_ON, 0, usiFeeInstL );
			break;
		case 12:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(usiFeeInstL, M_FEE_PAR_TRAP_1, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_PARALLEL_TRAP_PUMP_2_ENTER */
		case 13:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(usiFeeInstL, M_FEE_PAR_TRAP_2, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_SERIAL_TRAP_PUMP_1_ENTER */
		case 14:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(usiFeeInstL, M_FEE_SERIAL_TRAP_1, 0, usiFeeInstL );
			break;
		/* NFEE_RUNNING_SERIAL_TRAP_PUMP_2_ENTER */
		case 15:
			/* Using QMASK send to NfeeControl that will foward */
			vSendCmdQToNFeeCTRL_GEN(usiFeeInstL, M_FEE_SERIAL_TRAP_2, 0, usiFeeInstL );
			break;
		case 16:
			ucAebInst = (unsigned char)xPusL->usiValues[1];
			ucAebState = (unsigned char)xPusL->usiValues[2];

			pxMebCLocal->xFeeControl.xFfee[usiFeeInstL].xChannel[ucAebInst].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebInst]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
			pxMebCLocal->xFeeControl.xFfee[usiFeeInstL].xChannel[ucAebInst].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebInst]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucAebState;

			switch (ucAebState) {
				case 0b0000: /*AEB_STATE_OFF*/
					pxMebCLocal->xFeeControl.xFfee[usiFeeInstL].xControl.xAeb[ucAebInst].eState = sAebOFF;
					break;
				case 0b0001: /*AEB_STATE_INIT*/
					pxMebCLocal->xFeeControl.xFfee[usiFeeInstL].xControl.xAeb[ucAebInst].eState = sAebInit;
					break;
				case 0b0010: /*AEB_STATE_CONFIG*/
					pxMebCLocal->xFeeControl.xFfee[usiFeeInstL].xControl.xAeb[ucAebInst].eState = sAebConfig;
					break;
				case 0b00011: /*AEB_STATE_IMAGE*/
					pxMebCLocal->xFeeControl.xFfee[usiFeeInstL].xControl.xAeb[ucAebInst].eState = sAebImage;
					break;
				case 0b0100: /*AEB_STATE_POWER_DOWN*/
				case 0b0101: /*AEB_STATE_POWER_*/
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"AEB (%hhu) - AEB_STATE_POWER is only Intermediate state\n\n", ucAebInst);
					}
					#endif
					break;
				case 0b0110: /*AEB_STATE_PATTERN*/
					pxMebCLocal->xFeeControl.xFfee[usiFeeInstL].xControl.xAeb[ucAebInst].eState = sAebPattern;
					break;
				case 0b0111: /*AEB_STATE_FAILURE*/
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"AEB (%hhu) - PUS: Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucAebInst);
					}
					#endif
					break;
				default:
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"AEB (%hhu) - PUS: Invalid AEB STATE\n\n", ucAebInst);
					}
					#endif
			}

			break;
		case 0:
		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
				fprintf(fp, "MEB Task: Command not implemented yet (SubType:%hu)\n\n",xPusL->usiSubType );
			#endif
	}
}

void vPusType252run( TSimucam_MEB *pxMebCLocal, tTMPus *xPusL ) {
	unsigned char ucFeeInstL;
	unsigned char ucAeb;

	ucFeeInstL = (unsigned char)xPusL->usiValues[0];
	switch (xPusL->usiSubType) {
		case 3: /* TC_SCAM_SPW_LINK_ENABLE */

			for (ucAeb = 0; N_OF_CCD > ucAeb; ucAeb++) {
				bSpwcGetLinkConfig(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire);
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire.xSpwcLinkConfig.bLinkStart = xConfSpw[ucFeeInstL].bSpwLinkStart;
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire.xSpwcLinkConfig.bAutostart = xConfSpw[ucFeeInstL].bSpwLinkAutostart;
				bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire);
			}

			if (bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[0].xSpacewire)){
				vSendEventLogArr(ucFeeInstL + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtSpwEnable]);
			} else {
				vSendEventLogArr(ucFeeInstL + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtSpwEnableErr]);
			}

			pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xControl.bChannelEnable = TRUE;

			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMinorMessage )
				fprintf(fp,"MEB Task: Link enable (NFEE-%hu)\n\n", ucFeeInstL);
			#endif
			break;

		case 4: /* TC_SCAM_SPW_LINK_DISABLE */

			for (ucAeb = 0; N_OF_CCD > ucAeb; ucAeb++) {
				bSpwcGetLinkConfig(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire);
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire.xSpwcLinkConfig.bDisconnect = TRUE;
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire.xSpwcLinkConfig.bLinkStart = FALSE;
				pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire.xSpwcLinkConfig.bAutostart = FALSE;
				bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire);
			}

			if (bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[0].xSpacewire)) {
				vSendEventLogArr(ucFeeInstL + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtSpwDisable]);
			} else {
				vSendEventLogArr(ucFeeInstL + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtSpwDisableErr]);
			}

			pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xControl.bChannelEnable = FALSE;

			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMinorMessage )
				fprintf(fp,"MEB Task: Link disable (NFEE-%hu)\n\n", ucFeeInstL);
			#endif
			break;

		case 5: /* TC_SCAM_SPW_LINK_RESET */
			/* todo:Do nothing, don't know what is reset spw link */
			break;

		case 2: /* TC_SCAM_SPW_RMAP_CONFIG_UPDATE */

			/* Can only update the configurations if the FEE is in off mode */
			if ( pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xControl.xDeb.eMode == sOFF ) {

				/* Update SpW Configurations */
				if (0 == xPusL->usiValues[1]) {
					/* Mode: Auto-Start */
					xConfSpw[ucFeeInstL].bSpwLinkStart = FALSE;
					xConfSpw[ucFeeInstL].bSpwLinkAutostart = TRUE;
				} else {
					/* Mode: Link Start */
					xConfSpw[ucFeeInstL].bSpwLinkStart = TRUE;
					xConfSpw[ucFeeInstL].bSpwLinkAutostart = TRUE;
				}
				xConfSpw[ucFeeInstL].ucSpwLinkSpeed = (alt_u8) xPusL->usiValues[2];
				xConfSpw[ucFeeInstL].ucLogicalAddr = (alt_u8) xPusL->usiValues[3];
				xConfSpw[ucFeeInstL].ucDpuLogicalAddr = (alt_u8) xPusL->usiValues[4];
				xConfSpw[ucFeeInstL].bTimeCodeTransmissionEn = (bool) xPusL->usiValues[5];
				xConfSpw[ucFeeInstL].ucRmapKey = (alt_u8) xPusL->usiValues[6];

				for (ucAeb = 0; N_OF_CCD > ucAeb; ucAeb++){
					/* Configure Spw Link */
					bSpwcGetLinkConfig(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire);
					pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire.xSpwcLinkConfig.bDisconnect = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire.xSpwcLinkConfig.bLinkStart = xConfSpw[ucFeeInstL].bSpwLinkStart;
					pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire.xSpwcLinkConfig.bAutostart = xConfSpw[ucFeeInstL].bSpwLinkAutostart;
					pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire.xSpwcLinkConfig.ucTxDivCnt = ucSpwcCalculateLinkDiv( xConfSpw[ucFeeInstL].ucSpwLinkSpeed );
					bSpwcSetLinkConfig(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire);

					/* Configure Data Packet */
					bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xDataPacket);
					pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xConfSpw[ucFeeInstL].ucDpuLogicalAddr;
					bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xDataPacket);

					/* Configure TimeCode Transmission */
					bSpwcEnableTimecodeTrans(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xSpacewire, xConfSpw[ucFeeInstL].bTimeCodeTransmissionEn );

					/* Disable the RMAP interrupt */
					bRmapGetIrqControl(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap);
					pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap.xRmapIrqControl.bWriteConfigEn = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap.xRmapIrqControl.bWriteWindowEn = FALSE;
					bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap);

					/* Change the RMAP configuration */
					bRmapGetCodecConfig( &pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap );
					pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap.xRmapCodecConfig.ucKey = xConfSpw[ucFeeInstL].ucRmapKey;
					pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap.xRmapCodecConfig.ucLogicalAddress = xConfSpw[ucFeeInstL].ucLogicalAddr;
					bRmapSetCodecConfig( &pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap );

					/* Enable the RMAP interrupt */
					bRmapGetIrqControl(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap);
					pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap.xRmapIrqControl.bWriteConfigEn = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap.xRmapIrqControl.bWriteWindowEn = TRUE;
					bRmapSetIrqControl(&pxMebCLocal->xFeeControl.xFfee[ucFeeInstL].xChannel[ucAeb].xRmap);
				}

				/* todo: Need to treat all the returns */
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMinorMessage )
					fprintf(fp,"MEB Task: [FEE %u] SpaceWire/RMAP configurations changed - LINK_STARTED: %hu, LINK_AUTOSTART: %hu, LINK_SPEED: %hu, LOGICAL_ADDR: 0x%02X, DEST_NODE_ADDR: 0x%02X, TIME_CODE_GEN: %hu, RMAP_KEY: 0x%02X\n",
							ucFeeInstL, xConfSpw[ucFeeInstL].bSpwLinkStart, xConfSpw[ucFeeInstL].bSpwLinkAutostart, xConfSpw[ucFeeInstL].ucSpwLinkSpeed, xConfSpw[ucFeeInstL].ucLogicalAddr, xConfSpw[ucFeeInstL].ucDpuLogicalAddr, xConfSpw[ucFeeInstL].bTimeCodeTransmissionEn, xConfSpw[ucFeeInstL].ucRmapKey);
				#endif
				break;

			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage )
					fprintf(fp,"MEB Task: NFEE-%hu is not in the Config Mode ( Changes not performed )\n\n", ucFeeInstL);
				#endif
			}
			break;

		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMajorMessage )
				fprintf(fp, "MEB Task: Command not allowed in this mode (RUN)\n\n" );
			#endif
			break;
	}
}

void vMebInit(TSimucam_MEB *pxMebCLocal) {
	INT8U errorCodeL;

	pxMebCLocal->ucActualDDR = 1;
	pxMebCLocal->ucNextDDR = 0;
	/* Flush all communication Queues */
	errorCodeL = OSQFlush(xMebQ);
	if ( errorCodeL != OS_NO_ERR ) {
		vFailFlushMEBQueue();
	}
}

/* Swap memory reference */
void vSwapMemmory(TSimucam_MEB *pxMebCLocal) {

	pxMebCLocal->ucActualDDR = (pxMebCLocal->ucActualDDR + 1) % 2 ;
	pxMebCLocal->ucNextDDR = (pxMebCLocal->ucNextDDR + 1) % 2 ;

}

/*This sequence is used more than one place, so it becomes a function*/
void vEnterConfigRoutine( TSimucam_MEB *pxMebCLocal ) {
	unsigned char ucFeeInstL, ucAebInstL;


	/* Stop the Sync (Stopping the simulation) */
	bStopSync();
	bClearSync();
	vSyncClearCounter();

	/* Give time to all tasks receive the command */
	OSTimeDlyHMSM(0, 0, 0, 5);

	pxMebCLocal->ucActualDDR = 1;
	pxMebCLocal->ucNextDDR = 0;
	/* Transition to Config Mode (Ending the simulation) */
	/* Send a message to the NFEE Controller forcing the mode */
//	vSendCmdQToNFeeCTRL_PRIO( M_NFC_CONFIG_FORCED, 0, 0 );
	vSendCmdQToNFeeCTRL_GEN(0, M_FEE_CONFIG_FORCED, 0, 0 ); /* Fix to send FEEs to Off - [rfranca] - TODO: check with Tiago how to properly do this */
	vSendCmdQToDataCTRL_PRIO( M_DATA_CONFIG_FORCED, 0, 0 );

	//vSendMessageNUCModeMEBChange( 1 ); /*1: Config*/

	/* Give time to all tasks receive the command */
	OSTimeDlyHMSM(0, 0, 0, 250);

	for (ucFeeInstL = 0; ucFeeInstL < N_OF_FastFEE; ucFeeInstL++) {
		for (ucAebInstL = 0; ucAebInstL < N_OF_CCD; ucAebInstL++) {
			vErrorInjOff(pxMebCLocal, ucFeeInstL, ucAebInstL);
		}
	}

	bDisableIsoDrivers();
	bDisableLvdsBoard();

	vChangeSyncRepeat(pxMebCLocal, 0);

}

void vSendMessageNUCModeMEBChange(  unsigned short int mode  ) {
	INT8U error_code, i;
	char cHeader[8] = "!M:%hhu:";
	char cBufferL[128] = "";

	sprintf( cBufferL, "%s%hu", cHeader, mode );


	/* Should send message to the NUc to inform the FEE mode */
	OSMutexPend(xMutexTranferBuffer, 0, &error_code); /*Blocking*/
	if (error_code == OS_ERR_NONE) {
		/* Got the Mutex */
		/*For now, will only get the first, not the packet that is waiting for longer time*/
		for( i = 0; i < N_128_SENDER; i++)
		{
            if ( xBuffer128_Sender[i].bInUse == FALSE ) {
                /* Locate a filled PreParsed variable in the array*/
            	/* Perform a copy to a local variable */
            	memcpy(xBuffer128_Sender[i].buffer_128, cBufferL, 128);
                xBuffer128_Sender[i].bInUse = TRUE;
                xBuffer128_Sender[i].bPUS = FALSE;
                break;
            }
		}
		OSMutexPost(xMutexTranferBuffer);
	} else {
		/* Couldn't get Mutex. (Should not get here since is a blocking call without timeout)*/
		vFailGetxMutexSenderBuffer128();
	}
}

/**
 * @name vSendHKUpdate
 * @author bndky
 * @brief Prepare the data and send to updateHK fukction
 * @ingroup rtos
 *
 * @param 	[in]	TSimucam_MEB 	*pxMebCLocal
 * @param	[in]	tTMPus 			*xPusL
 *
 * @retval void
 **/
void vSendHKUpdate(TSimucam_MEB *pxMebCLocal, tTMPus *xPusL){
	union HkValue u_HKValue;

	/* converting from usi to uli */
	u_HKValue.usiValues[0] = xPus->usiValues[3];
	u_HKValue.usiValues[1] = xPus->usiValues[2];

	vUpdateFeeHKValue(&pxMebCLocal->xFeeControl.xFfee[xPus->usiValues[0]], xPus->usiValues[1], u_HKValue.uliValue);
}

void vErrorInjOff(TSimucam_MEB *pxMebCLocal, alt_u8 ucFee, alt_u8 ucAeb) {

	bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire);
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire.xSpwcTimecodeConfig.ucTimeOffset = 0;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = FALSE;
	bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire);

	bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket);
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
	bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket);

	bDpktGetRmapErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket);
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket.xDpktRmapErrInj.bTriggerErr = FALSE;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket.xDpktRmapErrInj.ucErrorId = 0;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket.xDpktRmapErrInj.uliValue = 0;
	bDpktSetRmapErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket);
	bDpktRstRmapErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket);

	bFeebGetMachineControl(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xFeeBuffer);
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xFeeBuffer.xFeebMachineControl.bWindowListEn = TRUE;
	bFeebSetMachineControl(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xFeeBuffer);

	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xErrorSWCtrlFull.bTxDisabled = FALSE;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xErrorSWCtrlFull.bMissingPkts = FALSE;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xErrorSWCtrlFull.bMissingData = FALSE;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xErrorSWCtrlFull.ucFrameNum = 0;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xErrorSWCtrlFull.usiSequenceCnt = 0;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xErrorSWCtrlFull.usiNRepeat = 0;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xErrorSWCtrlFull.usiDataCnt = 0;

	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xErrorSWCtrlWin.bTxDisabled = FALSE;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xErrorSWCtrlWin.bMissingPkts = FALSE;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xErrorSWCtrlWin.bMissingData = FALSE;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xErrorSWCtrlWin.ucFrameNum = 0;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xErrorSWCtrlWin.usiSequenceCnt = 0;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xErrorSWCtrlWin.usiNRepeat = 0;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xErrorSWCtrlWin.usiDataCnt = 0;

	bDpktGetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket);
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket.xDpktSpacewireErrInj.bEepReceivedEn = FALSE;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket.xDpktSpacewireErrInj.usiSequenceCnt = 0;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket.xDpktSpacewireErrInj.usiNRepeat     = 0;
	bDpktSetSpacewireErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket);

	/* Force the stop of any ongoing SpW Codec Errors */
	bDpktGetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket);
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket.xDpktSpwCodecErrInj.bStartErrInj = FALSE;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket.xDpktSpwCodecErrInj.bResetErrInj = TRUE;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket.xDpktSpwCodecErrInj.ucErrInjErrCode = eDpktSpwCodecErrIdNone;
	bDpktSetSpwCodecErrInj(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket);

	/* Stop and correct SpW Destination Address Error */
	if (TRUE == pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xSpacewireErrInj.bDestinationErrorEn){
		pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xSpacewireErrInj.bDestinationErrorEn = FALSE;
		bDpktGetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket);
		pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xSpacewireErrInj.ucOriginalDestAddr;
		bDpktSetPacketConfig(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket);
	}

	bDpktHeaderErrInjStopInj(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket);
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xDataPktError.ucErrorCnt = 0;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xDataPktError.bStartErrorInj = FALSE;

	bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket, eDpktCcdSideE);
	bDpktContentErrInjStopInj(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xDataPacket, eDpktCcdSideF);
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xImgWinContentErr.bStartLeftErrorInj = FALSE;
	pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xImgWinContentErr.bStartRightErrorInj = FALSE;

}

void vTimeCodeMissCounter(TSimucam_MEB * pxMebCLocal) {
	alt_u8 ucFee = 0;
	alt_u8 ucAeb = 0;

	for ( ucFee = 0; ucFee < N_OF_FastFEE; ucFee++ ) {
		for ( ucAeb = 0; ucAeb < N_OF_CCD; ucAeb++ ) {
			if ( pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.bMissTC == TRUE ) {
				if ( pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.usiMissCount == 0 ){
					bSpwcEnableTimecodeTrans(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire, TRUE);
					pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.bMissTC = FALSE;
				} else {
					pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.usiMissCount--;
				}
			}

			if (pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.bWrongTC == TRUE) {
				if ((pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.usiWrongCount == 0)  ){
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire);
					pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire.xSpwcTimecodeConfig.ucTimeOffset = 0;
					pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = FALSE;
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire);
					pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.bWrongTC = FALSE;
				} else {
					pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.usiWrongCount--;
				}
			}

			if (pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.bUxp == TRUE)  {
				if (pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.usiUxpCount > 0) {
					pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.usiUxpCount--;
				} else {
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire);
					pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire.xSpwcTimecodeConfig.uliSyncDelayValue = 0;
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire);
					pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.bUxp = FALSE;
				}
			}

			if (pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.bJitter == TRUE)  {
				if (pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.usiJitterCount > 0) {
					pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.usiJitterCount--;
				} else {
					bSpwcGetTimecodeConfig(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire);
					pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire.xSpwcTimecodeConfig.bSyncTriggerEnable = TRUE;
					pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire.xSpwcTimecodeConfig.bSyncDelayTriggerEn = FALSE;
					pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire.xSpwcTimecodeConfig.uliSyncDelayValue = 0;
					bSpwcSetTimecodeConfig(&pxMebCLocal->xFeeControl.xFfee[ucFee].xChannel[ucAeb].xSpacewire);
					pxMebCLocal->xFeeControl.xFfee[ucFee].xErrorInjControl[ucAeb].xTimeCodeErrInj.bJitter = FALSE;
				}
			}
		}
	}

}

/* ImgWin Content Error Sort Function */
int iCompareImgWinContent (const void *cvpImgWinA, const void *cvpImgWinB) {
	int iCompResult = 0;
	/*
	 * Compare function need to return:
	 *   -- (return > 0) if (ImgWinA > ImgWinB)
	 *   -- (return == 0) if (ImgWinA == ImgWinB)
	 *   -- (return < 0) if (ImgWinA < ImgWinB)
	 */

	/*
	 * Content need to be sorted as:
	 *   -- 1st key: Y position
	 *   -- 2nd key: X position
	 */

	TImgWinContentErrData *pxImgWinA = (TImgWinContentErrData *)cvpImgWinA;
	TImgWinContentErrData *pxImgWinB = (TImgWinContentErrData *)cvpImgWinB;

	/* 1st key (Y position) compare */
	if (pxImgWinA->usiPxRowY > pxImgWinB->usiPxRowY) {
		/* (ImgWinA > ImgWinB) : (return > 0) */
		iCompResult = 1;
	} else if (pxImgWinA->usiPxRowY < pxImgWinB->usiPxRowY) {
		/* (ImgWinA < ImgWinB) : (return > 0) */
		iCompResult = -1;
	} else {
		/* 1st key (Y position) is the same */
		/* 2nd key (X position) compare */
		if (pxImgWinA->usiPxColX > pxImgWinB->usiPxColX) {
			/* (ImgWinA > ImgWinB) : (return > 0) */
			iCompResult = 1;
		} else if (pxImgWinA->usiPxColX < pxImgWinB->usiPxColX) {
			/* (ImgWinA < ImgWinB) : (return > 0) */
			iCompResult = -1;
		} else {
			/* 2nd key (X position) is the same */
			/* (ImgWinA == ImgWinB) : (return == 0) */
			iCompResult = 0;
		}
	}

    return (iCompResult);
}

/* Data Packet Error Sort Function */
int iCompareDataPktError (const void *cvpDataPktErrA, const void *cvpDataPktErrB) {
	int iCompResult = 0;
	/*
	 * Compare function need to return:
	 *   -- (return > 0) if (DataPktErrA > DataPktErrB)
	 *   -- (return == 0) if (DataPktErrA == DataPktErrB)
	 *   -- (return < 0) if (DataPktErrA < DataPktErrB)
	 */

	/*
	 * Content need to be sorted as:
	 *   -- 1st key: Frame Number
	 *   -- 2nd key: Sequence Counter
	 */

	TDataPktErrorData *pxDataPktErrA = (TDataPktErrorData *)cvpDataPktErrA;
	TDataPktErrorData *pxDataPktErrB = (TDataPktErrorData *)cvpDataPktErrB;

	/* 1st key (Frame Number) compare */
	if (pxDataPktErrA->usiFrameCounter > pxDataPktErrB->usiFrameCounter) {
		/* (DataPktErrA > DataPktErrB) : (return > 0) */
		iCompResult = 1;
	} else if (pxDataPktErrA->usiFrameCounter < pxDataPktErrB->usiFrameCounter) {
		/* (DataPktErrA < DataPktErrB) : (return > 0) */
		iCompResult = -1;
	} else {
		/* 1st key (Frame Number) is the same */
		/* 2nd key (Sequence Counter) compare */
		if (pxDataPktErrA->usiSequenceCounter > pxDataPktErrB->usiSequenceCounter) {
			/* (DataPktErrA > DataPktErrB) : (return > 0) */
			iCompResult = 1;
		} else if (pxDataPktErrA->usiSequenceCounter < pxDataPktErrB->usiSequenceCounter) {
			/* (DataPktErrA < DataPktErrB) : (return > 0) */
			iCompResult = -1;
		} else {
			/* 2nd key (Sequence Counter) is the same */
			/* (DataPktErrA == DataPktErrB) : (return == 0) */
			iCompResult = 0;
		}
	}

    return (iCompResult);
}

/* After stop the Sync signal generation, maybe some FEE task could be locked waiting for this signal. So we send to everyone, and after that they will flush the queue */
/* Don't need this function anymore... for now
void vReleaseSyncMessages(void) {
	unsigned char ucIL;
	unsigned char error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ulWord = 0;
	uiCmdtoSend.ucByte[2] = M_SYNC;

	for( ucIL = 0; ucIL < N_OF_NFEE; ucIL++ ){
		uiCmdtoSend.ucByte[3] = M_NFEE_BASE_ADDR + ucIL;
		error_codel = OSQPost(xWaitSyncQFee[ ucIL ], (void *)uiCmdtoSend.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendMsgSync( ucIL );
		}
	}
}
*/

void vManageSyncGenerator( TSimucam_MEB *pxMebCLocal ) {

	/* Check if the Sync Generator should be stopped */
	if (0 == pxMebCLocal->ucSyncNRepeat) {
		/* Sync Generator should be stopped */
		bSyncCtrHoldBlankPulse(TRUE);
	}
	/* Check if the Sync Generator should be running continuously */
	else if (255 == pxMebCLocal->ucSyncNRepeat) {
		/* Sync Generator should be running continuously */
		bSyncCtrHoldBlankPulse(FALSE);
	} else {
		/* Sync Generator should be running a set amount of pulses */
		/* Check if the amount of pulses is finished */
		if (0 == pxMebCLocal->ucSyncRepeatCnt) {
			/* The amount of pulses is finished */
			bSyncCtrHoldBlankPulse(TRUE);
		} else {
			/* The amount of pulses is not finished */
			bSyncCtrHoldBlankPulse(FALSE);
			pxMebCLocal->ucSyncRepeatCnt--;
		}
	}

}
