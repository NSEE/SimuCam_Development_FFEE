/*
 * fee_taskV2.c
 *
 *  Created on: 22 de ago de 2019
 *      Author: Tiago-note
 */


#include "fee_taskV3.h"



void vFeeTaskV3(void *task_data) {
	TFFee *pxNFee;
	INT8U error_code;
	volatile INT8U ucRetries;
	tQMask uiCmdFEE;
	volatile TAEBTransmission xTrans[N_OF_CCD];
	unsigned char ucIL, ucChan;
	TtInMode xTinMode[8];
	unsigned char ucSwpIdL, ucSwpSideL, ucAebIdL, ucCcdSideL;
	unsigned short int usiSpwPLengthL;

	/* Fee Instance Data Structure */
	pxNFee = ( TFFee * ) task_data;

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
		fprintf(fp,"Fast FEE %hhu Task. (Task on)\n", pxNFee->ucId);
	}
	#endif

	for(;;){

		switch (pxNFee->xControl.xDeb.eState) {
			case sInit:

				usiSpwPLengthL = xDefaults.usiSpwPLength;

				/*todo: get from default*/
				pxNFee->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bEnable = TRUE;
				pxNFee->xChannel[1].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFee->xChannel[2].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFee->xChannel[3].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;

				for (ucIL=0; ucIL < 8; ucIL++){
					xTinMode[ucIL].ucAebNumber = 0;
					xTinMode[ucIL].bSideCcd = 0;
					xTinMode[ucIL].ucSpWChannel = 0;
					xTinMode[ucIL].bDataOn = FALSE;
					xTinMode[ucIL].bPattern = FALSE;
					xTinMode[ucIL].bSent = FALSE;
				}

				/*Fixed in the ICD*/
				xTinMode[7].ucSideSpw = 1; /*Right*/
				xTinMode[6].ucSideSpw = 0; /*Left*/
				xTinMode[5].ucSideSpw = 1; /*Right*/
				xTinMode[4].ucSideSpw = 0; /*Left*/
				xTinMode[3].ucSideSpw = 1; /*Right*/
				xTinMode[2].ucSideSpw = 0; /*Left*/
				xTinMode[1].ucSideSpw = 1; /*Right*/
				xTinMode[0].ucSideSpw = 0; /*Left*/

				xTinMode[7].ucSpWChannel = 3;
				xTinMode[6].ucSpWChannel = 3;
				xTinMode[5].ucSpWChannel = 2;
				xTinMode[4].ucSpWChannel = 2;
				xTinMode[3].ucSpWChannel = 1;
				xTinMode[2].ucSpWChannel = 1;
				xTinMode[1].ucSpWChannel = 0;
				xTinMode[0].ucSpWChannel = 0;


				/* Flush the queue */
				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR )
					vFailFlushNFEEQueue();

				/*Initializing the HW DataPacket*/
				vInitialConfig_DpktPacket( pxNFee );

				/* Change the configuration of RMAP for a particular FEE*/
				vInitialConfig_RMAPCodecConfig( pxNFee );

				/*0..2255*/
				pxNFee->xCommon.ulVStart = 0;
				pxNFee->xCommon.ulVEnd = pxNFee->xCcdInfo.usiHeight + pxNFee->xCcdInfo.usiOLN;
				/*0..2294*/
				pxNFee->xCommon.ulHStart = 0;
				pxNFee->xCommon.ulHEnd = pxNFee->xCcdInfo.usiHalfWidth + pxNFee->xCcdInfo.usiSPrescanN + pxNFee->xCcdInfo.usiSOverscanN;

				for (ucIL=0; ucIL < 4; ucIL++ ){
					bDpktGetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);
					pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiCcdVStart = 0;
					pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiCcdVEnd = pxNFee->xCommon.ulVEnd;
					bDpktSetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);

					bFeebGetMachineControl(&pxNFee->xChannel[ucIL].xFeeBuffer);
					//pxFeebCh->xWindowingConfig.bMasking = DATA_PACKET;/* True= data packet;    FALSE= Transparent mode */
					pxNFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bBufferOverflowEn = xDefaults.bBufferOverflowEn;
					pxNFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bDigitaliseEn = TRUE;
					pxNFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bReadoutEn = TRUE;
					pxNFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
					bFeebSetMachineControl(&pxNFee->xChannel[ucIL].xFeeBuffer);

					/* Clear all FEE Machine Statistics */
					bFeebClearMachineStatistics(&pxNFee->xChannel[ucIL].xFeeBuffer);
				}

				pxNFee->xControl.xDeb.eState = sOFF;
				break;

			case sOFF_Enter:/* Transition */

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: Config Mode\n", pxNFee->ucId);
				}
				#endif

				/* If a transition to On was requested when the FEE is waiting to go to Calibration,
				 * configure the hardware to not send any data in the next sync */
				for (ucIL=0; ucIL < 4; ucIL++ ){
					bDpktGetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);
					bDpktGetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);
					pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
					pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
					bDpktSetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);

					/* Disable the link SPW */
					bDisableSPWChannel( &pxNFee->xChannel[ucIL].xSpacewire );
					/* Disable RMAP interrupts */
					bDisableRmapIRQ(&pxNFee->xChannel[ucIL].xRmap, pxNFee->ucSPWId[ucIL]);

					/* Reset Channel DMAs */
					bSdmaResetChDma(pxNFee->ucSPWId[ucIL], eSdmaLeftBuffer, TRUE);
					bSdmaResetChDma(pxNFee->ucSPWId[ucIL], eSdmaRightBuffer, TRUE);

					/* Disable IRQ and clear the Double Buffer */
					bDisAndClrDbBuffer(&pxNFee->xChannel[ucIL].xFeeBuffer);
				}
				pxNFee->xControl.bChannelEnable = FALSE;

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: OFF\n", pxNFee->ucId);
				}
				#endif


				/* End of simulation! Clear everything that is possible */
				pxNFee->xControl.bWatingSync = FALSE;
				pxNFee->xControl.bSimulating = FALSE;
				pxNFee->xControl.bUsingDMA = FALSE;
				pxNFee->xControl.bTransientMode = TRUE;

				/*Clear all control variables that control the data in the RAM for this FEE*/
				vResetMemCCDFEE(pxNFee);

				/*Clear the queue message for this FEE*/
				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				ucRetries = 0;

				pxNFee->xControl.xDeb.ucTimeCode = 0;
				for (ucIL=0; ucIL < 4; ucIL++ ){
					pxNFee->xControl.xAeb[ucIL].bSwitchedOn = FALSE;
					pxNFee->xControl.xAeb[ucIL].eState = sAebOFF;
				}


				/* Real Fee State (graph) */
				pxNFee->xControl.xDeb.eLastMode = sInit;
				pxNFee->xControl.xDeb.eMode = sOFF;
				pxNFee->xControl.xDeb.eNextMode = sOFF;
				/* Real State */

				pxNFee->xControl.xDeb.eState = sOFF;
				break;

			case sOFF:

				/*Wait for message in the Queue*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinConfig( pxNFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}
				break;


			case sOn_Enter:

				/*Clear the queue message for this FEE*/
				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				for (ucIL=0; ucIL < 4; ucIL++ ){
					/* Write in the RMAP - UCL- NFEE ICD p. 49*/
					bRmapGetRmapMemCfgArea(&pxNFee->xChannel[ucIL].xRmap);
					pxNFee->xChannel[ucIL].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod  = 7; /*On mode*/
					bRmapSetRmapMemCfgArea(&pxNFee->xChannel[ucIL].xRmap);

					/* If a transition to On was requested when the FEE is waiting to go to Calibration,
					 * configure the hardware to not send any data in the next sync */
					bDpktGetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);
					pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOn;
					pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOn;
					bDpktSetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);

					/* Reset Channel DMAs */
					bSdmaResetChDma(pxNFee->ucSPWId[ucIL], eSdmaLeftBuffer, TRUE);
					bSdmaResetChDma(pxNFee->ucSPWId[ucIL], eSdmaRightBuffer, TRUE);

					/* Disable IRQ and clear the Double Buffer */
					bDisAndClrDbBuffer(&pxNFee->xChannel[ucIL].xFeeBuffer);

					/* Enable RMAP interrupts */
					bEnableRmapIRQ(&pxNFee->xChannel[ucIL].xRmap, pxNFee->ucId);

					/* Enable the link SPW */
					bEnableSPWChannel( &pxNFee->xChannel[ucIL].xSpacewire );
				}

				pxNFee->xControl.bChannelEnable = TRUE;

				/*Enabling some important variables*/
				pxNFee->xControl.bSimulating = TRUE;
				pxNFee->xControl.bUsingDMA = FALSE;

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: On Mode\n", pxNFee->ucId);
				}
				#endif

				pxNFee->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFee->xControl.xDeb.eLastMode = pxNFee->xControl.xDeb.eMode;
				pxNFee->xControl.xDeb.eMode = sOn;
				pxNFee->xControl.xDeb.eNextMode = sOn;


				/* Real State */
				pxNFee->xControl.xDeb.eState = sOn;
				break;

			case sOn:
				/*Wait for commands in the Queue*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinOn( pxNFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}
				break;


			case sStandBy_Enter:

				for (ucIL=0; ucIL < 4; ucIL++ ){
					/* Write in the RMAP - UCL- NFEE ICD p. 49*/
					bRmapGetRmapMemCfgArea(&pxNFee->xChannel[ucIL].xRmap);
					pxNFee->xChannel[ucIL].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod  = 6; /*sFeeStandBy*/
					bRmapSetRmapMemCfgArea(&pxNFee->xChannel[ucIL].xRmap);

					/* Disable IRQ and clear the Double Buffer */
					bDisAndClrDbBuffer(&pxNFee->xChannel[ucIL].xFeeBuffer);

					/* Disable RMAP interrupts */
					bEnableRmapIRQ(&pxNFee->xChannel[ucIL].xRmap, pxNFee->ucId);

					/* Enable the link SPW */
					bEnableSPWChannel( &pxNFee->xChannel[ucIL].xSpacewire );
				}

				pxNFee->xControl.bChannelEnable = TRUE;

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: Standby\n", pxNFee->ucId);
				}
				#endif

				pxNFee->xControl.bUsingDMA = FALSE;

				pxNFee->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxNFee->xControl.xDeb.eLastMode = pxNFee->xControl.xDeb.eMode;
				pxNFee->xControl.xDeb.eMode = sStandBy;
				pxNFee->xControl.xDeb.eNextMode = sStandBy;


				//vSendMessageNUCModeFeeChange( pxNFee->ucId, (unsigned short int)pxNFee->xControl.eMode );
				pxNFee->xControl.xDeb.eState = sStandBy;
				break;


			case sStandBy:
				/*Wait for commands in the Queue*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinStandBy( pxNFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}
				break;

			case sWaitSync:
				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: (sFeeWaitingSync)\n", pxNFee->ucId);
				}
				#endif

				/* Wait for sync, or any other command*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code != OS_ERR_NONE ) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ (sFeeWaitingSync)\n", pxNFee->ucId);
					}
					#endif
				} else {
					vQCmdFEEinWaitingSync( pxNFee, uiCmdFEE.ulWord  );
				}
				break;

			case sFullPattern_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: Going to FullImage Pattern.\n", pxNFee->ucId);
				}
				#endif

				/* Real Fee State (graph) */
				pxNFee->xControl.xDeb.eLastMode = sOn_Enter;
				pxNFee->xControl.xDeb.eMode = sFullPattern;
				pxNFee->xControl.xDeb.eNextMode = sFullPattern;
				/* Real State */

				pxNFee->xControl.xDeb.eState = redoutCycle_Enter;
				break;

			case sWinPattern_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: Going to Windowing Pattern.\n", pxNFee->ucId);
				}
				#endif

				/* Real Fee State (graph) */
				pxNFee->xControl.xDeb.eLastMode = sOn_Enter;
				pxNFee->xControl.xDeb.eMode = sWinPattern;
				pxNFee->xControl.xDeb.eNextMode = sWinPattern;
				/* Real State */

				pxNFee->xControl.xDeb.eState = redoutCycle_Enter;
				break;

			case sFullImage_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: Going to FullImage after Sync.\n", pxNFee->ucId);
				}
				#endif

				/* Real Fee State (graph) */
				pxNFee->xControl.xDeb.eLastMode = sStandBy_Enter;
				pxNFee->xControl.xDeb.eMode = sFullImage;
				pxNFee->xControl.xDeb.eNextMode = sFullImage;
				/* Real State */

				pxNFee->xControl.xDeb.eState = redoutCycle_Enter;
				break;

			case sWindowing_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: Going to Windowing after Sync.\n", pxNFee->ucId);
				}
				#endif

				/* Real Fee State (graph) */
				pxNFee->xControl.xDeb.eLastMode = sStandBy_Enter;
				pxNFee->xControl.xDeb.eMode = sWindowing;
				pxNFee->xControl.xDeb.eNextMode = sWindowing;
				/* Real State */

				pxNFee->xControl.xDeb.eState = redoutCycle_Enter;
				break;




