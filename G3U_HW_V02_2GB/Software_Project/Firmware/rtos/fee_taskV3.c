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
	unsigned short int usiH, usiW;


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

				usiSpwPLengthL = xDefaults.usiFullSpwPLength;

				/*todo: get from default*/
				//pxNFee->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
				//pxNFee->xChannel[1].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				//pxNFee->xChannel[2].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				//pxNFee->xChannel[3].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				for ( ucIL=0; ucIL < N_OF_CCD; ucIL++ ) {
					pxNFee->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}
				pxNFee->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;

				for (ucIL=0; ucIL < 8; ucIL++){
					xTinMode[ucIL].ucAebNumber = 0;
					xTinMode[ucIL].ucSideCcd = eDpktCcdSideE;
					xTinMode[ucIL].ucSpWChannel = 0;
					xTinMode[ucIL].bDataOn = FALSE;
					xTinMode[ucIL].bPattern = FALSE;
					xTinMode[ucIL].bSent = FALSE;
					// Fixed in the ICD
					xTinMode[ucIL].ucSideSpw = (ucIL % 2 == 0) ? eCommLeftBuffer : eCommRightBuffer;
					xTinMode[ucIL].ucSpWChannel = (ucIL >> 1);
				}

				/*Fixed in the ICD*/
				//xTinMode[7].ucSideSpw = eCommRightBuffer; /*Right*/
				//xTinMode[6].ucSideSpw = eCommLeftBuffer; /*Left*/
				//xTinMode[5].ucSideSpw = eCommRightBuffer; /*Right*/
				//xTinMode[4].ucSideSpw = eCommLeftBuffer; /*Left*/
				//xTinMode[3].ucSideSpw = eCommRightBuffer; /*Right*/
				//xTinMode[2].ucSideSpw = eCommLeftBuffer; /*Left*/
				//xTinMode[1].ucSideSpw = eCommRightBuffer; /*Right*/
				//xTinMode[0].ucSideSpw = eCommLeftBuffer; /*Left*/

				//xTinMode[7].ucSpWChannel = 3;
				//xTinMode[6].ucSpWChannel = 3;
				//xTinMode[5].ucSpWChannel = 2;
				//xTinMode[4].ucSpWChannel = 2;
				//xTinMode[3].ucSpWChannel = 1;
				//xTinMode[2].ucSpWChannel = 1;
				//xTinMode[1].ucSpWChannel = 0;
				//xTinMode[0].ucSpWChannel = 0;

				/* Flush the queue */
				error_code = OSQFlush( xFeeQ[ pxNFee->ucId ] );
				if ( error_code != OS_NO_ERR )
					vFailFlushNFEEQueue();

				/*Initializing the HW DataPacket*/
				vInitialConfig_DpktPacket( pxNFee );

				/* Change the configuration of RMAP for a particular FEE*/
				vInitialConfig_RMAPCodecConfig( pxNFee );

				/*0..2264*/
				pxNFee->xCommon.ulVStart = 0;
				pxNFee->xCommon.ulVEnd = pxNFee->xCcdInfo.usiHeight + pxNFee->xCcdInfo.usiOLN;
				/*0..2294*/
				pxNFee->xCommon.ulHStart = 0;
				pxNFee->xCommon.ulHEnd = pxNFee->xCcdInfo.usiHalfWidth + pxNFee->xCcdInfo.usiSPrescanN + pxNFee->xCcdInfo.usiSOverscanN;

				for (ucIL=0; ucIL < N_OF_CCD; ucIL++ ){
					bDpktGetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);
					pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiCcdVStart = 0;
					pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiCcdVEnd = pxNFee->xCommon.ulVEnd;
					bDpktSetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);

					bFeebGetMachineControl(&pxNFee->xChannel[ucIL].xFeeBuffer);
					//pxFeebCh->xWindowingConfig.bMasking = DATA_PACKET;/* True= data packet;    FALSE= Transparent mode */
					pxNFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bBufferOverflowEn = xDefaults.bBufferOverflowEn;
					pxNFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bDigitaliseEn = TRUE;
					pxNFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bReadoutEn = TRUE;
					pxNFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bWindowListEn = TRUE;
					bFeebSetMachineControl(&pxNFee->xChannel[ucIL].xFeeBuffer);

					/* Clear all FEE Machine Statistics */
					bFeebClearMachineStatistics(&pxNFee->xChannel[ucIL].xFeeBuffer);

					/* Set the Pixel Storage Size - [rfranca] */
					bFeebSetPxStorageSize(&pxNFee->xChannel[ucIL].xFeeBuffer, eCommLeftBuffer, FEEB_PX_DEF_STORAGE_SIZE_BYTES, xDefaults.usiFullSpwPLength);
					bFeebSetPxStorageSize(&pxNFee->xChannel[ucIL].xFeeBuffer, eCommRightBuffer, FEEB_PX_DEF_STORAGE_SIZE_BYTES, xDefaults.usiFullSpwPLength);

					/* Disable SpaceWire Link */
					bSpwcGetLinkConfig(&(pxNFee->xChannel[ucIL].xSpacewire));
					pxNFee->xChannel[ucIL].xSpacewire.xSpwcLinkConfig.bEnable = FALSE;
					bSpwcSetLinkConfig(&(pxNFee->xChannel[ucIL].xSpacewire));
				}

				/* FGS */
				usiH = pxNFee->xCcdInfo.usiHeight + pxNFee->xCcdInfo.usiOLN;
				usiW = pxNFee->xCcdInfo.usiHalfWidth + pxNFee->xCcdInfo.usiSPrescanN + pxNFee->xCcdInfo.usiSOverscanN;
				for (ucAebIdL = 0; ucAebIdL < 4; ucAebIdL++ ){
					for (ucCcdSideL = 0; ucCcdSideL < 2; ucCcdSideL++ ){
						bFtdiSetImagettesParams(pxNFee->ucId, ucAebIdL, ucCcdSideL, usiW, usiH ,(alt_u32 *)(pxNFee->xMemMap.xAebMemCcd[ucAebIdL].xSide[ucCcdSideL].ulOffsetAddr + COMM_WINDOING_PARAMETERS_OFST));
					}
				}

				pxNFee->xControl.xDeb.eState = sOFF;
				break;

			case sOFF_Enter:/* Transition */

				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: Off Mode\n", pxNFee->ucId);
				}
				#endif

				/* Sends information to the NUC that it enter CONFIG mode */
				vSendFEEStatus(pxNFee->ucId, 1);
				/* Send Event Log */
				vSendEventLogArr(pxNFee->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtDebOffMode]);

				/* If a transition to On was requested when the FEE is waiting to go to Calibration,
				 * configure the hardware to not send any data in the next sync */
				for (ucIL=0; ucIL < N_OF_CCD; ucIL++ ){

					bDpktGetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);
					pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
					pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
					bDpktSetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);

					bFeebGetMachineControl(&pxNFee->xChannel[ucIL].xFeeBuffer);
					pxNFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bDigitaliseEn = TRUE;
					pxNFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bReadoutEn = TRUE;
					bFeebSetMachineControl(&pxNFee->xChannel[ucIL].xFeeBuffer);

					/* Disable the link SPW */
					bDisableSPWChannel( &pxNFee->xChannel[ucIL].xSpacewire );
					/* Disable RMAP interrupts */
					bDisableRmapIRQ(&pxNFee->xChannel[ucIL].xRmap, pxNFee->ucSPWId[ucIL]);

					/* Reset Channel DMAs */
					bSdmaResetCommDma(pxNFee->ucSPWId[ucIL], eSdmaLeftBuffer, TRUE);
					bSdmaResetCommDma(pxNFee->ucSPWId[ucIL], eSdmaRightBuffer, TRUE);

					/* Disable IRQ and clear the Double Buffer */
					bDisAndClrDbBuffer(&pxNFee->xChannel[ucIL].xFeeBuffer);
				}
				pxNFee->xControl.bChannelEnable = FALSE;

