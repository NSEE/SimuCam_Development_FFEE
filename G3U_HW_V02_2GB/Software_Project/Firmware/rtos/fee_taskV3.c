/*
 * fee_taskV2.c
 *
 *  Created on: 22 de ago de 2019
 *      Author: Tiago-note
 */

#include "fee_taskV3.h"

void vFeeTaskV3(void *task_data) {
	TFFee *pxFee;
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
	pxFee = ( TFFee * ) task_data;

	#if DEBUG_ON
	if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
		fprintf(fp,"Fast FEE %hhu Task. (Task on)\n", pxFee->ucId);
	}
	#endif

	for(;;){

		switch (pxFee->xControl.xDeb.eState) {
			case sInit:

				/* Flush the queue */
				error_code = OSQFlush( xFeeQ[ pxFee->ucId ] );
				if ( error_code != OS_NO_ERR )
					vFailFlushFEEQueue();

				/*Initializing the the values of the RMAP memory area */
				vInitialConfig_RmapMemArea( pxFee );

				/*Initializing the HW DataPacket*/
				vInitialConfig_DpktPacket( pxFee );

				/* Change the configuration of RMAP for a particular FEE*/
				vInitialConfig_RMAPCodecConfig( pxFee );

				/* Initial configuration for TimeCode Transmission */
				pxFee->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = xConfSpw[pxFee->ucId].bTimeCodeTransmissionEn;
				for ( ucIL = 1; ucIL < N_OF_CCD; ucIL++ ) {
					pxFee->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}

				/* Initial configuration for SpW Channels data inputs (TxInMod) */
				for (ucIL = 0; ucIL < 8; ucIL++){
					xTinMode[ucIL].ucAebNumber  = 0;
					xTinMode[ucIL].ucSideCcd    = eDpktCcdSideE;
					xTinMode[ucIL].ucSpWChannel = 0;
					xTinMode[ucIL].bDataOn      = FALSE;
					xTinMode[ucIL].bPattern     = FALSE;
					xTinMode[ucIL].bSent        = FALSE;
					/* Fixed in the ICD */
					xTinMode[ucIL].ucSideSpw    = (ucIL % 2 == 0) ? eCommLeftBuffer : eCommRightBuffer;
					xTinMode[ucIL].ucSpWChannel = (ucIL >> 1);
				}

				/* Initial configuration for several simulation parameters */

				usiSpwPLengthL = xConfSpw[pxFee->ucId].usiFullSpwPLength;

				/*0..2264*/
				pxFee->xCommon.ulVStart = 0;
				pxFee->xCommon.ulVEnd = pxFee->xCcdInfo.usiHeight + pxFee->xCcdInfo.usiOLN - 1;
				/*0..2294*/
				pxFee->xCommon.ulHStart = 0;
				pxFee->xCommon.ulHEnd = pxFee->xCcdInfo.usiHalfWidth + pxFee->xCcdInfo.usiSPrescanN + pxFee->xCcdInfo.usiSOverscanN - 1;

				for (ucIL = 0; ucIL < N_OF_CCD; ucIL++ ){

					/* Set FEE Machine Parameters */
					bFeebGetMachineControl(&pxFee->xChannel[ucIL].xFeeBuffer);
					pxFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bBufferOverflowEn = xDefaults.bBufferOverflowEn;
					pxFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bDigitaliseEn = TRUE;
					pxFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bReadoutEn = TRUE;
					pxFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bWindowListEn = TRUE;
					bFeebSetMachineControl(&pxFee->xChannel[ucIL].xFeeBuffer);

					/* Clear all FEE Machine Statistics */
					bFeebClearMachineStatistics(&pxFee->xChannel[ucIL].xFeeBuffer);

					/* Set the Pixel Storage Size - [rfranca] */
					bFeebSetPxStorageSize(&pxFee->xChannel[ucIL].xFeeBuffer, eCommLeftBuffer, FEEB_PX_DEF_STORAGE_SIZE_BYTES, xConfSpw[pxFee->ucId].usiFullSpwPLength);
					bFeebSetPxStorageSize(&pxFee->xChannel[ucIL].xFeeBuffer, eCommRightBuffer, FEEB_PX_DEF_STORAGE_SIZE_BYTES, xConfSpw[pxFee->ucId].usiFullSpwPLength);

					/* Disable SpaceWire Link */
					bSpwcGetLinkConfig(&(pxFee->xChannel[ucIL].xSpacewire));
					pxFee->xChannel[ucIL].xSpacewire.xSpwcLinkConfig.bEnable     = FALSE;
					pxFee->xChannel[ucIL].xSpacewire.xSpwcLinkConfig.bDisconnect = TRUE;
					pxFee->xChannel[ucIL].xSpacewire.xSpwcLinkConfig.bLinkStart  = FALSE;
					pxFee->xChannel[ucIL].xSpacewire.xSpwcLinkConfig.bAutostart  = FALSE;
					pxFee->xChannel[ucIL].xSpacewire.xSpwcLinkConfig.ucTxDivCnt  = ucSpwcCalculateLinkDiv(xConfSpw[pxFee->ucId].ucSpwLinkSpeed);
					bSpwcSetLinkConfig(&(pxFee->xChannel[ucIL].xSpacewire));
				}

				/* Initial configuration for FGS feature */
				usiH = pxFee->xCcdInfo.usiHeight + pxFee->xCcdInfo.usiOLN;
				usiW = pxFee->xCcdInfo.usiHalfWidth + pxFee->xCcdInfo.usiSPrescanN + pxFee->xCcdInfo.usiSOverscanN;
				for (ucAebIdL = 0; ucAebIdL < N_OF_CCD; ucAebIdL++ ){
					for (ucCcdSideL = 0; ucCcdSideL < 2; ucCcdSideL++ ){
						bFtdiSetImagettesParams(pxFee->ucId, ucAebIdL, ucCcdSideL, usiW, usiH ,(alt_u32 *)(pxFee->xMemMap.xAebMemCcd[ucAebIdL].xSide[ucCcdSideL].ulOffsetAddr + COMM_WINDOING_PARAMETERS_OFST));
					}
				}

				pxFee->xControl.xDeb.eState = sOFF_Enter;
				break;

			case sOFF_Enter:/* Transition */

				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: Off Mode\n", pxFee->ucId);
				}
				#endif

				/* End of simulation! Clear everything that is possible */

				/* Sends information to the NUC that it entered OFF mode */
				vSendFEEStatus(pxFee->ucId, 1);
				/* Send Event Log */
				vSendEventLogArr(pxFee->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtDebOffMode]);

				/* If a transition to On was requested when the FEE is waiting to go to Calibration,
				 * configure the hardware to not send any data in the next sync */
				for (ucIL = 0; ucIL < N_OF_CCD; ucIL++ ){

					bDpktGetPacketConfig(&pxFee->xChannel[ucIL].xDataPacket);
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiCcdVEnd             = pxFee->xCcdInfo.usiHeight + pxFee->xCcdInfo.usiOLN - 1;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiCcdImgVEnd          = pxFee->xCcdInfo.usiHeight - 1;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiCcdOvsVEnd          = pxFee->xCcdInfo.usiOLN - 1;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiCcdHStart           = 0;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiCcdHEnd             = pxFee->xCcdInfo.usiHalfWidth + pxFee->xCcdInfo.usiSPrescanN + pxFee->xCcdInfo.usiSOverscanN - 1;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.bCcdImgEn              = TRUE;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.bCcdOvsEn              = TRUE;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.usiPacketLength        = xConfSpw[pxFee->ucId].usiFullSpwPLength;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucProtocolId           = xConfSpw[pxFee->ucId].ucDataProtId;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr          = xConfSpw[pxFee->ucId].ucDpuLogicalAddr;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer    = eDpktOff;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer   = eDpktOff;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucCcdNumberLeftBuffer  = 0;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucCcdNumberRightBuffer = 0;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucCcdSideLeftBuffer    = eDpktCcdSideE;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucCcdSideRightBuffer   = eDpktCcdSideF;
					bDpktSetPacketConfig(&pxFee->xChannel[ucIL].xDataPacket);

					bFeebGetMachineControl(&pxFee->xChannel[ucIL].xFeeBuffer);
					pxFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bDigitaliseEn = TRUE;
					pxFee->xChannel[ucIL].xFeeBuffer.xFeebMachineControl.bReadoutEn = TRUE;
					bFeebSetMachineControl(&pxFee->xChannel[ucIL].xFeeBuffer);

					/* Disable the link SPW */
					bDisableSPWChannel( &pxFee->xChannel[ucIL].xSpacewire, ucIL );

					/* Disable RMAP interrupts */
					bDisableRmapIRQ(&pxFee->xChannel[ucIL].xRmap, pxFee->ucSPWId[ucIL]);

					/* Reset Channel DMAs */
					bSdmaResetCommDma(pxFee->ucSPWId[ucIL], eSdmaLeftBuffer, TRUE);
					bSdmaResetCommDma(pxFee->ucSPWId[ucIL], eSdmaRightBuffer, TRUE);

					/* Disable IRQ and clear the Double Buffer */
					bDisAndClrDbBuffer(&pxFee->xChannel[ucIL].xFeeBuffer);
				}
				pxFee->xControl.bChannelEnable = FALSE;

				/* Clear configuration for TimeCode Transmission */
				pxFee->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = xConfSpw[pxFee->ucId].bTimeCodeTransmissionEn;
				for ( ucIL = 1; ucIL < N_OF_CCD; ucIL++ ) {
					pxFee->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}

				/* Clear configuration for SpW Channels data inputs (TxInMod) */
				for (ucIL = 0; ucIL < 8; ucIL++){
					xTinMode[ucIL].ucAebNumber  = 0;
					xTinMode[ucIL].ucSideCcd    = eDpktCcdSideE;
					xTinMode[ucIL].ucSpWChannel = 0;
					xTinMode[ucIL].bDataOn      = FALSE;
					xTinMode[ucIL].bPattern     = FALSE;
					xTinMode[ucIL].bSent        = FALSE;
				}

				/* Clear TimeCode and Switch off the AEBs */
				pxFee->xControl.xDeb.ucTimeCode = 0;
				for (ucIL = 0; ucIL < N_OF_CCD; ucIL++ ){
					pxFee->xControl.xAeb[ucIL].bSwitchedOn = FALSE;
					pxFee->xControl.xAeb[ucIL].eState = sAebOFF;
					/* Clear AEB Timestamp - [rfranca] */
					bRmapClrAebTimestamp(ucIL);
				}

				/* Clear AEBs On/Off Control - [rfranca] */
				pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0 = FALSE;
				pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1 = FALSE;
				pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2 = FALSE;
				pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3 = FALSE;

				/* Clear AEBs On/Off Status - [rfranca] */
				pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = FALSE;
				pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = FALSE;
				pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = FALSE;
				pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = FALSE;

				/* Enable all RMAP Channels - [rfranca] */
				vRmapCh1EnableCodec(TRUE);
				vRmapCh2EnableCodec(TRUE);
				vRmapCh3EnableCodec(TRUE);
				vRmapCh4EnableCodec(TRUE);

				/* Return RMAP Config to On mode - [rfranca] */
				pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod = eRmapDebOpModeOn;

				/* Zero-Fill all RMAP RAM Memories - [rfranca] */
				vRmapZeroFillDebRamMem();
				for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
					bRmapZeroFillAebRamMem(ucIL);
				}

				/* Soft-Reset all RMAP Areas (reset all registers to configured default) - [rfranca] */
				vInitialConfig_RmapMemArea( pxFee );

				/* Clear configuration for several simulation parameters */
				pxFee->xControl.bWatingSync = FALSE;
				pxFee->xControl.bSimulating = FALSE;
				pxFee->xControl.bUsingDMA = FALSE;
				pxFee->xControl.bTransientMode = TRUE;

				/*Clear all control variables that control the data in the RAM for this FEE*/
				vResetMemCCDFEE(pxFee);

				/*Clear the queue message for this FEE*/
				error_code = OSQFlush( xFeeQ[ pxFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushFEEQueue();
				}

				ucRetries = 0;

				/* Real Fee State (graph) */
				pxFee->xControl.xDeb.eLastMode = sInit;
				pxFee->xControl.xDeb.eMode = sOFF;
				pxFee->xControl.xDeb.eNextMode = sOFF;

				pxFee->xControl.xDeb.eDebRealMode = eDebRealStOff;

				/* Real State */
				pxFee->xControl.xDeb.eState = sOFF;
				break;

			case sOFF:

				/*Wait for message in the Queue*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinConfig( pxFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxFee->ucId);
					}
					#endif
				}
				break;


			case sOn_Enter:

				/*Clear the queue message for this FEE*/
				error_code = OSQFlush( xFeeQ[ pxFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushFEEQueue();
				}

				/* Sends information to the NUC that it left CONFIG mode */
				vSendFEEStatus(pxFee->ucId, 0);

				/* Send Event Log */
				vSendEventLogArr(pxFee->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtDebOnMode]);

				for (ucIL = 0; ucIL < 4; ucIL++ ){
					/* Write in the RMAP */
					bRmapGetRmapMemCfgArea(&pxFee->xChannel[ucIL].xRmap);
					pxFee->xChannel[ucIL].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeOn; /* DEB Operational Mode 7 : DEB On Mode */
					bRmapSetRmapMemCfgArea(&pxFee->xChannel[ucIL].xRmap);

					/* If a transition to On was requested when the FEE is waiting to go to Calibration,
					 * configure the hardware to not send any data in the next sync */
					bDpktGetPacketConfig(&pxFee->xChannel[ucIL].xDataPacket);
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
					pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
					bDpktSetPacketConfig(&pxFee->xChannel[ucIL].xDataPacket);

					/* Reset Channel DMAs */
					bSdmaResetCommDma(pxFee->ucSPWId[ucIL], eSdmaLeftBuffer, TRUE);
					bSdmaResetCommDma(pxFee->ucSPWId[ucIL], eSdmaRightBuffer, TRUE);

					/* Disable IRQ and clear the Double Buffer */
					bDisAndClrDbBuffer(&pxFee->xChannel[ucIL].xFeeBuffer);

					/* Enable RMAP interrupts */
					bEnableRmapIRQ(&pxFee->xChannel[ucIL].xRmap, pxFee->ucId);

					/* Enable the link SPW */
					bEnableSPWChannel( &pxFee->xChannel[ucIL].xSpacewire, ucIL );
				}

				pxFee->xControl.bChannelEnable = TRUE;

				/*Enabling some important variables*/
				pxFee->xControl.bSimulating = TRUE;
				pxFee->xControl.bUsingDMA = FALSE;

				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: On Mode\n", pxFee->ucId);
				}
				#endif

				pxFee->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxFee->xControl.xDeb.eLastMode = pxFee->xControl.xDeb.eMode;
				pxFee->xControl.xDeb.eMode = sOn;
				pxFee->xControl.xDeb.eNextMode = sOn;

				pxFee->xControl.xDeb.eDebRealMode = eDebRealStOn;

				/* Real State */
				pxFee->xControl.xDeb.eState = sOn;
				break;

			case sOn:
				/*Wait for commands in the Queue*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinOn( pxFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxFee->ucId);
					}
					#endif
				}
				break;


			case sStandBy_Enter:

				/* Send Event Log */
				vSendEventLogArr(pxFee->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtDebStandbyMode]);

				for (ucIL = 0; ucIL < N_OF_CCD; ucIL++ ){
					/* Write in the RMAP */
					bRmapGetRmapMemCfgArea(&pxFee->xChannel[ucIL].xRmap);
					pxFee->xChannel[ucIL].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeStandby; /* DEB Operational Mode 6 : DEB Standby Mode */
					bRmapSetRmapMemCfgArea(&pxFee->xChannel[ucIL].xRmap);

					/* Disable IRQ and clear the Double Buffer */
					bDisAndClrDbBuffer(&pxFee->xChannel[ucIL].xFeeBuffer);

					/* Disable RMAP interrupts */
					bEnableRmapIRQ(&pxFee->xChannel[ucIL].xRmap, pxFee->ucId);

					/* Enable the link SPW */
					bEnableSPWChannel( &pxFee->xChannel[ucIL].xSpacewire, ucIL );
				}

				pxFee->xControl.bChannelEnable = TRUE;

				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: Standby\n", pxFee->ucId);
				}
				#endif

				pxFee->xControl.bUsingDMA = FALSE;

				pxFee->xControl.bWatingSync = TRUE;
				/* Real Fee State (graph) */
				pxFee->xControl.xDeb.eLastMode = pxFee->xControl.xDeb.eMode;
				pxFee->xControl.xDeb.eMode = sStandBy;
				pxFee->xControl.xDeb.eNextMode = sStandBy;

				pxFee->xControl.xDeb.eDebRealMode = eDebRealStStandBy;

				//vSendMessageNUCModeFeeChange( pxFFee->ucId, (unsigned short int)pxFFee->xControl.eMode );
				pxFee->xControl.xDeb.eState = sStandBy;
				break;


			case sStandBy:
				/*Wait for commands in the Queue*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdFEEinStandBy( pxFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxFee->ucId);
					}
					#endif
				}
				break;

			case sWaitSync:
				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: (sFeeWaitingSync)\n", pxFee->ucId);
				}
				#endif

				/* Wait for sync, or any other command*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code != OS_ERR_NONE ) {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ (sFeeWaitingSync)\n", pxFee->ucId);
					}
					#endif
				} else {
					vQCmdFEEinWaitingSync( pxFee, uiCmdFEE.ulWord  );
				}
				break;

			case sFullPattern_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: Going to FullImage Pattern.\n", pxFee->ucId);
				}
				#endif

				/* Send Event Log */
				vSendEventLogArr(pxFee->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtDebFullImagePatternMode]);

				/* Real Fee State (graph) */
				pxFee->xControl.xDeb.eLastMode = sOn_Enter;
				pxFee->xControl.xDeb.eMode = sFullPattern;
				pxFee->xControl.xDeb.eNextMode = sFullPattern;

				pxFee->xControl.xDeb.eDebRealMode = eDebRealStFullPattern;

				/* Real State */
				pxFee->xControl.xDeb.eState = redoutCycle_Enter;
				break;

			case sWinPattern_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: Going to Windowing Pattern.\n", pxFee->ucId);
				}
				#endif

				/* Send Event Log */
				vSendEventLogArr(pxFee->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtDebWindowingPatternMode]);

				/* Real Fee State (graph) */
				pxFee->xControl.xDeb.eLastMode = sOn_Enter;
				pxFee->xControl.xDeb.eMode = sWinPattern;
				pxFee->xControl.xDeb.eNextMode = sWinPattern;

				pxFee->xControl.xDeb.eDebRealMode = eDebRealStWinPattern;

				/* Real State */
				pxFee->xControl.xDeb.eState = redoutCycle_Enter;
				break;

			case sFullImage_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: Going to FullImage after Sync.\n", pxFee->ucId);
				}
				#endif

				/* Send Event Log */
				vSendEventLogArr(pxFee->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtDebFullImageMode]);

				/* Real Fee State (graph) */
				pxFee->xControl.xDeb.eLastMode = sStandBy_Enter;
				pxFee->xControl.xDeb.eMode = sFullImage;
				pxFee->xControl.xDeb.eNextMode = sFullImage;

				pxFee->xControl.xDeb.eDebRealMode = eDebRealStFullImage;

				/* Real State */
				pxFee->xControl.xDeb.eState = redoutCycle_Enter;
				break;

			case sWindowing_Enter:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: Going to Windowing after Sync.\n", pxFee->ucId);
				}
				#endif

				/* Send Event Log */
				vSendEventLogArr(pxFee->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtDebWindowingMode]);

				/* Real Fee State (graph) */
				pxFee->xControl.xDeb.eLastMode = sStandBy_Enter;
				pxFee->xControl.xDeb.eMode = sWindowing;
				pxFee->xControl.xDeb.eNextMode = sWindowing;

				pxFee->xControl.xDeb.eDebRealMode = eDebRealStWindowing;

				/* Real State */
				pxFee->xControl.xDeb.eState = redoutCycle_Enter;
				break;

