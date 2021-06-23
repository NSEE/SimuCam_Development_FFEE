/*
 * ftdi.c
 *
 *  Created on: 5 de set de 2019
 *      Author: rfranca
 */

#include "ftdi.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
// A variable to hold the context of interrupt
static volatile int viRxBuffHoldContext;
static volatile int viTxBuffHoldContext;

static volatile TPatchRcptConfig xDdrPatchRcptConfig[FTDI_IMGT_MEMORY_QTD];
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]

void vFtdiRxIrqHandler(void* pvContext) {
	INT8U error_codel;
	tQMask uiCmdtoSend;
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* viRxBuffHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*viRxBuffHoldContext = ...;
	// if (*viRxBuffHoldContext == '0') {}...
	// App logic sequence...

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

//#if DEBUG_ON
//if ( xDefaults.usiDebugLevel <= dlCriticalOnly ) {
//	fprintf(fp,"--FTDI Irq--\n");
//}
//#endif

	/* Rx Half-CCD Received Flag */
	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxHccdReceivedIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxHccdReceivedIrqFlagClr = TRUE;

		/* Rx Buffer Last Empty flag treatment */
		uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
		uiCmdtoSend.ucByte[2] = M_DATA_FTDI_BUFFER_EMPTY;
		uiCmdtoSend.ucByte[1] = 0;
		uiCmdtoSend.ucByte[0] = 0;

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailSendBufferEmptyIRQtoDTC();
		}
		/*
		 #if DEBUG_ON
		 if ( xDefaults.usiDebugLevel <= dlMajorMessage ) {
		 fprintf(fp,"FTDI Irq Empty 0\n");
		 }
		 #endif
		 */

	}

	/* Rx Half-CCD Communication Error Flag */
	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxHccdCommErrIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxHccdCommErrIrqFlagClr = TRUE;

		/* Rx Communication Error flag treatment */
		uiCmdtoSend.ucByte[3] = M_DATA_CTRL_ADDR;
		uiCmdtoSend.ucByte[2] = M_DATA_FTDI_ERROR;
		uiCmdtoSend.ucByte[1] = 0;
		uiCmdtoSend.ucByte[0] = ucFtdiGetRxErrorCode();

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xQMaskDataCtrl, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailFtdiErrorIRQtoDTC();
		}

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMajorMessage) {
			fprintf(fp, "FTDI Rx Irq Err \n");
//			fprintf(fp, "FTDI Rx Irq Err : Payload CRC %d\n", vpxFtdiModule->xFtdiRxCommError.bHalfCcdReplyPayCrcErr);
//			fprintf(fp, "FTDI Rx Irq Err : Payload EOP %d\n", vpxFtdiModule->xFtdiRxCommError.bHalfCcdReplyPayEopErr);
//			fprintf(fp, "FTDI Rx Irq Err Header : Received %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.bHalfCcdReceived);
//			fprintf(fp, "FTDI Rx Irq Err Header : FEE Number %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.ucHalfCcdFeeNumber);
//			fprintf(fp, "FTDI Rx Irq Err Header : CCD Number %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.ucHalfCcdCcdNumber);
//			fprintf(fp, "FTDI Rx Irq Err Header : CCD Side %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.ucHalfCcdCcdSide);
//			fprintf(fp, "FTDI Rx Irq Err Header : CCD Height %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.usiHalfCcdCcdHeight);
//			fprintf(fp, "FTDI Rx Irq Err Header : CCD Width %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.usiHalfCcdCcdWidth);
//			fprintf(fp, "FTDI Rx Irq Err Header : Exposure Number %u\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.usiHalfCcdExpNumber);
//			fprintf(fp, "FTDI Rx Irq Err Header : Image Length Bytes %lu\n", vpxFtdiModule->xFtdiHalfCcdReplyStatus.uliHalfCcdImgLengthBytes);
		}
#endif

	}

	/* Rx Patch Reception Error Flag */
	if (vpxFtdiModule->xFtdiRxIrqFlag.bRxPatchRcptErrIrqFlag) {
		vpxFtdiModule->xFtdiRxIrqFlagClr.bRxPatchRcptErrIrqFlagClr = TRUE;
	}

}

