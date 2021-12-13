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
volatile bool vbDeftDefaultsReceived = FALSE;
volatile alt_u32 vuliDeftExpectedDefaultsQtd = 1;
volatile alt_u32 vuliDeftReceivedDefaultsQtd = 0;
volatile TDeftMebDefaults vxDeftMebDefaults;
volatile TDeftFeeDefaults vxDeftFeeDefaults[N_OF_FastFEE];
volatile TDeftNucDefaults vxDeftNucDefaults;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
void vDeftInitMebDefault() {

	vxDeftMebDefaults.pxGenSimulationParams = &(xDefaults);

	*(vxDeftMebDefaults.pxGenSimulationParams) = cxDefaultsGenSimulationParams;

}

bool bDeftInitFeeDefault(alt_u8 ucFee) {
	bool bStatus = FALSE;
	unsigned char ucAeb;

	if (N_OF_FastFEE > ucFee) {

		vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams = &(xConfSpw[ucFee]);

		for (ucAeb = 0; N_OF_CCD > ucAeb; ucAeb++) {
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg = cxDefaultsRmapDebAreaCritCfg;
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg = cxDefaultsRmapDebAreaGenCfg;
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk = cxDefaultsRmapDebAreaHk;
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[ucAeb] = cxDefaultsRmapAebAreaCritCfg;
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[ucAeb] = cxDefaultsRmapAebAreaGenCfg;
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[ucAeb] = cxDefaultsRmapAebAreaHk;
		}

		*(vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams) = cxDefaultsSpwInterfaceParams;

		bStatus = TRUE;
	}

	return (bStatus);
}

void vDeftInitNucDefault() {

	vxDeftNucDefaults.pxEthInterfaceParams = &(xConfEth);

	*(vxDeftNucDefaults.pxEthInterfaceParams) = cxDefaultsEthInterfaceParams;

}

bool bDeftSetMebDefaultValues(alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = TRUE;

	vxDeftMebDefaults.pxGenSimulationParams = &(xDefaults);

	switch (usiDefaultId) {

		/* CCD Serial Overscan Columns */
		case eDeftMebOverScanSerialId:
			vxDeftMebDefaults.pxGenSimulationParams->usiOverScanSerial = (alt_u16) uliDefaultValue;
			break;
		/* CCD Serial Prescan Columns */
		case eDeftMebPreScanSerialId:
			vxDeftMebDefaults.pxGenSimulationParams->usiPreScanSerial = (alt_u16) uliDefaultValue;
			break;
		/* CCD Parallel Overscan Lines */
		case eDeftMebOLNId:
			vxDeftMebDefaults.pxGenSimulationParams->usiOLN = (alt_u16) uliDefaultValue;
			break;
		/* CCD Columns */
		case eDeftMebColsId:
			vxDeftMebDefaults.pxGenSimulationParams->usiCols = (alt_u16) uliDefaultValue;
			break;
		/* CCD Image Lines */
		case eDeftMebRowsId:
			vxDeftMebDefaults.pxGenSimulationParams->usiRows = (alt_u16) uliDefaultValue;
			break;
		/* SimuCam Exposure Period [ms] */
		case eDeftMebExposurePeriodId:
			vxDeftMebDefaults.pxGenSimulationParams->usiExposurePeriod = (alt_u16) uliDefaultValue;
			break;
		/* Output Buffer Overflow Enable */
		case eDeftMebBufferOverflowEnId:
			vxDeftMebDefaults.pxGenSimulationParams->bBufferOverflowEn = (bool) uliDefaultValue;
			break;
		/* CCD Start Readout Delay [ms] */
		case eDeftMebStartDelayId:
			vxDeftMebDefaults.pxGenSimulationParams->ulStartDelay = (alt_u32) uliDefaultValue;
			break;
		/* CCD Line Skip Delay [ns] */
		case eDeftMebSkipDelayId:
			vxDeftMebDefaults.pxGenSimulationParams->ulSkipDelay = (alt_u32) uliDefaultValue;
			break;
		/* CCD Line Transfer Delay [ns] */
		case eDeftMebLineDelayId:
			vxDeftMebDefaults.pxGenSimulationParams->ulLineDelay = (alt_u32) uliDefaultValue;
			break;
		/* CCD ADC And Pixel Transfer Delay [ns] */
		case eDeftMebADCPixelDelayId:
			vxDeftMebDefaults.pxGenSimulationParams->ulADCPixelDelay = (alt_u32) uliDefaultValue;
			break;
		/* Serial Messages Debug Level */
		case eDeftMebDebugLevelId:
			vxDeftMebDefaults.pxGenSimulationParams->ucDebugLevel = (alt_u8) uliDefaultValue;
			break;
		/* FEEs Guard Delay [ms] */
		case eDeftMebGuardFeeDelayId:
			vxDeftMebDefaults.pxGenSimulationParams->usiGuardFEEDelay = (alt_u16) uliDefaultValue;
			break;
		/* SimuCam Synchronism Source (0 = Internal / 1 = External) */
		case eDeftMebSyncSourceId:
			vxDeftMebDefaults.pxGenSimulationParams->ucSyncSource = (alt_u8) uliDefaultValue;
			break;
		/* Activate the backup SpaceWire channels for the F-FEE Simulation entity */
		case eDeftMebUseBackupSpwChannelsId:
			vxDeftMebDefaults.pxGenSimulationParams->bUseBackupSpwChannels = (bool) uliDefaultValue;
			break;
		default:
			bStatus = FALSE;
			break;
	}

	return (bStatus);
}