/*============================== Readout Cycle Implementation ========================*/



			case redoutCycle_Enter:

				/* Indicates that this FEE will now need to use DMA*/
				pxNFee->xControl.bUsingDMA = TRUE;
				xTrans[0].bFirstT = TRUE;
				pxNFee->xControl.bTransientMode = TRUE;


				if (xGlobal.bJustBeforSync == FALSE)
					pxNFee->xControl.xDeb.eState = redoutWaitBeforeSyncSignal;
				else
					pxNFee->xControl.xDeb.eState = redoutCheckRestr;

				break;

				/*Pre Sync*/
			case redoutWaitBeforeSyncSignal:


				/*Will wait for the Before sync signal, probably in this state it will need to treat many RMAP commands*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdWaitBeforeSyncSignal( pxNFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}
				break;



			case redoutCheckDTCUpdate:

				/*Check if is needed wait the update of the memory, need only in the last readout cycle */
				if ( xGlobal.bPreMaster == FALSE ) {
					pxNFee->xControl.xDeb.eState = redoutCheckRestr;
				} else {
					if ( (xGlobal.bDTCFinished == TRUE) || (xGlobal.bJustBeforSync == TRUE) ) {
						/*If DTC already updated the memory then can go*/
						pxNFee->xControl.xDeb.eState = redoutCheckRestr;
					} else {
						/*Wait for commands in the Queue, expected to receive the message informing that DTC finished the memory update*/
						uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
						if ( error_code == OS_ERR_NONE ) {
							vQCmdFEEinWaitingMemUpdate( pxNFee, uiCmdFEE.ulWord );
						} else {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
							}
							#endif
						}
					}
				}
				break;

			case redoutCheckRestr:

				/*The Meb My have sent a message to inform the finish of the update of the image*/
				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushNFEEQueue();
				}

				for (ucIL=0; ucIL < 4; ucIL++ ){
					/* Wait until both buffers are empty  */
					vWaitUntilBufferEmpty( pxNFee->ucSPWId[ucIL] );
				}
				/* Guard time that HW MAYBE need, this will be used during the development, will be removed in some future version*/
				OSTimeDlyHMSM(0, 0, 0, min_sim(xDefaults.usiGuardNFEEDelay,1)); //todo: For now fixed in 2 ms

				/*Reset Fee Buffer every Master Sync*/
				if ( xGlobal.bPreMaster == TRUE ) {
					for (ucIL=0; ucIL < 4; ucIL++ ){
						/* Stop the module Double Buffer */
						bFeebStopCh(&pxNFee->xChannel[ucIL].xFeeBuffer);
						/* Clear all buffer form the Double Buffer */
						bFeebClrCh(&pxNFee->xChannel[ucIL].xFeeBuffer);
						/* Start the module Double Buffer */
						bFeebStartCh(&pxNFee->xChannel[ucIL].xFeeBuffer);
					}
				}
				pxNFee->xControl.xDeb.eState = redoutConfigureTrans;

				break;


			case redoutConfigureTrans:

				/*Check if this FEE is in Full*/
				if ( (pxNFee->xControl.xDeb.eMode == sFullPattern) || (pxNFee->xControl.xDeb.eMode == sFullImage)) {
					/*Check if there is any type of error enabled*/
					//bErrorInj = pxNFee->xControl.xErrorSWCtrl.bMissingData || pxNFee->xControl.xErrorSWCtrl.bMissingPkts || pxNFee->xControl.xErrorSWCtrl.bTxDisabled;
					for (ucIL=0; ucIL < 4; ucIL++ ){
						bDpktGetErrorInjection(&pxNFee->xChannel[ucIL].xDataPacket);
						pxNFee->xChannel[ucIL].xDataPacket.xDpktErrorInjection.bMissingData = pxNFee->xControl.xErrorSWCtrl.bMissingData;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktErrorInjection.bMissingPkts = pxNFee->xControl.xErrorSWCtrl.bMissingPkts;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktErrorInjection.bTxDisabled = pxNFee->xControl.xErrorSWCtrl.bTxDisabled;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktErrorInjection.ucFrameNum = pxNFee->xControl.xErrorSWCtrl.ucFrameNum;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktErrorInjection.usiDataCnt = pxNFee->xControl.xErrorSWCtrl.usiDataCnt;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktErrorInjection.usiNRepeat = pxNFee->xControl.xErrorSWCtrl.usiNRepeat;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktErrorInjection.usiSequenceCnt = pxNFee->xControl.xErrorSWCtrl.usiSequenceCnt;
						bDpktSetErrorInjection(&pxNFee->xChannel[ucIL].xDataPacket);
					}
				}

				/* Reset the memory control variables thats is used in the transmission*/
				vResetMemCCDFEE( pxNFee );

				pxNFee->xControl.bUsingDMA = TRUE;


				for (ucIL=0; ucIL < 4; ucIL++ ){
					xTrans[ucIL].xCcdMapLocal[0] = &pxNFee->xMemMap.xAebMemCcd[ucIL].xSide[0];
					xTrans[ucIL].xCcdMapLocal[1] = &pxNFee->xMemMap.xAebMemCcd[ucIL].xSide[1];

					xTrans[ucIL].xCcdMapLocal[0]->ulAddrI = xTrans[ucIL].xCcdMapLocal[0]->ulOffsetAddr + COMM_WINDOING_PARAMETERS_OFST;
					xTrans[ucIL].xCcdMapLocal[1]->ulAddrI = xTrans[ucIL].xCcdMapLocal[1]->ulOffsetAddr + COMM_WINDOING_PARAMETERS_OFST;

					/* Tells to HW where is the packet oder list (before the image)*/
					bWindCopyMebWindowingParam(xTrans[ucIL].xCcdMapLocal[0]->ulOffsetAddr, xTrans[ucIL].ucMemory, pxNFee->ucId, ucIL);

					xTrans[ucIL].ulAddrIni = 0; /*This will be the offset*/
					xTrans[ucIL].ulAddrFinal = pxNFee->xCommon.usiTotalBytes;
					xTrans[ucIL].ulTotalBlocks = pxNFee->xCommon.usiNTotalBlocks;

					/* Check if need to change the memory */
					xTrans[ucIL].ucMemory = (unsigned char) (( *pxNFee->xControl.pActualMem + 1 ) % 2) ; /* Select the other memory*/

					/* Enable IRQ and clear the Double Buffer */
					bEnableDbBuffer(pxNFee, &pxNFee->xChannel[ucIL].xFeeBuffer);
				}

				/*Configure the 8 sides of buffer to transmission - T_IN_MOD*/
				for (ucChan=0; ucChan < 8; ucChan++) {
					vConfigTinMode( pxNFee , &xTinMode[ucChan], ucChan);
				}

				/* Keep counting how many buffers where transmitted, always need count to 8 (8 buffers)*/
				pxNFee->xControl.xDeb.ucTransmited = 0;

				/* Update DataPacket with the information of actual readout information*/
				/* Configuration of Spw Channel 0 */
				/* T0_IN_MOD Select data source for left Fifo of SpW n°1:*/
				/* T1_IN_MOD Select data source for right Fifo of SpW n°1:*/
				for (ucChan=0; ucChan < 4; ucChan++){
					xTrans[ucChan].bDmaReturn[0] = FALSE;
					xTrans[ucChan].bDmaReturn[1] = FALSE;
					bDpktGetPacketConfig(&pxNFee->xChannel[ucChan].xDataPacket);
					bFeebGetMachineControl(&pxNFee->xChannel[ucChan].xFeeBuffer);
					pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucCcdNumberLeftBuffer = xTinMode[ucChan*2].ucAebNumber;
					pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucCcdNumberRigthBuffer = xTinMode[ucChan*2+1].ucAebNumber;
					pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.bCcdSideLeftBuffer = xTinMode[ucChan*2].bSideCcd;
					pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.bCcdSideRigthBuffer = xTinMode[ucChan*2+1].bSideCcd;
					switch (pxNFee->xControl.xDeb.eMode) {
						case sFullPattern:
							usiSpwPLengthL = FAST_SIZE_BUFFER_WIN;


							if ( xTinMode[ucChan*2].bDataOn == TRUE ){
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktFullImagePatternDeb;
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
								xTinMode[ucChan*2].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}
							if ( xTinMode[ucChan*2+1].bDataOn == TRUE ){
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktFullImagePatternDeb;
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
								xTinMode[ucChan*2+1].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}
							pxNFee->xChannel[ucChan].xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
							break;
						case sWinPattern:
							usiSpwPLengthL = FAST_SIZE_BUFFER_WIN;

							if ( xTinMode[ucChan*2].bDataOn == TRUE ){
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktWindowingPatternDeb;
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
								xTinMode[ucChan*2].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}
							if ( xTinMode[ucChan*2+1].bDataOn == TRUE ){
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktWindowingPatternDeb;
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
								xTinMode[ucChan*2 + 1].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}
							pxNFee->xChannel[ucChan].xFeeBuffer.xFeebMachineControl.bWindowingEn = TRUE;
							break;
						case sFullImage:
							usiSpwPLengthL = FAST_SIZE_BUFFER_WIN;

							/*Need to configure both sides of buffer*/
							if ( xTinMode[ucChan*2].bDataOn == TRUE ){
								if ( xTinMode[ucChan*2].bPattern == TRUE )
									pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktFullImagePatternAeb;
								else
									pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktFullImage;
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
								xTinMode[ucChan*2].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}

							if ( xTinMode[ucChan*2+1].bDataOn == TRUE ){
								if ( xTinMode[ucChan*2+1].bPattern == TRUE )
									pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktFullImagePatternAeb;
								else
									pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktFullImage;
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
								xTinMode[ucChan*2 + 1].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}
							pxNFee->xChannel[ucChan].xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
							break;
						case sWindowing:
							usiSpwPLengthL = FAST_SIZE_BUFFER_WIN;

							/*Need to configure both sides of buffer*/
							if ( xTinMode[ucChan*2].bDataOn == TRUE ){
								if ( xTinMode[ucChan*2].bPattern == TRUE )
									pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktWindowingPatternAeb;
								else
									pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktWindowing;
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
								xTinMode[ucChan*2].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}

							if ( xTinMode[ucChan*2+1].bDataOn == TRUE ){
								if ( xTinMode[ucChan*2+1].bPattern == TRUE )
									pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktWindowingPatternAeb;
								else
									pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktWindowing;
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
								xTinMode[ucChan*2 + 1].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}

							pxNFee->xChannel[ucChan].xFeeBuffer.xFeebMachineControl.bWindowingEn = TRUE;
							break;
						default:
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlMajorMessage )
								fprintf(fp,"\nFFEE-%hu Task: Mode not recognized: xDpktDataPacketConfig (Data Packet). Configuring On Mode.\n", pxNFee->ucId);
							#endif
							pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
							pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
							pxNFee->xChannel[ucChan].xFeeBuffer.xFeebMachineControl.bWindowingEn = FALSE;
							break;
					}
					pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiPacketLength = usiSpwPLengthL;

					bFeebSetMachineControl(&pxNFee->xChannel[ucChan].xFeeBuffer);
					bDpktSetPacketConfig(&pxNFee->xChannel[ucChan].xDataPacket);
				}



				ucRetries = 0;
				pxNFee->xControl.xDeb.ucRealySent = 0;
				pxNFee->xControl.xDeb.eState = redoutPreLoadBuffer;
				break;


			case redoutPreLoadBuffer:

				if ( ucRetries < 9 ) {
					if ( pxNFee->xControl.xDeb.ucTransmited < 8) {

						for (ucIL=0; ucIL < 8; ucIL++){

							ucSwpIdL = xTinMode[ucIL].ucSpWChannel;
							ucSwpSideL = xTinMode[ucIL].ucSideSpw;
							ucAebIdL = xTinMode[ucIL].ucAebNumber;
							ucCcdSideL = (unsigned char)xTinMode[ucIL].bSideCcd;

							if ( xTinMode[ucIL].bSent == FALSE ) {
								if ( xTinMode[ucChan].bDataOn == TRUE ) {
									if (  xTrans[ucAebIdL].ucMemory == 0  )
										xTinMode[ucIL].bSent = bSdmaDmaM1Transfer((alt_u32 *)xTrans[ucAebIdL].xCcdMapLocal[ucCcdSideL]->ulAddrI, (alt_u32)xTrans[ucAebIdL].ulTotalBlocks, ucSwpSideL, pxNFee->ucSPWId[ucSwpIdL]);
									else
										xTinMode[ucIL].bSent = bSdmaDmaM2Transfer((alt_u32 *)xTrans[ucAebIdL].xCcdMapLocal[ucCcdSideL]->ulAddrI, (alt_u32)xTrans[ucAebIdL].ulTotalBlocks, ucSwpSideL, pxNFee->ucSPWId[ucSwpIdL]);

									if ( xTinMode[ucIL].bSent == FALSE ) {
										#if DEBUG_ON
										if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
											fprintf(fp,"\nFFEE-%hu Task: DMA Schedule fail, xTinMode %u\n", pxNFee->ucId, ucIL);
										}
										#endif

										/* Stop the module Double Buffer */
										bFeebStopCh(&pxNFee->xChannel[ucSwpIdL].xFeeBuffer);
										/* Clear all buffer form the Double Buffer */
										bFeebClrCh(&pxNFee->xChannel[ucSwpIdL].xFeeBuffer);
										/* Start the module Double Buffer */
										bFeebStartCh(&pxNFee->xChannel[ucSwpIdL].xFeeBuffer);

									} else {
										pxNFee->xControl.xDeb.ucTransmited++;
										pxNFee->xControl.xDeb.ucRealySent++;
									}
								}
							}
						}
						ucRetries++;
					} else {
						/*Success*/
						pxNFee->xControl.xDeb.eState = redoutWaitSync;
						pxNFee->xControl.xDeb.ucFinished = 0;

						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
							fprintf(fp,"FFEE-%hu Task: DMAs Scheduled\n", pxNFee->ucId);
						}
						#endif
					}
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: CRITICAL! D. B. Requested more than 9 times.\n", pxNFee->ucId);
						fprintf(fp,"FFEE %hhu Task: Ending the simulation.\n", pxNFee->ucId);
					}
					#endif

					/*Back to Config*/
					pxNFee->xControl.bWatingSync = FALSE;
					pxNFee->xControl.xDeb.eLastMode = sInit;
					pxNFee->xControl.xDeb.eMode = sOFF;
					pxNFee->xControl.xDeb.eState = sOFF_Enter;

					ucRetries = 0;
				}

				break;


			case redoutTransmission:
				/*Will wait for the Before sync signal, probably in this state it will need to treat many RMAP commands*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdWaitFinishingTransmission( pxNFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxNFee->ucId);
					}
					#endif
				}

				break;

			case redoutEndSch:
				/* Debug purposes only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: End of trans\n", pxNFee->ucId);
				}
				#endif

				vResetMemCCDFEE(pxNFee);


				if ((xGlobal.bJustBeforSync == TRUE)) {
					pxNFee->xControl.xDeb.eState = redoutCheckRestr;
				} else {
					pxNFee->xControl.xDeb.eState = redoutWaitBeforeSyncSignal;
				}
				break;

			case redoutCycle_Out:
				pxNFee->xControl.bUsingDMA = FALSE;

				if ( pxNFee->xControl.xDeb.eNextMode == sOn_Enter ) {

					for (ucIL=0; ucIL<4;ucIL++){
						bDpktGetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);
						pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOn;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOn;
						bDpktSetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);
					}
				} else if ( pxNFee->xControl.xDeb.eNextMode == sStandBy_Enter ) {
					for (ucIL=0; ucIL<4;ucIL++){
						bDpktGetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);
						pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktStandby;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktStandby;
						bDpktSetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);
					}
				}

				/* Real State */
				pxNFee->xControl.xDeb.eState = pxNFee->xControl.xDeb.eNextMode;

				break;


			case redoutWaitSync:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: (redoutWaitSync)\n", pxNFee->ucId);
				}
				#endif

				/* Wait for sync, or any other command*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxNFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code != OS_ERR_NONE ) {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ (redoutWaitSync)\n", pxNFee->ucId);
					}
					#endif
				} else {
					vQCmdFEEinReadoutSync( pxNFee, uiCmdFEE.ulWord  );
				}

				/* Write in the RMAP - UCL- NFEE ICD p. 49*/
				if (xTrans[0].bFirstT == TRUE) {
					xTrans[0].bFirstT = FALSE;
					bRmapGetRmapMemCfgArea(&pxNFee->xChannel[0].xRmap);
					bRmapGetRmapMemCfgArea(&pxNFee->xChannel[1].xRmap);
					bRmapGetRmapMemCfgArea(&pxNFee->xChannel[2].xRmap);
					bRmapGetRmapMemCfgArea(&pxNFee->xChannel[3].xRmap);
					switch ( pxNFee->xControl.xDeb.eMode ) {

						case sOn: /*0x0*/
							if (pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != 7) {
								pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod=7;
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[0].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[1].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[2].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[3].xRmap);
							}
							break;
						case sFullPattern: /*0x1*/
							if (pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != 1) {
								pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = 1;
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[0].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[1].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[2].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[3].xRmap);
							}
							break;
						case sWinPattern:/*0x2*/
							if (pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != 3) {
								pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = 3;
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[0].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[1].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[2].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[3].xRmap);
							}
							break;
						case sStandBy: /*0x4*/
							if (pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != 6) {
								pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = 6;
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[0].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[1].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[2].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[3].xRmap);
							}
							break;
						case sFullImage:/*0x6*/
							if (pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != 0) {
								pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = 0;
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[0].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[1].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[2].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[3].xRmap);
							}
							break;
						case sWindowing:/*0x5*/
							if (pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != 2) {
								pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = 2;
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[0].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[1].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[2].xRmap);
								bRmapGetRmapMemCfgArea(&pxNFee->xChannel[3].xRmap);
							}
							break;
						default:
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"FFEE-%hu Task: Unexpected eMode (redoutWaitSync)\n", pxNFee->ucId);
							}
							#endif
							break;
					}
				}
				break;


			default:
				pxNFee->xControl.xDeb.eState = sOFF_Enter;
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"\nFFEE %hhu Task: Unexpected mode (default)\n", pxNFee->ucId);
				#endif
				break;
		}
	}
}