//				#if DEBUG_ON
//				if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
//					fprintf(fp,"FFEE-%hu Task: OFF\n", pxNFee->ucId);
//				}
//				#endif

				/* End of simulation! Clear everything that is possible */

				for (ucIL=0; ucIL < 8; ucIL++){
					xTinMode[ucIL].ucAebNumber = 0;
					xTinMode[ucIL].ucSideCcd = eDpktCcdSideE;
					xTinMode[ucIL].ucSpWChannel = 0;
					xTinMode[ucIL].bDataOn = FALSE;
					xTinMode[ucIL].bPattern = FALSE;
					xTinMode[ucIL].bSent = FALSE;
				}

				pxNFee->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
				pxNFee->xChannel[1].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				pxNFee->xChannel[2].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				pxNFee->xChannel[3].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;

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
				for (ucIL=0; ucIL < N_OF_CCD; ucIL++ ){
					pxNFee->xControl.xAeb[ucIL].bSwitchedOn = FALSE;
					pxNFee->xControl.xAeb[ucIL].eState = sAebOFF;
					/* Clear AEB Timestamp - [rfranca] */
					bRmapClrAebTimestamp(ucIL);
				}

				/* Clear AEBs On/Off Control - [rfranca] */
				pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0 = FALSE;
				pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1 = FALSE;
				pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2 = FALSE;
				pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3 = FALSE;

				/* Clear AEBs On/Off Status - [rfranca] */
				pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = FALSE;
				pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = FALSE;
				pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = FALSE;
				pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = FALSE;

				/* Enable all RMAP Channels - [rfranca] */
				vRmapCh1EnableCodec(TRUE);
				vRmapCh2EnableCodec(TRUE);
				vRmapCh3EnableCodec(TRUE);
				vRmapCh4EnableCodec(TRUE);

				/* Return RMAP Config to On mode - [rfranca] */
				pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod = eRmapDebOpModeOn;

				/* Zero-Fill all RMAP RAM Memories - [rfranca] */
				vRmapZeroFillDebRamMem();
				bRmapZeroFillAebRamMem(eCommFFeeAeb1Id);
				bRmapZeroFillAebRamMem(eCommFFeeAeb2Id);
				bRmapZeroFillAebRamMem(eCommFFeeAeb3Id);
				bRmapZeroFillAebRamMem(eCommFFeeAeb4Id);

				/* Soft-Reset all RMAP Areas (reset all registers) - [rfranca] */
				vRmapSoftRstDebMemArea();
				bRmapSoftRstAebMemArea(eCommFFeeAeb1Id);
				bRmapSoftRstAebMemArea(eCommFFeeAeb2Id);
				bRmapSoftRstAebMemArea(eCommFFeeAeb3Id);
				bRmapSoftRstAebMemArea(eCommFFeeAeb4Id);

				/* FGS */
				vFtdiAbortImagettes();
				vFtdiEnableImagettes(FALSE);

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

				/* Sends information to the NUC that it left CONFIG mode */
				vSendFEEStatus(pxNFee->ucId, 0);

				/* Send Event Log */
				vSendEventLogArr(pxNFee->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtDebOnMode]);

				for (ucIL=0; ucIL < 4; ucIL++ ){
					/* Write in the RMAP - UCL- NFEE ICD p. 49*/
					bRmapGetRmapMemCfgArea(&pxNFee->xChannel[ucIL].xRmap);
					pxNFee->xChannel[ucIL].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeOn; /* DEB Operational Mode 7 : DEB On Mode */
					bRmapSetRmapMemCfgArea(&pxNFee->xChannel[ucIL].xRmap);

					/* If a transition to On was requested when the FEE is waiting to go to Calibration,
					 * configure the hardware to not send any data in the next sync */
					bDpktGetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);
					pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
					pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
					bDpktSetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);

					/* Reset Channel DMAs */
					bSdmaResetCommDma(pxNFee->ucSPWId[ucIL], eSdmaLeftBuffer, TRUE);
					bSdmaResetCommDma(pxNFee->ucSPWId[ucIL], eSdmaRightBuffer, TRUE);

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

				/* Send Event Log */
				vSendEventLogArr(pxNFee->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtDebStandbyMode]);

				for (ucIL=0; ucIL < N_OF_CCD; ucIL++ ){
					/* Write in the RMAP - UCL- NFEE ICD p. 49*/
					bRmapGetRmapMemCfgArea(&pxNFee->xChannel[ucIL].xRmap);
					pxNFee->xChannel[ucIL].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeStandby; /* DEB Operational Mode 6 : DEB Standby Mode */
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

				/* Send Event Log */
				vSendEventLogArr(pxNFee->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtDebFullImagePatternMode]);

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

				/* Send Event Log */
				vSendEventLogArr(pxNFee->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtDebWindowingPatternMode]);

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

				/* Send Event Log */
				vSendEventLogArr(pxNFee->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtDebFullImageMode]);

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

				/* Send Event Log */
				vSendEventLogArr(pxNFee->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtDebWindowingMode]);

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

				for (ucIL=0; ucIL < N_OF_CCD; ucIL++ ){
					/* Wait until both buffers are empty  */
					vWaitUntilBufferEmpty( pxNFee->ucSPWId[ucIL] );
				}
				/* Guard time that HW MAYBE need, this will be used during the development, will be removed in some future version*/
				OSTimeDlyHMSM(0, 0, 0, min_sim(xDefaults.usiGuardNFEEDelay,1)); //todo: For now fixed in 2 ms

				/*Reset Fee Buffer every Master Sync*/
				if ( xGlobal.bPreMaster == TRUE ) {
					for (ucIL=0; ucIL < N_OF_CCD; ucIL++ ){
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
					for (ucIL=0; ucIL < N_OF_CCD; ucIL++ ){
						bDpktGetTransmissionErrInj(&pxNFee->xChannel[ucIL].xDataPacket);
						pxNFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bMissingDataEn = pxNFee->xErrorInjControl[ucIL].xErrorSWCtrlFull.bMissingData;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bMissingPktsEn = pxNFee->xErrorInjControl[ucIL].xErrorSWCtrlFull.bMissingPkts;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bTxDisabledEn = pxNFee->xErrorInjControl[ucIL].xErrorSWCtrlFull.bTxDisabled;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.ucFrameNum = pxNFee->xErrorInjControl[ucIL].xErrorSWCtrlFull.ucFrameNum;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiDataCnt = pxNFee->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiDataCnt;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiNRepeat = pxNFee->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiNRepeat;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiSequenceCnt = pxNFee->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiSequenceCnt;
						bDpktSetTransmissionErrInj(&pxNFee->xChannel[ucIL].xDataPacket);
					}
				} else if ( (pxNFee->xControl.xDeb.eMode == sWindowing) ||  (pxNFee->xControl.xDeb.eMode == sWinPattern) ) {
					for (ucIL=0; ucIL < N_OF_CCD; ucIL++ ){
						bDpktGetTransmissionErrInj(&pxNFee->xChannel[ucIL].xDataPacket);
						pxNFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bMissingDataEn = pxNFee->xErrorInjControl[ucIL].xErrorSWCtrlWin.bMissingData;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bMissingPktsEn = pxNFee->xErrorInjControl[ucIL].xErrorSWCtrlWin.bMissingPkts;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bTxDisabledEn = pxNFee->xErrorInjControl[ucIL].xErrorSWCtrlWin.bTxDisabled;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.ucFrameNum = pxNFee->xErrorInjControl[ucIL].xErrorSWCtrlWin.ucFrameNum;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiDataCnt = pxNFee->xErrorInjControl[ucIL].xErrorSWCtrlWin.usiDataCnt;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiNRepeat = pxNFee->xErrorInjControl[ucIL].xErrorSWCtrlWin.usiNRepeat;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiSequenceCnt = pxNFee->xErrorInjControl[ucIL].xErrorSWCtrlWin.usiSequenceCnt;
						bDpktSetTransmissionErrInj(&pxNFee->xChannel[ucIL].xDataPacket);
					}
				}

				/* Reset the memory control variables thats is used in the transmission*/
				vResetMemCCDFEE( pxNFee );

				pxNFee->xControl.bUsingDMA = TRUE;


				for (ucIL=0; ucIL < N_OF_CCD; ucIL++ ){
					xTrans[ucIL].xCcdMapLocal[eCcdSideELeft] = &pxNFee->xMemMap.xAebMemCcd[ucIL].xSide[eCcdSideELeft];
					xTrans[ucIL].xCcdMapLocal[eCcdSideFRight] = &pxNFee->xMemMap.xAebMemCcd[ucIL].xSide[eCcdSideFRight];

					xTrans[ucIL].xCcdMapLocal[eCcdSideELeft]->ulAddrI = xTrans[ucIL].xCcdMapLocal[eCcdSideELeft]->ulOffsetAddr + COMM_WINDOING_PARAMETERS_OFST;
					xTrans[ucIL].xCcdMapLocal[eCcdSideFRight]->ulAddrI = xTrans[ucIL].xCcdMapLocal[eCcdSideFRight]->ulOffsetAddr + COMM_WINDOING_PARAMETERS_OFST;

					/* Tells to HW where is the packet oder list (before the image)*/
					bWindCopyMebWindowingParam(xTrans[ucIL].xCcdMapLocal[eCcdSideELeft]->ulOffsetAddr, xTrans[ucIL].ucMemory, pxNFee->ucId, ucIL);

					xTrans[ucIL].ulAddrIni = 0; /*This will be the offset*/
					xTrans[ucIL].ulAddrFinal = pxNFee->xCommon.usiTotalBytes;
					xTrans[ucIL].ulTotalBlocks = pxNFee->xCommon.usiNTotalBlocks;

					/* Check if need to change the memory */
					xTrans[ucIL].ucMemory = (unsigned char) (( *pxNFee->xControl.pActualMem + 1 ) % 2) ; /* Select the other memory*/

					/* Enable IRQ and clear the Double Buffer */
					bEnableDbBuffer(pxNFee, &pxNFee->xChannel[ucIL].xFeeBuffer);
				}

//				/* FGS */
//				bFtdiSwapImagettesMem( xTrans[ucIL].ucMemory );

				/*Configure the 8 sides of buffer to transmission - T_IN_MOD*/
				for (ucChan=0; ucChan < 8; ucChan++) {
					vConfigTinMode( pxNFee , &xTinMode[ucChan], ucChan);
				}

				/* Keep counting how many buffers where transmitted, always need count to 8 (8 buffers)*/
				pxNFee->xControl.xDeb.ucTransmited = 0;

				/* Update DataPacket with the information of actual readout information*/
				/* Configuration of Spw Channel 0 */
				/* T0_IN_MOD Select data source for left Fifo of SpW n1:*/
				/* T1_IN_MOD Select data source for right Fifo of SpW n1:*/
				for (ucChan=0; ucChan < N_OF_CCD; ucChan++){
					xTrans[ucChan].bDmaReturn[eCcdSideELeft] = FALSE;
					xTrans[ucChan].bDmaReturn[eCcdSideFRight] = FALSE;
					bDpktGetPacketConfig(&pxNFee->xChannel[ucChan].xDataPacket);
					bFeebGetMachineControl(&pxNFee->xChannel[ucChan].xFeeBuffer);
					pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucCcdNumberLeftBuffer = xTinMode[ucChan*2].ucAebNumber;
					pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucCcdNumberRightBuffer = xTinMode[ucChan*2+1].ucAebNumber;
					pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucCcdSideLeftBuffer = xTinMode[ucChan*2].ucSideCcd;
					pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucCcdSideRightBuffer = xTinMode[ucChan*2+1].ucSideCcd;
					switch (pxNFee->xControl.xDeb.eMode) {
						case sFullPattern:
							usiSpwPLengthL = xDefaults.usiFullSpwPLength;

							if ( xTinMode[ucChan*2].bDataOn == TRUE ){
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImagePatternDeb;
								/* Update DEB Data Packet with Pattern Configs - [rfranca] */
								bDpktUpdateDpktDebCfg(&pxNFee->xChannel[ucChan].xDataPacket);
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
								xTinMode[ucChan*2].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}
							if ( xTinMode[ucChan*2+1].bDataOn == TRUE ){
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktFullImagePatternDeb;
								/* Update DEB Data Packet with Pattern Configs - [rfranca] */
								bDpktUpdateDpktDebCfg(&pxNFee->xChannel[ucChan].xDataPacket);
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
								xTinMode[ucChan*2+1].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}
							break;
						case sWinPattern:
							usiSpwPLengthL = xDefaults.usiWinSpwPLength;

							if ( xTinMode[ucChan*2].bDataOn == TRUE ){
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowingPatternDeb;
								/* Update DEB Data Packet with Pattern Configs - [rfranca] */
								bDpktUpdateDpktDebCfg(&pxNFee->xChannel[ucChan].xDataPacket);
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
								xTinMode[ucChan*2].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}
							if ( xTinMode[ucChan*2+1].bDataOn == TRUE ){
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktWindowingPatternDeb;
								/* Update DEB Data Packet with Pattern Configs - [rfranca] */
								bDpktUpdateDpktDebCfg(&pxNFee->xChannel[ucChan].xDataPacket);
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
								xTinMode[ucChan*2 + 1].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}
							break;
						case sFullImage:
							usiSpwPLengthL = xDefaults.usiFullSpwPLength;

							/*Need to configure both sides of buffer*/
							if ( xTinMode[ucChan*2].bDataOn == TRUE ){
								if ( xTinMode[ucChan*2].bPattern == TRUE ) {
									pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImagePatternAeb;
									/* Update AEB Data Packet with Pattern Configs - [rfranca] */
									bDpktUpdateDpktAebCfg(&pxNFee->xChannel[ucChan].xDataPacket, xTinMode[ucChan*2].ucAebNumber, xTinMode[ucChan*2].ucSideSpw);
								} else {
									if (pxNFee->xControl.xAeb[ucChan].bSwitchedOn == TRUE) {

										switch (pxNFee->xControl.xAeb[ucChan].eState) {
											case sAebPattern:
												pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImagePatternAeb;
												/* Update AEB Data Packet with Pattern Configs - [rfranca] */
												bDpktUpdateDpktAebCfg(&pxNFee->xChannel[ucChan].xDataPacket, xTinMode[ucChan*2].ucAebNumber, xTinMode[ucChan*2].ucSideSpw);
												break;
											case sAebImage:
												pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImage;
												break;
											default:
												pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
												xTinMode[ucChan*2].bSent = TRUE;
												pxNFee->xControl.xDeb.ucTransmited++;
												break;
										}

									} else {
										pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
										xTinMode[ucChan*2].bSent = TRUE;
										pxNFee->xControl.xDeb.ucTransmited++;
									}

								}
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
								xTinMode[ucChan*2].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}

							if ( xTinMode[ucChan*2+1].bDataOn == TRUE ){
								if ( xTinMode[ucChan*2+1].bPattern == TRUE ) {
									pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktFullImagePatternAeb;
									/* Update AEB Data Packet with Pattern Configs - [rfranca] */
									bDpktUpdateDpktAebCfg(&pxNFee->xChannel[ucChan].xDataPacket, xTinMode[ucChan*2+1].ucAebNumber, xTinMode[ucChan*2+1].ucSideSpw);
								} else {

									if (pxNFee->xControl.xAeb[ucChan].bSwitchedOn == TRUE) {

										switch (pxNFee->xControl.xAeb[ucChan].eState) {
											case sAebPattern:
												pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImagePatternAeb;
												/* Update AEB Data Packet with Pattern Configs - [rfranca] */
												bDpktUpdateDpktAebCfg(&pxNFee->xChannel[ucChan].xDataPacket, xTinMode[ucChan*2 + 1].ucAebNumber, xTinMode[ucChan*2+1].ucSideSpw);
												break;
											case sAebImage:
												pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImage;
												break;
											default:
												pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
												xTinMode[ucChan*2+1].bSent = TRUE;
												pxNFee->xControl.xDeb.ucTransmited++;
												break;
										}

									} else {
										pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
										xTinMode[ucChan*2+1].bSent = TRUE;
										pxNFee->xControl.xDeb.ucTransmited++;
									}
								}
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
								xTinMode[ucChan*2 + 1].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}
							break;
						case sWindowing:
							usiSpwPLengthL = xDefaults.usiWinSpwPLength;

							/*Need to configure both sides of buffer*/
							if ( xTinMode[ucChan*2].bDataOn == TRUE ){
								if ( xTinMode[ucChan*2].bPattern == TRUE )
									pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowingPatternAeb;
								else {
									if (pxNFee->xControl.xAeb[ucChan].bSwitchedOn == TRUE) {

										switch (pxNFee->xControl.xAeb[ucChan].eState) {
											case sAebPattern:
												pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowingPatternAeb;
												break;
											case sAebImage:
												pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowing;
												break;
											default:
												pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
												xTinMode[ucChan*2].bSent = TRUE;
												pxNFee->xControl.xDeb.ucTransmited++;
												break;
										}

									} else {
										pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
										xTinMode[ucChan*2].bSent = TRUE;
										pxNFee->xControl.xDeb.ucTransmited++;
									}
								}
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
								xTinMode[ucChan*2].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}

							if ( xTinMode[ucChan*2+1].bDataOn == TRUE ){
								if ( xTinMode[ucChan*2+1].bPattern == TRUE )
									pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktWindowingPatternAeb;
								else {
									if (pxNFee->xControl.xAeb[ucChan].bSwitchedOn == TRUE) {

										switch (pxNFee->xControl.xAeb[ucChan].eState) {
											case sAebPattern:
												pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowingPatternAeb;
												break;
											case sAebImage:
												pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowing;
												break;
											default:
												pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
												xTinMode[ucChan*2+1].bSent = TRUE;
												pxNFee->xControl.xDeb.ucTransmited++;
												break;
										}

									} else {
										pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
										xTinMode[ucChan*2+1].bSent = TRUE;
										pxNFee->xControl.xDeb.ucTransmited++;
									}
								}
							} else {
								pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
								xTinMode[ucChan*2 + 1].bSent = TRUE;
								pxNFee->xControl.xDeb.ucTransmited++;
							}

							break;
						default:
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlMajorMessage )
								fprintf(fp,"\nFFEE-%hu Task: Mode not recognized: xDpktDataPacketConfig (Data Packet). Configuring On Mode.\n", pxNFee->ucId);
							#endif
							pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
							pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
							break;
					}
					pxNFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.usiPacketLength = usiSpwPLengthL;

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
							ucCcdSideL = (unsigned char)xTinMode[ucIL].ucSideCcd;

//							/* FGS */
//							usiH = pxNFee->xCcdInfo.usiHeight + pxNFee->xCcdInfo.usiOLN;
//							usiW = pxNFee->xCcdInfo.usiHalfWidth + pxNFee->xCcdInfo.usiSPrescanN + pxNFee->xCcdInfo.usiSOverscanN;
//							bFtdiSetImagettesParams(0, ucAebIdL, ucCcdSideL, usiW, usiH ,(alt_u32 *)xTrans[ucAebIdL].xCcdMapLocal[ucCcdSideL]->ulAddrI);

							if ( xTinMode[ucIL].bSent == FALSE ) {
								if ( xTinMode[ucIL].bDataOn == TRUE ) {
									if (  xTrans[ucAebIdL].ucMemory == 0  )
										xTinMode[ucIL].bSent = bSdmaCommDmaTransfer(eDdr2Memory1, (alt_u32 *)xTrans[ucAebIdL].xCcdMapLocal[ucCcdSideL]->ulAddrI, (alt_u32)xTrans[ucAebIdL].ulTotalBlocks, ucSwpSideL, pxNFee->ucSPWId[ucSwpIdL]);
									else
										xTinMode[ucIL].bSent = bSdmaCommDmaTransfer(eDdr2Memory2, (alt_u32 *)xTrans[ucAebIdL].xCcdMapLocal[ucCcdSideL]->ulAddrI, (alt_u32)xTrans[ucAebIdL].ulTotalBlocks, ucSwpSideL, pxNFee->ucSPWId[ucSwpIdL]);

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

					/* FGS */
					vFtdiAbortImagettes();
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

					for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
						bDpktGetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);
						pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
						bDpktSetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);
					}
				} else if ( pxNFee->xControl.xDeb.eNextMode == sStandBy_Enter ) {
					for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
						bDpktGetPacketConfig(&pxNFee->xChannel[ucIL].xDataPacket);
						pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktStandby;
						pxNFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktStandby;
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
					for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
						bRmapGetRmapMemCfgArea(&pxNFee->xChannel[ucIL].xRmap);
					}
					switch ( pxNFee->xControl.xDeb.eMode ) {

						case sOn: /*7u*/
							/* DEB Operational Mode 7 : DEB On Mode */
							if (pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != eRmapDebOpModeOn) {
								pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeOn;
								for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
									bRmapGetRmapMemCfgArea(&pxNFee->xChannel[ucIL].xRmap);
								}
							}
							break;
						case sFullPattern: /*1u*/
							/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
							if (pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != eRmapDebOpModeFullImgPatt) {
								pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeFullImgPatt;
								for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
									bRmapGetRmapMemCfgArea(&pxNFee->xChannel[ucIL].xRmap);
								}
							}
							break;
						case sWinPattern:/*3u*/
							/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
							if (pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != eRmapDebOpModeWinPatt) {
								pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeWinPatt;
								for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
									bRmapGetRmapMemCfgArea(&pxNFee->xChannel[ucIL].xRmap);
								}
							}
							break;
						case sStandBy: /*4u*/
							/* DEB Operational Mode 6 : DEB Standby Mode */
							if (pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != eRmapDebOpModeStandby) {
								pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeStandby;
								for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
									bRmapGetRmapMemCfgArea(&pxNFee->xChannel[ucIL].xRmap);
								}
							}
							break;
						case sFullImage: /*0u*/
							/* DEB Operational Mode 0 : DEB Full-Image Mode */
							if (pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != eRmapDebOpModeFullImg) {
								pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeFullImg;
								for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
									bRmapGetRmapMemCfgArea(&pxNFee->xChannel[ucIL].xRmap);
								}
							}
							break;
						case sWindowing:/*2u*/
							/* DEB Operational Mode 2 : DEB Windowing Mode */
							if (pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != eRmapDebOpModeWin) {
								pxNFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeWin;
								for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
									bRmapGetRmapMemCfgArea(&pxNFee->xChannel[ucIL].xRmap);
								}
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
	unsigned char ucIL;

	uiCmdFEEL.ulWord = cmd;

	switch (uiCmdFEEL.ucByte[2]) {
		case M_FEE_DT_SOURCE:
			if ( uiCmdFEEL.ucByte[0] == 0 )
				pxNFeeP->xControl.xDeb.eDataSource = dsPattern;
			else if ( uiCmdFEEL.ucByte[0] == 1 )
				pxNFeeP->xControl.xDeb.eDataSource = dsSSD;
			else
				pxNFeeP->xControl.xDeb.eDataSource = dsWindowStack;
			break;

		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: Already in OFF Mode (OFF)\n", pxNFeeP->ucId);
			}
			#endif
			break;
		case M_FEE_ON_FORCED:
		case M_FEE_ON:
			pxNFeeP->xControl.bWatingSync = FALSE;

			/* Real Fee State (graph) */
			pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOn;
			pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			/* Real State - keep in the same state until master sync - wait for master sync to change*/
			pxNFeeP->xControl.xDeb.eState = sOn_Enter;
			break;

		case M_FEE_RUN:
		case M_FEE_RUN_FORCED:
			break;

		case M_FEE_RMAP:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: Can't threat RMAP Messages in this mode (Config)\n", pxNFeeP->ucId);
			}
			#endif
			break;
		case M_MASTER_SYNC:
			/* Increment AEBs Timestamps - [rfranca] */
			bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxNFeeP->xControl.xAeb[0].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxNFeeP->xControl.xAeb[1].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxNFeeP->xControl.xAeb[2].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxNFeeP->xControl.xAeb[3].bSwitchedOn);
			/*Do nothing for now*/
			break;

		case M_BEFORE_MASTER:
			vActivateContentErrInj(pxNFeeP);
			vActivateDataPacketErrInj(pxNFeeP);
			/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
			for ( ucIL = (pxNFeeP->ucId * 4) ; ucIL < (pxNFeeP->ucId * 4 + 4); ucIL++ ){
				/* Stop the Comm Channels */
				bFeebStopCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffers from the Comm Channels */
				bFeebClrCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the Comm Channels */
				bFeebStartCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
			}
			/*Do nothing for now*/
			break;

		case M_FEE_FULL:
		case M_FEE_FULL_PATTERN:
		case M_FEE_WIN:
		case M_FEE_WIN_PATTERN:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Transition not allowed from OFF mode (OFF)\n", pxNFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Unexpected command for this mode (OFF, cmd=%hhu )\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
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
		case M_FEE_DT_SOURCE:

			if ( uiCmdFEEL.ucByte[0] == 0 )
				pxNFeeP->xControl.xDeb.eDataSource = dsPattern;
			else if ( uiCmdFEEL.ucByte[0] == 1 )
				pxNFeeP->xControl.xDeb.eDataSource = dsSSD;
			else
				pxNFeeP->xControl.xDeb.eDataSource = dsWindowStack;
			break;

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

			for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;
		case M_FEE_ON:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Already in On mode (On)\n", pxNFeeP->ucId);
			}
			#endif
			break;

		case M_FEE_STANDBY:
			pxNFeeP->xControl.bWatingSync = FALSE;

			/* Real Fee State (graph) */
			pxNFeeP->xControl.xDeb.eLastMode = sOn_Enter;
			pxNFeeP->xControl.xDeb.eMode = sStandBy;
			pxNFeeP->xControl.xDeb.eNextMode = sStandBy_Enter;
			/* Real State - asynchronous */
			pxNFeeP->xControl.xDeb.eState = sStandBy_Enter;
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
			vActivateContentErrInj(pxNFeeP);
			vActivateDataPacketErrInj(pxNFeeP);
			/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
			for ( ucIL = (pxNFeeP->ucId * 4) ; ucIL < (pxNFeeP->ucId * 4 + 4); ucIL++ ){
				/* Stop the Comm Channels */
				bFeebStopCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffers from the Comm Channels */
				bFeebClrCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the Comm Channels */
				bFeebStartCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
			}
			/*All transiction should be performed during the Pre-Sync of the Master, in order to data packet receive the right configuration during sync*/

			if ( pxNFeeP->xControl.xDeb.eNextMode != pxNFeeP->xControl.xDeb.eMode ) {
				pxNFeeP->xControl.xDeb.eState =  pxNFeeP->xControl.xDeb.eNextMode;

				if ( pxNFeeP->xControl.xDeb.eNextMode == sStandBy_Enter ) {

					for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktStandby;
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktStandby;
						bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
					}

				} else if ( pxNFeeP->xControl.xDeb.eNextMode == sFullPattern_Enter ) {

					for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImagePatternDeb;
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktFullImagePatternDeb;
						bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
						/* Update DEB Data Packet with Pattern Configs - [rfranca] */
						bDpktUpdateDpktDebCfg(&pxNFeeP->xChannel[ucIL].xDataPacket);
					}

				} else if ( pxNFeeP->xControl.xDeb.eNextMode == sWinPattern_Enter ) {

					for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowingPatternDeb;
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktWindowingPatternDeb;
						bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
						/* Update DEB Data Packet with Pattern Configs - [rfranca] */
						bDpktUpdateDpktDebCfg(&pxNFeeP->xChannel[ucIL].xDataPacket);
					}
				}
			}
			break;

		case M_MASTER_SYNC:
			/* Increment AEBs Timestamps - [rfranca] */
			bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxNFeeP->xControl.xAeb[0].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxNFeeP->xControl.xAeb[1].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxNFeeP->xControl.xAeb[2].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxNFeeP->xControl.xAeb[3].bSwitchedOn);
			/*DO nothing for now*/
			break;
		case M_FEE_DMA_ACCESS:

			break;
		case M_FEE_FULL:
		case M_FEE_WIN:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Transition not allowed from On mode (On)\n", pxNFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Unexpected command for this mode (On, cmd=%hhu)\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
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
		case M_FEE_DT_SOURCE:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
			}
			#endif
			break;
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

			for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;
		case M_FEE_ON_FORCED:
			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOn;
			pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			pxNFeeP->xControl.xDeb.eState = sOn_Enter;

			for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
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
			vActivateContentErrInj(pxNFeeP);
			vActivateDataPacketErrInj(pxNFeeP);
			/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
			for ( ucIL = (pxNFeeP->ucId * 4) ; ucIL < (pxNFeeP->ucId * 4 + 4); ucIL++ ){
				/* Stop the Comm Channels */
				bFeebStopCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffers from the Comm Channels */
				bFeebClrCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the Comm Channels */
				bFeebStartCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
			}
			/*The Meb My have sent a message to inform the finish of the update of the image*/
			error_code = OSQFlush( xFeeQ[ pxNFeeP->ucId ] );
			if ( error_code != OS_NO_ERR ) {
				vFailFlushNFEEQueue();
			}

			if ( pxNFeeP->xControl.xDeb.eNextMode == pxNFeeP->xControl.xDeb.eLastMode )
				pxNFeeP->xControl.xDeb.eState = redoutCycle_Out;
			else
				pxNFeeP->xControl.xDeb.eState = redoutConfigureTrans;

			break;

		case M_MASTER_SYNC:
			/* Increment AEBs Timestamps - [rfranca] */
			bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxNFeeP->xControl.xAeb[0].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxNFeeP->xControl.xAeb[1].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxNFeeP->xControl.xAeb[2].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxNFeeP->xControl.xAeb[3].bSwitchedOn);

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
			case M_FEE_DT_SOURCE:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
				}
				#endif
				break;
			case M_FEE_CAN_ACCESS_NEXT_MEM:
				/*Do nothing*/
				break;
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* to Config is always forced mode */
				pxNFeeP->xControl.bWatingSync = FALSE;
				pxNFeeP->xControl.xDeb.eLastMode = sInit;
				pxNFeeP->xControl.xDeb.eMode = sOFF;
				pxNFeeP->xControl.xDeb.eState = sOFF_Enter;

				for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
					/* [rfranca] */
					bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
					pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
					pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
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

				for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
					/* [rfranca] */
					bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
					pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
					pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
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
				vActivateContentErrInj(pxNFeeP);
				vActivateDataPacketErrInj(pxNFeeP);
				/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
				for ( ucIL = (pxNFeeP->ucId * 4) ; ucIL < (pxNFeeP->ucId * 4 + 4); ucIL++ ){
					/* Stop the Comm Channels */
					bFeebStopCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
					/* Clear all buffers from the Comm Channels */
					bFeebClrCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
					/* Start the Comm Channels */
					bFeebStartCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				}
				/*Do nothing for now*/
				break;

			case M_MASTER_SYNC:
				/* Increment AEBs Timestamps - [rfranca] */
				bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxNFeeP->xControl.xAeb[0].bSwitchedOn);
				bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxNFeeP->xControl.xAeb[1].bSwitchedOn);
				bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxNFeeP->xControl.xAeb[2].bSwitchedOn);
				bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxNFeeP->xControl.xAeb[3].bSwitchedOn);
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

			for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_ON_FORCED:
			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOn;
			pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			pxNFeeP->xControl.xDeb.eState = sOn_Enter;

			for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
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
			vActivateContentErrInj(pxNFeeP);
			vActivateDataPacketErrInj(pxNFeeP);
			/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
			for ( ucIL = (pxNFeeP->ucId * 4) ; ucIL < (pxNFeeP->ucId * 4 + 4); ucIL++ ){
				/* Stop the Comm Channels */
				bFeebStopCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffers from the Comm Channels */
				bFeebClrCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the Comm Channels */
				bFeebStartCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
			}
			break;

		case M_MASTER_SYNC:
			/* Increment AEBs Timestamps - [rfranca] */
			bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxNFeeP->xControl.xAeb[0].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxNFeeP->xControl.xAeb[1].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxNFeeP->xControl.xAeb[2].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxNFeeP->xControl.xAeb[3].bSwitchedOn);
			/*This block of code is used only for the On-Standby transitions, that will be done only in the master sync*/
			/* Warning */
				pxNFeeP->xControl.bWatingSync = TRUE;
				/* Real State */
				pxNFeeP->xControl.xDeb.eState = pxNFeeP->xControl.xDeb.eNextMode;
			break;
		case M_FEE_DMA_ACCESS:

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
		case M_FEE_DT_SOURCE:
			if ( uiCmdFEEL.ucByte[0] == 0 )
				pxNFeeP->xControl.xDeb.eDataSource = dsPattern;
			else if ( uiCmdFEEL.ucByte[0] == 1 )
				pxNFeeP->xControl.xDeb.eDataSource = dsSSD;
			else
				pxNFeeP->xControl.xDeb.eDataSource = dsWindowStack;
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

			for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