/*============================== Readout Cycle Implementation ========================*/

			case redoutCycle_Enter:

				/* Indicates that this FEE will now need to use DMA*/
				pxFee->xControl.bUsingDMA = TRUE;
				xTrans[0].bFirstT = TRUE;
				pxFee->xControl.bTransientMode = TRUE;


				if (xGlobal.bJustBeforSync == FALSE)
					pxFee->xControl.xDeb.eState = redoutWaitBeforeSyncSignal;
				else
					pxFee->xControl.xDeb.eState = redoutCheckRestr;

				break;

				/*Pre Sync*/
			case redoutWaitBeforeSyncSignal:


				/*Will wait for the Before sync signal, probably in this state it will need to treat many RMAP commands*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdWaitBeforeSyncSignal( pxFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxFee->ucId);
					}
					#endif
				}
				break;



			case redoutCheckDTCUpdate:

				/*Check if is needed wait the update of the memory, need only in the last readout cycle */
				if ( xGlobal.bPreMaster == FALSE ) {
					pxFee->xControl.xDeb.eState = redoutCheckRestr;
				} else {
					if ( (xGlobal.bDTCFinished == TRUE) || (xGlobal.bJustBeforSync == TRUE) ) {
						/*If DTC already updated the memory then can go*/
						pxFee->xControl.xDeb.eState = redoutCheckRestr;
					} else {
						/*Wait for commands in the Queue, expected to receive the message informing that DTC finished the memory update*/
						uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxFee->ucId ] , 0, &error_code); /* Blocking operation */
						if ( error_code == OS_ERR_NONE ) {
							vQCmdFEEinWaitingMemUpdate( pxFee, uiCmdFEE.ulWord );
						} else {
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxFee->ucId);
							}
							#endif
						}
					}
				}
				break;

			case redoutCheckRestr:

				/*The Meb My have sent a message to inform the finish of the update of the image*/
				error_code = OSQFlush( xFeeQ[ pxFee->ucId ] );
				if ( error_code != OS_NO_ERR ) {
					vFailFlushFEEQueue();
				}

				for (ucIL = 0; ucIL < N_OF_CCD; ucIL++ ){
					/* Wait until both buffers are empty  */
					vWaitUntilBufferEmpty( pxFee->ucSPWId[ucIL] );
				}
				/* Guard time that HW MAYBE need, this will be used during the development, will be removed in some future version*/
				OSTimeDlyHMSM(0, 0, 0, min_sim(xDefaults.usiGuardFEEDelay,1)); //todo: For now fixed in 2 ms

				/*Reset Fee Buffer every Master Sync*/
				if ( xGlobal.bPreMaster == TRUE ) {
					for (ucIL = 0; ucIL < N_OF_CCD; ucIL++ ){
						/* Stop the module Double Buffer */
						bFeebStopCh(&pxFee->xChannel[ucIL].xFeeBuffer);
						/* Clear all buffer form the Double Buffer */
						bFeebClrCh(&pxFee->xChannel[ucIL].xFeeBuffer);
						/* Start the module Double Buffer */
						bFeebStartCh(&pxFee->xChannel[ucIL].xFeeBuffer);
					}
				}
				pxFee->xControl.xDeb.eState = redoutConfigureTrans;

				break;

			case redoutConfigureTrans:

				/*Check if this FEE is in Full*/
				if ( (pxFee->xControl.xDeb.eMode == sFullPattern) || (pxFee->xControl.xDeb.eMode == sFullImage)) {
					/*Check if there is any type of error enabled*/
					//bErrorInj = pxFFee->xControl.xErrorSWCtrl.bMissingData || pxFFee->xControl.xErrorSWCtrl.bMissingPkts || pxFFee->xControl.xErrorSWCtrl.bTxDisabled;
					for (ucIL = 0; ucIL < N_OF_CCD; ucIL++ ){
						bDpktGetTransmissionErrInj(&pxFee->xChannel[ucIL].xDataPacket);
						pxFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bMissingDataEn = pxFee->xErrorInjControl[ucIL].xErrorSWCtrlFull.bMissingData;
						pxFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bMissingPktsEn = pxFee->xErrorInjControl[ucIL].xErrorSWCtrlFull.bMissingPkts;
						pxFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bTxDisabledEn  = pxFee->xErrorInjControl[ucIL].xErrorSWCtrlFull.bTxDisabled;
						pxFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.ucFrameNum     = pxFee->xErrorInjControl[ucIL].xErrorSWCtrlFull.ucFrameNum;
						pxFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiDataCnt     = pxFee->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiDataCnt;
						pxFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiNRepeat     = pxFee->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiNRepeat;
						pxFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiSequenceCnt = pxFee->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiSequenceCnt;
						bDpktSetTransmissionErrInj(&pxFee->xChannel[ucIL].xDataPacket);
					}
				} else if ( (pxFee->xControl.xDeb.eMode == sWindowing) ||  (pxFee->xControl.xDeb.eMode == sWinPattern) ) {
					for (ucIL = 0; ucIL < N_OF_CCD; ucIL++ ){
						bDpktGetTransmissionErrInj(&pxFee->xChannel[ucIL].xDataPacket);
						pxFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bMissingDataEn = pxFee->xErrorInjControl[ucIL].xErrorSWCtrlWin.bMissingData;
						pxFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bMissingPktsEn = pxFee->xErrorInjControl[ucIL].xErrorSWCtrlWin.bMissingPkts;
						pxFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bTxDisabledEn  = pxFee->xErrorInjControl[ucIL].xErrorSWCtrlWin.bTxDisabled;
						pxFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.ucFrameNum     = pxFee->xErrorInjControl[ucIL].xErrorSWCtrlWin.ucFrameNum;
						pxFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiDataCnt     = pxFee->xErrorInjControl[ucIL].xErrorSWCtrlWin.usiDataCnt;
						pxFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiNRepeat     = pxFee->xErrorInjControl[ucIL].xErrorSWCtrlWin.usiNRepeat;
						pxFee->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiSequenceCnt = pxFee->xErrorInjControl[ucIL].xErrorSWCtrlWin.usiSequenceCnt;
						bDpktSetTransmissionErrInj(&pxFee->xChannel[ucIL].xDataPacket);
					}
				}

				/* Reset the memory control variables thats is used in the transmission*/
				vResetMemCCDFEE( pxFee );

				pxFee->xControl.bUsingDMA = TRUE;


				for (ucIL = 0; ucIL < N_OF_CCD; ucIL++ ){
					xTrans[ucIL].xCcdMapLocal[eCcdSideELeft] = &pxFee->xMemMap.xAebMemCcd[ucIL].xSide[eCcdSideELeft];
					xTrans[ucIL].xCcdMapLocal[eCcdSideFRight] = &pxFee->xMemMap.xAebMemCcd[ucIL].xSide[eCcdSideFRight];

					xTrans[ucIL].xCcdMapLocal[eCcdSideELeft]->ulAddrI = xTrans[ucIL].xCcdMapLocal[eCcdSideELeft]->ulOffsetAddr + COMM_WINDOING_PARAMETERS_OFST;
					xTrans[ucIL].xCcdMapLocal[eCcdSideFRight]->ulAddrI = xTrans[ucIL].xCcdMapLocal[eCcdSideFRight]->ulOffsetAddr + COMM_WINDOING_PARAMETERS_OFST;

					/* Tells to HW where is the packet oder list (before the image)*/
					bWindCopyMebWindowingParam(xTrans[ucIL].xCcdMapLocal[eCcdSideELeft]->ulOffsetAddr, xTrans[ucIL].ucMemory, pxFee->ucId, ucIL);

					xTrans[ucIL].ulAddrIni = 0; /*This will be the offset*/
					xTrans[ucIL].ulAddrFinal = pxFee->xCommon.usiTotalBytes;
					xTrans[ucIL].ulTotalBlocks = pxFee->xCommon.usiNTotalBlocks;

					/* Check if need to change the memory */
					xTrans[ucIL].ucMemory = (unsigned char) (( *pxFee->xControl.pActualMem + 1 ) % 2) ; /* Select the other memory*/

					/* Enable IRQ and clear the Double Buffer */
					bEnableDbBuffer(pxFee, &pxFee->xChannel[ucIL].xFeeBuffer);
				}

//				/* FGS */
//				bFtdiSwapImagettesMem( xTrans[ucIL].ucMemory );

				/*Configure the 8 sides of buffer to transmission - T_IN_MOD*/
				for (ucChan=0; ucChan < 8; ucChan++) {
					vConfigTinMode( pxFee , &xTinMode[ucChan], ucChan);
				}

				/* Keep counting how many buffers where transmitted, always need count to 8 (8 buffers)*/
				pxFee->xControl.xDeb.ucTransmited = 0;

				/* Update DataPacket with the information of actual readout information*/
				/* Configuration of Spw Channel 0 */
				/* T0_IN_MOD Select data source for left Fifo of SpW n1:*/
				/* T1_IN_MOD Select data source for right Fifo of SpW n1:*/
				for (ucChan=0; ucChan < N_OF_CCD; ucChan++){
					xTrans[ucChan].bDmaReturn[eCcdSideELeft] = FALSE;
					xTrans[ucChan].bDmaReturn[eCcdSideFRight] = FALSE;
					bDpktGetPacketConfig(&pxFee->xChannel[ucChan].xDataPacket);
					bFeebGetMachineControl(&pxFee->xChannel[ucChan].xFeeBuffer);
					pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucCcdNumberLeftBuffer = xTinMode[ucChan*2].ucAebNumber;
					pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucCcdNumberRightBuffer = xTinMode[ucChan*2+1].ucAebNumber;
					pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucCcdSideLeftBuffer = xTinMode[ucChan*2].ucSideCcd;
					pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucCcdSideRightBuffer = xTinMode[ucChan*2+1].ucSideCcd;
					switch (pxFee->xControl.xDeb.eMode) {
						case sFullPattern:
							usiSpwPLengthL = xConfSpw[pxFee->ucId].usiFullSpwPLength;

							if ( xTinMode[ucChan*2].bDataOn == TRUE ){
								pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImagePatternDeb;
								/* Update DEB Data Packet with Pattern Configs - [rfranca] */
								bDpktUpdateDpktDebCfg(&pxFee->xChannel[ucChan].xDataPacket);
							} else {
								pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
								xTinMode[ucChan*2].bSent = TRUE;
								pxFee->xControl.xDeb.ucTransmited++;
							}
							if ( xTinMode[ucChan*2+1].bDataOn == TRUE ){
								pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktFullImagePatternDeb;
								/* Update DEB Data Packet with Pattern Configs - [rfranca] */
								bDpktUpdateDpktDebCfg(&pxFee->xChannel[ucChan].xDataPacket);
							} else {
								pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
								xTinMode[ucChan*2+1].bSent = TRUE;
								pxFee->xControl.xDeb.ucTransmited++;
							}
							break;
						case sWinPattern:
							usiSpwPLengthL = xConfSpw[pxFee->ucId].usiWinSpwPLength;

							if ( xTinMode[ucChan*2].bDataOn == TRUE ){
								pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowingPatternDeb;
								/* Update DEB Data Packet with Pattern Configs - [rfranca] */
								bDpktUpdateDpktDebCfg(&pxFee->xChannel[ucChan].xDataPacket);
							} else {
								pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
								xTinMode[ucChan*2].bSent = TRUE;
								pxFee->xControl.xDeb.ucTransmited++;
							}
							if ( xTinMode[ucChan*2+1].bDataOn == TRUE ){
								pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktWindowingPatternDeb;
								/* Update DEB Data Packet with Pattern Configs - [rfranca] */
								bDpktUpdateDpktDebCfg(&pxFee->xChannel[ucChan].xDataPacket);
							} else {
								pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
								xTinMode[ucChan*2 + 1].bSent = TRUE;
								pxFee->xControl.xDeb.ucTransmited++;
							}
							break;
						case sFullImage:
							usiSpwPLengthL = xConfSpw[pxFee->ucId].usiFullSpwPLength;

							/*Need to configure both sides of buffer*/
							if ( xTinMode[ucChan*2].bDataOn == TRUE ){
								if ( xTinMode[ucChan*2].bPattern == TRUE ) {
									pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImagePatternAeb;
									/* Update AEB Data Packet with Pattern Configs - [rfranca] */
									bDpktUpdateDpktAebCfg(&pxFee->xChannel[ucChan].xDataPacket, xTinMode[ucChan*2].ucAebNumber, xTinMode[ucChan*2].ucSideSpw);
								} else {
									if (pxFee->xControl.xAeb[ucChan].bSwitchedOn == TRUE) {

										switch (pxFee->xControl.xAeb[ucChan].eState) {
											case sAebPattern:
												pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImagePatternAeb;
												/* Update AEB Data Packet with Pattern Configs - [rfranca] */
												bDpktUpdateDpktAebCfg(&pxFee->xChannel[ucChan].xDataPacket, xTinMode[ucChan*2].ucAebNumber, xTinMode[ucChan*2].ucSideSpw);
												break;
											case sAebImage:
												pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImage;
												break;
											default:
												pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
												xTinMode[ucChan*2].bSent = TRUE;
												pxFee->xControl.xDeb.ucTransmited++;
												break;
										}

									} else {
										pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
										xTinMode[ucChan*2].bSent = TRUE;
										pxFee->xControl.xDeb.ucTransmited++;
									}

								}
							} else {
								pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
								xTinMode[ucChan*2].bSent = TRUE;
								pxFee->xControl.xDeb.ucTransmited++;
							}

							if ( xTinMode[ucChan*2+1].bDataOn == TRUE ){
								if ( xTinMode[ucChan*2+1].bPattern == TRUE ) {
									pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktFullImagePatternAeb;
									/* Update AEB Data Packet with Pattern Configs - [rfranca] */
									bDpktUpdateDpktAebCfg(&pxFee->xChannel[ucChan].xDataPacket, xTinMode[ucChan*2+1].ucAebNumber, xTinMode[ucChan*2+1].ucSideSpw);
								} else {

									if (pxFee->xControl.xAeb[ucChan].bSwitchedOn == TRUE) {

										switch (pxFee->xControl.xAeb[ucChan].eState) {
											case sAebPattern:
												pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImagePatternAeb;
												/* Update AEB Data Packet with Pattern Configs - [rfranca] */
												bDpktUpdateDpktAebCfg(&pxFee->xChannel[ucChan].xDataPacket, xTinMode[ucChan*2 + 1].ucAebNumber, xTinMode[ucChan*2+1].ucSideSpw);
												break;
											case sAebImage:
												pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImage;
												break;
											default:
												pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
												xTinMode[ucChan*2+1].bSent = TRUE;
												pxFee->xControl.xDeb.ucTransmited++;
												break;
										}

									} else {
										pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
										xTinMode[ucChan*2+1].bSent = TRUE;
										pxFee->xControl.xDeb.ucTransmited++;
									}
								}
							} else {
								pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
								xTinMode[ucChan*2 + 1].bSent = TRUE;
								pxFee->xControl.xDeb.ucTransmited++;
							}
							break;
						case sWindowing:
							usiSpwPLengthL = xConfSpw[pxFee->ucId].usiWinSpwPLength;

							/*Need to configure both sides of buffer*/
							if ( xTinMode[ucChan*2].bDataOn == TRUE ){
								if ( xTinMode[ucChan*2].bPattern == TRUE )
									pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowingPatternAeb;
								else {
									if (pxFee->xControl.xAeb[ucChan].bSwitchedOn == TRUE) {

										switch (pxFee->xControl.xAeb[ucChan].eState) {
											case sAebPattern:
												pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowingPatternAeb;
												break;
											case sAebImage:
												pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowing;
												break;
											default:
												pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
												xTinMode[ucChan*2].bSent = TRUE;
												pxFee->xControl.xDeb.ucTransmited++;
												break;
										}

									} else {
										pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
										xTinMode[ucChan*2].bSent = TRUE;
										pxFee->xControl.xDeb.ucTransmited++;
									}
								}
							} else {
								pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
								xTinMode[ucChan*2].bSent = TRUE;
								pxFee->xControl.xDeb.ucTransmited++;
							}

							if ( xTinMode[ucChan*2+1].bDataOn == TRUE ){
								if ( xTinMode[ucChan*2+1].bPattern == TRUE )
									pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktWindowingPatternAeb;
								else {
									if (pxFee->xControl.xAeb[ucChan].bSwitchedOn == TRUE) {

										switch (pxFee->xControl.xAeb[ucChan].eState) {
											case sAebPattern:
												pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowingPatternAeb;
												break;
											case sAebImage:
												pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowing;
												break;
											default:
												pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
												xTinMode[ucChan*2+1].bSent = TRUE;
												pxFee->xControl.xDeb.ucTransmited++;
												break;
										}

									} else {
										pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
										xTinMode[ucChan*2+1].bSent = TRUE;
										pxFee->xControl.xDeb.ucTransmited++;
									}
								}
							} else {
								pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
								xTinMode[ucChan*2 + 1].bSent = TRUE;
								pxFee->xControl.xDeb.ucTransmited++;
							}

							break;
						default:
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlMajorMessage )
								fprintf(fp,"\nFFEE-%hu Task: Mode not recognized: xDpktDataPacketConfig (Data Packet). Configuring On Mode.\n", pxFee->ucId);
							#endif
							pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
							pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
							break;
					}
					pxFee->xChannel[ucChan].xDataPacket.xDpktDataPacketConfig.usiPacketLength = usiSpwPLengthL;

					bFeebSetMachineControl(&pxFee->xChannel[ucChan].xFeeBuffer);
					bDpktSetPacketConfig(&pxFee->xChannel[ucChan].xDataPacket);
				}

				ucRetries = 0;
				pxFee->xControl.xDeb.ucRealySent = 0;
				pxFee->xControl.xDeb.eState = redoutPreLoadBuffer;
				break;

			case redoutPreLoadBuffer:

				if ( ucRetries < 9 ) {
					if ( pxFee->xControl.xDeb.ucTransmited < 8) {

						for (ucIL = 0; ucIL < 8; ucIL++){

							ucSwpIdL = xTinMode[ucIL].ucSpWChannel;
							ucSwpSideL = xTinMode[ucIL].ucSideSpw;
							ucAebIdL = xTinMode[ucIL].ucAebNumber;
							ucCcdSideL = (unsigned char)xTinMode[ucIL].ucSideCcd;

//							/* FGS */
//							usiH = pxFFee->xCcdInfo.usiHeight + pxFFee->xCcdInfo.usiOLN;
//							usiW = pxFFee->xCcdInfo.usiHalfWidth + pxFFee->xCcdInfo.usiSPrescanN + pxFFee->xCcdInfo.usiSOverscanN;
//							bFtdiSetImagettesParams(0, ucAebIdL, ucCcdSideL, usiW, usiH ,(alt_u32 *)xTrans[ucAebIdL].xCcdMapLocal[ucCcdSideL]->ulAddrI);

							if ( xTinMode[ucIL].bSent == FALSE ) {
								if ( xTinMode[ucIL].bDataOn == TRUE ) {
									if (  xTrans[ucAebIdL].ucMemory == 0  )
										xTinMode[ucIL].bSent = bSdmaCommDmaTransfer(eDdr2Memory1, (alt_u32 *)xTrans[ucAebIdL].xCcdMapLocal[ucCcdSideL]->ulAddrI, (alt_u32)xTrans[ucAebIdL].ulTotalBlocks, ucSwpSideL, pxFee->ucSPWId[ucSwpIdL]);
									else
										xTinMode[ucIL].bSent = bSdmaCommDmaTransfer(eDdr2Memory2, (alt_u32 *)xTrans[ucAebIdL].xCcdMapLocal[ucCcdSideL]->ulAddrI, (alt_u32)xTrans[ucAebIdL].ulTotalBlocks, ucSwpSideL, pxFee->ucSPWId[ucSwpIdL]);

									if ( xTinMode[ucIL].bSent == FALSE ) {
										#if DEBUG_ON
										if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
											fprintf(fp,"\nFFEE-%hu Task: DMA Schedule fail, xTinMode %u\n", pxFee->ucId, ucIL);
										}
										#endif

										/* Stop the module Double Buffer */
										bFeebStopCh(&pxFee->xChannel[ucSwpIdL].xFeeBuffer);
										/* Clear all buffer form the Double Buffer */
										bFeebClrCh(&pxFee->xChannel[ucSwpIdL].xFeeBuffer);
										/* Start the module Double Buffer */
										bFeebStartCh(&pxFee->xChannel[ucSwpIdL].xFeeBuffer);

									} else {
										pxFee->xControl.xDeb.ucTransmited++;
										pxFee->xControl.xDeb.ucRealySent++;
									}
								}
							}
						}
						ucRetries++;
					} else {
						/*Success*/
						pxFee->xControl.xDeb.eState = redoutWaitSync;
						pxFee->xControl.xDeb.ucFinished = 0;

						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
							fprintf(fp,"FFEE-%hu Task: DMAs Scheduled\n", pxFee->ucId);
						}
						#endif
					}
				} else {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: CRITICAL! D. B. Requested more than 9 times.\n", pxFee->ucId);
						fprintf(fp,"FFEE %hhu Task: Ending the simulation.\n", pxFee->ucId);
					}
					#endif

					/*Back to Config*/
					pxFee->xControl.bWatingSync = FALSE;
					pxFee->xControl.xDeb.eLastMode = sInit;
					pxFee->xControl.xDeb.eMode = sOFF;
					pxFee->xControl.xDeb.eState = sOFF_Enter;

					ucRetries = 0;

				}

				break;


			case redoutTransmission:
				/*Will wait for the Before sync signal, probably in this state it will need to treat many RMAP commands*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code == OS_ERR_NONE ) {
					vQCmdWaitFinishingTransmission( pxFee, uiCmdFEE.ulWord );
				} else {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ\n", pxFee->ucId);
					}
					#endif
				}

				break;

			case redoutEndSch:
				/* Debug purposes only*/
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: End of trans\n", pxFee->ucId);
				}
				#endif

				vResetMemCCDFEE(pxFee);


				if ((xGlobal.bJustBeforSync == TRUE)) {
					pxFee->xControl.xDeb.eState = redoutCheckRestr;
				} else {
					pxFee->xControl.xDeb.eState = redoutWaitBeforeSyncSignal;
				}
				break;

			case redoutCycle_Out:
				pxFee->xControl.bUsingDMA = FALSE;

				if ( pxFee->xControl.xDeb.eNextMode == sOn_Enter ) {

					for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
						bDpktGetPacketConfig(&pxFee->xChannel[ucIL].xDataPacket);
						pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
						pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
						bDpktSetPacketConfig(&pxFee->xChannel[ucIL].xDataPacket);
					}
				} else if ( pxFee->xControl.xDeb.eNextMode == sStandBy_Enter ) {
					for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
						bDpktGetPacketConfig(&pxFee->xChannel[ucIL].xDataPacket);
						pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktStandby;
						pxFee->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktStandby;
						bDpktSetPacketConfig(&pxFee->xChannel[ucIL].xDataPacket);
					}
				}

				/* Real State */
				pxFee->xControl.xDeb.eState = pxFee->xControl.xDeb.eNextMode;

				break;


			case redoutWaitSync:

				/* Debug only*/
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"FFEE-%hu Task: (redoutWaitSync)\n", pxFee->ucId);
				}
				#endif

				/* Wait for sync, or any other command*/
				uiCmdFEE.ulWord = (unsigned int)OSQPend(xFeeQ[ pxFee->ucId ] , 0, &error_code); /* Blocking operation */
				if ( error_code != OS_ERR_NONE ) {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"FFEE-%hu Task: Can't get cmd from Queue xFeeQ (redoutWaitSync)\n", pxFee->ucId);
					}
					#endif
				} else {
					vQCmdFEEinReadoutSync( pxFee, uiCmdFEE.ulWord  );
				}

				/* Write in the RMAP */
				if (xTrans[0].bFirstT == TRUE) {
					xTrans[0].bFirstT = FALSE;
					for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
						bRmapGetRmapMemCfgArea(&pxFee->xChannel[ucIL].xRmap);
					}
					switch ( pxFee->xControl.xDeb.eMode ) {

						case sOn: /*7u*/
							/* DEB Operational Mode 7 : DEB On Mode */
							if (pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != eRmapDebOpModeOn) {
								pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeOn;
								for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
									bRmapGetRmapMemCfgArea(&pxFee->xChannel[ucIL].xRmap);
								}
							}
							break;
						case sFullPattern: /*1u*/
							/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
							if (pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != eRmapDebOpModeFullImgPatt) {
								pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeFullImgPatt;
								for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
									bRmapGetRmapMemCfgArea(&pxFee->xChannel[ucIL].xRmap);
								}
							}
							break;
						case sWinPattern:/*3u*/
							/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
							if (pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != eRmapDebOpModeWinPatt) {
								pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeWinPatt;
								for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
									bRmapGetRmapMemCfgArea(&pxFee->xChannel[ucIL].xRmap);
								}
							}
							break;
						case sStandBy: /*4u*/
							/* DEB Operational Mode 6 : DEB Standby Mode */
							if (pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != eRmapDebOpModeStandby) {
								pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeStandby;
								for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
									bRmapGetRmapMemCfgArea(&pxFee->xChannel[ucIL].xRmap);
								}
							}
							break;
						case sFullImage: /*0u*/
							/* DEB Operational Mode 0 : DEB Full-Image Mode */
							if (pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != eRmapDebOpModeFullImg) {
								pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeFullImg;
								for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
									bRmapGetRmapMemCfgArea(&pxFee->xChannel[ucIL].xRmap);
								}
							}
							break;
						case sWindowing:/*2u*/
							/* DEB Operational Mode 2 : DEB Windowing Mode */
							if (pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod != eRmapDebOpModeWin) {
								pxFee->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod = eRmapDebOpModeWin;
								for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
									bRmapGetRmapMemCfgArea(&pxFee->xChannel[ucIL].xRmap);
								}
							}
							break;
						default:
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"FFEE-%hu Task: Unexpected eMode (redoutWaitSync)\n", pxFee->ucId);
							}
							#endif
							break;
					}
				}
				break;

			default:
				pxFee->xControl.xDeb.eState = sOFF_Enter;
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp,"\nFFEE %hhu Task: Unexpected mode (default)\n", pxFee->ucId);
				#endif
				break;
		}
	}
}