/* Threat income command while the Fee is in Config. mode*/
void vQCmdFEEinConfig( TFFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;

	uiCmdFEEL.ulWord = cmd;

	switch (uiCmdFEEL.ucByte[2]) {
		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: Already in Config Mode (Config)\n", pxNFeeP->ucId);
			}
			#endif
			break;
		case M_FEE_ON_FORCED:
			break;
		case M_FEE_ON:
		case M_FEE_RUN:
		case M_FEE_RUN_FORCED:
			pxNFeeP->xControl.bWatingSync = FALSE;

			/* Real Fee State (graph) */
			pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOn;
			pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			/* Real State - keep in the same state until master sync - wait for master sync to change*/
			pxNFeeP->xControl.xDeb.eState = sOn_Enter;
			break;

		case M_FEE_RMAP:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: Can't threat RMAP Messages in this mode (Config)\n", pxNFeeP->ucId);
			}
			#endif
			break;
		case M_MASTER_SYNC:
			/*Do nothing for now*/
			break;

		case M_BEFORE_MASTER:
			/*Do nothing for now*/
			break;

		case M_FEE_FULL:
		case M_FEE_FULL_PATTERN:
		case M_FEE_WIN:
		case M_FEE_WIN_PATTERN:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Unexpected command for this mode (Config, cmd=%hhu )\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
			}
			#endif
			break;
	}
}

/* Threat income command while the Fee is in On mode*/
void vQCmdFEEinOn( TFFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	unsigned char ucIL;

	uiCmdFEEL.ulWord = cmd;

	switch (uiCmdFEEL.ucByte[2]) {
		case M_NFC_CONFIG_RESET:
			/*Do nothing*/
			break;
		case M_FEE_CAN_ACCESS_NEXT_MEM:
			/*Do nothing*/
			break;
		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
			pxNFeeP->xControl.bWatingSync = FALSE;

			/* Real Fee State (graph) */
			pxNFeeP->xControl.xDeb.eLastMode = sOn_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOFF;
			pxNFeeP->xControl.xDeb.eNextMode = sOFF;
			/* Real State */
			pxNFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL=0; ucIL<4;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;
		case M_FEE_STANDBY:
			pxNFeeP->xControl.bWatingSync = TRUE;

			/* Real Fee State (graph) */
			pxNFeeP->xControl.xDeb.eLastMode = sOn_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOn;
			pxNFeeP->xControl.xDeb.eNextMode = sStandBy_Enter;
			/* Real State - only change on master */
			pxNFeeP->xControl.xDeb.eState = sOn;
			break;


		case M_FEE_FULL_PATTERN:
		case M_FEE_FULL_PATTERN_FORCED: /* There are no forced mode to go to the Pattern Mode */

			pxNFeeP->xControl.bWatingSync = TRUE;

			/* Real Fee State (graph) */
			pxNFeeP->xControl.xDeb.eLastMode = sOn_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOn;
			pxNFeeP->xControl.xDeb.eNextMode = sFullPattern_Enter;
			/* Real State - only change on master*/
			pxNFeeP->xControl.xDeb.eState = sOn;

			break;
		case M_FEE_WIN_PATTERN:
		case M_FEE_WIN_PATTERN_FORCED: /* There are no forced mode to go to the Pattern Mode */
			pxNFeeP->xControl.bWatingSync = TRUE;

			/* Real Fee State (graph) */
			pxNFeeP->xControl.xDeb.eLastMode = sOn_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOn;
			pxNFeeP->xControl.xDeb.eNextMode = sWinPattern_Enter;
			/* Real State - only change on master*/
			pxNFeeP->xControl.xDeb.eState = sOn;
			break;
		case M_FEE_RMAP:

			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
			}
			#endif
			/* Perform some actions, check if is a valid command for this mode of operation  */
			vQCmdFeeRMAPinModeOn( pxNFeeP, cmd );

			break;
		case M_BEFORE_MASTER:
			/*All transiction should be performed during the Pre-Sync of the Master, in order to data packet receive the right configuration during sync*/

			if ( pxNFeeP->xControl.xDeb.eNextMode != pxNFeeP->xControl.xDeb.eMode ) {
				pxNFeeP->xControl.xDeb.eState =  pxNFeeP->xControl.xDeb.eNextMode;

				if ( pxNFeeP->xControl.xDeb.eNextMode == sStandBy_Enter ) {

					for (ucIL=0; ucIL<4;ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktStandby;
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktStandby;
						bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
					}

				} else if ( pxNFeeP->xControl.xDeb.eNextMode == sFullPattern_Enter ) {

					for (ucIL=0; ucIL<4;ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktFullImagePatternDeb;
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktFullImagePatternDeb;
						bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
					}

				} else if ( pxNFeeP->xControl.xDeb.eNextMode == sWinPattern_Enter ) {

					for (ucIL=0; ucIL<4;ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktWindowingPatternDeb;
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktWindowingPatternDeb;
						bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
					}
				}
			}
			break;

		case M_MASTER_SYNC:
			/*DO nothing for now*/
			break;
		case M_FEE_DMA_ACCESS:

			break;
		case M_FEE_FULL:
		case M_FEE_WIN:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Unexpected command for this mode (ON, cmd=%hhu )\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
			}
			#endif
			break;

	}
}


/* Threat income command while the Fee is on Readout Mode mode*/
void vQCmdWaitFinishingTransmission( TFFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;
	unsigned char error_code, ucIL;

	uiCmdFEEL.ulWord = cmd;

	switch (uiCmdFEEL.ucByte[2]) {
		case M_FEE_CAN_ACCESS_NEXT_MEM:
			/*Do nothing*/
			break;

		case M_FEE_TRANS_FINISHED_L:
		case M_FEE_TRANS_FINISHED_D:

			pxNFeeP->xControl.xDeb.ucFinished++;

			if ( pxNFeeP->xControl.xDeb.ucFinished >= pxNFeeP->xControl.xDeb.ucRealySent ) {
				pxNFeeP->xControl.xDeb.eState = redoutEndSch;
			}

			break;

		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED:
			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sInit;
			pxNFeeP->xControl.xDeb.eMode = sOFF;
			pxNFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL=0; ucIL<4;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;
		case M_FEE_ON_FORCED:
			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOn;
			pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			pxNFeeP->xControl.xDeb.eState = sOn_Enter;

			for (ucIL=0; ucIL<4;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOn;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOn;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;
		case M_FEE_ON:
			if (( pxNFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxNFeeP->xControl.xDeb.eMode == sWinPattern)) {

				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.xDeb.eState = redoutTransmission; /*Will stay until master sync*/
				pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;

			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
				}
				#endif
			}

			break;
		case M_FEE_STANDBY:
			if (( pxNFeeP->xControl.xDeb.eMode == sFullImage ) || (pxNFeeP->xControl.xDeb.eMode == sWindowing)){
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.xDeb.eState = redoutTransmission; /*Will stay until master sync*/
				pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;
			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
				#endif
			}
			break;

		case M_FEE_RMAP:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
			}
			#endif

			/* Perform some actions, check if is a valid command for this mode of operation  */
			vQCmdFeeRMAPinReadoutTrans( pxNFeeP, cmd );//todo: dizem que nao vao enviar comando durante a transmissao, ignorar?

			break;

		case M_BEFORE_MASTER:
			for (ucIL=0; ucIL < 4; ucIL++ ){
				/* Stop the module Double Buffer */
				bFeebStopCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffer form the Double Buffer */
				bFeebClrCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the module Double Buffer */
				bFeebStartCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
			}
			/*The Meb My have sent a message to inform the finish of the update of the image*/
			error_code = OSQFlush( xFeeQ[ pxNFeeP->ucId ] );
			if ( error_code != OS_NO_ERR ) {
				vFailFlushNFEEQueue();
			}

			pxNFeeP->xControl.xDeb.eState = redoutConfigureTrans;
			break;

		case M_MASTER_SYNC:

			break;
		case M_FEE_FULL:
		case M_FEE_FULL_PATTERN:
		case M_FEE_WIN:
		case M_FEE_WIN_PATTERN:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task:  Unexpected command for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
			}
			#endif
			break;
	}
}