//		case M_FEE_ON:
//			pxNFeeP->xControl.bWatingSync = TRUE;
//			pxNFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
//			pxNFeeP->xControl.xDeb.eMode = sStandBy;
//			pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;
//
//			pxNFeeP->xControl.xDeb.eState = sStandBy; /*Will stay until master sync*/
//			break;
		case M_FEE_ON:
		case M_FEE_ON_FORCED: /* Standby to On is always forced mode */
			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOn;
			pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			/* Real State */
			pxNFeeP->xControl.xDeb.eState = sOn_Enter;

			for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
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

		case M_FEE_STANDBY:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Already in StandBy mode (StandBy)\n", pxNFeeP->ucId);
			}
			#endif
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
			vActivateContentErrInj(pxNFeeP);
			vActivateDataPacketErrInj(pxNFeeP);
			/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
			for ( ucIL = (pxNFeeP->ucId * 4) ; ucIL < (pxNFeeP->ucId * 4 + 4); ucIL++ ){
				/* Stop the Comm Channels */
				bFeebStopCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffers from the Comm Channels */
				bFeebClrCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the Comm Channels */
				bFeebStartCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
			}
			/*All transiction should be performed during the Pre-Sync of the Master, in order to data packet receive the right configuration during sync*/

			if ( pxNFeeP->xControl.xDeb.eNextMode != pxNFeeP->xControl.xDeb.eMode ) {
				pxNFeeP->xControl.xDeb.eState =  pxNFeeP->xControl.xDeb.eNextMode;

				if ( pxNFeeP->xControl.xDeb.eNextMode == sOn_Enter ) {
					for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
						bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
					}
				} else if ( pxNFeeP->xControl.xDeb.eNextMode == sFullImage_Enter ) {
					for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImage;
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
						bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
					}
				} else if ( pxNFeeP->xControl.xDeb.eNextMode == sWindowing_Enter ) {
					for (ucIL=0; ucIL<N_OF_CCD;ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowing;
						pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktWindowing;
						bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
					}
				}
			}
			break;

		case M_MASTER_SYNC:
			/* Increment AEBs Timestamps - [rfranca] */
			bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxNFeeP->xControl.xAeb[0].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxNFeeP->xControl.xAeb[1].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxNFeeP->xControl.xAeb[2].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxNFeeP->xControl.xAeb[3].bSwitchedOn);
			/*DO nothing for now*/
			break;

		case M_FEE_FULL_PATTERN:
		case M_FEE_WIN_PATTERN:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Transition not allowed from StandBy mode (StandBy)\n", pxNFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Unexpected command for this mode (StandBy, cmd=%hhu)\n", pxNFeeP->ucId, uiCmdFEEL.ucByte[2]);
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
		case M_FEE_DT_SOURCE:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
			}
			#endif
			break;
		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED:
			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sInit;
			pxNFeeP->xControl.xDeb.eMode = sOFF;
			pxNFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL=0; ucIL<N_OF_CCD; ucIL++) {
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
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
			for (ucIL=0; ucIL<N_OF_CCD; ucIL++) {
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
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
			vActivateContentErrInj(pxNFeeP);
			vActivateDataPacketErrInj(pxNFeeP);
			/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
			for ( ucIL = (pxNFeeP->ucId * 4) ; ucIL < (pxNFeeP->ucId * 4 + 4); ucIL++ ){
				/* Stop the Comm Channels */
				bFeebStopCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffers from the Comm Channels */
				bFeebClrCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the Comm Channels */
				bFeebStartCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
			}
			break;
		case M_MASTER_SYNC:
			/* Increment AEBs Timestamps - [rfranca] */
			bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxNFeeP->xControl.xAeb[0].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxNFeeP->xControl.xAeb[1].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxNFeeP->xControl.xAeb[2].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxNFeeP->xControl.xAeb[3].bSwitchedOn);
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

			for (ucIL=0; ucIL<N_OF_CCD; ucIL++) {
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
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
		case M_FEE_DT_SOURCE:
			#if DEBUG_ON
			if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"NFEE %hhu Task:  Command not allowed for this mode \n", pxNFeeP->ucId);
			}
			#endif
			break;
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

			for (ucIL=0;ucIL<N_OF_CCD;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
				bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_ON_FORCED:

			pxNFeeP->xControl.bWatingSync = FALSE;
			pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
			pxNFeeP->xControl.xDeb.eMode = sOn;
			pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			pxNFeeP->xControl.xDeb.eState = sOn_Enter;

			for (ucIL=0;ucIL<N_OF_CCD;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
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
			vActivateContentErrInj(pxNFeeP);
			vActivateDataPacketErrInj(pxNFeeP);
			/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
			for ( ucIL = (pxNFeeP->ucId * 4) ; ucIL < (pxNFeeP->ucId * 4 + 4); ucIL++ ){
				/* Stop the Comm Channels */
				bFeebStopCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffers from the Comm Channels */
				bFeebClrCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the Comm Channels */
				bFeebStartCh(&pxNFeeP->xChannel[ucIL].xFeeBuffer);
			}
			if ( pxNFeeP->xControl.xDeb.eNextMode == pxNFeeP->xControl.xDeb.eLastMode )
				pxNFeeP->xControl.xDeb.eState = redoutCycle_Out; /*Is time to start the preparation of the double buffer in order to transmit data just after sync arrives*/
			else
				pxNFeeP->xControl.xDeb.eState = redoutCheckDTCUpdate; /*Received some command to change the mode, just go wait sync to change*/
			break;

		case M_MASTER_SYNC:
			/* Increment AEBs Timestamps - [rfranca] */
			bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxNFeeP->xControl.xAeb[0].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxNFeeP->xControl.xAeb[1].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxNFeeP->xControl.xAeb[2].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxNFeeP->xControl.xAeb[3].bSwitchedOn);
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
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
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

	for (ucIL=0; ucIL < N_OF_CCD; ucIL++ ){
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

	for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
		bDpktGetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiCcdXSize = pxNFeeP->xCcdInfo.usiHalfWidth + pxNFeeP->xCcdInfo.usiSPrescanN + pxNFeeP->xCcdInfo.usiSOverscanN;
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiCcdYSize = pxNFeeP->xCcdInfo.usiHeight + pxNFeeP->xCcdInfo.usiOLN;
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiDataYSize = pxNFeeP->xCcdInfo.usiHeight;
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiOverscanYSize = pxNFeeP->xCcdInfo.usiOLN;
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiPacketLength = xDefaults.usiFullSpwPLength;
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucProtocolId = xDefaults.usiDataProtId; /* 0xF0 ou  0x02*/
		pxNFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr = xDefaults.usiDpuLogicalAddr;
		bDpktSetPacketConfig(&pxNFeeP->xChannel[ucIL].xDataPacket);
	}

}

