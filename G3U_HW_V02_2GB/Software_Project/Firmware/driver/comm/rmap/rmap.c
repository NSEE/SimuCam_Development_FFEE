/*
 * rmap.c
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#include "rmap.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
// A variable to hold the context of interrupt
static volatile int viCh1HoldContext;
static volatile int viCh2HoldContext;
static volatile int viCh3HoldContext;
static volatile int viCh4HoldContext;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
/* todo:Trigger not working right */
void vRmapCh1HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) uliRmapCh1WriteCmdAddress();

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 0;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[0];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif

		error_codel = OSQPostFront(xFeeQ[0], (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(0);
		}

	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[0];

		error_codel = OSQPostFront(xLutQ, (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(0);
		}
	}

}

void vRmapCh2HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) uliRmapCh2WriteCmdAddress();

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 1;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[1];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif

		error_codel = OSQPostFront(xFeeQ[1], (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(1);
		}

	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[1];

		error_codel = OSQPostFront(xLutQ, (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(1);
		}
	}

}

void vRmapCh3HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) uliRmapCh3WriteCmdAddress();

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 2;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[2];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif

		error_codel = OSQPostFront(xFeeQ[2], (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(2);
		}

	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[2];

		error_codel = OSQPostFront(xLutQ, (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(2);
		}
	}

}

void vRmapCh4HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucADDRReg;
	INT8U error_codel;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IRQ RMAP.\n");
		}
#endif

		ucADDRReg = (unsigned char) uliRmapCh4WriteCmdAddress();

		uiCmdRmap.ucByte[3] = M_NFEE_BASE_ADDR + 3;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = ucADDRReg;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[3];

#if DEBUG_ON
		if (xDefaults.usiDebugLevel <= dlMinorMessage) {
			fprintf(fp, "IucADDRReg: %u\n", ucADDRReg);
		}
#endif

		error_codel = OSQPostFront(xFeeQ[3], (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(3);
		}

	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[3];

		error_codel = OSQPostFront(xLutQ, (void *) uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if (error_codel != OS_ERR_NONE) {
			vFailSendRMAPFromIRQ(3);
		}
	}

}

alt_u32 uliRmapCh1WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh2WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh3WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh4WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

bool vRmapInitIrq(alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	void* pvHoldContext;
	volatile TCommChannel *vpxCommChannel;
	switch (ucCommCh) {
	case eCommSpwCh1:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh1HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_1_RMAP_IRQ, pvHoldContext, vRmapCh1HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_2_RMAP_IRQ, pvHoldContext, vRmapCh2HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_3_RMAP_IRQ, pvHoldContext, vRmapCh3HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_4_RMAP_IRQ, pvHoldContext, vRmapCh4HandleIrq);
		bStatus = TRUE;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return bStatus;
}

bool bRmapSetIrqControl(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapIrqControl = pxRmapCh->xRmapIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetIrqControl(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapIrqControl = vpxCommChannel->xRmap.xRmapIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetIrqFlags(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapIrqFlag = vpxCommChannel->xRmap.xRmapIrqFlag;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetEchoingMode(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapEchoingModeConfig = pxRmapCh->xRmapEchoingModeConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetEchoingMode(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapEchoingModeConfig = vpxCommChannel->xRmap.xRmapEchoingModeConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapCodecConfig = pxRmapCh->xRmapCodecConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecConfig = vpxCommChannel->xRmap.xRmapCodecConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecStatus(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecStatus = vpxCommChannel->xRmap.xRmapCodecStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapGetCodecError(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapCodecError = vpxCommChannel->xRmap.xRmapCodecError;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetMemConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		vpxCommChannel->xRmap.xRmapMemConfig = pxRmapCh->xRmapMemConfig;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetMemConfig(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapMemConfig = vpxCommChannel->xRmap.xRmapMemConfig;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bRmapGetMemStatus(TRmapChannel *pxRmapCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

		pxRmapCh->xRmapMemStatus = vpxCommChannel->xRmap.xRmapMemStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bRmapSetRmapMemCfgArea(TRmapChannel *pxRmapCh) {
	bool bStatus = TRUE;
	/*
	 bool bStatus = FALSE;
	 volatile TCommChannel *vpxCommChannel;

	 if (pxRmapCh != NULL) {

	 vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

	 vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig = pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig;

	 bStatus = TRUE;
	 }
	 */

	return bStatus;
}

bool bRmapGetRmapMemCfgArea(TRmapChannel *pxRmapCh) {
	bool bStatus = TRUE;
	/*
	 bool bStatus = FALSE;
	 volatile TCommChannel *vpxCommChannel;

	 if (pxRmapCh != NULL) {

	 vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

	 pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig = vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaConfig;

	 bStatus = TRUE;
	 }
	 */

	return bStatus;
}

bool bRmapSetRmapMemHkArea(TRmapChannel *pxRmapCh) {
	bool bStatus = TRUE;
	/*
	 bool bStatus = FALSE;
	 volatile TCommChannel *vpxCommChannel;

	 if (pxRmapCh != NULL) {

	 vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

	 vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk = pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk;

	 bStatus = TRUE;
	 }
	 */

	return bStatus;

}

bool bRmapGetRmapMemHkArea(TRmapChannel *pxRmapCh) {
	bool bStatus = TRUE;
	/*
	 bool bStatus = FALSE;
	 volatile TCommChannel *vpxCommChannel;

	 if (pxRmapCh != NULL) {

	 vpxCommChannel = (TCommChannel *)(pxRmapCh->xRmapDevAddr.uliRmapBaseAddr);

	 pxRmapCh->xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk = vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAreaPrt->xRmapMemAreaHk;

	 bStatus = TRUE;
	 }
	 */

	return bStatus;
}

bool bRmapInitCh(TRmapChannel *pxRmapCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxRmapCh != NULL) {

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb1AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb2AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb3AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb4AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb1AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb2AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb3AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb4AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb1AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb2AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb3AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb4AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb1AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb2AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb3AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb4AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb1AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb2AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb3AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb4AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb1AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb2AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb3AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb4AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb1AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb2AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb3AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAeb4AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb1AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb2AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb3AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAeb4AreaPrt = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bRmapGetIrqControl(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetCodecConfig(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetCodecStatus(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetMemConfig(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetMemStatus(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetRmapMemCfgArea(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetRmapMemHkArea(pxRmapCh)) {
				bInitFail = TRUE;
			}
			if (!bRmapGetEchoingMode(pxRmapCh)) {
				bInitFail = TRUE;
			}

			if (!bInitFail) {
				bStatus = TRUE;
			}
		}
	}
	return bStatus;
}
//! [public functions]

//! [private functions]
alt_u32 uliRmapReadReg(alt_u32 *puliAddr, alt_u32 uliOffset) {
	volatile alt_u32 uliValue;

	uliValue = *(puliAddr + uliOffset);
	return uliValue;
}

//! [private functions]