/* Threat income command while the Fee is waiting for sync*/
void vQCmdFEEinReadoutSync( TFFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	unsigned char ucIL;

	/* Get command word*/
	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_NFEE_BASE_ADDR + pxNFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_CAN_ACCESS_NEXT_MEM:
				/*Do nothing*/
				break;
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.xDeb.eLastMode = sInit;
				pxNFeeP->xControl.xDeb.eMode = sOFF;
				pxNFeeP->xControl.xDeb.eState = sOFF_Enter;

				for (ucIL=0; ucIL<4;ucIL++){
					/* [rfranca] */
					bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
					pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
					pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
					bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				}



				break;
			case M_FEE_ON:
				if (( pxNFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxNFeeP->xControl.xDeb.eMode == sWinPattern)) {
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.xDeb.eState = redoutWaitSync; /*Will stay until master sync*/
					pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;

				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
					#endif
				}
				break;
			case M_FEE_ON_FORCED:
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;
				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				for (ucIL=0; ucIL<4;ucIL++){
					/* [rfranca] */
					bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
					pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOn;
					pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOn;
					bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				}

				break;

			case M_FEE_STANDBY:
				if (( pxNFeeP->xControl.xDeb.eMode == sFullImage ) || (pxNFeeP->xControl.xDeb.eMode == sWindowing)){
					pxNFeeP->xControl.bWatingSync = TRUE;
					pxNFeeP->xControl.xDeb.eState = redoutWaitSync; /*Will stay until master sync*/
					pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;
				} else {
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
						fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
					#endif
				}
				break;

			case M_FEE_RMAP:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"\nFFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
				}
				#endif
				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPReadoutSync( pxNFeeP, cmd ); // todo: Precisa criar fluxo para RMAP
				break;
			case M_BEFORE_MASTER:
				/*Do nothing for now*/
				break;

			case M_MASTER_SYNC:
				/* Warning */
					pxNFeeP->xControl.xDeb.eState = redoutTransmission;
				break;

			case M_FEE_DMA_ACCESS:
				break;
			case M_FEE_FULL:
			case M_FEE_FULL_PATTERN:
			case M_FEE_WIN:
			case M_FEE_WIN_PATTERN:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"FFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
				}
				#endif
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"FFEE %hhu Task:  Unexpected command for this mode \n", pxNFeeP->ucId);
				}
				#endif
				break;
		}
	}
}

/*Not in use for now*/
/* Threat income command while the Fee is waiting for sync*/
void vQCmdFEEinWaitingSync( TFFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	unsigned char ucIL;

	/* Get command word*/
	uiCmdFEEL.ulWord = cmd;

	switch (uiCmdFEEL.ucByte[2]) {
		case M_FEE_CAN_ACCESS_NEXT_MEM:
			/*Do nothing*/
			break;
		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sInit;
			pxNFeeP->xControl.xDeb.eMode = sOFF;
			pxNFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL=0; ucIL<4;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_ON_FORCED:
			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOn;
			pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			pxNFeeP->xControl.xDeb.eState = sOn_Enter;

			for (ucIL=0; ucIL<4;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOn;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOn;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_RMAP:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"\nFFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
			}
			#endif
			/* Perform some actions, check if is a valid command for this mode of operation  */
			vQCmdFeeRMAPWaitingSync( pxNFeeP, cmd );
			break;
		case M_BEFORE_MASTER:
			break;

		case M_MASTER_SYNC:
			/*This block of code is used only for the On-Standby transitions, that will be done only in the master sync*/
			/* Warning */
				pxNFeeP->xControl.bWatingSync = TRUE;
				/* Real State */
				pxNFeeP->xControl.xDeb.eState = pxNFeeP->xControl.xDeb.eNextMode;
			break;
		case M_FEE_DMA_ACCESS:
			/* Send message telling to controller that is not using the DMA any more */
			bSendGiveBackNFeeCtrl( M_NFC_DMA_GIVEBACK, 0, pxNFeeP->ucId);
			break;
		case M_FEE_STANDBY:
		case M_FEE_ON:
		case M_FEE_FULL:
		case M_FEE_FULL_PATTERN:
		case M_FEE_WIN:
		case M_FEE_WIN_PATTERN:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Command not allowed, already processing a changing action (in redoutPreparingDB)\n", pxNFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task:  Unexpected command for this mode (in Config mode)\n", pxNFeeP->ucId);
			}
			#endif
			break;
	}
}


/* Threat income command while the Fee is in Standby mode*/
void vQCmdFEEinStandBy( TFFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	unsigned char ucIL;

	uiCmdFEEL.ulWord = cmd;

	switch (uiCmdFEEL.ucByte[2]) {
	case M_FEE_CAN_ACCESS_NEXT_MEM:
		/*Do nothing*/
		break;
		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
			pxNFeeP->xControl.bWatingSync = FALSE;

			/* Real Fee State (graph) */
			pxNFeeP->xControl.xDeb.eLastMode = sOn_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOFF;
			pxNFeeP->xControl.xDeb.eNextMode = sOFF;
			/* Real State */
			pxNFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL=0; ucIL<4;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_ON:
			pxNFeeP->xControl.bWatingSync = TRUE;
			pxNFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
			pxNFeeP->xControl.xDeb.eMode = sStandBy;
			pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;

			pxNFeeP->xControl.xDeb.eState = sStandBy; /*Will stay until master sync*/
			break;
		case M_FEE_ON_FORCED:
			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOn;
			pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			/* Real State */
			pxNFeeP->xControl.xDeb.eState = sOn_Enter;

			for (ucIL=0; ucIL<4;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOn;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOn;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_FULL:
		case M_FEE_FULL_FORCED:
			pxNFeeP->xControl.bWatingSync = TRUE;
			/* Real Fee State (graph) */
			pxNFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
			pxNFeeP->xControl.xDeb.eMode = sStandBy;
			pxNFeeP->xControl.xDeb.eNextMode = sFullImage_Enter;
			/* Real State */
			pxNFeeP->xControl.xDeb.eState = sStandBy;
			break;

		case M_FEE_WIN:
		case M_FEE_WIN_FORCED:
			pxNFeeP->xControl.bWatingSync = TRUE;
			/* Real Fee State (graph) */
			pxNFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
			pxNFeeP->xControl.xDeb.eMode = sStandBy;
			pxNFeeP->xControl.xDeb.eNextMode = sWindowing_Enter;
			/* Real State */
			pxNFeeP->xControl.xDeb.eState = sStandBy;
			break;

		case M_FEE_RMAP:

			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
			}
			#endif
			/* Perform some actions, check if is a valid command for this mode of operation  */
			vQCmdFeeRMAPinStandBy( pxNFeeP, cmd );

			break;

		case M_BEFORE_MASTER:
			/*All transiction should be performed during the Pre-Sync of the Master, in order to data packet receive the right configuration during sync*/

			if ( pxNFeeP->xControl.xDeb.eNextMode != pxNFeeP->xControl.xDeb.eMode ) {
				pxNFeeP->xControl.xDeb.eState =  pxNFeeP->xControl.xDeb.eNextMode;

				if ( pxNFeeP->xControl.xDeb.eNextMode == sOn_Enter ) {
					for (ucIL=0; ucIL<4;ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOn;
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOn;
						bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
					}
				} else if ( pxNFeeP->xControl.xDeb.eNextMode == sFullImage_Enter ) {
					for (ucIL=0; ucIL<4;ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktFullImage;
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOn;
						bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
					}
				} else if ( pxNFeeP->xControl.xDeb.eNextMode == sWindowing_Enter ) {
					for (ucIL=0; ucIL<4;ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktWindowing;
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktWindowing;
						bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
					}
				}
			}
			break;

		case M_MASTER_SYNC:
			/*DO nothing for now*/
			break;

		case M_FEE_FULL_PATTERN:
		case M_FEE_WIN_PATTERN:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Unexpected command for this mode (StandBy, cmd=%hhu )\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
			}
			#endif
			break;
	}
}




/* Threat income command while the Fee is in Config. mode*/
void vQCmdFEEinWaitingMemUpdate( TFFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	unsigned char ucIL;

	uiCmdFEEL.ulWord = cmd;

	switch (uiCmdFEEL.ucByte[2]) {
		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED:
			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sInit;
			pxNFeeP->xControl.xDeb.eMode = sOFF;
			pxNFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL=0; ucIL<4; ucIL++) {
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_CAN_ACCESS_NEXT_MEM:
			pxNFeeP->xControl.xDeb.eState = redoutCheckRestr;
			break;

		case M_FEE_ON_FORCED:
			pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eMode = sOn;
			pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			pxNFeeP->xControl.xDeb.eState = sOn_Enter;

			/* [rfranca] */
			for (ucIL=0; ucIL<4; ucIL++) {
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOn;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOn;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_ON:
			/*BEfore sync, so it need to end the transmission/double buffer and wait for the sync*/
			if (( pxNFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxNFeeP->xControl.xDeb.eMode == sWinPattern)) {

				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.xDeb.eState = redoutCheckDTCUpdate; /*Will stay until master sync*/
				pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;

			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
				#endif
			}
			break;

		case M_FEE_STANDBY:
			if (( pxNFeeP->xControl.xDeb.eMode == sFullImage ) || (pxNFeeP->xControl.xDeb.eMode == sWindowing)){
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.xDeb.eState = redoutCheckDTCUpdate; /*Will stay until master sync*/
				pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;
			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
				#endif
			}
			break;

		case M_FEE_RMAP:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
			}
			#endif

			/* Perform some actions, check if is a valid command for this mode of operation  */
			vQCmdFeeRMAPinWaitingMemUpdate( pxNFeeP, cmd );//todo: Tiago
			break;

		case M_BEFORE_MASTER:

			break;
		case M_MASTER_SYNC:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: CRITICAL! Sync arrive and still waiting for DTC complete the memory update. (Readout Cycle)\n", pxNFeeP->ucId);
				fprintf(fp,"FFEE %hhu Task: Ending the simulation.\n", pxNFeeP->ucId);
			}
			#endif
			/*Back to Config*/
			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sInit;
			pxNFeeP->xControl.xDeb.eMode = sOFF;
			pxNFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL=0; ucIL<4; ucIL++) {
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;
		case M_FEE_FULL:
		case M_FEE_FULL_PATTERN:
		case M_FEE_WIN:
		case M_FEE_WIN_PATTERN:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Unexpected command for in this mode (Readout Cycle, cmd=%hhu )\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
			}
			#endif
	}
}



void vQCmdWaitBeforeSyncSignal( TFFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	unsigned char ucIL;

	/* Get command word*/
	uiCmdFEEL.ulWord = cmd;

	switch (uiCmdFEEL.ucByte[2]) {
		case M_FEE_CAN_ACCESS_NEXT_MEM:
			/*Do nothing*/
			break;
		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED: /* to Config is always forced mode */
			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sInit;
			pxNFeeP->xControl.xDeb.eMode = sOFF;
			pxNFeeP->xControl.xDeb.eNextMode = sOFF;
			pxNFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL=0;ucIL<4;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_ON_FORCED:

			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOn;
			pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			pxNFeeP->xControl.xDeb.eState = sOn_Enter;

			for (ucIL=0;ucIL<4;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOn;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOn;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_ON:
			if (( pxNFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxNFeeP->xControl.xDeb.eMode == sWinPattern)) {
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.xDeb.eState = redoutWaitBeforeSyncSignal; /*Will stay until master sync*/
				pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;

			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
				}
				#endif
			}
			break;

		case M_FEE_STANDBY:
			if (( pxNFeeP->xControl.xDeb.eMode == sFullImage ) || (pxNFeeP->xControl.xDeb.eMode == sWindowing)){
				pxNFeeP->xControl.bWatingSync = TRUE;
				pxNFeeP->xControl.xDeb.eState = redoutWaitBeforeSyncSignal; /*Will stay until master sync*/
				pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;

			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
				#endif
			}
			break;

		case M_FEE_RMAP:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"\nFFEE %hhu Task: RMAP Message\n", pxNFeeP->ucId);
			}
			#endif
			/* Perform some actions, check if is a valid command for this mode of operation  */
			vQCmdFeeRMAPBeforeSync( pxNFeeP, cmd ); // todo: Precisa criar fluxo para RMAP
			break;

		case M_BEFORE_MASTER:

			if ( pxNFeeP->xControl.xDeb.eNextMode == pxNFeeP->xControl.xDeb.eLastMode )
				pxNFeeP->xControl.xDeb.eState = redoutCycle_Out; /*Is time to start the preparation of the double buffer in order to transmit data just after sync arrives*/
			else
				pxNFeeP->xControl.xDeb.eState = redoutCheckDTCUpdate; /*Received some command to change the mode, just go wait sync to change*/
			break;

		case M_MASTER_SYNC:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: CRITICAL! Something went wrong, no expected sync before the 'Before Sync Signal'  \n", pxNFeeP->ucId);
				fprintf(fp,"FFEE %hhu Task: Ending the simulation.\n", pxNFeeP->ucId);
			}
			#endif
			/*Back to Config*/
			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sInit;
			pxNFeeP->xControl.xDeb.eMode = sOFF;
			pxNFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL=0;ucIL<4;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_FULL:
		case M_FEE_FULL_PATTERN:
		case M_FEE_WIN:
		case M_FEE_WIN_PATTERN:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxNFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Unexpected command for this mode \n", pxNFeeP->ucId);
			}
			#endif
			break;
	}

}