/**
 * @name bUpdateFeeHKValue
 * @author bndky
 * @brief Update RMAP HK function for simulated FEE
 * @ingroup rtos
 *
 * @param 	[in]	TRmapChannel 	*pxRmapCh
 * @param	[in]	alt_u16	        usiRmapHkID (same as Default ID)
 * @param	[in]	alt_u32			uliRawValue
 *
 * @retval boolean - True if success
 **/
bool bUpdateFeeHKValue ( TRmapChannel *pxRmapCh, alt_u16 usiRmapHkID, alt_u32 uliRawValue ) { // Before: 26124 bytes, After: 53792 bytes
	// Load current values
	bRmapGetRmapMemHkArea(pxRmapCh);

	// Switch case to assign value to register
	switch(usiRmapHkID){
		case eDefDebAreaCritCfg_DtcAebOnoff_bAebIdx3:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3 = (bool) uliRawValue;
			break;
		case eDefDebAreaCritCfg_DtcAebOnoff_bAebIdx2:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2 = (bool) uliRawValue;
			break;
		case eDefDebAreaCritCfg_DtcAebOnoff_bAebIdx1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1 = (bool) uliRawValue;
			break;
		case eDefDebAreaCritCfg_DtcAebOnoff_bAebIdx0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0 = (bool) uliRawValue;
			break;
		case eDefDebAreaCritCfg_DtcPllReg0_bPfdfc:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg0.bPfdfc = (bool) uliRawValue;
			break;
		case eDefDebAreaCritCfg_DtcPllReg0_bGtme:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg0.bGtme = (bool) uliRawValue;
			break;
		case eDefDebAreaCritCfg_DtcPllReg0_bHoldtr:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldtr = (bool) uliRawValue;
			break;
		case eDefDebAreaCritCfg_DtcPllReg0_bHoldf:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldf = (bool) uliRawValue;
			break;
		case eDefDebAreaCritCfg_DtcPllReg0_ucOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg0.ucOthers = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaCritCfg_DtcPllReg1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefDebAreaCritCfg_DtcPllReg2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefDebAreaCritCfg_DtcPllReg3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefDebAreaCritCfg_DtcFeeMod_ucOperMod:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaCritCfg_DtcImmOnmod_bImmOn:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcImmOnmod.bImmOn = (bool) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcInMod_ucT7InMod:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcInMod_ucT6InMod:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcInMod_ucT5InMod:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcInMod_ucT4InMod:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcInMod_ucT3InMod:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcInMod_ucT2InMod:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcInMod_ucT1InMod:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcInMod_ucT0InMod:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcWdwSiz_ucWSizX:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcWdwSiz_ucWSizY:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx4:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4 = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen4:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4 = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx3:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3 = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen3:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3 = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx2:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2 = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen2:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2 = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1 = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1 = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcOvsPat_ucOvsLinPat:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcSizPat_usiNbLinPat:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcSizPat_usiNbPixPat:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcTrg25S_ucN25SNCyc:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcSelTrg_bTrgSrc:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSelTrg.bTrgSrc = (bool) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcFrmCnt_usiPsetFrmCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcSelSyn_bSynFrq:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSelSyn.bSynFrq = (bool) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcRstCps_bRstSpw:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstSpw = (bool) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcRstCps_bRstWdg:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstWdg = (bool) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtc25SDly_uliN25SDly:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly = (alt_u32) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcTmodConf_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefDebAreaGenCfg_CfgDtcSpwCfg_ucTimecode:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaHk_DebStatus_ucOperMod:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaHk_DebStatus_ucEdacListCorrErr:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaHk_DebStatus_ucEdacListUncorrErr:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaHk_DebStatus_ucOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOthers = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaHk_DebStatus_bVdigAeb4:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = (bool) uliRawValue;
			break;
		case eDefDebAreaHk_DebStatus_bVdigAeb3:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = (bool) uliRawValue;
			break;
		case eDefDebAreaHk_DebStatus_bVdigAeb2:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = (bool) uliRawValue;
			break;
		case eDefDebAreaHk_DebStatus_bVdigAeb1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = (bool) uliRawValue;
			break;
		case eDefDebAreaHk_DebStatus_ucWdwListCntOvf:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf = (alt_u8) uliRawValue;
			break;
		case eDefDebAreaHk_DebStatus_bWdg:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bWdg = (bool) uliRawValue;
			break;
		case eDefDebAreaHk_DebOvf_bRowActList8:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList8 = (bool) uliRawValue;
			break;
		case eDefDebAreaHk_DebOvf_bRowActList7:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList7 = (bool) uliRawValue;
			break;
		case eDefDebAreaHk_DebOvf_bRowActList6:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList6 = (bool) uliRawValue;
			break;
		case eDefDebAreaHk_DebOvf_bRowActList5:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList5 = (bool) uliRawValue;
			break;
		case eDefDebAreaHk_DebOvf_bRowActList4:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList4 = (bool) uliRawValue;
			break;
		case eDefDebAreaHk_DebOvf_bRowActList3:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList3 = (bool) uliRawValue;
			break;
		case eDefDebAreaHk_DebOvf_bRowActList2:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList2 = (bool) uliRawValue;
			break;
		case eDefDebAreaHk_DebOvf_bRowActList1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList1 = (bool) uliRawValue;
			break;
		case eDefDebAreaHk_DebAhk1_usiVdigIn:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebAhk1.usiVdigIn = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaHk_DebAhk1_usiVio:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebAhk1.usiVio = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaHk_DebAhk2_usiVcor:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebAhk2.usiVcor = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaHk_DebAhk2_usiVlvd:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebAhk2.usiVlvd = (alt_u16) uliRawValue;
			break;
		case eDefDebAreaHk_DebAhk3_usiDebTemp:
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebAhk3.usiDebTemp = (alt_u16) uliRawValue;
			break;

		case eDefAeb1AreaCritCfg_AebControl_ucReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xAebControl.ucReserved = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_AebControl_ucNewState:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xAebControl.ucNewState = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_AebControl_bSetState:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xAebControl.bSetState = (bool) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_AebControl_bAebReset:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xAebControl.bAebReset = (bool) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_AebControl_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xAebControl.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_AebConfig_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xAebConfig.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_AebConfigKey_uliKey:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xAebConfigKey.uliKey = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_AebConfigAit_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_AebConfigPattern_ucPatternCcdid:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_AebConfigPattern_usiPatternCols:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = (alt_u16) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_AebConfigPattern_ucReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_AebConfigPattern_usiPatternRows:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = (alt_u16) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_VaspI2CControl_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_DacConfig1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xDacConfig1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_DacConfig2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xDacConfig2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_Reserved20_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xReserved20.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_PwrConfig1_ucTimeVccdOn:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_PwrConfig1_ucTimeVclkOn:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_PwrConfig1_ucTimeVan1On:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_PwrConfig1_ucTimeVan2On:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_PwrConfig2_ucTimeVan3On:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_PwrConfig2_ucTimeVccdOff:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_PwrConfig2_ucTimeVclkOff:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_PwrConfig2_ucTimeVan1Off:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_PwrConfig3_ucTimeVan2Off:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaCritCfg_PwrConfig3_ucTimeVan3Off:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_Adc1Config1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_Adc1Config2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_Adc1Config3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_Adc2Config1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_Adc2Config2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_Adc2Config3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_Reserved118_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xReserved118.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_Reserved11C_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xReserved11C.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig4_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig5_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig6_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig7_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig8_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig9_ucReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig9_usiFtLoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig9_bLt0Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled = (bool) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig9_bReserved1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 = (bool) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig9_usiLt0LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig10_bLt1Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled = (bool) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig10_bReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 = (bool) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig10_usiLt1LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig10_bLt2Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled = (bool) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig10_bReserved1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 = (bool) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig10_usiLt2LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig11_bLt3Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled = (bool) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig11_bReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig11.bReserved = (bool) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig11_usiLt3LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig11_usiPixLoopCntWord1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 = (alt_u16) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig12_usiPixLoopCntWord0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 = (alt_u16) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig12_bPcEnabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled = (bool) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig12_bReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig12.bReserved = (bool) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig12_usiPcLoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig13_ucReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig13_usiInt1LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig13_ucReserved1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig13_usiInt2LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb1AreaGenCfg_SeqConfig14_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AebStatus_ucAebStatus:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAebStatus.ucAebStatus = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaHk_AebStatus_ucOthers0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAebStatus.ucOthers0 = (alt_u8) uliRawValue;
			break;
		case eDefAeb1AreaHk_AebStatus_usiOthers1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAebStatus.usiOthers1 = (alt_u16) uliRawValue;
			break;
		case eDefAeb1AreaHk_Timestamp1_uliTimestampDword1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_Timestamp2_uliTimestampDword0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataTVaspL_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataTVaspR_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataTBiasP_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataTHkP_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataTTou1P_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataTTou2P_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataHkVode_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataHkVodf_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataHkVrd_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataHkVog_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataTCcd_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataTRef1KMea_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataTRef649RMea_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataHkAnaN5V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataSRef_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataHkCcdP31V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataHkClkP15V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataHkAnaP5V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataHkAnaP3V3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataHkDigP3V3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_AdcRdDataAdcRefBuf2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_VaspRdConfig_usiOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xVaspRdConfig.usiOthers = (alt_u16) uliRawValue;
			break;
		case eDefAeb1AreaHk_RevisionId1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xRevisionId1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb1AreaHk_RevisionId2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xRevisionId2.uliOthers = (alt_u32) uliRawValue;
			break;

		case eDefAeb2AreaCritCfg_AebControl_ucReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xAebControl.ucReserved = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_AebControl_ucNewState:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xAebControl.ucNewState = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_AebControl_bSetState:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xAebControl.bSetState = (bool) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_AebControl_bAebReset:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xAebControl.bAebReset = (bool) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_AebControl_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xAebControl.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_AebConfig_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xAebConfig.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_AebConfigKey_uliKey:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xAebConfigKey.uliKey = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_AebConfigAit_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_AebConfigPattern_ucPatternCcdid:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_AebConfigPattern_usiPatternCols:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = (alt_u16) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_AebConfigPattern_ucReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_AebConfigPattern_usiPatternRows:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = (alt_u16) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_VaspI2CControl_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_DacConfig1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xDacConfig1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_DacConfig2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xDacConfig2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_Reserved20_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xReserved20.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_PwrConfig1_ucTimeVccdOn:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_PwrConfig1_ucTimeVclkOn:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_PwrConfig1_ucTimeVan1On:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_PwrConfig1_ucTimeVan2On:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_PwrConfig2_ucTimeVan3On:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_PwrConfig2_ucTimeVccdOff:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_PwrConfig2_ucTimeVclkOff:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_PwrConfig2_ucTimeVan1Off:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_PwrConfig3_ucTimeVan2Off:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaCritCfg_PwrConfig3_ucTimeVan3Off:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_Adc1Config1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_Adc1Config2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_Adc1Config3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_Adc2Config1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_Adc2Config2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_Adc2Config3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_Reserved118_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xReserved118.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_Reserved11C_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xReserved11C.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig4_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig5_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig6_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig7_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig8_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig9_ucReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig9_usiFtLoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig9_bLt0Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled = (bool) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig9_bReserved1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 = (bool) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig9_usiLt0LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig10_bLt1Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled = (bool) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig10_bReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 = (bool) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig10_usiLt1LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig10_bLt2Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled = (bool) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig10_bReserved1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 = (bool) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig10_usiLt2LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig11_bLt3Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled = (bool) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig11_bReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig11.bReserved = (bool) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig11_usiLt3LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig11_usiPixLoopCntWord1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 = (alt_u16) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig12_usiPixLoopCntWord0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 = (alt_u16) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig12_bPcEnabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled = (bool) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig12_bReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig12.bReserved = (bool) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig12_usiPcLoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig13_ucReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig13_usiInt1LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig13_ucReserved1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig13_usiInt2LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb2AreaGenCfg_SeqConfig14_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AebStatus_ucAebStatus:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAebStatus.ucAebStatus = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaHk_AebStatus_ucOthers0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAebStatus.ucOthers0 = (alt_u8) uliRawValue;
			break;
		case eDefAeb2AreaHk_AebStatus_usiOthers1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAebStatus.usiOthers1 = (alt_u16) uliRawValue;
			break;
		case eDefAeb2AreaHk_Timestamp1_uliTimestampDword1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_Timestamp2_uliTimestampDword0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataTVaspL_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataTVaspR_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataTBiasP_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataTHkP_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataTTou1P_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataTTou2P_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataHkVode_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataHkVodf_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataHkVrd_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataHkVog_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataTCcd_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataTRef1KMea_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataTRef649RMea_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataHkAnaN5V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataSRef_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataHkCcdP31V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataHkClkP15V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataHkAnaP5V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataHkAnaP3V3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataHkDigP3V3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_AdcRdDataAdcRefBuf2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_VaspRdConfig_usiOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xVaspRdConfig.usiOthers = (alt_u16) uliRawValue;
			break;
		case eDefAeb2AreaHk_RevisionId1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xRevisionId1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb2AreaHk_RevisionId2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xRevisionId2.uliOthers = (alt_u32) uliRawValue;
			break;

		case eDefAeb3AreaCritCfg_AebControl_ucReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xAebControl.ucReserved = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_AebControl_ucNewState:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xAebControl.ucNewState = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_AebControl_bSetState:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xAebControl.bSetState = (bool) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_AebControl_bAebReset:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xAebControl.bAebReset = (bool) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_AebControl_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xAebControl.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_AebConfig_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xAebConfig.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_AebConfigKey_uliKey:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xAebConfigKey.uliKey = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_AebConfigAit_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_AebConfigPattern_ucPatternCcdid:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_AebConfigPattern_usiPatternCols:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = (alt_u16) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_AebConfigPattern_ucReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_AebConfigPattern_usiPatternRows:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = (alt_u16) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_VaspI2CControl_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_DacConfig1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xDacConfig1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_DacConfig2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xDacConfig2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_Reserved20_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xReserved20.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_PwrConfig1_ucTimeVccdOn:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_PwrConfig1_ucTimeVclkOn:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_PwrConfig1_ucTimeVan1On:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_PwrConfig1_ucTimeVan2On:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_PwrConfig2_ucTimeVan3On:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_PwrConfig2_ucTimeVccdOff:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_PwrConfig2_ucTimeVclkOff:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_PwrConfig2_ucTimeVan1Off:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_PwrConfig3_ucTimeVan2Off:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaCritCfg_PwrConfig3_ucTimeVan3Off:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_Adc1Config1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_Adc1Config2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_Adc1Config3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_Adc2Config1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_Adc2Config2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_Adc2Config3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_Reserved118_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xReserved118.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_Reserved11C_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xReserved11C.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig4_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig5_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig6_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig7_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig8_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig9_ucReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig9_usiFtLoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig9_bLt0Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled = (bool) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig9_bReserved1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 = (bool) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig9_usiLt0LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig10_bLt1Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled = (bool) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig10_bReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 = (bool) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig10_usiLt1LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig10_bLt2Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled = (bool) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig10_bReserved1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 = (bool) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig10_usiLt2LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig11_bLt3Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled = (bool) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig11_bReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig11.bReserved = (bool) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig11_usiLt3LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig11_usiPixLoopCntWord1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 = (alt_u16) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig12_usiPixLoopCntWord0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 = (alt_u16) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig12_bPcEnabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled = (bool) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig12_bReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig12.bReserved = (bool) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig12_usiPcLoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig13_ucReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig13_usiInt1LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig13_ucReserved1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig13_usiInt2LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb3AreaGenCfg_SeqConfig14_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AebStatus_ucAebStatus:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAebStatus.ucAebStatus = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaHk_AebStatus_ucOthers0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAebStatus.ucOthers0 = (alt_u8) uliRawValue;
			break;
		case eDefAeb3AreaHk_AebStatus_usiOthers1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAebStatus.usiOthers1 = (alt_u16) uliRawValue;
			break;
		case eDefAeb3AreaHk_Timestamp1_uliTimestampDword1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_Timestamp2_uliTimestampDword0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataTVaspL_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataTVaspR_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataTBiasP_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataTHkP_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataTTou1P_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataTTou2P_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataHkVode_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataHkVodf_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataHkVrd_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataHkVog_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataTCcd_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataTRef1KMea_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataTRef649RMea_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataHkAnaN5V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataSRef_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataHkCcdP31V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataHkClkP15V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataHkAnaP5V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataHkAnaP3V3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataHkDigP3V3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_AdcRdDataAdcRefBuf2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_VaspRdConfig_usiOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xVaspRdConfig.usiOthers = (alt_u16) uliRawValue;
			break;
		case eDefAeb3AreaHk_RevisionId1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xRevisionId1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb3AreaHk_RevisionId2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xRevisionId2.uliOthers = (alt_u32) uliRawValue;
			break;

		case eDefAeb4AreaCritCfg_AebControl_ucReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xAebControl.ucReserved = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_AebControl_ucNewState:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xAebControl.ucNewState = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_AebControl_bSetState:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xAebControl.bSetState = (bool) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_AebControl_bAebReset:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xAebControl.bAebReset = (bool) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_AebControl_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xAebControl.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_AebConfig_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xAebConfig.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_AebConfigKey_uliKey:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xAebConfigKey.uliKey = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_AebConfigAit_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_AebConfigPattern_ucPatternCcdid:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_AebConfigPattern_usiPatternCols:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = (alt_u16) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_AebConfigPattern_ucReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_AebConfigPattern_usiPatternRows:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = (alt_u16) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_VaspI2CControl_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_DacConfig1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xDacConfig1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_DacConfig2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xDacConfig2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_Reserved20_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xReserved20.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_PwrConfig1_ucTimeVccdOn:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_PwrConfig1_ucTimeVclkOn:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_PwrConfig1_ucTimeVan1On:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_PwrConfig1_ucTimeVan2On:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_PwrConfig2_ucTimeVan3On:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_PwrConfig2_ucTimeVccdOff:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_PwrConfig2_ucTimeVclkOff:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_PwrConfig2_ucTimeVan1Off:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_PwrConfig3_ucTimeVan2Off:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaCritCfg_PwrConfig3_ucTimeVan3Off:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_Adc1Config1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_Adc1Config2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_Adc1Config3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_Adc2Config1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_Adc2Config2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_Adc2Config3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_Reserved118_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xReserved118.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_Reserved11C_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xReserved11C.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig4_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig5_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig6_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig7_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig8_uliReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig9_ucReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig9_usiFtLoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig9_bLt0Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled = (bool) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig9_bReserved1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 = (bool) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig9_usiLt0LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig10_bLt1Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled = (bool) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig10_bReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 = (bool) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig10_usiLt1LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig10_bLt2Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled = (bool) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig10_bReserved1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 = (bool) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig10_usiLt2LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig11_bLt3Enabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled = (bool) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig11_bReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig11.bReserved = (bool) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig11_usiLt3LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig11_usiPixLoopCntWord1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 = (alt_u16) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig12_usiPixLoopCntWord0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 = (alt_u16) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig12_bPcEnabled:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled = (bool) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig12_bReserved:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig12.bReserved = (bool) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig12_usiPcLoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig13_ucReserved0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig13_usiInt1LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig13_ucReserved1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig13_usiInt2LoopCnt:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt = (alt_u16) uliRawValue;
			break;
		case eDefAeb4AreaGenCfg_SeqConfig14_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AebStatus_ucAebStatus:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAebStatus.ucAebStatus = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaHk_AebStatus_ucOthers0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAebStatus.ucOthers0 = (alt_u8) uliRawValue;
			break;
		case eDefAeb4AreaHk_AebStatus_usiOthers1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAebStatus.usiOthers1 = (alt_u16) uliRawValue;
			break;
		case eDefAeb4AreaHk_Timestamp1_uliTimestampDword1:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_Timestamp2_uliTimestampDword0:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataTVaspL_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataTVaspR_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataTBiasP_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataTHkP_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataTTou1P_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataTTou2P_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataHkVode_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataHkVodf_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataHkVrd_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataHkVog_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataTCcd_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataTRef1KMea_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataTRef649RMea_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataHkAnaN5V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataSRef_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataHkCcdP31V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataHkClkP15V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataHkAnaP5V_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataHkAnaP3V3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataHkDigP3V3_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_AdcRdDataAdcRefBuf2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_VaspRdConfig_usiOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xVaspRdConfig.usiOthers = (alt_u16) uliRawValue;
			break;
		case eDefAeb4AreaHk_RevisionId1_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xRevisionId1.uliOthers = (alt_u32) uliRawValue;
			break;
		case eDefAeb4AreaHk_RevisionId2_uliOthers:
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xRevisionId2.uliOthers = (alt_u32) uliRawValue;
			break;

		default:
			return FALSE;
			break;
	}

	bRmapSetRmapMemHkArea(pxRmapCh);

	return TRUE;
}

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
	bSpwcGetLinkConfig(xSPW);
	xSPW->xSpwcLinkConfig.bLinkStart = FALSE;
	xSPW->xSpwcLinkConfig.bAutostart = FALSE;
	xSPW->xSpwcLinkConfig.bDisconnect = TRUE;
	bSpwcSetLinkConfig(xSPW);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableSPWChannel( TSpwcChannel *xSPW ) {
	/* Enable SPW channel */
	bSpwcGetLinkConfig(xSPW);
	xSPW->xSpwcLinkConfig.bEnable = TRUE;
	xSPW->xSpwcLinkConfig.bLinkStart = xDefaults.bSpwLinkStart;
	xSPW->xSpwcLinkConfig.bAutostart = TRUE;
	xSPW->xSpwcLinkConfig.bDisconnect = FALSE;
	bSpwcSetLinkConfig(xSPW);

	/*todo: No treatment for now  */
	return TRUE;
}