/* Threat income command while the Fee is in Config. mode*/
void vQCmdFEEinConfig( TFFee *pxFFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	unsigned char ucIL;

	uiCmdFEEL.ulWord = cmd;

	switch (uiCmdFEEL.ucByte[2]) {
		case M_FEE_DT_SOURCE:
			if ( uiCmdFEEL.ucByte[0] == 0 )
				pxFFeeP->xControl.xDeb.eDataSource = dsPattern;
			else if ( uiCmdFEEL.ucByte[0] == 1 )
				pxFFeeP->xControl.xDeb.eDataSource = dsSSD;
			else
				pxFFeeP->xControl.xDeb.eDataSource = dsWindowStack;
			break;

		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: Already in OFF Mode (OFF)\n", pxFFeeP->ucId);
			}
			#endif
			break;
		case M_FEE_ON_FORCED:
		case M_FEE_ON:
			pxFFeeP->xControl.bWatingSync = FALSE;

			/* Real Fee State (graph) */
			pxFFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
			pxFFeeP->xControl.xDeb.eMode = sOn;
			pxFFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			/* Real State - keep in the same state until master sync - wait for master sync to change*/
			pxFFeeP->xControl.xDeb.eState = sOn_Enter;
			break;

		case M_FEE_RUN:
		case M_FEE_RUN_FORCED:
			break;

		case M_FEE_RMAP:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: Can't threat RMAP Messages in this mode (Config)\n", pxFFeeP->ucId);
			}
			#endif
			break;
		case M_MASTER_SYNC:
			/* Increment AEBs Timestamps - [rfranca] */
			bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxFFeeP->xControl.xAeb[0].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxFFeeP->xControl.xAeb[1].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxFFeeP->xControl.xAeb[2].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxFFeeP->xControl.xAeb[3].bSwitchedOn);
			/*Do nothing for now*/
			break;

		case M_BEFORE_MASTER:
			vActivateContentErrInj(pxFFeeP);
			vActivateDataPacketErrInj(pxFFeeP);
			/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
			for ( ucIL = (pxFFeeP->ucId * 4) ; ucIL < (pxFFeeP->ucId * 4 + 4); ucIL++ ){
				/* Stop the Comm Channels */
				bFeebStopCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffers from the Comm Channels */
				bFeebClrCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the Comm Channels */
				bFeebStartCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
			}
			/*Do nothing for now*/
			break;

		case M_FEE_FULL:
		case M_FEE_FULL_PATTERN:
		case M_FEE_WIN:
		case M_FEE_WIN_PATTERN:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Transition not allowed from OFF mode (OFF)\n", pxFFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Unexpected command for this mode (OFF, cmd=%hhu )\n", pxFFeeP->ucId, uiCmdFEEL.ucByte[2]);
			}
			#endif
			break;
	}
}

/* Threat income command while the Fee is in On mode*/
void vQCmdFEEinOn( TFFee *pxFFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	unsigned char ucIL;

	uiCmdFEEL.ulWord = cmd;

	switch (uiCmdFEEL.ucByte[2]) {
		case M_FEE_DT_SOURCE:

			if ( uiCmdFEEL.ucByte[0] == 0 )
				pxFFeeP->xControl.xDeb.eDataSource = dsPattern;
			else if ( uiCmdFEEL.ucByte[0] == 1 )
				pxFFeeP->xControl.xDeb.eDataSource = dsSSD;
			else
				pxFFeeP->xControl.xDeb.eDataSource = dsWindowStack;
			break;

		case M_NFC_CONFIG_RESET:
			/*Do nothing*/
			break;
		case M_FEE_CAN_ACCESS_NEXT_MEM:
			/*Do nothing*/
			break;
		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
			pxFFeeP->xControl.bWatingSync = FALSE;

			/* Real Fee State (graph) */
			pxFFeeP->xControl.xDeb.eLastMode = sOn_Enter;
			pxFFeeP->xControl.xDeb.eMode = sOFF;
			pxFFeeP->xControl.xDeb.eNextMode = sOFF;
			/* Real State */
			pxFFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
				bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
			}

			break;
		case M_FEE_ON:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Already in On mode (On)\n", pxFFeeP->ucId);
			}
			#endif
			break;

		case M_FEE_STANDBY:
			pxFFeeP->xControl.bWatingSync = FALSE;

			/* Real Fee State (graph) */
			pxFFeeP->xControl.xDeb.eLastMode = sOn_Enter;
			pxFFeeP->xControl.xDeb.eMode = sStandBy;
			pxFFeeP->xControl.xDeb.eNextMode = sStandBy_Enter;
			/* Real State - asynchronous */
			pxFFeeP->xControl.xDeb.eState = sStandBy_Enter;
			break;


		case M_FEE_FULL_PATTERN:
		case M_FEE_FULL_PATTERN_FORCED: /* There are no forced mode to go to the Pattern Mode */

			pxFFeeP->xControl.bWatingSync = TRUE;

			/* Real Fee State (graph) */
			pxFFeeP->xControl.xDeb.eLastMode = sOn_Enter;
			pxFFeeP->xControl.xDeb.eMode = sOn;
			pxFFeeP->xControl.xDeb.eNextMode = sFullPattern_Enter;
			/* Real State - only change on master*/
			pxFFeeP->xControl.xDeb.eState = sOn;

			break;
		case M_FEE_WIN_PATTERN:
		case M_FEE_WIN_PATTERN_FORCED: /* There are no forced mode to go to the Pattern Mode */
			pxFFeeP->xControl.bWatingSync = TRUE;

			/* Real Fee State (graph) */
			pxFFeeP->xControl.xDeb.eLastMode = sOn_Enter;
			pxFFeeP->xControl.xDeb.eMode = sOn;
			pxFFeeP->xControl.xDeb.eNextMode = sWinPattern_Enter;
			/* Real State - only change on master*/
			pxFFeeP->xControl.xDeb.eState = sOn;
			break;
		case M_FEE_RMAP:

			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: RMAP Message\n", pxFFeeP->ucId);
			}
			#endif
			/* Perform some actions, check if is a valid command for this mode of operation  */
			vQCmdFeeRMAPinModeOn( pxFFeeP, cmd );

			break;
		case M_BEFORE_MASTER:
			vActivateContentErrInj(pxFFeeP);
			vActivateDataPacketErrInj(pxFFeeP);
			/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
			for ( ucIL = (pxFFeeP->ucId * 4) ; ucIL < (pxFFeeP->ucId * 4 + 4); ucIL++ ){
				/* Stop the Comm Channels */
				bFeebStopCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffers from the Comm Channels */
				bFeebClrCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the Comm Channels */
				bFeebStartCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
			}
			/*All transiction should be performed during the Pre-Sync of the Master, in order to data packet receive the right configuration during sync*/

			if ( pxFFeeP->xControl.xDeb.eNextMode != pxFFeeP->xControl.xDeb.eMode ) {
				pxFFeeP->xControl.xDeb.eState =  pxFFeeP->xControl.xDeb.eNextMode;

				if ( pxFFeeP->xControl.xDeb.eNextMode == sStandBy_Enter ) {

					for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
						pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktStandby;
						pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktStandby;
						bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
					}

				} else if ( pxFFeeP->xControl.xDeb.eNextMode == sFullPattern_Enter ) {

					for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
						pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImagePatternDeb;
						pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktFullImagePatternDeb;
						bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
						/* Update DEB Data Packet with Pattern Configs - [rfranca] */
						bDpktUpdateDpktDebCfg(&pxFFeeP->xChannel[ucIL].xDataPacket);
					}

				} else if ( pxFFeeP->xControl.xDeb.eNextMode == sWinPattern_Enter ) {

					for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
						pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowingPatternDeb;
						pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktWindowingPatternDeb;
						bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
						/* Update DEB Data Packet with Pattern Configs - [rfranca] */
						bDpktUpdateDpktDebCfg(&pxFFeeP->xChannel[ucIL].xDataPacket);
					}
				}
			}
			break;

		case M_MASTER_SYNC:
			/* Increment AEBs Timestamps - [rfranca] */
			bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxFFeeP->xControl.xAeb[0].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxFFeeP->xControl.xAeb[1].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxFFeeP->xControl.xAeb[2].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxFFeeP->xControl.xAeb[3].bSwitchedOn);
			/*DO nothing for now*/
			break;
		case M_FEE_DMA_ACCESS:

			break;
		case M_FEE_FULL:
		case M_FEE_WIN:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Transition not allowed from On mode (On)\n", pxFFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Unexpected command for this mode (On, cmd=%hhu)\n", pxFFeeP->ucId, uiCmdFEEL.ucByte[2]);
			}
			#endif
			break;

	}
}


/* Threat income command while the Fee is on Readout Mode mode*/
void vQCmdWaitFinishingTransmission( TFFee *pxFFeeP, unsigned int cmd ){
	tQMask uiCmdFEEL;
	unsigned char error_code, ucIL;

	uiCmdFEEL.ulWord = cmd;

	switch (uiCmdFEEL.ucByte[2]) {
		case M_FEE_DT_SOURCE:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode \n", pxFFeeP->ucId);
			}
			#endif
			break;
		case M_FEE_CAN_ACCESS_NEXT_MEM:
			/*Do nothing*/
			break;

		case M_FEE_TRANS_FINISHED_L:
		case M_FEE_TRANS_FINISHED_D:

			pxFFeeP->xControl.xDeb.ucFinished++;

			if ( pxFFeeP->xControl.xDeb.ucFinished >= pxFFeeP->xControl.xDeb.ucRealySent ) {
				pxFFeeP->xControl.xDeb.eState = redoutEndSch;
			}

			break;

		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED:
			pxFFeeP->xControl.bWatingSync = FALSE;
			pxFFeeP->xControl.xDeb.eLastMode = sInit;
			pxFFeeP->xControl.xDeb.eMode = sOFF;
			pxFFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
				bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
			}

			break;
		case M_FEE_ON_FORCED:
			pxFFeeP->xControl.bWatingSync = FALSE;
			pxFFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
			pxFFeeP->xControl.xDeb.eMode = sOn;
			pxFFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			pxFFeeP->xControl.xDeb.eState = sOn_Enter;

			for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
				bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
			}

			break;
		case M_FEE_ON:
			if (( pxFFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxFFeeP->xControl.xDeb.eMode == sWinPattern)) {

				pxFFeeP->xControl.bWatingSync = TRUE;
				pxFFeeP->xControl.xDeb.eState = redoutTransmission; /*Will stay until master sync*/
				pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;

			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxFFeeP->ucId);
				}
				#endif
			}

			break;
		case M_FEE_STANDBY:
			if (( pxFFeeP->xControl.xDeb.eMode == sFullImage ) || (pxFFeeP->xControl.xDeb.eMode == sWindowing)){
				pxFFeeP->xControl.bWatingSync = TRUE;
				pxFFeeP->xControl.xDeb.eState = redoutTransmission; /*Will stay until master sync*/
				pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;
			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxFFeeP->ucId);
				#endif
			}
			break;

		case M_FEE_RMAP:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: RMAP Message\n", pxFFeeP->ucId);
			}
			#endif

			/* Perform some actions, check if is a valid command for this mode of operation  */
			vQCmdFeeRMAPinReadoutTrans( pxFFeeP, cmd );//todo: dizem que nao vao enviar comando durante a transmissao, ignorar?

			break;

		case M_BEFORE_MASTER:
			vActivateContentErrInj(pxFFeeP);
			vActivateDataPacketErrInj(pxFFeeP);
			/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
			for ( ucIL = (pxFFeeP->ucId * 4) ; ucIL < (pxFFeeP->ucId * 4 + 4); ucIL++ ){
				/* Stop the Comm Channels */
				bFeebStopCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffers from the Comm Channels */
				bFeebClrCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the Comm Channels */
				bFeebStartCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
			}
			/*The Meb My have sent a message to inform the finish of the update of the image*/
			error_code = OSQFlush( xFeeQ[ pxFFeeP->ucId ] );
			if ( error_code != OS_NO_ERR ) {
				vFailFlushFEEQueue();
			}

			if ( pxFFeeP->xControl.xDeb.eNextMode == pxFFeeP->xControl.xDeb.eLastMode )
				pxFFeeP->xControl.xDeb.eState = redoutCycle_Out;
			else
				pxFFeeP->xControl.xDeb.eState = redoutConfigureTrans;

			break;

		case M_MASTER_SYNC:
			/* Increment AEBs Timestamps - [rfranca] */
			bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxFFeeP->xControl.xAeb[0].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxFFeeP->xControl.xAeb[1].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxFFeeP->xControl.xAeb[2].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxFFeeP->xControl.xAeb[3].bSwitchedOn);

			break;
		case M_FEE_FULL:
		case M_FEE_FULL_PATTERN:
		case M_FEE_WIN:
		case M_FEE_WIN_PATTERN:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxFFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task:  Unexpected command for this mode (in redoutTransmission)\n", pxFFeeP->ucId);
			}
			#endif
			break;
	}
}