/* Change the configuration of RMAP for a particular FEE*/
void vInitialConfig_RMAPCodecConfig( TFFee *pxNFeeP ) {
unsigned char ucIL;

	for (ucIL=0; ucIL < 4; ucIL++ ){
		bRmapGetCodecConfig( &pxNFeeP->xChannel[ucIL].xRmap );
		pxNFeeP->xChannel[ucIL].xRmap.xRmapCodecConfig.ucKey = (unsigned char) xDefaults.ucRmapKey ;
		pxNFeeP->xChannel[ucIL].xRmap.xRmapCodecConfig.ucLogicalAddress = (unsigned char) xDefaults.ucLogicalAddr;
		bRmapSetCodecConfig( &pxNFeeP->xChannel[ucIL].xRmap );
	}

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"FFEE %hhu Task. RMAP KEY = %hu\n", pxNFeeP->ucId ,xDefaults.ucRmapKey );
		fprintf(fp,"FFEE %hhu Task. Log. Addr. = %hu \n", pxNFeeP->ucId, xDefaults.ucLogicalAddr);
	}
	#endif

}

/* Initializing the HW DataPacket*/
void vInitialConfig_DpktPacket( TFFee *pxNFeeP ) {
	unsigned char ucIL;

	for ( ucIL = 0; ucIL < 4; ucIL++ ) {
		bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiCcdXSize = pxNFeeP->xCcdInfo.usiHalfWidth + pxNFeeP->xCcdInfo.usiSPrescanN + pxNFeeP->xCcdInfo.usiSOverscanN;
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiCcdYSize = pxNFeeP->xCcdInfo.usiHeight + pxNFeeP->xCcdInfo.usiOLN;
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiDataYSize = pxNFeeP->xCcdInfo.usiHeight;
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiOverscanYSize = pxNFeeP->xCcdInfo.usiOLN;
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiPacketLength = xDefaults.usiSpwPLength;
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeft = eDpktOff;
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRight = eDpktOff;
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucProtocolId = xDefaults.usiDataProtId; /* 0xF0 ou  0x02*/
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xDefaults.usiDpuLogicalAddr;
		bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
	}

}

/**
 * @name vUpdateFeeHKValue
 * @author bndky
 * @brief Update RMAP HK function for simulated FEE
 * @ingroup rtos
 *
 * @param 	[in]	TNFee 			*pxNFeeP
 * @param	[in]	alt_u8 	        ucRmapHkID (0 - 66)
 * @param	[in]	alt_u32			uliRawValue
 *
 * @retval void
 **/
//
//void vUpdateFeeHKValue ( TFFee *pxNFeeP, alt_u8 ucRmapHkID, alt_u32 uliRawValue ){
//
//	/* Load current values */
//	bRmapGetRmapMemHkArea(&pxNFeeP->xChannel.xRmap);
//
//	/* Switch case to assign value to register */
//	switch(ucRmapHkID){
//		case eRmapHkTouSense1:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense1 = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkTouSense2:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense2 = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkTouSense3:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense3 = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkTouSense4:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense4 = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkTouSense5:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense5 = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkTouSense6:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTouSense6 = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd1Ts:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1Ts = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd2Ts:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2Ts = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd3Ts:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3Ts = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd4Ts:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4Ts = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkPrt1:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt1 = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkPrt2:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt2 = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkPrt3:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt3 = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkPrt4:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt4 = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkPrt5:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiPrt5 = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkZeroDiffAmp:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiZeroDiffAmp = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd1VodMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VodMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd1VogMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VogMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd1VrdMonE:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VrdMonE = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd2VodMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VodMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd2VogMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VogMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd2VrdMonE:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VrdMonE = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd3VodMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VodMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd3VogMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VogMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd3VrdMonE:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VrdMonE = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd4VodMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VodMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd4VogMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VogMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd4VrdMonE:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VrdMonE = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkVccd:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVccd = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkVrclkMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVrclkMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkViclk:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiViclk = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkVrclkLow:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVrclkLow = (alt_u16)uliRawValue;
//		break;
//		case eRmapHk5vbPosMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi5vbPosMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHk5vbNegMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi5vbNegMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHk3v3bMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi3v3bMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHk2v5aMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi2v5aMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHk3v3dMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi3v3dMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHk2v5dMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi2v5dMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHk1v5dMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi1v5dMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHk5vrefMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usi5vrefMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkVccdPosRaw:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVccdPosRaw = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkVclkPosRaw:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVclkPosRaw = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkVan1PosRaw:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVan1PosRaw = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkVan3NegMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVan3NegMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkVan2PosRaw:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVan2PosRaw = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkVdigRaw:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVdigRaw = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkVdigRaw2:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiVdigRaw2 = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkViclkLow:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiViclkLow = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd1VrdMonF:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VrdMonF = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd1VddMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VddMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd1VgdMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd1VgdMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd2VrdMonF:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VrdMonF = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd2VddMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VddMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd2VgdMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd2VgdMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd3VrdMonF:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VrdMonF = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd3VddMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VddMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd3VgdMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd3VgdMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd4VrdMonF:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VrdMonF = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd4VddMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VddMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkCcd4VgdMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiCcd4VgdMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkIgHiMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiIgHiMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkIgLoMon:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiIgLoMon = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkTsenseA:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTsenseA = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkTsenseB:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiTsenseB = (alt_u16)uliRawValue;
//		break;
//		case eRmapHkFpgaMinVer:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucFpgaMinorVersion = (alt_u8)uliRawValue;
//		break;
//		case eRmapHkFpgaMajVer:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.ucFpgaMajorVersion = (alt_u8)uliRawValue;
//		break;
//		case eRmapHkBoardId:
//			pxNFeeP->xChannel.xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk.usiBoardId = (alt_u16)uliRawValue;
//		break;
//		default:
//			#if DEBUG_ON
//			if ( xDefaults.usiDebugLevel <= dlMajorMessage )
//				fprintf(fp, "HK update: HK ID out of bounds: %u;\n", ucRmapHkID );
//			#endif
//		break;
//	}
//
//	bRmapSetRmapMemHkArea(&pxNFeeP->xChannel.xRmap);
//
//}