bool bDeftSetFeeDefaultValues(alt_u8 ucFee, alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = TRUE;

	switch (usiDefaultId) {
		
		/* SpaceWire link set as Link Start */
		case eDeftSpwSpwLinkStartId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->bSpwLinkStart                     = (bool) uliDefaultValue;
			break;
		/* SpaceWire link set as Link Auto-Start */
		case eDeftSpwSpwLinkAutostartId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->bSpwLinkAutostart                 = (bool) uliDefaultValue;
			break;
		/* SpaceWire Link Speed [Mhz] */
		case eDeftSpwSpwLinkSpeedId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->ucSpwLinkSpeed                    = (alt_u8) uliDefaultValue;
			break;
		/* Timecode Transmission Enable */
		case eDeftSpwTimeCodeTransmissionEnId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->bTimeCodeTransmissionEn           = (bool) uliDefaultValue;
			break;
		/* RMAP Logical Address */
		case eDeftSpwLogicalAddrId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->ucLogicalAddr                     = (alt_u8) uliDefaultValue;
			break;
		/* RMAP Key */
		case eDeftSpwRmapKeyId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->ucRmapKey                         = (alt_u8) uliDefaultValue;
			break;
		/* Data Packet Protocol ID */
		case eDeftSpwDataProtIdId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->ucDataProtId                      = (alt_u8) uliDefaultValue;
			break;
		/* Data Packet Target Logical Address */
		case eDeftSpwDpuLogicalAddrId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->ucDpuLogicalAddr                  = (alt_u8) uliDefaultValue;
			break;
		/* Window Mode Data packet length [B] */
		case eDeftSpwWinSpwPLengthId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->usiWinSpwPLength                  = (alt_u16) uliDefaultValue;
			break;
		/* Full-Image Mode Data packet length [B] */
		case eDeftSpwFullSpwPLengthId:
			vxDeftFeeDefaults[ucFee].pxSpwInterfaceParams->usiFullSpwPLength                 = (alt_u16) uliDefaultValue;
			break;

		/* F-FEE DEB Critical Configuration Area Register "DTC_AEB_ONOFF", "AEB_IDX4" Field */
		case eDeftFfeeDebAreaCritCfgDtcAebOnoffAebIdx4Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx4               = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Critical Configuration Area Register "DTC_AEB_ONOFF", "AEB_IDX3" Field */
		case eDeftFfeeDebAreaCritCfgDtcAebOnoffAebIdx3Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3               = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Critical Configuration Area Register "DTC_AEB_ONOFF", "AEB_IDX2" Field */
		case eDeftFfeeDebAreaCritCfgDtcAebOnoffAebIdx2Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2               = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Critical Configuration Area Register "DTC_AEB_ONOFF", "AEB_IDX1" Field */
		case eDeftFfeeDebAreaCritCfgDtcAebOnoffAebIdx1Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1               = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_0", "PFDFC" Field */
		case eDeftFfeeDebAreaCritCfgDtcPllReg0PfdfcId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg.xDtcPllReg0.bPfdfc                  = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_0", "GTME" Field */
		case eDeftFfeeDebAreaCritCfgDtcPllReg0GtmeId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg.xDtcPllReg0.bGtme                   = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_0", "HOLDTR" Field */
		case eDeftFfeeDebAreaCritCfgDtcPllReg0HoldtrId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg.xDtcPllReg0.bHoldtr                 = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_0", "HOLDF" Field */
		case eDeftFfeeDebAreaCritCfgDtcPllReg0HoldfId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg.xDtcPllReg0.bHoldf                  = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_0", FOFF, "LOCK1", "LOCK0", "LOCKW1", "LOCKW0", "C1", "C0" Fields */
		case eDeftFfeeDebAreaCritCfgDtcPllReg0OthersId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg.xDtcPllReg0.ucOthers                = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_1", "HOLD", "RESET", "RESHOL", "PD", "Y4MUX", "Y3MUX", "Y2MUX", "Y1MUX", "Y0MUX", "FB_MUX", "PFD", "CP_current", "PRECP", "CP_DIR", "C1", "C0" Fields */
		case eDeftFfeeDebAreaCritCfgDtcPllReg1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg.xDtcPllReg1.uliOthers               = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_2", 90DIV8, "90DIV4", "ADLOCK", "SXOIREF", "SREF", "Output_Y4_Mode", "Output_Y3_Mode", "Output_Y2_Mode", "Output_Y1_Mode", "Output_Y0_Mode", "OUTSEL4", "OUTSEL3", "OUTSEL2", "OUTSEL1", "OUTSEL0", "C1", "C0" Fields */
		case eDeftFfeeDebAreaCritCfgDtcPllReg2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg.xDtcPllReg2.uliOthers               = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_3", REFDEC, "MANAUT", "DLYN", "DLYM", "N", "M", "C1", "C0" Fields */
		case eDeftFfeeDebAreaCritCfgDtcPllReg3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg.xDtcPllReg3.uliOthers               = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE DEB Critical Configuration Area Register "DTC_FEE_MOD", "OPER_MOD" Field */
		case eDeftFfeeDebAreaCritCfgDtcFeeModOperModId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod                = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB Critical Configuration Area Register "DTC_IMM_ONMOD", "IMM_ON" Field */
		case eDeftFfeeDebAreaCritCfgDtcImmOnmodImmOnId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaCritCfg.xDtcImmOnmod.bImmOn                 = (bool) uliDefaultValue;
			break;

		/* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T7_IN_MOD" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcInModT7InModId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod               = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T6_IN_MOD" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcInModT6InModId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod               = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T5_IN_MOD" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcInModT5InModId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod               = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T4_IN_MOD" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcInModT4InModId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod               = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T3_IN_MOD" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcInModT3InModId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod               = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T2_IN_MOD" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcInModT2InModId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod               = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T1_IN_MOD" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcInModT1InModId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod               = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T0_IN_MOD" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcInModT0InModId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod               = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_WDW_SIZ", "W_SIZ_X" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcWdwSizWSizXId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX                = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_WDW_SIZ", "W_SIZ_Y" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcWdwSizWSizYId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY                = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_IDX_4" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwIdx4Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4             = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_LEN_4" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwLen4Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4             = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_IDX_3" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwIdx3Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3             = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_LEN_3" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwLen3Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3             = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_IDX_2" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwIdx2Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2             = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_LEN_2" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwLen2Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2             = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_IDX_1" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwIdx1Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1             = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_LEN_1" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwLen1Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1             = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_OVS_DEB", "OVS_LIN_DEB" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcOvsDebOvsLinDebId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcOvsDeb.ucOvsLinDeb            = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_SIZ_DEB", "NB_LIN_DEB" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcSizDebNbLinDebId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcSizDeb.usiNbLinDeb            = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_SIZ_DEB", "NB_PIX_DEB" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcSizDebNbPixDebId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcSizDeb.usiNbPixDeb            = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_TRG_25S", "2_5S_N_CYC" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcTrg25SN25SNCycId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc             = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_SEL_TRG", "TRG_SRC" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcSelTrgTrgSrcId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcSelTrg.bTrgSrc                = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_FRM_CNT", "PSET_FRM_CNT" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcFrmCntPsetFrmCntId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt          = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_SEL_SYN", "SYN_FRQ" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcSelSynSynFrqId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcSelSyn.bSynFrq                = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_RST_CPS", "RST_SPW" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcRstCpsRstSpwId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstSpw                = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_RST_CPS", "RST_WDG" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcRstCpsRstWdgId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstWdg                = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_25S_DLY", "25S_DLY" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtc25SDlyN25SDlyId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_TMOD_CONF", "RESERVED" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcTmodConfReservedId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE DEB General Configuration Area Register "DTC_SPW_CFG", "TIMECODE" Field */
		case eDeftFfeeDebAreaGenCfgCfgDtcSpwCfgTimecodeId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode             = (alt_u8) uliDefaultValue;
			break;

		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "OPER_MOD" Field */
		case eDeftFfeeDebAreaHkDebStatusOperModId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebStatus.ucOperMod                     = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "EDAC_LIST_CORR_ERR" Field */
		case eDeftFfeeDebAreaHkDebStatusEdacListCorrErrId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr             = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "EDAC_LIST_UNCORR_ERR" Field */
		case eDeftFfeeDebAreaHkDebStatusEdacListUncorrErrId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr           = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "NB_PLLPERIOD", "PLL_REF", "PLL_VCXO", "PLL_LOCK" Fields */
		case eDeftFfeeDebAreaHkDebStatusOthersId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebStatus.ucOthers                      = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "VDIG_AEB_4" Field */
		case eDeftFfeeDebAreaHkDebStatusVdigAeb4Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebStatus.bVdigAeb4                     = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "VDIG_AEB_3" Field */
		case eDeftFfeeDebAreaHkDebStatusVdigAeb3Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebStatus.bVdigAeb3                     = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "VDIG_AEB_2" Field */
		case eDeftFfeeDebAreaHkDebStatusVdigAeb2Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebStatus.bVdigAeb2                     = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "VDIG_AEB_1" Field */
		case eDeftFfeeDebAreaHkDebStatusVdigAeb1Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebStatus.bVdigAeb1                     = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "WDW_LIST_CNT_OVF" Field */
		case eDeftFfeeDebAreaHkDebStatusWdwListCntOvfId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf               = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "WDG" Field */
		case eDeftFfeeDebAreaHkDebStatusWdgId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebStatus.bWdg                          = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_8" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList8Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebOvf.bRowActList8                     = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_7" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList7Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebOvf.bRowActList7                     = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_6" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList6Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebOvf.bRowActList6                     = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_5" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList5Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebOvf.bRowActList5                     = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_4" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList4Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebOvf.bRowActList4                     = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_3" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList3Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebOvf.bRowActList3                     = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_2" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList2Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebOvf.bRowActList2                     = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_1" Field */
		case eDeftFfeeDebAreaHkDebOvfRowActList1Id:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebOvf.bRowActList1                     = (bool) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_AHK1", "VIO" Field */
		case eDeftFfeeDebAreaHkDebAhk1VioId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebAhk1.usiVio                          = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_AHK2", "VCOR" Field */
		case eDeftFfeeDebAreaHkDebAhk2VcorId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebAhk2.usiVcor                         = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_AHK2", "VLVD" Field */
		case eDeftFfeeDebAreaHkDebAhk2VlvdId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebAhk2.usiVlvd                         = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE DEB Housekeeping Area Register "DEB_AHK1", "DEB_TEMP" Field */
		case eDeftFfeeDebAreaHkDebAhk1DebTempId:
			vxDeftFeeDefaults[ucFee].xRmapDebAreaHk.xDebAhk1.usiDebTemp                      = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONTROL", "RESERVED" Field */
		case eDeftFfeeAeb1AreaCritCfgAebControlReserved0Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xAebControl.ucReserved           = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONTROL", "NEW_STATE" Field */
		case eDeftFfeeAeb1AreaCritCfgAebControlNewStateId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xAebControl.ucNewState           = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONTROL", "SET_STATE" Field */
		case eDeftFfeeAeb1AreaCritCfgAebControlSetStateId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xAebControl.bSetState            = (bool) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONTROL", "AEB_RESET" Field */
		case eDeftFfeeAeb1AreaCritCfgAebControlAebResetId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xAebControl.bAebReset            = (bool) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONTROL", RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields */
		case eDeftFfeeAeb1AreaCritCfgAebControlOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xAebControl.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONFIG", RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields */
		case eDeftFfeeAeb1AreaCritCfgAebConfigOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xAebConfig.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONFIG_KEY", "KEY" Field */
		case eDeftFfeeAeb1AreaCritCfgAebConfigKeyKeyId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xAebConfigKey.uliKey             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONFIG_AIT", "OVERRIDE_SW", "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields */
		case eDeftFfeeAeb1AreaCritCfgAebConfigAitOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xAebConfigAit.uliOthers          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_CCDID" Field */
		case eDeftFfeeAeb1AreaCritCfgAebConfigPatternPatternCcdidId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xAebConfigPattern.ucPatternCcdid = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_COLS" Field */
		case eDeftFfeeAeb1AreaCritCfgAebConfigPatternPatternColsId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xAebConfigPattern.usiPatternCols = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "RESERVED" Field */
		case eDeftFfeeAeb1AreaCritCfgAebConfigPatternReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xAebConfigPattern.ucReserved     = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_ROWS" Field */
		case eDeftFfeeAeb1AreaCritCfgAebConfigPatternPatternRowsId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xAebConfigPattern.usiPatternRows = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "VASP_I2C_CONTROL", VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields */
		case eDeftFfeeAeb1AreaCritCfgVaspI2CControlOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xVaspI2CControl.uliOthers        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "DAC_CONFIG_1", RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields */
		case eDeftFfeeAeb1AreaCritCfgDacConfig1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xDacConfig1.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "DAC_CONFIG_2", RESERVED_0, "DAC_VOD", "RESERVED_1" Fields */
		case eDeftFfeeAeb1AreaCritCfgDacConfig2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xDacConfig2.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "RESERVED_20", "RESERVED" Field */
		case eDeftFfeeAeb1AreaCritCfgReserved20ReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xReserved20.uliReserved          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCCD_ON" Field */
		case eDeftFfeeAeb1AreaCritCfgPwrConfig1TimeVccdOnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xPwrConfig1.ucTimeVccdOn         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCLK_ON" Field */
		case eDeftFfeeAeb1AreaCritCfgPwrConfig1TimeVclkOnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xPwrConfig1.ucTimeVclkOn         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN1_ON" Field */
		case eDeftFfeeAeb1AreaCritCfgPwrConfig1TimeVan1OnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xPwrConfig1.ucTimeVan1On         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN2_ON" Field */
		case eDeftFfeeAeb1AreaCritCfgPwrConfig1TimeVan2OnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xPwrConfig1.ucTimeVan2On         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN3_ON" Field */
		case eDeftFfeeAeb1AreaCritCfgPwrConfig2TimeVan3OnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xPwrConfig2.ucTimeVan3On         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCCD_OFF" Field */
		case eDeftFfeeAeb1AreaCritCfgPwrConfig2TimeVccdOffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xPwrConfig2.ucTimeVccdOff        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCLK_OFF" Field */
		case eDeftFfeeAeb1AreaCritCfgPwrConfig2TimeVclkOffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xPwrConfig2.ucTimeVclkOff        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN1_OFF" Field */
		case eDeftFfeeAeb1AreaCritCfgPwrConfig2TimeVan1OffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xPwrConfig2.ucTimeVan1Off        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN2_OFF" Field */
		case eDeftFfeeAeb1AreaCritCfgPwrConfig3TimeVan2OffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xPwrConfig3.ucTimeVan2Off        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN3_OFF" Field */
		case eDeftFfeeAeb1AreaCritCfgPwrConfig3TimeVan3OffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[0].xPwrConfig3.ucTimeVan3Off        = (alt_u8) uliDefaultValue;
			break;

		/* F-FEE AEB 1 General Configuration Area Register "ADC1_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
		case eDeftFfeeAeb1AreaGenCfgAdc1Config1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xAdc1Config1.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "ADC1_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
		case eDeftFfeeAeb1AreaGenCfgAdc1Config2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xAdc1Config2.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "ADC1_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
		case eDeftFfeeAeb1AreaGenCfgAdc1Config3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xAdc1Config3.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "ADC2_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
		case eDeftFfeeAeb1AreaGenCfgAdc2Config1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xAdc2Config1.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "ADC2_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
		case eDeftFfeeAeb1AreaGenCfgAdc2Config2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xAdc2Config2.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "ADC2_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
		case eDeftFfeeAeb1AreaGenCfgAdc2Config3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xAdc2Config3.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "RESERVED_118", "RESERVED" Field */
		case eDeftFfeeAeb1AreaGenCfgReserved118ReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xReserved118.uliReserved          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "RESERVED_11C", "RESERVED" Field */
		case eDeftFfeeAeb1AreaGenCfgReserved11CReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xReserved11C.uliReserved          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_1", "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig1.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_2", ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig2.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_3", RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig3.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_4", RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig4OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig4.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_5", SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig5OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig5.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_6", "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig6OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig6.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_14", "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig14OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig14.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_7", "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig7OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig7.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_8", "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig8OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig8.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_9", "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig9OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig9.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_10", "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig10OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig10.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_11", "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig11OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig11.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_12", "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig12OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig12.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_13", "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig13OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig13.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_15", "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig15OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig15.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_16", "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig16OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig16.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_17", "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig17OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig17.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_18", "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig18OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig18.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_19", "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig19OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig19.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_20", "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig20OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig20.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_21", "RESERVED" Field */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig21OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig21.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_22", "RESERVED" Field */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig22OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig22.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_23", "RESERVED" Field */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig23OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig23.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_24", "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig24OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig24.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_25", "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig25OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig25.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_26", "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig26OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig26.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_27", "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig27OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig27.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_28", "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig28OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig28.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_29", "RESERVED" Field */
		case eDeftFfeeAeb1AreaGenCfgSeqConfig29OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[0].xSeqConfig29.uliOthers            = (alt_u32) uliDefaultValue;
			break;

		/* F-FEE AEB 1 Housekeeping Area Register "AEB_STATUS", "AEB_STATUS" Field */
		case eDeftFfeeAeb1AreaHkAebStatusAebStatusId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAebStatus.ucAebStatus                = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "AEB_STATUS", VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields */
		case eDeftFfeeAeb1AreaHkAebStatusOthers0Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAebStatus.ucOthers0                  = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "AEB_STATUS", DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields */
		case eDeftFfeeAeb1AreaHkAebStatusOthers1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAebStatus.usiOthers1                 = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "TIMESTAMP_1", "TIMESTAMP_DWORD_1" Field */
		case eDeftFfeeAeb1AreaHkTimestamp1TimestampDword1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xTimestamp1.uliTimestampDword1        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "TIMESTAMP_2", "TIMESTAMP_DWORD_0" Field */
		case eDeftFfeeAeb1AreaHkTimestamp2TimestampDword0Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xTimestamp2.uliTimestampDword0        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_VASP_L", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTVaspLOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataTVaspL.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_VASP_R", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTVaspROthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataTVaspR.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTBiasPOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataTBiasP.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_HK_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTHkPOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataTHkP.uliOthers              = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTTou1POthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataTTou1P.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTTou2POthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataTTou2P.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_VODE", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkVodeOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataHkVode.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_VODF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkVodfOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataHkVodf.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_VRD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkVrdOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataHkVrd.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_VOG", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkVogOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataHkVog.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_CCD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTCcdOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataTCcd.uliOthers              = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTRef1KMeaOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataTRef1KMea.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataTRef649RMeaOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataTRef649RMea.uliOthers       = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkAnaN5VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataHkAnaN5V.uliOthers          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_S_REF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataSRefOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataSRef.uliOthers              = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkCcdP31VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataHkCcdP31V.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkClkP15VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataHkClkP15V.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkAnaP5VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataHkAnaP5V.uliOthers          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkAnaP3V3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataHkAnaP3V3.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataHkDigP3V3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataHkDigP3V3.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields */
		case eDeftFfeeAeb1AreaHkAdcRdDataAdcRefBuf2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdcRdDataAdcRefBuf2.uliOthers        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "VASP_RD_CONFIG", VASP1_READ_DATA, "VASP2_READ_DATA" Fields */
		case eDeftFfeeAeb1AreaHkVaspRdConfigOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xVaspRdConfig.usiOthers               = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "REVISION_ID_1", FPGA_VERSION, "FPGA_DATE" Fields */
		case eDeftFfeeAeb1AreaHkRevisionId1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xRevisionId1.uliOthers                = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "REVISION_ID_2", FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields */
		case eDeftFfeeAeb1AreaHkRevisionId2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xRevisionId2.uliOthers                = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "AEB_STATUS", "VASP2_DELAYED", "VASP1_DELAYED", "VASP2_ERROR", "VASP1_ERROR" Fields */
		case eDeftFfeeAeb1AreaHkAebStatusucOthers2Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAebStatus.ucOthers2                  = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC1_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
		case eDeftFfeeAeb1AreaHkAdc1RdConfig3ucOthers1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdc1RdConfig3.ucOthers1              = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 1 Housekeeping Area Register "ADC2_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
		case eDeftFfeeAeb1AreaHkAdc2RdConfig3ucOthers1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[0].xAdc2RdConfig3.ucOthers1              = (alt_u8) uliDefaultValue;
			break;

		/* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONTROL", "RESERVED" Field */
		case eDeftFfeeAeb2AreaCritCfgAebControlReserved0Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xAebControl.ucReserved           = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONTROL", "NEW_STATE" Field */
		case eDeftFfeeAeb2AreaCritCfgAebControlNewStateId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xAebControl.ucNewState           = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONTROL", "SET_STATE" Field */
		case eDeftFfeeAeb2AreaCritCfgAebControlSetStateId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xAebControl.bSetState            = (bool) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONTROL", "AEB_RESET" Field */
		case eDeftFfeeAeb2AreaCritCfgAebControlAebResetId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xAebControl.bAebReset            = (bool) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONTROL", RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields */
		case eDeftFfeeAeb2AreaCritCfgAebControlOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xAebControl.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONFIG", RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields */
		case eDeftFfeeAeb2AreaCritCfgAebConfigOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xAebConfig.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONFIG_KEY", "KEY" Field */
		case eDeftFfeeAeb2AreaCritCfgAebConfigKeyKeyId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xAebConfigKey.uliKey             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONFIG_AIT", "OVERRIDE_SW", "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields */
		case eDeftFfeeAeb2AreaCritCfgAebConfigAitOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xAebConfigAit.uliOthers          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_CCDID" Field */
		case eDeftFfeeAeb2AreaCritCfgAebConfigPatternPatternCcdidId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xAebConfigPattern.ucPatternCcdid = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_COLS" Field */
		case eDeftFfeeAeb2AreaCritCfgAebConfigPatternPatternColsId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xAebConfigPattern.usiPatternCols = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "RESERVED" Field */
		case eDeftFfeeAeb2AreaCritCfgAebConfigPatternReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xAebConfigPattern.ucReserved     = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_ROWS" Field */
		case eDeftFfeeAeb2AreaCritCfgAebConfigPatternPatternRowsId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xAebConfigPattern.usiPatternRows = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "VASP_I2C_CONTROL", VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields */
		case eDeftFfeeAeb2AreaCritCfgVaspI2CControlOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xVaspI2CControl.uliOthers        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "DAC_CONFIG_1", RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields */
		case eDeftFfeeAeb2AreaCritCfgDacConfig1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xDacConfig1.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "DAC_CONFIG_2", RESERVED_0, "DAC_VOD", "RESERVED_1" Fields */
		case eDeftFfeeAeb2AreaCritCfgDacConfig2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xDacConfig2.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "RESERVED_20", "RESERVED" Field */
		case eDeftFfeeAeb2AreaCritCfgReserved20ReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xReserved20.uliReserved          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCCD_ON" Field */
		case eDeftFfeeAeb2AreaCritCfgPwrConfig1TimeVccdOnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xPwrConfig1.ucTimeVccdOn         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCLK_ON" Field */
		case eDeftFfeeAeb2AreaCritCfgPwrConfig1TimeVclkOnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xPwrConfig1.ucTimeVclkOn         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN1_ON" Field */
		case eDeftFfeeAeb2AreaCritCfgPwrConfig1TimeVan1OnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xPwrConfig1.ucTimeVan1On         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN2_ON" Field */
		case eDeftFfeeAeb2AreaCritCfgPwrConfig1TimeVan2OnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xPwrConfig1.ucTimeVan2On         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN3_ON" Field */
		case eDeftFfeeAeb2AreaCritCfgPwrConfig2TimeVan3OnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xPwrConfig2.ucTimeVan3On         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCCD_OFF" Field */
		case eDeftFfeeAeb2AreaCritCfgPwrConfig2TimeVccdOffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xPwrConfig2.ucTimeVccdOff        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCLK_OFF" Field */
		case eDeftFfeeAeb2AreaCritCfgPwrConfig2TimeVclkOffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xPwrConfig2.ucTimeVclkOff        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN1_OFF" Field */
		case eDeftFfeeAeb2AreaCritCfgPwrConfig2TimeVan1OffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xPwrConfig2.ucTimeVan1Off        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN2_OFF" Field */
		case eDeftFfeeAeb2AreaCritCfgPwrConfig3TimeVan2OffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xPwrConfig3.ucTimeVan2Off        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN3_OFF" Field */
		case eDeftFfeeAeb2AreaCritCfgPwrConfig3TimeVan3OffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[1].xPwrConfig3.ucTimeVan3Off        = (alt_u8) uliDefaultValue;
			break;

		/* F-FEE AEB 2 General Configuration Area Register "ADC1_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
		case eDeftFfeeAeb2AreaGenCfgAdc1Config1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xAdc1Config1.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "ADC1_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
		case eDeftFfeeAeb2AreaGenCfgAdc1Config2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xAdc1Config2.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "ADC1_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
		case eDeftFfeeAeb2AreaGenCfgAdc1Config3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xAdc1Config3.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "ADC2_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
		case eDeftFfeeAeb2AreaGenCfgAdc2Config1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xAdc2Config1.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "ADC2_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
		case eDeftFfeeAeb2AreaGenCfgAdc2Config2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xAdc2Config2.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "ADC2_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
		case eDeftFfeeAeb2AreaGenCfgAdc2Config3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xAdc2Config3.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "RESERVED_118", "RESERVED" Field */
		case eDeftFfeeAeb2AreaGenCfgReserved118ReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xReserved118.uliReserved          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "RESERVED_11C", "RESERVED" Field */
		case eDeftFfeeAeb2AreaGenCfgReserved11CReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xReserved11C.uliReserved          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_1", "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig1.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_2", ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig2.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_3", RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig3.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_4", RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig4OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig4.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_5", SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig5OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig5.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_6", "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig6OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig6.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_14", "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig14OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig14.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_7", "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig7OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig7.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_8", "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig8OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig8.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_9", "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig9OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig9.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_10", "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig10OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig10.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_11", "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig11OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig11.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_12", "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig12OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig12.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_13", "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig13OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig13.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_15", "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig15OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig15.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_16", "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig16OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig16.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_17", "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig17OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig17.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_18", "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig18OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig18.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_19", "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig19OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig19.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_20", "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig20OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig20.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_21", "RESERVED" Field */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig21OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig21.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_22", "RESERVED" Field */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig22OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig22.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_23", "RESERVED" Field */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig23OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig23.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_24", "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig24OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig24.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_25", "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig25OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig25.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_26", "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig26OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig26.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_27", "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig27OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig27.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_28", "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig28OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig28.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_29", "RESERVED" Field */
		case eDeftFfeeAeb2AreaGenCfgSeqConfig29OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[1].xSeqConfig29.uliOthers            = (alt_u32) uliDefaultValue;
			break;

		/* F-FEE AEB 2 Housekeeping Area Register "AEB_STATUS", "AEB_STATUS" Field */
		case eDeftFfeeAeb2AreaHkAebStatusAebStatusId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAebStatus.ucAebStatus                = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "AEB_STATUS", VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields */
		case eDeftFfeeAeb2AreaHkAebStatusOthers0Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAebStatus.ucOthers0                  = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "AEB_STATUS", DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields */
		case eDeftFfeeAeb2AreaHkAebStatusOthers1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAebStatus.usiOthers1                 = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "TIMESTAMP_1", "TIMESTAMP_DWORD_1" Field */
		case eDeftFfeeAeb2AreaHkTimestamp1TimestampDword1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xTimestamp1.uliTimestampDword1        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "TIMESTAMP_2", "TIMESTAMP_DWORD_0" Field */
		case eDeftFfeeAeb2AreaHkTimestamp2TimestampDword0Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xTimestamp2.uliTimestampDword0        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_VASP_L", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTVaspLOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataTVaspL.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_VASP_R", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTVaspROthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataTVaspR.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTBiasPOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataTBiasP.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_HK_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTHkPOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataTHkP.uliOthers              = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTTou1POthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataTTou1P.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTTou2POthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataTTou2P.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_VODE", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkVodeOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataHkVode.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_VODF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkVodfOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataHkVodf.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_VRD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkVrdOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataHkVrd.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_VOG", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkVogOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataHkVog.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_CCD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTCcdOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataTCcd.uliOthers              = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTRef1KMeaOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataTRef1KMea.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataTRef649RMeaOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataTRef649RMea.uliOthers       = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkAnaN5VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataHkAnaN5V.uliOthers          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_S_REF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataSRefOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataSRef.uliOthers              = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkCcdP31VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataHkCcdP31V.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkClkP15VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataHkClkP15V.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkAnaP5VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataHkAnaP5V.uliOthers          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkAnaP3V3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataHkAnaP3V3.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataHkDigP3V3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataHkDigP3V3.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields */
		case eDeftFfeeAeb2AreaHkAdcRdDataAdcRefBuf2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdcRdDataAdcRefBuf2.uliOthers        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "VASP_RD_CONFIG", VASP1_READ_DATA, "VASP2_READ_DATA" Fields */
		case eDeftFfeeAeb2AreaHkVaspRdConfigOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xVaspRdConfig.usiOthers               = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "REVISION_ID_1", FPGA_VERSION, "FPGA_DATE" Fields */
		case eDeftFfeeAeb2AreaHkRevisionId1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xRevisionId1.uliOthers                = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "REVISION_ID_2", FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields */
		case eDeftFfeeAeb2AreaHkRevisionId2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xRevisionId2.uliOthers                = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "AEB_STATUS", "VASP2_DELAYED", "VASP1_DELAYED", "VASP2_ERROR", "VASP1_ERROR" Fields */
		case eDeftFfeeAeb2AreaHkAebStatusucOthers2Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAebStatus.ucOthers2                  = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC1_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
		case eDeftFfeeAeb2AreaHkAdc1RdConfig3ucOthers1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdc1RdConfig3.ucOthers1              = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 2 Housekeeping Area Register "ADC2_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
		case eDeftFfeeAeb2AreaHkAdc2RdConfig3ucOthers1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[1].xAdc2RdConfig3.ucOthers1              = (alt_u8) uliDefaultValue;
			break;

		/* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONTROL", "RESERVED" Field */
		case eDeftFfeeAeb3AreaCritCfgAebControlReserved0Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xAebControl.ucReserved           = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONTROL", "NEW_STATE" Field */
		case eDeftFfeeAeb3AreaCritCfgAebControlNewStateId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xAebControl.ucNewState           = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONTROL", "SET_STATE" Field */
		case eDeftFfeeAeb3AreaCritCfgAebControlSetStateId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xAebControl.bSetState            = (bool) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONTROL", "AEB_RESET" Field */
		case eDeftFfeeAeb3AreaCritCfgAebControlAebResetId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xAebControl.bAebReset            = (bool) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONTROL", RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields */
		case eDeftFfeeAeb3AreaCritCfgAebControlOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xAebControl.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONFIG", RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields */
		case eDeftFfeeAeb3AreaCritCfgAebConfigOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xAebConfig.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONFIG_KEY", "KEY" Field */
		case eDeftFfeeAeb3AreaCritCfgAebConfigKeyKeyId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xAebConfigKey.uliKey             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Critical Configuration Area Register "AEB_CONFIG_AIT", "OVERRIDE_SW", "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields */
		case eDeftFfeeAeb3AreaCritCfgAebConfigAitOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xAebConfigAit.uliOthers          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_CCDID" Field */
		case eDeftFfeeAeb3AreaCritCfgAebConfigPatternPatternCcdidId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xAebConfigPattern.ucPatternCcdid = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_COLS" Field */
		case eDeftFfeeAeb3AreaCritCfgAebConfigPatternPatternColsId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xAebConfigPattern.usiPatternCols = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "RESERVED" Field */
		case eDeftFfeeAeb3AreaCritCfgAebConfigPatternReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xAebConfigPattern.ucReserved     = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_ROWS" Field */
		case eDeftFfeeAeb3AreaCritCfgAebConfigPatternPatternRowsId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xAebConfigPattern.usiPatternRows = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "VASP_I2C_CONTROL", VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields */
		case eDeftFfeeAeb3AreaCritCfgVaspI2CControlOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xVaspI2CControl.uliOthers        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "DAC_CONFIG_1", RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields */
		case eDeftFfeeAeb3AreaCritCfgDacConfig1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xDacConfig1.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "DAC_CONFIG_2", RESERVED_0, "DAC_VOD", "RESERVED_1" Fields */
		case eDeftFfeeAeb3AreaCritCfgDacConfig2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xDacConfig2.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "RESERVED_20", "RESERVED" Field */
		case eDeftFfeeAeb3AreaCritCfgReserved20ReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xReserved20.uliReserved          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCCD_ON" Field */
		case eDeftFfeeAeb3AreaCritCfgPwrConfig1TimeVccdOnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xPwrConfig1.ucTimeVccdOn         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCLK_ON" Field */
		case eDeftFfeeAeb3AreaCritCfgPwrConfig1TimeVclkOnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xPwrConfig1.ucTimeVclkOn         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN1_ON" Field */
		case eDeftFfeeAeb3AreaCritCfgPwrConfig1TimeVan1OnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xPwrConfig1.ucTimeVan1On         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN2_ON" Field */
		case eDeftFfeeAeb3AreaCritCfgPwrConfig1TimeVan2OnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xPwrConfig1.ucTimeVan2On         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN3_ON" Field */
		case eDeftFfeeAeb3AreaCritCfgPwrConfig2TimeVan3OnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xPwrConfig2.ucTimeVan3On         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCCD_OFF" Field */
		case eDeftFfeeAeb3AreaCritCfgPwrConfig2TimeVccdOffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xPwrConfig2.ucTimeVccdOff        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCLK_OFF" Field */
		case eDeftFfeeAeb3AreaCritCfgPwrConfig2TimeVclkOffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xPwrConfig2.ucTimeVclkOff        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN1_OFF" Field */
		case eDeftFfeeAeb3AreaCritCfgPwrConfig2TimeVan1OffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xPwrConfig2.ucTimeVan1Off        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN2_OFF" Field */
		case eDeftFfeeAeb3AreaCritCfgPwrConfig3TimeVan2OffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xPwrConfig3.ucTimeVan2Off        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN3_OFF" Field */
		case eDeftFfeeAeb3AreaCritCfgPwrConfig3TimeVan3OffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[2].xPwrConfig3.ucTimeVan3Off        = (alt_u8) uliDefaultValue;
			break;

		/* F-FEE AEB 3 General Configuration Area Register "ADC1_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
		case eDeftFfeeAeb3AreaGenCfgAdc1Config1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xAdc1Config1.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "ADC1_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
		case eDeftFfeeAeb3AreaGenCfgAdc1Config2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xAdc1Config2.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "ADC1_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
		case eDeftFfeeAeb3AreaGenCfgAdc1Config3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xAdc1Config3.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "ADC2_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
		case eDeftFfeeAeb3AreaGenCfgAdc2Config1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xAdc2Config1.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "ADC2_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
		case eDeftFfeeAeb3AreaGenCfgAdc2Config2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xAdc2Config2.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "ADC2_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
		case eDeftFfeeAeb3AreaGenCfgAdc2Config3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xAdc2Config3.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "RESERVED_118", "RESERVED" Field */
		case eDeftFfeeAeb3AreaGenCfgReserved118ReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xReserved118.uliReserved          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "RESERVED_11C", "RESERVED" Field */
		case eDeftFfeeAeb3AreaGenCfgReserved11CReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xReserved11C.uliReserved          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_1", "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig1.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_2", ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig2.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_3", RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig3.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_4", RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig4OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig4.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_5", SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig5OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig5.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_6", "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig6OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig6.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_14", "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig14OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig14.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_7", "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig7OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig7.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_8", "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig8OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig8.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_9", "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig9OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig9.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_10", "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig10OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig10.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_11", "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig11OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig11.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_12", "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig12OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig12.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_13", "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig13OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig13.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_15", "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig15OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig15.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_16", "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig16OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig16.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_17", "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig17OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig17.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_18", "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig18OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig18.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_19", "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig19OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig19.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_20", "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig20OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig20.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_21", "RESERVED" Field */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig21OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig21.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_22", "RESERVED" Field */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig22OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig22.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_23", "RESERVED" Field */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig23OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig23.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_24", "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig24OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig24.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_25", "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig25OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig25.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_26", "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig26OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig26.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_27", "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig27OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig27.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_28", "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig28OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig28.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_29", "RESERVED" Field */
		case eDeftFfeeAeb3AreaGenCfgSeqConfig29OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[2].xSeqConfig29.uliOthers            = (alt_u32) uliDefaultValue;
			break;

		/* F-FEE AEB 3 Housekeeping Area Register "AEB_STATUS", "AEB_STATUS" Field */
		case eDeftFfeeAeb3AreaHkAebStatusAebStatusId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAebStatus.ucAebStatus                = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "AEB_STATUS", VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields */
		case eDeftFfeeAeb3AreaHkAebStatusOthers0Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAebStatus.ucOthers0                  = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "AEB_STATUS", DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields */
		case eDeftFfeeAeb3AreaHkAebStatusOthers1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAebStatus.usiOthers1                 = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "TIMESTAMP_1", "TIMESTAMP_DWORD_1" Field */
		case eDeftFfeeAeb3AreaHkTimestamp1TimestampDword1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xTimestamp1.uliTimestampDword1        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "TIMESTAMP_2", "TIMESTAMP_DWORD_0" Field */
		case eDeftFfeeAeb3AreaHkTimestamp2TimestampDword0Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xTimestamp2.uliTimestampDword0        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_VASP_L", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTVaspLOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataTVaspL.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_VASP_R", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTVaspROthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataTVaspR.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTBiasPOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataTBiasP.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_HK_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTHkPOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataTHkP.uliOthers              = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTTou1POthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataTTou1P.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTTou2POthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataTTou2P.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_VODE", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkVodeOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataHkVode.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_VODF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkVodfOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataHkVodf.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_VRD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkVrdOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataHkVrd.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_VOG", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkVogOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataHkVog.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_CCD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTCcdOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataTCcd.uliOthers              = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTRef1KMeaOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataTRef1KMea.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataTRef649RMeaOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataTRef649RMea.uliOthers       = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkAnaN5VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataHkAnaN5V.uliOthers          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_S_REF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataSRefOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataSRef.uliOthers              = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkCcdP31VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataHkCcdP31V.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkClkP15VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataHkClkP15V.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkAnaP5VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataHkAnaP5V.uliOthers          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkAnaP3V3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataHkAnaP3V3.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataHkDigP3V3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataHkDigP3V3.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields */
		case eDeftFfeeAeb3AreaHkAdcRdDataAdcRefBuf2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdcRdDataAdcRefBuf2.uliOthers        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "VASP_RD_CONFIG", VASP1_READ_DATA, "VASP2_READ_DATA" Fields */
		case eDeftFfeeAeb3AreaHkVaspRdConfigOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xVaspRdConfig.usiOthers               = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "REVISION_ID_1", FPGA_VERSION, "FPGA_DATE" Fields */
		case eDeftFfeeAeb3AreaHkRevisionId1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xRevisionId1.uliOthers                = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "REVISION_ID_2", FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields */
		case eDeftFfeeAeb3AreaHkRevisionId2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xRevisionId2.uliOthers                = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "AEB_STATUS", "VASP2_DELAYED", "VASP1_DELAYED", "VASP2_ERROR", "VASP1_ERROR" Fields */
		case eDeftFfeeAeb3AreaHkAebStatusucOthers2Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAebStatus.ucOthers2                  = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC1_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
		case eDeftFfeeAeb3AreaHkAdc1RdConfig3ucOthers1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdc1RdConfig3.ucOthers1              = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 3 Housekeeping Area Register "ADC2_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
		case eDeftFfeeAeb3AreaHkAdc2RdConfig3ucOthers1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[2].xAdc2RdConfig3.ucOthers1              = (alt_u8) uliDefaultValue;
			break;

		/* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONTROL", "RESERVED" Field */
		case eDeftFfeeAeb4AreaCritCfgAebControlReserved0Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xAebControl.ucReserved           = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONTROL", "NEW_STATE" Field */
		case eDeftFfeeAeb4AreaCritCfgAebControlNewStateId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xAebControl.ucNewState           = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONTROL", "SET_STATE" Field */
		case eDeftFfeeAeb4AreaCritCfgAebControlSetStateId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xAebControl.bSetState            = (bool) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONTROL", "AEB_RESET" Field */
		case eDeftFfeeAeb4AreaCritCfgAebControlAebResetId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xAebControl.bAebReset            = (bool) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONTROL", RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields */
		case eDeftFfeeAeb4AreaCritCfgAebControlOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xAebControl.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONFIG", RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields */
		case eDeftFfeeAeb4AreaCritCfgAebConfigOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xAebConfig.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONFIG_KEY", "KEY" Field */
		case eDeftFfeeAeb4AreaCritCfgAebConfigKeyKeyId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xAebConfigKey.uliKey             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Critical Configuration Area Register "AEB_CONFIG_AIT", "OVERRIDE_SW", "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields */
		case eDeftFfeeAeb4AreaCritCfgAebConfigAitOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xAebConfigAit.uliOthers          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_CCDID" Field */
		case eDeftFfeeAeb4AreaCritCfgAebConfigPatternPatternCcdidId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xAebConfigPattern.ucPatternCcdid = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_COLS" Field */
		case eDeftFfeeAeb4AreaCritCfgAebConfigPatternPatternColsId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xAebConfigPattern.usiPatternCols = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "RESERVED" Field */
		case eDeftFfeeAeb4AreaCritCfgAebConfigPatternReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xAebConfigPattern.ucReserved     = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_ROWS" Field */
		case eDeftFfeeAeb4AreaCritCfgAebConfigPatternPatternRowsId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xAebConfigPattern.usiPatternRows = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "VASP_I2C_CONTROL", VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields */
		case eDeftFfeeAeb4AreaCritCfgVaspI2CControlOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xVaspI2CControl.uliOthers        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "DAC_CONFIG_1", RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields */
		case eDeftFfeeAeb4AreaCritCfgDacConfig1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xDacConfig1.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "DAC_CONFIG_2", RESERVED_0, "DAC_VOD", "RESERVED_1" Fields */
		case eDeftFfeeAeb4AreaCritCfgDacConfig2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xDacConfig2.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "RESERVED_20", "RESERVED" Field */
		case eDeftFfeeAeb4AreaCritCfgReserved20ReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xReserved20.uliReserved          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCCD_ON" Field */
		case eDeftFfeeAeb4AreaCritCfgPwrConfig1TimeVccdOnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xPwrConfig1.ucTimeVccdOn         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCLK_ON" Field */
		case eDeftFfeeAeb4AreaCritCfgPwrConfig1TimeVclkOnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xPwrConfig1.ucTimeVclkOn         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN1_ON" Field */
		case eDeftFfeeAeb4AreaCritCfgPwrConfig1TimeVan1OnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xPwrConfig1.ucTimeVan1On         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN2_ON" Field */
		case eDeftFfeeAeb4AreaCritCfgPwrConfig1TimeVan2OnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xPwrConfig1.ucTimeVan2On         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN3_ON" Field */
		case eDeftFfeeAeb4AreaCritCfgPwrConfig2TimeVan3OnId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xPwrConfig2.ucTimeVan3On         = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCCD_OFF" Field */
		case eDeftFfeeAeb4AreaCritCfgPwrConfig2TimeVccdOffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xPwrConfig2.ucTimeVccdOff        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCLK_OFF" Field */
		case eDeftFfeeAeb4AreaCritCfgPwrConfig2TimeVclkOffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xPwrConfig2.ucTimeVclkOff        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN1_OFF" Field */
		case eDeftFfeeAeb4AreaCritCfgPwrConfig2TimeVan1OffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xPwrConfig2.ucTimeVan1Off        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN2_OFF" Field */
		case eDeftFfeeAeb4AreaCritCfgPwrConfig3TimeVan2OffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xPwrConfig3.ucTimeVan2Off        = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN3_OFF" Field */
		case eDeftFfeeAeb4AreaCritCfgPwrConfig3TimeVan3OffId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaCritCfg[3].xPwrConfig3.ucTimeVan3Off        = (alt_u8) uliDefaultValue;
			break;

		/* F-FEE AEB 4 General Configuration Area Register "ADC1_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
		case eDeftFfeeAeb4AreaGenCfgAdc1Config1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xAdc1Config1.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "ADC1_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
		case eDeftFfeeAeb4AreaGenCfgAdc1Config2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xAdc1Config2.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "ADC1_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
		case eDeftFfeeAeb4AreaGenCfgAdc1Config3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xAdc1Config3.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "ADC2_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
		case eDeftFfeeAeb4AreaGenCfgAdc2Config1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xAdc2Config1.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "ADC2_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
		case eDeftFfeeAeb4AreaGenCfgAdc2Config2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xAdc2Config2.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "ADC2_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
		case eDeftFfeeAeb4AreaGenCfgAdc2Config3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xAdc2Config3.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "RESERVED_118", "RESERVED" Field */
		case eDeftFfeeAeb4AreaGenCfgReserved118ReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xReserved118.uliReserved          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "RESERVED_11C", "RESERVED" Field */
		case eDeftFfeeAeb4AreaGenCfgReserved11CReservedId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xReserved11C.uliReserved          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_1", "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig1.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_2", ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig2.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_3", RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig3.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_4", RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig4OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig4.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_5", SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig5OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig5.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_6", "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig6OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig6.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_14", "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig14OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig14.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_7", "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig7OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig7.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_8", "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig8OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig8.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_9", "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig9OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig9.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_10", "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig10OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig10.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_11", "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig11OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig11.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_12", "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig12OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig12.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_13", "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig13OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig13.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_15", "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig15OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig15.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_16", "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig16OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig16.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_17", "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig17OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig17.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_18", "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig18OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig18.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_19", "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig19OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig19.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_20", "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig20OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig20.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_21", "RESERVED" Field */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig21OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig21.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_22", "RESERVED" Field */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig22OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig22.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_23", "RESERVED" Field */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig23OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig23.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_24", "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig24OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig24.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_25", "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig25OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig25.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_26", "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig26OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig26.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_27", "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig27OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig27.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_28", "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig28OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig28.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_29", "RESERVED" Field */
		case eDeftFfeeAeb4AreaGenCfgSeqConfig29OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaGenCfg[3].xSeqConfig29.uliOthers            = (alt_u32) uliDefaultValue;
			break;

		/* F-FEE AEB 4 Housekeeping Area Register "AEB_STATUS", "AEB_STATUS" Field */
		case eDeftFfeeAeb4AreaHkAebStatusAebStatusId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAebStatus.ucAebStatus                = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "AEB_STATUS", VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields */
		case eDeftFfeeAeb4AreaHkAebStatusOthers0Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAebStatus.ucOthers0                  = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "AEB_STATUS", DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields */
		case eDeftFfeeAeb4AreaHkAebStatusOthers1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAebStatus.usiOthers1                 = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "TIMESTAMP_1", "TIMESTAMP_DWORD_1" Field */
		case eDeftFfeeAeb4AreaHkTimestamp1TimestampDword1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xTimestamp1.uliTimestampDword1        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "TIMESTAMP_2", "TIMESTAMP_DWORD_0" Field */
		case eDeftFfeeAeb4AreaHkTimestamp2TimestampDword0Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xTimestamp2.uliTimestampDword0        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_VASP_L", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTVaspLOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataTVaspL.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_VASP_R", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTVaspROthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataTVaspR.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTBiasPOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataTBiasP.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_HK_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTHkPOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataTHkP.uliOthers              = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTTou1POthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataTTou1P.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTTou2POthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataTTou2P.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_VODE", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkVodeOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataHkVode.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_VODF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkVodfOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataHkVodf.uliOthers            = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_VRD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkVrdOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataHkVrd.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_VOG", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkVogOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataHkVog.uliOthers             = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_CCD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTCcdOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataTCcd.uliOthers              = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTRef1KMeaOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataTRef1KMea.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataTRef649RMeaOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataTRef649RMea.uliOthers       = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkAnaN5VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataHkAnaN5V.uliOthers          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_S_REF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataSRefOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataSRef.uliOthers              = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkCcdP31VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataHkCcdP31V.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkClkP15VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataHkClkP15V.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkAnaP5VOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataHkAnaP5V.uliOthers          = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkAnaP3V3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataHkAnaP3V3.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataHkDigP3V3OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataHkDigP3V3.uliOthers         = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields */
		case eDeftFfeeAeb4AreaHkAdcRdDataAdcRefBuf2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdcRdDataAdcRefBuf2.uliOthers        = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "VASP_RD_CONFIG", VASP1_READ_DATA, "VASP2_READ_DATA" Fields */
		case eDeftFfeeAeb4AreaHkVaspRdConfigOthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xVaspRdConfig.usiOthers               = (alt_u16) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "REVISION_ID_1", FPGA_VERSION, "FPGA_DATE" Fields */
		case eDeftFfeeAeb4AreaHkRevisionId1OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xRevisionId1.uliOthers                = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "REVISION_ID_2", FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields */
		case eDeftFfeeAeb4AreaHkRevisionId2OthersId:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xRevisionId2.uliOthers                = (alt_u32) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "AEB_STATUS", "VASP2_DELAYED", "VASP1_DELAYED", "VASP2_ERROR", "VASP1_ERROR" Fields */
		case eDeftFfeeAeb4AreaHkAebStatusucOthers2Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAebStatus.ucOthers2                  = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC1_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
		case eDeftFfeeAeb4AreaHkAdc1RdConfig3ucOthers1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdc1RdConfig3.ucOthers1              = (alt_u8) uliDefaultValue;
			break;
		/* F-FEE AEB 4 Housekeeping Area Register "ADC2_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
		case eDeftFfeeAeb4AreaHkAdc2RdConfig3ucOthers1Id:
			vxDeftFeeDefaults[ucFee].xRmapAebAreaHk[3].xAdc2RdConfig3.ucOthers1              = (alt_u8) uliDefaultValue;
			break;

		default:
			bStatus = FALSE;
			break;
	}

	return (bStatus);
}

bool bDeftSetNucDefaultValues(alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = TRUE;

	switch (usiDefaultId) {
	/* TcpServerPort */
	case eDeftEthTcpServerPortId:
		vxDeftNucDefaults.pxEthInterfaceParams->siPortPUS = (alt_u16) uliDefaultValue;
		break;
	/* PUS TCP Enable DHCP (dynamic) IP (all IPv4 fields below will be ignored if this is true) */
	case eDeftEthDhcpV4EnableId:
		vxDeftNucDefaults.pxEthInterfaceParams->bDHCP = (bool) uliDefaultValue;
		break;
	/* PUS TCP address IPv4 uint32 representation (Example is 192.168.17.10) */
	case eDeftEthIpV4AddressId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucIP[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucIP[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucIP[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucIP[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* PUS TCP subnet IPv4 uint32 representation (Example is 255.255.255.0) */
	case eDeftEthIpV4SubnetId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucSubNet[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucSubNet[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucSubNet[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucSubNet[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* PUS TCP gateway IPv4 uint32 representation (Example is 192.168.17.1) */
	case eDeftEthIpV4GatewayId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucGTW[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucGTW[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucGTW[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucGTW[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* PUS TCP DNS IPv4 uint32 representation (Example is 1.1.1.1) */
	case eDeftEthIpV4DNSId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucDNS[0] = (alt_u8) ((uliDefaultValue >> 24) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucDNS[1] = (alt_u8) ((uliDefaultValue >> 16) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucDNS[2] = (alt_u8) ((uliDefaultValue >> 8 ) & 0x000000FF);
		vxDeftNucDefaults.pxEthInterfaceParams->ucDNS[3] = (alt_u8) (uliDefaultValue         & 0x000000FF);
		break;
	/* PUS HP_PID identification (>127 to disable verification) */
	case eDeftEthPusHpPidId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucPID = (alt_u8) uliDefaultValue;
		break;
	/* PUS HP_PCAT identification (> 15 to disable verification) */
	case eDeftEthPusHpPcatId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucPCAT = (alt_u8) uliDefaultValue;
		break;
	/* PUS Default Encapsulation Protocol (0 = None, 1 = EDEN) */
	case eDeftEthPusEncapId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucEncap = (alt_u8) uliDefaultValue;
		break;
	/* PUS HP_SOURCE_ID parameter */
	case eDeftEthPusHpSourceIdId:
		vxDeftNucDefaults.pxEthInterfaceParams->usiSourceId = (alt_u16) uliDefaultValue;
		break;
	/* PUS HP_PID parameter for ImageGenerator communication */
	case eDeftEthPusHpImgGenPidId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucImgGenPID = (alt_u8) uliDefaultValue;
		break;
	/* PUS HP_PCAT parameter for ImageGenerator communication */
	case eDeftEthPusHpImgGenPcatId:
		vxDeftNucDefaults.pxEthInterfaceParams->ucImgGenPCAT = (alt_u8) uliDefaultValue;
		break;
	default:
		bStatus = FALSE;
		break;
	}

	return (bStatus);
}

bool bDeftSetDefaultValues(alt_u16 usiMebFee, alt_u16 usiDefaultId, alt_u32 uliDefaultValue) {
	bool bStatus = FALSE;

	if (0 == usiMebFee) { /* MEB or NUC Default */

		if (((DEFT_MEB_DEFS_ID_LOWER_LIM <= usiDefaultId) && (DEFT_FEE_DEFS_ID_LOWER_LIM > usiDefaultId)) || (DEFT_NUC_DEFS_ID_RESERVED == usiDefaultId)) {

			/* Default ID is a MEB Default */
			bStatus = bDeftSetMebDefaultValues(usiDefaultId, uliDefaultValue);

		} else if (DEFT_NUC_DEFS_ID_LOWER_LIM <= usiDefaultId) {

			/* Default ID is a NUC Default */
			bStatus = bDeftSetNucDefaultValues(usiDefaultId, uliDefaultValue);

		}

	} else if ((N_OF_FastFEE + 1) >= usiMebFee) { /* FEE Default */

		if ((DEFT_FEE_DEFS_ID_LOWER_LIM <= usiDefaultId) && (DEFT_NUC_DEFS_ID_LOWER_LIM > usiDefaultId)) {

			/* Default ID is a FEE Default */
			bStatus = bDeftSetFeeDefaultValues(usiMebFee - 1, usiDefaultId, uliDefaultValue);

		}

	}

	if (TRUE == bStatus) {
		vuliDeftReceivedDefaultsQtd++;
	}

	return (bStatus);
}

//! [public functions]

//! [private functions]
//! [private functions]