void vFtdiTxIrqHandler(void* pvContext) {
	INT8U error_codel;
	tQMask uiCmdtoSend;
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* viTxBuffHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*viTxBuffHoldContext = ...;
	// if (*viTxBuffHoldContext == '0') {}...
	// App logic sequence...

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	/* Tx Finished Transmission Flag */
	if (vpxFtdiModule->xFtdiTxIrqFlag.bTxLutFinishedIrqFlag) {
		vpxFtdiModule->xFtdiTxIrqFlagClr.bTxLutFinishedIrqFlagClr = TRUE;
		/* Tx Finished Transmission flag treatment */
		uiCmdtoSend.ucByte[3] = M_LUT_H_ADDR;
		uiCmdtoSend.ucByte[2] = M_LUT_FTDI_BUFFER_FINISH;
		uiCmdtoSend.ucByte[1] = 0;
		uiCmdtoSend.ucByte[0] = 0;

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xLutQ, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailSendBufferLastIRQtoLUT();
		}
	}

	/* Tx Communication Error Flag */
	if (vpxFtdiModule->xFtdiTxIrqFlag.bTxLutCommErrIrqFlag) {
		vpxFtdiModule->xFtdiTxIrqFlagClr.bTxLutCommErrIrqFlagClr = TRUE;
		/* Tx Communication Error flag treatment */
		uiCmdtoSend.ucByte[3] = M_LUT_H_ADDR;
		uiCmdtoSend.ucByte[2] = M_LUT_FTDI_ERROR;
		uiCmdtoSend.ucByte[1] = 0;
		uiCmdtoSend.ucByte[0] = ucFtdiGetRxErrorCode();

		/*Sync the Meb task and tell that has a PUS command waiting*/
		error_codel = OSQPost(xLutQ, (void *) uiCmdtoSend.ulWord);
		if (error_codel != OS_ERR_NONE) {
			vFailFtdiErrorIRQtoLUT();
		}

#if DEBUG_ON
		if (xDefaults.ucDebugLevel <= dlMajorMessage) {
			fprintf(fp, "FTDI Tx Irq Err \n");
//			fprintf(fp, "FTDI Tx Irq Err : Payload NACK %d\n", vpxFtdiModule->xFtdiTxCommError.bLutPayloadNackErr);
		}
#endif

	}

}

bool bFtdiRxIrqInit(void) {
	bool bStatus = FALSE;
	void* pvHoldContext;
	// Recast the hold_context pointer to match the alt_irq_register() function
	// prototype.
	pvHoldContext = (void*) &viRxBuffHoldContext;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	// Clear all flags
	vpxFtdiModule->xFtdiRxIrqFlagClr.bRxHccdReceivedIrqFlagClr = TRUE;
	vpxFtdiModule->xFtdiRxIrqFlagClr.bRxHccdCommErrIrqFlagClr = TRUE;
	vpxFtdiModule->xFtdiRxIrqFlagClr.bRxPatchRcptErrIrqFlagClr = TRUE;
	// Register the interrupt handler
	if (0 == alt_irq_register(FTDI_RX_BUFFER_IRQ, pvHoldContext, vFtdiRxIrqHandler)) {
		bStatus = TRUE;
	}
	return bStatus;
}

bool bFtdiTxIrqInit(void) {
	bool bStatus = FALSE;
	void* pvHoldContext;
	// Recast the hold_context pointer to match the alt_irq_register() function
	// prototype.
	pvHoldContext = (void*) &viTxBuffHoldContext;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	// Clear all flags
	vpxFtdiModule->xFtdiTxIrqFlagClr.bTxLutFinishedIrqFlagClr = TRUE;
	vpxFtdiModule->xFtdiTxIrqFlagClr.bTxLutCommErrIrqFlagClr = TRUE;
	// Register the interrupt handler
	if (0 == alt_irq_register(FTDI_TX_BUFFER_IRQ, pvHoldContext, vFtdiTxIrqHandler)) {
		bStatus = TRUE;
	}
	return bStatus;
}