/* Threat income command while the Fee is waiting for sync*/
void vQCmdFEEinReadoutSync( TFFee *pxFFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	unsigned char ucIL;

	/* Get command word*/
	uiCmdFEEL.ulWord = cmd;

	if ( (uiCmdFEEL.ucByte[3] == ( M_FEE_BASE_ADDR + pxFFeeP->ucId)) ) {

		switch (uiCmdFEEL.ucByte[2]) {
			case M_FEE_DT_SOURCE:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode \n", pxFFeeP->ucId);
				}
				#endif
				break;
			case M_FEE_CAN_ACCESS_NEXT_MEM:
				/*Do nothing*/
				break;
			case M_FEE_CONFIG:
			case M_FEE_CONFIG_FORCED: /* to Config is always forced mode */
				pxFFeeP->xControl.bWatingSync = FALSE;
				pxFFeeP->xControl.xDeb.eLastMode = sInit;
				pxFFeeP->xControl.xDeb.eMode = sOFF;
				pxFFeeP->xControl.xDeb.eState = sOFF_Enter;

				for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
					/* [rfranca] */
					bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
					pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
					pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
					bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				}



				break;
			case M_FEE_ON:
				if (( pxFFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxFFeeP->xControl.xDeb.eMode == sWinPattern)) {
					pxFFeeP->xControl.bWatingSync = TRUE;
					pxFFeeP->xControl.xDeb.eState = redoutWaitSync; /*Will stay until master sync*/
					pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;

				} else {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
						fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode \n", pxFFeeP->ucId);
					#endif
				}
				break;
			case M_FEE_ON_FORCED:
				pxFFeeP->xControl.bWatingSync = FALSE;
				pxFFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxFFeeP->xControl.xDeb.eMode = sOn;
				pxFFeeP->xControl.xDeb.eNextMode = sOn_Enter;
				pxFFeeP->xControl.xDeb.eState = sOn_Enter;

				for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
					/* [rfranca] */
					bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
					pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
					pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
					bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				}

				break;

			case M_FEE_STANDBY:
				if (( pxFFeeP->xControl.xDeb.eMode == sFullImage ) || (pxFFeeP->xControl.xDeb.eMode == sWindowing)){
					pxFFeeP->xControl.bWatingSync = TRUE;
					pxFFeeP->xControl.xDeb.eState = redoutWaitSync; /*Will stay until master sync*/
					pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;
				} else {
					#if DEBUG_ON
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
						fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxFFeeP->ucId);
					#endif
				}
				break;

			case M_FEE_RMAP:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
					fprintf(fp,"\nFFEE %hhu Task: RMAP Message\n", pxFFeeP->ucId);
				}
				#endif
				/* Perform some actions, check if is a valid command for this mode of operation  */
				vQCmdFeeRMAPReadoutSync( pxFFeeP, cmd ); // todo: Precisa criar fluxo para RMAP
				break;
			case M_BEFORE_MASTER:
				vActivateContentErrInj(pxFFeeP);
				vActivateDataPacketErrInj(pxFFeeP);
				/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
				for ( ucIL = (pxFFeeP->ucId * 4) ; ucIL < (pxFFeeP->ucId * 4 + 4); ucIL++ ){
					/* Stop the Comm Channels */
					bFeebStopCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
					/* Clear all buffers from the Comm Channels */
					bFeebClrCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
					/* Start the Comm Channels */
					bFeebStartCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				}
				/*Do nothing for now*/
				break;

			case M_MASTER_SYNC:
				/* Increment AEBs Timestamps - [rfranca] */
				bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxFFeeP->xControl.xAeb[0].bSwitchedOn);
				bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxFFeeP->xControl.xAeb[1].bSwitchedOn);
				bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxFFeeP->xControl.xAeb[2].bSwitchedOn);
				bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxFFeeP->xControl.xAeb[3].bSwitchedOn);
				/* Warning */
					pxFFeeP->xControl.xDeb.eState = redoutTransmission;
				break;

			case M_FEE_DMA_ACCESS:
				break;
			case M_FEE_FULL:
			case M_FEE_FULL_PATTERN:
			case M_FEE_WIN:
			case M_FEE_WIN_PATTERN:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"FFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxFFeeP->ucId);
				}
				#endif
				break;
			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"FFEE %hhu Task:  Unexpected command for this mode \n", pxFFeeP->ucId);
				}
				#endif
				break;
		}
	}
}

/*Not in use for now*/
/* Threat income command while the Fee is waiting for sync*/
void vQCmdFEEinWaitingSync( TFFee *pxFFeeP, unsigned int cmd ) {
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
			pxFFeeP->xControl.bWatingSync = FALSE;
			pxFFeeP->xControl.xDeb.eLastMode = sInit;
			pxFFeeP->xControl.xDeb.eMode = sOFF;
			pxFFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
				bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_ON_FORCED:
			pxFFeeP->xControl.bWatingSync = FALSE;
			pxFFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
			pxFFeeP->xControl.xDeb.eMode = sOn;
			pxFFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			pxFFeeP->xControl.xDeb.eState = sOn_Enter;

			for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
				bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_RMAP:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"\nFFEE %hhu Task: RMAP Message\n", pxFFeeP->ucId);
			}
			#endif
			/* Perform some actions, check if is a valid command for this mode of operation  */
			vQCmdFeeRMAPWaitingSync( pxFFeeP, cmd );
			break;
		case M_BEFORE_MASTER:
			vActivateContentErrInj(pxFFeeP);
			vActivateDataPacketErrInj(pxFFeeP);
			/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
			for ( ucIL = (pxFFeeP->ucId * 4) ; ucIL < (pxFFeeP->ucId * 4 + 4); ucIL++ ){
				/* Stop the Comm Channels */
				bFeebStopCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffers from the Comm Channels */
				bFeebClrCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the Comm Channels */
				bFeebStartCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
			}
			break;

		case M_MASTER_SYNC:
			/* Increment AEBs Timestamps - [rfranca] */
			bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxFFeeP->xControl.xAeb[0].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxFFeeP->xControl.xAeb[1].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxFFeeP->xControl.xAeb[2].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxFFeeP->xControl.xAeb[3].bSwitchedOn);
			/*This block of code is used only for the On-Standby transitions, that will be done only in the master sync*/
			/* Warning */
				pxFFeeP->xControl.bWatingSync = TRUE;
				/* Real State */
				pxFFeeP->xControl.xDeb.eState = pxFFeeP->xControl.xDeb.eNextMode;
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
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Command not allowed, already processing a changing action (in redoutPreparingDB)\n", pxFFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task:  Unexpected command for this mode (in Config mode)\n", pxFFeeP->ucId);
			}
			#endif
			break;
	}
}


/* Threat income command while the Fee is in Standby mode*/
void vQCmdFEEinStandBy( TFFee *pxFFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	unsigned char ucIL;

	uiCmdFEEL.ulWord = cmd;

	switch (uiCmdFEEL.ucByte[2]) {
		case M_FEE_DT_SOURCE:
			if ( uiCmdFEEL.ucByte[0] == 0 )
				pxFFeeP->xControl.xDeb.eDataSource = dsPattern;
			else if ( uiCmdFEEL.ucByte[0] == 1 )
				pxFFeeP->xControl.xDeb.eDataSource = dsSSD;
			else
				pxFFeeP->xControl.xDeb.eDataSource = dsWindowStack;
			break;
		case M_FEE_CAN_ACCESS_NEXT_MEM:
			/*Do nothing*/
			break;
		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED: /* Standby to Config is always forced mode */
			pxFFeeP->xControl.bWatingSync = FALSE;

			/* Real Fee State (graph) */
			pxFFeeP->xControl.xDeb.eLastMode = sOn_Enter;
			pxFFeeP->xControl.xDeb.eMode = sOFF;
			pxFFeeP->xControl.xDeb.eNextMode = sOFF;
			/* Real State */
			pxFFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
				bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

//		case M_FEE_ON:
//			pxFFeeP->xControl.bWatingSync = TRUE;
//			pxFFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
//			pxFFeeP->xControl.xDeb.eMode = sStandBy;
//			pxFFeeP->xControl.xDeb.eNextMode = sOn_Enter;
//
//			pxFFeeP->xControl.xDeb.eState = sStandBy; /*Will stay until master sync*/
//			break;
		case M_FEE_ON:
		case M_FEE_ON_FORCED: /* Standby to On is always forced mode */
			pxFFeeP->xControl.bWatingSync = FALSE;
			pxFFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
			pxFFeeP->xControl.xDeb.eMode = sOn;
			pxFFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			/* Real State */
			pxFFeeP->xControl.xDeb.eState = sOn_Enter;

			for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
				bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_FULL:
		case M_FEE_FULL_FORCED:
			pxFFeeP->xControl.bWatingSync = TRUE;
			/* Real Fee State (graph) */
			pxFFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
			pxFFeeP->xControl.xDeb.eMode = sStandBy;
			pxFFeeP->xControl.xDeb.eNextMode = sFullImage_Enter;
			/* Real State */
			pxFFeeP->xControl.xDeb.eState = sStandBy;
			break;

		case M_FEE_WIN:
		case M_FEE_WIN_FORCED:
			pxFFeeP->xControl.bWatingSync = TRUE;
			/* Real Fee State (graph) */
			pxFFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
			pxFFeeP->xControl.xDeb.eMode = sStandBy;
			pxFFeeP->xControl.xDeb.eNextMode = sWindowing_Enter;
			/* Real State */
			pxFFeeP->xControl.xDeb.eState = sStandBy;
			break;

		case M_FEE_STANDBY:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Already in StandBy mode (StandBy)\n", pxFFeeP->ucId);
			}
			#endif
			break;

		case M_FEE_RMAP:

			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: RMAP Message\n", pxFFeeP->ucId);
			}
			#endif
			/* Perform some actions, check if is a valid command for this mode of operation  */
			vQCmdFeeRMAPinStandBy( pxFFeeP, cmd );

			break;

		case M_BEFORE_MASTER:
			vActivateContentErrInj(pxFFeeP);
			vActivateDataPacketErrInj(pxFFeeP);
			/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
			for ( ucIL = (pxFFeeP->ucId * 4) ; ucIL < (pxFFeeP->ucId * 4 + 4); ucIL++ ){
				/* Stop the Comm Channels */
				bFeebStopCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffers from the Comm Channels */
				bFeebClrCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the Comm Channels */
				bFeebStartCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
			}
			/*All transiction should be performed during the Pre-Sync of the Master, in order to data packet receive the right configuration during sync*/

			if ( pxFFeeP->xControl.xDeb.eNextMode != pxFFeeP->xControl.xDeb.eMode ) {
				pxFFeeP->xControl.xDeb.eState =  pxFFeeP->xControl.xDeb.eNextMode;

				if ( pxFFeeP->xControl.xDeb.eNextMode == sOn_Enter ) {
					for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
						pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
						pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
						bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
					}
				} else if ( pxFFeeP->xControl.xDeb.eNextMode == sFullImage_Enter ) {
					for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
						pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktFullImage;
						pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
						bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
					}
				} else if ( pxFFeeP->xControl.xDeb.eNextMode == sWindowing_Enter ) {
					for (ucIL = 0; ucIL < N_OF_CCD; ucIL++){
						/* [rfranca] */
						bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
						pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktWindowing;
						pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktWindowing;
						bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
					}
				}
			}
			break;

		case M_MASTER_SYNC:
			/* Increment AEBs Timestamps - [rfranca] */
			bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxFFeeP->xControl.xAeb[0].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxFFeeP->xControl.xAeb[1].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxFFeeP->xControl.xAeb[2].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxFFeeP->xControl.xAeb[3].bSwitchedOn);
			/*DO nothing for now*/
			break;

		case M_FEE_FULL_PATTERN:
		case M_FEE_WIN_PATTERN:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Transition not allowed from StandBy mode (StandBy)\n", pxFFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Unexpected command for this mode (StandBy, cmd=%hhu)\n", pxFFeeP->ucId, uiCmdFEEL.ucByte[2]);
			}
			#endif
			break;
	}
}



/* Threat income command while the Fee is in Config. mode*/
void vQCmdFEEinWaitingMemUpdate( TFFee *pxFFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	unsigned char ucIL;

	uiCmdFEEL.ulWord = cmd;

	switch (uiCmdFEEL.ucByte[2]) {
		case M_FEE_DT_SOURCE:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode \n", pxFFeeP->ucId);
			}
			#endif
			break;
		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED:
			pxFFeeP->xControl.bWatingSync = FALSE;
			pxFFeeP->xControl.xDeb.eLastMode = sInit;
			pxFFeeP->xControl.xDeb.eMode = sOFF;
			pxFFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL = 0; ucIL < N_OF_CCD; ucIL++) {
				/* [rfranca] */
				bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
				bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_CAN_ACCESS_NEXT_MEM:
			pxFFeeP->xControl.xDeb.eState = redoutCheckRestr;
			break;

		case M_FEE_ON_FORCED:
			pxFFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
			pxFFeeP->xControl.bWatingSync = FALSE;
			pxFFeeP->xControl.xDeb.eMode = sOn;
			pxFFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			pxFFeeP->xControl.xDeb.eState = sOn_Enter;

			/* [rfranca] */
			for (ucIL = 0; ucIL < N_OF_CCD; ucIL++) {
				bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
				bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_ON:
			/*BEfore sync, so it need to end the transmission/double buffer and wait for the sync*/
			if (( pxFFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxFFeeP->xControl.xDeb.eMode == sWinPattern)) {

				pxFFeeP->xControl.bWatingSync = TRUE;
				pxFFeeP->xControl.xDeb.eState = redoutCheckDTCUpdate; /*Will stay until master sync*/
				pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;

			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxFFeeP->ucId);
				#endif
			}
			break;

		case M_FEE_STANDBY:
			if (( pxFFeeP->xControl.xDeb.eMode == sFullImage ) || (pxFFeeP->xControl.xDeb.eMode == sWindowing)){
				pxFFeeP->xControl.bWatingSync = TRUE;
				pxFFeeP->xControl.xDeb.eState = redoutCheckDTCUpdate; /*Will stay until master sync*/
				pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;
			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxFFeeP->ucId);
				#endif
			}
			break;

		case M_FEE_RMAP:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: RMAP Message\n", pxFFeeP->ucId);
			}
			#endif

			/* Perform some actions, check if is a valid command for this mode of operation  */
			vQCmdFeeRMAPinWaitingMemUpdate( pxFFeeP, cmd );//todo: Tiago
			break;

		case M_BEFORE_MASTER:
			vActivateContentErrInj(pxFFeeP);
			vActivateDataPacketErrInj(pxFFeeP);
			/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
			for ( ucIL = (pxFFeeP->ucId * 4) ; ucIL < (pxFFeeP->ucId * 4 + 4); ucIL++ ){
				/* Stop the Comm Channels */
				bFeebStopCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffers from the Comm Channels */
				bFeebClrCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the Comm Channels */
				bFeebStartCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
			}
			break;
		case M_MASTER_SYNC:
			/* Increment AEBs Timestamps - [rfranca] */
			bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxFFeeP->xControl.xAeb[0].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxFFeeP->xControl.xAeb[1].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxFFeeP->xControl.xAeb[2].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxFFeeP->xControl.xAeb[3].bSwitchedOn);
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"FFEE %hhu Task: CRITICAL! Sync arrive and still waiting for DTC complete the memory update. (Readout Cycle)\n", pxFFeeP->ucId);
				fprintf(fp,"FFEE %hhu Task: Ending the simulation.\n", pxFFeeP->ucId);
			}
			#endif
			/*Back to Config*/
			pxFFeeP->xControl.bWatingSync = FALSE;
			pxFFeeP->xControl.xDeb.eLastMode = sInit;
			pxFFeeP->xControl.xDeb.eMode = sOFF;
			pxFFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL = 0; ucIL < N_OF_CCD; ucIL++) {
				/* [rfranca] */
				bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
				bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
			}

			break;
		case M_FEE_FULL:
		case M_FEE_FULL_PATTERN:
		case M_FEE_WIN:
		case M_FEE_WIN_PATTERN:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxFFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Unexpected command for in this mode (Readout Cycle, cmd=%hhu )\n", pxFFeeP->ucId, uiCmdFEEL.ucByte[2]);
			}
			#endif
	}
}



void vQCmdWaitBeforeSyncSignal( TFFee *pxFFeeP, unsigned int cmd ) {
	tQMask uiCmdFEEL;
	unsigned char ucIL;

	/* Get command word*/
	uiCmdFEEL.ulWord = cmd;

	switch (uiCmdFEEL.ucByte[2]) {
		case M_FEE_DT_SOURCE:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode \n", pxFFeeP->ucId);
			}
			#endif
			break;
		case M_FEE_CAN_ACCESS_NEXT_MEM:
			/*Do nothing*/
			break;
		case M_FEE_CONFIG:
		case M_FEE_CONFIG_FORCED: /* to Config is always forced mode */
			pxFFeeP->xControl.bWatingSync = FALSE;
			pxFFeeP->xControl.xDeb.eLastMode = sInit;
			pxFFeeP->xControl.xDeb.eMode = sOFF;
			pxFFeeP->xControl.xDeb.eNextMode = sOFF;
			pxFFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL = 0;ucIL < N_OF_CCD; ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
				bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_ON_FORCED:

			pxFFeeP->xControl.bWatingSync = FALSE;
			pxFFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
			pxFFeeP->xControl.xDeb.eMode = sOn;
			pxFFeeP->xControl.xDeb.eNextMode = sOn_Enter;
			pxFFeeP->xControl.xDeb.eState = sOn_Enter;

			for (ucIL = 0;ucIL < N_OF_CCD; ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOn;
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOn;
				bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_ON:
			if (( pxFFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxFFeeP->xControl.xDeb.eMode == sWinPattern)) {
				pxFFeeP->xControl.bWatingSync = TRUE;
				pxFFeeP->xControl.xDeb.eState = redoutWaitBeforeSyncSignal; /*Will stay until master sync*/
				pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;

			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode \n", pxFFeeP->ucId);
				}
				#endif
			}
			break;

		case M_FEE_STANDBY:
			if (( pxFFeeP->xControl.xDeb.eMode == sFullImage ) || (pxFFeeP->xControl.xDeb.eMode == sWindowing)){
				pxFFeeP->xControl.bWatingSync = TRUE;
				pxFFeeP->xControl.xDeb.eState = redoutWaitBeforeSyncSignal; /*Will stay until master sync*/
				pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;

			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxFFeeP->ucId);
				#endif
			}
			break;

		case M_FEE_RMAP:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
				fprintf(fp,"\nFFEE %hhu Task: RMAP Message\n", pxFFeeP->ucId);
			}
			#endif
			/* Perform some actions, check if is a valid command for this mode of operation  */
			vQCmdFeeRMAPBeforeSync( pxFFeeP, cmd ); // todo: Precisa criar fluxo para RMAP
			break;

		case M_BEFORE_MASTER:
			vActivateContentErrInj(pxFFeeP);
			vActivateDataPacketErrInj(pxFFeeP);
			/* Stop, clear and restart the Comm Channels for the next sync - [rfranca] */
			for ( ucIL = (pxFFeeP->ucId * 4) ; ucIL < (pxFFeeP->ucId * 4 + 4); ucIL++ ){
				/* Stop the Comm Channels */
				bFeebStopCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				/* Clear all buffers from the Comm Channels */
				bFeebClrCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
				/* Start the Comm Channels */
				bFeebStartCh(&pxFFeeP->xChannel[ucIL].xFeeBuffer);
			}
			if ( pxFFeeP->xControl.xDeb.eNextMode == pxFFeeP->xControl.xDeb.eLastMode )
				pxFFeeP->xControl.xDeb.eState = redoutCycle_Out; /*Is time to start the preparation of the double buffer in order to transmit data just after sync arrives*/
			else
				pxFFeeP->xControl.xDeb.eState = redoutCheckDTCUpdate; /*Received some command to change the mode, just go wait sync to change*/
			break;

		case M_MASTER_SYNC:
			/* Increment AEBs Timestamps - [rfranca] */
			bRmapIncAebTimestamp(eCommFFeeAeb1Id, pxFFeeP->xControl.xAeb[0].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb2Id, pxFFeeP->xControl.xAeb[1].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb3Id, pxFFeeP->xControl.xAeb[2].bSwitchedOn);
			bRmapIncAebTimestamp(eCommFFeeAeb4Id, pxFFeeP->xControl.xAeb[3].bSwitchedOn);
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: CRITICAL! Something went wrong, no expected sync before the 'Before Sync Signal'  \n", pxFFeeP->ucId);
				fprintf(fp,"FFEE %hhu Task: Ending the simulation.\n", pxFFeeP->ucId);
			}
			#endif
			/*Back to Config*/
			pxFFeeP->xControl.bWatingSync = FALSE;
			pxFFeeP->xControl.xDeb.eLastMode = sInit;
			pxFFeeP->xControl.xDeb.eMode = sOFF;
			pxFFeeP->xControl.xDeb.eState = sOFF_Enter;

			for (ucIL = 0;ucIL<4;ucIL++){
				/* [rfranca] */
				bDpktGetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer = eDpktOff;
				pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer = eDpktOff;
				bDpktSetPacketConfig(&pxFFeeP->xChannel[ucIL].xDataPacket);
			}

			break;

		case M_FEE_FULL:
		case M_FEE_FULL_PATTERN:
		case M_FEE_WIN:
		case M_FEE_WIN_PATTERN:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Command not allowed for this mode (in redoutPreparingDB)\n", pxFFeeP->ucId);
			}
			#endif
			break;
		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
				fprintf(fp,"FFEE %hhu Task: Unexpected command for this mode \n", pxFFeeP->ucId);
			}
			#endif
			break;
	}

}

