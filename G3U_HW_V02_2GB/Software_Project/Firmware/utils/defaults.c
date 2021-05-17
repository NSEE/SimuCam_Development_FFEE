/*
 * defaults.c
 *
 *  Created on: 29 de set de 2020
 *      Author: rfranca
 */

#include "defaults.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
volatile bool vbDefaultsReceived = FALSE;
volatile alt_u32 vuliExpectedDefaultsQtd = 1;
volatile alt_u32 vuliReceivedDefaultsQtd = 0;
volatile TDeftMebDefaults vxDeftMebDefaults;
volatile TDeftFeeDefaults vxDeftFeeDefaults[N_OF_FastFEE] = {
	{
		.vpxRmapDebMem = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR),
		.vpxRmapAebMem = {
			(TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR),
			(TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR),
			(TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR),
			(TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR)
		}
	}
};
volatile TDeftNucDefaults vxDeftNucDefaults;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
void vClearMebDefault() {

	vxDeftMebDefaults.xDebug.usiOverScanSerial = 0;
	vxDeftMebDefaults.xDebug.usiPreScanSerial  = 0;
	vxDeftMebDefaults.xDebug.usiOLN            = 10;
	vxDeftMebDefaults.xDebug.usiCols           = 2295;
	vxDeftMebDefaults.xDebug.usiRows           = 2255;
	vxDeftMebDefaults.xDebug.usiSyncPeriod     = 2500;
	vxDeftMebDefaults.xDebug.usiPreBtSync      = 200;
	vxDeftMebDefaults.xDebug.bBufferOverflowEn = FALSE;
	vxDeftMebDefaults.xDebug.ulStartDelay      = 200;
	vxDeftMebDefaults.xDebug.ulSkipDelay       = 110000;
	vxDeftMebDefaults.xDebug.ulLineDelay       = 90000;
	vxDeftMebDefaults.xDebug.ulADCPixelDelay   = 333;
	vxDeftMebDefaults.xDebug.ucRmapKey         = 209;
	vxDeftMebDefaults.xDebug.ucLogicalAddr     = 81;
	vxDeftMebDefaults.xDebug.bSpwLinkStart     = FALSE;
	vxDeftMebDefaults.xDebug.usiLinkNFEE0      = 0;
	vxDeftMebDefaults.xDebug.usiDebugLevel     = 4;
	vxDeftMebDefaults.xDebug.usiPatternType    = 0;
	vxDeftMebDefaults.xDebug.usiGuardNFEEDelay = 50;
	vxDeftMebDefaults.xDebug.usiDataProtId     = 240;
	vxDeftMebDefaults.xDebug.usiDpuLogicalAddr = 80;
	vxDeftMebDefaults.ucSyncSource             = 0;
	vxDeftMebDefaults.usiExposurePeriod        = 25000;
	vxDeftMebDefaults.bEventReport             = FALSE;
	vxDeftMebDefaults.bLogReport               = FALSE;

}

bool bClearFeeDefault(alt_u8 ucFee) {
	bool bStatus = FALSE;
	unsigned char ucAeb;

	if (N_OF_FastFEE > ucFee) {

		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3					= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2					= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1					= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0					= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg0.bPfdfc						= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg0.bGtme						= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldtr						= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldf						= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg0.ucOthers					= 0x3F			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg1.uliOthers					= 0xD00500F2	;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg2.uliOthers					= 0x028002FD	;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg3.uliOthers					= 0x38001000	;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod					= 0x07			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcImmOnmod.bImmOn						= FALSE			;

		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX					= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY					= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4					= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4					= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3					= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3					= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2					= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2					= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1					= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1					= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat				= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat				= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat				= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc					= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcSelTrg.bTrgSrc					= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt				= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcSelSyn.bSynFrq					= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstSpw					= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstWdg					= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode					= 0x00			;

		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.ucOperMod							= 0x07			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr					= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr				= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.ucOthers							= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.bVdigAeb4							= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.bVdigAeb3							= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.bVdigAeb2							= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.bVdigAeb1							= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf					= 0x00			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.bWdg								= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList8							= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList7							= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList6							= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList5							= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList4							= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList3							= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList2							= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList1							= FALSE			;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebAhk1.usiVdigIn							= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebAhk1.usiVio								= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebAhk2.usiVcor								= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebAhk2.usiVlvd								= 0x0000		;
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebAhk3.usiDebTemp							= 0x0000		;

		for (ucAeb=0; ucAeb < N_OF_CCD; ucAeb++) {

			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xAebControl.ucReserved			= 0x00			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xAebControl.ucNewState			= 0x00			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xAebControl.bSetState			= FALSE			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xAebControl.bAebReset			= FALSE			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xAebControl.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xAebConfig.uliOthers				= 0x00070000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xAebConfigKey.uliKey				= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid	= 0x00			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols	= 0x000E		;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved		= 0x00			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows	= 0x000E		;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers		= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xDacConfig1.uliOthers			= 0x08000800	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xDacConfig2.uliOthers			= 0x08000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xReserved20.uliReserved			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn			= 0x00			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn			= 0x63			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On			= 0xC8			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On			= 0xC8			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On			= 0xC8			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff		= 0xC8			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff		= 0x63			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off		= 0x00			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off		= 0x00			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off		= 0x00			;

			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers			= 0x5640003F	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers			= 0x00F00000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers			= 0x5640008F	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers			= 0x003F0000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xReserved118.uliReserved			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xReserved11C.uliReserved			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers				= 0x22FFFF1F	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers				= 0x0E1F0011	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers				= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers				= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers				= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers				= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0			= 0x00			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt			= 0x08C5		;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled			= FALSE			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1			= FALSE			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt			= 0x0000		;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled			= TRUE			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0			= FALSE			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt		= 0x08C5		;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled			= FALSE			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1			= FALSE			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt		= 0x0000		;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled			= FALSE			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig11.bReserved			= FALSE			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt		= 0x0A00		;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1	= 0x0000		;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0	= 0x08C5		;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled			= FALSE			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig12.bReserved			= FALSE			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt			= 0x118A		;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0			= 0x00			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt		= 0x0000		;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1			= 0x00			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt		= 0x0000		;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers			= 0x00000000	;

			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAebStatus.ucAebStatus				= 0x00			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAebStatus.ucOthers0					= 0x00			;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAebStatus.usiOthers1					= 0x0000		;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1		= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0		= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers				= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers				= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers				= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers				= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers		= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers				= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers			= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers		= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xVaspRdConfig.usiOthers				= 0x0000		;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xRevisionId1.uliOthers				= 0x00000000	;
			vxDeftFeeDefaults[ucFee].vpxRmapAebMem[ucAeb]->xRmapAebAreaHk.xRevisionId2.uliOthers				= 0x00000000	;

		}

		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bDisconnect													= FALSE			;
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bAutostart													= FALSE			;
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bAutostart													= TRUE			;
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.ucTxDivCnt													= 0x01			;

		vxDeftFeeDefaults[ucFee].bTimecodebTransEn															= TRUE			;
		vxDeftFeeDefaults[ucFee].ucRmapLogicAddr															= 0x51			;
		vxDeftFeeDefaults[ucFee].ucRmapKey																	= 0xD1			;

		bStatus = TRUE;
	}

	return (bStatus);
}

void vClearNucDefault() {

	vxDeftNucDefaults.xEthernet.siPortPUS   = 17000;
	vxDeftNucDefaults.xEthernet.bDHCP       = FALSE;
	vxDeftNucDefaults.xEthernet.ucIP[0]     = 192;
	vxDeftNucDefaults.xEthernet.ucIP[1]     = 168;
	vxDeftNucDefaults.xEthernet.ucIP[2]     = 0;
	vxDeftNucDefaults.xEthernet.ucIP[3]     = 5;
	vxDeftNucDefaults.xEthernet.ucSubNet[0] = 255;
	vxDeftNucDefaults.xEthernet.ucSubNet[1] = 255;
	vxDeftNucDefaults.xEthernet.ucSubNet[2] = 255;
	vxDeftNucDefaults.xEthernet.ucSubNet[3] = 0;
	vxDeftNucDefaults.xEthernet.ucGTW[0]    = 192;
	vxDeftNucDefaults.xEthernet.ucGTW[1]    = 168;
	vxDeftNucDefaults.xEthernet.ucGTW[2]    = 0;
	vxDeftNucDefaults.xEthernet.ucGTW[3]    = 1;
	vxDeftNucDefaults.xEthernet.ucDNS[0]    = 8;
	vxDeftNucDefaults.xEthernet.ucDNS[1]    = 8;
	vxDeftNucDefaults.xEthernet.ucDNS[2]    = 8;
	vxDeftNucDefaults.xEthernet.ucDNS[3]    = 8;
	vxDeftNucDefaults.xEthernet.ucPID       = 112;

}

