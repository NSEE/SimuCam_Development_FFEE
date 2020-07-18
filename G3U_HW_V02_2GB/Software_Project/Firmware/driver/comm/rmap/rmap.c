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
//static volatile int viCh5HoldContext;
//static volatile int viCh6HoldContext;
//static volatile int viCh7HoldContext;
//static volatile int viCh8HoldContext;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
void vRmapCh1HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucEntity;
	INT16U usiADDRReg;
	INT32U uliReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 0;
	const unsigned char cucIrqNumber = 0;
	const unsigned char cucChNumber = 0;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CH_1_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
			fprintf(fp,"IRQ RMAP.\n");
		}
		#endif

		uliReg = uliRmapCh1WriteCmdAddress();

		ucEntity = (INT8U) (( uliReg & 0x000F0000 ) >> 16);
		usiADDRReg = (INT16U) ( uliReg & 0x0000FFFF );

		uiCmdRmap.ucByte[3] = ucEntity;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = (INT8U)((usiADDRReg & 0xFF00) >> 8);
		uiCmdRmap.ucByte[0] = (INT8U)(usiADDRReg & 0x00FF);

#if ( 1 <= N_OF_FastFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

	/* Disable others RMAP Channels - rfranca */
	vRmapCh2EnableCodec(FALSE);
	vRmapCh3EnableCodec(FALSE);
	vRmapCh4EnableCodec(FALSE);

}

void vRmapCh2HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucEntity;
	INT16U usiADDRReg;
	INT32U uliReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 0;
	const unsigned char cucIrqNumber = 1;
	const unsigned char cucChNumber = 1;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CH_2_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
			fprintf(fp,"IRQ RMAP.\n");
		}
		#endif

		uliReg = uliRmapCh2WriteCmdAddress();

		ucEntity = (INT8U) (( uliReg & 0x000F0000 ) >> 16);
		usiADDRReg = (INT16U) ( uliReg & 0x0000FFFF );

		uiCmdRmap.ucByte[3] = ucEntity;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = (INT8U)((usiADDRReg & 0xFF00) >> 8);
		uiCmdRmap.ucByte[0] = (INT8U)(usiADDRReg & 0x00FF);

#if ( 1 <= N_OF_FastFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

	/* Disable others RMAP Channels - rfranca */
	vRmapCh1EnableCodec(FALSE);
	vRmapCh3EnableCodec(FALSE);
	vRmapCh4EnableCodec(FALSE);

}

void vRmapCh3HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucEntity;
	INT16U usiADDRReg;
	INT32U uliReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 0;
	const unsigned char cucIrqNumber = 2;
	const unsigned char cucChNumber = 2;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CH_3_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
			fprintf(fp,"IRQ RMAP.\n");
		}
		#endif

		uliReg = uliRmapCh3WriteCmdAddress();

		ucEntity = (INT8U) (( uliReg & 0x000F0000 ) >> 16);
		usiADDRReg = (INT16U) ( uliReg & 0x0000FFFF );

		uiCmdRmap.ucByte[3] = ucEntity;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = (INT8U)((usiADDRReg & 0xFF00) >> 8);
		uiCmdRmap.ucByte[0] = (INT8U)(usiADDRReg & 0x00FF);

#if ( 1 <= N_OF_FastFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

	/* Disable others RMAP Channels - rfranca */
	vRmapCh1EnableCodec(FALSE);
	vRmapCh2EnableCodec(FALSE);
	vRmapCh4EnableCodec(FALSE);

}

void vRmapCh4HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucEntity;
	INT16U usiADDRReg;
	INT32U uliReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 0;
	const unsigned char cucIrqNumber = 3;
	const unsigned char cucChNumber = 3;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CH_4_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
			fprintf(fp,"IRQ RMAP.\n");
		}
		#endif

		uliReg = uliRmapCh4WriteCmdAddress();

		ucEntity = (INT8U) (( uliReg & 0x000F0000 ) >> 16);
		usiADDRReg = (INT16U) ( uliReg & 0x0000FFFF );

		uiCmdRmap.ucByte[3] = ucEntity;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = (INT8U)((usiADDRReg & 0xFF00) >> 8);
		uiCmdRmap.ucByte[0] = (INT8U)(usiADDRReg & 0x00FF);

#if ( 1 <= N_OF_FastFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

	/* Disable others RMAP Channels - rfranca */
	vRmapCh1EnableCodec(FALSE);
	vRmapCh2EnableCodec(FALSE);
	vRmapCh3EnableCodec(FALSE);

}