/* Change the configuration of RMAP for a particular FEE*/
void vInitialConfig_RMAPCodecConfig( TFFee *pxFFeeP ) {

	alt_u8 ucAeb = 0;

	for (ucAeb = 0; N_OF_CCD > ucAeb; ucAeb++ ) {
		bRmapGetCodecConfig( &pxFFeeP->xChannel[ucAeb].xRmap );
		pxFFeeP->xChannel[ucAeb].xRmap.xRmapCodecConfig.ucKey = xConfSpw[pxFFeeP->ucId].ucRmapKey ;
		pxFFeeP->xChannel[ucAeb].xRmap.xRmapCodecConfig.ucLogicalAddress = xConfSpw[pxFFeeP->ucId].ucLogicalAddr;
		bRmapSetCodecConfig( &pxFFeeP->xChannel[ucAeb].xRmap );
	}

	#if DEBUG_ON
	if ( xDefaults.ucDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"FFEE %hhu Task. RMAP KEY = %hu\n", pxFFeeP->ucId, xConfSpw[pxFFeeP->ucId].ucRmapKey );
		fprintf(fp,"FFEE %hhu Task. RMAP Log. Addr. = %hu \n", pxFFeeP->ucId, xConfSpw[pxFFeeP->ucId].ucLogicalAddr );
	}
	#endif

}

/* Initializing the HW DataPacket*/
void vInitialConfig_DpktPacket( TFFee *pxFFeeP ) {

	alt_u8 ucAeb = 0;

	for (ucAeb = 0; N_OF_CCD > ucAeb; ucAeb++ ) {
		bDpktGetPacketConfig( &(pxFFeeP->xChannel[ucAeb].xDataPacket) );
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.usiCcdXSize            = pxFFeeP->xCcdInfo.usiHalfWidth + pxFFeeP->xCcdInfo.usiSPrescanN + pxFFeeP->xCcdInfo.usiSOverscanN;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.usiCcdYSize            = pxFFeeP->xCcdInfo.usiHeight + pxFFeeP->xCcdInfo.usiOLN;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.usiDataYSize           = pxFFeeP->xCcdInfo.usiHeight;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.usiOverscanYSize       = pxFFeeP->xCcdInfo.usiOLN;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.usiCcdVStart           = 0;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.usiCcdVEnd             = pxFFeeP->xCcdInfo.usiHeight + pxFFeeP->xCcdInfo.usiOLN - 1;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.usiCcdImgVEnd          = pxFFeeP->xCcdInfo.usiHeight - 1;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.usiCcdOvsVEnd          = pxFFeeP->xCcdInfo.usiOLN - 1;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.usiCcdHStart           = 0;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.usiCcdHEnd             = pxFFeeP->xCcdInfo.usiHalfWidth + pxFFeeP->xCcdInfo.usiSPrescanN + pxFFeeP->xCcdInfo.usiSOverscanN - 1;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.bCcdImgEn              = TRUE;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.bCcdOvsEn              = TRUE;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.usiPacketLength        = xConfSpw[pxFFeeP->ucId].usiFullSpwPLength;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.ucProtocolId           = xConfSpw[pxFFeeP->ucId].ucDataProtId;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.ucLogicalAddr          = xConfSpw[pxFFeeP->ucId].ucDpuLogicalAddr;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer    = eDpktOff;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer   = eDpktOff;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.ucCcdNumberLeftBuffer  = 0;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.ucCcdNumberRightBuffer = 0;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.ucCcdSideLeftBuffer    = eDpktCcdSideE;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketConfig.ucCcdSideRightBuffer   = eDpktCcdSideF;
		bDpktSetPacketConfig( &(pxFFeeP->xChannel[ucAeb].xDataPacket) );

		bDpktGetDataPacketDebCfg( &(pxFFeeP->xChannel[ucAeb].xDataPacket) );
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketDebCfg.usiDebCcdImgVEnd = pxFFeeP->xCcdInfo.usiHeight - 1;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketDebCfg.usiDebCcdOvsVEnd = pxFFeeP->xCcdInfo.usiOLN - 1;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketDebCfg.usiDebCcdHEnd    = pxFFeeP->xCcdInfo.usiHalfWidth + pxFFeeP->xCcdInfo.usiSPrescanN + pxFFeeP->xCcdInfo.usiSOverscanN - 1;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketDebCfg.bDebCcdImgEn     = TRUE;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketDebCfg.bDebCcdOvsEn     = TRUE;
		bDpktSetDataPacketDebCfg( &(pxFFeeP->xChannel[ucAeb].xDataPacket) );

		bDpktGetDataPacketAebCfg( &(pxFFeeP->xChannel[ucAeb].xDataPacket) );
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketAebCfg.usiAebCcdImgVEndLeftBuffer  = pxFFeeP->xCcdInfo.usiHeight - 1;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketAebCfg.usiAebCcdHEndLeftBuffer     = pxFFeeP->xCcdInfo.usiHalfWidth + pxFFeeP->xCcdInfo.usiSPrescanN + pxFFeeP->xCcdInfo.usiSOverscanN - 1;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketAebCfg.bAebCcdImgEnLeftBuffer      = TRUE;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketAebCfg.bAebCcdOvsEnLeftBuffer      = TRUE;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketAebCfg.ucAebCcdNumberIDLeftBuffer  = 0;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketAebCfg.usiAebCcdImgVEndRightBuffer = pxFFeeP->xCcdInfo.usiHeight - 1;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketAebCfg.usiAebCcdHEndRightBuffer    = pxFFeeP->xCcdInfo.usiHalfWidth + pxFFeeP->xCcdInfo.usiSPrescanN + pxFFeeP->xCcdInfo.usiSOverscanN - 1;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketAebCfg.bAebCcdImgEnRightBuffer     = TRUE;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketAebCfg.bAebCcdOvsEnRightBuffer     = TRUE;
		pxFFeeP->xChannel[ucAeb].xDataPacket.xDpktDataPacketAebCfg.ucAebCcdNumberIDRightBuffer = 0;
		bDpktSetDataPacketAebCfg( &(pxFFeeP->xChannel[ucAeb].xDataPacket) );
	}

}

/* Initializing the the values of the RMAP memory area */
void vInitialConfig_RmapMemArea( TFFee *pxFFeeP ) {

	alt_u8 ucAeb = 0;

	bRmapGetRmapMemHkArea( &(pxFFeeP->xChannel[0].xRmap) );
	bRmapGetRmapMemCfgArea( &(pxFFeeP->xChannel[0].xRmap) );

	pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg = vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaCritCfg;
	pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg = vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaGenCfg;
	pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk = vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk;

	for (ucAeb = 0; N_OF_CCD > ucAeb; ucAeb++ ) {

		pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAeb]->xRmapAebAreaCritCfg = vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaCritCfg[ucAeb];
		pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAeb]->xRmapAebAreaGenCfg = vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaGenCfg[ucAeb];
		pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAeb]->xRmapAebAreaHk = vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[ucAeb];

	}

	bRmapSetRmapMemHkArea( &(pxFFeeP->xChannel[0].xRmap) );
	bRmapSetRmapMemCfgArea( &(pxFFeeP->xChannel[0].xRmap) );

}

/**
 * @name vUpdateFeeHKValue
 * @author bndky
 * @brief Update RMAP HK function for simulated FEE
 * @ingroup rtos
 *
 * @param 	[in]	TFFee 	        *pxFFeeP
 * @param	[in]	alt_u16	        usiRmapHkID (same as Default ID)
 * @param	[in]	alt_u32			uliRawValue
 *
 **/
void vUpdateFeeHKValue ( TFFee *pxFFeeP, alt_u16 usiRmapHkID, alt_u32 uliRawValue ) {

	/* Load current values */
	bRmapGetRmapMemHkArea(&(pxFFeeP->xChannel[0].xRmap));

	/* Switch case to assign value to register */
	switch(usiRmapHkID){

		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "OPER_MOD" Field */
		case eDeftFfeeDebAreaHkDebStatusOperModId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOperMod               = (alt_u8) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebStatus.ucOperMod                                             = (alt_u8) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "EDAC_LIST_CORR_ERR" Field */
		case eDeftFfeeDebAreaHkDebStatusEdacListCorrErrId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr       = (alt_u8) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr                                     = (alt_u8) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "EDAC_LIST_UNCORR_ERR" Field */
		case eDeftFfeeDebAreaHkDebStatusEdacListUncorrErrId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr     = (alt_u8) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr                                   = (alt_u8) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", PLL_REF, "PLL_VCXO", "PLL_LOCK" Fields */
		case eDeftFfeeDebAreaHkDebStatusOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucOthers                = (alt_u8) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebStatus.ucOthers                                              = (alt_u8) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "VDIG_AEB_4" Field */
		case eDeftFfeeDebAreaHkDebStatusVdigAeb4Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4               = (bool) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebStatus.bVdigAeb4                                             = (bool) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "VDIG_AEB_3" Field */
		case eDeftFfeeDebAreaHkDebStatusVdigAeb3Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3               = (bool) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebStatus.bVdigAeb3                                             = (bool) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "VDIG_AEB_2" Field */
		case eDeftFfeeDebAreaHkDebStatusVdigAeb2Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2               = (bool) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebStatus.bVdigAeb2                                             = (bool) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "VDIG_AEB_1" Field */
		case eDeftFfeeDebAreaHkDebStatusVdigAeb1Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1               = (bool) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebStatus.bVdigAeb1                                             = (bool) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "WDW_LIST_CNT_OVF" Field */
		case eDeftFfeeDebAreaHkDebStatusWdwListCntOvfId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf         = (alt_u8) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf                                       = (alt_u8) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "WDG" Field */
		case eDeftFfeeDebAreaHkDebStatusWdgId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bWdg                    = (bool) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebStatus.bWdg                                                  = (bool) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_8" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList8Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList8               = (bool) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebOvf.bRowActList8                                             = (bool) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_7" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList7Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList7               = (bool) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebOvf.bRowActList7                                             = (bool) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_6" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList6Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList6               = (bool) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebOvf.bRowActList6                                             = (bool) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_5" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList5Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList5               = (bool) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebOvf.bRowActList5                                             = (bool) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_4" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList4Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList4               = (bool) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebOvf.bRowActList4                                             = (bool) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_3" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList3Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList3               = (bool) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebOvf.bRowActList3                                             = (bool) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_2" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList2Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList2               = (bool) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebOvf.bRowActList2                                             = (bool) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_1" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList1Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebOvf.bRowActList1               = (bool) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebOvf.bRowActList1                                             = (bool) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_AHK1", "VDIG_IN" Field */
		case eDeftFfeeDebAreaHkDebAhk1VdigInId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebAhk1.usiVdigIn                 = (alt_u16) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebAhk1.usiVdigIn                                               = (alt_u16) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_AHK1", "VIO" Field */
		case eDeftFfeeDebAreaHkDebAhk1VioId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebAhk1.usiVio                    = (alt_u16) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebAhk1.usiVio                                                  = (alt_u16) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_AHK2", "VCOR" Field */
		case eDeftFfeeDebAreaHkDebAhk2VcorId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebAhk2.usiVcor                   = (alt_u16) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebAhk2.usiVcor                                                 = (alt_u16) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_AHK2", "VLVD" Field */
		case eDeftFfeeDebAreaHkDebAhk2VlvdId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebAhk2.usiVlvd                   = (alt_u16) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebAhk2.usiVlvd                                                 = (alt_u16) uliRawValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_AHK3", "DEB_TEMP" Field */
		case eDeftFfeeDebAreaHkDebAhk3DebTempId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebAhk3.usiDebTemp                = (alt_u16) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapDebAreaHk.xDebAhk3.usiDebTemp                                              = (alt_u16) uliRawValue;
			break;

		/* F-FEE AEB 1 Housekeeping Area Register "AEB_STATUS", "AEB_STATUS" Field */
		case eDeftFfeeAeb1AreaHkAebStatusAebStatusId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAebStatus.ucAebStatus          = (alt_u8) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAebStatus.ucAebStatus                                        = (alt_u8) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "AEB_STATUS", VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields */
		case eDeftFfeeAeb1AreaHkAebStatusOthers0Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAebStatus.ucOthers0            = (alt_u8) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAebStatus.ucOthers0                                          = (alt_u8) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "AEB_STATUS", DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields */
		case eDeftFfeeAeb1AreaHkAebStatusOthers1Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAebStatus.usiOthers1           = (alt_u16) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAebStatus.usiOthers1                                         = (alt_u16) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "TIMESTAMP_1", "TIMESTAMP_DWORD_1" Field */
		case eDeftFfeeAeb1AreaHkTimestamp1TimestampDword1Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1  = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xTimestamp1.uliTimestampDword1                                = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "TIMESTAMP_2", "TIMESTAMP_DWORD_0" Field */
		case eDeftFfeeAeb1AreaHkTimestamp2TimestampDword0Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0  = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xTimestamp2.uliTimestampDword0                                = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_VASP_L", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTVaspLOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataTVaspL.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_VASP_R", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTVaspROthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataTVaspR.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTBiasPOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataTBiasP.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_HK_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTHkPOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers        = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataTHkP.uliOthers                                      = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTTou1POthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataTTou1P.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTTou2POthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataTTou2P.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_VODE", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkVodeOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataHkVode.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_VODF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkVodfOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataHkVodf.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_VRD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkVrdOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers       = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataHkVrd.uliOthers                                     = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_VOG", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkVogOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers       = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataHkVog.uliOthers                                     = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_CCD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTCcdOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers        = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataTCcd.uliOthers                                      = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTRef1KMeaOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataTRef1KMea.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTRef649RMeaOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataTRef649RMea.uliOthers                               = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkAnaN5VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers    = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataHkAnaN5V.uliOthers                                  = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_S_REF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataSRefOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers        = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataSRef.uliOthers                                      = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkCcdP31VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataHkCcdP31V.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkClkP15VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataHkClkP15V.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkAnaP5VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers    = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataHkAnaP5V.uliOthers                                  = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkAnaP3V3OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataHkAnaP3V3.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkDigP3V3OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataHkDigP3V3.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataAdcRefBuf2OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers  = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xAdcRdDataAdcRefBuf2.uliOthers                                = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "VASP_RD_CONFIG", VASP1_READ_DATA, "VASP2_READ_DATA" Fields */
		case eDeftFfeeAeb1AreaHkVaspRdConfigOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xVaspRdConfig.usiOthers         = (alt_u16) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xVaspRdConfig.usiOthers                                       = (alt_u16) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "REVISION_ID_1", FPGA_VERSION, "FPGA_DATE" Fields */
		case eDeftFfeeAeb1AreaHkRevisionId1OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xRevisionId1.uliOthers          = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xRevisionId1.uliOthers                                        = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "REVISION_ID_2", FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields */
		case eDeftFfeeAeb1AreaHkRevisionId2OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0]->xRmapAebAreaHk.xRevisionId2.uliOthers          = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[0].xRevisionId2.uliOthers                                        = (alt_u32) uliRawValue;
			break;

		/* F-FEE AEB 2 Housekeeping Area Register "AEB_STATUS", "AEB_STATUS" Field */
		case eDeftFfeeAeb2AreaHkAebStatusAebStatusId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAebStatus.ucAebStatus          = (alt_u8) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAebStatus.ucAebStatus                                        = (alt_u8) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "AEB_STATUS", VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields */
		case eDeftFfeeAeb2AreaHkAebStatusOthers0Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAebStatus.ucOthers0            = (alt_u8) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAebStatus.ucOthers0                                          = (alt_u8) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "AEB_STATUS", DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields */
		case eDeftFfeeAeb2AreaHkAebStatusOthers1Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAebStatus.usiOthers1           = (alt_u16) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAebStatus.usiOthers1                                         = (alt_u16) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "TIMESTAMP_1", "TIMESTAMP_DWORD_1" Field */
		case eDeftFfeeAeb2AreaHkTimestamp1TimestampDword1Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1  = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xTimestamp1.uliTimestampDword1                                = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "TIMESTAMP_2", "TIMESTAMP_DWORD_0" Field */
		case eDeftFfeeAeb2AreaHkTimestamp2TimestampDword0Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0  = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xTimestamp2.uliTimestampDword0                                = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_VASP_L", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTVaspLOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataTVaspL.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_VASP_R", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTVaspROthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataTVaspR.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTBiasPOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataTBiasP.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_HK_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTHkPOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers        = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataTHkP.uliOthers                                      = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTTou1POthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataTTou1P.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTTou2POthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataTTou2P.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_VODE", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkVodeOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataHkVode.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_VODF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkVodfOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataHkVodf.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_VRD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkVrdOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers       = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataHkVrd.uliOthers                                     = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_VOG", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkVogOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers       = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataHkVog.uliOthers                                     = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_CCD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTCcdOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers        = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataTCcd.uliOthers                                      = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTRef1KMeaOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataTRef1KMea.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTRef649RMeaOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataTRef649RMea.uliOthers                               = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkAnaN5VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers    = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataHkAnaN5V.uliOthers                                  = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_S_REF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataSRefOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers        = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataSRef.uliOthers                                      = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkCcdP31VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataHkCcdP31V.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkClkP15VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataHkClkP15V.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkAnaP5VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers    = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataHkAnaP5V.uliOthers                                  = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkAnaP3V3OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataHkAnaP3V3.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkDigP3V3OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataHkDigP3V3.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataAdcRefBuf2OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers  = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xAdcRdDataAdcRefBuf2.uliOthers                                = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "VASP_RD_CONFIG", VASP1_READ_DATA, "VASP2_READ_DATA" Fields */
		case eDeftFfeeAeb2AreaHkVaspRdConfigOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xVaspRdConfig.usiOthers         = (alt_u16) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xVaspRdConfig.usiOthers                                       = (alt_u16) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "REVISION_ID_1", FPGA_VERSION, "FPGA_DATE" Fields */
		case eDeftFfeeAeb2AreaHkRevisionId1OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xRevisionId1.uliOthers          = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xRevisionId1.uliOthers                                        = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "REVISION_ID_2", FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields */
		case eDeftFfeeAeb2AreaHkRevisionId2OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1]->xRmapAebAreaHk.xRevisionId2.uliOthers          = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[1].xRevisionId2.uliOthers                                        = (alt_u32) uliRawValue;
			break;

		/* F-FEE AEB 3 Housekeeping Area Register "AEB_STATUS", "AEB_STATUS" Field */
		case eDeftFfeeAeb3AreaHkAebStatusAebStatusId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAebStatus.ucAebStatus          = (alt_u8) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAebStatus.ucAebStatus                                        = (alt_u8) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "AEB_STATUS", VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields */
		case eDeftFfeeAeb3AreaHkAebStatusOthers0Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAebStatus.ucOthers0            = (alt_u8) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAebStatus.ucOthers0                                          = (alt_u8) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "AEB_STATUS", DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields */
		case eDeftFfeeAeb3AreaHkAebStatusOthers1Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAebStatus.usiOthers1           = (alt_u16) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAebStatus.usiOthers1                                         = (alt_u16) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "TIMESTAMP_1", "TIMESTAMP_DWORD_1" Field */
		case eDeftFfeeAeb3AreaHkTimestamp1TimestampDword1Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1  = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xTimestamp1.uliTimestampDword1                                = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "TIMESTAMP_2", "TIMESTAMP_DWORD_0" Field */
		case eDeftFfeeAeb3AreaHkTimestamp2TimestampDword0Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0  = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xTimestamp2.uliTimestampDword0                                = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_VASP_L", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTVaspLOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataTVaspL.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_VASP_R", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTVaspROthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataTVaspR.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTBiasPOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataTBiasP.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_HK_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTHkPOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers        = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataTHkP.uliOthers                                      = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTTou1POthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataTTou1P.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTTou2POthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataTTou2P.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_VODE", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkVodeOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataHkVode.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_VODF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkVodfOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataHkVodf.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_VRD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkVrdOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers       = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataHkVrd.uliOthers                                     = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_VOG", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkVogOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers       = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataHkVog.uliOthers                                     = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_CCD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTCcdOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers        = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataTCcd.uliOthers                                      = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTRef1KMeaOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataTRef1KMea.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTRef649RMeaOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataTRef649RMea.uliOthers                               = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkAnaN5VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers    = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataHkAnaN5V.uliOthers                                  = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_S_REF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataSRefOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers        = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataSRef.uliOthers                                      = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkCcdP31VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataHkCcdP31V.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkClkP15VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataHkClkP15V.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkAnaP5VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers    = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataHkAnaP5V.uliOthers                                  = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkAnaP3V3OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataHkAnaP3V3.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkDigP3V3OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataHkDigP3V3.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataAdcRefBuf2OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers  = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xAdcRdDataAdcRefBuf2.uliOthers                                = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "VASP_RD_CONFIG", VASP1_READ_DATA, "VASP2_READ_DATA" Fields */
		case eDeftFfeeAeb3AreaHkVaspRdConfigOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xVaspRdConfig.usiOthers         = (alt_u16) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xVaspRdConfig.usiOthers                                       = (alt_u16) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "REVISION_ID_1", FPGA_VERSION, "FPGA_DATE" Fields */
		case eDeftFfeeAeb3AreaHkRevisionId1OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xRevisionId1.uliOthers          = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xRevisionId1.uliOthers                                        = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "REVISION_ID_2", FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields */
		case eDeftFfeeAeb3AreaHkRevisionId2OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2]->xRmapAebAreaHk.xRevisionId2.uliOthers          = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[2].xRevisionId2.uliOthers                                        = (alt_u32) uliRawValue;
			break;

		/* F-FEE AEB 4 Housekeeping Area Register "AEB_STATUS", "AEB_STATUS" Field */
		case eDeftFfeeAeb4AreaHkAebStatusAebStatusId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAebStatus.ucAebStatus          = (alt_u8) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAebStatus.ucAebStatus                                        = (alt_u8) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "AEB_STATUS", VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields */
		case eDeftFfeeAeb4AreaHkAebStatusOthers0Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAebStatus.ucOthers0            = (alt_u8) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAebStatus.ucOthers0                                          = (alt_u8) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "AEB_STATUS", DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields */
		case eDeftFfeeAeb4AreaHkAebStatusOthers1Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAebStatus.usiOthers1           = (alt_u16) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAebStatus.usiOthers1                                         = (alt_u16) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "TIMESTAMP_1", "TIMESTAMP_DWORD_1" Field */
		case eDeftFfeeAeb4AreaHkTimestamp1TimestampDword1Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1  = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xTimestamp1.uliTimestampDword1                                = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "TIMESTAMP_2", "TIMESTAMP_DWORD_0" Field */
		case eDeftFfeeAeb4AreaHkTimestamp2TimestampDword0Id:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0  = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xTimestamp2.uliTimestampDword0                                = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_VASP_L", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTVaspLOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataTVaspL.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_VASP_R", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTVaspROthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataTVaspR.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTBiasPOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataTBiasP.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_HK_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTHkPOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers        = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataTHkP.uliOthers                                      = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTTou1POthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataTTou1P.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTTou2POthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataTTou2P.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_VODE", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkVodeOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataHkVode.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_VODF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkVodfOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers      = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataHkVodf.uliOthers                                    = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_VRD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkVrdOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers       = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataHkVrd.uliOthers                                     = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_VOG", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkVogOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers       = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataHkVog.uliOthers                                     = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_CCD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTCcdOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers        = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataTCcd.uliOthers                                      = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTRef1KMeaOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataTRef1KMea.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTRef649RMeaOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataTRef649RMea.uliOthers                               = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkAnaN5VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers    = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataHkAnaN5V.uliOthers                                  = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_S_REF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataSRefOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers        = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataSRef.uliOthers                                      = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkCcdP31VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataHkCcdP31V.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkClkP15VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataHkClkP15V.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkAnaP5VOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers    = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataHkAnaP5V.uliOthers                                  = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkAnaP3V3OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataHkAnaP3V3.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkDigP3V3OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers   = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataHkDigP3V3.uliOthers                                 = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataAdcRefBuf2OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers  = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xAdcRdDataAdcRefBuf2.uliOthers                                = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "VASP_RD_CONFIG", VASP1_READ_DATA, "VASP2_READ_DATA" Fields */
		case eDeftFfeeAeb4AreaHkVaspRdConfigOthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xVaspRdConfig.usiOthers         = (alt_u16) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xVaspRdConfig.usiOthers                                       = (alt_u16) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "REVISION_ID_1", FPGA_VERSION, "FPGA_DATE" Fields */
		case eDeftFfeeAeb4AreaHkRevisionId1OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xRevisionId1.uliOthers          = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xRevisionId1.uliOthers                                        = (alt_u32) uliRawValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "REVISION_ID_2", FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields */
		case eDeftFfeeAeb4AreaHkRevisionId2OthersId:
			pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3]->xRmapAebAreaHk.xRevisionId2.uliOthers          = (alt_u32) uliRawValue;
			vxDeftFeeDefaults[pxFFeeP->ucId].xRmapAebAreaHk[3].xRevisionId2.uliOthers                                        = (alt_u32) uliRawValue;
			break;

		default:
			#if DEBUG_ON
			if ( xDefaults.ucDebugLevel <= dlMajorMessage )
				fprintf(fp, "HK update [FEE %u]: HK ID out of bounds: %u;\n", pxFFeeP->ucId, usiRmapHkID );
			#endif
			break;
	}

	bRmapSetRmapMemHkArea(&(pxFFeeP->xChannel[0].xRmap));

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