bool bSetMebDefaultValues(alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = TRUE;

	switch (usiDefaultId) {
	// usiOverScanSerial
	case eDefOverScanSerial:
		vxDeftMebDefaults.xDebug.usiOverScanSerial = (alt_u16) uliDefaultValue;
		break;
	// usiPreScanSerial
	case eDefPreScanSerial:
		vxDeftMebDefaults.xDebug.usiPreScanSerial = (alt_u16) uliDefaultValue;
		break;
	// usiOLN
	case eDefOLN:
		vxDeftMebDefaults.xDebug.usiOLN = (alt_u16) uliDefaultValue;
		break;
	// usiCols
	case eDefCols:
		vxDeftMebDefaults.xDebug.usiCols = (alt_u16) uliDefaultValue;
		break;
	// usiRows
	case eDefRows:
		vxDeftMebDefaults.xDebug.usiRows = (alt_u16) uliDefaultValue;
		break;
	// usiSyncPeriod
	case eDefSyncPeriod:
		vxDeftMebDefaults.xDebug.usiSyncPeriod = (alt_u16) uliDefaultValue;
		break;
	// usiPreBtSync
	case eDefPreBtSync:
		vxDeftMebDefaults.xDebug.usiPreBtSync = (alt_u16) uliDefaultValue;
		break;
	// bBufferOverflowEn
	case eDefBufferOverflowEn:
		vxDeftMebDefaults.xDebug.bBufferOverflowEn = (bool) uliDefaultValue;
		break;
	// ulStartDelay
	case eDefStartDelay:
		vxDeftMebDefaults.xDebug.ulStartDelay = (alt_u32) uliDefaultValue;
		break;
	// ulSkipDelay
	case eDefSkipDelay:
		vxDeftMebDefaults.xDebug.ulSkipDelay = (alt_u32) uliDefaultValue;
		break;
	// ulLineDelay
	case eDefLineDelay:
		vxDeftMebDefaults.xDebug.ulLineDelay = (alt_u32) uliDefaultValue;
		break;
	// ulADCPixelDelay
	case eDefADCPixelDelay:
		vxDeftMebDefaults.xDebug.ulADCPixelDelay = (alt_u32) uliDefaultValue;
		break;
	// ucRmapKey
	case eDefRmapKey:
		vxDeftMebDefaults.xDebug.ucRmapKey = (alt_u16) uliDefaultValue;
		break;
	// ucLogicalAddr
	case eDefMebLogicalAddr:
		vxDeftMebDefaults.xDebug.ucLogicalAddr = (alt_u16) uliDefaultValue;
		break;
	// bSpwLinkStart
	case 18:
		vxDeftMebDefaults.xDebug.bSpwLinkStart = (bool) uliDefaultValue;
		break;
	// usiLinkNFEE0
	case eDefLinkNFEE0:
		vxDeftMebDefaults.xDebug.usiLinkNFEE0 = (alt_u16) uliDefaultValue;
		break;
	// usiDebugLevel
	case eDefDebugLevel:
		vxDeftMebDefaults.xDebug.usiDebugLevel = (alt_u16) uliDefaultValue;
		break;
	// usiPatternType
	case eDefPatternType:
		vxDeftMebDefaults.xDebug.usiPatternType = (alt_u16) uliDefaultValue;
		break;
	// usiGuardNFEEDelay
	case eDefGuardNFEEDelay:
		vxDeftMebDefaults.xDebug.usiGuardNFEEDelay = (alt_u16) uliDefaultValue;
		break;
	// usiDataProtId
	case eDefDataProtId:
		vxDeftMebDefaults.xDebug.usiDataProtId = (alt_u16) uliDefaultValue;
		break;
	// usiDpuLogicalAddr
	case eDefDpuLogicalAddr:
		vxDeftMebDefaults.xDebug.usiDpuLogicalAddr = (alt_u16) uliDefaultValue;
		break;
	// Sync_Source
	case eDefSync_Source:
		vxDeftMebDefaults.ucSyncSource = (alt_u8) uliDefaultValue;
		break;
	// EP
//	case eDefEP:
//		vxDeftMebDefaults.usiExposurePeriod = (alt_u32) uliDefaultValue;
//		break;
	// EventReport
	case eDefEventReport:
		vxDeftMebDefaults.bEventReport = (alt_u8) uliDefaultValue;
		break;
	// LogReport
	case eDefLogReport:
		vxDeftMebDefaults.bLogReport = (alt_u8) uliDefaultValue;
		break;
	/* Reserved Value - Number of defaults to be received */
	case DEFT_NUC_DEFS_ID_RESERVED:
		vuliExpectedDefaultsQtd = uliDefaultValue + 1;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return (bStatus);
}

bool bSetFeeDefaultValues(alt_u8 ucFee, alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = TRUE;

	switch (usiDefaultId) {

	// SPW_LinkStart
//	case eDefSPW_LinkStart:
//		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bLinkStart = (bool) uliDefaultValue;
//		break;
	// SPW_Autostart
	case eDefSPW_Autostart:
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bAutostart = (bool) uliDefaultValue;
		break;
	// SPW_LinkSpeed
	case eDefSPW_LinkSpeed:
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.ucTxDivCnt = ucSpwcCalculateLinkDiv((alt_u8) uliDefaultValue);
		break;
	// TimeCode Enable
	case eDefTimeCodeEnable:
		vxDeftFeeDefaults[ucFee].bTimecodebTransEn = (bool) uliDefaultValue;
		break;
	// ucLogicalAddr
//	case eDefFeeLogicalAddr:
//		vxDeftFeeDefaults[ucFee].ucRmapLogicAddr = (alt_u8) uliDefaultValue;
//		break;
	// ucKey
//	case eDefFeeKey:
//		vxDeftFeeDefaults[ucFee].ucRmapKey = (alt_u8) uliDefaultValue;
//		break;

	// DebAreaCritCfg_DtcAebOnoff_bAebIdx3
	case eDefDebAreaCritCfg_DtcAebOnoff_bAebIdx3:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3 = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcAebOnoff_bAebIdx2
	case eDefDebAreaCritCfg_DtcAebOnoff_bAebIdx2:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2 = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcAebOnoff_bAebIdx1
	case eDefDebAreaCritCfg_DtcAebOnoff_bAebIdx1:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1 = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcAebOnoff_bAebIdx0
	case eDefDebAreaCritCfg_DtcAebOnoff_bAebIdx0:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0 = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg0_bPfdfc
	case eDefDebAreaCritCfg_DtcPllReg0_bPfdfc:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg0.bPfdfc = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg0_bGtme
	case eDefDebAreaCritCfg_DtcPllReg0_bGtme:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg0.bGtme = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg0_bHoldtr
	case eDefDebAreaCritCfg_DtcPllReg0_bHoldtr:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldtr = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg0_bHoldf
	case eDefDebAreaCritCfg_DtcPllReg0_bHoldf:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldf = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg0_ucOthers
	case eDefDebAreaCritCfg_DtcPllReg0_ucOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg0.ucOthers = (alt_u8) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg1_uliOthers
	case eDefDebAreaCritCfg_DtcPllReg1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg2_uliOthers
	case eDefDebAreaCritCfg_DtcPllReg2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg3_uliOthers
	case eDefDebAreaCritCfg_DtcPllReg3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcPllReg3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcFeeMod_ucOperMod
	case eDefDebAreaCritCfg_DtcFeeMod_ucOperMod:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcImmOnmod_bImmOn
	case eDefDebAreaCritCfg_DtcImmOnmod_bImmOn:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaCritCfg.xDtcImmOnmod.bImmOn = (bool) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT7InMod
	case eDefDebAreaGenCfg_CfgDtcInMod_ucT7InMod:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT6InMod
	case eDefDebAreaGenCfg_CfgDtcInMod_ucT6InMod:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT5InMod
	case eDefDebAreaGenCfg_CfgDtcInMod_ucT5InMod:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT4InMod
	case eDefDebAreaGenCfg_CfgDtcInMod_ucT4InMod:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT3InMod
	case eDefDebAreaGenCfg_CfgDtcInMod_ucT3InMod:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT2InMod
	case eDefDebAreaGenCfg_CfgDtcInMod_ucT2InMod:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT1InMod
	case eDefDebAreaGenCfg_CfgDtcInMod_ucT1InMod:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT0InMod
	case eDefDebAreaGenCfg_CfgDtcInMod_ucT0InMod:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwSiz_ucWSizX
	case eDefDebAreaGenCfg_CfgDtcWdwSiz_ucWSizX:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwSiz_ucWSizY
	case eDefDebAreaGenCfg_CfgDtcWdwSiz_ucWSizY:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx4
	case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx4:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen4
	case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen4:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx3
	case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx3:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen3
	case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen3:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx2
	case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx2:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen2
	case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen2:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx1
	case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx1:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen1
	case eDefDebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen1:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcOvsPat_ucOvsLinPat
	case eDefDebAreaGenCfg_CfgDtcOvsPat_ucOvsLinPat:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcSizPat_usiNbLinPat
	case eDefDebAreaGenCfg_CfgDtcSizPat_usiNbLinPat:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcSizPat_usiNbPixPat
	case eDefDebAreaGenCfg_CfgDtcSizPat_usiNbPixPat:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcTrg25S_ucN25SNCyc
	case eDefDebAreaGenCfg_CfgDtcTrg25S_ucN25SNCyc:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcSelTrg_bTrgSrc
	case eDefDebAreaGenCfg_CfgDtcSelTrg_bTrgSrc:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcSelTrg.bTrgSrc = (bool) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcFrmCnt_usiPsetFrmCnt
	case eDefDebAreaGenCfg_CfgDtcFrmCnt_usiPsetFrmCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcSelSyn_bSynFrq
	case eDefDebAreaGenCfg_CfgDtcSelSyn_bSynFrq:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcSelSyn.bSynFrq = (bool) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcRstCps_bRstSpw
	case eDefDebAreaGenCfg_CfgDtcRstCps_bRstSpw:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstSpw = (bool) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcRstCps_bRstWdg
	case eDefDebAreaGenCfg_CfgDtcRstCps_bRstWdg:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstWdg = (bool) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtc25SDly_uliN25SDly
	case eDefDebAreaGenCfg_CfgDtc25SDly_uliN25SDly:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly = (alt_u32) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcTmodConf_uliReserved
	case eDefDebAreaGenCfg_CfgDtcTmodConf_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcSpwCfg_ucTimecode
	case eDefDebAreaGenCfg_CfgDtcSpwCfg_ucTimecode:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode = (alt_u8) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_ucOperMod
	case eDefDebAreaHk_DebStatus_ucOperMod:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.ucOperMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_ucEdacListCorrErr
	case eDefDebAreaHk_DebStatus_ucEdacListCorrErr:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr = (alt_u8) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_ucEdacListUncorrErr
	case eDefDebAreaHk_DebStatus_ucEdacListUncorrErr:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr = (alt_u8) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_ucOthers
	case eDefDebAreaHk_DebStatus_ucOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.ucOthers = (alt_u8) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_bVdigAeb4
	case eDefDebAreaHk_DebStatus_bVdigAeb4:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.bVdigAeb4 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_bVdigAeb3
	case eDefDebAreaHk_DebStatus_bVdigAeb3:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.bVdigAeb3 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_bVdigAeb2
	case eDefDebAreaHk_DebStatus_bVdigAeb2:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.bVdigAeb2 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_bVdigAeb1
	case eDefDebAreaHk_DebStatus_bVdigAeb1:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.bVdigAeb1 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_ucWdwListCntOvf
	case eDefDebAreaHk_DebStatus_ucWdwListCntOvf:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf = (alt_u8) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_bWdg
	case eDefDebAreaHk_DebStatus_bWdg:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebStatus.bWdg = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList8
	case eDefDebAreaHk_DebOvf_bRowActList8:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList8 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList7
	case eDefDebAreaHk_DebOvf_bRowActList7:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList7 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList6
	case eDefDebAreaHk_DebOvf_bRowActList6:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList6 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList5
	case eDefDebAreaHk_DebOvf_bRowActList5:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList5 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList4
	case eDefDebAreaHk_DebOvf_bRowActList4:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList4 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList3
	case eDefDebAreaHk_DebOvf_bRowActList3:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList3 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList2
	case eDefDebAreaHk_DebOvf_bRowActList2:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList2 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList1
	case eDefDebAreaHk_DebOvf_bRowActList1:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebOvf.bRowActList1 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebAhk1_usiVdigIn
	case eDefDebAreaHk_DebAhk1_usiVdigIn:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebAhk1.usiVdigIn = (alt_u16) uliDefaultValue;
		break;
	// DebAreaHk_DebAhk1_usiVio
	case eDefDebAreaHk_DebAhk1_usiVio:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebAhk1.usiVio = (alt_u16) uliDefaultValue;
		break;
	// DebAreaHk_DebAhk2_usiVcor
	case eDefDebAreaHk_DebAhk2_usiVcor:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebAhk2.usiVcor = (alt_u16) uliDefaultValue;
		break;
	// DebAreaHk_DebAhk2_usiVlvd
	case eDefDebAreaHk_DebAhk2_usiVlvd:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebAhk2.usiVlvd = (alt_u16) uliDefaultValue;
		break;
	// DebAreaHk_DebAhk3_usiDebTemp
	case eDefDebAreaHk_DebAhk3_usiDebTemp:
		vxDeftFeeDefaults[ucFee].vpxRmapDebMem->xRmapDebAreaHk.xDebAhk3.usiDebTemp = (alt_u16) uliDefaultValue;
		break;

	// Aeb1AreaCritCfg_AebControl_ucReserved0
	case eDefAeb1AreaCritCfg_AebControl_ucReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xAebControl.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebControl_ucNewState
	case eDefAeb1AreaCritCfg_AebControl_ucNewState:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xAebControl.ucNewState = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebControl_bSetState
	case eDefAeb1AreaCritCfg_AebControl_bSetState:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xAebControl.bSetState = (bool) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebControl_bAebReset
	case eDefAeb1AreaCritCfg_AebControl_bAebReset:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xAebControl.bAebReset = (bool) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebControl_uliOthers
	case eDefAeb1AreaCritCfg_AebControl_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xAebControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebConfig_uliOthers
	case eDefAeb1AreaCritCfg_AebConfig_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xAebConfig.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebConfigKey_uliKey
	case eDefAeb1AreaCritCfg_AebConfigKey_uliKey:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xAebConfigKey.uliKey = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebConfigAit_uliOthers
	case eDefAeb1AreaCritCfg_AebConfigAit_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebConfigPattern_ucPatternCcdid
	case eDefAeb1AreaCritCfg_AebConfigPattern_ucPatternCcdid:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebConfigPattern_usiPatternCols
	case eDefAeb1AreaCritCfg_AebConfigPattern_usiPatternCols:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebConfigPattern_ucReserved
	case eDefAeb1AreaCritCfg_AebConfigPattern_ucReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebConfigPattern_usiPatternRows
	case eDefAeb1AreaCritCfg_AebConfigPattern_usiPatternRows:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_VaspI2CControl_uliOthers
	case eDefAeb1AreaCritCfg_VaspI2CControl_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_DacConfig1_uliOthers
	case eDefAeb1AreaCritCfg_DacConfig1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xDacConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_DacConfig2_uliOthers
	case eDefAeb1AreaCritCfg_DacConfig2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xDacConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_Reserved20_uliReserved
	case eDefAeb1AreaCritCfg_Reserved20_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xReserved20.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig1_ucTimeVccdOn
	case eDefAeb1AreaCritCfg_PwrConfig1_ucTimeVccdOn:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig1_ucTimeVclkOn
	case eDefAeb1AreaCritCfg_PwrConfig1_ucTimeVclkOn:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig1_ucTimeVan1On
	case eDefAeb1AreaCritCfg_PwrConfig1_ucTimeVan1On:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig1_ucTimeVan2On
	case eDefAeb1AreaCritCfg_PwrConfig1_ucTimeVan2On:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig2_ucTimeVan3On
	case eDefAeb1AreaCritCfg_PwrConfig2_ucTimeVan3On:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig2_ucTimeVccdOff
	case eDefAeb1AreaCritCfg_PwrConfig2_ucTimeVccdOff:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig2_ucTimeVclkOff
	case eDefAeb1AreaCritCfg_PwrConfig2_ucTimeVclkOff:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig2_ucTimeVan1Off
	case eDefAeb1AreaCritCfg_PwrConfig2_ucTimeVan1Off:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig3_ucTimeVan2Off
	case eDefAeb1AreaCritCfg_PwrConfig3_ucTimeVan2Off:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig3_ucTimeVan3Off
	case eDefAeb1AreaCritCfg_PwrConfig3_ucTimeVan3Off:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Adc1Config1_uliOthers
	case eDefAeb1AreaGenCfg_Adc1Config1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Adc1Config2_uliOthers
	case eDefAeb1AreaGenCfg_Adc1Config2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Adc1Config3_uliOthers
	case eDefAeb1AreaGenCfg_Adc1Config3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Adc2Config1_uliOthers
	case eDefAeb1AreaGenCfg_Adc2Config1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Adc2Config2_uliOthers
	case eDefAeb1AreaGenCfg_Adc2Config2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Adc2Config3_uliOthers
	case eDefAeb1AreaGenCfg_Adc2Config3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Reserved118_uliReserved
	case eDefAeb1AreaGenCfg_Reserved118_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xReserved118.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Reserved11C_uliReserved
	case eDefAeb1AreaGenCfg_Reserved11C_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xReserved11C.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig1_uliOthers
	case eDefAeb1AreaGenCfg_SeqConfig1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig2_uliOthers
	case eDefAeb1AreaGenCfg_SeqConfig2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig3_uliOthers
	case eDefAeb1AreaGenCfg_SeqConfig3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig4_uliOthers
	case eDefAeb1AreaGenCfg_SeqConfig4_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig5_uliOthers
	case eDefAeb1AreaGenCfg_SeqConfig5_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig6_uliOthers
	case eDefAeb1AreaGenCfg_SeqConfig6_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig7_uliReserved
	case eDefAeb1AreaGenCfg_SeqConfig7_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig8_uliReserved
	case eDefAeb1AreaGenCfg_SeqConfig8_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig9_ucReserved0
	case eDefAeb1AreaGenCfg_SeqConfig9_ucReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig9_usiFtLoopCnt
	case eDefAeb1AreaGenCfg_SeqConfig9_usiFtLoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig9_bLt0Enabled
	case eDefAeb1AreaGenCfg_SeqConfig9_bLt0Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig9_bReserved1
	case eDefAeb1AreaGenCfg_SeqConfig9_bReserved1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig9_usiLt0LoopCnt
	case eDefAeb1AreaGenCfg_SeqConfig9_usiLt0LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig10_bLt1Enabled
	case eDefAeb1AreaGenCfg_SeqConfig10_bLt1Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig10_bReserved0
	case eDefAeb1AreaGenCfg_SeqConfig10_bReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig10_usiLt1LoopCnt
	case eDefAeb1AreaGenCfg_SeqConfig10_usiLt1LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig10_bLt2Enabled
	case eDefAeb1AreaGenCfg_SeqConfig10_bLt2Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig10_bReserved1
	case eDefAeb1AreaGenCfg_SeqConfig10_bReserved1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig10_usiLt2LoopCnt
	case eDefAeb1AreaGenCfg_SeqConfig10_usiLt2LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig11_bLt3Enabled
	case eDefAeb1AreaGenCfg_SeqConfig11_bLt3Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig11_bReserved
	case eDefAeb1AreaGenCfg_SeqConfig11_bReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig11.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig11_usiLt3LoopCnt
	case eDefAeb1AreaGenCfg_SeqConfig11_usiLt3LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig11_usiPixLoopCntWord1
	case eDefAeb1AreaGenCfg_SeqConfig11_usiPixLoopCntWord1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig12_usiPixLoopCntWord0
	case eDefAeb1AreaGenCfg_SeqConfig12_usiPixLoopCntWord0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig12_bPcEnabled
	case eDefAeb1AreaGenCfg_SeqConfig12_bPcEnabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig12_bReserved
	case eDefAeb1AreaGenCfg_SeqConfig12_bReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig12.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig12_usiPcLoopCnt
	case eDefAeb1AreaGenCfg_SeqConfig12_usiPcLoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig13_ucReserved0
	case eDefAeb1AreaGenCfg_SeqConfig13_ucReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig13_usiInt1LoopCnt
	case eDefAeb1AreaGenCfg_SeqConfig13_usiInt1LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig13_ucReserved1
	case eDefAeb1AreaGenCfg_SeqConfig13_ucReserved1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig13_usiInt2LoopCnt
	case eDefAeb1AreaGenCfg_SeqConfig13_usiInt2LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig14_uliOthers
	case eDefAeb1AreaGenCfg_SeqConfig14_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AebStatus_ucAebStatus
	case eDefAeb1AreaHk_AebStatus_ucAebStatus:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAebStatus.ucAebStatus = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaHk_AebStatus_ucOthers0
	case eDefAeb1AreaHk_AebStatus_ucOthers0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAebStatus.ucOthers0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaHk_AebStatus_usiOthers1
	case eDefAeb1AreaHk_AebStatus_usiOthers1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAebStatus.usiOthers1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaHk_Timestamp1_uliTimestampDword1
	case eDefAeb1AreaHk_Timestamp1_uliTimestampDword1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_Timestamp2_uliTimestampDword0
	case eDefAeb1AreaHk_Timestamp2_uliTimestampDword0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTVaspL_uliOthers
	case eDefAeb1AreaHk_AdcRdDataTVaspL_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTVaspR_uliOthers
	case eDefAeb1AreaHk_AdcRdDataTVaspR_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTBiasP_uliOthers
	case eDefAeb1AreaHk_AdcRdDataTBiasP_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTHkP_uliOthers
	case eDefAeb1AreaHk_AdcRdDataTHkP_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTTou1P_uliOthers
	case eDefAeb1AreaHk_AdcRdDataTTou1P_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTTou2P_uliOthers
	case eDefAeb1AreaHk_AdcRdDataTTou2P_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkVode_uliOthers
	case eDefAeb1AreaHk_AdcRdDataHkVode_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkVodf_uliOthers
	case eDefAeb1AreaHk_AdcRdDataHkVodf_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkVrd_uliOthers
	case eDefAeb1AreaHk_AdcRdDataHkVrd_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkVog_uliOthers
	case eDefAeb1AreaHk_AdcRdDataHkVog_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTCcd_uliOthers
	case eDefAeb1AreaHk_AdcRdDataTCcd_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTRef1KMea_uliOthers
	case eDefAeb1AreaHk_AdcRdDataTRef1KMea_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTRef649RMea_uliOthers
	case eDefAeb1AreaHk_AdcRdDataTRef649RMea_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkAnaN5V_uliOthers
	case eDefAeb1AreaHk_AdcRdDataHkAnaN5V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataSRef_uliOthers
	case eDefAeb1AreaHk_AdcRdDataSRef_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkCcdP31V_uliOthers
	case eDefAeb1AreaHk_AdcRdDataHkCcdP31V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkClkP15V_uliOthers
	case eDefAeb1AreaHk_AdcRdDataHkClkP15V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkAnaP5V_uliOthers
	case eDefAeb1AreaHk_AdcRdDataHkAnaP5V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkAnaP3V3_uliOthers
	case eDefAeb1AreaHk_AdcRdDataHkAnaP3V3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkDigP3V3_uliOthers
	case eDefAeb1AreaHk_AdcRdDataHkDigP3V3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataAdcRefBuf2_uliOthers
	case eDefAeb1AreaHk_AdcRdDataAdcRefBuf2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_VaspRdConfig_usiOthers
	case eDefAeb1AreaHk_VaspRdConfig_usiOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xVaspRdConfig.usiOthers = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaHk_RevisionId1_uliOthers
	case eDefAeb1AreaHk_RevisionId1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xRevisionId1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_RevisionId2_uliOthers
	case eDefAeb1AreaHk_RevisionId2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[0]->xRmapAebAreaHk.xRevisionId2.uliOthers = (alt_u32) uliDefaultValue;
		break;

	// Aeb2AreaCritCfg_AebControl_ucReserved0
	case eDefAeb2AreaCritCfg_AebControl_ucReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xAebControl.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebControl_ucNewState
	case eDefAeb2AreaCritCfg_AebControl_ucNewState:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xAebControl.ucNewState = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebControl_bSetState
	case eDefAeb2AreaCritCfg_AebControl_bSetState:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xAebControl.bSetState = (bool) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebControl_bAebReset
	case eDefAeb2AreaCritCfg_AebControl_bAebReset:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xAebControl.bAebReset = (bool) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebControl_uliOthers
	case eDefAeb2AreaCritCfg_AebControl_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xAebControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebConfig_uliOthers
	case eDefAeb2AreaCritCfg_AebConfig_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xAebConfig.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebConfigKey_uliKey
	case eDefAeb2AreaCritCfg_AebConfigKey_uliKey:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xAebConfigKey.uliKey = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebConfigAit_uliOthers
	case eDefAeb2AreaCritCfg_AebConfigAit_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebConfigPattern_ucPatternCcdid
	case eDefAeb2AreaCritCfg_AebConfigPattern_ucPatternCcdid:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebConfigPattern_usiPatternCols
	case eDefAeb2AreaCritCfg_AebConfigPattern_usiPatternCols:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebConfigPattern_ucReserved
	case eDefAeb2AreaCritCfg_AebConfigPattern_ucReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebConfigPattern_usiPatternRows
	case eDefAeb2AreaCritCfg_AebConfigPattern_usiPatternRows:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_VaspI2CControl_uliOthers
	case eDefAeb2AreaCritCfg_VaspI2CControl_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_DacConfig1_uliOthers
	case eDefAeb2AreaCritCfg_DacConfig1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xDacConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_DacConfig2_uliOthers
	case eDefAeb2AreaCritCfg_DacConfig2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xDacConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_Reserved20_uliReserved
	case eDefAeb2AreaCritCfg_Reserved20_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xReserved20.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig1_ucTimeVccdOn
	case eDefAeb2AreaCritCfg_PwrConfig1_ucTimeVccdOn:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig1_ucTimeVclkOn
	case eDefAeb2AreaCritCfg_PwrConfig1_ucTimeVclkOn:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig1_ucTimeVan1On
	case eDefAeb2AreaCritCfg_PwrConfig1_ucTimeVan1On:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig1_ucTimeVan2On
	case eDefAeb2AreaCritCfg_PwrConfig1_ucTimeVan2On:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig2_ucTimeVan3On
	case eDefAeb2AreaCritCfg_PwrConfig2_ucTimeVan3On:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig2_ucTimeVccdOff
	case eDefAeb2AreaCritCfg_PwrConfig2_ucTimeVccdOff:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig2_ucTimeVclkOff
	case eDefAeb2AreaCritCfg_PwrConfig2_ucTimeVclkOff:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig2_ucTimeVan1Off
	case eDefAeb2AreaCritCfg_PwrConfig2_ucTimeVan1Off:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig3_ucTimeVan2Off
	case eDefAeb2AreaCritCfg_PwrConfig3_ucTimeVan2Off:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig3_ucTimeVan3Off
	case eDefAeb2AreaCritCfg_PwrConfig3_ucTimeVan3Off:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Adc1Config1_uliOthers
	case eDefAeb2AreaGenCfg_Adc1Config1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Adc1Config2_uliOthers
	case eDefAeb2AreaGenCfg_Adc1Config2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Adc1Config3_uliOthers
	case eDefAeb2AreaGenCfg_Adc1Config3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Adc2Config1_uliOthers
	case eDefAeb2AreaGenCfg_Adc2Config1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Adc2Config2_uliOthers
	case eDefAeb2AreaGenCfg_Adc2Config2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Adc2Config3_uliOthers
	case eDefAeb2AreaGenCfg_Adc2Config3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Reserved118_uliReserved
	case eDefAeb2AreaGenCfg_Reserved118_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xReserved118.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Reserved11C_uliReserved
	case eDefAeb2AreaGenCfg_Reserved11C_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xReserved11C.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig1_uliOthers
	case eDefAeb2AreaGenCfg_SeqConfig1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig2_uliOthers
	case eDefAeb2AreaGenCfg_SeqConfig2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig3_uliOthers
	case eDefAeb2AreaGenCfg_SeqConfig3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig4_uliOthers
	case eDefAeb2AreaGenCfg_SeqConfig4_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig5_uliOthers
	case eDefAeb2AreaGenCfg_SeqConfig5_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig6_uliOthers
	case eDefAeb2AreaGenCfg_SeqConfig6_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig7_uliReserved
	case eDefAeb2AreaGenCfg_SeqConfig7_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig8_uliReserved
	case eDefAeb2AreaGenCfg_SeqConfig8_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig9_ucReserved0
	case eDefAeb2AreaGenCfg_SeqConfig9_ucReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig9_usiFtLoopCnt
	case eDefAeb2AreaGenCfg_SeqConfig9_usiFtLoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig9_bLt0Enabled
	case eDefAeb2AreaGenCfg_SeqConfig9_bLt0Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig9_bReserved1
	case eDefAeb2AreaGenCfg_SeqConfig9_bReserved1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig9_usiLt0LoopCnt
	case eDefAeb2AreaGenCfg_SeqConfig9_usiLt0LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig10_bLt1Enabled
	case eDefAeb2AreaGenCfg_SeqConfig10_bLt1Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig10_bReserved0
	case eDefAeb2AreaGenCfg_SeqConfig10_bReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig10_usiLt1LoopCnt
	case eDefAeb2AreaGenCfg_SeqConfig10_usiLt1LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig10_bLt2Enabled
	case eDefAeb2AreaGenCfg_SeqConfig10_bLt2Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig10_bReserved1
	case eDefAeb2AreaGenCfg_SeqConfig10_bReserved1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig10_usiLt2LoopCnt
	case eDefAeb2AreaGenCfg_SeqConfig10_usiLt2LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig11_bLt3Enabled
	case eDefAeb2AreaGenCfg_SeqConfig11_bLt3Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig11_bReserved
	case eDefAeb2AreaGenCfg_SeqConfig11_bReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig11.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig11_usiLt3LoopCnt
	case eDefAeb2AreaGenCfg_SeqConfig11_usiLt3LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig11_usiPixLoopCntWord1
	case eDefAeb2AreaGenCfg_SeqConfig11_usiPixLoopCntWord1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig12_usiPixLoopCntWord0
	case eDefAeb2AreaGenCfg_SeqConfig12_usiPixLoopCntWord0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig12_bPcEnabled
	case eDefAeb2AreaGenCfg_SeqConfig12_bPcEnabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig12_bReserved
	case eDefAeb2AreaGenCfg_SeqConfig12_bReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig12.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig12_usiPcLoopCnt
	case eDefAeb2AreaGenCfg_SeqConfig12_usiPcLoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig13_ucReserved0
	case eDefAeb2AreaGenCfg_SeqConfig13_ucReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig13_usiInt1LoopCnt
	case eDefAeb2AreaGenCfg_SeqConfig13_usiInt1LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig13_ucReserved1
	case eDefAeb2AreaGenCfg_SeqConfig13_ucReserved1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig13_usiInt2LoopCnt
	case eDefAeb2AreaGenCfg_SeqConfig13_usiInt2LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig14_uliOthers
	case eDefAeb2AreaGenCfg_SeqConfig14_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AebStatus_ucAebStatus
	case eDefAeb2AreaHk_AebStatus_ucAebStatus:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAebStatus.ucAebStatus = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaHk_AebStatus_ucOthers0
	case eDefAeb2AreaHk_AebStatus_ucOthers0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAebStatus.ucOthers0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaHk_AebStatus_usiOthers1
	case eDefAeb2AreaHk_AebStatus_usiOthers1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAebStatus.usiOthers1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaHk_Timestamp1_uliTimestampDword1
	case eDefAeb2AreaHk_Timestamp1_uliTimestampDword1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_Timestamp2_uliTimestampDword0
	case eDefAeb2AreaHk_Timestamp2_uliTimestampDword0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTVaspL_uliOthers
	case eDefAeb2AreaHk_AdcRdDataTVaspL_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTVaspR_uliOthers
	case eDefAeb2AreaHk_AdcRdDataTVaspR_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTBiasP_uliOthers
	case eDefAeb2AreaHk_AdcRdDataTBiasP_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTHkP_uliOthers
	case eDefAeb2AreaHk_AdcRdDataTHkP_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTTou1P_uliOthers
	case eDefAeb2AreaHk_AdcRdDataTTou1P_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTTou2P_uliOthers
	case eDefAeb2AreaHk_AdcRdDataTTou2P_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkVode_uliOthers
	case eDefAeb2AreaHk_AdcRdDataHkVode_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkVodf_uliOthers
	case eDefAeb2AreaHk_AdcRdDataHkVodf_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkVrd_uliOthers
	case eDefAeb2AreaHk_AdcRdDataHkVrd_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkVog_uliOthers
	case eDefAeb2AreaHk_AdcRdDataHkVog_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTCcd_uliOthers
	case eDefAeb2AreaHk_AdcRdDataTCcd_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTRef1KMea_uliOthers
	case eDefAeb2AreaHk_AdcRdDataTRef1KMea_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTRef649RMea_uliOthers
	case eDefAeb2AreaHk_AdcRdDataTRef649RMea_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkAnaN5V_uliOthers
	case eDefAeb2AreaHk_AdcRdDataHkAnaN5V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataSRef_uliOthers
	case eDefAeb2AreaHk_AdcRdDataSRef_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkCcdP31V_uliOthers
	case eDefAeb2AreaHk_AdcRdDataHkCcdP31V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkClkP15V_uliOthers
	case eDefAeb2AreaHk_AdcRdDataHkClkP15V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkAnaP5V_uliOthers
	case eDefAeb2AreaHk_AdcRdDataHkAnaP5V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkAnaP3V3_uliOthers
	case eDefAeb2AreaHk_AdcRdDataHkAnaP3V3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkDigP3V3_uliOthers
	case eDefAeb2AreaHk_AdcRdDataHkDigP3V3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataAdcRefBuf2_uliOthers
	case eDefAeb2AreaHk_AdcRdDataAdcRefBuf2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_VaspRdConfig_usiOthers
	case eDefAeb2AreaHk_VaspRdConfig_usiOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xVaspRdConfig.usiOthers = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaHk_RevisionId1_uliOthers
	case eDefAeb2AreaHk_RevisionId1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xRevisionId1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_RevisionId2_uliOthers
	case eDefAeb2AreaHk_RevisionId2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[1]->xRmapAebAreaHk.xRevisionId2.uliOthers = (alt_u32) uliDefaultValue;
		break;

	// Aeb3AreaCritCfg_AebControl_ucReserved0
	case eDefAeb3AreaCritCfg_AebControl_ucReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xAebControl.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebControl_ucNewState
	case eDefAeb3AreaCritCfg_AebControl_ucNewState:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xAebControl.ucNewState = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebControl_bSetState
	case eDefAeb3AreaCritCfg_AebControl_bSetState:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xAebControl.bSetState = (bool) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebControl_bAebReset
	case eDefAeb3AreaCritCfg_AebControl_bAebReset:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xAebControl.bAebReset = (bool) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebControl_uliOthers
	case eDefAeb3AreaCritCfg_AebControl_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xAebControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebConfig_uliOthers
	case eDefAeb3AreaCritCfg_AebConfig_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xAebConfig.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebConfigKey_uliKey
	case eDefAeb3AreaCritCfg_AebConfigKey_uliKey:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xAebConfigKey.uliKey = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebConfigAit_uliOthers
	case eDefAeb3AreaCritCfg_AebConfigAit_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebConfigPattern_ucPatternCcdid
	case eDefAeb3AreaCritCfg_AebConfigPattern_ucPatternCcdid:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebConfigPattern_usiPatternCols
	case eDefAeb3AreaCritCfg_AebConfigPattern_usiPatternCols:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebConfigPattern_ucReserved
	case eDefAeb3AreaCritCfg_AebConfigPattern_ucReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebConfigPattern_usiPatternRows
	case eDefAeb3AreaCritCfg_AebConfigPattern_usiPatternRows:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_VaspI2CControl_uliOthers
	case eDefAeb3AreaCritCfg_VaspI2CControl_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_DacConfig1_uliOthers
	case eDefAeb3AreaCritCfg_DacConfig1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xDacConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_DacConfig2_uliOthers
	case eDefAeb3AreaCritCfg_DacConfig2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xDacConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_Reserved20_uliReserved
	case eDefAeb3AreaCritCfg_Reserved20_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xReserved20.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig1_ucTimeVccdOn
	case eDefAeb3AreaCritCfg_PwrConfig1_ucTimeVccdOn:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig1_ucTimeVclkOn
	case eDefAeb3AreaCritCfg_PwrConfig1_ucTimeVclkOn:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig1_ucTimeVan1On
	case eDefAeb3AreaCritCfg_PwrConfig1_ucTimeVan1On:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig1_ucTimeVan2On
	case eDefAeb3AreaCritCfg_PwrConfig1_ucTimeVan2On:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig2_ucTimeVan3On
	case eDefAeb3AreaCritCfg_PwrConfig2_ucTimeVan3On:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig2_ucTimeVccdOff
	case eDefAeb3AreaCritCfg_PwrConfig2_ucTimeVccdOff:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig2_ucTimeVclkOff
	case eDefAeb3AreaCritCfg_PwrConfig2_ucTimeVclkOff:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig2_ucTimeVan1Off
	case eDefAeb3AreaCritCfg_PwrConfig2_ucTimeVan1Off:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig3_ucTimeVan2Off
	case eDefAeb3AreaCritCfg_PwrConfig3_ucTimeVan2Off:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig3_ucTimeVan3Off
	case eDefAeb3AreaCritCfg_PwrConfig3_ucTimeVan3Off:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Adc1Config1_uliOthers
	case eDefAeb3AreaGenCfg_Adc1Config1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Adc1Config2_uliOthers
	case eDefAeb3AreaGenCfg_Adc1Config2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Adc1Config3_uliOthers
	case eDefAeb3AreaGenCfg_Adc1Config3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Adc2Config1_uliOthers
	case eDefAeb3AreaGenCfg_Adc2Config1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Adc2Config2_uliOthers
	case eDefAeb3AreaGenCfg_Adc2Config2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Adc2Config3_uliOthers
	case eDefAeb3AreaGenCfg_Adc2Config3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Reserved118_uliReserved
	case eDefAeb3AreaGenCfg_Reserved118_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xReserved118.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Reserved11C_uliReserved
	case eDefAeb3AreaGenCfg_Reserved11C_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xReserved11C.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig1_uliOthers
	case eDefAeb3AreaGenCfg_SeqConfig1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig2_uliOthers
	case eDefAeb3AreaGenCfg_SeqConfig2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig3_uliOthers
	case eDefAeb3AreaGenCfg_SeqConfig3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig4_uliOthers
	case eDefAeb3AreaGenCfg_SeqConfig4_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig5_uliOthers
	case eDefAeb3AreaGenCfg_SeqConfig5_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig6_uliOthers
	case eDefAeb3AreaGenCfg_SeqConfig6_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig7_uliReserved
	case eDefAeb3AreaGenCfg_SeqConfig7_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig8_uliReserved
	case eDefAeb3AreaGenCfg_SeqConfig8_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig9_ucReserved0
	case eDefAeb3AreaGenCfg_SeqConfig9_ucReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig9_usiFtLoopCnt
	case eDefAeb3AreaGenCfg_SeqConfig9_usiFtLoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig9_bLt0Enabled
	case eDefAeb3AreaGenCfg_SeqConfig9_bLt0Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig9_bReserved1
	case eDefAeb3AreaGenCfg_SeqConfig9_bReserved1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig9_usiLt0LoopCnt
	case eDefAeb3AreaGenCfg_SeqConfig9_usiLt0LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig10_bLt1Enabled
	case eDefAeb3AreaGenCfg_SeqConfig10_bLt1Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig10_bReserved0
	case eDefAeb3AreaGenCfg_SeqConfig10_bReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig10_usiLt1LoopCnt
	case eDefAeb3AreaGenCfg_SeqConfig10_usiLt1LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig10_bLt2Enabled
	case eDefAeb3AreaGenCfg_SeqConfig10_bLt2Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig10_bReserved1
	case eDefAeb3AreaGenCfg_SeqConfig10_bReserved1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig10_usiLt2LoopCnt
	case eDefAeb3AreaGenCfg_SeqConfig10_usiLt2LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig11_bLt3Enabled
	case eDefAeb3AreaGenCfg_SeqConfig11_bLt3Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig11_bReserved
	case eDefAeb3AreaGenCfg_SeqConfig11_bReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig11.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig11_usiLt3LoopCnt
	case eDefAeb3AreaGenCfg_SeqConfig11_usiLt3LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig11_usiPixLoopCntWord1
	case eDefAeb3AreaGenCfg_SeqConfig11_usiPixLoopCntWord1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig12_usiPixLoopCntWord0
	case eDefAeb3AreaGenCfg_SeqConfig12_usiPixLoopCntWord0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig12_bPcEnabled
	case eDefAeb3AreaGenCfg_SeqConfig12_bPcEnabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig12_bReserved
	case eDefAeb3AreaGenCfg_SeqConfig12_bReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig12.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig12_usiPcLoopCnt
	case eDefAeb3AreaGenCfg_SeqConfig12_usiPcLoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig13_ucReserved0
	case eDefAeb3AreaGenCfg_SeqConfig13_ucReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig13_usiInt1LoopCnt
	case eDefAeb3AreaGenCfg_SeqConfig13_usiInt1LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig13_ucReserved1
	case eDefAeb3AreaGenCfg_SeqConfig13_ucReserved1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig13_usiInt2LoopCnt
	case eDefAeb3AreaGenCfg_SeqConfig13_usiInt2LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig14_uliOthers
	case eDefAeb3AreaGenCfg_SeqConfig14_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AebStatus_ucAebStatus
	case eDefAeb3AreaHk_AebStatus_ucAebStatus:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAebStatus.ucAebStatus = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaHk_AebStatus_ucOthers0
	case eDefAeb3AreaHk_AebStatus_ucOthers0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAebStatus.ucOthers0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaHk_AebStatus_usiOthers1
	case eDefAeb3AreaHk_AebStatus_usiOthers1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAebStatus.usiOthers1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaHk_Timestamp1_uliTimestampDword1
	case eDefAeb3AreaHk_Timestamp1_uliTimestampDword1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_Timestamp2_uliTimestampDword0
	case eDefAeb3AreaHk_Timestamp2_uliTimestampDword0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTVaspL_uliOthers
	case eDefAeb3AreaHk_AdcRdDataTVaspL_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTVaspR_uliOthers
	case eDefAeb3AreaHk_AdcRdDataTVaspR_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTBiasP_uliOthers
	case eDefAeb3AreaHk_AdcRdDataTBiasP_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTHkP_uliOthers
	case eDefAeb3AreaHk_AdcRdDataTHkP_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTTou1P_uliOthers
	case eDefAeb3AreaHk_AdcRdDataTTou1P_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTTou2P_uliOthers
	case eDefAeb3AreaHk_AdcRdDataTTou2P_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkVode_uliOthers
	case eDefAeb3AreaHk_AdcRdDataHkVode_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkVodf_uliOthers
	case eDefAeb3AreaHk_AdcRdDataHkVodf_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkVrd_uliOthers
	case eDefAeb3AreaHk_AdcRdDataHkVrd_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkVog_uliOthers
	case eDefAeb3AreaHk_AdcRdDataHkVog_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTCcd_uliOthers
	case eDefAeb3AreaHk_AdcRdDataTCcd_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTRef1KMea_uliOthers
	case eDefAeb3AreaHk_AdcRdDataTRef1KMea_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTRef649RMea_uliOthers
	case eDefAeb3AreaHk_AdcRdDataTRef649RMea_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkAnaN5V_uliOthers
	case eDefAeb3AreaHk_AdcRdDataHkAnaN5V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataSRef_uliOthers
	case eDefAeb3AreaHk_AdcRdDataSRef_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkCcdP31V_uliOthers
	case eDefAeb3AreaHk_AdcRdDataHkCcdP31V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkClkP15V_uliOthers
	case eDefAeb3AreaHk_AdcRdDataHkClkP15V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkAnaP5V_uliOthers
	case eDefAeb3AreaHk_AdcRdDataHkAnaP5V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkAnaP3V3_uliOthers
	case eDefAeb3AreaHk_AdcRdDataHkAnaP3V3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkDigP3V3_uliOthers
	case eDefAeb3AreaHk_AdcRdDataHkDigP3V3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataAdcRefBuf2_uliOthers
	case eDefAeb3AreaHk_AdcRdDataAdcRefBuf2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_VaspRdConfig_usiOthers
	case eDefAeb3AreaHk_VaspRdConfig_usiOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xVaspRdConfig.usiOthers = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaHk_RevisionId1_uliOthers
	case eDefAeb3AreaHk_RevisionId1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xRevisionId1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_RevisionId2_uliOthers
	case eDefAeb3AreaHk_RevisionId2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[2]->xRmapAebAreaHk.xRevisionId2.uliOthers = (alt_u32) uliDefaultValue;
		break;

	// Aeb4AreaCritCfg_AebControl_ucReserved0
	case eDefAeb4AreaCritCfg_AebControl_ucReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xAebControl.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebControl_ucNewState
	case eDefAeb4AreaCritCfg_AebControl_ucNewState:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xAebControl.ucNewState = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebControl_bSetState
	case eDefAeb4AreaCritCfg_AebControl_bSetState:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xAebControl.bSetState = (bool) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebControl_bAebReset
	case eDefAeb4AreaCritCfg_AebControl_bAebReset:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xAebControl.bAebReset = (bool) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebControl_uliOthers
	case eDefAeb4AreaCritCfg_AebControl_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xAebControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebConfig_uliOthers
	case eDefAeb4AreaCritCfg_AebConfig_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xAebConfig.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebConfigKey_uliKey
	case eDefAeb4AreaCritCfg_AebConfigKey_uliKey:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xAebConfigKey.uliKey = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebConfigAit_uliOthers
	case eDefAeb4AreaCritCfg_AebConfigAit_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebConfigPattern_ucPatternCcdid
	case eDefAeb4AreaCritCfg_AebConfigPattern_ucPatternCcdid:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebConfigPattern_usiPatternCols
	case eDefAeb4AreaCritCfg_AebConfigPattern_usiPatternCols:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebConfigPattern_ucReserved
	case eDefAeb4AreaCritCfg_AebConfigPattern_ucReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebConfigPattern_usiPatternRows
	case eDefAeb4AreaCritCfg_AebConfigPattern_usiPatternRows:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_VaspI2CControl_uliOthers
	case eDefAeb4AreaCritCfg_VaspI2CControl_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_DacConfig1_uliOthers
	case eDefAeb4AreaCritCfg_DacConfig1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xDacConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_DacConfig2_uliOthers
	case eDefAeb4AreaCritCfg_DacConfig2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xDacConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_Reserved20_uliReserved
	case eDefAeb4AreaCritCfg_Reserved20_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xReserved20.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig1_ucTimeVccdOn
	case eDefAeb4AreaCritCfg_PwrConfig1_ucTimeVccdOn:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig1_ucTimeVclkOn
	case eDefAeb4AreaCritCfg_PwrConfig1_ucTimeVclkOn:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig1_ucTimeVan1On
	case eDefAeb4AreaCritCfg_PwrConfig1_ucTimeVan1On:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig1_ucTimeVan2On
	case eDefAeb4AreaCritCfg_PwrConfig1_ucTimeVan2On:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig2_ucTimeVan3On
	case eDefAeb4AreaCritCfg_PwrConfig2_ucTimeVan3On:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig2_ucTimeVccdOff
	case eDefAeb4AreaCritCfg_PwrConfig2_ucTimeVccdOff:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig2_ucTimeVclkOff
	case eDefAeb4AreaCritCfg_PwrConfig2_ucTimeVclkOff:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig2_ucTimeVan1Off
	case eDefAeb4AreaCritCfg_PwrConfig2_ucTimeVan1Off:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig3_ucTimeVan2Off
	case eDefAeb4AreaCritCfg_PwrConfig3_ucTimeVan2Off:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig3_ucTimeVan3Off
	case eDefAeb4AreaCritCfg_PwrConfig3_ucTimeVan3Off:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Adc1Config1_uliOthers
	case eDefAeb4AreaGenCfg_Adc1Config1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Adc1Config2_uliOthers
	case eDefAeb4AreaGenCfg_Adc1Config2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Adc1Config3_uliOthers
	case eDefAeb4AreaGenCfg_Adc1Config3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Adc2Config1_uliOthers
	case eDefAeb4AreaGenCfg_Adc2Config1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Adc2Config2_uliOthers
	case eDefAeb4AreaGenCfg_Adc2Config2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Adc2Config3_uliOthers
	case eDefAeb4AreaGenCfg_Adc2Config3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Reserved118_uliReserved
	case eDefAeb4AreaGenCfg_Reserved118_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xReserved118.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Reserved11C_uliReserved
	case eDefAeb4AreaGenCfg_Reserved11C_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xReserved11C.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig1_uliOthers
	case eDefAeb4AreaGenCfg_SeqConfig1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig2_uliOthers
	case eDefAeb4AreaGenCfg_SeqConfig2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig3_uliOthers
	case eDefAeb4AreaGenCfg_SeqConfig3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig4_uliOthers
	case eDefAeb4AreaGenCfg_SeqConfig4_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig5_uliOthers
	case eDefAeb4AreaGenCfg_SeqConfig5_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig6_uliOthers
	case eDefAeb4AreaGenCfg_SeqConfig6_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig7_uliReserved
	case eDefAeb4AreaGenCfg_SeqConfig7_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig8_uliReserved
	case eDefAeb4AreaGenCfg_SeqConfig8_uliReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig9_ucReserved0
	case eDefAeb4AreaGenCfg_SeqConfig9_ucReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig9_usiFtLoopCnt
	case eDefAeb4AreaGenCfg_SeqConfig9_usiFtLoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig9_bLt0Enabled
	case eDefAeb4AreaGenCfg_SeqConfig9_bLt0Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig9_bReserved1
	case eDefAeb4AreaGenCfg_SeqConfig9_bReserved1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig9_usiLt0LoopCnt
	case eDefAeb4AreaGenCfg_SeqConfig9_usiLt0LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig10_bLt1Enabled
	case eDefAeb4AreaGenCfg_SeqConfig10_bLt1Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig10_bReserved0
	case eDefAeb4AreaGenCfg_SeqConfig10_bReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig10_usiLt1LoopCnt
	case eDefAeb4AreaGenCfg_SeqConfig10_usiLt1LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig10_bLt2Enabled
	case eDefAeb4AreaGenCfg_SeqConfig10_bLt2Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig10_bReserved1
	case eDefAeb4AreaGenCfg_SeqConfig10_bReserved1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig10_usiLt2LoopCnt
	case eDefAeb4AreaGenCfg_SeqConfig10_usiLt2LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig11_bLt3Enabled
	case eDefAeb4AreaGenCfg_SeqConfig11_bLt3Enabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig11_bReserved
	case eDefAeb4AreaGenCfg_SeqConfig11_bReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig11.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig11_usiLt3LoopCnt
	case eDefAeb4AreaGenCfg_SeqConfig11_usiLt3LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig11_usiPixLoopCntWord1
	case eDefAeb4AreaGenCfg_SeqConfig11_usiPixLoopCntWord1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig12_usiPixLoopCntWord0
	case eDefAeb4AreaGenCfg_SeqConfig12_usiPixLoopCntWord0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig12_bPcEnabled
	case eDefAeb4AreaGenCfg_SeqConfig12_bPcEnabled:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig12_bReserved
	case eDefAeb4AreaGenCfg_SeqConfig12_bReserved:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig12.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig12_usiPcLoopCnt
	case eDefAeb4AreaGenCfg_SeqConfig12_usiPcLoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig13_ucReserved0
	case eDefAeb4AreaGenCfg_SeqConfig13_ucReserved0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig13_usiInt1LoopCnt
	case eDefAeb4AreaGenCfg_SeqConfig13_usiInt1LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig13_ucReserved1
	case eDefAeb4AreaGenCfg_SeqConfig13_ucReserved1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig13_usiInt2LoopCnt
	case eDefAeb4AreaGenCfg_SeqConfig13_usiInt2LoopCnt:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig14_uliOthers
	case eDefAeb4AreaGenCfg_SeqConfig14_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AebStatus_ucAebStatus
	case eDefAeb4AreaHk_AebStatus_ucAebStatus:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAebStatus.ucAebStatus = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaHk_AebStatus_ucOthers0
	case eDefAeb4AreaHk_AebStatus_ucOthers0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAebStatus.ucOthers0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaHk_AebStatus_usiOthers1
	case eDefAeb4AreaHk_AebStatus_usiOthers1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAebStatus.usiOthers1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaHk_Timestamp1_uliTimestampDword1
	case eDefAeb4AreaHk_Timestamp1_uliTimestampDword1:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_Timestamp2_uliTimestampDword0
	case eDefAeb4AreaHk_Timestamp2_uliTimestampDword0:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTVaspL_uliOthers
	case eDefAeb4AreaHk_AdcRdDataTVaspL_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTVaspR_uliOthers
	case eDefAeb4AreaHk_AdcRdDataTVaspR_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTBiasP_uliOthers
	case eDefAeb4AreaHk_AdcRdDataTBiasP_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTHkP_uliOthers
	case eDefAeb4AreaHk_AdcRdDataTHkP_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTTou1P_uliOthers
	case eDefAeb4AreaHk_AdcRdDataTTou1P_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTTou2P_uliOthers
	case eDefAeb4AreaHk_AdcRdDataTTou2P_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkVode_uliOthers
	case eDefAeb4AreaHk_AdcRdDataHkVode_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkVodf_uliOthers
	case eDefAeb4AreaHk_AdcRdDataHkVodf_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkVrd_uliOthers
	case eDefAeb4AreaHk_AdcRdDataHkVrd_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkVog_uliOthers
	case eDefAeb4AreaHk_AdcRdDataHkVog_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTCcd_uliOthers
	case eDefAeb4AreaHk_AdcRdDataTCcd_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTRef1KMea_uliOthers
	case eDefAeb4AreaHk_AdcRdDataTRef1KMea_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTRef649RMea_uliOthers
	case eDefAeb4AreaHk_AdcRdDataTRef649RMea_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkAnaN5V_uliOthers
	case eDefAeb4AreaHk_AdcRdDataHkAnaN5V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataSRef_uliOthers
	case eDefAeb4AreaHk_AdcRdDataSRef_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataSRef.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkCcdP31V_uliOthers
	case eDefAeb4AreaHk_AdcRdDataHkCcdP31V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkClkP15V_uliOthers
	case eDefAeb4AreaHk_AdcRdDataHkClkP15V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkAnaP5V_uliOthers
	case eDefAeb4AreaHk_AdcRdDataHkAnaP5V_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkAnaP3V3_uliOthers
	case eDefAeb4AreaHk_AdcRdDataHkAnaP3V3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkDigP3V3_uliOthers
	case eDefAeb4AreaHk_AdcRdDataHkDigP3V3_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataAdcRefBuf2_uliOthers
	case eDefAeb4AreaHk_AdcRdDataAdcRefBuf2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_VaspRdConfig_usiOthers
	case eDefAeb4AreaHk_VaspRdConfig_usiOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xVaspRdConfig.usiOthers = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaHk_RevisionId1_uliOthers
	case eDefAeb4AreaHk_RevisionId1_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xRevisionId1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_RevisionId2_uliOthers
	case eDefAeb4AreaHk_RevisionId2_uliOthers:
		vxDeftFeeDefaults[ucFee].vpxRmapAebMem[3]->xRmapAebAreaHk.xRevisionId2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return (bStatus);
}

bool bSetNucDefaultValues(alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = TRUE;

	switch (usiDefaultId) {
	/* TcpServerPort */
	case eDefTcpServerPort:
		vxDeftNucDefaults.xEthernet.siPortPUS = (alt_u16) uliDefaultValue;
		break;
	/* DHCPv4Enable */
	case eDefDHCPv4Enable:
		vxDeftNucDefaults.xEthernet.bDHCP = (bool) uliDefaultValue;
		break;
	/* IPv4Address */
	case eDefIPv4Address:
		vxDeftNucDefaults.xEthernet.ucIP[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucIP[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucIP[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucIP[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* IPv4Subnet */
	case eDefIPv4Subnet:
		vxDeftNucDefaults.xEthernet.ucSubNet[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucSubNet[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucSubNet[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucSubNet[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* IPv4Gateway */
	case eDefIPv4Gateway:
		vxDeftNucDefaults.xEthernet.ucGTW[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucGTW[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucGTW[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucGTW[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* IPv4DNS */
	case eDefIPv4DNS:
		vxDeftNucDefaults.xEthernet.ucDNS[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucDNS[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucDNS[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucDNS[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* PusHpPid */
	case eDefPusHpPid:
		vxDeftNucDefaults.xEthernet.ucPID = (alt_u8) uliDefaultValue;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return (bStatus);
}

bool bSetDefaultValues(alt_u16 usiMebFee, alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = FALSE;

	if (0 == usiMebFee) { /* MEB or NUC Default */

		if (((DEFT_MEB_DEFS_ID_LOWER_LIM <= usiDefaultId) && (DEFT_FEE_DEFS_ID_LOWER_LIM > usiDefaultId)) || (DEFT_NUC_DEFS_ID_RESERVED == usiDefaultId)) {

			/* Default ID is a MEB Default */
			bStatus = bSetMebDefaultValues(usiDefaultId, uliDefaultValue);

		} else if (DEFT_NUC_DEFS_ID_LOWER_LIM <= usiDefaultId) {

			/* Default ID is a NUC Default */
			bStatus = bSetNucDefaultValues(usiDefaultId, uliDefaultValue);

		}

	} else if ((N_OF_FastFEE + 1) >= usiMebFee) { /* FEE Default */

		if ((DEFT_FEE_DEFS_ID_LOWER_LIM <= usiDefaultId) && (DEFT_NUC_DEFS_ID_LOWER_LIM > usiDefaultId)) {

			/* Default ID is a FEE Default */
			bStatus = bSetFeeDefaultValues(usiMebFee - 1, usiDefaultId, uliDefaultValue);

		}

	}

	if (TRUE == bStatus) {
		vuliReceivedDefaultsQtd++;
	}

	return (bStatus);
}

//! [public functions]

//! [private functions]
//! [private functions]
