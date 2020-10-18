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

bool bRmapChEnableCodec(alt_u8 ucCommCh, bool bEnable){
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile TCommChannel *vpxCommChannel = NULL;

	switch (ucCommCh) {
	case eCommSpwCh1:
		vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh2:
		vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh3:
		vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommSpwCh4:
		vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
		bValidCh = TRUE;
		break;
//	case eCommSpwCh5:
//		vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
//		bValidCh = TRUE;
//		break;
//	case eCommSpwCh6:
//		vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
//		bValidCh = TRUE;
//		break;
//	case eCommSpwCh7:
//		vpxCommChannel = (TCommChannel *) (COMM_CH_7_BASE_ADDR);
//		bValidCh = TRUE;
//		break;
//	case eCommSpwCh8:
//		bValidCh = TRUE;
//		vpxCommChannel = (TCommChannel *) (COMM_CH_8_BASE_ADDR);
//		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if (bValidCh) {
		vpxCommChannel->xRmap.xRmapCodecConfig.bEnable = bEnable;
		bStatus = TRUE;
	}

	return (bStatus);
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

void vRmapSoftRstDebMemArea(void){
	volatile TRmapMemDebArea *vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);

	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bPfdfc = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bGtme = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldtr = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldf = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bFoff = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bLock1 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bLock0 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bLockw1 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bLockw0 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bC1 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bC0 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bHold = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bReset = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bReshol = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bPd = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucY4Mux = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucY3Mux = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucY2Mux = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucY1Mux = 5;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucY0Mux = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucFbMux = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucPfd = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.ucCpCurrent = 0x0F;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bPrecp = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bCpDir = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bC1 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.bC0 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bN90Div8 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bN90Div4 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bAdlock = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bSxoiref = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bSref = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.ucOutputY4Mode = 0x05;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.ucOutputY3Mode = 0x00;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.ucOutputY2Mode = 0x00;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.ucOutputY1Mode = 0x00;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.ucOutputY0Mode = 0x05;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bOutsel4 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bOutsel3 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bOutsel2 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bOutsel1 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bOutsel0 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bC1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.bC0 = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.bRefdec = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.bManaut = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.ucDlyn = 7;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.ucDlym = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.usiN = 0x0001;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.usiM = 0;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.bC1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.bC0 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod = 7;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcImmOnmod.bImmOn = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1 = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSelTrg.bTrgSrc = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSelSyn.bSynFrq = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstSpw = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstWdg = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved = 0;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucOperMod = 7;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bPllRef = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bPllVcxo = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bPllLock = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bWdg = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList8 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList7 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList6 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList5 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList4 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList3 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList2 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk1.usiVdigIn = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk1.usiVio = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk2.usiVcor = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk2.usiVlvd = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk3.usiDebTemp = 0;

}

