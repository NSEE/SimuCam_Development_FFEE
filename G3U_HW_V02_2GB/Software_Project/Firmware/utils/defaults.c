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
volatile TDeftMebDefaults vxDeftMebDefaults;
volatile TDeftFeeDefaults vxDeftFeeDefaults[N_OF_FastFEE];
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

	if (N_OF_FastFEE > ucFee) {

		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3					= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2					= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1					= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0					= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg0.bPfdfc						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg0.bGtme						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg0.bHoldtr					= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg0.bHoldf						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg0.ucOthers					= 0x3F			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg1.uliOthers					= 0xD00500F2	;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg2.uliOthers					= 0x028002FD	;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg3.uliOthers					= 0x38001000	;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod					= 0x07			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcImmOnmod.bImmOn					= FALSE			;

		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4				= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4				= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3				= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3				= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2				= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2				= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1				= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1				= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat				= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat				= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcSelTrg.bTrgSrc					= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt				= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcSelSyn.bSynFrq					= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstSpw					= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstWdg					= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode				= 0x00			;

		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.ucOperMod						= 0x07			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.ucOthers							= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.bVdigAeb4						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.bVdigAeb3						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.bVdigAeb2						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.bVdigAeb1						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.bWdg								= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList8						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList7						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList6						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList5						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList4						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList3						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList2						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList1						= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebAhk1.usiVdigIn							= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebAhk1.usiVio								= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebAhk2.usiVcor							= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebAhk2.usiVlvd							= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebAhk3.usiDebTemp							= 0x0000		;

		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebControl.ucReserved				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebControl.ucNewState				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebControl.bSetState				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebControl.bAebReset				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebControl.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebConfig.uliOthers				= 0x00070000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebConfigKey.uliKey				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebConfigAit.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid	= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols	= 0x000E		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved		= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows	= 0x000E		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xDacConfig1.uliOthers				= 0x08000800	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xDacConfig2.uliOthers				= 0x08000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xReserved20.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn			= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn			= 0x63			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff			= 0x63			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off			= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off			= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off			= 0x00			;

		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xAdc1Config1.uliOthers				= 0x5640003F	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xAdc1Config2.uliOthers				= 0x00F00000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xAdc1Config3.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xAdc2Config1.uliOthers				= 0x5640008F	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xAdc2Config2.uliOthers				= 0x003F0000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xAdc2Config3.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xReserved118.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xReserved11C.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig1.uliOthers				= 0x22FFFF1F	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig2.uliOthers				= 0x0E1F0011	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig3.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig4.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig5.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig6.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig7.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig8.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt				= 0x08C5		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig9.bReserved1				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled				= TRUE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig10.bReserved0				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt			= 0x08C5		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig10.bReserved1				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig11.bReserved				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt			= 0x0A00		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1		= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0		= 0x08C5		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig12.bReserved				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt			= 0x118A		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig14.uliOthers				= 0x00000000	;

		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAebStatus.ucAebStatus					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAebStatus.ucOthers0						= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAebStatus.usiOthers1					= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xTimestamp1.uliTimestampDword1			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xTimestamp2.uliTimestampDword0			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataSRef.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xVaspRdConfig.usiOthers					= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xRevisionId1.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xRevisionId2.uliOthers					= 0x00000000	;

		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebControl.ucReserved				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebControl.ucNewState				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebControl.bSetState				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebControl.bAebReset				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebControl.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebConfig.uliOthers				= 0x00070000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebConfigKey.uliKey				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebConfigAit.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid	= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols	= 0x000E		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved		= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows	= 0x000E		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xDacConfig1.uliOthers				= 0x08000800	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xDacConfig2.uliOthers				= 0x08000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xReserved20.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn			= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn			= 0x63			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff			= 0x63			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off			= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off			= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off			= 0x00			;

		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xAdc1Config1.uliOthers				= 0x5640003F	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xAdc1Config2.uliOthers				= 0x00F00000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xAdc1Config3.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xAdc2Config1.uliOthers				= 0x5640008F	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xAdc2Config2.uliOthers				= 0x003F0000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xAdc2Config3.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xReserved118.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xReserved11C.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig1.uliOthers				= 0x22FFFF1F	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig2.uliOthers				= 0x0E1F0011	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig3.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig4.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig5.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig6.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig7.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig8.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt				= 0x08C5		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig9.bReserved1				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled				= TRUE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig10.bReserved0				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt			= 0x08C5		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig10.bReserved1				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig11.bReserved				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt			= 0x0A00		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1		= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0		= 0x08C5		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig12.bReserved				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt			= 0x118A		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig14.uliOthers				= 0x00000000	;

		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAebStatus.ucAebStatus					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAebStatus.ucOthers0						= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAebStatus.usiOthers1					= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xTimestamp1.uliTimestampDword1			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xTimestamp2.uliTimestampDword0			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataSRef.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xVaspRdConfig.usiOthers					= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xRevisionId1.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xRevisionId2.uliOthers					= 0x00000000	;

		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebControl.ucReserved				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebControl.ucNewState				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebControl.bSetState				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebControl.bAebReset				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebControl.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebConfig.uliOthers				= 0x00070000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebConfigKey.uliKey				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebConfigAit.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid	= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols	= 0x000E		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved		= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows	= 0x000E		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xDacConfig1.uliOthers				= 0x08000800	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xDacConfig2.uliOthers				= 0x08000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xReserved20.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn			= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn			= 0x63			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff			= 0x63			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off			= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off			= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off			= 0x00			;

		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xAdc1Config1.uliOthers				= 0x5640003F	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xAdc1Config2.uliOthers				= 0x00F00000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xAdc1Config3.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xAdc2Config1.uliOthers				= 0x5640008F	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xAdc2Config2.uliOthers				= 0x003F0000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xAdc2Config3.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xReserved118.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xReserved11C.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig1.uliOthers				= 0x22FFFF1F	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig2.uliOthers				= 0x0E1F0011	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig3.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig4.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig5.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig6.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig7.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig8.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt				= 0x08C5		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig9.bReserved1				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled				= TRUE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig10.bReserved0				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt			= 0x08C5		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig10.bReserved1				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig11.bReserved				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt			= 0x0A00		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1		= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0		= 0x08C5		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig12.bReserved				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt			= 0x118A		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig14.uliOthers				= 0x00000000	;

		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAebStatus.ucAebStatus					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAebStatus.ucOthers0						= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAebStatus.usiOthers1					= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xTimestamp1.uliTimestampDword1			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xTimestamp2.uliTimestampDword0			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataSRef.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xVaspRdConfig.usiOthers					= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xRevisionId1.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xRevisionId2.uliOthers					= 0x00000000	;

		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebControl.ucReserved				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebControl.ucNewState				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebControl.bSetState				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebControl.bAebReset				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebControl.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebConfig.uliOthers				= 0x00070000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebConfigKey.uliKey				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebConfigAit.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid	= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols	= 0x000E		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved		= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows	= 0x000E		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xDacConfig1.uliOthers				= 0x08000800	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xDacConfig2.uliOthers				= 0x08000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xReserved20.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn			= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn			= 0x63			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff			= 0xC8			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff			= 0x63			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off			= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off			= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off			= 0x00			;

		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xAdc1Config1.uliOthers				= 0x5640003F	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xAdc1Config2.uliOthers				= 0x00F00000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xAdc1Config3.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xAdc2Config1.uliOthers				= 0x5640008F	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xAdc2Config2.uliOthers				= 0x003F0000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xAdc2Config3.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xReserved118.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xReserved11C.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig1.uliOthers				= 0x22FFFF1F	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig2.uliOthers				= 0x0E1F0011	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig3.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig4.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig5.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig6.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig7.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig8.uliReserved				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt				= 0x08C5		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig9.bReserved1				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled				= TRUE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig10.bReserved0				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt			= 0x08C5		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig10.bReserved1				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig11.bReserved				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt			= 0x0A00		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1		= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0		= 0x08C5		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig12.bReserved				= FALSE			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt			= 0x118A		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1				= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt			= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig14.uliOthers				= 0x00000000	;

		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAebStatus.ucAebStatus					= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAebStatus.ucOthers0						= 0x00			;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAebStatus.usiOthers1					= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xTimestamp1.uliTimestampDword1			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xTimestamp2.uliTimestampDword0			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataSRef.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers				= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers			= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xVaspRdConfig.usiOthers					= 0x0000		;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xRevisionId1.uliOthers					= 0x00000000	;
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xRevisionId2.uliOthers					= 0x00000000	;

		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bDisconnect												= FALSE			;
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bAutostart												= FALSE			;
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bAutostart												= TRUE			;
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.ucTxDivCnt												= 0x01			;

		vxDeftFeeDefaults[ucFee].bTimecodebTransEn														= TRUE			;
		vxDeftFeeDefaults[ucFee].ucRmapLogicAddr														= 0x51			;
		vxDeftFeeDefaults[ucFee].ucRmapKey																= 0xD1			;

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
	// 0~3 are LESIA-ONLY defaults
	// usiOverScanSerial
	case 4:
		vxDeftMebDefaults.xDebug.usiOverScanSerial = (alt_u16) uliDefaultValue;
		break;
	// usiPreScanSerial
	case 5:
		vxDeftMebDefaults.xDebug.usiPreScanSerial = (alt_u16) uliDefaultValue;
		break;
	// usiOLN
	case 6:
		vxDeftMebDefaults.xDebug.usiOLN = (alt_u16) uliDefaultValue;
		break;
	// usiCols
	case 7:
		vxDeftMebDefaults.xDebug.usiCols = (alt_u16) uliDefaultValue;
		break;
	// usiRows
	case 8:
		vxDeftMebDefaults.xDebug.usiRows = (alt_u16) uliDefaultValue;
		break;
	// usiSyncPeriod
	case 9:
		vxDeftMebDefaults.xDebug.usiSyncPeriod = (alt_u16) uliDefaultValue;
		break;
	// usiPreBtSync
	case 10:
		vxDeftMebDefaults.xDebug.usiPreBtSync = (alt_u16) uliDefaultValue;
		break;
	// bBufferOverflowEn
	case 11:
		vxDeftMebDefaults.xDebug.bBufferOverflowEn = (bool) uliDefaultValue;
		break;
	// ulStartDelay
	case 12:
		vxDeftMebDefaults.xDebug.ulStartDelay = (alt_u32) uliDefaultValue;
		break;
	// ulSkipDelay
	case 13:
		vxDeftMebDefaults.xDebug.ulSkipDelay = (alt_u32) uliDefaultValue;
		break;
	// ulLineDelay
	case 14:
		vxDeftMebDefaults.xDebug.ulLineDelay = (alt_u32) uliDefaultValue;
		break;
	// ulADCPixelDelay
	case 15:
		vxDeftMebDefaults.xDebug.ulADCPixelDelay = (alt_u32) uliDefaultValue;
		break;
	// ucRmapKey
	case 16:
		vxDeftMebDefaults.xDebug.ucRmapKey = (alt_u16) uliDefaultValue;
		break;
	// ucLogicalAddr
	case 17:
		vxDeftMebDefaults.xDebug.ucLogicalAddr = (alt_u16) uliDefaultValue;
		break;
	// bSpwLinkStart
	case 18:
		vxDeftMebDefaults.xDebug.bSpwLinkStart = (bool) uliDefaultValue;
		break;
	// usiLinkNFEE0
	case 19:
		vxDeftMebDefaults.xDebug.usiLinkNFEE0 = (alt_u16) uliDefaultValue;
		break;
	// usiDebugLevel
	case 20:
		vxDeftMebDefaults.xDebug.usiDebugLevel = (alt_u16) uliDefaultValue;
		break;
	// usiPatternType
	case 21:
		vxDeftMebDefaults.xDebug.usiPatternType = (alt_u16) uliDefaultValue;
		break;
	// usiGuardNFEEDelay
	case 22:
		vxDeftMebDefaults.xDebug.usiGuardNFEEDelay = (alt_u16) uliDefaultValue;
		break;
	// usiDataProtId
	case 23:
		vxDeftMebDefaults.xDebug.usiDataProtId = (alt_u16) uliDefaultValue;
		break;
	// usiDpuLogicalAddr
	case 24:
		vxDeftMebDefaults.xDebug.usiDpuLogicalAddr = (alt_u16) uliDefaultValue;
		break;
	// 25 is LESIA-ONLY default
	// Sync_Source
	case 26:
		vxDeftMebDefaults.ucSyncSource = (alt_u8) uliDefaultValue;
		break;
	// EP
	case 27:
		vxDeftMebDefaults.usiExposurePeriod = (alt_u32) uliDefaultValue;
		break;
	// EventReport
	case 28:
		vxDeftMebDefaults.bEventReport = (alt_u8) uliDefaultValue;
		break;
	// LogReport
	case 29:
		vxDeftMebDefaults.bLogReport = (alt_u8) uliDefaultValue;
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
	case 3000:
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bAutostart = (bool) uliDefaultValue;
		break;
	// SPW_Autostart
	case 3001:
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.bAutostart = (bool) uliDefaultValue;
		break;
	// SPW_LinkSpeed
	case 3002:
		vxDeftFeeDefaults[ucFee].xSpwLinkConfig.ucTxDivCnt = ucSpwcCalculateLinkDiv((alt_u8) uliDefaultValue);
		break;
	// TimeCode Enable
	case 3003:
		vxDeftFeeDefaults[ucFee].bTimecodebTransEn = (bool) uliDefaultValue;
		break;
	// ucLogicalAddr
	case 3004:
		vxDeftFeeDefaults[ucFee].ucRmapLogicAddr = (alt_u8) uliDefaultValue;
		break;
	// ucKey
	case 3005:
		vxDeftFeeDefaults[ucFee].ucRmapKey = (alt_u8) uliDefaultValue;
		break;

	// DebAreaCritCfg_DtcAebOnoff_bAebIdx3
	case 4000:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3 = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcAebOnoff_bAebIdx2
	case 4001:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2 = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcAebOnoff_bAebIdx1
	case 4002:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1 = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcAebOnoff_bAebIdx0
	case 4003:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0 = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg0_bPfdfc
	case 4004:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg0.bPfdfc = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg0_bGtme
	case 4005:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg0.bGtme = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg0_bHoldtr
	case 4006:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg0.bHoldtr = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg0_bHoldf
	case 4007:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg0.bHoldf = (bool) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg0_ucOthers
	case 4008:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg0.ucOthers = (alt_u8) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg1_uliOthers
	case 4009:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg2_uliOthers
	case 4010:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcPllReg3_uliOthers
	case 4011:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcPllReg3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcFeeMod_ucOperMod
	case 4012:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaCritCfg_DtcImmOnmod_bImmOn
	case 4013:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaCritCfg.xDtcImmOnmod.bImmOn = (bool) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT7InMod
	case 4200:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT6InMod
	case 4201:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT5InMod
	case 4202:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT4InMod
	case 4203:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT3InMod
	case 4204:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT2InMod
	case 4205:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT1InMod
	case 4206:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcInMod_ucT0InMod
	case 4207:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwSiz_ucWSizX
	case 4208:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwSiz_ucWSizY
	case 4209:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx4
	case 4210:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen4
	case 4211:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx3
	case 4212:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen3
	case 4213:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx2
	case 4214:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen2
	case 4215:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwIdx1
	case 4216:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcWdwIdx_usiWdwLen1
	case 4217:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1 = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcOvsPat_ucOvsLinPat
	case 4218:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcSizPat_usiNbLinPat
	case 4219:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcSizPat_usiNbPixPat
	case 4220:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcTrg25S_ucN25SNCyc
	case 4221:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc = (alt_u8) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcSelTrg_bTrgSrc
	case 4222:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcSelTrg.bTrgSrc = (bool) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcFrmCnt_usiPsetFrmCnt
	case 4223:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt = (alt_u16) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcSelSyn_bSynFrq
	case 4224:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcSelSyn.bSynFrq = (bool) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcRstCps_bRstSpw
	case 4225:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstSpw = (bool) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcRstCps_bRstWdg
	case 4226:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstWdg = (bool) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtc25SDly_uliN25SDly
	case 4227:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly = (alt_u32) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcTmodConf_uliReserved
	case 4228:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// DebAreaGenCfg_CfgDtcSpwCfg_ucTimecode
	case 4229:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode = (alt_u8) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_ucOperMod
	case 4400:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.ucOperMod = (alt_u8) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_ucEdacListCorrErr
	case 4401:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr = (alt_u8) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_ucEdacListUncorrErr
	case 4402:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr = (alt_u8) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_ucOthers
	case 4403:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.ucOthers = (alt_u8) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_bVdigAeb4
	case 4404:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.bVdigAeb4 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_bVdigAeb3
	case 4405:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.bVdigAeb3 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_bVdigAeb2
	case 4406:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.bVdigAeb2 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_bVdigAeb1
	case 4407:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.bVdigAeb1 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_ucWdwListCntOvf
	case 4408:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf = (alt_u8) uliDefaultValue;
		break;
	// DebAreaHk_DebStatus_bWdg
	case 4409:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebStatus.bWdg = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList8
	case 4410:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList8 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList7
	case 4411:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList7 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList6
	case 4412:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList6 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList5
	case 4413:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList5 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList4
	case 4414:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList4 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList3
	case 4415:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList3 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList2
	case 4416:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList2 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebOvf_bRowActList1
	case 4417:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebOvf.bRowActList1 = (bool) uliDefaultValue;
		break;
	// DebAreaHk_DebAhk1_usiVdigIn
	case 4418:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebAhk1.usiVdigIn = (alt_u16) uliDefaultValue;
		break;
	// DebAreaHk_DebAhk1_usiVio
	case 4419:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebAhk1.usiVio = (alt_u16) uliDefaultValue;
		break;
	// DebAreaHk_DebAhk2_usiVcor
	case 4420:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebAhk2.usiVcor = (alt_u16) uliDefaultValue;
		break;
	// DebAreaHk_DebAhk2_usiVlvd
	case 4421:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebAhk2.usiVlvd = (alt_u16) uliDefaultValue;
		break;
	// DebAreaHk_DebAhk3_usiDebTemp
	case 4422:
		vxDeftFeeDefaults[ucFee].xRmapDebMem.xRmapDebAreaHk.xDebAhk3.usiDebTemp = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebControl_ucReserved0

	case 5000:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebControl.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebControl_ucNewState
	case 5001:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebControl.ucNewState = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebControl_bSetState
	case 5002:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebControl.bSetState = (bool) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebControl_bAebReset
	case 5003:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebControl.bAebReset = (bool) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebControl_uliOthers
	case 5004:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebConfig_uliOthers
	case 5005:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebConfig.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebConfigKey_uliKey
	case 5006:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebConfigKey.uliKey = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebConfigAit_uliOthers
	case 5007:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebConfigAit.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebConfigPattern_ucPatternCcdid
	case 5008:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebConfigPattern_usiPatternCols
	case 5009:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebConfigPattern_ucReserved
	case 5010:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_AebConfigPattern_usiPatternRows
	case 5011:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_VaspI2CControl_uliOthers
	case 5012:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_DacConfig1_uliOthers
	case 5013:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xDacConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_DacConfig2_uliOthers
	case 5014:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xDacConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_Reserved20_uliReserved
	case 5015:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xReserved20.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig1_ucTimeVccdOn
	case 5016:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig1_ucTimeVclkOn
	case 5017:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig1_ucTimeVan1On
	case 5018:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig1_ucTimeVan2On
	case 5019:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig2_ucTimeVan3On
	case 5020:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig2_ucTimeVccdOff
	case 5021:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig2_ucTimeVclkOff
	case 5022:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig2_ucTimeVan1Off
	case 5023:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig3_ucTimeVan2Off
	case 5024:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaCritCfg_PwrConfig3_ucTimeVan3Off
	case 5025:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Adc1Config1_uliOthers
	case 5200:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xAdc1Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Adc1Config2_uliOthers
	case 5201:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xAdc1Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Adc1Config3_uliOthers
	case 5202:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xAdc1Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Adc2Config1_uliOthers
	case 5203:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xAdc2Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Adc2Config2_uliOthers
	case 5204:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xAdc2Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Adc2Config3_uliOthers
	case 5205:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xAdc2Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Reserved118_uliReserved
	case 5206:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xReserved118.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_Reserved11C_uliReserved
	case 5207:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xReserved11C.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig1_uliOthers
	case 5208:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig2_uliOthers
	case 5209:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig3_uliOthers
	case 5210:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig4.uliOthers
	case 5211:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig4.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig5_uliOthers
	case 5212:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig5.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig6_uliOthers
	case 5213:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig6.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig7_uliReserved
	case 5214:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig7.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig8_uliReserved
	case 5215:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig8.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig9_ucReserved0
	case 5216:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig9_usiFtLoopCnt
	case 5217:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig9_bLt0Enabled
	case 5218:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig9_bReserved1
	case 5219:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig9_usiLt0LoopCnt
	case 5220:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig10_bLt1Enabled
	case 5221:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig10_bReserved0
	case 5222:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig10_usiLt1LoopCnt
	case 5223:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig10_bLt2Enabled
	case 5224:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig10_bReserved1
	case 5225:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig10_usiLt2LoopCnt
	case 5226:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig11_bLt3Enabled
	case 5227:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig11_bReserved
	case 5228:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig11.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig11_usiLt3LoopCnt
	case 5229:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig11_usiPixLoopCntWord1
	case 5230:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig12_usiPixLoopCntWord0
	case 5231:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig12_bPcEnabled
	case 5232:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig12_bReserved
	case 5233:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig12.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig12_usiPcLoopCnt
	case 5234:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig13_ucReserved0
	case 5235:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig13_usiInt1LoopCnt
	case 5236:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig13_ucReserved1
	case 5237:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig13_usiInt2LoopCnt
	case 5238:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaGenCfg_SeqConfig14_uliOthers
	case 5239:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaGenCfg.xSeqConfig14.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AebStatus_ucAebStatus
	case 5400:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAebStatus.ucAebStatus = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaHk_AebStatus_ucOthers0
	case 5401:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAebStatus.ucOthers0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb1AreaHk_AebStatus_usiOthers1
	case 5402:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAebStatus.usiOthers1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaHk_Timestamp1_uliTimestampDword1
	case 5403:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_Timestamp2_uliTimestampDword0
	case 5404:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTVaspL_uliOthers
	case 5405:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTVaspR_uliOthers
	case 5406:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTBiasP_uliOthers
	case 5407:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTHkP_uliOthers
	case 5408:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTTou1P_uliOthers
	case 5409:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTTou2P_uliOthers
	case 5410:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkVode_uliOthers
	case 5411:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkVodf_uliOthers
	case 5412:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkVrd_uliOthers
	case 5413:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkVog_uliOthers
	case 5414:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTCcd_uliOthers
	case 5415:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTRef1KMea_uliOthers
	case 5416:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataTRef649RMea_uliOthers
	case 5417:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkAnaN5V_uliOthers
	case 5418:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataSRef_uliOthers
	case 5419:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataSRef.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkCcdP31V_uliOthers
	case 5420:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkClkP15V_uliOthers
	case 5421:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkAnaP5V_uliOthers
	case 5422:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkAnaP3V3_uliOthers
	case 5423:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataHkDigP3V3_uliOthers
	case 5424:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_AdcRdDataAdcRefBuf2_uliOthers
	case 5425:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_VaspRdConfig_usiOthers
	case 5426:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xVaspRdConfig.usiOthers = (alt_u16) uliDefaultValue;
		break;
	// Aeb1AreaHk_RevisionId1_uliOthers
	case 5427:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xRevisionId1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb1AreaHk_RevisionId2_uliOthers
	case 5428:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[0].xRmapAebAreaHk.xRevisionId2.uliOthers = (alt_u32) uliDefaultValue;
		break;

	// Aeb2AreaCritCfg_AebControl_ucReserved0
	case 6000:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebControl.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebControl_ucNewState
	case 6001:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebControl.ucNewState = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebControl_bSetState
	case 6002:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebControl.bSetState = (bool) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebControl_bAebReset
	case 6003:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebControl.bAebReset = (bool) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebControl_uliOthers
	case 6004:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebConfig_uliOthers
	case 6005:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebConfig.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebConfigKey_uliKey
	case 6006:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebConfigKey.uliKey = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebConfigAit_uliOthers
	case 6007:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebConfigAit.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebConfigPattern_ucPatternCcdid
	case 6008:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebConfigPattern_usiPatternCols
	case 6009:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebConfigPattern_ucReserved
	case 6010:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_AebConfigPattern_usiPatternRows
	case 6011:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_VaspI2CControl_uliOthers
	case 6012:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_DacConfig1_uliOthers
	case 6013:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xDacConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_DacConfig2_uliOthers
	case 6014:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xDacConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_Reserved20_uliReserved
	case 6015:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xReserved20.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig1_ucTimeVccdOn
	case 6016:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig1_ucTimeVclkOn
	case 6017:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig1_ucTimeVan1On
	case 6018:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig1_ucTimeVan2On
	case 6019:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig2_ucTimeVan3On
	case 6020:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig2_ucTimeVccdOff
	case 6021:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig2_ucTimeVclkOff
	case 6022:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig2_ucTimeVan1Off
	case 6023:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig3_ucTimeVan2Off
	case 6024:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaCritCfg_PwrConfig3_ucTimeVan3Off
	case 6025:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Adc1Config1_uliOthers
	case 6200:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xAdc1Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Adc1Config2_uliOthers
	case 6201:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xAdc1Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Adc1Config3_uliOthers
	case 6202:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xAdc1Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Adc2Config1_uliOthers
	case 6203:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xAdc2Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Adc2Config2_uliOthers
	case 6204:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xAdc2Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Adc2Config3_uliOthers
	case 6205:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xAdc2Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Reserved118_uliReserved
	case 6206:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xReserved118.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_Reserved11C_uliReserved
	case 6207:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xReserved11C.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig1_uliOthers
	case 6208:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig2_uliOthers
	case 6209:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig3_uliOthers
	case 6210:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig4_uliOthers
	case 6211:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig4.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig5_uliOthers
	case 6212:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig5.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig6_uliOthers
	case 6213:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig6.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig7_uliReserved
	case 6214:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig7.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig8_uliReserved
	case 6215:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig8.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig9_ucReserved0
	case 6216:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig9_usiFtLoopCnt
	case 6217:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig9_bLt0Enabled
	case 6218:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig9_bReserved1
	case 6219:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig9_usiLt0LoopCnt
	case 6220:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig10_bLt1Enabled
	case 6221:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig10_bReserved0
	case 6222:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig10_usiLt1LoopCnt
	case 6223:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig10_bLt2Enabled
	case 6224:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig10_bReserved1
	case 6225:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig10_usiLt2LoopCnt
	case 6226:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig11_bLt3Enabled
	case 6227:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig11_bReserved
	case 6228:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig11.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig11_usiLt3LoopCnt
	case 6229:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig11_usiPixLoopCntWord1
	case 6230:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig12_usiPixLoopCntWord0
	case 6231:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig12_bPcEnabled
	case 6232:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig12_bReserved
	case 6233:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig12.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig12_usiPcLoopCnt
	case 6234:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig13_ucReserved0
	case 6235:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig13_usiInt1LoopCnt
	case 6236:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig13_ucReserved1
	case 6237:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig13_usiInt2LoopCnt
	case 6238:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaGenCfg_SeqConfig14_uliOthers
	case 6239:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaGenCfg.xSeqConfig14.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AebStatus_ucAebStatus
	case 6400:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAebStatus.ucAebStatus = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaHk_AebStatus_ucOthers0
	case 6401:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAebStatus.ucOthers0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb2AreaHk_AebStatus_usiOthers1
	case 6402:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAebStatus.usiOthers1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaHk_Timestamp1_uliTimestampDword1
	case 6403:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_Timestamp2_uliTimestampDword0
	case 6404:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTVaspL_uliOthers
	case 6405:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTVaspR_uliOthers
	case 6406:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTBiasP_uliOthers
	case 6407:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTHkP_uliOthers
	case 6408:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTTou1P_uliOthers
	case 6409:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTTou2P_uliOthers
	case 6410:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkVode_uliOthers
	case 6411:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkVodf_uliOthers
	case 6412:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkVrd_uliOthers
	case 6413:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkVog_uliOthers
	case 6414:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTCcd_uliOthers
	case 6415:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTRef1KMea_uliOthers
	case 6416:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataTRef649RMea_uliOthers
	case 6417:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkAnaN5V_uliOthers
	case 6418:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataSRef_uliOthers
	case 6419:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataSRef.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkCcdP31V_uliOthers
	case 6420:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkClkP15V_uliOthers
	case 6421:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkAnaP5V_uliOthers
	case 6422:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkAnaP3V3_uliOthers
	case 6423:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataHkDigP3V3_uliOthers
	case 6424:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_AdcRdDataAdcRefBuf2_uliOthers
	case 6425:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_VaspRdConfig_usiOthers
	case 6426:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xVaspRdConfig.usiOthers = (alt_u16) uliDefaultValue;
		break;
	// Aeb2AreaHk_RevisionId1_uliOthers
	case 6427:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xRevisionId1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb2AreaHk_RevisionId2_uliOthers
	case 6428:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[1].xRmapAebAreaHk.xRevisionId2.uliOthers = (alt_u32) uliDefaultValue;
		break;

	// Aeb3AreaCritCfg_AebControl_ucReserved0
	case 7000:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebControl.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebControl_ucNewState
	case 7001:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebControl.ucNewState = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebControl_bSetState
	case 7002:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebControl.bSetState = (bool) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebControl_bAebReset
	case 7003:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebControl.bAebReset = (bool) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebControl_uliOthers
	case 7004:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebConfig_uliOthers
	case 7005:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebConfig.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebConfigKey_uliKey
	case 7006:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebConfigKey.uliKey = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebConfigAit_uliOthers
	case 7007:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebConfigAit.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebConfigPattern_ucPatternCcdid
	case 7008:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebConfigPattern_usiPatternCols
	case 7009:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebConfigPattern_ucReserved
	case 7010:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_AebConfigPattern_usiPatternRows
	case 7011:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_VaspI2CControl_uliOthers
	case 7012:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_DacConfig1_uliOthers
	case 7013:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xDacConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_DacConfig2_uliOthers
	case 7014:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xDacConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_Reserved20_uliReserved
	case 7015:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xReserved20.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig1_ucTimeVccdOn
	case 7016:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig1_ucTimeVclkOn
	case 7017:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig1_ucTimeVan1On
	case 7018:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig1_ucTimeVan2On
	case 7019:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig2_ucTimeVan3On
	case 7020:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig2_ucTimeVccdOff
	case 7021:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig2_ucTimeVclkOff
	case 7022:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig2_ucTimeVan1Off
	case 7023:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig3_ucTimeVan2Off
	case 7024:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaCritCfg_PwrConfig3_ucTimeVan3Off
	case 7025:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Adc1Config1_uliOthers
	case 7200:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xAdc1Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Adc1Config2_uliOthers
	case 7201:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xAdc1Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Adc1Config3_uliOthers
	case 7202:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xAdc1Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Adc2Config1_uliOthers
	case 7203:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xAdc2Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Adc2Config2_uliOthers
	case 7204:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xAdc2Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Adc2Config3_uliOthers
	case 7205:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xAdc2Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Reserved118_uliReserved
	case 7206:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xReserved118.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_Reserved11C_uliReserved
	case 7207:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xReserved11C.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig1_uliOthers
	case 7208:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig2_uliOthers
	case 7209:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig3_uliOthers
	case 7210:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig4_uliOthers
	case 7211:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig4.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig5_uliOthers
	case 7212:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig5.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig6_uliOthers
	case 7213:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig6.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig7_uliReserved
	case 7214:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig7.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig8_uliReserved
	case 7215:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig8.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig9_ucReserved0
	case 7216:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig9_usiFtLoopCnt
	case 7217:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig9_bLt0Enabled
	case 7218:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig9_bReserved1
	case 7219:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig9_usiLt0LoopCnt
	case 7220:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig10_bLt1Enabled
	case 7221:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig10_bReserved0
	case 7222:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig10_usiLt1LoopCnt
	case 7223:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig10_bLt2Enabled
	case 7224:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig10_bReserved1
	case 7225:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig10_usiLt2LoopCnt
	case 7226:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig11_bLt3Enabled
	case 7227:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig11_bReserved
	case 7228:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig11.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig11_usiLt3LoopCnt
	case 7229:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig11_usiPixLoopCntWord1
	case 7230:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig12_usiPixLoopCntWord0
	case 7231:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig12_bPcEnabled
	case 7232:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig12_bReserved
	case 7233:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig12.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig12_usiPcLoopCnt
	case 7234:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig13_ucReserved0
	case 7235:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig13_usiInt1LoopCnt
	case 7236:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig13_ucReserved1
	case 7237:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig13_usiInt2LoopCnt
	case 7238:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaGenCfg_SeqConfig14_uliOthers
	case 7239:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaGenCfg.xSeqConfig14.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AebStatus_ucAebStatus
	case 7400:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAebStatus.ucAebStatus = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaHk_AebStatus_ucOthers0
	case 7401:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAebStatus.ucOthers0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb3AreaHk_AebStatus_usiOthers1
	case 7402:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAebStatus.usiOthers1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaHk_Timestamp1_uliTimestampDword1
	case 7403:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_Timestamp2_uliTimestampDword0
	case 7404:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTVaspL_uliOthers
	case 7405:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTVaspR_uliOthers
	case 7406:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTBiasP_uliOthers
	case 7407:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTHkP_uliOthers
	case 7408:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTTou1P_uliOthers
	case 7409:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTTou2P_uliOthers
	case 7410:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkVode_uliOthers
	case 7411:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkVodf_uliOthers
	case 7412:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkVrd_uliOthers
	case 7413:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkVog_uliOthers
	case 7414:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTCcd_uliOthers
	case 7415:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTRef1KMea_uliOthers
	case 7416:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataTRef649RMea_uliOthers
	case 7417:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkAnaN5V_uliOthers
	case 7418:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataSRef_uliOthers
	case 7419:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataSRef.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkCcdP31V_uliOthers
	case 7420:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkClkP15V_uliOthers
	case 7421:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkAnaP5V_uliOthers
	case 7422:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkAnaP3V3_uliOthers
	case 7423:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataHkDigP3V3_uliOthers
	case 7424:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_AdcRdDataAdcRefBuf2_uliOthers
	case 7425:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_VaspRdConfig_usiOthers
	case 7426:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xVaspRdConfig.usiOthers = (alt_u16) uliDefaultValue;
		break;
	// Aeb3AreaHk_RevisionId1_uliOthers
	case 7427:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xRevisionId1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb3AreaHk_RevisionId2_uliOthers
	case 7428:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[2].xRmapAebAreaHk.xRevisionId2.uliOthers = (alt_u32) uliDefaultValue;
		break;

	// Aeb4AreaCritCfg_AebControl_ucReserved0
	case 8000:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebControl.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebControl_ucNewState
	case 8001:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebControl.ucNewState = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebControl_bSetState
	case 8002:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebControl.bSetState = (bool) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebControl_bAebReset
	case 8003:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebControl.bAebReset = (bool) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebControl_uliOthers
	case 8004:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebConfig_uliOthers
	case 8005:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebConfig.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebConfigKey_uliKey
	case 8006:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebConfigKey.uliKey = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebConfigAit_uliOthers
	case 8007:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebConfigAit.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebConfigPattern_ucPatternCcdid
	case 8008:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebConfigPattern_usiPatternCols
	case 8009:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebConfigPattern_ucReserved
	case 8010:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_AebConfigPattern_usiPatternRows
	case 8011:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_VaspI2CControl_uliOthers
	case 8012:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_DacConfig1_uliOthers
	case 8013:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xDacConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_DacConfig2_uliOthers
	case 8014:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xDacConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_Reserved20_uliReserved
	case 8015:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xReserved20.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig1_ucTimeVccdOn
	case 8016:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig1_ucTimeVclkOn
	case 8017:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig1_ucTimeVan1On
	case 8018:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig1_ucTimeVan2On
	case 8019:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig2_ucTimeVan3On
	case 8020:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig2_ucTimeVccdOff
	case 8021:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig2_ucTimeVclkOff
	case 8022:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig2_ucTimeVan1Off
	case 8023:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig3_ucTimeVan2Off
	case 8024:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaCritCfg_PwrConfig3_ucTimeVan3Off
	case 8025:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Adc1Config1_uliOthers
	case 8200:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xAdc1Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Adc1Config2_uliOthers
	case 8201:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xAdc1Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Adc1Config3_uliOthers
	case 8202:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xAdc1Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Adc2Config1_uliOthers
	case 8203:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xAdc2Config1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Adc2Config2_uliOthers
	case 8204:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xAdc2Config2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Adc2Config3_uliOthers
	case 8205:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xAdc2Config3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Reserved118_uliReserved
	case 8206:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xReserved118.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_Reserved11C_uliReserved
	case 8207:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xReserved11C.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig1_uliOthers
	case 8208:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig2_uliOthers
	case 8209:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig3_uliOthers
	case 8210:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig4_uliOthers
	case 8211:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig4.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig5_uliOthers
	case 8212:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig5.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig6_uliOthers
	case 8213:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig6.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig7_uliReserved
	case 8214:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig7.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig8_uliReserved
	case 8215:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig8.uliReserved = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig9_ucReserved0
	case 8216:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig9_usiFtLoopCnt
	case 8217:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig9_bLt0Enabled
	case 8218:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig9_bReserved1
	case 8219:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig9.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig9_usiLt0LoopCnt
	case 8220:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig10_bLt1Enabled
	case 8221:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig10_bReserved0
	case 8222:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig10.bReserved0 = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig10_usiLt1LoopCnt
	case 8223:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig10_bLt2Enabled
	case 8224:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig10_bReserved1
	case 8225:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig10.bReserved1 = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig10_usiLt2LoopCnt
	case 8226:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig11_bLt3Enabled
	case 8227:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig11_bReserved
	case 8228:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig11.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig11_usiLt3LoopCnt
	case 8229:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig11_usiPixLoopCntWord1
	case 8230:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig12_usiPixLoopCntWord0
	case 8231:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0 = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig12_bPcEnabled
	case 8232:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig12_bReserved
	case 8233:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig12.bReserved = (bool) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig12_usiPcLoopCnt
	case 8234:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig13_ucReserved0
	case 8235:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig13_usiInt1LoopCnt
	case 8236:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig13_ucReserved1
	case 8237:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1 = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig13_usiInt2LoopCnt
	case 8238:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaGenCfg_SeqConfig14_uliOthers
	case 8239:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaGenCfg.xSeqConfig14.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AebStatus_ucAebStatus
	case 8400:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAebStatus.ucAebStatus = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaHk_AebStatus_ucOthers0
	case 8401:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAebStatus.ucOthers0 = (alt_u8) uliDefaultValue;
		break;
	// Aeb4AreaHk_AebStatus_usiOthers1
	case 8402:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAebStatus.usiOthers1 = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaHk_Timestamp1_uliTimestampDword1
	case 8403:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xTimestamp1.uliTimestampDword1 = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_Timestamp2_uliTimestampDword0
	case 8404:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xTimestamp2.uliTimestampDword0 = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTVaspL_uliOthers
	case 8405:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTVaspL.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTVaspR_uliOthers
	case 8406:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTVaspR.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTBiasP_uliOthers
	case 8407:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTBiasP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTHkP_uliOthers
	case 8408:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTHkP.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTTou1P_uliOthers
	case 8409:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTTou1P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTTou2P_uliOthers
	case 8410:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTTou2P.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkVode_uliOthers
	case 8411:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkVode.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkVodf_uliOthers
	case 8412:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkVodf.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkVrd_uliOthers
	case 8413:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkVrd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkVog_uliOthers
	case 8414:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkVog.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTCcd_uliOthers
	case 8415:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTCcd.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTRef1KMea_uliOthers
	case 8416:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataTRef649RMea_uliOthers
	case 8417:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkAnaN5V_uliOthers
	case 8418:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataSRef_uliOthers
	case 8419:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataSRef.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkCcdP31V_uliOthers
	case 8420:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkClkP15V_uliOthers
	case 8421:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkAnaP5V_uliOthers
	case 8422:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkAnaP3V3_uliOthers
	case 8423:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataHkDigP3V3_uliOthers
	case 8424:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_AdcRdDataAdcRefBuf2_uliOthers
	case 8425:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_VaspRdConfig_usiOthers
	case 8426:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xVaspRdConfig.usiOthers = (alt_u16) uliDefaultValue;
		break;
	// Aeb4AreaHk_RevisionId1_uliOthers
	case 8427:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xRevisionId1.uliOthers = (alt_u32) uliDefaultValue;
		break;
	// Aeb4AreaHk_RevisionId2_uliOthers
	case 8428:
		vxDeftFeeDefaults[ucFee].xRmapAebMem[3].xRmapAebAreaHk.xRevisionId2.uliOthers = (alt_u32) uliDefaultValue;
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
	case 10000:
		vxDeftNucDefaults.xEthernet.siPortPUS = (alt_u16) uliDefaultValue;
		break;
	/* DHCPv4Enable */
	case 10001:
		vxDeftNucDefaults.xEthernet.bDHCP = (bool) uliDefaultValue;
		break;
	/* IPv4Address */
	case 10002:
		vxDeftNucDefaults.xEthernet.ucIP[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucIP[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucIP[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucIP[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* IPv4Subnet */
	case 10003:
		vxDeftNucDefaults.xEthernet.ucSubNet[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucSubNet[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucSubNet[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucSubNet[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* IPv4Gateway */
	case 10004:
		vxDeftNucDefaults.xEthernet.ucGTW[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucGTW[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucGTW[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucGTW[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* IPv4DNS */
	case 10005:
		vxDeftNucDefaults.xEthernet.ucDNS[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucDNS[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucDNS[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.xEthernet.ucDNS[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* PusHpPid */
	case 10006:
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

		if ((DEFT_MEB_DEFS_ID_LOWER_LIM <= usiDefaultId) && (DEFT_FEE_DEFS_ID_LOWER_LIM > usiDefaultId)) {

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

	return (bStatus);
}

//! [public functions]

//! [private functions]
//! [private functions]