/* This function send command request for the FFEE Controller Queue*/
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


/* This function send command request for the FFEE Controller Queue*/
bool bSendRequestFeeCtrl( unsigned char ucCMD, unsigned char ucSUBType, unsigned char ucValue )
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

bool bDisableSPWChannel( TSpwcChannel *xSPW, unsigned char ucFee ) {
	/* Disable SPW channel */
	bSpwcGetLinkConfig(xSPW);
	xSPW->xSpwcLinkConfig.bLinkStart = FALSE;
	xSPW->xSpwcLinkConfig.bAutostart = FALSE;
	xSPW->xSpwcLinkConfig.bDisconnect = TRUE;
	bSpwcSetLinkConfig(xSPW);

	/*todo: No treatment for now  */
	return TRUE;
}

bool bEnableSPWChannel( TSpwcChannel *xSPW, unsigned char ucFee ) {
	/* Enable SPW channel */
	bSpwcGetLinkConfig(xSPW);
	xSPW->xSpwcLinkConfig.bEnable = TRUE;
	xSPW->xSpwcLinkConfig.bLinkStart = xConfSpw[ucFee].bSpwLinkStart;
	xSPW->xSpwcLinkConfig.bAutostart = xConfSpw[ucFee].bSpwLinkAutostart;
	xSPW->xSpwcLinkConfig.bDisconnect = FALSE;
	bSpwcSetLinkConfig(xSPW);

	/*todo: No treatment for now  */
	return TRUE;
}

void vConfigTinMode( TFFee *pxFFeeP , TtInMode *xTinModeP, unsigned ucTxin){
	unsigned char ucMode, ucX;

	(*xTinModeP).bSent = FALSE;

	ucX = ucTxin;
	switch (ucTxin) {
		case 7:
			ucMode = pxFFeeP->xControl.xDeb.ucTxInMode[ucX];
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
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
					}
					#endif
			}
			break;
		case 6:
			ucMode = pxFFeeP->xControl.xDeb.ucTxInMode[ucX];
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
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
						}
						#endif
				}
			break;
		case 5:
			ucMode = pxFFeeP->xControl.xDeb.ucTxInMode[ucX];
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
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
						}
						#endif
				}
			break;
		case 4:
			ucMode = pxFFeeP->xControl.xDeb.ucTxInMode[ucX];
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
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
						}
						#endif
				}

			break;
		case 3:
			ucMode = pxFFeeP->xControl.xDeb.ucTxInMode[ucX];
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
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
						}
						#endif
				}
			break;
		case 2:
			ucMode = pxFFeeP->xControl.xDeb.ucTxInMode[ucX];
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
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
						}
						#endif
				}
			break;
		case 1:
			ucMode = pxFFeeP->xControl.xDeb.ucTxInMode[ucX];
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
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
						}
						#endif
				}
			break;
		case 0:
			ucMode = pxFFeeP->xControl.xDeb.ucTxInMode[ucX];
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
					if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
						fprintf(fp,"Tx_IN_MOD: Unused value to T%hhu, set to no data\n\n", ucX);
					}
					#endif
			}
			break;
		default:
			break;
	}
}

bool bEnableDbBuffer( TFFee *pxFFeeP, TFeebChannel *pxFeebCh ) {
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

inline void vActivateContentErrInj( TFFee *pxFFeeP ) {
	unsigned char ucIL;
	for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
		if (TRUE == pxFFeeP->xErrorInjControl[ucIL].xImgWinContentErr.bStartLeftErrorInj) {
			bDpktGetLeftContentErrInj(&pxFFeeP->xChannel[ucIL].xDataPacket);
			if (TRUE == pxFFeeP->xChannel[ucIL].xDataPacket.xDpktLeftContentErrInj.bInjecting) {
				bDpktContentErrInjStopInj(&pxFFeeP->xChannel[ucIL].xDataPacket, eDpktCcdSideE);
			}
			if (bDpktContentErrInjStartInj(&pxFFeeP->xChannel[ucIL].xDataPacket, eDpktCcdSideE)) {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu AEB %hhu Task: Image and window error injection started (left side)\n", pxFFeeP->ucId, ucIL);
				#endif
			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu AEB %hhu Task: Image and window error injection could not start (left side)\n", pxFFeeP->ucId, ucIL);
				#endif
			}
			pxFFeeP->xErrorInjControl[ucIL].xImgWinContentErr.bStartLeftErrorInj = FALSE;
		}
		if (TRUE == pxFFeeP->xErrorInjControl[ucIL].xImgWinContentErr.bStartRightErrorInj) {
			bDpktGetRightContentErrInj(&pxFFeeP->xChannel[ucIL].xDataPacket);
			if (TRUE == pxFFeeP->xChannel[ucIL].xDataPacket.xDpktRightContentErrInj.bInjecting) {
				bDpktContentErrInjStopInj(&pxFFeeP->xChannel[ucIL].xDataPacket, eDpktCcdSideF);
			}
			if (bDpktContentErrInjStartInj(&pxFFeeP->xChannel[ucIL].xDataPacket, eDpktCcdSideF)) {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu AEB %hhu Task: Image and window error injection started (right side)\n", pxFFeeP->ucId, ucIL);
				#endif
			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu AEB %hhu Task: Image and window error injection could not start (right side)\n", pxFFeeP->ucId, ucIL);
				#endif
			}
			pxFFeeP->xErrorInjControl[ucIL].xImgWinContentErr.bStartRightErrorInj = FALSE;
		}
	}
}

inline void vActivateDataPacketErrInj( TFFee *pxFFeeP ) {
	unsigned char ucIL;
	for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
		if (TRUE == pxFFeeP->xErrorInjControl[ucIL].xDataPktError.bStartErrorInj) {
			if ( bDpktHeaderErrInjStartInj(&pxFFeeP->xChannel[ucIL].xDataPacket) ) {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu AEB %hhu Task: Data packet header error injection started\n", pxFFeeP->ucId, ucIL);
				#endif
			} else {
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
					fprintf(fp,"FFEE %hhu AEB %hhu Task: Data packet header error injection could not start\n", pxFFeeP->ucId, ucIL);
				#endif
			}
			pxFFeeP->xErrorInjControl[ucIL].xDataPktError.bStartErrorInj = FALSE;
		}
	}
}

/*DLR DLR RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinModeOn( TFFee *pxFFeeP, unsigned int cmd ) {
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
	vSendEventLogArr(pxFFeeP->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtRmapReceived]);

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case eRmapDebCritCfgDtcAebOnoffAddr: //DTC_AEB_ONOFF (ICD p. 40)

				pxFFeeP->xControl.xAeb[0].bSwitchedOn = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxFFeeP->xControl.xAeb[1].bSwitchedOn = pxFFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;
				pxFFeeP->xControl.xAeb[2].bSwitchedOn = pxFFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;
				pxFFeeP->xControl.xAeb[3].bSwitchedOn = pxFFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;

				/* Get AEBs On/Off Status - [rfranca] */
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = pxFFeeP->xControl.xAeb[0].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = pxFFeeP->xControl.xAeb[1].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = pxFFeeP->xControl.xAeb[2].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = pxFFeeP->xControl.xAeb[3].bSwitchedOn;
				break;
			case eRmapDebCritCfgDtcFeeModAddr: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case eRmapDebOpModeFullImg:
						/* DEB Operational Mode 0 : DEB Full-Image Mode */
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Can't go to this mode from On mode\n\n");
						}
						#endif
						break;
					case eRmapDebOpModeFullImgPatt:
						/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
						pxFFeeP->xControl.xDeb.eState = sWaitSync;

						pxFFeeP->xControl.bWatingSync = TRUE;
						/* Real Fee State (graph) */
						pxFFeeP->xControl.xDeb.eLastMode = sOn_Enter;
						pxFFeeP->xControl.xDeb.eMode = sOn;
						pxFFeeP->xControl.xDeb.eNextMode = sFullPattern_Enter;
						/* Real State */
						pxFFeeP->xControl.xDeb.eState = sOn;

						break;
					case eRmapDebOpModeWin:
						/* DEB Operational Mode 2 : DEB Windowing Mode */
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Can't go to this mode from On mode\n\n");
						}
						#endif
						break;
					case eRmapDebOpModeWinPatt:
						/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
						pxFFeeP->xControl.xDeb.eState = sWaitSync;

						pxFFeeP->xControl.bWatingSync = TRUE;
						/* Real Fee State (graph) */
						pxFFeeP->xControl.xDeb.eLastMode = sOn_Enter;
						pxFFeeP->xControl.xDeb.eMode = sOn;
						pxFFeeP->xControl.xDeb.eNextMode = sWinPattern_Enter;
						/* Real State */
						pxFFeeP->xControl.xDeb.eState = sOn;

						break;
					case eRmapDebOpModeStandby:
						/* DEB Operational Mode 6 : DEB Standby Mode */

						/*Asynchronous*/
						pxFFeeP->xControl.xDeb.eState = sStandBy_Enter;

						pxFFeeP->xControl.xDeb.eMode = sStandBy;
						pxFFeeP->xControl.xDeb.eLastMode = sOn_Enter;
						pxFFeeP->xControl.xDeb.eNextMode = sStandBy_Enter;

						break;
					case eRmapDebOpModeOn:
						/* DEB Operational Mode 7 : DEB On Mode */
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: DEB already in On mode\n\n");
						}
						#endif
						break;
					default:
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Invalid Mode (%hhu)\n\n", ucMode);
						}
						#endif
				}
				break;

			case eRmapDebCritCfgDtcImmOnmodAddr: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxFFeeP->xControl.xDeb.eState = sOn_Enter;

				pxFFeeP->xControl.xDeb.eMode = sOn;
				pxFFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxFFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case eRmapDebGenCfgDtcInMod1Addr: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxFFeeP->xControl.xDeb.ucTxInMode[7] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[6] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[5] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[4] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case eRmapDebGenCfgDtcInMod2Addr: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxFFeeP->xControl.xDeb.ucTxInMode[3] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[2] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[1] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[0] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case eRmapDebGenCfgDtcWdwSizAddr: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcWdwIdx1Addr: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case eRmapDebGenCfgDtcWdwIdx2Addr:
			case eRmapDebGenCfgDtcWdwIdx3Addr:
			case eRmapDebGenCfgDtcWdwIdx4Addr:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcOvsPatAddr: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSizPatAddr: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcTrg25SAddr: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				vChangeSyncRepeat( &xSimMeb, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc );
				/* Check if the Sync Generator should be stopped */
				if (0 == pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc) {
					/* Sync Generator should be stopped */
					bSyncCtrHoldBlankPulse(TRUE);
				} else {
					/* Sync Generator should be running */
					bSyncCtrHoldBlankPulse(FALSE);
				}
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSelTrgAddr: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcFrmCntAddr: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				/* rfranca */
				for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
					bDpktSetFrameCounterValue(&pxFFeeP->xChannel[ucIL].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				}
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[0].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[1].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[2].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[3].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSelSynAddr: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcRspCpsAddr: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtc25SDlyAddr: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcTmodConfAddr: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSpwCfgAddr: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
					pxFFeeP->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}
				//pxFFeeP->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				//pxFFeeP->xChannel[1].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				//pxFFeeP->xChannel[2].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				//pxFFeeP->xChannel[3].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;

				pxFFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
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
			case eRmapAebCritCfgAebControlAddr: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					/* Soft-Reset the AEB RMAP Areas (reset all registers) - [rfranca] */
					bRmapZeroFillAebRamMem(ucAebNumber);
					bRmapSoftRstAebMemArea(ucAebNumber);

					/* Set AEB to AEB_STATE_INIT  - [rfranca] */
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = eRmapAebStateInit;
					pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
				} else if ( bSetState == TRUE ) {
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case eRmapAebStateOff:
							/* AEB State : AEB_STATE_OFF */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebOffMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_OFF \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateInit:
							/* AEB State : AEB_STATE_INIT */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebInitMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_INIT \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateConfig:
							/* AEB State : AEB_STATE_CONFIG */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebConfigMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_CONFIG \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateImage:
							/* AEB State : AEB_STATE_IMAGE */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebImageMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_IMAGE \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerDown:
							/* AEB State : AEB_STATE_POWER_DOWN */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerDownMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerUp:
							/* AEB State : AEB_STATE_POWER_UP */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerUpMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePattern:
							/* AEB State : AEB_STATE_PATTERN */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPatternMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_PATTERN \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateFailure:
							/* AEB State : AEB_STATE_FAILURE */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebFailureMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							/* AEB State : Unused/Spare */
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case eRmapAebCritCfgAebConfigPatternAddr: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_CONFIG_PATTERN\n\n", ucEntity, usiADDRReg);
				}
				#endif
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu)- RMAP Reg (%hu): Cmd not implemented in this version.\n\n", ucEntity, usiADDRReg);
				}
				#endif
		}

	}
}