void vSendMessageNUCModeFeeChange( unsigned char usIdFee, unsigned short int mode  ) {
	INT8U error_code, i;
	char cHeader[8] = "!F:%hhu:";
	char cBufferL[128] = "";

	sprintf( cBufferL, "%s%hhu:%hu", cHeader, usIdFee, mode );


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

void vSetDoubleBufferRightSize( unsigned char ucLength, unsigned char ucId ) {

	switch (ucId) {
		case 0:
			bFeebCh1SetBufferSize( ucLength, 1);
			break;
		case 1:
			bFeebCh2SetBufferSize( ucLength, 1);
			break;
		case 2:
			bFeebCh3SetBufferSize( ucLength, 1);
			break;
		case 3:
			bFeebCh4SetBufferSize( ucLength, 1);
			break;
		case 4:
			bFeebCh5SetBufferSize( ucLength, 1);
			break;
		case 5:
			bFeebCh6SetBufferSize( ucLength, 1);
			break;
		case 6:
			bFeebCh7SetBufferSize( ucLength, 1);
			break;
		case 7:
			bFeebCh8SetBufferSize( ucLength, 1);
			break;
		default:
			break;
	}
}

void vSetDoubleBufferLeftSize( unsigned char ucLength, unsigned char ucId ) {

	switch (ucId) {
		case 0:
			bFeebCh1SetBufferSize( ucLength, 0);
			break;
		case 1:
			bFeebCh2SetBufferSize( ucLength, 0);
			break;
		case 2:
			bFeebCh3SetBufferSize( ucLength, 0);
			break;
		case 3:
			bFeebCh4SetBufferSize( ucLength, 0);
			break;
		case 4:
			bFeebCh5SetBufferSize( ucLength, 0);
			break;
		case 5:
			bFeebCh6SetBufferSize( ucLength, 0);
			break;
		case 6:
			bFeebCh7SetBufferSize( ucLength, 0);
			break;
		case 7:
			bFeebCh8SetBufferSize( ucLength, 0);
			break;
		default:
			break;
	}
}

/* todo: Adicionar Timeout e colocar a tarefa para sleep*/
void vWaitUntilBufferEmpty( unsigned char ucId ) {
	unsigned char ucIcounter;

	ucIcounter = 0;
	switch (ucId) {
		case 0:
			while ( ((bFeebGetCh1LeftFeeBusy()== TRUE) || (bFeebGetCh1RightFeeBusy()== TRUE)) && (ucIcounter<10) ) {OSTimeDlyHMSM(0, 0, 0, 1); ucIcounter++;}
			break;
		case 1:
			while ( ((bFeebGetCh2LeftFeeBusy()== TRUE) || (bFeebGetCh2RightFeeBusy()== TRUE)) && (ucIcounter<10)  ) {OSTimeDlyHMSM(0, 0, 0, 1); ucIcounter++;}
			break;
		case 2:
			while ( ((bFeebGetCh3LeftFeeBusy()== TRUE) || (bFeebGetCh3RightFeeBusy()== TRUE)) && (ucIcounter<10)  ) {OSTimeDlyHMSM(0, 0, 0, 1); ucIcounter++;}
			break;
		case 3:
			while ( ((bFeebGetCh4LeftFeeBusy()== TRUE) || (bFeebGetCh4RightFeeBusy()== TRUE)) && (ucIcounter<10)  ) {OSTimeDlyHMSM(0, 0, 0, 1); ucIcounter++;}
			break;
		case 4:
			while ( ((bFeebGetCh5LeftFeeBusy()== TRUE) || (bFeebGetCh5RightFeeBusy()== TRUE)) && (ucIcounter<10)  ) {OSTimeDlyHMSM(0, 0, 0, 1); ucIcounter++;}
			break;
		case 5:
			while ( ((bFeebGetCh6LeftFeeBusy()== TRUE) || (bFeebGetCh6RightFeeBusy()== TRUE)) && (ucIcounter<10)  ) {OSTimeDlyHMSM(0, 0, 0, 1); ucIcounter++;}
			break;
		case 6:
			while ( ((bFeebGetCh7LeftFeeBusy()== TRUE) || (bFeebGetCh7RightFeeBusy()== TRUE)  ) && (ucIcounter<10)  ) {OSTimeDlyHMSM(0, 0, 0, 1); ucIcounter++;}
			break;
		case 7:
			while ( ((bFeebGetCh8LeftFeeBusy()== TRUE) || (bFeebGetCh8RightFeeBusy()== TRUE)  ) && (ucIcounter<10)  ) {OSTimeDlyHMSM(0, 0, 0, 1); ucIcounter++;}
			break;
		default:
			break;
	}

}

inline unsigned long int uliReturnMaskR( unsigned char ucChannel ){
	unsigned long int uliOut;

	switch (ucChannel) {
		case 0:
			uliOut = LEDS_1R_MASK;
			break;
		case 1:
			uliOut = LEDS_2R_MASK;
			break;
		case 2:
			uliOut = LEDS_3R_MASK;
			break;
		case 3:
			uliOut = LEDS_4R_MASK;
			break;
		case 4:
			uliOut = LEDS_5R_MASK;
			break;
		case 5:
			uliOut = LEDS_6R_MASK;
			break;
		case 6:
			uliOut = LEDS_7R_MASK;
			break;
		case 7:
			uliOut = LEDS_8R_MASK;
			break;
		default:
			uliOut = LEDS_R_ALL_MASK;
			break;
	}
	return uliOut;
}


inline unsigned long int uliReturnMaskG( unsigned char ucChannel ){
	unsigned long int uliOut;

	switch (ucChannel) {
		case 0:
			uliOut = LEDS_1G_MASK;
			break;
		case 1:
			uliOut = LEDS_2G_MASK;
			break;
		case 2:
			uliOut = LEDS_3G_MASK;
			break;
		case 3:
			uliOut = LEDS_4G_MASK;
			break;
		case 4:
			uliOut = LEDS_5G_MASK;
			break;
		case 5:
			uliOut = LEDS_6G_MASK;
			break;
		case 6:
			uliOut = LEDS_7G_MASK;
			break;
		case 7:
			uliOut = LEDS_8G_MASK;
			break;
		default:
			uliOut = LEDS_G_ALL_MASK;
			break;
	}
	return uliOut;
}


/* This function send command request for the NFEE Controller Queue*/
bool bSendMSGtoMebTask( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	bool bSuccesL;
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_MEB_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	bSuccesL = FALSE;
	error_codel = OSQPost(xMebQ, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailFromFEE();
		bSuccesL = FALSE;
	} else {
		bSuccesL =  TRUE;
	}
	return bSuccesL;
}


/* This function send command request for the NFEE Controller Queue*/
bool bSendRequestNFeeCtrl( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
{
	bool bSuccesL;
	INT8U error_codel;
	tQMask uiCmdtoSend;

	uiCmdtoSend.ucByte[3] = M_FEE_CTRL_ADDR;
	uiCmdtoSend.ucByte[2] = ucCMD;
	uiCmdtoSend.ucByte[1] = ucSUBType;
	uiCmdtoSend.ucByte[0] = ucValue;

	/* Sync the Meb task and tell that has a PUS command waiting */
	bSuccesL = FALSE;
	error_codel = OSQPost(xQMaskFeeCtrl, (void *)uiCmdtoSend.ulWord);
	if ( error_codel != OS_ERR_NONE ) {
		vFailRequestDMA( ucValue );
		bSuccesL = FALSE;
	} else {
		bSuccesL =  TRUE;
	}
	return bSuccesL;
}

bool bDisableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId ) {
	/* Disable RMAP channel */
	bRmapGetIrqControl(pxRmapCh);
	pxRmapCh->xRmapIrqControl.bWriteConfigEn = FALSE;
	pxRmapCh->xRmapIrqControl.bWriteWindowEn = FALSE;
	bRmapSetIrqControl(pxRmapCh);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableRmapIRQ( TRmapChannel *pxRmapCh, unsigned char ucId ) {

	bRmapGetIrqControl(pxRmapCh);
	pxRmapCh->xRmapIrqControl.bWriteConfigEn = TRUE;
	pxRmapCh->xRmapIrqControl.bWriteWindowEn = TRUE;
	bRmapSetIrqControl(pxRmapCh);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bDisableSPWChannel( TSpwcChannel *xSPW ) {
	/* Disable SPW channel */
	bSpwcGetLink(xSPW);
	xSPW->xSpwcLinkConfig.bLinkStart = FALSE;
	xSPW->xSpwcLinkConfig.bAutostart = FALSE;
	xSPW->xSpwcLinkConfig.bDisconnect = TRUE;
	bSpwcSetLink(xSPW);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableSPWChannel( TSpwcChannel *xSPW ) {
	/* Enable SPW channel */
	bSpwcGetLink(xSPW);
	xSPW->xSpwcLinkConfig.bLinkStart = xDefaults.bSpwLinkStart;
	xSPW->xSpwcLinkConfig.bAutostart = TRUE;
	xSPW->xSpwcLinkConfig.bDisconnect = FALSE;
	bSpwcSetLink(xSPW);

	/*todo: No treatment for now  */
	return TRUE;
}

void vConfigTinMode( TFFee *pxNFeeP , TtInMode *xTinModeP, unsigned ucTxin){
	unsigned char ucMode, ucX;

	ucX = ucTxin;
	switch (ucTxin) {
		case 7:
			ucMode = pxNFeeP->xControl.xDeb.ucTxInMode[ucX];
			switch (ucMode) {
				case 0b000:
					(*xTinModeP).bDataOn = FALSE;
					break;
				case 0b001:
					(*xTinModeP).bDataOn = TRUE;
					(*xTinModeP).bPattern = FALSE;
					(*xTinModeP).ucAebNumber = 3;
					(*xTinModeP).bSideCcd = 1; /*E = Left = 0 | F = Right = 1*/
					break;
				case 0b100:
					(*xTinModeP).bDataOn = FALSE;
					break;
				case 0b101:
					(*xTinModeP).bDataOn = TRUE;
					(*xTinModeP).bPattern = TRUE;
					(*xTinModeP).ucAebNumber = 3;
					(*xTinModeP).bSideCcd = 1; /*E = Left = 0 | F = Right = 1*/
					break;
				default:
					(*xTinModeP).bDataOn = FALSE;
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
					}
					#endif
			}
			break;
		case 6:
			ucMode = pxNFeeP->xControl.xDeb.ucTxInMode[ucX];
				switch (ucMode) {
					case 0b000:
						(*xTinModeP).bDataOn = FALSE;
						break;
					case 0b001:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 3;
						(*xTinModeP).bSideCcd = 0; /*E = Left = 0 | F = Right = 1*/
						break;
					case 0b010:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).bSideCcd = 1; /*E = Left = 0 | F = Right = 1*/
						break;
					case 0b100:
						(*xTinModeP).bDataOn = FALSE;
						break;
					case 0b101:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 3;
						(*xTinModeP).bSideCcd = 0; /*E = Left = 0 | F = Right = 1*/
						break;
					case 0b110:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).bSideCcd = 1; /*E = Left = 0 | F = Right = 1*/
						break;
					default:
						(*xTinModeP).bDataOn = FALSE;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
						}
						#endif
				}
			break;
		case 5:
			ucMode = pxNFeeP->xControl.xDeb.ucTxInMode[ucX];
				switch (ucMode) {
					case 0b000:
						(*xTinModeP).bDataOn = FALSE;
						break;
					case 0b001:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).bSideCcd = 1; /*E = Left = 0 | F = Right = 1*/
						break;
					case 0b010:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 3;
						(*xTinModeP).bSideCcd = 0; /*E = Left = 0 | F = Right = 1*/
						break;
					case 0b100:
						(*xTinModeP).bDataOn = FALSE;
						break;
					case 0b101:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).bSideCcd = 1; /*E = Left = 0 | F = Right = 1*/
						break;
					case 0b110:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 3;
						(*xTinModeP).bSideCcd = 0; /*E = Left = 0 | F = Right = 1*/
						break;
					default:
						(*xTinModeP).bDataOn = FALSE;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
						}
						#endif
				}
			break;
		case 4:
			ucMode = pxNFeeP->xControl.xDeb.ucTxInMode[ucX];
				switch (ucMode) {
					case 0b000:
						(*xTinModeP).bDataOn = FALSE;
						break;
					case 0b001:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).bSideCcd = 0; /*E = Left = 0 | F = Right = 1*/
						break;
					case 0b100:
						(*xTinModeP).bDataOn = FALSE;
						break;
					case 0b101:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).bSideCcd = 0; /*E = Left = 0 | F = Right = 1*/
						break;
					default:
						(*xTinModeP).bDataOn = FALSE;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
						}
						#endif
				}

			break;
		case 3:
			ucMode = pxNFeeP->xControl.xDeb.ucTxInMode[ucX];
				switch (ucMode) {
					case 0b000:
						(*xTinModeP).bDataOn = FALSE;
						break;
					case 0b001:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).bSideCcd = 1; /*E = Left = 0 | F = Right = 1*/
						break;
					case 0b100:
						(*xTinModeP).bDataOn = FALSE;
						break;
					case 0b101:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).bSideCcd = 1; /*E = Left = 0 | F = Right = 1*/
						break;
					default:
						(*xTinModeP).bDataOn = FALSE;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
						}
						#endif
				}
			break;
		case 2:
			ucMode = pxNFeeP->xControl.xDeb.ucTxInMode[ucX];
				switch (ucMode) {
					case 0b000:
						(*xTinModeP).bDataOn = FALSE;
						break;
					case 0b001:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 1;
						(*xTinModeP).bSideCcd = 0; /*E = Left = 0 | F = Right = 1*/
						break;
					case 0b010:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 0;
						(*xTinModeP).bSideCcd = 1; /*E = Left = 0 | F = Right = 1*/
						break;
					case 0b100:
						(*xTinModeP).bDataOn = FALSE;
						break;
					case 0b101:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 1;
						(*xTinModeP).bSideCcd = 0; /*E = Left = 0 | F = Right = 1*/
						break;
					case 0b110:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 0;
						(*xTinModeP).bSideCcd = 1; /*E = Left = 0 | F = Right = 1*/
						break;
					default:
						(*xTinModeP).bDataOn = FALSE;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
						}
						#endif
				}
			break;
		case 1:
			ucMode = pxNFeeP->xControl.xDeb.ucTxInMode[ucX];
				switch (ucMode) {
					case 0b000:
						(*xTinModeP).bDataOn = FALSE;
						break;
					case 0b001:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 0;
						(*xTinModeP).bSideCcd = 1; /*E = Left = 0 | F = Right = 1*/
						break;
					case 0b010:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 1;
						(*xTinModeP).bSideCcd = 0; /*E = Left = 0 | F = Right = 1*/
						break;
					case 0b100:
						(*xTinModeP).bDataOn = FALSE;
						break;
					case 0b101:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 0;
						(*xTinModeP).bSideCcd = 1; /*E = Left = 0 | F = Right = 1*/
						break;
					case 0b110:
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 1;
						(*xTinModeP).bSideCcd = 0; /*E = Left = 0 | F = Right = 1*/
						break;
					default:
						(*xTinModeP).bDataOn = FALSE;
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
						}
						#endif
				}
			break;
		case 0:
			ucMode = pxNFeeP->xControl.xDeb.ucTxInMode[ucX];
			switch (ucMode) {
				case 0b000:
					(*xTinModeP).bDataOn = FALSE;
					break;
				case 0b001:
					(*xTinModeP).bDataOn = TRUE;
					(*xTinModeP).bPattern = FALSE;
					(*xTinModeP).ucAebNumber = 0;
					(*xTinModeP).bSideCcd = 0; /*E = Left = 0 | F = Right = 1*/
					break;
				case 0b100:
					(*xTinModeP).bDataOn = FALSE;
					break;
				case 0b101:
					(*xTinModeP).bDataOn = TRUE;
					(*xTinModeP).bPattern = TRUE;
					(*xTinModeP).ucAebNumber = 0;
					(*xTinModeP).bSideCcd = 0; /*E = Left = 0 | F = Right = 1*/
					break;
				default:
					(*xTinModeP).bDataOn = FALSE;
					#if DEBUG_ON
					if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
					}
					#endif
			}
			break;
		default:
			break;
	}
}

bool bEnableDbBuffer( TFFee *pxNFeeP, TFeebChannel *pxFeebCh ) {
	/* Stop the module Double Buffer */
	bFeebStopCh(pxFeebCh);
	/* Clear all buffer form the Double Buffer */
	bFeebClrCh(pxFeebCh);
	/* Start the module Double Buffer */
	bFeebStartCh(pxFeebCh);

	/*Enable IRQ of FEE Buffer*/
	bFeebGetIrqControl(pxFeebCh);
	pxFeebCh->xFeebIrqControl.bLeftBufferEmptyEn = TRUE;
	pxFeebCh->xFeebIrqControl.bRightBufferEmptyEn = TRUE;
	bFeebSetIrqControl(pxFeebCh);

	/*todo: No treatment for now  */
	return TRUE;
}


bool bDisAndClrDbBuffer( TFeebChannel *pxFeebCh ) {

	/*Disable IRQ of FEE Buffer*/
	bFeebGetIrqControl(pxFeebCh);
	pxFeebCh->xFeebIrqControl.bLeftBufferEmptyEn = FALSE;
	pxFeebCh->xFeebIrqControl.bRightBufferEmptyEn = FALSE;
	bFeebSetIrqControl(pxFeebCh);

	/* Stop the module Double Buffer */
	bFeebStopCh(pxFeebCh);

	/* Clear all buffer form the Double Buffer */
	bFeebClrCh(pxFeebCh);
	bFeebStartCh(pxFeebCh);

	/*todo: No treatment for now  */
	return TRUE;
}