void vRmapCh5HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucEntity;
	INT16U usiADDRReg;
	INT32U uliReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 1;
	const unsigned char cucIrqNumber = 4;
	const unsigned char cucChNumber = 4;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CH_5_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
			fprintf(fp,"IRQ RMAP.\n");
		}
		#endif

		uliReg = uliRmapCh5WriteCmdAddress();

		ucEntity = (INT8U) (( uliReg & 0x000F0000 ) >> 16);
		usiADDRReg = (INT16U) ( uliReg & 0x0000FFFF );

		uiCmdRmap.ucByte[3] = ucEntity;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = (INT8U)((usiADDRReg & 0xFF00) >> 8);
		uiCmdRmap.ucByte[0] = (INT8U)(usiADDRReg & 0x00FF);

#if ( 2 <= N_OF_FastFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

	/* Disable others RMAP Channels - rfranca */
	vRmapCh6EnableCodec(FALSE);
	vRmapCh7EnableCodec(FALSE);
	vRmapCh8EnableCodec(FALSE);

}

void vRmapCh6HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucEntity;
	INT16U usiADDRReg;
	INT32U uliReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 1;
	const unsigned char cucIrqNumber = 5;
	const unsigned char cucChNumber = 5;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CH_6_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
			fprintf(fp,"IRQ RMAP.\n");
		}
		#endif

		uliReg = uliRmapCh6WriteCmdAddress();

		ucEntity = (INT8U) (( uliReg & 0x000F0000 ) >> 16);
		usiADDRReg = (INT16U) ( uliReg & 0x0000FFFF );

		uiCmdRmap.ucByte[3] = ucEntity;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = (INT8U)((usiADDRReg & 0xFF00) >> 8);
		uiCmdRmap.ucByte[0] = (INT8U)(usiADDRReg & 0x00FF);

#if ( 2 <= N_OF_FastFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

	/* Disable others RMAP Channels - rfranca */
	vRmapCh5EnableCodec(FALSE);
	vRmapCh7EnableCodec(FALSE);
	vRmapCh8EnableCodec(FALSE);

}

void vRmapCh7HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucEntity;
	INT16U usiADDRReg;
	INT32U uliReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 1;
	const unsigned char cucIrqNumber = 6;
	const unsigned char cucChNumber = 6;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CH_7_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
			fprintf(fp,"IRQ RMAP.\n");
		}
		#endif

		uliReg = uliRmapCh7WriteCmdAddress();

		ucEntity = (INT8U) (( uliReg & 0x000F0000 ) >> 16);
		usiADDRReg = (INT16U) ( uliReg & 0x0000FFFF );

		uiCmdRmap.ucByte[3] = ucEntity;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = (INT8U)((usiADDRReg & 0xFF00) >> 8);
		uiCmdRmap.ucByte[0] = (INT8U)(usiADDRReg & 0x00FF);

#if ( 2 <= N_OF_FastFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

	/* Disable others RMAP Channels - rfranca */
	vRmapCh5EnableCodec(FALSE);
	vRmapCh6EnableCodec(FALSE);
	vRmapCh8EnableCodec(FALSE);

}

void vRmapCh8HandleIrq(void* pvContext) {
	tQMask uiCmdRmap;
	INT8U ucEntity;
	INT16U usiADDRReg;
	INT32U uliReg;
	INT8U error_codel;

	const unsigned char cucFeeNumber = 1;
	const unsigned char cucIrqNumber = 7;
	const unsigned char cucChNumber = 7;

	volatile TCommChannel *vpxCommChannel = (TCommChannel *)(COMM_CH_8_BASE_ADDR);

	/* RMAP Write Configuration Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteConfigFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteConfigFlagClr = TRUE;
		/* RMAP Write Configuration Area flag treatment */

		/* Warnning simplification: For now all address is lower than 1 bytes  */

		#if DEBUG_ON
		if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
			fprintf(fp,"IRQ RMAP.\n");
		}
		#endif

		uliReg = uliRmapCh8WriteCmdAddress();

		ucEntity = (INT8U) (( uliReg & 0x000F0000 ) >> 16);
		usiADDRReg = (INT16U) ( uliReg & 0x0000FFFF );

		uiCmdRmap.ucByte[3] = ucEntity;
		uiCmdRmap.ucByte[2] = M_FEE_RMAP;
		uiCmdRmap.ucByte[1] = (INT8U)((usiADDRReg & 0xFF00) >> 8);
		uiCmdRmap.ucByte[0] = (INT8U)(usiADDRReg & 0x00FF);

#if ( 2 <= N_OF_FastFEE )
		error_codel = OSQPostFront(xFeeQ[cucFeeNumber], (void *)uiCmdRmap.ulWord); /*todo: Fee number Hard Coded*/
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
#else
		fprintf(fp, "CRITICAL ERROR: FEE %u DOES NOT EXIST\n", cucFeeNumber);
