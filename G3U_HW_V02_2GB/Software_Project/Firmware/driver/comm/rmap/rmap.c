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
const TRmapDebAreaCritCfg cxDefaultsRmapDebAreaCritCfg = { /* RMAP DEB Critical Config Memory Area Defaults */
	.xDtcAebOnoff.bAebIdx3 = FALSE,
	.xDtcAebOnoff.bAebIdx2 = FALSE,
	.xDtcAebOnoff.bAebIdx1 = FALSE,
	.xDtcAebOnoff.bAebIdx0 = FALSE,
	.xDtcPllReg0.bPfdfc    = FALSE,
	.xDtcPllReg0.bGtme     = FALSE,
	.xDtcPllReg0.bHoldtr   = FALSE,
	.xDtcPllReg0.bHoldf    = FALSE,
	.xDtcPllReg0.ucOthers  = 63,
	.xDtcPllReg1.uliOthers = 0xD00500F2,
	.xDtcPllReg2.uliOthers = 0x028002FD,
	.xDtcPllReg3.uliOthers = 0x38001000,
	.xDtcFeeMod.ucOperMod  = 7,
	.xDtcImmOnmod.bImmOn   = FALSE
};

const TRmapDebAreaGenCfg cxDefaultsRmapDebAreaGenCfg = { /* RMAP DEB General Config Memory Area Defaults */
	.xCfgDtcInMod.ucT7InMod      = 0,
	.xCfgDtcInMod.ucT6InMod      = 0,
	.xCfgDtcInMod.ucT5InMod      = 0,
	.xCfgDtcInMod.ucT4InMod      = 0,
	.xCfgDtcInMod.ucT3InMod      = 0,
	.xCfgDtcInMod.ucT2InMod      = 0,
	.xCfgDtcInMod.ucT1InMod      = 0,
	.xCfgDtcInMod.ucT0InMod      = 0,
	.xCfgDtcWdwSiz.ucWSizX       = 0,
	.xCfgDtcWdwSiz.ucWSizY       = 0,
	.xCfgDtcWdwIdx.usiWdwIdx4    = 0,
	.xCfgDtcWdwIdx.usiWdwLen4    = 0,
	.xCfgDtcWdwIdx.usiWdwIdx3    = 0,
	.xCfgDtcWdwIdx.usiWdwLen3    = 0,
	.xCfgDtcWdwIdx.usiWdwIdx2    = 0,
	.xCfgDtcWdwIdx.usiWdwLen2    = 0,
	.xCfgDtcWdwIdx.usiWdwIdx1    = 0,
	.xCfgDtcWdwIdx.usiWdwLen1    = 0,
	.xCfgDtcOvsPat.ucOvsLinPat   = 0,
	.xCfgDtcSizPat.usiNbLinPat   = 0,
	.xCfgDtcSizPat.usiNbPixPat   = 0,
	.xCfgDtcTrg25S.ucN25SNCyc    = 0,
	.xCfgDtcSelTrg.bTrgSrc       = FALSE,
	.xCfgDtcFrmCnt.usiPsetFrmCnt = 0,
	.xCfgDtcSelSyn.bSynFrq       = FALSE,
	.xCfgDtcRstCps.bRstSpw       = FALSE,
	.xCfgDtcRstCps.bRstWdg       = FALSE,
	.xCfgDtc25SDly.uliN25SDly    = 0,
	.xCfgDtcTmodConf.uliReserved = 0,
	.xCfgDtcSpwCfg.ucTimecode    = 0
};