/*DLR DLR RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinModeOn( TFFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucMode, ucSpwTC;
	INT8U ucEntity;
	INT8U ucAebNumber, ucNewState;
	INT16U usiADDRReg;
	INT32U uliReg;
	bool bAebReset, bSetState;

	uiCmdFEEL.ulWord = cmd;
	ucEntity = uiCmdFEEL.ucByte[3];
	usiADDRReg = (INT16U)((uiCmdFEEL.ucByte[1] << 8) & 0xFF00) | ( uiCmdFEEL.ucByte[0] & 0x00FF );

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case 0x0000: //DTC_AEB_ONOFF (ICD p. 40)

				pxNFeeP->xControl.xAeb[0].bSwitchedOn = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[1].bSwitchedOn = pxNFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[2].bSwitchedOn = pxNFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[3].bSwitchedOn = pxNFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				break;
			case 0x0014: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case 0: /*full_image mode*/
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Can't go to this mode from On mode\n\n");
						}
						#endif
						break;
					case 1: /*full-image pattern mode*/
						pxNFeeP->xControl.xDeb.eState = sWaitSync;

						//pxNFeeP->xControl.xDeb.eMode; still the same while wait
						pxNFeeP->xControl.xDeb.eLastMode = sOn_Enter;
						pxNFeeP->xControl.xDeb.eNextMode = sFullImage_Enter;
						pxNFeeP->xControl.bWatingSync = TRUE;

						break;
					case 2: /*windowing mode*/
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Can't go to this mode from On mode\n\n");
						}
						#endif
						break;
					case 3: /*windowing pattern mode*/


						pxNFeeP->xControl.xDeb.eState = sWaitSync;

						//pxNFeeP->xControl.xDeb.eMode; still the same while wait
						pxNFeeP->xControl.xDeb.eLastMode = sOn_Enter;
						pxNFeeP->xControl.xDeb.eNextMode = sWinPattern_Enter;
						pxNFeeP->xControl.bWatingSync = TRUE;

						break;
					case 6: /*standby mode*/

						/*Asynchronous*/
						pxNFeeP->xControl.xDeb.eState = sStandBy_Enter;

						pxNFeeP->xControl.xDeb.eMode = sStandBy;
						pxNFeeP->xControl.xDeb.eLastMode = sOn_Enter;
						pxNFeeP->xControl.xDeb.eNextMode = sStandBy;


						break;
					case 7: /*on mode*/
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: DEB already in On mode\n\n");
						}
						#endif
						break;
					default:
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Invalid Mode (%hhu)\n\n", ucMode);
						}
						#endif
				}
				break;

			case 0x0018: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case 0x0104: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[7] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[6] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[5] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[4] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case 0x0108: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[3] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[2] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[1] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[0] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case 0x010C: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0110: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case 0x0114:
			case 0x0118:
			case 0x011C:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0120: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0124: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0128: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x012C: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0130: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0134: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0138: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x013C: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0140: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0144: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				pxNFeeP->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[1].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[2].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[3].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;

				pxNFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bEnable = TRUE;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): Cmd not implemented in this version.\n\n", usiADDRReg);
				}
				#endif
		}

	} else {
	/* ucEntity > 0 is AEB */
		switch (ucEntity) {
			case 1: ucAebNumber = 0; break;
			case 2: ucAebNumber = 1; break;
			case 4: ucAebNumber = 3; break;
			case 8: ucAebNumber = 4; break;
			default: ucAebNumber = 0; break;
		}


		switch (usiADDRReg) {
			case 0x0000: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = 0b0000;

					pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
				} else if ( bSetState == TRUE ) {
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case 0b0000: /*AEB_STATE_OFF*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							break;
						case 0b0001: /*AEB_STATE_INIT*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							break;
						case 0b0010: /*AEB_STATE_CONFIG*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							break;
						case 0b00011: /*AEB_STATE_IMAGE*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							break;
						case 0b0100: /*AEB_STATE_POWER_DOWN*/
						case 0b0101: /*AEB_STATE_POWER_*/
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case 0b0110: /*AEB_STATE_PATTERN*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							break;
						case 0b0111: /*AEB_STATE_FAILURE*/
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case 0x0010: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_CONFIG_PATTERN\n\n", ucEntity, usiADDRReg);
				}
				#endif
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu)- RMAP Reg (%hu): Cmd not implemented in this version.\n\n", ucEntity, usiADDRReg);
				}
				#endif
		}

	}
}

/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPBeforeSync( TFFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucMode, ucSpwTC, ucIL;
	INT8U ucEntity;
	INT8U ucAebNumber, ucNewState;
	INT16U usiADDRReg;
	bool bAebReset, bSetState;

	uiCmdFEEL.ulWord = cmd;
	ucEntity = uiCmdFEEL.ucByte[3];
	usiADDRReg = (INT16U)((uiCmdFEEL.ucByte[1] << 8) & 0xFF00) | ( uiCmdFEEL.ucByte[0] & 0x00FF );

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case 0x0000: //DTC_AEB_ONOFF (ICD p. 40)

				pxNFeeP->xControl.xAeb[0].bSwitchedOn = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[1].bSwitchedOn = pxNFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[2].bSwitchedOn = pxNFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[3].bSwitchedOn = pxNFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				break;
			case 0x0014: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case 0: /*full_image mode*/
					case 2: /*windowing mode*/
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
						break;
					case 1:
					case 3: /*windowing pattern mode*/
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif

						break;
					case 6: /*standby mode*/

						if (( pxNFeeP->xControl.xDeb.eMode == sFullImage ) || (pxNFeeP->xControl.xDeb.eMode == sWindowing)){
							pxNFeeP->xControl.bWatingSync = TRUE;
							pxNFeeP->xControl.xDeb.eState = redoutWaitBeforeSyncSignal; /*Will stay until master sync*/
							pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;
						} else {
							for ( ucIL=0; ucIL < 4 ; ucIL++ ){
								bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
								pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
								bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							}
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
								fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxNFeeP->ucId);
							#endif
						}


						break;
					case 7: /*on mode*/
						if (( pxNFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxNFeeP->xControl.xDeb.eMode == sWinPattern)) {

							pxNFeeP->xControl.bWatingSync = TRUE;
							pxNFeeP->xControl.xDeb.eState = redoutWaitBeforeSyncSignal; /*Will stay until master sync*/
							pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;

						} else {
							for ( ucIL=0; ucIL < 4 ; ucIL++ ){
								bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
								pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
								bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							}
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
							}
							#endif
						}
						break;
					default:
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Invalid Mode (%hhu)\n\n", ucMode);
						}
						#endif
				}
				break;

			case 0x0018: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case 0x0104: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[7] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[6] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[5] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[4] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case 0x0108: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[3] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[2] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[1] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[0] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case 0x010C: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0110: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case 0x0114:
			case 0x0118:
			case 0x011C:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0120: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0124: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0128: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x012C: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0130: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0134: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0138: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x013C: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0140: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0144: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				pxNFeeP->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[1].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[2].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[3].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;

				pxNFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bEnable = TRUE;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): Cmd not implemented in this version.\n\n", usiADDRReg);
				}
				#endif
		}

	} else {
	/* ucEntity > 0 is AEB */
		switch (ucEntity) {
			case 1: ucAebNumber = 0; break;
			case 2: ucAebNumber = 1; break;
			case 4: ucAebNumber = 3; break;
			case 8: ucAebNumber = 4; break;
			default: ucAebNumber = 0; break;
		}


		switch (usiADDRReg) {
			case 0x0000: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = 0b0000;

					pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
				} else if ( bSetState == TRUE ) {
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case 0b0000: /*AEB_STATE_OFF*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							break;
						case 0b0001: /*AEB_STATE_INIT*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							break;
						case 0b0010: /*AEB_STATE_CONFIG*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							break;
						case 0b00011: /*AEB_STATE_IMAGE*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							break;
						case 0b0100: /*AEB_STATE_POWER_DOWN*/
						case 0b0101: /*AEB_STATE_POWER_*/
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case 0b0110: /*AEB_STATE_PATTERN*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							break;
						case 0b0111: /*AEB_STATE_FAILURE*/
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case 0x0010: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_CONFIG_PATTERN\n\n", ucEntity, usiADDRReg);
				}
				#endif
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu)- RMAP Reg (%hu): Cmd not implemented in this version.\n\n", ucEntity, usiADDRReg);
				}
				#endif
		}

	}
}


/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinWaitingMemUpdate( TFFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucMode, ucSpwTC, ucIL;
	INT8U ucEntity;
	INT8U ucAebNumber, ucNewState;
	INT16U usiADDRReg;
	bool bAebReset, bSetState;

	uiCmdFEEL.ulWord = cmd;
	ucEntity = uiCmdFEEL.ucByte[3];
	usiADDRReg = (INT16U)((uiCmdFEEL.ucByte[1] << 8) & 0xFF00) | ( uiCmdFEEL.ucByte[0] & 0x00FF );

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case 0x0000: //DTC_AEB_ONOFF (ICD p. 40)

				pxNFeeP->xControl.xAeb[0].bSwitchedOn = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[1].bSwitchedOn = pxNFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[2].bSwitchedOn = pxNFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[3].bSwitchedOn = pxNFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				break;
			case 0x0014: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case 0: /*full_image mode*/
					case 2: /*windowing mode*/
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
						break;
					case 1: /*full-image pattern mode*/
					case 3: /*windowing pattern mode*/
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif

						break;
					case 6: /*standby mode*/
						if (( pxNFeeP->xControl.xDeb.eMode == sFullImage ) || (pxNFeeP->xControl.xDeb.eMode == sWindowing)){

							pxNFeeP->xControl.bWatingSync = TRUE;
							pxNFeeP->xControl.xDeb.eState = redoutCheckDTCUpdate; /*Will stay until master sync*/
							pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;
						} else {
							for ( ucIL=0; ucIL < 4 ; ucIL++ ){
								bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
								pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
								bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							}
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
							}
							#endif
						}
						break;
					case 7: /*on mode*/
						/*BEfore sync, so it need to end the transmission/double buffer and wait for the sync*/
						if (( pxNFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxNFeeP->xControl.xDeb.eMode == sWinPattern)) {

							pxNFeeP->xControl.bWatingSync = TRUE;
							pxNFeeP->xControl.xDeb.eState = redoutCheckDTCUpdate; /*Will stay until master sync*/
							pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;

						} else {
							for ( ucIL=0; ucIL < 4 ; ucIL++ ){
								bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
								pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
								bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							}
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
							}
							#endif
						}
						break;
					default:
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Invalid Mode (%hhu)\n\n", ucMode);
						}
						#endif
				}
				break;

			case 0x0018: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case 0x0104: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[7] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[6] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[5] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[4] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case 0x0108: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[3] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[2] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[1] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[0] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case 0x010C: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0110: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case 0x0114:
			case 0x0118:
			case 0x011C:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0120: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0124: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0128: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x012C: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0130: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0134: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0138: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x013C: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0140: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0144: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				pxNFeeP->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[1].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[2].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[3].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;

				pxNFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bEnable = TRUE;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): Cmd not implemented in this version.\n\n", usiADDRReg);
				}
				#endif
		}

	} else {
	/* ucEntity > 0 is AEB */
		switch (ucEntity) {
			case 1: ucAebNumber = 0; break;
			case 2: ucAebNumber = 1; break;
			case 4: ucAebNumber = 3; break;
			case 8: ucAebNumber = 4; break;
			default: ucAebNumber = 0; break;
		}


		switch (usiADDRReg) {
			case 0x0000: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = 0b0000;

					pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
				} else if ( bSetState == TRUE ) {
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case 0b0000: /*AEB_STATE_OFF*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							break;
						case 0b0001: /*AEB_STATE_INIT*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							break;
						case 0b0010: /*AEB_STATE_CONFIG*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							break;
						case 0b00011: /*AEB_STATE_IMAGE*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							break;
						case 0b0100: /*AEB_STATE_POWER_DOWN*/
						case 0b0101: /*AEB_STATE_POWER_*/
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case 0b0110: /*AEB_STATE_PATTERN*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							break;
						case 0b0111: /*AEB_STATE_FAILURE*/
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case 0x0010: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_CONFIG_PATTERN\n\n", ucEntity, usiADDRReg);
				}
				#endif
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu)- RMAP Reg (%hu): Cmd not implemented in this version.\n\n", ucEntity, usiADDRReg);
				}
				#endif
		}

	}
}


/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinStandBy( TFFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;
	INT8U ucMode, ucSpwTC, ucIL;
	INT8U ucEntity;
	INT8U ucAebNumber, ucNewState;
	INT16U usiADDRReg;
	bool bAebReset, bSetState;

	uiCmdFEEL.ulWord = cmd;
	ucEntity = uiCmdFEEL.ucByte[3];
	usiADDRReg = (INT16U)((uiCmdFEEL.ucByte[1] << 8) & 0xFF00) | ( uiCmdFEEL.ucByte[0] & 0x00FF );

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case 0x0000: //DTC_AEB_ONOFF (ICD p. 40)

				pxNFeeP->xControl.xAeb[0].bSwitchedOn = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[1].bSwitchedOn = pxNFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[2].bSwitchedOn = pxNFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[3].bSwitchedOn = pxNFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				break;
			case 0x0014: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case 0: /*full_image mode*/
						pxNFeeP->xControl.bWatingSync = TRUE;
						/* Real Fee State (graph) */
						pxNFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
						pxNFeeP->xControl.xDeb.eMode = sStandBy;
						pxNFeeP->xControl.xDeb.eNextMode = sFullImage_Enter;
						/* Real State */
						pxNFeeP->xControl.xDeb.eState = sStandBy;
						break;

					case 2: /*windowing mode*/
						pxNFeeP->xControl.bWatingSync = TRUE;
						/* Real Fee State (graph) */
						pxNFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
						pxNFeeP->xControl.xDeb.eMode = sStandBy;
						pxNFeeP->xControl.xDeb.eNextMode = sWindowing_Enter;
						/* Real State */
						pxNFeeP->xControl.xDeb.eState = sStandBy;
						break;
					case 1: /*full-image pattern mode*/
					case 3: /*windowing pattern mode*/
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode. (Stand-By Mode)\n\n");
						}
						#endif

						break;
					case 6: /*standby mode*/
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Already in this mode. (Stand-By Mode)\n\n");
						}
						#endif
						break;
					case 7: /*on mode*/
						pxNFeeP->xControl.bWatingSync = TRUE;
						pxNFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
						pxNFeeP->xControl.xDeb.eMode = sStandBy;
						pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;

						pxNFeeP->xControl.xDeb.eState = sStandBy; /*Will stay until master sync*/
						break;
					default:
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Invalid Mode (%hhu)\n\n", ucMode);
						}
						#endif
				}
				break;

			case 0x0018: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case 0x0104: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[7] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[6] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[5] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[4] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case 0x0108: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[3] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[2] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[1] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[0] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case 0x010C: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0110: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case 0x0114:
			case 0x0118:
			case 0x011C:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0120: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0124: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0128: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x012C: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0130: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0134: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0138: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x013C: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0140: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0144: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				pxNFeeP->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[1].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[2].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[3].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;

				pxNFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bEnable = TRUE;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): Cmd not implemented in this version.\n\n", usiADDRReg);
				}
				#endif
		}

	} else {
	/* ucEntity > 0 is AEB */
		switch (ucEntity) {
			case 1: ucAebNumber = 0; break;
			case 2: ucAebNumber = 1; break;
			case 4: ucAebNumber = 3; break;
			case 8: ucAebNumber = 4; break;
			default: ucAebNumber = 0; break;
		}


		switch (usiADDRReg) {
			case 0x0000: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = 0b0000;

					pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
				} else if ( bSetState == TRUE ) {
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case 0b0000: /*AEB_STATE_OFF*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							break;
						case 0b0001: /*AEB_STATE_INIT*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							break;
						case 0b0010: /*AEB_STATE_CONFIG*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							break;
						case 0b00011: /*AEB_STATE_IMAGE*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							break;
						case 0b0100: /*AEB_STATE_POWER_DOWN*/*/
						case 0b0101: /*AEB_STATE_POWER_*/
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case 0b0110: /*AEB_STATE_PATTERN*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							break;
						case 0b0111: /*AEB_STATE_FAILURE*/
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case 0x0010: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_CONFIG_PATTERN\n\n", ucEntity, usiADDRReg);
				}
				#endif
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu)- RMAP Reg (%hu): Cmd not implemented in this version.\n\n", ucEntity, usiADDRReg);
				}
				#endif
		}

	}
}