bool bRmapSoftRstAebMemArea(alt_u8 ucAebId){
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

		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.ucReserved0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.ucReserved1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.bAdcDataRd = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.bAdcCfgWr = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.bAdcCfgRd = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.bDacWr = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.usiReserved2 = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfig.ucReserved0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfig.bWatchdogDis = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfig.bIntSync = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfig.ucReserved1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfig.bVaspCdsEn = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfig.bVasp2CalEn = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfig.bVasp1CalEn = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfig.usiReserved2 = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigKey.uliKey = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bOverrideSw = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.ucReserved0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bSwVan3 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bSwVan2 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bSwVan1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bSwVclk = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bSwVccd = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bOverrideVasp = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bReserved1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bVasp2PixEn = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bVasp1PixEn = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bVasp2AdcEn = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bVasp1AdcEn = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bVasp2Reset = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bVasp1Reset = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bOverrideAdc = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bAdc2EnP5V0 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bAdc1EnP5V0 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bPt1000CalOnN = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bEnVMuxN = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bAdc2PwdnN = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bAdc1PwdnN = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.bAdcClkEn = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.ucReserved2 = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = 32;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = 32;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xVaspI2CControl.ucVaspCfgAddr = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xVaspI2CControl.ucVasp1CfgData = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xVaspI2CControl.ucVasp2CfgData = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xVaspI2CControl.ucReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xVaspI2CControl.bVasp2Select = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xVaspI2CControl.bVasp1Select = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xVaspI2CControl.bCalibrationStart = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xVaspI2CControl.bI2CReadStart = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xVaspI2CControl.bI2CWriteStart = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig1.ucReserved0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig1.usiDacVog = 0x0800;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig1.ucReserved1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig1.usiDacVrd = 0x0800;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig2.ucReserved0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig2.usiDacVod = 0x0800;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig2.usiReserved1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xReserved20.uliReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn = 0x63;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On = 0xC8;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On = 0xC8;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On = 0xC8;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff = 0xC8;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff = 0x63;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.bReserved0 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.bSpirst = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.bMuxmod = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.bBypas = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.bClkenb = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.bChop = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.bStat = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.bReserved1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.bIdlmod = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.ucDly = 4;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.ucSbcs = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.ucDrate = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.ucAinp = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.ucAinn = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.ucDiff = 0x3F;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin7 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin6 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin5 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin4 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin3 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin2 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin0 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin15 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin14 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin13 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin12 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin11 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin10 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin9 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bAin8 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.ucReserved0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bRef = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bGain = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bTemp = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bVcc = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bReserved1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bOffset = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bCio7 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bCio6 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bCio5 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bCio4 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bCio3 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bCio2 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bCio1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.bCio0 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config3.bDio7 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config3.bDio6 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config3.bDio5 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config3.bDio4 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config3.bDio3 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config3.bDio2 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config3.bDio1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config3.bDio0 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config3.uliReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.bReserved0 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.bSpirst = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.bMuxmod = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.bBypas = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.bClkenb = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.bChop = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.bStat = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.bReserved1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.bIdlmod = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.ucDly = 4;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.ucSbcs = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.ucDrate = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.ucAinp = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.ucAinn = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.ucDiff = 0x8F;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin7 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin6 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin5 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin4 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin3 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin2 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin0 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin15 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin14 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin13 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin12 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin11 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin10 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin9 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bAin8 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.ucReserved0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bRef = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bGain = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bTemp = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bVcc = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bReserved1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bOffset = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bCio7 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bCio6 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bCio5 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bCio4 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bCio3 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bCio2 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bCio1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.bCio0 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config3.bDio7 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config3.bDio6 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config3.bDio5 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config3.bDio4 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config3.bDio3 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config3.bDio2 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config3.bDio1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config3.bDio0 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config3.uliReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xReserved118.uliReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xReserved11C.uliReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.ucReserved0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeCcdEnable = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeSpare = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeTstline = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeTstfrm = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeVaspclamp = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOePreclamp = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeIg = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeTg = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeDg = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeRphir = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeSw = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeRphi3 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeRphi2 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeRphi1 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeSphi4 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeSphi3 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeSphi2 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeSphi1 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeIphi4 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeIphi3 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeIphi2 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bSeqOeIphi1 = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.bReserved1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.ucAdcClkDiv = 0x1F;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig2.ucAdcClkLowPos = 0x0E;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig2.ucAdcClkHighPos = 0x1F;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig2.ucCdsClkLowPos = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig2.ucCdsClkHighPos = 0x11;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig3.ucRphirClkLowPos = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig3.ucRphirClkHighPos = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig3.ucRphi1ClkLowPos = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig3.ucRphi1ClkHighPos = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig4.ucRphi2ClkLowPos = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig4.ucRphi2ClkHighPos = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig4.ucRphi3ClkLowPos = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig4.ucRphi3ClkHighPos = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig5.ucSwClkLowPos = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig5.ucSwClkHighPos = 0x00;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig5.bVaspOutCtrl = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig5.bReserved = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig5.usiVaspOutEnPos = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig6.bVaspOutCtrlInv = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig6.bReserved0 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig6.usiVaspOutDisPos = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig6.usiReserved1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt = 0x08C5;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt = 0x08C5;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.bReserved = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt = 0x0A00;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 = 0x0000;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 = 0x08C5;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.bReserved = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt = 0x118A;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig14.ucReserved0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig14.bSphiInv = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig14.ucReserved1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig14.bRphiInv = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig14.usiReserved2 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.ucAebStatus = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.bVasp2CfgRun = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.bVasp1CfgRun = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.bDacCfgWrRun = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.bAdcCfgRdRun = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.bAdcCfgWrRun = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.bAdcDatRdRun = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.bAdcError = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.bAdc2Lu = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.bAdc1Lu = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.bAdcDatRd = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.bAdcCfgRd = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.bAdcCfgWr = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.bAdc2Busy = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.bAdc1Busy = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspL.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspL.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspL.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspL.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspL.uliAdcChxDataTVaspL = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspR.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspR.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspR.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspR.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspR.uliAdcChxDataTVaspR = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTBiasP.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTBiasP.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTBiasP.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTBiasP.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTBiasP.uliAdcChxDataTBiasP = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTHkP.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTHkP.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTHkP.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTHkP.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTHkP.uliAdcChxDataTHkP = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou1P.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou1P.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou1P.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou1P.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou1P.uliAdcChxDataTTou1P = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou2P.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou2P.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou2P.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou2P.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou2P.uliAdcChxDataTTou2P = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVode.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVode.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVode.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVode.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVode.uliAdcChxDataHkVode = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVodf.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVodf.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVodf.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVodf.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVodf.uliAdcChxDataHkVodf = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVrd.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVrd.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVrd.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVrd.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVrd.uliAdcChxDataHkVrd = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVog.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVog.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVog.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVog.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVog.uliAdcChxDataHkVog = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTCcd.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTCcd.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTCcd.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTCcd.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTCcd.uliAdcChxDataTCcd = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef1KMea.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliAdcChxDataTRef1KMea = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef649RMea.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliAdcChxDataTRef649RMea = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliAdcChxDataHkAnaN5V = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataSRef.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataSRef.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataSRef.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataSRef.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataSRef.uliAdcChxDataSRef = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliAdcChxDataHkCcdP31V = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkClkP15V.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliAdcChxDataHkClkP15V = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliAdcChxDataHkAnaP5V = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliAdcChxDataHkAnaP3V3 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliAdcChxDataHkDigP3V3 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bNewData = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bOvf = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bSupply = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.ucChid = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.ucAdcChxDataAdcRefBuf2 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xVaspRdConfig.ucVasp1ReadData = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xVaspRdConfig.ucVasp2ReadData = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xRevisionId1.usiFpgaVersion = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xRevisionId1.usiFpgaDate = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xRevisionId2.usiFpgaTimeH = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xRevisionId2.ucFpgaTimeM = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xRevisionId2.usiFpgaSvn = 0;

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