void vConfigTinMode( TFFee *pxNFeeP , TtInMode *xTinModeP, unsigned ucTxin){
	unsigned char ucMode, ucX;

	(*xTinModeP).bSent = FALSE;

	ucX = ucTxin;
	switch (ucTxin) {
		case 7:
			ucMode = pxNFeeP->xControl.xDeb.ucTxInMode[ucX];
			switch (ucMode) {
				case eRmapT7InModSpw4RNoData0:
					/* Data source for right Fifo of SpW n4 : No data */
					(*xTinModeP).bDataOn = FALSE;
					break;
				case eRmapT7InModSpw4RAebDataCcd4F:
					/* Data source for right Fifo of SpW n4 : AEB data, CCD4 output F */
					(*xTinModeP).bDataOn = TRUE;
					(*xTinModeP).bPattern = FALSE;
					(*xTinModeP).ucAebNumber = 3;
					(*xTinModeP).ucSideCcd = eDpktCcdSideF; /*E = Left = 0 | F = Right = 1*/
					break;
				case eRmapT7InModSpw4RNoData1:
					/* Data source for right Fifo of SpW n4 : No data */
					(*xTinModeP).bDataOn = FALSE;
					break;
				case eRmapT7InModSpw4RPattDataCcd4F:
					/* Data source for right Fifo of SpW n4 : Pattern data, CCD4 output F */
					(*xTinModeP).bDataOn = TRUE;
					(*xTinModeP).bPattern = TRUE;
					(*xTinModeP).ucAebNumber = 3;
					(*xTinModeP).ucSideCcd = eDpktCcdSideF; /*E = Left = 0 | F = Right = 1*/
					break;
				default:
					/* Data source for right Fifo of SpW n4 : Unused */
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
					case eRmapT6InModSpw4LNoData0:
						/* Data source for left Fifo of SpW n4 : No data */
						(*xTinModeP).bDataOn = FALSE;
						break;
					case eRmapT6InModSpw4LAebDataCcd4E:
						/* Data source for left Fifo of SpW n4 : AEB data, CCD4 output E */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 3;
						(*xTinModeP).ucSideCcd = eDpktCcdSideE; /*E = Left = 0 | F = Right = 1*/
						break;
					case eRmapT6InModSpw4LAebDataCcd3F:
						/* Data source for left Fifo of SpW n4 : AEB data, CCD3 output F */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).ucSideCcd = eDpktCcdSideF; /*E = Left = 0 | F = Right = 1*/
						break;
					case eRmapT6InModSpw4LNoData1:
						/* Data source for left Fifo of SpW n4 : No data */
						(*xTinModeP).bDataOn = FALSE;
						break;
					case eRmapT6InModSpw4LPattDataCcd4E:
						/* Data source for left Fifo of SpW n4 : Pattern data, CCD4 output E */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 3;
						(*xTinModeP).ucSideCcd = eDpktCcdSideE; /*E = Left = 0 | F = Right = 1*/
						break;
					case eRmapT6InModSpw4LPattDataCcd3F:
						/* Data source for left Fifo of SpW n4 : Pattern data, CCD3 output F */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).ucSideCcd = eDpktCcdSideF; /*E = Left = 0 | F = Right = 1*/
						break;
					default:
						/* Data source for left Fifo of SpW n4 : Unused */
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
					case eRmapT5InModSpw3RNoData0:
						/* Data source for right Fifo of SpW n3 : No data */
						(*xTinModeP).bDataOn = FALSE;
						break;
					case eRmapT5InModSpw3RAebDataCcd3F:
						/* Data source for right Fifo of SpW n3 : AEB data, CCD3 output F */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).ucSideCcd = eDpktCcdSideF; /*E = Left = 0 | F = Right = 1*/
						break;
					case eRmapT5InModSpw3RAebDataCcd4E:
						/* Data source for right Fifo of SpW n3 : AEB data, CCD4 output E */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 3;
						(*xTinModeP).ucSideCcd = eDpktCcdSideE; /*E = Left = 0 | F = Right = 1*/
						break;
					case eRmapT5InModSpw3RNoData1:
						/* Data source for right Fifo of SpW n3 : No data */
						(*xTinModeP).bDataOn = FALSE;
						break;
					case eRmapT5InModSpw3RPattDataCcd3F:
						/* Data source for right Fifo of SpW n3 : Pattern data, CCD3 output F */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).ucSideCcd = eDpktCcdSideF; /*E = Left = 0 | F = Right = 1*/
						break;
					case eRmapT5InModSpw3RPattDataCcd4E:
						/* Data source for right Fifo of SpW n3 : Pattern data, CCD4 output E */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 3;
						(*xTinModeP).ucSideCcd = eDpktCcdSideE; /*E = Left = 0 | F = Right = 1*/
						break;
					default:
						/* Data source for right Fifo of SpW n3 : Unused */
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
					case eRmapT4InModSpw3LNoData0:
						/* Data source for left Fifo of SpW n3 : No data */
						(*xTinModeP).bDataOn = FALSE;
						break;
					case eRmapT4InModSpw3LAebDataCcd3E:
						/* Data source for left Fifo of SpW n3 : AEB data, CCD3 output E */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).ucSideCcd = eDpktCcdSideE; /*E = Left = 0 | F = Right = 1*/
						break;
					case eRmapT4InModSpw3LNoData1:
						/* Data source for left Fifo of SpW n3 : No data */
						(*xTinModeP).bDataOn = FALSE;
						break;
					case eRmapT4InModSpw3LPattDataCcd3E:
						/* Data source for left Fifo of SpW n3 : Pattern data, CCD3 output E */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).ucSideCcd = eDpktCcdSideE; /*E = Left = 0 | F = Right = 1*/
						break;
					default:
						/* Data source for left Fifo of SpW n3 : Unused */
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
					case eRmapT3InModSpw2RNoData0:
						/* Data source for right Fifo of SpW n2 : No data */
						(*xTinModeP).bDataOn = FALSE;
						break;
					case eRmapT3InModSpw2RAebDataCcd2F:
						/* Data source for right Fifo of SpW n2 : AEB data, CCD2 output F */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).ucSideCcd = eDpktCcdSideF; /*E = Left = 0 | F = Right = 1*/
						break;
					case eRmapT3InModSpw2RNoData1:
						/* Data source for right Fifo of SpW n2 : No data */
						(*xTinModeP).bDataOn = FALSE;
						break;
					case eRmapT3InModSpw2RPattDataCcd2F:
						/* Data source for right Fifo of SpW n2 : Pattern data, CCD2 output F */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 2;
						(*xTinModeP).ucSideCcd = eDpktCcdSideF; /*E = Left = 0 | F = Right = 1*/
						break;
					default:
						/* Data source for right Fifo of SpW n2 : Unused */
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
					case eRmapT2InModSpw2LNoData0:
						/* Data source for left Fifo of SpW n2 : No data */
						(*xTinModeP).bDataOn = FALSE;
						break;
					case eRmapT2InModSpw2LAebDataCcd2E:
						/* Data source for left Fifo of SpW n2 : AEB data, CCD2 output E */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 1;
						(*xTinModeP).ucSideCcd = eDpktCcdSideE; /*E = Left = 0 | F = Right = 1*/
						break;
					case eRmapT2InModSpw2LAebDataCcd1F:
						/* Data source for left Fifo of SpW n2 : AEB data, CCD1 output F */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 0;
						(*xTinModeP).ucSideCcd = eDpktCcdSideF; /*E = Left = 0 | F = Right = 1*/
						break;
					case eRmapT2InModSpw2LNoData1:
						/* Data source for left Fifo of SpW n2 : No data */
						(*xTinModeP).bDataOn = FALSE;
						break;
					case eRmapT2InModSpw2LPattDataCcd2E:
						/* Data source for left Fifo of SpW n2 : Pattern data, CCD2 output E */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 1;
						(*xTinModeP).ucSideCcd = eDpktCcdSideE; /*E = Left = 0 | F = Right = 1*/
						break;
					case eRmapT2InModSpw2LPattDataCcd1F:
						/* Data source for left Fifo of SpW n2 : Pattern data, CCD1 output F */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 0;
						(*xTinModeP).ucSideCcd = eDpktCcdSideF; /*E = Left = 0 | F = Right = 1*/
						break;
					default:
						/* Data source for left Fifo of SpW n2 : Unused */
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
					case eRmapT1InModSpw1RNoData0:
						/* Data source for right Fifo of SpW n1 : No data */
						(*xTinModeP).bDataOn = FALSE;
						break;
					case eRmapT1InModSpw1RAebDataCcd1F:
						/* Data source for right Fifo of SpW n1 : AEB data, CCD1 output F */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 0;
						(*xTinModeP).ucSideCcd = eDpktCcdSideF; /*E = Left = 0 | F = Right = 1*/
						break;
					case eRmapT1InModSpw1RAebDataCcd2E:
						/* Data source for right Fifo of SpW n1 : AEB data, CCD2 output E */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = FALSE;
						(*xTinModeP).ucAebNumber = 1;
						(*xTinModeP).ucSideCcd = eDpktCcdSideE; /*E = Left = 0 | F = Right = 1*/
						break;
					case eRmapT1InModSpw1RNoData1:
						/* Data source for right Fifo of SpW n1 : No data */
						(*xTinModeP).bDataOn = FALSE;
						break;
					case eRmapT1InModSpw1RPattDataCcd1F:
						/* Data source for right Fifo of SpW n1 : Pattern data, CCD1 output F */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 0;
						(*xTinModeP).ucSideCcd = eDpktCcdSideF; /*E = Left = 0 | F = Right = 1*/
						break;
					case eRmapT1InModSpw1RPattDataCcd2E:
						/* Data source for right Fifo of SpW n1 : Pattern data, CCD2 output E */
						(*xTinModeP).bDataOn = TRUE;
						(*xTinModeP).bPattern = TRUE;
						(*xTinModeP).ucAebNumber = 1;
						(*xTinModeP).ucSideCcd = eDpktCcdSideE; /*E = Left = 0 | F = Right = 1*/
						break;
					default:
						/* Data source for right Fifo of SpW n1 : Unused */
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
				case eRmapT0InModSpw1LNoData0:
					/* Data source for left Fifo of SpW n1 : No data */
					(*xTinModeP).bDataOn = FALSE;
					break;
				case eRmapT0InModSpw1LAebDataCcd1E:
					/* Data source for left Fifo of SpW n1 : AEB data, CCD1 output E */
					(*xTinModeP).bDataOn = TRUE;
					(*xTinModeP).bPattern = FALSE;
					(*xTinModeP).ucAebNumber = 0;
					(*xTinModeP).ucSideCcd = eDpktCcdSideE; /*E = Left = 0 | F = Right = 1*/
					break;
				case eRmapT0InModSpw1LNoData1:
					/* Data source for left Fifo of SpW n1 : No data */
					(*xTinModeP).bDataOn = FALSE;
					break;
				case eRmapT0InModSpw1LPattDataCcd1E:
					/* Data source for left Fifo of SpW n1 : Pattern data, CCD1 output E */
					(*xTinModeP).bDataOn = TRUE;
					(*xTinModeP).bPattern = TRUE;
					(*xTinModeP).ucAebNumber = 0;
					(*xTinModeP).ucSideCcd = eDpktCcdSideE; /*E = Left = 0 | F = Right = 1*/
					break;
				default:
					/* Data source for left Fifo of SpW n1 : Unused */
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
	pxFeebCh->xFeebIrqControl.bLeftBuffCtrlFinishedEn = TRUE;
	pxFeebCh->xFeebIrqControl.bRightBuffCtrlFinishedEn = TRUE;
	bFeebSetIrqControl(pxFeebCh);

	/*todo: No treatment for now  */
	return TRUE;
}