#endif
	}

	/* RMAP Write Windowing Area Flag */
	if (vpxCommChannel->xRmap.xRmapIrqFlag.bWriteWindowFlag) {
		vpxCommChannel->xRmap.xRmapIrqFlagClr.bWriteWindowFlagClr = TRUE;
		/* RMAP Write Windowing Area flag treatment */
		uiCmdRmap.ucByte[3] = M_LUT_H_ADDR;
		uiCmdRmap.ucByte[2] = M_LUT_UPDATE;
		uiCmdRmap.ucByte[1] = 0;
		uiCmdRmap.ucByte[0] = xDefaultsCH.ucChannelToFEE[cucChNumber];

		error_codel = OSQPostFront(xLutQ, (void *)uiCmdRmap.ulWord);
		if ( error_codel != OS_ERR_NONE ) {
			vFailSendRMAPFromIRQ( cucIrqNumber );
		}
	}

	/* Disable others RMAP Channels - rfranca */
	vRmapCh5EnableCodec(FALSE);
	vRmapCh6EnableCodec(FALSE);
	vRmapCh7EnableCodec(FALSE);

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

alt_u32 uliRmapCh5WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh6WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh7WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_7_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

alt_u32 uliRmapCh8WriteCmdAddress(void) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_8_BASE_ADDR);
	return (vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress);
}

void vRmapCh1EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh2EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh3EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh4EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh5EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh6EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh7EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_7_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
}

void vRmapCh8EnableCodec(bool bEnable) {
	volatile TCommChannel *vpxCommChannel = (TCommChannel *) (COMM_CH_8_BASE_ADDR);
	vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
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

bool bRmapClrAebTimestamp(alt_u8 ucAebId){
	bool bStatus = FALSE;
	bool bValidAeb = FALSE;
	volatile TRmapMemAebArea *vpxRmapMemAebArea = NULL;

	switch (ucAebId) {
	case eCommFFeeAeb1Id:
		vpxRmapMemAebArea = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
		bValidAeb = TRUE;
		break;
	case eCommFFeeAeb2Id:
		vpxRmapMemAebArea = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
		bValidAeb = TRUE;
		break;
	case eCommFFeeAeb3Id:
		vpxRmapMemAebArea = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
		bValidAeb = TRUE;
		break;
	case eCommFFeeAeb4Id:
		vpxRmapMemAebArea = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
		bValidAeb = TRUE;
		break;
	default:
		bValidAeb = FALSE;
		break;
	}

	if (bValidAeb) {
		vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = 0x00000000;
		vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = 0x00000000;
		bStatus = TRUE;
	}

	return (bStatus);
}

bool bRmapIncAebTimestamp(alt_u8 ucAebId, bool bAebOn){
	bool bStatus = FALSE;
	bool bValidAeb = FALSE;
	volatile TRmapMemAebArea *vpxRmapMemAebArea = NULL;

	switch (ucAebId) {
	case eCommFFeeAeb1Id:
		vpxRmapMemAebArea = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
		bValidAeb = TRUE;
		break;
	case eCommFFeeAeb2Id:
		vpxRmapMemAebArea = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
		bValidAeb = TRUE;
		break;
	case eCommFFeeAeb3Id:
		vpxRmapMemAebArea = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
		bValidAeb = TRUE;
		break;
	case eCommFFeeAeb4Id:
		vpxRmapMemAebArea = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
		bValidAeb = TRUE;
		break;
	default:
		bValidAeb = FALSE;
		break;
	}

	if (bValidAeb) {

		if (bAebOn) {
			/* aeb is on */
			/* increment timestamp */
			if (0xFFFFFFFF == vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0) {
				/* lower dword will overflow */
				if (0xFFFFFFFF == vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1) {
					/* upper dword will overflow */
					/* clear both dwords */
					vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = 0x00000000;
					vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = 0x00000000;
				} else {
					/* upper dword will not overflow */
					/* increment upper dword and clear lower dword */
					vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1++;
					vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = 0x00000000;
				}
			} else {
				/* lower dword will not overflow */
				/* increment lower dword */
				vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0++;
			}
		} else {
			/* aeb is off */
			/* clear timestamp */
			vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = 0x00000000;
			vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = 0x00000000;
		}

		bStatus = TRUE;
	}

	return (bStatus);
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
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxRmapCh->xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[0] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[1] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[2] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			pxRmapCh->xRmapMemAreaPrt.puliRmapAebAreaPrt[3] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapDevAddr.uliRmapBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[0] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[1] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[2] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
			vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[3] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);
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