const TRmapDebAreaHk cxDefaultsRmapDebAreaHk = { /* RMAP DEB Housekeeping Memory Area Defaults */
	.xDebStatus.ucOperMod           = 7,
	.xDebStatus.ucEdacListCorrErr   = 0,
	.xDebStatus.ucEdacListUncorrErr = 0,
	.xDebStatus.ucOthers            = 0,
	.xDebStatus.bVdigAeb4           = FALSE,
	.xDebStatus.bVdigAeb3           = FALSE,
	.xDebStatus.bVdigAeb2           = FALSE,
	.xDebStatus.bVdigAeb1           = FALSE,
	.xDebStatus.ucWdwListCntOvf     = 0,
	.xDebStatus.bWdg                = FALSE,
	.xDebOvf.bRowActList8           = FALSE,
	.xDebOvf.bRowActList7           = FALSE,
	.xDebOvf.bRowActList6           = FALSE,
	.xDebOvf.bRowActList5           = FALSE,
	.xDebOvf.bRowActList4           = FALSE,
	.xDebOvf.bRowActList3           = FALSE,
	.xDebOvf.bRowActList2           = FALSE,
	.xDebOvf.bRowActList1           = FALSE,
	.xDebOvf.bOutbuff8              = FALSE,
	.xDebOvf.bOutbuff7              = FALSE,
	.xDebOvf.bOutbuff6              = FALSE,
	.xDebOvf.bOutbuff5              = FALSE,
	.xDebOvf.bOutbuff4              = FALSE,
	.xDebOvf.bOutbuff3              = FALSE,
	.xDebOvf.bOutbuff2              = FALSE,
	.xDebOvf.bOutbuff1              = FALSE,
	.xDebOvf.bRmap4                 = FALSE,
	.xDebOvf.bRmap3                 = FALSE,
	.xDebOvf.bRmap2                 = FALSE,
	.xDebOvf.bRmap1                 = FALSE,
	.xSpwStatus.ucState4            = 0,
	.xSpwStatus.bCrd4               = FALSE,
	.xSpwStatus.bFifo4              = FALSE,
	.xSpwStatus.bEsc4               = FALSE,
	.xSpwStatus.bPar4               = FALSE,
	.xSpwStatus.bDisc4              = FALSE,
	.xSpwStatus.ucState3            = 0,
	.xSpwStatus.bCrd3               = FALSE,
	.xSpwStatus.bFifo3              = FALSE,
	.xSpwStatus.bEsc3               = FALSE,
	.xSpwStatus.bPar3               = FALSE,
	.xSpwStatus.bDisc3              = FALSE,
	.xSpwStatus.ucState2            = 0,
	.xSpwStatus.bCrd2               = FALSE,
	.xSpwStatus.bFifo2              = FALSE,
	.xSpwStatus.bEsc2               = FALSE,
	.xSpwStatus.bPar2               = FALSE,
	.xSpwStatus.bDisc2              = FALSE,
	.xSpwStatus.ucState1            = 0,
	.xSpwStatus.bCrd1               = FALSE,
	.xSpwStatus.bFifo1              = FALSE,
	.xSpwStatus.bEsc1               = FALSE,
	.xSpwStatus.bPar1               = FALSE,
	.xSpwStatus.bDisc1              = FALSE,
	.xDebAhk1.usiVdigIn             = 0,
	.xDebAhk1.usiVio                = 0,
	.xDebAhk2.usiVcor               = 0,
	.xDebAhk2.usiVlvd               = 0,
	.xDebAhk3.usiDebTemp            = 0
};

const TRmapAebAreaCritCfg cxDefaultsRmapAebAreaCritCfg = { /* RMAP AEB Critical Config Memory Area Defaults */
	.xAebControl.ucReserved           = 0,
	.xAebControl.ucNewState           = 0,
	.xAebControl.bSetState            = FALSE,
	.xAebControl.bAebReset            = FALSE,
	.xAebControl.uliOthers            = 0,
	.xAebConfig.uliOthers             = 0x00070000,
	.xAebConfigKey.uliKey             = 0,
	.xAebConfigAit.uliOthers          = 0,
	.xAebConfigPattern.ucPatternCcdid = 0,
	.xAebConfigPattern.usiPatternCols = 14,
	.xAebConfigPattern.ucReserved     = 0,
	.xAebConfigPattern.usiPatternRows = 14,
	.xVaspI2CControl.uliOthers        = 0,
	.xDacConfig1.uliOthers            = 0x08000800,
	.xDacConfig2.uliOthers            = 0x08000000,
	.xReserved20.uliReserved          = 0,
	.xPwrConfig1.ucTimeVccdOn         = 0,
	.xPwrConfig1.ucTimeVclkOn         = 99,
	.xPwrConfig1.ucTimeVan1On         = 200,
	.xPwrConfig1.ucTimeVan2On         = 200,
	.xPwrConfig2.ucTimeVan3On         = 200,
	.xPwrConfig2.ucTimeVccdOff        = 200,
	.xPwrConfig2.ucTimeVclkOff        = 99,
	.xPwrConfig2.ucTimeVan1Off        = 0,
	.xPwrConfig3.ucTimeVan2Off        = 0,
	.xPwrConfig3.ucTimeVan3Off        = 0
};

