/*
 * fee_buffers.c
 *
 *  Created on: 19/12/2018
 *      Author: rfranca
 */

#include "fee_buffers.h"

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
void vFeebCh1HandleIrq(void* pvContext) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	//volatile int* pviHoldContext = (volatile int*) pvContext;
	// Use context value according to your app logic...
	//*pviHoldContext = ...;
	// if (*pviHoldContext == '0') {}...
	// App logic sequence...

	const unsigned char cucIrqNumber = 0;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty0Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bLeftBufferEmpty0Flag\n", cucIrqNumber);

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty1Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bLeftBufferEmpty1Flag\n", cucIrqNumber);

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty0Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bRightBufferEmpty0Flag\n", cucIrqNumber);

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty1Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bRightBufferEmpty1Flag\n", cucIrqNumber);

	}

#if DEBUG_ON
		fprintf(fp, "IntF%u\n", cucIrqNumber);
#endif

}

void vFeebCh2HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;

	const unsigned char cucIrqNumber = 1;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty0Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bLeftBufferEmpty0Flag\n", cucIrqNumber);

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty1Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bLeftBufferEmpty1Flag\n", cucIrqNumber);

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty0Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bRightBufferEmpty0Flag\n", cucIrqNumber);

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty1Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bRightBufferEmpty1Flag\n", cucIrqNumber);

	}

#if DEBUG_ON
		fprintf(fp, "IntF%u\n", cucIrqNumber);
#endif

}

void vFeebCh3HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;

	const unsigned char cucIrqNumber = 2;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty0Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bLeftBufferEmpty0Flag\n", cucIrqNumber);

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty1Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bLeftBufferEmpty1Flag\n", cucIrqNumber);

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty0Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bRightBufferEmpty0Flag\n", cucIrqNumber);

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty1Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bRightBufferEmpty1Flag\n", cucIrqNumber);

	}

#if DEBUG_ON
		fprintf(fp, "IntF%u\n", cucIrqNumber);
#endif

}

void vFeebCh4HandleIrq(void* pvContext) {
	//volatile int* pviHoldContext = (volatile int*) pvContext;

	const unsigned char cucIrqNumber = 3;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);

	// Check Irq Buffer Empty Flags
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty0Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bLeftBufferEmpty0Flag\n", cucIrqNumber);

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bLeftBufferEmpty1Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bLeftBufferEmpty1Flag\n", cucIrqNumber);

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty0Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bRightBufferEmpty0Flag\n", cucIrqNumber);

	}
	if (vpxCommChannel->xFeeBuffer.xFeebIrqFlag.bRightBufferEmpty1Flag) {
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;

		printf("FEEB IRQ: Channel %u, bRightBufferEmpty1Flag\n", cucIrqNumber);

	}

#if DEBUG_ON
		fprintf(fp, "IntF%u\n", cucIrqNumber);
#endif

}

bool vFeebInitIrq(alt_u8 ucCommCh) {
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
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_1_BUFFERS_IRQ, pvHoldContext, vFeebCh1HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh2:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh2HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_2_BUFFERS_IRQ, pvHoldContext, vFeebCh2HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh3:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh3HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_3_BUFFERS_IRQ, pvHoldContext, vFeebCh3HandleIrq);
		bStatus = TRUE;
		break;
	case eCommSpwCh4:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		pvHoldContext = (void*) &viCh4HoldContext;
		vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
		// Clear all flags
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bLeftBufferEmpty1FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty0FlagClr = TRUE;
		vpxCommChannel->xFeeBuffer.xFeebIrqFlagClr.bRightBufferEmpty1FlagClr = TRUE;
		// Register the interrupt handler
		alt_irq_register(COMM_CH_4_BUFFERS_IRQ, pvHoldContext, vFeebCh4HandleIrq);
		bStatus = TRUE;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return bStatus;
}

bool bFeebSetIrqControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebIrqControl = pxFeebCh->xFeebIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetIrqControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebIrqControl = vpxCommChannel->xFeeBuffer.xFeebIrqControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetIrqFlags(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebIrqFlag = vpxCommChannel->xFeeBuffer.xFeebIrqFlag;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetBuffersStatus(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebBufferStatus = vpxCommChannel->xFeeBuffer.xFeebBufferStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetLeftBufferEmpty(TFeebChannel *pxFeebCh) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;

	}

	return bFlag;
}

bool bFeebGetRightBufferEmpty(TFeebChannel *pxFeebCh) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;

	}

	return bFlag;
}

bool bFeebGetCh1LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh1RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh2LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh2RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh3LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh3RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh4LeftBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftBufferEmpty;
	return bFlag;
}

bool bFeebGetCh4RightBufferEmpty(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightBufferEmpty;
	return bFlag;
}

bool bFeebGetCh1LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh1RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh2LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh2RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh3LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh3RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetCh4LeftFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bLeftFeeBusy;
	return bFlag;
}

bool bFeebGetCh4RightFeeBusy(void) {
	bool bFlag = FALSE;
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
	bFlag = vpxCommChannel->xFeeBuffer.xFeebBufferStatus.bRightFeeBusy;
	return bFlag;
}

bool bFeebGetBufferDataControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebBufferDataControl = vpxCommChannel->xFeeBuffer.xFeebBufferDataControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebSetBufferDataControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebBufferDataControl = pxFeebCh->xFeebBufferDataControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetBufferDataStatus(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebBufferDataStatus = vpxCommChannel->xFeeBuffer.xFeebBufferDataStatus;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetMachineControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebMachineControl = vpxCommChannel->xFeeBuffer.xFeebMachineControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebSetMachineControl(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl = pxFeebCh->xFeebMachineControl;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebClearMachineStatistics(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl.bClear = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebGetMachineStatistics(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		pxFeebCh->xFeebMachineStatistics = vpxCommChannel->xFeeBuffer.xFeebMachineStatistics;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebStartCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl.bStart = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebStopCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl.bStop = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebClrCh(TFeebChannel *pxFeebCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxFeebCh->xFeebDevAddr.uliFeebBaseAddr);

		vpxCommChannel->xFeeBuffer.xFeebMachineControl.bClear = TRUE;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bFeebInitCh(TFeebChannel *pxFeebCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxFeebCh != NULL) {

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxFeebCh->xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel->xFeeBuffer.xFeebDevAddr.uliFeebBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bFeebGetIrqControl(pxFeebCh)) {
				bInitFail = TRUE;
			}
			if (!bFeebGetIrqFlags(pxFeebCh)) {
				bInitFail = TRUE;
			}
			if (!bFeebGetBuffersStatus(pxFeebCh)) {
				bInitFail = TRUE;
			}
			if (!bFeebGetBufferDataControl(pxFeebCh)) {
				bInitFail = TRUE;
			}
			if (!bFeebGetMachineControl(pxFeebCh)) {
				bInitFail = TRUE;
			}
			if (!bFeebGetMachineStatistics(pxFeebCh)) {
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
//! [private functions]