bool bFtdiRequestHalfCcdImg(alt_u8 ucFee, alt_u8 ucCcdNumber, alt_u8 ucCcdSide, alt_u16 usiExposureNum, alt_u16 usiCcdHalfWidth, alt_u16 usiCcdHeight, alt_u32 uliPayloadLengthInBytes) {
	bool bStatus = FALSE;

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	bool bPayloadLengthFlag = FALSE;

	if ((FTDI_TRANSFER_MIN_BYTES <= uliPayloadLengthInBytes) && (FTDI_TRANSFER_MAX_BYTES >= uliPayloadLengthInBytes)) {
		bPayloadLengthFlag = TRUE;
		/* Rounding up the size to the nearest multiple of FTDI_DATA_ACCESS_WIDTH_BYTES (FTDI_DATA_ACCESS_WIDTH_BYTES = 32 bytes = 256b = size of memory access) */
		if (uliPayloadLengthInBytes % FTDI_DATA_ACCESS_WIDTH_BYTES) {
			/* Transfer size is not a multiple of DSCH_DATA_ACCESS_WIDTH_BYTES */
			vpxFtdiModule->xFtdiPayloadConfig.uliRxPayRdForceLenBytes = (alt_u32) ((uliPayloadLengthInBytes & FTDI_DATA_TRANSFER_SIZE_MASK ) + FTDI_DATA_ACCESS_WIDTH_BYTES );
		} else {
			vpxFtdiModule->xFtdiPayloadConfig.uliRxPayRdForceLenBytes = uliPayloadLengthInBytes;
		}
	}
	if ((ucFee < 6) && (ucCcdNumber < 4) && (ucCcdSide < 2) && (usiCcdHalfWidth <= FTDI_MAX_HCCD_IMG_WIDTH) && (usiCcdHeight <= FTDI_MAX_HCCD_IMG_HEIGHT) && (bPayloadLengthFlag)) {
		vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdFeeNumber = ucFee;
		vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdCcdNumber = ucCcdNumber;
		vpxFtdiModule->xFtdiHalfCcdReqControl.ucHalfCcdCcdSide = ucCcdSide;
		vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdExpNumber = usiExposureNum;
		vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdCcdWidth = usiCcdHalfWidth;
		vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdCcdHeight = usiCcdHeight;
		vpxFtdiModule->xFtdiHalfCcdReqControl.usiHalfCcdReqTimeout = FTDI_HALFCCD_REQ_TIMEOUT;
//        if (0 == usiEP) {
//        	vpxFtdiModule->xFtdiPayloadDelay.usiRxPayRdQqwordDly = 0;
//        } else {
//        	vpxFtdiModule->xFtdiPayloadDelay.usiRxPayRdQqwordDly = 27;
//        }
        vpxFtdiModule->xFtdiPayloadConfig.usiRxPayRdQqwordDly = 0;
		vpxFtdiModule->xFtdiHalfCcdReqControl.bRequestHalfCcd = TRUE;
		bStatus = TRUE;
	}
	return bStatus;
}

bool bFtdiTransmitLutWinArea(alt_u8 ucFee, alt_u16 usiCcdHalfWidth, alt_u16 usiCcdHeight, alt_u32 uliLutLengthBytes) {
	bool bStatus = FALSE;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	if ((ucFee < 6) && (usiCcdHalfWidth <= FTDI_MAX_HCCD_IMG_WIDTH) && (usiCcdHeight <= FTDI_MAX_HCCD_IMG_HEIGHT) && (uliLutLengthBytes <= FTDI_WIN_AREA_PAYLOAD_SIZE)) {
		vpxFtdiModule->xFtdiLutTransControl.ucLutFeeNumber = ucFee;
		vpxFtdiModule->xFtdiLutTransControl.ucLutCcdNumber = 0;
		vpxFtdiModule->xFtdiLutTransControl.ucLutCcdSide = 0;
		vpxFtdiModule->xFtdiLutTransControl.usiLutExpNumber = 0;
		vpxFtdiModule->xFtdiLutTransControl.usiLutCcdWidth = usiCcdHalfWidth;
		vpxFtdiModule->xFtdiLutTransControl.usiLutCcdHeight = usiCcdHeight;
		vpxFtdiModule->xFtdiLutTransControl.usiLutTransTimeout = FTDI_LUT_TRANS_TIMEOUT;
		vpxFtdiModule->xFtdiLutTransControl.uliLutLengthBytes = FTDI_WIN_AREA_WINDOING_SIZE + uliLutLengthBytes;
		vpxFtdiModule->xFtdiPayloadConfig.usiTxPayWrQqwordDly = 0;
		vpxFtdiModule->xFtdiLutTransControl.bInvert16bWords = TRUE;
		vpxFtdiModule->xFtdiLutTransControl.bTransmitLut = TRUE;
		bStatus = TRUE;
	}
	return bStatus;
}