const TRmapAebAreaGenCfg cxDefaultsRmapAebAreaGenCfg = { /* RMAP AEB General Config Memory Area Defaults */
	.xAdc1Config1.uliOthers          = 0x5640003F,
	.xAdc1Config2.uliOthers          = 0x00F00000,
	.xAdc1Config3.uliOthers          = 0,
	.xAdc2Config1.uliOthers          = 0x5640008F,
	.xAdc2Config2.uliOthers          = 0x003F0000,
	.xAdc2Config3.uliOthers          = 0,
	.xReserved118.uliReserved        = 0,
	.xReserved11C.uliReserved        = 0,
	.xSeqConfig1.uliOthers           = 0x22FFFF1F,
	.xSeqConfig2.uliOthers           = 0x0E1F0011,
	.xSeqConfig3.uliOthers           = 0,
	.xSeqConfig4.uliOthers           = 0,
	.xSeqConfig5.uliOthers           = 0,
	.xSeqConfig6.uliOthers           = 0,
	.xSeqConfig7.uliReserved         = 0,
	.xSeqConfig8.uliReserved         = 0,
	.xSeqConfig9.ucReserved0         = 0,
	.xSeqConfig9.usiFtLoopCnt        = 2245,
	.xSeqConfig9.bLt0Enabled         = FALSE,
	.xSeqConfig9.bReserved1          = FALSE,
	.xSeqConfig9.usiLt0LoopCnt       = 0,
	.xSeqConfig10.bLt1Enabled        = TRUE,
	.xSeqConfig10.bReserved0         = FALSE,
	.xSeqConfig10.usiLt1LoopCnt      = 2245,
	.xSeqConfig10.bLt2Enabled        = FALSE,
	.xSeqConfig10.bReserved1         = FALSE,
	.xSeqConfig10.usiLt2LoopCnt      = 0,
	.xSeqConfig11.bLt3Enabled        = FALSE,
	.xSeqConfig11.bReserved          = FALSE,
	.xSeqConfig11.usiLt3LoopCnt      = 2560,
	.xSeqConfig11.usiPixLoopCntWord1 = 0,
	.xSeqConfig12.usiPixLoopCntWord0 = 2245,
	.xSeqConfig12.bPcEnabled         = FALSE,
	.xSeqConfig12.bReserved          = FALSE,
	.xSeqConfig12.usiPcLoopCnt       = 4490,
	.xSeqConfig13.ucReserved0        = 0,
	.xSeqConfig13.usiInt1LoopCnt     = 0,
	.xSeqConfig13.ucReserved1        = 0,
	.xSeqConfig13.usiInt2LoopCnt     = 0,
	.xSeqConfig14.uliOthers          = 0
};

const TRmapAebAreaHk cxDefaultsRmapAebAreaHk = { /* RMAP AEB Housekeeping Memory Area Defaults */
	.xAebStatus.ucAebStatus          = 0,
	.xAebStatus.ucOthers0            = 0,
	.xAebStatus.usiOthers1           = 0,
	.xTimestamp1.uliTimestampDword1  = 0,
	.xTimestamp2.uliTimestampDword0  = 0,
	.xAdcRdDataTVaspL.uliOthers      = 0,
	.xAdcRdDataTVaspR.uliOthers      = 0,
	.xAdcRdDataTBiasP.uliOthers      = 0,
	.xAdcRdDataTHkP.uliOthers        = 0,
	.xAdcRdDataTTou1P.uliOthers      = 0,
	.xAdcRdDataTTou2P.uliOthers      = 0,
	.xAdcRdDataHkVode.uliOthers      = 0,
	.xAdcRdDataHkVodf.uliOthers      = 0,
	.xAdcRdDataHkVrd.uliOthers       = 0,
	.xAdcRdDataHkVog.uliOthers       = 0,
	.xAdcRdDataTCcd.uliOthers        = 0,
	.xAdcRdDataTRef1KMea.uliOthers   = 0,
	.xAdcRdDataTRef649RMea.uliOthers = 0,
	.xAdcRdDataHkAnaN5V.uliOthers    = 0,
	.xAdcRdDataSRef.uliOthers        = 0,
	.xAdcRdDataHkCcdP31V.uliOthers   = 0,
	.xAdcRdDataHkClkP15V.uliOthers   = 0,
	.xAdcRdDataHkAnaP5V.uliOthers    = 0,
	.xAdcRdDataHkAnaP3V3.uliOthers   = 0,
	.xAdcRdDataHkDigP3V3.uliOthers   = 0,
	.xAdcRdDataAdcRefBuf2.uliOthers  = 0,
	.xAdc1RdConfig1.ucOthers0        = 0,
	.xAdc1RdConfig1.uliOthers1       = 0,
	.xAdc1RdConfig2.usiOthers0       = 0,
	.xAdc1RdConfig2.ucOthers1        = 0,
	.xAdc1RdConfig2.usiOthers2       = 0,
	.xAdc1RdConfig3.ucOthers         = 0,
	.xAdc2RdConfig1.ucOthers0        = 0,
	.xAdc2RdConfig1.uliOthers1       = 0,
	.xAdc2RdConfig2.usiOthers0       = 0,
	.xAdc2RdConfig2.ucOthers1        = 0,
	.xAdc2RdConfig2.usiOthers2       = 0,
	.xAdc2RdConfig3.ucOthers         = 0,
	.xVaspRdConfig.usiOthers         = 0,
	.xRevisionId1.uliOthers          = 0,
	.xRevisionId2.uliOthers          = 0
};
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