bool bDisAndClrDbBuffer( TFeebChannel *pxFeebCh ) {

	/*Disable IRQ of FEE Buffer*/
	bFeebGetIrqControl(pxFeebCh);
	pxFeebCh->xFeebIrqControl.bLeftBuffCtrlFinishedEn = FALSE;
	pxFeebCh->xFeebIrqControl.bRightBuffCtrlFinishedEn = FALSE;
	bFeebSetIrqControl(pxFeebCh);

	/* Stop the module Double Buffer */
	bFeebStopCh(pxFeebCh);

	/* Clear all buffer form the Double Buffer */
	bFeebClrCh(pxFeebCh);
	bFeebStartCh(pxFeebCh);

	/*todo: No treatment for now  */
	return TRUE;
}

inline void vActivateContentErrInj( TFFee *pxNFeeP ) {
	unsigned char ucIL;
	for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
		if (TRUE == pxNFeeP->xErrorInjControl[ucIL].xImgWinContentErr.bStartLeftErrorInj) {
			bDpktGetLeftContentErrInj(&pxNFeeP->xChannel[ucIL].xDataPacket);
			if (TRUE == pxNFeeP->xChannel[ucIL].xDataPacket.xDpktLeftContentErrInj.bInjecting) {
				bDpktContentErrInjStopInj(&pxNFeeP->xChannel[ucIL].xDataPacket, eDpktCcdSideE);
			}
			if (bDpktContentErrInjStartInj(&pxNFeeP->xChannel[ucIL].xDataPacket, eDpktCcdSideE)) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu AEB %hhu Task: Image and window error injection started (left side)\n", pxNFeeP->ucId, ucIL);
				#endif
			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu AEB %hhu Task: Image and window error injection could not start (left side)\n", pxNFeeP->ucId, ucIL);
				#endif
			}
			pxNFeeP->xErrorInjControl[ucIL].xImgWinContentErr.bStartLeftErrorInj = FALSE;
		}
		if (TRUE == pxNFeeP->xErrorInjControl[ucIL].xImgWinContentErr.bStartRightErrorInj) {
			bDpktGetRightContentErrInj(&pxNFeeP->xChannel[ucIL].xDataPacket);
			if (TRUE == pxNFeeP->xChannel[ucIL].xDataPacket.xDpktRightContentErrInj.bInjecting) {
				bDpktContentErrInjStopInj(&pxNFeeP->xChannel[ucIL].xDataPacket, eDpktCcdSideF);
			}
			if (bDpktContentErrInjStartInj(&pxNFeeP->xChannel[ucIL].xDataPacket, eDpktCcdSideF)) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu AEB %hhu Task: Image and window error injection started (right side)\n", pxNFeeP->ucId, ucIL);
				#endif
			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu AEB %hhu Task: Image and window error injection could not start (right side)\n", pxNFeeP->ucId, ucIL);
				#endif
			}
			pxNFeeP->xErrorInjControl[ucIL].xImgWinContentErr.bStartRightErrorInj = FALSE;
		}
	}
}

inline void vActivateDataPacketErrInj( TFFee *pxNFeeP ) {
	unsigned char ucIL;
	for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
		if (TRUE == pxNFeeP->xErrorInjControl[ucIL].xDataPktError.bStartErrorInj) {
			if ( bDpktHeaderErrInjStartInj(&pxNFeeP->xChannel[ucIL].xDataPacket) ) {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"NFEE %hhu AEB %hhu Task: Data packet header error injection started\n", pxNFeeP->ucId, ucIL);
				#endif
			} else {
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly )
					fprintf(fp,"NFEE %hhu AEB %hhu Task: Data packet header error injection could not start\n", pxNFeeP->ucId, ucIL);
				#endif
			}
			pxNFeeP->xErrorInjControl[ucIL].xDataPktError.bStartErrorInj = FALSE;
		}
	}
}