void vFtdiResetHalfCcdImg(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiHalfCcdReqControl.bRstHalfCcdController = TRUE;
}

void vFtdiResetLutWinArea(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiLutTransControl.bRstLutController = TRUE;
}

alt_u8 ucFtdiGetRxErrorCode(void) {
	alt_u8 ucErrorCode = 0;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	ucErrorCode = (alt_u8) (vpxFtdiModule->xFtdiRxCommError.usiRxCommErrCode);
	return ucErrorCode;
}

alt_u8 ucFtdiGetTxErrorCode(void) {
	alt_u8 ucErrorCode = 0;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	ucErrorCode = (alt_u8) (vpxFtdiModule->xFtdiTxCommError.usiTxLutCommErrCode);
	return ucErrorCode;
}

alt_u16 usiFtdiRxBufferUsedBytes(void) {
	alt_u32 usiBufferUsedBytes = 0;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	usiBufferUsedBytes = vpxFtdiModule->xFtdiRxBufferStatus.usiRxBuffUsedBytes;
	return usiBufferUsedBytes;
}

alt_u16 usiFtdiTxBufferUsedBytes(void) {
	alt_u32 usiBufferUsedBytes = 0;
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	usiBufferUsedBytes = vpxFtdiModule->xFtdiTxBufferStatus.usiTxBuffUsedBytes;
	return usiBufferUsedBytes;
}

void vFtdiStopModule(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiFtdiModuleControl.bModuleStop = TRUE;
}

void vFtdiStartModule(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiFtdiModuleControl.bModuleStart = TRUE;
}

void vFtdiClearModule(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiFtdiModuleControl.bModuleClear = TRUE;
}

void vFtdiAbortOperation(void) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiHalfCcdReqControl.bAbortHalfCcdReq = TRUE;
	vpxFtdiModule->xFtdiLutTransControl.bAbortLutTrans = TRUE;
}

void vFtdiIrqGlobalEn(bool bEnable) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiFtdiIrqControl.bFtdiGlobalIrqEn = bEnable;
}

void vFtdiIrqRxHccdReceivedEn(bool bEnable) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiRxIrqControl.bRxHccdReceivedIrqEn = bEnable;
}

void vFtdiIrqRxHccdCommErrEn(bool bEnable) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiRxIrqControl.bRxHccdCommErrIrqEn = bEnable;
}

void vFtdiIrqRxPatchRcptErrEn(bool bEnable) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiRxIrqControl.bRxPatchRcptErrIrqEn = bEnable;
}

void vFtdiIrqTxLutFinishedEn(bool bEnable) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiTxIrqControl.bTxLutFinishedIrqEn = bEnable;
}

void vFtdiIrqTxLutCommErrEn(bool bEnable) {
	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;
	vpxFtdiModule->xFtdiTxIrqControl.bTxLutCommErrIrqEn = bEnable;
}

/*
 * Imagettes functions prototypes:
 */

/* Enable/Disable the Imagettes machine. */
void vFtdiEnableImagettes(bool bEnable){

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	vpxFtdiModule->xPatchRcptControl.bInvPixelsByteOrder = FALSE;
	vpxFtdiModule->xPatchRcptControl.usiTimeout = FTDI_IMGT_RCPT_TIMEOUT;
	vpxFtdiModule->xPatchRcptControl.uliDataDelay = uliPxDelayCalcPeriodMs(xDefaults.ulStartDelay);
	vpxFtdiModule->xPatchRcptControl.bEnable = bEnable;

}

