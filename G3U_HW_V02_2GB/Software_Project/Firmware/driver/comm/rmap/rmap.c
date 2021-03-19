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
	INT8U error_codel;
	alt_u8 ucWordCnt = 0;
	alt_u32 ucWriteByteAddr = 0;
	alt_u32 ucWriteLenWords = 0;

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

		ucWriteLenWords = (alt_u32)(vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteLengthBytes / 4);
		ucWriteByteAddr = vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		for (ucWordCnt = 0; ucWordCnt < ucWriteLenWords; ucWordCnt++) {

			ucEntity = (INT8U) (( ucWriteByteAddr & 0x000F0000 ) >> 16);
			usiADDRReg = (INT16U) ( ucWriteByteAddr & 0x0000FFFF );

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

			ucWriteByteAddr += 4;
		}

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
	INT8U error_codel;
	alt_u8 ucWordCnt = 0;
	alt_u32 ucWriteByteAddr = 0;
	alt_u32 ucWriteLenWords = 0;

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

		ucWriteLenWords = (alt_u32)(vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteLengthBytes / 4);
		ucWriteByteAddr = vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		for (ucWordCnt = 0; ucWordCnt < ucWriteLenWords; ucWordCnt++) {

			ucEntity = (INT8U) (( ucWriteByteAddr & 0x000F0000 ) >> 16);
			usiADDRReg = (INT16U) ( ucWriteByteAddr & 0x0000FFFF );

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

			ucWriteByteAddr += 4;
		}

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
	INT8U error_codel;
	alt_u8 ucWordCnt = 0;
	alt_u32 ucWriteByteAddr = 0;
	alt_u32 ucWriteLenWords = 0;

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

		ucWriteLenWords = (alt_u32)(vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteLengthBytes / 4);
		ucWriteByteAddr = vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		for (ucWordCnt = 0; ucWordCnt < ucWriteLenWords; ucWordCnt++) {

			ucEntity = (INT8U) (( ucWriteByteAddr & 0x000F0000 ) >> 16);
			usiADDRReg = (INT16U) ( ucWriteByteAddr & 0x0000FFFF );

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

			ucWriteByteAddr += 4;
		}

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
	INT8U error_codel;
	alt_u8 ucWordCnt = 0;
	alt_u32 ucWriteByteAddr = 0;
	alt_u32 ucWriteLenWords = 0;

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

		ucWriteLenWords = (alt_u32)(vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteLengthBytes / 4);
		ucWriteByteAddr = vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		for (ucWordCnt = 0; ucWordCnt < ucWriteLenWords; ucWordCnt++) {

			ucEntity = (INT8U) (( ucWriteByteAddr & 0x000F0000 ) >> 16);
			usiADDRReg = (INT16U) ( ucWriteByteAddr & 0x0000FFFF );

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

			ucWriteByteAddr += 4;
		}

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
	INT8U error_codel;
	alt_u8 ucWordCnt = 0;
	alt_u32 ucWriteByteAddr = 0;
	alt_u32 ucWriteLenWords = 0;

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

		ucWriteLenWords = (alt_u32)(vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteLengthBytes / 4);
		ucWriteByteAddr = vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		for (ucWordCnt = 0; ucWordCnt < ucWriteLenWords; ucWordCnt++) {

			ucEntity = (INT8U) (( ucWriteByteAddr & 0x000F0000 ) >> 16);
			usiADDRReg = (INT16U) ( ucWriteByteAddr & 0x0000FFFF );

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

			ucWriteByteAddr += 4;
		}
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
	INT8U error_codel;
	alt_u8 ucWordCnt = 0;
	alt_u32 ucWriteByteAddr = 0;
	alt_u32 ucWriteLenWords = 0;

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

		ucWriteLenWords = (alt_u32)(vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteLengthBytes / 4);
		ucWriteByteAddr = vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		for (ucWordCnt = 0; ucWordCnt < ucWriteLenWords; ucWordCnt++) {

			ucEntity = (INT8U) (( ucWriteByteAddr & 0x000F0000 ) >> 16);
			usiADDRReg = (INT16U) ( ucWriteByteAddr & 0x0000FFFF );

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

			ucWriteByteAddr += 4;
		}

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
	INT8U error_codel;
	alt_u8 ucWordCnt = 0;
	alt_u32 ucWriteByteAddr = 0;
	alt_u32 ucWriteLenWords = 0;

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

		ucWriteLenWords = (alt_u32)(vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteLengthBytes / 4);
		ucWriteByteAddr = vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		for (ucWordCnt = 0; ucWordCnt < ucWriteLenWords; ucWordCnt++) {

			ucEntity = (INT8U) (( ucWriteByteAddr & 0x000F0000 ) >> 16);
			usiADDRReg = (INT16U) ( ucWriteByteAddr & 0x0000FFFF );

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

			ucWriteByteAddr += 4;
		}

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
	INT8U error_codel;
	alt_u8 ucWordCnt = 0;
	alt_u32 ucWriteByteAddr = 0;
	alt_u32 ucWriteLenWords = 0;

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

		ucWriteLenWords = (alt_u32)(vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteLengthBytes / 4);
		ucWriteByteAddr = vpxCommChannel->xRmap.xRmapMemStatus.uliLastWriteAddress;

		for (ucWordCnt = 0; ucWordCnt < ucWriteLenWords; ucWordCnt++) {

			ucEntity = (INT8U) (( ucWriteByteAddr & 0x000F0000 ) >> 16);
			usiADDRReg = (INT16U) ( ucWriteByteAddr & 0x0000FFFF );

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

			ucWriteByteAddr += 4;
		}

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
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.ucOthers = 63;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.uliOthers = 0xD00500F2;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.uliOthers = 0x028002FD;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.uliOthers = 0x38001000;
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
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucOthers = 0;
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
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff8 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff7 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff6 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff5 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff4 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff3 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff2 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap4 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap3 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap2 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState4 = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd4 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo4 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc4 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar4 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc4 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState3 = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd3 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo3 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc3 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar3 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc3 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState2 = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd2 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo2 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc2 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar2 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc2 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState1 = 0;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar1 = FALSE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc1 = FALSE;
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

		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.ucReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.ucNewState = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.bSetState = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.bAebReset = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfig.uliOthers = 0x00070000;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigKey.uliKey = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = 14;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = 14;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig1.uliOthers = 0x08000800;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig2.uliOthers = 0x08000000;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xReserved20.uliReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn = 99;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On = 200;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On = 200;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On = 200;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff = 200;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff = 99;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off = 0;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers = 0x5640003F;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers = 0x00F00000;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers = 0x5640008F;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers = 0x003F0000;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xReserved118.uliReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xReserved11C.uliReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers = 0x22FFFF1F;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers = 0x0E1F0011;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt = 2245;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled = TRUE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt = 2245;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.bReserved = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt = 2560;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 = 2245;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.bReserved = FALSE;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt = 4490;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt = 0;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.ucAebStatus = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.ucOthers0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.usiOthers1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig1.ucOthers0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig1.uliOthers1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig2.usiOthers0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig2.ucOthers1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig2.usiOthers2 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig3.ucOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig1.ucOthers0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig1.uliOthers1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig2.usiOthers0 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig2.ucOthers1 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig2.usiOthers2 = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig3.ucOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xVaspRdConfig.usiOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xRevisionId1.uliOthers = 0;
		vpxRmapMemAebArea->xRmapAebAreaHk.xRevisionId2.uliOthers = 0;

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