/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPBeforeSync( TFFee *pxFFeeP, unsigned int cmd ) {
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
	vSendEventLogArr(pxFFeeP->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtRmapReceived]);

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case eRmapDebCritCfgDtcAebOnoffAddr: //DTC_AEB_ONOFF (ICD p. 40)

				pxFFeeP->xControl.xAeb[0].bSwitchedOn = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxFFeeP->xControl.xAeb[1].bSwitchedOn = pxFFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;
				pxFFeeP->xControl.xAeb[2].bSwitchedOn = pxFFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;
				pxFFeeP->xControl.xAeb[3].bSwitchedOn = pxFFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;

				/* Get AEBs On/Off Status - [rfranca] */
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = pxFFeeP->xControl.xAeb[0].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = pxFFeeP->xControl.xAeb[1].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = pxFFeeP->xControl.xAeb[2].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = pxFFeeP->xControl.xAeb[3].bSwitchedOn;
				break;
			case eRmapDebCritCfgDtcFeeModAddr: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case eRmapDebOpModeFullImg:
						/* DEB Operational Mode 0 : DEB Full-Image Mode */
					case eRmapDebOpModeWin:
						/* DEB Operational Mode 2 : DEB Windowing Mode */
						for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
						break;
					case eRmapDebOpModeFullImgPatt:
						/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
					case eRmapDebOpModeWinPatt:
						/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
						for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif

						break;
					case eRmapDebOpModeStandby:
						/* DEB Operational Mode 6 : DEB Standby Mode */

						if (( pxFFeeP->xControl.xDeb.eMode == sFullImage ) || (pxFFeeP->xControl.xDeb.eMode == sWindowing)){
							pxFFeeP->xControl.bWatingSync = TRUE;
							pxFFeeP->xControl.xDeb.eState = redoutWaitBeforeSyncSignal; /*Will stay until master sync*/
							pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;
						} else {
							for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
								bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
								pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
								bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							}
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
								fprintf(fp,"FFEE %hhu Task:  Command not allowed for this mode (in redoutTransmission)\n", pxFFeeP->ucId);
							#endif
						}

						break;
					case eRmapDebOpModeOn:
						/* DEB Operational Mode 7 : DEB On Mode */
						if (( pxFFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxFFeeP->xControl.xDeb.eMode == sWinPattern)) {

							pxFFeeP->xControl.bWatingSync = TRUE;
							pxFFeeP->xControl.xDeb.eState = redoutWaitBeforeSyncSignal; /*Will stay until master sync*/
							pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;

						} else {
							for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
								bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
								pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
								bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							}
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
							}
							#endif
						}
						break;
					default:
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Invalid Mode (%hhu)\n\n", ucMode);
						}
						#endif
				}
				break;

			case eRmapDebCritCfgDtcImmOnmodAddr: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxFFeeP->xControl.xDeb.eState = sOn_Enter;

				pxFFeeP->xControl.xDeb.eMode = sOn;
				pxFFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxFFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case eRmapDebGenCfgDtcInMod1Addr: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxFFeeP->xControl.xDeb.ucTxInMode[7] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[6] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[5] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[4] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case eRmapDebGenCfgDtcInMod2Addr: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxFFeeP->xControl.xDeb.ucTxInMode[3] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[2] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[1] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[0] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case eRmapDebGenCfgDtcWdwSizAddr: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcWdwIdx1Addr: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case eRmapDebGenCfgDtcWdwIdx2Addr:
			case eRmapDebGenCfgDtcWdwIdx3Addr:
			case eRmapDebGenCfgDtcWdwIdx4Addr:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcOvsPatAddr: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSizPatAddr: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcTrg25SAddr: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSelTrgAddr: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcFrmCntAddr: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				/* rfranca */
				bDpktSetFrameCounterValue(&pxFFeeP->xChannel[0].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				bDpktSetFrameCounterValue(&pxFFeeP->xChannel[1].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				bDpktSetFrameCounterValue(&pxFFeeP->xChannel[2].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				bDpktSetFrameCounterValue(&pxFFeeP->xChannel[3].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSelSynAddr: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcRspCpsAddr: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtc25SDlyAddr: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcTmodConfAddr: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSpwCfgAddr: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				pxFFeeP->xChannel[0].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				pxFFeeP->xChannel[1].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				pxFFeeP->xChannel[2].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				pxFFeeP->xChannel[3].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;

				pxFFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
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
			case eRmapAebCritCfgAebControlAddr: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					/* Soft-Reset the AEB RMAP Areas (reset all registers) - [rfranca] */
					bRmapSoftRstAebMemArea(ucAebNumber);
					bRmapZeroFillAebRamMem(ucAebNumber);

					/* Set AEB to AEB_STATE_INIT  - [rfranca] */
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = eRmapAebStateInit;
					pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
				} else if ( bSetState == TRUE ) {
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case eRmapAebStateOff:
							/* AEB State : AEB_STATE_OFF */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebOffMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_OFF \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateInit:
							/* AEB State : AEB_STATE_INIT */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebInitMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_INIT \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateConfig:
							/* AEB State : AEB_STATE_CONFIG */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebConfigMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_CONFIG \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateImage:
							/* AEB State : AEB_STATE_IMAGE */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebImageMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_IMAGE \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerDown:
							/* AEB State : AEB_STATE_POWER_DOWN */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerDownMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerUp:
							/* AEB State : AEB_STATE_POWER_UP */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerUpMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePattern:
							/* AEB State : AEB_STATE_PATTERN */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPatternMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_PATTERN \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateFailure:
							/* AEB State : AEB_STATE_FAILURE */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebFailureMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							/* AEB State : Unused/Spare */
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case eRmapAebCritCfgAebConfigPatternAddr: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_CONFIG_PATTERN\n\n", ucEntity, usiADDRReg);
				}
				#endif
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu)- RMAP Reg (%hu): Cmd not implemented in this version.\n\n", ucEntity, usiADDRReg);
				}
				#endif
		}

	}
}

/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinWaitingMemUpdate( TFFee *pxFFeeP, unsigned int cmd ) {
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
	vSendEventLogArr(pxFFeeP->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtRmapReceived]);

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case eRmapDebCritCfgDtcAebOnoffAddr: //DTC_AEB_ONOFF (ICD p. 40)

				pxFFeeP->xControl.xAeb[0].bSwitchedOn = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxFFeeP->xControl.xAeb[1].bSwitchedOn = pxFFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;
				pxFFeeP->xControl.xAeb[2].bSwitchedOn = pxFFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;
				pxFFeeP->xControl.xAeb[3].bSwitchedOn = pxFFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;

				/* Get AEBs On/Off Status - [rfranca] */
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = pxFFeeP->xControl.xAeb[0].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = pxFFeeP->xControl.xAeb[1].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = pxFFeeP->xControl.xAeb[2].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = pxFFeeP->xControl.xAeb[3].bSwitchedOn;
				break;
			case eRmapDebCritCfgDtcFeeModAddr: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case eRmapDebOpModeFullImg:
						/* DEB Operational Mode 0 : DEB Full-Image Mode */
					case eRmapDebOpModeWin:
						/* DEB Operational Mode 2 : DEB Windowing Mode */
						for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
						break;
					case eRmapDebOpModeFullImgPatt:
						/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
					case eRmapDebOpModeWinPatt:
						/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
						for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif

						break;
					case eRmapDebOpModeStandby:
						/* DEB Operational Mode 6 : DEB Standby Mode */
						if (( pxFFeeP->xControl.xDeb.eMode == sFullImage ) || (pxFFeeP->xControl.xDeb.eMode == sWindowing)){

							pxFFeeP->xControl.bWatingSync = TRUE;
							pxFFeeP->xControl.xDeb.eState = redoutCheckDTCUpdate; /*Will stay until master sync*/
							pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;
						} else {
							for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
								bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
								pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
								bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							}
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
							}
							#endif
						}
						break;
					case eRmapDebOpModeOn:
						/* DEB Operational Mode 7 : DEB On Mode */
						/*Before sync, so it need to end the transmission/double buffer and wait for the sync*/
						if (( pxFFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxFFeeP->xControl.xDeb.eMode == sWinPattern)) {

							pxFFeeP->xControl.bWatingSync = TRUE;
							pxFFeeP->xControl.xDeb.eState = redoutCheckDTCUpdate; /*Will stay until master sync*/
							pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;

						} else {
							for ( ucIL = 0; ucIL < 4 ; ucIL++ ){
								bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
								pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
								bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							}
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
							}
							#endif
						}
						break;
					default:
						for ( ucIL = 0; ucIL < 4 ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Invalid Mode (%hhu)\n\n", ucMode);
						}
						#endif
				}
				break;

			case eRmapDebCritCfgDtcImmOnmodAddr: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxFFeeP->xControl.xDeb.eState = sOn_Enter;

				pxFFeeP->xControl.xDeb.eMode = sOn;
				pxFFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxFFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case eRmapDebGenCfgDtcInMod1Addr: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxFFeeP->xControl.xDeb.ucTxInMode[7] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[6] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[5] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[4] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case eRmapDebGenCfgDtcInMod2Addr: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxFFeeP->xControl.xDeb.ucTxInMode[3] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[2] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[1] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[0] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case eRmapDebGenCfgDtcWdwSizAddr: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcWdwIdx1Addr: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case eRmapDebGenCfgDtcWdwIdx2Addr:
			case eRmapDebGenCfgDtcWdwIdx3Addr:
			case eRmapDebGenCfgDtcWdwIdx4Addr:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcOvsPatAddr: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSizPatAddr: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcTrg25SAddr: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSelTrgAddr: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcFrmCntAddr: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				/* rfranca */
				for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
					bDpktSetFrameCounterValue(&pxFFeeP->xChannel[ucIL].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				}
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[0].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[1].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[2].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[3].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSelSynAddr: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcRspCpsAddr: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtc25SDlyAddr: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcTmodConfAddr: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSpwCfgAddr: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
					pxFFeeP->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}

				pxFFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
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
			case eRmapAebCritCfgAebControlAddr: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					/* Soft-Reset the AEB RMAP Areas (reset all registers) - [rfranca] */
					bRmapSoftRstAebMemArea(ucAebNumber);
					bRmapZeroFillAebRamMem(ucAebNumber);

					/* Set AEB to AEB_STATE_INIT  - [rfranca] */
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = eRmapAebStateInit;
					pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
				} else if ( bSetState == TRUE ) {
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case eRmapAebStateOff:
							/* AEB State : AEB_STATE_OFF */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebOffMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_OFF \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateInit:
							/* AEB State : AEB_STATE_INIT */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebInitMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_INIT \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateConfig:
							/* AEB State : AEB_STATE_CONFIG */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebConfigMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_CONFIG \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateImage:
							/* AEB State : AEB_STATE_IMAGE */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebImageMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_IMAGE \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerDown:
							/* AEB State : AEB_STATE_POWER_DOWN */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerDownMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerUp:
							/* AEB State : AEB_STATE_POWER_UP */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerUpMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePattern:
							/* AEB State : AEB_STATE_PATTERN */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPatternMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_PATTERN \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateFailure:
							/* AEB State : AEB_STATE_FAILURE */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebFailureMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							/* AEB State : Unused/Spare */
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case eRmapAebCritCfgAebConfigPatternAddr: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_CONFIG_PATTERN\n\n", ucEntity, usiADDRReg);
				}
				#endif
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu)- RMAP Reg (%hu): Cmd not implemented in this version.\n\n", ucEntity, usiADDRReg);
				}
				#endif
		}

	}
}

/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinStandBy( TFFee *pxFFeeP, unsigned int cmd ){
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
	vSendEventLogArr(pxFFeeP->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtRmapReceived]);

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case eRmapDebCritCfgDtcAebOnoffAddr: //DTC_AEB_ONOFF (ICD p. 40)

				pxFFeeP->xControl.xAeb[0].bSwitchedOn = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxFFeeP->xControl.xAeb[1].bSwitchedOn = pxFFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;
				pxFFeeP->xControl.xAeb[2].bSwitchedOn = pxFFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;
				pxFFeeP->xControl.xAeb[3].bSwitchedOn = pxFFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;

				/* Get AEBs On/Off Status - [rfranca] */
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = pxFFeeP->xControl.xAeb[0].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = pxFFeeP->xControl.xAeb[1].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = pxFFeeP->xControl.xAeb[2].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = pxFFeeP->xControl.xAeb[3].bSwitchedOn;
				break;
			case eRmapDebCritCfgDtcFeeModAddr: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case eRmapDebOpModeFullImg:
						/* DEB Operational Mode 0 : DEB Full-Image Mode */
						pxFFeeP->xControl.bWatingSync = TRUE;
						/* Real Fee State (graph) */
						pxFFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
						pxFFeeP->xControl.xDeb.eMode = sStandBy;
						pxFFeeP->xControl.xDeb.eNextMode = sFullImage_Enter;
						/* Real State */
						pxFFeeP->xControl.xDeb.eState = sStandBy;
						break;

					case eRmapDebOpModeWin:
						/* DEB Operational Mode 2 : DEB Windowing Mode */
						pxFFeeP->xControl.bWatingSync = TRUE;
						/* Real Fee State (graph) */
						pxFFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
						pxFFeeP->xControl.xDeb.eMode = sStandBy;
						pxFFeeP->xControl.xDeb.eNextMode = sWindowing_Enter;
						/* Real State */
						pxFFeeP->xControl.xDeb.eState = sStandBy;
						break;
					case eRmapDebOpModeFullImgPatt:
						/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
					case eRmapDebOpModeWinPatt:
						/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
						for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode. (Stand-By Mode)\n\n");
						}
						#endif

						break;
					case eRmapDebOpModeStandby:
						/* DEB Operational Mode 6 : DEB Standby Mode */
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Already in this mode. (Stand-By Mode)\n\n");
						}
						#endif
						break;
					case eRmapDebOpModeOn:
						/* DEB Operational Mode 7 : DEB On Mode */
						pxFFeeP->xControl.bWatingSync = FALSE;
						pxFFeeP->xControl.xDeb.eLastMode = sStandBy_Enter;
						pxFFeeP->xControl.xDeb.eMode = sOn;
						pxFFeeP->xControl.xDeb.eNextMode = sOn_Enter;

						pxFFeeP->xControl.xDeb.eState = sOn_Enter; /* Asynchronous */
						break;
					default:
						for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Invalid Mode (%hhu)\n\n", ucMode);
						}
						#endif
				}
				break;

			case eRmapDebCritCfgDtcImmOnmodAddr: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxFFeeP->xControl.xDeb.eState = sOn_Enter;

				pxFFeeP->xControl.xDeb.eMode = sOn;
				pxFFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxFFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case eRmapDebGenCfgDtcInMod1Addr: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxFFeeP->xControl.xDeb.ucTxInMode[7] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[6] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[5] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[4] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case eRmapDebGenCfgDtcInMod2Addr: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxFFeeP->xControl.xDeb.ucTxInMode[3] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[2] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[1] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[0] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case eRmapDebGenCfgDtcWdwSizAddr: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcWdwIdx1Addr: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case eRmapDebGenCfgDtcWdwIdx2Addr:
			case eRmapDebGenCfgDtcWdwIdx3Addr:
			case eRmapDebGenCfgDtcWdwIdx4Addr:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcOvsPatAddr: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSizPatAddr: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcTrg25SAddr: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSelTrgAddr: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcFrmCntAddr: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				/* rfranca */
				for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
					bDpktSetFrameCounterValue(&pxFFeeP->xChannel[ucIL].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				}
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[0].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[1].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[2].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[3].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSelSynAddr: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcRspCpsAddr: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtc25SDlyAddr: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcTmodConfAddr: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSpwCfgAddr: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
					pxFFeeP->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}

				pxFFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
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
			case eRmapAebCritCfgAebControlAddr: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					/* Soft-Reset the AEB RMAP Areas (reset all registers) - [rfranca] */
					bRmapSoftRstAebMemArea(ucAebNumber);
					bRmapZeroFillAebRamMem(ucAebNumber);

					/* Set AEB to AEB_STATE_INIT  - [rfranca] */
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = eRmapAebStateInit;
					pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
				} else if ( bSetState == TRUE ) {
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case eRmapAebStateOff:
							/* AEB State : AEB_STATE_OFF */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebOffMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_OFF \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateInit:
							/* AEB State : AEB_STATE_INIT */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebInitMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_INIT \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateConfig:
							/* AEB State : AEB_STATE_CONFIG */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebConfigMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_CONFIG \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateImage:
							/* AEB State : AEB_STATE_IMAGE */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebImageMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_IMAGE \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerDown:
							/* AEB State : AEB_STATE_POWER_DOWN */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerDownMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerUp:
							/* AEB State : AEB_STATE_POWER_UP */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerUpMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePattern:
							/* AEB State : AEB_STATE_PATTERN */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPatternMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_PATTERN \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateFailure:
							/* AEB State : AEB_STATE_FAILURE */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebFailureMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							/* AEB State : Unused/Spare */
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case eRmapAebCritCfgAebConfigPatternAddr: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_CONFIG_PATTERN\n\n", ucEntity, usiADDRReg);
				}
				#endif
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu)- RMAP Reg (%hu): Cmd not implemented in this version.\n\n", ucEntity, usiADDRReg);
				}
				#endif
		}

	}
}