/* Abort any Imagette receival and clear the Imagettes machine. */
void vFtdiAbortImagettes(void){

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	vpxFtdiModule->xPatchRcptControl.bDiscard = TRUE;

}

/* Set Half-CCD parameters. Need to be called onde in the initialization. */
bool bFtdiSetImagettesParams(alt_u8 ucFee, alt_u8 ucCcdNumber, alt_u8 ucCcdSide, alt_u16 usiCcdHalfWidth, alt_u16 usiCcdHeight, alt_u32 *uliDdrInitialAddr){
	bool bStatus = FALSE;

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	union Ddr2MemoryAddress unDdrImagetteBaseAddr[2];

	if ((ucFee < FTDI_IMGT_FEE_QTD) && (ucCcdNumber < FTDI_IMGT_CCD_QTD) && (ucCcdSide < FTDI_IMGT_SIDE_QTD)
			 && (usiCcdHalfWidth <= FTDI_MAX_HCCD_IMG_WIDTH)  && (usiCcdHeight <= FTDI_MAX_HCCD_IMG_HEIGHT)
			 && ((alt_u32)uliDdrInitialAddr < DDR2_M1_MEMORY_SIZE)) {

		#if DEBUG_ON
		if ( xDefaults.ucDebugLevel <= dlMinorMessage ) {
			fprintf(fp, "Set Imagette Param: ucFee = %u; ucCcdNumber = %u; ucCcdSide = %u; usiCcdHalfWidth = %u; usiCcdHeight = %u; uliDdrInitialAddr = 0x%08lX \n",
					ucFee, ucCcdNumber, ucCcdSide, usiCcdHalfWidth, usiCcdHeight, (alt_u32)uliDdrInitialAddr);
		}
		#endif

		vpxFtdiModule->xPatchRcptConfig.usiFeesCcdsHalfwidthPixels = usiCcdHalfWidth;
		vpxFtdiModule->xPatchRcptConfig.usiFeesCcdsHeightPixels = usiCcdHeight;

		xDdrPatchRcptConfig[eDdr2Memory1].usiFeesCcdsHalfwidthPixels = usiCcdHalfWidth;
		xDdrPatchRcptConfig[eDdr2Memory1].usiFeesCcdsHeightPixels = usiCcdHeight;

		xDdrPatchRcptConfig[eDdr2Memory2].usiFeesCcdsHalfwidthPixels = usiCcdHalfWidth;
		xDdrPatchRcptConfig[eDdr2Memory2].usiFeesCcdsHeightPixels = usiCcdHeight;

		unDdrImagetteBaseAddr[eDdr2Memory1].ulliMemAddr64b = DDR2_M1_BASE_ADDR + (alt_u64) ((alt_u32) uliDdrInitialAddr);
		unDdrImagetteBaseAddr[eDdr2Memory2].ulliMemAddr64b = DDR2_M2_BASE_ADDR + (alt_u64) ((alt_u32) uliDdrInitialAddr);

		switch (ucFee) {
			case 0: /* FEE 0 */
				switch (ucCcdNumber) {
					case 0: /* CCD 0 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 1: /* CCD 1 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 2: /* CCD 2 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 3: /* CCD 3 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee0Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee0Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee0Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					default:
						break;
				}
				break;
			case 1: /* FEE 1 */
				switch (ucCcdNumber) {
					case 0: /* CCD 0 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 1: /* CCD 1 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 2: /* CCD 2 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 3: /* CCD 3 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee1Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee1Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee1Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					default:
						break;
				}
				break;
			case 2: /* FEE 2 */
				switch (ucCcdNumber) {
					case 0: /* CCD 0 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 1: /* CCD 1 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 2: /* CCD 2 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 3: /* CCD 3 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee2Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee2Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee2Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					default:
						break;
				}
				break;
			case 3: /* FEE 3 */
				switch (ucCcdNumber) {
					case 0: /* CCD 0 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 1: /* CCD 1 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 2: /* CCD 2 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 3: /* CCD 3 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee3Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee3Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee3Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					default:
						break;
				}
				break;
			case 4: /* FEE 4 */
				switch (ucCcdNumber) {
					case 0: /* CCD 0 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 1: /* CCD 1 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 2: /* CCD 2 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 3: /* CCD 3 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee4Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee4Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee4Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					default:
						break;
				}
				break;
			case 5: /* FEE 5 */
				switch (ucCcdNumber) {
					case 0: /* CCD 0 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd0LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd0LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd0RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd0RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 1: /* CCD 1 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd1LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd1LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd1RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd1RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 2: /* CCD 2 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd2LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd2LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd2RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd2RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					case 3: /* CCD 3 */
						switch (ucCcdSide) {
							case eCcdSideELeft: /* Left CCD Side = 0 */
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd3LeftInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd3LeftInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							case eCcdSideFRight: /* Right CCD Side = 1 */
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								vpxFtdiModule->xPatchRcptConfig.uliFee5Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory1].uliFee5Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory1].uliMemAddr32b[0];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd3RightInitAddrHighDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[1];
								xDdrPatchRcptConfig[eDdr2Memory2].uliFee5Ccd3RightInitAddrLowDword = unDdrImagetteBaseAddr[eDdr2Memory2].uliMemAddr32b[0];
								break;
							default:
								break;
						}
						break;
					default:
						break;
				}
				break;
			default:
				break;
		}

		bStatus = TRUE;

	}

	return (bStatus);
}

/* Swap the memory to be patched with Imagettes. Need to be called every memory swap. */
bool bFtdiSwapImagettesMem(alt_u8 ucDdrMemId){
	bool bStatus = FALSE;

	volatile TFtdiModule *vpxFtdiModule = (TFtdiModule *) FTDI_MODULE_BASE_ADDR;

	if (ucDdrMemId < FTDI_IMGT_MEMORY_QTD) {

		vpxFtdiModule->xPatchRcptConfig  = xDdrPatchRcptConfig[ucDdrMemId];

		#if DEBUG_ON
		if ( xDefaults.ucDebugLevel <= dlMinorMessage ) {
			fprintf(fp, "Swap Imagette Memory: ucDdrMemId = %u \n", ucDdrMemId);
		}
		#endif

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bDumpImagettesfromMem(alt_u8 ucFee, alt_u8 ucCcdNumber, alt_u8 ucCcdSide, alt_u16 usiCcdHalfWidth, alt_u16 usiCcdHeight, alt_u8 ucDdrMemId, alt_u32 uliDdrInitialAddr) {
	bool bStatus = FALSE;

	alt_u32 uliRowCnt = 0;
	alt_u32 uliColCnt = 0;
	alt_u32 uliPixCnt = 0;

	alt_u32 uliBaseAddr = 0;

	alt_u32 uliPixOffset = 0;

	alt_u16 *pusiPixAddr = 0;
	alt_u16 usiPixData = 0xFFFF;

	bStatus = bDdr2SwitchMemory(ucDdrMemId);

	if (bStatus) {

		fprintf(fp, "Imagettes Dump for FEE %u, CCD %u, Side %u:\n", ucFee, ucCcdNumber, ucCcdSide);

		uliBaseAddr = uliDdrInitialAddr;
		for (uliRowCnt = 0; uliRowCnt < usiCcdHeight; uliRowCnt++) {
			for (uliColCnt = 0; uliColCnt < usiCcdHalfWidth; uliColCnt++) {

				uliPixCnt = uliRowCnt * usiCcdHalfWidth + uliColCnt;

				uliPixOffset = (alt_u32)((uliPixCnt +  ((alt_u32)(uliPixCnt/64) * 4)) * 2);

				pusiPixAddr = (alt_u16 *)(uliBaseAddr + uliPixOffset);

				usiPixData = *pusiPixAddr;

				if (0x0000 != usiPixData) {
					fprintf(fp, "  Offset = 0x%08lX; Pixel = %lu; Row = %lu; Column = %lu; Side = %u; Data = 0x%04X \n", (alt_u32)uliPixOffset, uliPixCnt, uliRowCnt, uliColCnt, ucCcdSide, usiPixData);
				}

			}
		}

	}

	return (bStatus);
}

//! [public functions]

//! [private functions]
//! [private functions]