/* Code for test purposes, should always be disabled in a release! */
#if DEV_MODE_ON
void vRmapDummyCmd(alt_u32 uliDummyAdddr){
	tQMask uiCmdRmap;
	INT8U ucEntity;
	INT16U usiADDRReg;
	INT8U error_codel;
	alt_u8 ucWordCnt = 0;
	alt_u32 ucWriteByteAddr = 0;
	alt_u32 ucWriteLenWords = 0;

	const unsigned char cucFeeNumber = 0;
	const unsigned char cucIrqNumber = 0;

	/* RMAP Write Configuration Area Flag */

	/* Warnning simplification: For now all address is lower than 1 bytes  */

	#if DEBUG_ON
	if ( xDefaults.usiDebugLevel <= dlMinorMessage ) {
		fprintf(fp,"IRQ RMAP.\n");
	}
	#endif

	ucWriteLenWords = 1;
	ucWriteByteAddr = uliDummyAdddr;

	for (ucWordCnt = 0; ucWordCnt < ucWriteLenWords; ucWordCnt++) {

		ucEntity = (INT8U) (( ucWriteByteAddr & 0x000F0000 ) >> 16);
		usiADDRReg = (INT16U) ( ucWriteByteAddr & 0x0000FFFF );

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

		ucWriteByteAddr += 4;
	}

}
#endif
//! [public functions]

//! [private functions]
alt_u32 uliRmapReadReg(alt_u32 *puliAddr, alt_u32 uliOffset) {
	volatile alt_u32 uliValue;

	uliValue = *(puliAddr + uliOffset);
	return uliValue;
}

//! [private functions]