/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPWaitingSync( TFFee *pxFFeeP, unsigned int cmd ){
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
	vSendEventLogArr(pxFFeeP->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtRmapReceived]);

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case eRmapDebCritCfgDtcAebOnoffAddr: //DTC_AEB_ONOFF (ICD p. 40)

				pxFFeeP->xControl.xAeb[0].bSwitchedOn = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxFFeeP->xControl.xAeb[1].bSwitchedOn = pxFFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;
				pxFFeeP->xControl.xAeb[2].bSwitchedOn = pxFFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;
				pxFFeeP->xControl.xAeb[3].bSwitchedOn = pxFFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;

				/* Get AEBs On/Off Status - [rfranca] */
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = pxFFeeP->xControl.xAeb[0].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = pxFFeeP->xControl.xAeb[1].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = pxFFeeP->xControl.xAeb[2].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = pxFFeeP->xControl.xAeb[3].bSwitchedOn;
				break;
			case eRmapDebCritCfgDtcFeeModAddr: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

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
						for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Can't perform this command, already processing a changing action.\n\n");
						}
						#endif
						break;
					default:
						for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Invalid Mode (%hhu)\n\n", ucMode);
						}
						#endif
				}
				break;

			case eRmapDebCritCfgDtcImmOnmodAddr: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxFFeeP->xControl.xDeb.eState = sOn_Enter;

				pxFFeeP->xControl.xDeb.eMode = sOn;
				pxFFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxFFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case eRmapDebGenCfgDtcInMod1Addr: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxFFeeP->xControl.xDeb.ucTxInMode[7] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[6] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[5] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[4] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case eRmapDebGenCfgDtcInMod2Addr: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxFFeeP->xControl.xDeb.ucTxInMode[3] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[2] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[1] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[0] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case eRmapDebGenCfgDtcWdwSizAddr: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcWdwIdx1Addr: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case eRmapDebGenCfgDtcWdwIdx2Addr:
			case eRmapDebGenCfgDtcWdwIdx3Addr:
			case eRmapDebGenCfgDtcWdwIdx4Addr:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcOvsPatAddr: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSizPatAddr: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcTrg25SAddr: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSelTrgAddr: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcFrmCntAddr: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				/* rfranca */
				for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
					bDpktSetFrameCounterValue(&pxFFeeP->xChannel[ucIL].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				}
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[0].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[1].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[2].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[3].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSelSynAddr: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcRspCpsAddr: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtc25SDlyAddr: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcTmodConfAddr: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSpwCfgAddr: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
					pxFFeeP->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}

				pxFFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
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
			case eRmapAebCritCfgAebControlAddr: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					/* Soft-Reset the AEB RMAP Areas (reset all registers) - [rfranca] */
					bRmapSoftRstAebMemArea(ucAebNumber);
					bRmapZeroFillAebRamMem(ucAebNumber);

					/* Set AEB to AEB_STATE_INIT  - [rfranca] */
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = eRmapAebStateInit;
					pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
				} else if ( bSetState == TRUE ) {
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case eRmapAebStateOff:
							/* AEB State : AEB_STATE_OFF */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebOffMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_OFF \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateInit:
							/* AEB State : AEB_STATE_INIT */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebInitMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_INIT \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateConfig:
							/* AEB State : AEB_STATE_CONFIG */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebConfigMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_CONFIG \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateImage:
							/* AEB State : AEB_STATE_IMAGE */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebImageMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_IMAGE \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerDown:
							/* AEB State : AEB_STATE_POWER_DOWN */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerDownMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerUp:
							/* AEB State : AEB_STATE_POWER_UP */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerUpMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePattern:
							/* AEB State : AEB_STATE_PATTERN */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPatternMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_PATTERN \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateFailure:
							/* AEB State : AEB_STATE_FAILURE */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebFailureMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							/* AEB State : Unused/Spare */
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case eRmapAebCritCfgAebConfigPatternAddr: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_CONFIG_PATTERN\n\n", ucEntity, usiADDRReg);
				}
				#endif
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu)- RMAP Reg (%hu): Cmd not implemented in this version.\n\n", ucEntity, usiADDRReg);
				}
				#endif
		}

	}

}

/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPReadoutSync( TFFee *pxFFeeP, unsigned int cmd ) {
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
	vSendEventLogArr(pxFFeeP->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtRmapReceived]);

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case eRmapDebCritCfgDtcAebOnoffAddr: //DTC_AEB_ONOFF (ICD p. 40)

				pxFFeeP->xControl.xAeb[0].bSwitchedOn = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxFFeeP->xControl.xAeb[1].bSwitchedOn = pxFFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;
				pxFFeeP->xControl.xAeb[2].bSwitchedOn = pxFFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;
				pxFFeeP->xControl.xAeb[3].bSwitchedOn = pxFFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;

				/* Get AEBs On/Off Status - [rfranca] */
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = pxFFeeP->xControl.xAeb[0].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = pxFFeeP->xControl.xAeb[1].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = pxFFeeP->xControl.xAeb[2].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = pxFFeeP->xControl.xAeb[3].bSwitchedOn;
				break;
			case eRmapDebCritCfgDtcFeeModAddr: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case eRmapDebOpModeFullImg:
						/* DEB Operational Mode 0 : DEB Full-Image Mode */
					case eRmapDebOpModeWin:
						/* DEB Operational Mode 2 : DEB Windowing Mode */
						for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
						break;
					case eRmapDebOpModeFullImgPatt:
						/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
					case eRmapDebOpModeWinPatt:
						/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
						for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif

						break;
					case eRmapDebOpModeStandby:
						/* DEB Operational Mode 6 : DEB Standby Mode */
						if (( pxFFeeP->xControl.xDeb.eMode == sFullImage ) || (pxFFeeP->xControl.xDeb.eMode == sWindowing)){
							pxFFeeP->xControl.bWatingSync = TRUE;
							pxFFeeP->xControl.xDeb.eState = redoutWaitSync; /*Will stay until master sync*/
							pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;
						} else {
							for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
								bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
								pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
								bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							}
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
							}
							#endif
						}
						break;
					case eRmapDebOpModeOn:
						/* DEB Operational Mode 7 : DEB On Mode */
						if (( pxFFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxFFeeP->xControl.xDeb.eMode == sWinPattern)) {

							pxFFeeP->xControl.bWatingSync = TRUE;
							pxFFeeP->xControl.xDeb.eState = redoutWaitSync; /*Will stay until master sync*/
							pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;

						} else {
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
							}
							#endif
						}
						break;
					default:
						for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Invalid Mode (%hhu)\n\n", ucMode);
						}
						#endif
				}
				break;

			case eRmapDebCritCfgDtcImmOnmodAddr: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxFFeeP->xControl.xDeb.eState = sOn_Enter;

				pxFFeeP->xControl.xDeb.eMode = sOn;
				pxFFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxFFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case eRmapDebGenCfgDtcInMod1Addr: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxFFeeP->xControl.xDeb.ucTxInMode[7] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[6] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[5] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[4] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case eRmapDebGenCfgDtcInMod2Addr: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxFFeeP->xControl.xDeb.ucTxInMode[3] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[2] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[1] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[0] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case eRmapDebGenCfgDtcWdwSizAddr: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcWdwIdx1Addr: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case eRmapDebGenCfgDtcWdwIdx2Addr:
			case eRmapDebGenCfgDtcWdwIdx3Addr:
			case eRmapDebGenCfgDtcWdwIdx4Addr:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcOvsPatAddr: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSizPatAddr: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcTrg25SAddr: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSelTrgAddr: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcFrmCntAddr: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				/* rfranca */
				for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
					bDpktSetFrameCounterValue(&pxFFeeP->xChannel[ucIL].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				}
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[0].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[1].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[2].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[3].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSelSynAddr: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcRspCpsAddr: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtc25SDlyAddr: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcTmodConfAddr: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSpwCfgAddr: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
					pxFFeeP->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}

				pxFFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
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
			case eRmapAebCritCfgAebControlAddr: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					/* Soft-Reset the AEB RMAP Areas (reset all registers) - [rfranca] */
					bRmapSoftRstAebMemArea(ucAebNumber);
					bRmapZeroFillAebRamMem(ucAebNumber);

					/* Set AEB to AEB_STATE_INIT  - [rfranca] */
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = eRmapAebStateInit;
					pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
				} else if ( bSetState == TRUE ) {
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case eRmapAebStateOff:
							/* AEB State : AEB_STATE_OFF */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebOffMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_OFF \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateInit:
							/* AEB State : AEB_STATE_INIT */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebInitMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_INIT \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateConfig:
							/* AEB State : AEB_STATE_CONFIG */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebConfigMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_CONFIG \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateImage:
							/* AEB State : AEB_STATE_IMAGE */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebImageMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_IMAGE \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerDown:
							/* AEB State : AEB_STATE_POWER_DOWN */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerDownMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerUp:
							/* AEB State : AEB_STATE_POWER_UP */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerUpMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePattern:
							/* AEB State : AEB_STATE_PATTERN */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPatternMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_PATTERN \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateFailure:
							/* AEB State : AEB_STATE_FAILURE */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebFailureMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							/* AEB State : Unused/Spare */
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case eRmapAebCritCfgAebConfigPatternAddr: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_CONFIG_PATTERN\n\n", ucEntity, usiADDRReg);
				}
				#endif
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu)- RMAP Reg (%hu): Cmd not implemented in this version.\n\n", ucEntity, usiADDRReg);
				}
				#endif
		}
	}
}

/* RMAP command received, while waiting for sync*/
void vQCmdFeeRMAPinReadoutTrans( TFFee *pxFFeeP, unsigned int cmd ) {
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
	vSendEventLogArr(pxFFeeP->ucId + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtRmapReceived]);

	/* ucEntity = 0 is DEB */
	if ( ucEntity == 0 ) {

		switch (usiADDRReg) {
			/*-----CRITICAL-----*/
			case eRmapDebCritCfgDtcAebOnoffAddr: //DTC_AEB_ONOFF (ICD p. 40)

				pxFFeeP->xControl.xAeb[0].bSwitchedOn = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;
				pxFFeeP->xControl.xAeb[1].bSwitchedOn = pxFFeeP->xChannel[1].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;
				pxFFeeP->xControl.xAeb[2].bSwitchedOn = pxFFeeP->xChannel[2].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;
				pxFFeeP->xControl.xAeb[3].bSwitchedOn = pxFFeeP->xChannel[3].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;

				/* Get AEBs On/Off Status - [rfranca] */
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = pxFFeeP->xControl.xAeb[0].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = pxFFeeP->xControl.xAeb[1].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = pxFFeeP->xControl.xAeb[2].bSwitchedOn;
				pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = pxFFeeP->xControl.xAeb[3].bSwitchedOn;
				break;
			case eRmapDebCritCfgDtcFeeModAddr: //DTC_FEE_MOD - default: 0x0000 0007

				ucMode = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;

				switch (ucMode) {
					case eRmapDebOpModeFullImg:
						/* DEB Operational Mode 0 : DEB Full-Image Mode */
					case eRmapDebOpModeWin:
						/* DEB Operational Mode 2 : DEB Windowing Mode */
						for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif
						break;
					case eRmapDebOpModeFullImgPatt:
						/* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
					case eRmapDebOpModeWinPatt:
						/* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
						for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
						}
						#endif

						break;
					case eRmapDebOpModeStandby:
						/* DEB Operational Mode 6 : DEB Standby Mode */
						if (( pxFFeeP->xControl.xDeb.eMode == sFullImage ) || (pxFFeeP->xControl.xDeb.eMode == sWindowing)){
							pxFFeeP->xControl.bWatingSync = TRUE;
							pxFFeeP->xControl.xDeb.eState = redoutTransmission; /*Will stay until master sync*/
							pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;

						} else {
							for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
								bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
								pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
								bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							}
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
							}
							#endif
						}
						break;
					case eRmapDebOpModeOn:
						/* DEB Operational Mode 7 : DEB On Mode */
						if (( pxFFeeP->xControl.xDeb.eMode == sFullPattern ) || (pxFFeeP->xControl.xDeb.eMode == sWinPattern)) {

							pxFFeeP->xControl.bWatingSync = TRUE;
							pxFFeeP->xControl.xDeb.eState = redoutTransmission; /*Will stay until master sync*/
							pxFFeeP->xControl.xDeb.eNextMode = pxFFeeP->xControl.xDeb.eLastMode;

						} else {
							for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
								bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
								pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
								bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							}
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"RMAP Mode op: Transition not allowed from this mode.\n\n");
							}
							#endif
						}
						break;
					default:
						for ( ucIL = 0; ucIL < N_OF_CCD ; ucIL++ ){
							bDpktGetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
							pxFFeeP->xChannel[ucIL].xDataPacket.xDpktDataPacketErrors.bInvalidCcdMode = TRUE;
							bDpktSetPacketErrors(&pxFFeeP->xChannel[ucIL].xDataPacket);
						}
						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
							fprintf(fp,"DTC_FEE_MOD: Invalid Mode (%hhu)\n\n", ucMode);
						}
						#endif
				}
				break;

			case eRmapDebCritCfgDtcImmOnmodAddr: //DTC_IMM_ONMOD - default: 0x0000 0000

				pxFFeeP->xControl.xDeb.eState = sOn_Enter;

				pxFFeeP->xControl.xDeb.eMode = sOn;
				pxFFeeP->xControl.xDeb.eLastMode = sOFF_Enter;
				pxFFeeP->xControl.xDeb.eNextMode = sOn;

				break;

			/*-----GENERAL-----*/
			case eRmapDebGenCfgDtcInMod1Addr: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxFFeeP->xControl.xDeb.ucTxInMode[7] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[6] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[5] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[4] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;
				break;

			case eRmapDebGenCfgDtcInMod2Addr: //DTC_IN_MOD - default: 0x0000 0000 (ICD p. 44)
				pxFFeeP->xControl.xDeb.ucTxInMode[3] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[2] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[1] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;
				pxFFeeP->xControl.xDeb.ucTxInMode[0] = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;
				break;

			case eRmapDebGenCfgDtcWdwSizAddr: //DTC_WDW_SIZ - default: 0x0000 0000 (ICD p. 45) - X-column and Y-row size of active windows
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_SIZ.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcWdwIdx1Addr: //DTC_WDW_IDX - default: 0x0000 0000 (ICD p. 45) - Pointers and lengths for window list
			case eRmapDebGenCfgDtcWdwIdx2Addr:
			case eRmapDebGenCfgDtcWdwIdx3Addr:
			case eRmapDebGenCfgDtcWdwIdx4Addr:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_WDW_IDX.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcOvsPatAddr: //DTC_OVS_PAT - default: 0x0000 0000 (ICD p. 45) - Number of overscan lines in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_OVS_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSizPatAddr: //DTC_SIZ_PAT - default: 0x0000 0000 (ICD p. 45) - Number of lines and pixels in PATTERN modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SIZ_PAT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcTrg25SAddr: //DTC_TRG_25S - default: 0x0000 0000 (ICD p. 45) - Generation of internal synchronization pulses
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TRG_25S.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSelTrgAddr: //DTC_SEL_TRG - default: 0x0000 0000 (ICD p. 45) - Select the source for synchronization signal
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_TRG.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcFrmCntAddr: //DTC_FRM_CNT - default: 0x0000 0000 (ICD p. 45) - Preset value of the frame counter
				/* rfranca */
				for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
					bDpktSetFrameCounterValue(&pxFFeeP->xChannel[ucIL].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				}
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[0].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[1].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[2].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				//bDpktSetFrameCounterValue(&pxFFeeP->xChannel[3].xDataPacket, pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt);
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_FRM_CNT.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSelSynAddr: //DTC_SEL_SYN - default: 0x0000 0000 (ICD p. 45) - Select main or redundant of synchronization signal
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_SEL_SYN.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcRspCpsAddr: //DTC_RSP_CPS - default: 0x0000 0000 (ICD p. 45) - Reset internal counters/pointers of DEB
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_RSP_CPS.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtc25SDlyAddr: //DTC_25S_DLY - default: 0x0000 0000 (ICD p. 45) - Delay between reception of synchronization signal and output to AEB
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_25S_DLY.\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcTmodConfAddr: //DTC_TMOD_CONF - default: 0x0000 0000 (ICD p. 45) - Test modes
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"DEB-RMAP Reg (%hu): DTC_TMOD_CONF\n\n", usiADDRReg);
				}
				#endif
				break;
			case eRmapDebGenCfgDtcSpwCfgAddr: //DTC_SPW_CFG - default: 0x0000 0000 (ICD p. 45) - SpW configuration for timecode

				ucSpwTC = pxFFeeP->xChannel[0].xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;

				for ( ucIL = 0; ucIL < N_OF_CCD; ucIL++ ) {
					pxFFeeP->xChannel[ucIL].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = FALSE;
				}

				pxFFeeP->xChannel[ucSpwTC].xSpacewire.xSpwcTimecodeConfig.bTransmissionEnable = TRUE;
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
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
			case eRmapAebCritCfgAebControlAddr: //AEB_CONTROL - default: 0x0000 0000 (ICD p. ) - mode setting

				ucNewState = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState;
				bAebReset = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset;
				bSetState = pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState;

				if ( bAebReset == TRUE ){
					/* Soft Reset */
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;

					/* Soft-Reset the AEB RMAP Areas (reset all registers) - [rfranca] */
					bRmapSoftRstAebMemArea(ucAebNumber);
					bRmapZeroFillAebRamMem(ucAebNumber);

					/* Set AEB to AEB_STATE_INIT  - [rfranca] */
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = eRmapAebStateInit;
					pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
				} else if ( bSetState == TRUE ) {
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
					pxFFeeP->xChannel[ucAebNumber].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebNumber]->xRmapAebAreaHk.xAebStatus.ucAebStatus = ucNewState;

					switch (ucNewState) {
						case eRmapAebStateOff:
							/* AEB State : AEB_STATE_OFF */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebOFF;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebOffMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_OFF \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateInit:
							/* AEB State : AEB_STATE_INIT */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebInit;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebInitMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_INIT \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateConfig:
							/* AEB State : AEB_STATE_CONFIG */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebConfig;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebConfigMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_CONFIG \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateImage:
							/* AEB State : AEB_STATE_IMAGE */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebImage;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebImageMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_IMAGE \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerDown:
							/* AEB State : AEB_STATE_POWER_DOWN */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerDownMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePowerUp:
							/* AEB State : AEB_STATE_POWER_UP */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPowerUpMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_STATE_POWER is only Intermediate state\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStatePattern:
							/* AEB State : AEB_STATE_PATTERN */
							pxFFeeP->xControl.xAeb[ucAebNumber].eState = sAebPattern;
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebPatternMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Transitioned to AEB_STATE_PATTERN \n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						case eRmapAebStateFailure:
							/* AEB State : AEB_STATE_FAILURE */
							/* Send Event Log */
							vSendEventLogArr(ucAebNumber + EVT_MEBFEE_FEE_OFS, cucEvtListData[eEvtAebFailureMode]);
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Cannot apply AEB_STATE_FAILURE, this state is not available\n\n", ucEntity, usiADDRReg);
							}
							#endif
							break;
						default:
							/* AEB State : Unused/Spare */
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
								fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): Invalid AEB STATE\n\n", ucEntity, usiADDRReg);
							}
							#endif
					}
				}

				break;

			case eRmapAebCritCfgAebConfigPatternAddr: //AEB_CONFIG_PATTERN - default: 0x0020 0020 (ICD p. 60) - AEB pattern settings (used for testing)
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu) - RMAP Reg (%hu): AEB_CONFIG_PATTERN\n\n", ucEntity, usiADDRReg);
				}
				#endif
				break;

			default:
				#if DEBUG_ON
				if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
					fprintf(fp,"AEB (%hhu)- RMAP Reg (%hu): Cmd not implemented in this version.\n\n", ucEntity, usiADDRReg);
				}
				#endif
		}
	}
}