/*DLR DLR RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinModeOn( TFFee *pxNFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	INT8U ucMode, ucSpwTC, ucIL;
	INT8U ucEntity;
	INT8U ucAebNumber, ucNewState;
	INT16U usiADDRReg;
	bool bAebReset, bSetState;

	uiCmdFEEL.ulWord = cmd;
	ucEntity = uiCmdFEEL.ucByte[3];
	usiADDRReg = (INT16U)((uiCmdFEEL.ucByte[1] << 8) & 0xFF00) | ( uiCmdFEEL.ucByte[0] & 0x00FF );
	/* Send Event Log */
	vSendEventLogArr(pxNFeeP->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtRmapReceived]);

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case RMAP_DCC_DTC_AEB_ONOFF_ADR: //DTC_AEB_ONOFF (ICD p. 40)

				pxNFeeP->xControl.xAeb[0].bSwitchedOn = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[1].bSwitchedOn = pxNFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;
				pxNFeeP->xControl.xAeb[2].bSwitchedOn = pxNFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;
				pxNFeeP->xControl.xAeb[3].bSwitchedOn = pxNFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;

				/* Get AEBs On/Off Status - [rfranca] */
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = pxNFeeP->xControl.xAeb[0].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = pxNFeeP->xControl.xAeb[1].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = pxNFeeP->xControl.xAeb[2].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = pxNFeeP->xControl.xAeb[3].bSwitchedOn;
				break;
			case RMAP_DCC_DTC_FEE_MOD_ADR: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case eRmapDebOpModeFullImg:
						/* DEB Operational Mode 0 : DEB Full-Image Mode */
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Can't go to this mode from On mode\n\n");
						}
						#endif
						break;
					case eRmapDebOpModeFullImgPatt:
						/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
						pxNFeeP->xControl.xDeb.eState = sWaitSync;

						pxNFeeP->xControl.bWatingSync = TRUE;
						/* Real Fee State (graph) */
						pxNFeeP->xControl.xDeb.eLastMode = sOn_Enter;
						pxNFeeP->xControl.xDeb.eMode = sOn;
						pxNFeeP->xControl.xDeb.eNextMode = sFullPattern_Enter;
						/* Real State */
						pxNFeeP->xControl.xDeb.eState = sOn;

						break;
					case eRmapDebOpModeWin:
						/* DEB Operational Mode 2 : DEB Windowing Mode */
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Can't go to this mode from On mode\n\n");
						}
						#endif
						break;
					case eRmapDebOpModeWinPatt:
						/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
						pxNFeeP->xControl.xDeb.eState = sWaitSync;

						pxNFeeP->xControl.bWatingSync = TRUE;
						/* Real Fee State (graph) */
						pxNFeeP->xControl.xDeb.eLastMode = sOn_Enter;
						pxNFeeP->xControl.xDeb.eMode = sOn;
						pxNFeeP->xControl.xDeb.eNextMode = sWinPattern_Enter;
						/* Real State */
						pxNFeeP->xControl.xDeb.eState = sOn;

						break;
					case eRmapDebOpModeStandby:
						/* DEB Operational Mode 6 : DEB Standby Mode */

						/*Asynchronous*/
						pxNFeeP->xControl.xDeb.eState = sStandBy_Enter;

						pxNFeeP->xControl.xDeb.eMode = sStandBy;
						pxNFeeP->xControl.xDeb.eLastMode = sOn_Enter;
						pxNFeeP->xControl.xDeb.eNextMode = sStandBy_Enter;

						break;
					case eRmapDebOpModeOn:
						/* DEB Operational Mode 7 : DEB On Mode */
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

			case RMAP_DCC_DTC_IMM_ONMOD_ADR: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case RMAP_DGC_DTC_IN_MOD_1_ADR: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[7] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[6] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[5] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[4] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case RMAP_DGC_DTC_IN_MOD_2_ADR: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[3] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[2] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[1] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[0] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case RMAP_DGC_DTC_WDW_SIZ_ADR: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_WDW_IDX_1_ADR: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case RMAP_DGC_DTC_WDW_IDX_2_ADR:
			case RMAP_DGC_DTC_WDW_IDX_3_ADR:
			case RMAP_DGC_DTC_WDW_IDX_4_ADR:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_OVS_PAT_ADR: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SIZ_PAT_ADR: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_TRG_25S_ADR: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				vChangeSyncRepeat( &xSimMeb, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc );
				/* Check if the Sync Generator should be stopped */
				if (0 == pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc) {
					/* Sync Generator should be stopped */
					bSyncCtrHoldBlankPulse(TRUE);
				} else {
					/* Sync Generator should be running */
					bSyncCtrHoldBlankPulse(FALSE);
				}
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SEL_TRG_ADR: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_FRM_CNT_ADR: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				/* rfranca */
				for ( ucIL=0; ucIL < N_OF_CCD; ucIL++ ) {
					bDpktSetFrameCounterValue(&pxNFeeP->xChannel[ucIL].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				}
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[0].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[1].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[2].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[3].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SEL_SYN_ADR: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_RSP_CPS_ADR: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_25S_DLY_ADR: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_TMOD_CONF_ADR: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SPW_CFG_ADR: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				for ( ucIL=0; ucIL < N_OF_CCD; ucIL++ ) {
					pxNFeeP->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}
				//pxNFeeP->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				//pxNFeeP->xChannel[1].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				//pxNFeeP->xChannel[2].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				//pxNFeeP->xChannel[3].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;

				pxNFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
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
			case RMAP_ACC_AEB_CONTROL_ADR: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					/* Soft-Reset the AEB RMAP Areas (reset all registers) - [rfranca] */
					bRmapZeroFillAebRamMem(ucAebNumber);
					bRmapSoftRstAebMemArea(ucAebNumber);

					/* Set AEB to AEB_STATE_INIT  - [rfranca] */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = eRmapAebStateInit;
					pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
				} else if ( bSetState == TRUE ) {
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case eRmapAebStateOff:
							/* AEB State : AEB_STATE_OFF */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebOffMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_OFF \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateInit:
							/* AEB State : AEB_STATE_INIT */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebInitMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_INIT \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateConfig:
							/* AEB State : AEB_STATE_CONFIG */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebConfigMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_CONFIG \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateImage:
							/* AEB State : AEB_STATE_IMAGE */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebImageMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_IMAGE \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerDown:
							/* AEB State : AEB_STATE_POWER_DOWN */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerDownMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerUp:
							/* AEB State : AEB_STATE_POWER_UP */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerUpMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePattern:
							/* AEB State : AEB_STATE_PATTERN */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPatternMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_PATTERN \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateFailure:
							/* AEB State : AEB_STATE_FAILURE */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebFailureMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							/* AEB State : Unused/Spare */
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case RMAP_ACC_AEB_CONFIG_PATTERN_ADR: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
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
	/* Send Event Log */
	vSendEventLogArr(pxNFeeP->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtRmapReceived]);

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case RMAP_DCC_DTC_AEB_ONOFF_ADR: //DTC_AEB_ONOFF (ICD p. 40)

				pxNFeeP->xControl.xAeb[0].bSwitchedOn = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[1].bSwitchedOn = pxNFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;
				pxNFeeP->xControl.xAeb[2].bSwitchedOn = pxNFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;
				pxNFeeP->xControl.xAeb[3].bSwitchedOn = pxNFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;

				/* Get AEBs On/Off Status - [rfranca] */
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = pxNFeeP->xControl.xAeb[0].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = pxNFeeP->xControl.xAeb[1].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = pxNFeeP->xControl.xAeb[2].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = pxNFeeP->xControl.xAeb[3].bSwitchedOn;
				break;
			case RMAP_DCC_DTC_FEE_MOD_ADR: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case eRmapDebOpModeFullImg:
						/* DEB Operational Mode 0 : DEB Full-Image Mode */
					case eRmapDebOpModeWin:
						/* DEB Operational Mode 2 : DEB Windowing Mode */
						for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
					case eRmapDebOpModeFullImgPatt:
						/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
					case eRmapDebOpModeWinPatt:
						/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
						for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
					case eRmapDebOpModeStandby:
						/* DEB Operational Mode 6 : DEB Standby Mode */

						if (( pxNFeeP->xControl.xDeb.eMode == sFullImage ) || (pxNFeeP->xControl.xDeb.eMode == sWindowing)){
							pxNFeeP->xControl.bWatingSync = TRUE;
							pxNFeeP->xControl.xDeb.eState = redoutWaitBeforeSyncSignal; /*Will stay until master sync*/
							pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;
						} else {
							for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
					case eRmapDebOpModeOn:
						/* DEB Operational Mode 7 : DEB On Mode */
						if (( pxNFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxNFeeP->xControl.xDeb.eMode == sWinPattern)) {

							pxNFeeP->xControl.bWatingSync = TRUE;
							pxNFeeP->xControl.xDeb.eState = redoutWaitBeforeSyncSignal; /*Will stay until master sync*/
							pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;

						} else {
							for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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

			case RMAP_DCC_DTC_IMM_ONMOD_ADR: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case RMAP_DGC_DTC_IN_MOD_1_ADR: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[7] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[6] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[5] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[4] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case RMAP_DGC_DTC_IN_MOD_2_ADR: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[3] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[2] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[1] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[0] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case RMAP_DGC_DTC_WDW_SIZ_ADR: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_WDW_IDX_1_ADR: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case RMAP_DGC_DTC_WDW_IDX_2_ADR:
			case RMAP_DGC_DTC_WDW_IDX_3_ADR:
			case RMAP_DGC_DTC_WDW_IDX_4_ADR:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_OVS_PAT_ADR: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SIZ_PAT_ADR: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_TRG_25S_ADR: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SEL_TRG_ADR: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_FRM_CNT_ADR: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				/* rfranca */
				bDpktSetFrameCounterValue(&pxNFeeP->xChannel[0].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				bDpktSetFrameCounterValue(&pxNFeeP->xChannel[1].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				bDpktSetFrameCounterValue(&pxNFeeP->xChannel[2].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				bDpktSetFrameCounterValue(&pxNFeeP->xChannel[3].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SEL_SYN_ADR: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_RSP_CPS_ADR: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_25S_DLY_ADR: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_TMOD_CONF_ADR: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SPW_CFG_ADR: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				pxNFeeP->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				pxNFeeP->xChannel[1].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				pxNFeeP->xChannel[2].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				pxNFeeP->xChannel[3].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;

				pxNFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
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
			case RMAP_ACC_AEB_CONTROL_ADR: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					/* Soft-Reset the AEB RMAP Areas (reset all registers) - [rfranca] */
					bRmapSoftRstAebMemArea(ucAebNumber);
					bRmapZeroFillAebRamMem(ucAebNumber);

					/* Set AEB to AEB_STATE_INIT  - [rfranca] */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = eRmapAebStateInit;
					pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
				} else if ( bSetState == TRUE ) {
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case eRmapAebStateOff:
							/* AEB State : AEB_STATE_OFF */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebOffMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_OFF \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateInit:
							/* AEB State : AEB_STATE_INIT */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebInitMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_INIT \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateConfig:
							/* AEB State : AEB_STATE_CONFIG */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebConfigMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_CONFIG \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateImage:
							/* AEB State : AEB_STATE_IMAGE */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebImageMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_IMAGE \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerDown:
							/* AEB State : AEB_STATE_POWER_DOWN */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerDownMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerUp:
							/* AEB State : AEB_STATE_POWER_UP */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerUpMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePattern:
							/* AEB State : AEB_STATE_PATTERN */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPatternMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_PATTERN \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateFailure:
							/* AEB State : AEB_STATE_FAILURE */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebFailureMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							/* AEB State : Unused/Spare */
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case RMAP_ACC_AEB_CONFIG_PATTERN_ADR: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
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

	/* Send Event Log */
	vSendEventLogArr(pxNFeeP->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtRmapReceived]);

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case RMAP_DCC_DTC_AEB_ONOFF_ADR: //DTC_AEB_ONOFF (ICD p. 40)

				pxNFeeP->xControl.xAeb[0].bSwitchedOn = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[1].bSwitchedOn = pxNFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;
				pxNFeeP->xControl.xAeb[2].bSwitchedOn = pxNFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;
				pxNFeeP->xControl.xAeb[3].bSwitchedOn = pxNFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;

				/* Get AEBs On/Off Status - [rfranca] */
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = pxNFeeP->xControl.xAeb[0].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = pxNFeeP->xControl.xAeb[1].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = pxNFeeP->xControl.xAeb[2].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = pxNFeeP->xControl.xAeb[3].bSwitchedOn;
				break;
			case RMAP_DCC_DTC_FEE_MOD_ADR: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case eRmapDebOpModeFullImg:
						/* DEB Operational Mode 0 : DEB Full-Image Mode */
					case eRmapDebOpModeWin:
						/* DEB Operational Mode 2 : DEB Windowing Mode */
						for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
					case eRmapDebOpModeFullImgPatt:
						/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
					case eRmapDebOpModeWinPatt:
						/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
						for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
					case eRmapDebOpModeStandby:
						/* DEB Operational Mode 6 : DEB Standby Mode */
						if (( pxNFeeP->xControl.xDeb.eMode == sFullImage ) || (pxNFeeP->xControl.xDeb.eMode == sWindowing)){

							pxNFeeP->xControl.bWatingSync = TRUE;
							pxNFeeP->xControl.xDeb.eState = redoutCheckDTCUpdate; /*Will stay until master sync*/
							pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;
						} else {
							for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
					case eRmapDebOpModeOn:
						/* DEB Operational Mode 7 : DEB On Mode */
						/*Before sync, so it need to end the transmission/double buffer and wait for the sync*/
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

			case RMAP_DCC_DTC_IMM_ONMOD_ADR: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case RMAP_DGC_DTC_IN_MOD_1_ADR: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[7] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[6] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[5] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[4] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case RMAP_DGC_DTC_IN_MOD_2_ADR: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[3] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[2] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[1] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[0] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case RMAP_DGC_DTC_WDW_SIZ_ADR: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_WDW_IDX_1_ADR: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case RMAP_DGC_DTC_WDW_IDX_2_ADR:
			case RMAP_DGC_DTC_WDW_IDX_3_ADR:
			case RMAP_DGC_DTC_WDW_IDX_4_ADR:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_OVS_PAT_ADR: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SIZ_PAT_ADR: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_TRG_25S_ADR: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SEL_TRG_ADR: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_FRM_CNT_ADR: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				/* rfranca */
				for ( ucIL=0; ucIL < N_OF_CCD; ucIL++ ) {
					bDpktSetFrameCounterValue(&pxNFeeP->xChannel[ucIL].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				}
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[0].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[1].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[2].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[3].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SEL_SYN_ADR: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_RSP_CPS_ADR: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_25S_DLY_ADR: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_TMOD_CONF_ADR: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SPW_CFG_ADR: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				for ( ucIL=0; ucIL < N_OF_CCD; ucIL++ ) {
					pxNFeeP->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}

				pxNFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
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
			case RMAP_ACC_AEB_CONTROL_ADR: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					/* Soft-Reset the AEB RMAP Areas (reset all registers) - [rfranca] */
					bRmapSoftRstAebMemArea(ucAebNumber);
					bRmapZeroFillAebRamMem(ucAebNumber);

					/* Set AEB to AEB_STATE_INIT  - [rfranca] */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = eRmapAebStateInit;
					pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
				} else if ( bSetState == TRUE ) {
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case eRmapAebStateOff:
							/* AEB State : AEB_STATE_OFF */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebOffMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_OFF \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateInit:
							/* AEB State : AEB_STATE_INIT */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebInitMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_INIT \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateConfig:
							/* AEB State : AEB_STATE_CONFIG */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebConfigMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_CONFIG \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateImage:
							/* AEB State : AEB_STATE_IMAGE */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebImageMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_IMAGE \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerDown:
							/* AEB State : AEB_STATE_POWER_DOWN */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerDownMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerUp:
							/* AEB State : AEB_STATE_POWER_UP */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerUpMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePattern:
							/* AEB State : AEB_STATE_PATTERN */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPatternMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_PATTERN \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateFailure:
							/* AEB State : AEB_STATE_FAILURE */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebFailureMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							/* AEB State : Unused/Spare */
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case RMAP_ACC_AEB_CONFIG_PATTERN_ADR: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
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
	/* Send Event Log */
	vSendEventLogArr(pxNFeeP->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtRmapReceived]);

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case RMAP_DCC_DTC_AEB_ONOFF_ADR: //DTC_AEB_ONOFF (ICD p. 40)

				pxNFeeP->xControl.xAeb[0].bSwitchedOn = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[1].bSwitchedOn = pxNFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;
				pxNFeeP->xControl.xAeb[2].bSwitchedOn = pxNFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;
				pxNFeeP->xControl.xAeb[3].bSwitchedOn = pxNFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;

				/* Get AEBs On/Off Status - [rfranca] */
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = pxNFeeP->xControl.xAeb[0].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = pxNFeeP->xControl.xAeb[1].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = pxNFeeP->xControl.xAeb[2].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = pxNFeeP->xControl.xAeb[3].bSwitchedOn;
				break;
			case RMAP_DCC_DTC_FEE_MOD_ADR: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case eRmapDebOpModeFullImg:
						/* DEB Operational Mode 0 : DEB Full-Image Mode */
						pxNFeeP->xControl.bWatingSync = TRUE;
						/* Real Fee State (graph) */
						pxNFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
						pxNFeeP->xControl.xDeb.eMode = sStandBy;
						pxNFeeP->xControl.xDeb.eNextMode = sFullImage_Enter;
						/* Real State */
						pxNFeeP->xControl.xDeb.eState = sStandBy;
						break;

					case eRmapDebOpModeWin:
						/* DEB Operational Mode 2 : DEB Windowing Mode */
						pxNFeeP->xControl.bWatingSync = TRUE;
						/* Real Fee State (graph) */
						pxNFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
						pxNFeeP->xControl.xDeb.eMode = sStandBy;
						pxNFeeP->xControl.xDeb.eNextMode = sWindowing_Enter;
						/* Real State */
						pxNFeeP->xControl.xDeb.eState = sStandBy;
						break;
					case eRmapDebOpModeFullImgPatt:
						/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
					case eRmapDebOpModeWinPatt:
						/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
						for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
					case eRmapDebOpModeStandby:
						/* DEB Operational Mode 6 : DEB Standby Mode */
						#if DEBUG_ON
						if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Already in this mode. (Stand-By Mode)\n\n");
						}
						#endif
						break;
					case eRmapDebOpModeOn:
						/* DEB Operational Mode 7 : DEB On Mode */
						pxNFeeP->xControl.bWatingSync = FALSE;
						pxNFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
						pxNFeeP->xControl.xDeb.eMode = sOn;
						pxNFeeP->xControl.xDeb.eNextMode = sOn_Enter;

						pxNFeeP->xControl.xDeb.eState = sOn_Enter; /* Asynchronous */
						break;
					default:
						for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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

			case RMAP_DCC_DTC_IMM_ONMOD_ADR: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case RMAP_DGC_DTC_IN_MOD_1_ADR: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[7] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[6] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[5] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[4] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case RMAP_DGC_DTC_IN_MOD_2_ADR: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[3] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[2] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[1] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[0] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case RMAP_DGC_DTC_WDW_SIZ_ADR: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_WDW_IDX_1_ADR: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case RMAP_DGC_DTC_WDW_IDX_2_ADR:
			case RMAP_DGC_DTC_WDW_IDX_3_ADR:
			case RMAP_DGC_DTC_WDW_IDX_4_ADR:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_OVS_PAT_ADR: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SIZ_PAT_ADR: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_TRG_25S_ADR: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SEL_TRG_ADR: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_FRM_CNT_ADR: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				/* rfranca */
				for ( ucIL=0; ucIL < N_OF_CCD; ucIL++ ) {
					bDpktSetFrameCounterValue(&pxNFeeP->xChannel[ucIL].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				}
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[0].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[1].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[2].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[3].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SEL_SYN_ADR: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_RSP_CPS_ADR: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_25S_DLY_ADR: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_TMOD_CONF_ADR: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SPW_CFG_ADR: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				for ( ucIL=0; ucIL < N_OF_CCD; ucIL++ ) {
					pxNFeeP->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}

				pxNFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
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
			case RMAP_ACC_AEB_CONTROL_ADR: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					/* Soft-Reset the AEB RMAP Areas (reset all registers) - [rfranca] */
					bRmapSoftRstAebMemArea(ucAebNumber);
					bRmapZeroFillAebRamMem(ucAebNumber);

					/* Set AEB to AEB_STATE_INIT  - [rfranca] */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = eRmapAebStateInit;
					pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
				} else if ( bSetState == TRUE ) {
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case eRmapAebStateOff:
							/* AEB State : AEB_STATE_OFF */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebOffMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_OFF \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateInit:
							/* AEB State : AEB_STATE_INIT */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebInitMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_INIT \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateConfig:
							/* AEB State : AEB_STATE_CONFIG */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebConfigMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_CONFIG \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateImage:
							/* AEB State : AEB_STATE_IMAGE */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebImageMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_IMAGE \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerDown:
							/* AEB State : AEB_STATE_POWER_DOWN */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerDownMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerUp:
							/* AEB State : AEB_STATE_POWER_UP */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerUpMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePattern:
							/* AEB State : AEB_STATE_PATTERN */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPatternMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_PATTERN \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateFailure:
							/* AEB State : AEB_STATE_FAILURE */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebFailureMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							/* AEB State : Unused/Spare */
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case RMAP_ACC_AEB_CONFIG_PATTERN_ADR: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
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
	/* Send Event Log */
	vSendEventLogArr(pxNFeeP->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtRmapReceived]);

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case RMAP_DCC_DTC_AEB_ONOFF_ADR: //DTC_AEB_ONOFF (ICD p. 40)

				pxNFeeP->xControl.xAeb[0].bSwitchedOn = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[1].bSwitchedOn = pxNFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;
				pxNFeeP->xControl.xAeb[2].bSwitchedOn = pxNFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;
				pxNFeeP->xControl.xAeb[3].bSwitchedOn = pxNFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;

				/* Get AEBs On/Off Status - [rfranca] */
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = pxNFeeP->xControl.xAeb[0].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = pxNFeeP->xControl.xAeb[1].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = pxNFeeP->xControl.xAeb[2].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = pxNFeeP->xControl.xAeb[3].bSwitchedOn;
				break;
			case RMAP_DCC_DTC_FEE_MOD_ADR: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case eRmapDebOpModeFullImg:
						/* DEB Operational Mode 0 : DEB Full-Image Mode */
					case eRmapDebOpModeWin:
						/* DEB Operational Mode 2 : DEB Windowing Mode */
					case eRmapDebOpModeFullImgPatt:
						/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
					case eRmapDebOpModeWinPatt:
						/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
					case eRmapDebOpModeStandby:
						/* DEB Operational Mode 6 : DEB Standby Mode */
					case eRmapDebOpModeOn:
						/* DEB Operational Mode 7 : DEB On Mode */
						for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
						for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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

			case RMAP_DCC_DTC_IMM_ONMOD_ADR: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case RMAP_DGC_DTC_IN_MOD_1_ADR: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[7] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[6] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[5] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[4] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case RMAP_DGC_DTC_IN_MOD_2_ADR: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[3] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[2] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[1] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[0] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case RMAP_DGC_DTC_WDW_SIZ_ADR: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_WDW_IDX_1_ADR: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case RMAP_DGC_DTC_WDW_IDX_2_ADR:
			case RMAP_DGC_DTC_WDW_IDX_3_ADR:
			case RMAP_DGC_DTC_WDW_IDX_4_ADR:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_OVS_PAT_ADR: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SIZ_PAT_ADR: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_TRG_25S_ADR: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SEL_TRG_ADR: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_FRM_CNT_ADR: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				/* rfranca */
				for ( ucIL=0; ucIL < N_OF_CCD; ucIL++ ) {
					bDpktSetFrameCounterValue(&pxNFeeP->xChannel[ucIL].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				}
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[0].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[1].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[2].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[3].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SEL_SYN_ADR: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_RSP_CPS_ADR: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_25S_DLY_ADR: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_TMOD_CONF_ADR: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SPW_CFG_ADR: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				for ( ucIL=0; ucIL < N_OF_CCD; ucIL++ ) {
					pxNFeeP->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}

				pxNFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
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
			case RMAP_ACC_AEB_CONTROL_ADR: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					/* Soft-Reset the AEB RMAP Areas (reset all registers) - [rfranca] */
					bRmapSoftRstAebMemArea(ucAebNumber);
					bRmapZeroFillAebRamMem(ucAebNumber);

					/* Set AEB to AEB_STATE_INIT  - [rfranca] */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = eRmapAebStateInit;
					pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
				} else if ( bSetState == TRUE ) {
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case eRmapAebStateOff:
							/* AEB State : AEB_STATE_OFF */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebOffMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_OFF \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateInit:
							/* AEB State : AEB_STATE_INIT */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebInitMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_INIT \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateConfig:
							/* AEB State : AEB_STATE_CONFIG */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebConfigMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_CONFIG \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateImage:
							/* AEB State : AEB_STATE_IMAGE */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebImageMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_IMAGE \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerDown:
							/* AEB State : AEB_STATE_POWER_DOWN */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerDownMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerUp:
							/* AEB State : AEB_STATE_POWER_UP */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerUpMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePattern:
							/* AEB State : AEB_STATE_PATTERN */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPatternMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_PATTERN \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateFailure:
							/* AEB State : AEB_STATE_FAILURE */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebFailureMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							/* AEB State : Unused/Spare */
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case RMAP_ACC_AEB_CONFIG_PATTERN_ADR: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
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
	/* Send Event Log */
	vSendEventLogArr(pxNFeeP->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtRmapReceived]);

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case RMAP_DCC_DTC_AEB_ONOFF_ADR: //DTC_AEB_ONOFF (ICD p. 40)

				pxNFeeP->xControl.xAeb[0].bSwitchedOn = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[1].bSwitchedOn = pxNFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;
				pxNFeeP->xControl.xAeb[2].bSwitchedOn = pxNFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;
				pxNFeeP->xControl.xAeb[3].bSwitchedOn = pxNFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;

				/* Get AEBs On/Off Status - [rfranca] */
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = pxNFeeP->xControl.xAeb[0].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = pxNFeeP->xControl.xAeb[1].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = pxNFeeP->xControl.xAeb[2].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = pxNFeeP->xControl.xAeb[3].bSwitchedOn;
				break;
			case RMAP_DCC_DTC_FEE_MOD_ADR: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case eRmapDebOpModeFullImg:
						/* DEB Operational Mode 0 : DEB Full-Image Mode */
					case eRmapDebOpModeWin:
						/* DEB Operational Mode 2 : DEB Windowing Mode */
						for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
					case eRmapDebOpModeFullImgPatt:
						/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
					case eRmapDebOpModeWinPatt:
						/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
						for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
					case eRmapDebOpModeStandby:
						/* DEB Operational Mode 6 : DEB Standby Mode */
						if (( pxNFeeP->xControl.xDeb.eMode == sFullImage ) || (pxNFeeP->xControl.xDeb.eMode == sWindowing)){
							pxNFeeP->xControl.bWatingSync = TRUE;
							pxNFeeP->xControl.xDeb.eState = redoutWaitSync; /*Will stay until master sync*/
							pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;
						} else {
							for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
					case eRmapDebOpModeOn:
						/* DEB Operational Mode 7 : DEB On Mode */
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
						for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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

			case RMAP_DCC_DTC_IMM_ONMOD_ADR: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case RMAP_DGC_DTC_IN_MOD_1_ADR: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[7] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[6] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[5] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[4] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case RMAP_DGC_DTC_IN_MOD_2_ADR: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[3] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[2] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[1] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[0] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case RMAP_DGC_DTC_WDW_SIZ_ADR: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_WDW_IDX_1_ADR: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case RMAP_DGC_DTC_WDW_IDX_2_ADR:
			case RMAP_DGC_DTC_WDW_IDX_3_ADR:
			case RMAP_DGC_DTC_WDW_IDX_4_ADR:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_OVS_PAT_ADR: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SIZ_PAT_ADR: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_TRG_25S_ADR: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SEL_TRG_ADR: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_FRM_CNT_ADR: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				/* rfranca */
				for ( ucIL=0; ucIL < N_OF_CCD; ucIL++ ) {
					bDpktSetFrameCounterValue(&pxNFeeP->xChannel[ucIL].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				}
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[0].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[1].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[2].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[3].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SEL_SYN_ADR: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_RSP_CPS_ADR: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_25S_DLY_ADR: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_TMOD_CONF_ADR: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SPW_CFG_ADR: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				for ( ucIL=0; ucIL < N_OF_CCD; ucIL++ ) {
					pxNFeeP->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}

				pxNFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
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
			case RMAP_ACC_AEB_CONTROL_ADR: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					/* Soft-Reset the AEB RMAP Areas (reset all registers) - [rfranca] */
					bRmapSoftRstAebMemArea(ucAebNumber);
					bRmapZeroFillAebRamMem(ucAebNumber);

					/* Set AEB to AEB_STATE_INIT  - [rfranca] */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = eRmapAebStateInit;
					pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
				} else if ( bSetState == TRUE ) {
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case eRmapAebStateOff:
							/* AEB State : AEB_STATE_OFF */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebOffMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_OFF \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateInit:
							/* AEB State : AEB_STATE_INIT */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebInitMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_INIT \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateConfig:
							/* AEB State : AEB_STATE_CONFIG */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebConfigMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_CONFIG \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateImage:
							/* AEB State : AEB_STATE_IMAGE */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebImageMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_IMAGE \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerDown:
							/* AEB State : AEB_STATE_POWER_DOWN */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerDownMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerUp:
							/* AEB State : AEB_STATE_POWER_UP */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerUpMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePattern:
							/* AEB State : AEB_STATE_PATTERN */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPatternMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_PATTERN \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateFailure:
							/* AEB State : AEB_STATE_FAILURE */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebFailureMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							/* AEB State : Unused/Spare */
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case RMAP_ACC_AEB_CONFIG_PATTERN_ADR: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
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
	/* Send Event Log */
	vSendEventLogArr(pxNFeeP->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtRmapReceived]);

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case RMAP_DCC_DTC_AEB_ONOFF_ADR: //DTC_AEB_ONOFF (ICD p. 40)

				pxNFeeP->xControl.xAeb[0].bSwitchedOn = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxNFeeP->xControl.xAeb[1].bSwitchedOn = pxNFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;
				pxNFeeP->xControl.xAeb[2].bSwitchedOn = pxNFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;
				pxNFeeP->xControl.xAeb[3].bSwitchedOn = pxNFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;

				/* Get AEBs On/Off Status - [rfranca] */
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = pxNFeeP->xControl.xAeb[0].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = pxNFeeP->xControl.xAeb[1].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = pxNFeeP->xControl.xAeb[2].bSwitchedOn;
				pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = pxNFeeP->xControl.xAeb[3].bSwitchedOn;
				break;
			case RMAP_DCC_DTC_FEE_MOD_ADR: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case eRmapDebOpModeFullImg:
						/* DEB Operational Mode 0 : DEB Full-Image Mode */
					case eRmapDebOpModeWin:
						/* DEB Operational Mode 2 : DEB Windowing Mode */
						for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
					case eRmapDebOpModeFullImgPatt:
						/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
					case eRmapDebOpModeWinPatt:
						/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
						for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
					case eRmapDebOpModeStandby:
						/* DEB Operational Mode 6 : DEB Standby Mode */
						if (( pxNFeeP->xControl.xDeb.eMode == sFullImage ) || (pxNFeeP->xControl.xDeb.eMode == sWindowing)){
							pxNFeeP->xControl.bWatingSync = TRUE;
							pxNFeeP->xControl.xDeb.eState = redoutTransmission; /*Will stay until master sync*/
							pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;

						} else {
							for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
					case eRmapDebOpModeOn:
						/* DEB Operational Mode 7 : DEB On Mode */
						if (( pxNFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxNFeeP->xControl.xDeb.eMode == sWinPattern)) {

							pxNFeeP->xControl.bWatingSync = TRUE;
							pxNFeeP->xControl.xDeb.eState = redoutTransmission; /*Will stay until master sync*/
							pxNFeeP->xControl.xDeb.eNextMode = pxNFeeP->xControl.xDeb.eLastMode;

						} else {
							for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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
						for ( ucIL=0; ucIL < N_OF_CCD ; ucIL++ ){
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

			case RMAP_DCC_DTC_IMM_ONMOD_ADR: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxNFeeP->xControl.xDeb.eState = sOn_Enter;

				pxNFeeP->xControl.xDeb.eMode = sOn;
				pxNFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxNFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case RMAP_DGC_DTC_IN_MOD_1_ADR: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[7] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[6] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[5] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[4] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case RMAP_DGC_DTC_IN_MOD_2_ADR: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxNFeeP->xControl.xDeb.ucTxInMode[3] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[2] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[1] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxNFeeP->xControl.xDeb.ucTxInMode[0] = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case RMAP_DGC_DTC_WDW_SIZ_ADR: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_WDW_IDX_1_ADR: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case RMAP_DGC_DTC_WDW_IDX_2_ADR:
			case RMAP_DGC_DTC_WDW_IDX_3_ADR:
			case RMAP_DGC_DTC_WDW_IDX_4_ADR:
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_OVS_PAT_ADR: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SIZ_PAT_ADR: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_TRG_25S_ADR: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SEL_TRG_ADR: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_FRM_CNT_ADR: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				/* rfranca */
				for ( ucIL=0; ucIL < N_OF_CCD; ucIL++ ) {
					bDpktSetFrameCounterValue(&pxNFeeP->xChannel[ucIL].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				}
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[0].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[1].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[2].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxNFeeP->xChannel[3].xDataPacket, pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SEL_SYN_ADR: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_RSP_CPS_ADR: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_25S_DLY_ADR: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_TMOD_CONF_ADR: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case RMAP_DGC_DTC_SPW_CFG_ADR: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxNFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				for ( ucIL=0; ucIL < N_OF_CCD; ucIL++ ) {
					pxNFeeP->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}

				pxNFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
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
			case RMAP_ACC_AEB_CONTROL_ADR: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					/* Soft-Reset the AEB RMAP Areas (reset all registers) - [rfranca] */
					bRmapSoftRstAebMemArea(ucAebNumber);
					bRmapZeroFillAebRamMem(ucAebNumber);

					/* Set AEB to AEB_STATE_INIT  - [rfranca] */
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = eRmapAebStateInit;
					pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
				} else if ( bSetState == TRUE ) {
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxNFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case eRmapAebStateOff:
							/* AEB State : AEB_STATE_OFF */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebOffMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_OFF \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateInit:
							/* AEB State : AEB_STATE_INIT */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebInitMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_INIT \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateConfig:
							/* AEB State : AEB_STATE_CONFIG */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebConfigMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_CONFIG \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateImage:
							/* AEB State : AEB_STATE_IMAGE */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebImageMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_IMAGE \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerDown:
							/* AEB State : AEB_STATE_POWER_DOWN */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerDownMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerUp:
							/* AEB State : AEB_STATE_POWER_UP */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerUpMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePattern:
							/* AEB State : AEB_STATE_PATTERN */
							pxNFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPatternMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_PATTERN \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateFailure:
							/* AEB State : AEB_STATE_FAILURE */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebFailureMode]);
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							/* AEB State : Unused/Spare */
							#if DEBUG_ON
							if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case RMAP_ACC_AEB_CONFIG_PATTERN_ADR: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
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