static alt_u8 sucRmapActiveCh[N_OF_FastFEE];
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
		if ( xDefaults.ucDebugLevel <= dlMinorMessage ) {
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

	/* Set this channel as the RMAP channel */
	sucRmapActiveCh[cucFeeNumber] = cucChNumber;

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
		if ( xDefaults.ucDebugLevel <= dlMinorMessage ) {
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

	/* Set this channel as the RMAP channel */
	sucRmapActiveCh[cucFeeNumber] = cucChNumber;

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
		if ( xDefaults.ucDebugLevel <= dlMinorMessage ) {
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

	/* Set this channel as the RMAP channel */
	sucRmapActiveCh[cucFeeNumber] = cucChNumber;

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
		if ( xDefaults.ucDebugLevel <= dlMinorMessage ) {
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

	/* Set this channel as the RMAP channel */
	sucRmapActiveCh[cucFeeNumber] = cucChNumber;

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
		if ( xDefaults.ucDebugLevel <= dlMinorMessage ) {
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

	/* Set this channel as the RMAP channel */
	sucRmapActiveCh[cucFeeNumber] = cucChNumber;

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
		if ( xDefaults.ucDebugLevel <= dlMinorMessage ) {
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

	/* Set this channel as the RMAP channel */
	sucRmapActiveCh[cucFeeNumber] = cucChNumber;

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
		if ( xDefaults.ucDebugLevel <= dlMinorMessage ) {
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

	/* Set this channel as the RMAP channel */
	sucRmapActiveCh[cucFeeNumber] = cucChNumber;

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
		if ( xDefaults.ucDebugLevel <= dlMinorMessage ) {
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

	/* Set this channel as the RMAP channel */
	sucRmapActiveCh[cucFeeNumber] = cucChNumber;

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

alt_u8 ucRmapGetActiveCh(alt_u8 ucFFee) {
	alt_u8 ucRmapActiveCh = 0xFF;
	if (N_OF_FastFEE > ucFFee) {
		ucRmapActiveCh = sucRmapActiveCh[ucFFee];
	}
	return (ucRmapActiveCh);
}

bool bRmapClearActiveCh(alt_u8 ucFFee) {
	bool bStatus = FALSE;
	if (N_OF_FastFEE > ucFFee) {
		sucRmapActiveCh[ucFFee] = 0;
		bStatus = TRUE;
	}
	return (bStatus);
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

void vRmapZeroFillDebRamMem(void) {
	alt_u32 uliRamDwordCnt = 0;

	volatile TRmapMemDebArea *vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);

	for (uliRamDwordCnt = 0; uliRamDwordCnt < RMAP_RAM_DEB_SIZE_DWORDS ; uliRamDwordCnt++) {
		/* Always set the RAM Address first */
		vpxRmapMemDebArea->xRmapRamDirAcc.uliRamMemAddr = uliRamDwordCnt;
		vpxRmapMemDebArea->xRmapRamDirAcc.uliRamMemData = 0x00000000;
	}

}

bool bRmapZeroFillAebRamMem(alt_u8 ucAebId) {
	bool bStatus = FALSE;
	bool bValidAeb = FALSE;
	alt_u32 uliRamDwordCnt = 0;
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

		for (uliRamDwordCnt = 0; uliRamDwordCnt < RMAP_RAM_AEB_SIZE_DWORDS ; uliRamDwordCnt++) {
			/* Always set the RAM Address first */
			vpxRmapMemAebArea->xRmapRamDirAcc.uliRamMemAddr = uliRamDwordCnt;
			vpxRmapMemAebArea->xRmapRamDirAcc.uliRamMemData = 0x00000000;
		}

		bStatus = TRUE;
	}

	return (bStatus);
}

void vRmapSoftRstDebMemArea(void){
	volatile TRmapMemDebArea *vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);

	vpxRmapMemDebArea->xRmapDebAreaCritCfg = cxDefaultsRmapDebAreaCritCfg;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg  = cxDefaultsRmapDebAreaGenCfg;
	vpxRmapMemDebArea->xRmapDebAreaHk      = cxDefaultsRmapDebAreaHk;

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

		vpxRmapMemAebArea->xRmapAebAreaCritCfg = cxDefaultsRmapAebAreaCritCfg;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg  = cxDefaultsRmapAebAreaGenCfg;
		vpxRmapMemAebArea->xRmapAebAreaHk      = cxDefaultsRmapAebAreaHk;

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
			vRmapZeroFillDebRamMem();
			if (!bRmapZeroFillAebRamMem(eCommFFeeAeb1Id)) {
				bInitFail = TRUE;
			}
			if (!bRmapZeroFillAebRamMem(eCommFFeeAeb2Id)) {
				bInitFail = TRUE;
			}
			if (!bRmapZeroFillAebRamMem(eCommFFeeAeb3Id)) {
				bInitFail = TRUE;
			}
			if (!bRmapZeroFillAebRamMem(eCommFFeeAeb4Id)) {
				bInitFail = TRUE;
			}
			vRmapSoftRstDebMemArea();
			if (!bRmapSoftRstAebMemArea(eCommFFeeAeb1Id)) {
				bInitFail = TRUE;
			}
			if (!bRmapSoftRstAebMemArea(eCommFFeeAeb2Id)) {
				bInitFail = TRUE;
			}
			if (!bRmapSoftRstAebMemArea(eCommFFeeAeb3Id)) {
				bInitFail = TRUE;
			}
			if (!bRmapSoftRstAebMemArea(eCommFFeeAeb4Id)) {
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
	if ( xDefaults.ucDebugLevel <= dlMinorMessage ) {
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

void vRmapDumpDebAddr( void ){
	volatile TRmapMemDebArea *vpxRmapMemDebArea = (TRmapMemDebArea *) (RMAP_MEM_FFEE_DEB_AREA_BASE);
	fprintf(fp, " xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaCritCfg.xDtcPllReg0.bPfdfc : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bPfdfc)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaCritCfg.xDtcPllReg0.bGtme : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bGtme)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaCritCfg.xDtcPllReg0.bHoldtr : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldtr)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaCritCfg.xDtcPllReg0.bHoldf : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldf)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaCritCfg.xDtcPllReg0.ucOthers : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.ucOthers)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaCritCfg.xDtcPllReg1.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaCritCfg.xDtcPllReg2.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaCritCfg.xDtcPllReg3.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaCritCfg.xDtcImmOnmod.bImmOn : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcImmOnmod.bImmOn)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcSelTrg.bTrgSrc : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSelTrg.bTrgSrc)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcSelSyn.bSynFrq : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSelSyn.bSynFrq)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstSpw : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstSpw)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstWdg : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstWdg)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebStatus.ucOperMod : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucOperMod)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebStatus.ucOthers : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucOthers)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebStatus.bVdigAeb4 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb4)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebStatus.bVdigAeb3 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb3)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebStatus.bVdigAeb2 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb2)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebStatus.bVdigAeb1 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb1)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebStatus.bWdg : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bWdg)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bRowActList8 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList8)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bRowActList7 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList7)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bRowActList6 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList6)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bRowActList5 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList5)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bRowActList4 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList4)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bRowActList3 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList3)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bRowActList2 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList2)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bRowActList1 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList1)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bOutbuff8 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff8)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bOutbuff7 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff7)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bOutbuff6 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff6)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bOutbuff5 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff5)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bOutbuff4 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff4)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bOutbuff3 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff3)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bOutbuff2 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff2)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bOutbuff1 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff1)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bRmap4 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap4)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bRmap3 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap3)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bRmap2 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap2)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebOvf.bRmap1 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap1)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.ucState4 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState4)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bCrd4 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd4)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bFifo4 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo4)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bEsc4 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc4)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bPar4 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar4)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bDisc4 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc4)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.ucState3 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState3)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bCrd3 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd3)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bFifo3 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo3)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bEsc3 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc3)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bPar3 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar3)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bDisc3 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc3)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.ucState2 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState2)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bCrd2 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd2)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bFifo2 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo2)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bEsc2 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc2)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bPar2 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar2)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bDisc2 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc2)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.ucState1 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState1)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bCrd1 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd1)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bFifo1 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo1)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bEsc1 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc1)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bPar1 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar1)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xSpwStatus.bDisc1 : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc1)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebAhk1.usiVdigIn : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk1.usiVdigIn)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebAhk1.usiVio : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk1.usiVio)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebAhk2.usiVcor : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk2.usiVcor)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebAhk2.usiVlvd : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk2.usiVlvd)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));
	fprintf(fp, " xRmapDebAreaHk.xDebAhk3.usiDebTemp : %lu \n", ((alt_u32)(&(vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk3.usiDebTemp)) - (alt_u32)(RMAP_MEM_FFEE_DEB_AREA_BASE)));

}

void vRmapDumpAebAddr( void ){
	volatile TRmapMemAebArea *vpxRmapMemAebArea = (TRmapMemAebArea *) (RMAP_MEM_FFEE_AEB_1_AREA_BASE);
	fprintf(fp, " xRmapAebAreaCritCfg.xAebControl.ucReserved : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.ucReserved)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xAebControl.ucNewState : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.ucNewState)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xAebControl.bSetState : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.bSetState)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xAebControl.bAebReset : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.bAebReset)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xAebControl.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xAebConfig.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfig.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xAebConfigKey.uliKey : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigKey.uliKey)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xAebConfigAit.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xDacConfig1.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig1.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xDacConfig2.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig2.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xReserved20.uliReserved : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xReserved20.uliReserved)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xAdc1Config1.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xAdc1Config2.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xAdc1Config3.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xAdc2Config1.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xAdc2Config2.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xAdc2Config3.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xReserved118.uliReserved : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xReserved118.uliReserved)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xReserved11C.uliReserved : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xReserved11C.uliReserved)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig1.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig2.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig3.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig4.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig5.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig6.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig7.uliReserved : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig8.uliReserved : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig11.bReserved : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.bReserved)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig12.bReserved : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.bReserved)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaGenCfg.xSeqConfig14.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAebStatus.ucAebStatus : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.ucAebStatus)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAebStatus.ucOthers0 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.ucOthers0)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAebStatus.usiOthers1 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.usiOthers1)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataSRef.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdc1RdConfig1.ucOthers0 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig1.ucOthers0)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdc1RdConfig1.uliOthers1 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig1.uliOthers1)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdc1RdConfig2.usiOthers0 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig2.usiOthers0)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdc1RdConfig2.ucOthers1 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig2.ucOthers1)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdc1RdConfig2.usiOthers2 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig2.usiOthers2)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdc1RdConfig3.ucOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig3.ucOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdc2RdConfig1.ucOthers0 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig1.ucOthers0)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdc2RdConfig1.uliOthers1 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig1.uliOthers1)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdc2RdConfig2.usiOthers0 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig2.usiOthers0)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdc2RdConfig2.ucOthers1 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig2.ucOthers1)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdc2RdConfig2.usiOthers2 : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig2.usiOthers2)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xAdc2RdConfig3.ucOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig3.ucOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xVaspRdConfig.usiOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xVaspRdConfig.usiOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xRevisionId1.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xRevisionId1.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));
	fprintf(fp, " xRmapAebAreaHk.xRevisionId2.uliOthers : %lu \n", ((alt_u32)(&(vpxRmapMemAebArea->xRmapAebAreaHk.xRevisionId2.uliOthers)) - (alt_u32)(RMAP_MEM_FFEE_AEB_1_AREA_BASE)));

}

void vRmapOneFillDebContent( void ) {
	volatile TRmapMemDebArea *vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);

	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bPfdfc         = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bGtme          = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldtr        = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldf         = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.ucOthers       = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.uliOthers      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.uliOthers      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.uliOthers      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod       = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcImmOnmod.bImmOn        = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX       = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY       = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4    = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4    = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3    = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3    = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2    = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2    = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1    = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1    = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat   = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat   = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat   = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc    = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSelTrg.bTrgSrc       = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSelSyn.bSynFrq       = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstSpw       = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstWdg       = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly    = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode    = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucOperMod            = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr    = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr  = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucOthers             = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb4            = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb3            = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb2            = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb1            = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf      = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bWdg                 = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList8            = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList7            = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList6            = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList5            = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList4            = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList3            = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList2            = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList1            = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff8               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff7               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff6               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff5               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff4               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff3               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff2               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff1               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap4                  = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap3                  = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap2                  = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap1                  = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState4             = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd4                = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo4               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc4                = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar4                = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc4               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState3             = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd3                = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo3               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc3                = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar3                = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc3               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState2             = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd2                = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo2               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc2                = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar2                = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc2               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState1             = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd1                = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo1               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc1                = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar1                = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc1               = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk1.usiVdigIn              = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk1.usiVio                 = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk2.usiVcor                = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk2.usiVlvd                = 0xFFFFFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk3.usiDebTemp             = 0xFFFFFFFF;

}

bool bRmapOneFillAebContent( alt_u8 ucAebId ) {
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
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.ucReserved          = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.ucNewState          = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.bSetState           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.bAebReset           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfig.uliOthers            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigKey.uliKey            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers         = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid= 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols= 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved    = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows= 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers       = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig1.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig2.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xReserved20.uliReserved         = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn        = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn        = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On        = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On        = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On        = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff       = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff       = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off       = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off       = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off       = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xReserved118.uliReserved         = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xReserved11C.uliReserved         = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved          = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved          = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0          = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt         = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled          = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt        = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled         = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0          = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt       = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled         = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1          = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt       = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled         = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.bReserved           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt       = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1  = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0  = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled          = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.bReserved           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt        = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0         = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt      = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1         = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt      = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.ucAebStatus               = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.ucOthers0                 = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.usiOthers1                = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1       = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0       = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers             = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers           = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers             = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers        = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers      = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers         = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers             = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers        = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers        = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers         = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers        = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers        = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers       = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig1.ucOthers0             = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig1.uliOthers1            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig2.usiOthers0            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig2.ucOthers1             = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig2.usiOthers2            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig3.ucOthers              = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig1.ucOthers0             = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig1.uliOthers1            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig2.usiOthers0            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig2.ucOthers1             = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig2.usiOthers2            = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig3.ucOthers              = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xVaspRdConfig.usiOthers              = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xRevisionId1.uliOthers               = 0xFFFFFFFF;
		vpxRmapMemAebArea->xRmapAebAreaHk.xRevisionId2.uliOthers               = 0xFFFFFFFF;

		bStatus = TRUE;
	}

	return (bStatus);
}

void vRmapDumpDebContent( void ) {
	volatile TRmapMemDebArea *vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);

	fprintf(fp, " -- \n");
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bPfdfc         = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bPfdfc        ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bGtme          = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bGtme         ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldtr        = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldtr       ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldf         = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldf        ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.ucOthers       = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg0.ucOthers      ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.uliOthers      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg1.uliOthers     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.uliOthers      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg2.uliOthers     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.uliOthers      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcPllReg3.uliOthers     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod       = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod      ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaCritCfg.xDtcImmOnmod.bImmOn        = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaCritCfg.xDtcImmOnmod.bImmOn       ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX       = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX      ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY       = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY      ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4    = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4   ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4    = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4   ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3    = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3   ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3    = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3   ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2    = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2   ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2    = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2   ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1    = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1   ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1    = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1   ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat   = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat  ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat   = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat  ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat   = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat  ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc    = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc   ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSelTrg.bTrgSrc       = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSelTrg.bTrgSrc      ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSelSyn.bSynFrq       = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSelSyn.bSynFrq      ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstSpw       = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstSpw      ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstWdg       = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstWdg      ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly    = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly   ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode    = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode   ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucOperMod            = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucOperMod           ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr    = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr   ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr  = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucOthers             = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucOthers            ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb4            = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb4           ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb3            = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb3           ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb2            = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb2           ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb1            = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb1           ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf      = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf     ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bWdg                 = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bWdg                ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList8            = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList8           ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList7            = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList7           ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList6            = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList6           ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList5            = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList5           ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList4            = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList4           ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList3            = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList3           ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList2            = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList2           ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList1            = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList1           ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff8               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff8              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff7               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff7              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff6               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff6              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff5               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff5              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff4               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff4              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff3               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff3              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff2               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff2              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff1               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bOutbuff1              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap4                  = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap4                 ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap3                  = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap3                 ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap2                  = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap2                 ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap1                  = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRmap1                 ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState4             = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState4            ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd4                = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd4               ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo4               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo4              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc4                = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc4               ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar4                = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar4               ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc4               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc4              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState3             = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState3            ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd3                = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd3               ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo3               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo3              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc3                = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc3               ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar3                = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar3               ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc3               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc3              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState2             = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState2            ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd2                = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd2               ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo2               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo2              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc2                = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc2               ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar2                = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar2               ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc2               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc2              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState1             = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.ucState1            ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd1                = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bCrd1               ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo1               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bFifo1              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc1                = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bEsc1               ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar1                = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bPar1               ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc1               = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xSpwStatus.bDisc1              ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebAhk1.usiVdigIn              = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk1.usiVdigIn             ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebAhk1.usiVio                 = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk1.usiVio                ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebAhk2.usiVcor                = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk2.usiVcor               ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebAhk2.usiVlvd                = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk2.usiVlvd               ));
	fprintf(fp, " xRmapMemDebArea->xRmapDebAreaHk.xDebAhk3.usiDebTemp             = %lu \n", (alt_u32)(vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk3.usiDebTemp            ));

}

bool bRmapDumpAebContent( alt_u8 ucAebId ) {
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
		fprintf(fp, " -- \n");
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xAebControl.ucReserved           = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.ucReserved          ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xAebControl.ucNewState           = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.ucNewState          ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xAebControl.bSetState            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.bSetState           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xAebControl.bAebReset            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.bAebReset           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xAebControl.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebControl.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xAebConfig.uliOthers             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfig.uliOthers            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xAebConfigKey.uliKey             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigKey.uliKey            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers          = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers         ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved     = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved    ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers        = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers       ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xDacConfig1.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig1.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xDacConfig2.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xDacConfig2.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xReserved20.uliReserved          = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xReserved20.uliReserved         ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn         = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn        ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn         = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn        ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On         = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On        ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On         = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On        ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On         = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On        ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff        = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff       ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff        = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff       ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off        = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off       ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off        = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off       ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off        = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off       ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xReserved118.uliReserved          = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xReserved118.uliReserved         ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xReserved11C.uliReserved          = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xReserved11C.uliReserved         ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved           = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved          ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved           = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved          ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0           = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0          ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt          = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt         ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled           = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled          ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt         = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt        ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled          = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled         ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0           = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0          ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt        = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt       ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled          = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled         ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1           = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1          ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt        = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt       ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled          = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled         ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig11.bReserved            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.bReserved           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt        = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt       ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1   = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1  ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0   = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0  ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled           = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled          ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig12.bReserved            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.bReserved           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt         = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt        ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0          = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0         ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt       = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt      ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1          = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1         ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt       = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt      ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAebStatus.ucAebStatus                = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.ucAebStatus               ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAebStatus.ucOthers0                  = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.ucOthers0                 ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAebStatus.usiOthers1                 = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAebStatus.usiOthers1                ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1        = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1       ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0        = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0       ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers              = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers             ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers            = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers           ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers              = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers             ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers         = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers        ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers       = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers      ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers          = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers         ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers              = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers             ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers         = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers        ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers         = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers        ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers          = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers         ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers         = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers        ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers         = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers        ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers        = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers       ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdc1RdConfig1.ucOthers0              = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig1.ucOthers0             ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdc1RdConfig1.uliOthers1             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig1.uliOthers1            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdc1RdConfig2.usiOthers0             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig2.usiOthers0            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdc1RdConfig2.ucOthers1              = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig2.ucOthers1             ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdc1RdConfig2.usiOthers2             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig2.usiOthers2            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdc1RdConfig3.ucOthers               = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc1RdConfig3.ucOthers              ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdc2RdConfig1.ucOthers0              = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig1.ucOthers0             ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdc2RdConfig1.uliOthers1             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig1.uliOthers1            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdc2RdConfig2.usiOthers0             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig2.usiOthers0            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdc2RdConfig2.ucOthers1              = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig2.ucOthers1             ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdc2RdConfig2.usiOthers2             = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig2.usiOthers2            ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xAdc2RdConfig3.ucOthers               = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xAdc2RdConfig3.ucOthers              ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xVaspRdConfig.usiOthers               = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xVaspRdConfig.usiOthers              ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xRevisionId1.uliOthers                = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xRevisionId1.uliOthers               ));
		fprintf(fp, " xRmapMemAebArea[%u]->xRmapAebAreaHk.xRevisionId2.uliOthers                = %lu \n", ucAebId, (alt_u32)(vpxRmapMemAebArea->xRmapAebAreaHk.xRevisionId2.uliOthers               ));

		bStatus = TRUE;
	}

	return (bStatus);
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