/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPWaitingSync( TFFee *pxNFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;
	INT8U ucMode, ucSpwTC, ucIL;
	INT8U ucEntity;
	INT8U ucAebNumber, ucNewState;
	INT16U usiADDRReg;
	bool bAebReset, bSetState;

	uiCmdFEEL.ulWord = cmd;
	ucEntity = uiCmdFEEL.ucByte[3];
	usiADDRReg = (INT16U)((uiCmdFEEL.ucByte[1] << 8) & 0xFF00) | ( uiCmdFEEL.ucByte[0] & 0x00FF );

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case 0x0000: //DTC_AEB_ONOFF (ICD p. 40)

				pxNFeeP->xControl.xAeb[0].bSwitchedOn = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[1].bSwitchedOn = pxNFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[2].bSwitchedOn = pxNFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[3].bSwitchedOn = pxNFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				break;
			case 0x0014: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case 0: /*full_image mode*/
					case 2: /*windowing mode*/
					case 1: /*full-image pattern mode*/
					case 3: /*windowing pattern mode*/
					case 6: /*standby mode*/
					case 7: /*on mode*/
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Can't perform this command, already processing a changing action.\n\n");
						}
						#endif
						break;
					default:
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Invalid Mode (%hhu)\n\n", ucMode);
						}
						#endif
				}
				break;

			case 0x0018: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case 0x0104: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[7] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[6] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[5] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[4] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case 0x0108: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[3] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[2] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[1] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[0] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case 0x010C: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0110: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case 0x0114:
			case 0x0118:
			case 0x011C:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0120: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0124: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0128: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x012C: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0130: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0134: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0138: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x013C: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0140: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0144: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				pxNFeeP->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[1].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[2].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[3].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;

				pxNFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bEnable = TRUE;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): Cmd not implemented in this version.\n\n", usiADDRReg);
				}
				#endif
		}

	} else {
	/* ucEntity > 0 is AEB */
		switch (ucEntity) {
			case 1: ucAebNumber = 0; break;
			case 2: ucAebNumber = 1; break;
			case 4: ucAebNumber = 3; break;
			case 8: ucAebNumber = 4; break;
			default: ucAebNumber = 0; break;
		}


		switch (usiADDRReg) {
			case 0x0000: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = 0b0000;

					pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
				} else if ( bSetState == TRUE ) {
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case 0b0000: /*AEB_STATE_OFF*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							break;
						case 0b0001: /*AEB_STATE_INIT*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							break;
						case 0b0010: /*AEB_STATE_CONFIG*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							break;
						case 0b00011: /*AEB_STATE_IMAGE*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							break;
						case 0b0100: /*AEB_STATE_POWER_DOWN*/
						case 0b0101: /*AEB_STATE_POWER_*/
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case 0b0110: /*AEB_STATE_PATTERN*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							break;
						case 0b0111: /*AEB_STATE_FAILURE*/
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case 0x0010: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_CONFIG_PATTERN\n\n", ucEntity, usiADDRReg);
				}
				#endif
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu)- RMAP Reg (%hu): Cmd not implemented in this version.\n\n", ucEntity, usiADDRReg);
				}
				#endif
		}

	}

}


//todo: Sera implementado apos mudancas nos registradores do RMAP
/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPReadoutSync( TFFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucMode, ucSpwTC, ucIL;
	INT8U ucEntity;
	INT8U ucAebNumber, ucNewState;
	INT16U usiADDRReg;
	bool bAebReset, bSetState;

	uiCmdFEEL.ulWord = cmd;
	ucEntity = uiCmdFEEL.ucByte[3];
	usiADDRReg = (INT16U)((uiCmdFEEL.ucByte[1] << 8) & 0xFF00) | ( uiCmdFEEL.ucByte[0] & 0x00FF );

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case 0x0000: //DTC_AEB_ONOFF (ICD p. 40)

				pxNFeeP->xControl.xAeb[0].bSwitchedOn = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[1].bSwitchedOn = pxNFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[2].bSwitchedOn = pxNFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[3].bSwitchedOn = pxNFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				break;
			case 0x0014: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case 0: /*full_image mode*/
					case 2: /*windowing mode*/
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
						break;
					case 1: /*full-image pattern mode*/
					case 3: /*windowing pattern mode*/
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif

						break;
					case 6: /*standby mode*/
						if (( pxNFeeP->xControl.xDeb.eMode == sFullImage ) || (pxNFeeP->xControl.xDeb.eMode == sWindowing)){
							pxNFeeP->xControl.bWatingSync = TRUE;
							pxNFeeP->xControl.xDeb.eState = redoutWaitSync; /*Will stay until master sync*/
							pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;
						} else {
							for ( ucIL=0; ucIL < 4 ; ucIL++ ){
								bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
								pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
								bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							}
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
							}
							#endif
						}
						break;
					case 7: /*on mode*/
						if (( pxNFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxNFeeP->xControl.xDeb.eMode == sWinPattern)) {

							pxNFeeP->xControl.bWatingSync = TRUE;
							pxNFeeP->xControl.xDeb.eState = redoutWaitSync; /*Will stay until master sync*/
							pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;

						} else {
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
							}
							#endif
						}
						break;
					default:
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Invalid Mode (%hhu)\n\n", ucMode);
						}
						#endif
				}
				break;

			case 0x0018: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case 0x0104: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[7] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[6] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[5] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[4] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case 0x0108: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[3] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[2] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[1] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[0] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case 0x010C: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0110: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case 0x0114:
			case 0x0118:
			case 0x011C:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0120: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0124: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0128: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x012C: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0130: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0134: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0138: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x013C: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0140: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0144: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				pxNFeeP->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[1].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[2].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[3].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;

				pxNFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bEnable = TRUE;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): Cmd not implemented in this version.\n\n", usiADDRReg);
				}
				#endif
		}

	} else {
	/* ucEntity > 0 is AEB */
		switch (ucEntity) {
			case 1: ucAebNumber = 0; break;
			case 2: ucAebNumber = 1; break;
			case 4: ucAebNumber = 3; break;
			case 8: ucAebNumber = 4; break;
			default: ucAebNumber = 0; break;
		}


		switch (usiADDRReg) {
			case 0x0000: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = 0b0000;

					pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
				} else if ( bSetState == TRUE ) {
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case 0b0000: /*AEB_STATE_OFF*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							break;
						case 0b0001: /*AEB_STATE_INIT*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							break;
						case 0b0010: /*AEB_STATE_CONFIG*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							break;
						case 0b00011: /*AEB_STATE_IMAGE*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							break;
						case 0b0100: /*AEB_STATE_POWER_DOWN*/
						case 0b0101: /*AEB_STATE_POWER_*/
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case 0b0110: /*AEB_STATE_PATTERN*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							break;
						case 0b0111: /*AEB_STATE_FAILURE*/
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case 0x0010: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_CONFIG_PATTERN\n\n", ucEntity, usiADDRReg);
				}
				#endif
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu)- RMAP Reg (%hu): Cmd not implemented in this version.\n\n", ucEntity, usiADDRReg);
				}
				#endif
		}
	}
}



//todo: Sera implementado apos mudancas nos registradores do RMAP
/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinReadoutTrans( TFFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucMode, ucSpwTC, ucIL;
	INT8U ucEntity;
	INT8U ucAebNumber, ucNewState;
	INT16U usiADDRReg;
	bool bAebReset, bSetState;

	uiCmdFEEL.ulWord = cmd;
	ucEntity = uiCmdFEEL.ucByte[3];
	usiADDRReg = (INT16U)((uiCmdFEEL.ucByte[1] << 8) & 0xFF00) | ( uiCmdFEEL.ucByte[0] & 0x00FF );

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case 0x0000: //DTC_AEB_ONOFF (ICD p. 40)

				pxNFeeP->xControl.xAeb[0].bSwitchedOn = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[1].bSwitchedOn = pxNFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[2].bSwitchedOn = pxNFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[3].bSwitchedOn = pxNFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				break;
			case 0x0014: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case 0: /*full_image mode*/
					case 2: /*windowing mode*/
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
						break;
					case 1: /*full-image pattern mode*/
					case 3: /*windowing pattern mode*/
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif

						break;
					case 6: /*standby mode*/
						if (( pxNFeeP->xControl.xDeb.eMode == sFullImage ) || (pxNFeeP->xControl.xDeb.eMode == sWindowing)){
							pxNFeeP->xControl.bWatingSync = TRUE;
							pxNFeeP->xControl.xDeb.eState = redoutTransmission; /*Will stay until master sync*/
							pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;

						} else {
							for ( ucIL=0; ucIL < 4 ; ucIL++ ){
								bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
								pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
								bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							}
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
							}
							#endif
						}
						break;
					case 7: /*on mode*/
						if (( pxNFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxNFeeP->xControl.xDeb.eMode == sWinPattern)) {

							pxNFeeP->xControl.bWatingSync = TRUE;
							pxNFeeP->xControl.xDeb.eState = redoutTransmission; /*Will stay until master sync*/
							pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;

						} else {
							for ( ucIL=0; ucIL < 4 ; ucIL++ ){
								bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
								pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
								bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							}
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
							}
							#endif
						}
						break;
					default:
						for ( ucIL=0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
							pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxNFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Invalid Mode (%hhu)\n\n", ucMode);
						}
						#endif
				}
				break;

			case 0x0018: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case 0x0104: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[7] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[6] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[5] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[4] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case 0x0108: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[3] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[2] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[1] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[0] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case 0x010C: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0110: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case 0x0114:
			case 0x0118:
			case 0x011C:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0120: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0124: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0128: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x012C: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0130: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0134: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0138: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x013C: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0140: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case 0x0144: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				pxNFeeP->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[1].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[2].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;
				pxNFeeP->xChannel[3].xSpacewire.xSpwcTimecodeConfig.bEnable = FALSE;

				pxNFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bEnable = TRUE;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): Cmd not implemented in this version.\n\n", usiADDRReg);
				}
				#endif
		}

	} else {
	/* ucEntity > 0 is AEB */
		switch (ucEntity) {
			case 1: ucAebNumber = 0; break;
			case 2: ucAebNumber = 1; break;
			case 4: ucAebNumber = 3; break;
			case 8: ucAebNumber = 4; break;
			default: ucAebNumber = 0; break;
		}


		switch (usiADDRReg) {
			case 0x0000: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = 0b0000;

					pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
				} else if ( bSetState == TRUE ) {
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case 0b0000: /*AEB_STATE_OFF*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							break;
						case 0b0001: /*AEB_STATE_INIT*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							break;
						case 0b0010: /*AEB_STATE_CONFIG*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							break;
						case 0b00011: /*AEB_STATE_IMAGE*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							break;
						case 0b0100: /*AEB_STATE_POWER_DOWN*/
						case 0b0101: /*AEB_STATE_POWER_*/
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case 0b0110: /*AEB_STATE_PATTERN*/
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							break;
						case 0b0111: /*AEB_STATE_FAILURE*/
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case 0x0010: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_CONFIG_PATTERN\n\n", ucEntity, usiADDRReg);
				}
				#endif
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu)- RMAP Reg (%hu): Cmd not implemented in this version.\n\n", ucEntity, usiADDRReg);
				}
				#endif
		}
	}
}
