/*
 * rmap_mem_area.h
 *
 *  Created on: 12 de abr de 2020
 *      Author: rfranca
 */

#ifndef DRIVER_COMM_RMAP_RMAP_MEM_AREA_H_
#define DRIVER_COMM_RMAP_RMAP_MEM_AREA_H_

#include "../../../simucam_definitions.h"

//! [constants definition]
//! [constants definition]

//! [public module structs definition]

/* DEB Critical Configuration Area Register "DTC_AEB_ONOFF" Struct */
typedef struct DtcAebOnoff {
	bool bAebIdx3; /* "AEB_IDX3" Field */
	bool bAebIdx2; /* "AEB_IDX2" Field */
	bool bAebIdx1; /* "AEB_IDX1" Field */
	bool bAebIdx0; /* "AEB_IDX0" Field */
} TDtcAebOnoff;

/* DEB Critical Configuration Area Register "DTC_PLL_REG_0" Struct */
typedef struct DtcPllReg0 {
	bool bPfdfc; /* "PFDFC" Field */
	bool bGtme; /* "GTME" Field */
	bool bHoldtr; /* "HOLDTR" Field */
	bool bHoldf; /* "HOLDF" Field */
	bool bFoff; /* "FOFF" Field */
	bool bLock1; /* "LOCK1" Field */
	bool bLock0; /* "LOCK0" Field */
	bool bLockw1; /* "LOCKW1" Field */
	bool bLockw0; /* "LOCKW0" Field */
	bool bC1; /* "C1" Field */
	bool bC0; /* "C0" Field */
} TDtcPllReg0;

/* DEB Critical Configuration Area Register "DTC_PLL_REG_1" Struct */
typedef struct DtcPllReg1 {
	bool bHold; /* "HOLD" Field */
	bool bReset; /* "RESET" Field */
	bool bReshol; /* "RESHOL" Field */
	bool bPd; /* "PD" Field */
	alt_u8 ucY4Mux; /* "Y4MUX" Field */
	alt_u8 ucY3Mux; /* "Y3MUX" Field */
	alt_u8 ucY2Mux; /* "Y2MUX" Field */
	alt_u8 ucY1Mux; /* "Y1MUX" Field */
	alt_u8 ucY0Mux; /* "Y0MUX" Field */
	alt_u8 ucFbMux; /* "FB_MUX" Field */
	alt_u8 ucPfd; /* "PFD" Field */
	alt_u8 ucCpCurrent; /* "CP_current" Field */
	bool bPrecp; /* "PRECP" Field */
	bool bCpDir; /* "CP_DIR" Field */
	bool bC1; /* "C1" Field */
	bool bC0; /* "C0" Field */
} TDtcPllReg1;

/* DEB Critical Configuration Area Register "DTC_PLL_REG_2" Struct */
typedef struct DtcPllReg2 {
	bool bN90Div8; /* "90DIV8" Field */
	bool bN90Div4; /* "90DIV4" Field */
	bool bAdlock; /* "ADLOCK" Field */
	bool bSxoiref; /* "SXOIREF" Field */
	bool bSref; /* "SREF" Field */
	alt_u8 ucOutputY4Mode; /* "Output_Y4_Mode" Field */
	alt_u8 ucOutputY3Mode; /* "Output_Y3_Mode" Field */
	alt_u8 ucOutputY2Mode; /* "Output_Y2_Mode" Field */
	alt_u8 ucOutputY1Mode; /* "Output_Y1_Mode" Field */
	alt_u8 ucOutputY0Mode; /* "Output_Y0_Mode" Field */
	bool bOutsel4; /* "OUTSEL4" Field */
	bool bOutsel3; /* "OUTSEL3" Field */
	bool bOutsel2; /* "OUTSEL2" Field */
	bool bOutsel1; /* "OUTSEL1" Field */
	bool bOutsel0; /* "OUTSEL0" Field */
	bool bC1; /* "C1" Field */
	bool bC0; /* "C0" Field */
} TDtcPllReg2;

/* DEB Critical Configuration Area Register "DTC_PLL_REG_3" Struct */
typedef struct DtcPllReg3 {
	bool bRefdec; /* "REFDEC" Field */
	bool bManaut; /* "MANAUT" Field */
	alt_u8 ucDlyn; /* "DLYN" Field */
	alt_u8 ucDlym; /* "DLYM" Field */
	alt_u16 usiN; /* "N" Field */
	alt_u16 usiM; /* "M" Field */
	bool bC1; /* "C1" Field */
	bool bC0; /* "C0" Field */
} TDtcPllReg3;

/* DEB Critical Configuration Area Register "DTC_FEE_MOD" Struct */
typedef struct DtcFeeMod {
	alt_u8 ucOperMod; /* "OPER_MOD" Field */
} TDtcFeeMod;

/* DEB Critical Configuration Area Register "DTC_IMM_ONMOD" Struct */
typedef struct DtcImmOnmod {
	bool bImmOn; /* "IMM_ON" Field */
} TDtcImmOnmod;

/* DEB General Configuration Area Register "DTC_IN_MOD" Struct */
typedef struct CfgDtcInMod {
	alt_u8 ucT7InMod; /* "T7_IN_MOD" Field */
	alt_u8 ucT6InMod; /* "T6_IN_MOD" Field */
	alt_u8 ucT5InMod; /* "T5_IN_MOD" Field */
	alt_u8 ucT4InMod; /* "T4_IN_MOD" Field */
	alt_u8 ucT3InMod; /* "T3_IN_MOD" Field */
	alt_u8 ucT2InMod; /* "T2_IN_MOD" Field */
	alt_u8 ucT1InMod; /* "T1_IN_MOD" Field */
	alt_u8 ucT0InMod; /* "T0_IN_MOD" Field */
} TCfgDtcInMod;

/* DEB General Configuration Area Register "DTC_WDW_SIZ" Struct */
typedef struct CfgDtcWdwSiz {
	alt_u8 ucWSizX; /* "W_SIZ_X" Field */
	alt_u8 ucWSizY; /* "W_SIZ_Y" Field */
} TCfgDtcWdwSiz;

/* DEB General Configuration Area Register "DTC_WDW_IDX" Struct */
typedef struct CfgDtcWdwIdx {
	alt_u16 usiWdwIdx4; /* "WDW_IDX_4" Field */
	alt_u16 usiWdwLen4; /* "WDW_LEN_4" Field */
	alt_u16 usiWdwIdx3; /* "WDW_IDX_3" Field */
	alt_u16 usiWdwLen3; /* "WDW_LEN_3" Field */
	alt_u16 usiWdwIdx2; /* "WDW_IDX_2" Field */
	alt_u16 usiWdwLen2; /* "WDW_LEN_2" Field */
	alt_u16 usiWdwIdx1; /* "WDW_IDX_1" Field */
	alt_u16 usiWdwLen1; /* "WDW_LEN_1" Field */
} TCfgDtcWdwIdx;

/* DEB General Configuration Area Register "DTC_OVS_PAT" Struct */
typedef struct CfgDtcOvsPat {
	alt_u8 ucOvsLinPat; /* "OVS_LIN_PAT" Field */
} TCfgDtcOvsPat;

/* DEB General Configuration Area Register "DTC_SIZ_PAT" Struct */
typedef struct CfgDtcSizPat {
	alt_u16 usiNbLinPat; /* "NB_LIN_PAT" Field */
	alt_u16 usiNbPixPat; /* "NB_PIX_PAT" Field */
} TCfgDtcSizPat;

/* DEB General Configuration Area Register "DTC_TRG_25S" Struct */
typedef struct CfgDtcTrg25S {
	alt_u8 ucN25SNCyc; /* "2_5S_N_CYC" Field */
} TCfgDtcTrg25S;

/* DEB General Configuration Area Register "DTC_SEL_TRG" Struct */
typedef struct CfgDtcSelTrg {
	bool bTrgSrc; /* "TRG_SRC" Field */
} TCfgDtcSelTrg;

/* DEB General Configuration Area Register "DTC_FRM_CNT" Struct */
typedef struct CfgDtcFrmCnt {
	alt_u16 usiPsetFrmCnt; /* "PSET_FRM_CNT" Field */
} TCfgDtcFrmCnt;

/* DEB General Configuration Area Register "DTC_SEL_SYN" Struct */
typedef struct CfgDtcSelSyn {
	bool bSynFrq; /* "SYN_FRQ" Field */
} TCfgDtcSelSyn;

/* DEB General Configuration Area Register "DTC_RST_CPS" Struct */
typedef struct CfgDtcRstCps {
	bool bRstSpw; /* "RST_SPW" Field */
	bool bRstWdg; /* "RST_WDG" Field */
} TCfgDtcRstCps;

/* DEB General Configuration Area Register "DTC_25S_DLY" Struct */
typedef struct CfgDtc25SDly {
	alt_u32 uliN25SDly; /* "25S_DLY" Field */
} TCfgDtc25SDly;

/* DEB General Configuration Area Register "DTC_TMOD_CONF" Struct */
typedef struct CfgDtcTmodConf {
	alt_u32 uliReserved; /* "RESERVED" Field */
} TCfgDtcTmodConf;

/* DEB General Configuration Area Register "DTC_SPW_CFG" Struct */
typedef struct CfgDtcSpwCfg {
	alt_u8 ucTimecode; /* "TIMECODE" Field */
} TCfgDtcSpwCfg;

/* DEB Housekeeping Area Register "DEB_STATUS" Struct */
typedef struct DebStatus {
	alt_u8 ucOperMod; /* "OPER_MOD" Field */
	alt_u8 ucEdacListCorrErr; /* "EDAC_LIST_CORR_ERR" Field */
	alt_u8 ucEdacListUncorrErr; /* "EDAC_LIST_UNCORR_ERR" Field */
	bool bPllRef; /* "PLL_REF" Field */
	bool bPllVcxo; /* "PLL_VCXO" Field */
	bool bPllLock; /* "PLL_LOCK" Field */
	bool bVdigAeb4; /* "VDIG_AEB_4" Field */
	bool bVdigAeb3; /* "VDIG_AEB_3" Field */
	bool bVdigAeb2; /* "VDIG_AEB_2" Field */
	bool bVdigAeb1; /* "VDIG_AEB_1" Field */
	alt_u8 ucWdwListCntOvf; /* "WDW_LIST_CNT_OVF" Field */
	bool bWdg; /* "WDG" Field */
} TDebStatus;

/* DEB Housekeeping Area Register "DEB_OVF" Struct */
typedef struct DebOvf {
	bool bRowActList8; /* "ROW_ACT_LIST_8" Field */
	bool bRowActList7; /* "ROW_ACT_LIST_7" Field */
	bool bRowActList6; /* "ROW_ACT_LIST_6" Field */
	bool bRowActList5; /* "ROW_ACT_LIST_5" Field */
	bool bRowActList4; /* "ROW_ACT_LIST_4" Field */
	bool bRowActList3; /* "ROW_ACT_LIST_3" Field */
	bool bRowActList2; /* "ROW_ACT_LIST_2" Field */
	bool bRowActList1; /* "ROW_ACT_LIST_1" Field */
	bool bOutbuff8; /* "OUTBUFF_8" Field */
	bool bOutbuff7; /* "OUTBUFF_7" Field */
	bool bOutbuff6; /* "OUTBUFF_6" Field */
	bool bOutbuff5; /* "OUTBUFF_5" Field */
	bool bOutbuff4; /* "OUTBUFF_4" Field */
	bool bOutbuff3; /* "OUTBUFF_3" Field */
	bool bOutbuff2; /* "OUTBUFF_2" Field */
	bool bOutbuff1; /* "OUTBUFF_1" Field */
	bool bRmap4; /* "RMAP_4" Field */
	bool bRmap3; /* "RMAP_3" Field */
	bool bRmap2; /* "RMAP_2" Field */
	bool bRmap1; /* "RMAP_1" Field */
} TDebOvf;

/* DEB Housekeeping Area Register "SPW_STATUS" Struct */
typedef struct SpwStatus {
	alt_u8 ucState4; /* "STATE_4" Field */
	bool bCrd4; /* "CRD_4" Field */
	bool bFifo4; /* "FIFO_4" Field */
	bool bEsc4; /* "ESC_4" Field */
	bool bPar4; /* "PAR_4" Field */
	bool bDisc4; /* "DISC_4" Field */
	alt_u8 ucState3; /* "STATE_3" Field */
	bool bCrd3; /* "CRD_3" Field */
	bool bFifo3; /* "FIFO_3" Field */
	bool bEsc3; /* "ESC_3" Field */
	bool bPar3; /* "PAR_3" Field */
	bool bDisc3; /* "DISC_3" Field */
	alt_u8 ucState2; /* "STATE_2" Field */
	bool bCrd2; /* "CRD_2" Field */
	bool bFifo2; /* "FIFO_2" Field */
	bool bEsc2; /* "ESC_2" Field */
	bool bPar2; /* "PAR_2" Field */
	bool bDisc2; /* "DISC_2" Field */
	alt_u8 ucState1; /* "STATE_1" Field */
	bool bCrd1; /* "CRD_1" Field */
	bool bFifo1; /* "FIFO_1" Field */
	bool bEsc1; /* "ESC_1" Field */
	bool bPar1; /* "PAR_1" Field */
	bool bDisc1; /* "DISC_1" Field */
} TSpwStatus;

/* DEB Housekeeping Area Register "DEB_AHK1" Struct */
typedef struct DebAhk1 {
	alt_u16 usiVdigIn; /* "VDIG_IN" Field */
	alt_u16 usiVio; /* "VIO" Field */
} TDebAhk1;

/* DEB Housekeeping Area Register "DEB_AHK2" Struct */
typedef struct DebAhk2 {
	alt_u16 usiVcor; /* "VCOR" Field */
	alt_u16 usiVlvd; /* "VLVD" Field */
} TDebAhk2;

/* DEB Housekeeping Area Register "DEB_AHK3" Struct */
typedef struct DebAhk3 {
	alt_u16 usiDebTemp; /* "DEB_TEMP" Field */
} TDebAhk3;

/* General Struct for RMAP DEB Critical Config Area Registers Access */
typedef struct RmapDebAreaCritCfg {
	TDtcAebOnoff xDtcAebOnoff;
	TDtcPllReg0 xDtcPllReg0;
	TDtcPllReg1 xDtcPllReg1;
	TDtcPllReg2 xDtcPllReg2;
	TDtcPllReg3 xDtcPllReg3;
	TDtcFeeMod xDtcFeeMod;
	TDtcImmOnmod xDtcImmOnmod;
} TRmapDebAreaCritCfg;

/* General Struct for RMAP DEB General Config Area Registers Access */
typedef struct RmapDebAreaGenCfg {
	TCfgDtcInMod xCfgDtcInMod;
	TCfgDtcWdwSiz xCfgDtcWdwSiz;
	TCfgDtcWdwIdx xCfgDtcWdwIdx;
	TCfgDtcOvsPat xCfgDtcOvsPat;
	TCfgDtcSizPat xCfgDtcSizPat;
	TCfgDtcTrg25S xCfgDtcTrg25S;
	TCfgDtcSelTrg xCfgDtcSelTrg;
	TCfgDtcFrmCnt xCfgDtcFrmCnt;
	TCfgDtcSelSyn xCfgDtcSelSyn;
	TCfgDtcRstCps xCfgDtcRstCps;
	TCfgDtc25SDly xCfgDtc25SDly;
	TCfgDtcTmodConf xCfgDtcTmodConf;
	TCfgDtcSpwCfg xCfgDtcSpwCfg;
} TRmapDebAreaGenCfg;

/* General Struct for RMAP DEB Housekeeping Area Registers Access */
typedef struct RmapDebAreaHk {
	TDebStatus xDebStatus;
	TDebOvf xDebOvf;
	TSpwStatus xSpwStatus;
	TDebAhk1 xDebAhk1;
	TDebAhk2 xDebAhk2;
	TDebAhk3 xDebAhk3;
} TRmapDebAreaHk;

/* AEB Critical Configuration Area Register "AEB_CONTROL" Struct */
typedef struct AebControl {
	bool bReserved0; /* "RESERVED_0" Field */
	bool bNewState; /* "NEW_STATE" Field */
	bool bSetState; /* "SET_STATE" Field */
	bool bAebReset; /* "AEB_RESET" Field */
	alt_u8 ucReserved1; /* "RESERVED_1" Field */
	bool bAdcDataRd; /* "ADC_DATA_RD" Field */
	bool bAdcCfgWr; /* "ADC_CFG_WR" Field */
	bool bAdcCfgRd; /* "ADC_CFG_RD" Field */
	bool bDacWr; /* "DAC_WR" Field */
	alt_u16 usiReserved2; /* "RESERVED_2" Field */
} TAebControl;

/* AEB Critical Configuration Area Register "AEB_CONFIG" Struct */
typedef struct AebConfig {
	alt_u8 ucReserved0; /* "RESERVED_0" Field */
	bool bWatchdogDis; /* "WATCH-DOG_DIS" Field */
	bool bIntSync; /* "INT_SYNC" Field */
	alt_u8 ucReserved1; /* "RESERVED_1" Field */
	bool bVaspCdsEn; /* "VASP_CDS_EN" Field */
	bool bVasp2CalEn; /* "VASP2_CAL_EN" Field */
	bool bVasp1CalEn; /* "VASP1_CAL_EN" Field */
	alt_u16 usiReserved2; /* "RESERVED_2" Field */
} TAebConfig;

/* AEB Critical Configuration Area Register "AEB_CONFIG_KEY" Struct */
typedef struct AebConfigKey {
	alt_u32 uliKey; /* "KEY" Field */
} TAebConfigKey;

/* AEB Critical Configuration Area Register "AEB_CONFIG_AIT" Struct */
typedef struct AebConfigAit {
	bool bOverrideSw; /* "OVERRIDE_SW" Field */
	alt_u8 ucReserved0; /* "RESERVED_0" Field */
	bool bSwVan3; /* "SW_VAN3" Field */
	bool bSwVan2; /* "SW_VAN2" Field */
	bool bSwVan1; /* "SW_VAN1" Field */
	bool bSwVclk; /* "SW_VCLK" Field */
	bool bSwVccd; /* "SW_VCCD" Field */
	bool bOverrideVasp; /* "OVERRIDE_VASP" Field */
	bool bReserved1; /* "RESERVED_1" Field */
	bool bVasp2PixEn; /* "VASP2_PIX_EN" Field */
	bool bVasp1PixEn; /* "VASP1_PIX_EN" Field */
	bool bVasp2AdcEn; /* "VASP2_ADC_EN" Field */
	bool bVasp1AdcEn; /* "VASP1_ADC_EN" Field */
	bool bVasp2Reset; /* "VASP2_RESET" Field */
	bool bVasp1Reset; /* "VASP1_RESET" Field */
	bool bOverrideAdc; /* "OVERRIDE_ADC" Field */
	bool bAdc2EnP5V0; /* "ADC2_EN_P5V0" Field */
	bool bAdc1EnP5V0; /* "ADC1_EN_P5V0" Field */
	bool bPt1000CalOnN; /* "PT1000_CAL_ON_N" Field */
	bool bEnVMuxN; /* "EN_V_MUX_N" Field */
	bool bAdc2PwdnN; /* "ADC2_PWDN_N" Field */
	bool bAdc1PwdnN; /* "ADC1_PWDN_N" Field */
	bool bAdcClkEn; /* "ADC_CLK_EN" Field */
	alt_u8 ucReserved2; /* "RESERVED_2" Field */
} TAebConfigAit;

/* AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" Struct */
typedef struct AebConfigPattern {
	alt_u8 ucPatternCcdid; /* "PATTERN_CCDID" Field */
	alt_u16 usiPatternCols; /* "PATTERN_COLS" Field */
	alt_u8 ucReserved; /* "RESERVED" Field */
	alt_u16 usiPatternRows; /* "PATTERN_ROWS" Field */
} TAebConfigPattern;

/* AEB Critical Configuration Area Register "VASP_I2C_CONTROL" Struct */
typedef struct VaspI2CControl {
	alt_u8 ucVaspCfgAddr; /* "VASP_CFG_ADDR" Field */
	alt_u8 ucVasp1CfgData; /* "VASP1_CFG_DATA" Field */
	alt_u8 ucVasp2CfgData; /* "VASP2_CFG_DATA" Field */
	alt_u8 ucReserved; /* "RESERVED" Field */
	bool bVasp2Select; /* "VASP2_SELECT" Field */
	bool bVasp1Select; /* "VASP1_SELECT" Field */
	bool bCalibrationStart; /* "CALIBRATION_START" Field */
	bool bI2CReadStart; /* "I2C_READ_START" Field */
	bool bI2CWriteStart; /* "I2C_WRITE_START" Field */
} TVaspI2CControl;

/* AEB Critical Configuration Area Register "DAC_CONFIG_1" Struct */
typedef struct DacConfig1 {
	alt_u8 ucReserved0; /* "RESERVED_0" Field */
	alt_u16 usiDacVog; /* "DAC_VOG" Field */
	alt_u8 ucReserved1; /* "RESERVED_1" Field */
	alt_u16 usiDacVrd; /* "DAC_VRD" Field */
} TDacConfig1;

/* AEB Critical Configuration Area Register "DAC_CONFIG_2" Struct */
typedef struct DacConfig2 {
	alt_u8 ucReserved0; /* "RESERVED_0" Field */
	alt_u16 usiDacVod; /* "DAC_VOD" Field */
	alt_u16 usiReserved1; /* "RESERVED_1" Field */
} TDacConfig2;

/* AEB Critical Configuration Area Register "RESERVED_20" Struct */
typedef struct Reserved20 {
	alt_u32 uliReserved; /* "RESERVED" Field */
} TReserved20;

/* AEB Critical Configuration Area Register "PWR_CONFIG1" Struct */
typedef struct PwrConfig1 {
	alt_u8 ucTimeVccdOn; /* "TIME_VCCD_ON" Field */
	alt_u8 ucTimeVclkOn; /* "TIME_VCLK_ON" Field */
	alt_u8 ucTimeVan1On; /* "TIME_VAN1_ON" Field */
	alt_u8 ucTimeVan2On; /* "TIME_VAN2_ON" Field */
} TPwrConfig1;

/* AEB Critical Configuration Area Register "PWR_CONFIG2" Struct */
typedef struct PwrConfig2 {
	alt_u8 ucTimeVan3On; /* "TIME_VAN3_ON" Field */
	alt_u8 ucTimeVccdOff; /* "TIME_VCCD_OFF" Field */
	alt_u8 ucTimeVclkOff; /* "TIME_VCLK_OFF" Field */
	alt_u8 ucTimeVan1Off; /* "TIME_VAN1_OFF" Field */
} TPwrConfig2;

/* AEB Critical Configuration Area Register "PWR_CONFIG3" Struct */
typedef struct PwrConfig3 {
	alt_u8 ucTimeVan2Off; /* "TIME_VAN2_OFF" Field */
	alt_u8 ucTimeVan3Off; /* "TIME_VAN3_OFF" Field */
} TPwrConfig3;

/* AEB General Configuration Area Register "ADC1_CONFIG_1" Struct */
typedef struct Adc1Config1 {
	bool bReserved0; /* "RESERVED_0" Field */
	bool bSpirst; /* "SPIRST" Field */
	bool bMuxmod; /* "MUXMOD" Field */
	bool bBypas; /* "BYPAS" Field */
	bool bClkenb; /* "CLKENB" Field */
	bool bChop; /* "CHOP" Field */
	bool bStat; /* "STAT" Field */
	bool bReserved1; /* "RESERVED_1" Field */
	bool bIdlmod; /* "IDLMOD" Field */
	alt_u8 ucDly; /* "DLY" Field */
	alt_u8 ucSbcs; /* "SBCS" Field */
	alt_u8 ucDrate; /* "DRATE" Field */
	alt_u8 ucAinp; /* "AINP" Field */
	alt_u8 ucAinn; /* "AINN" Field */
	alt_u8 ucDiff; /* "DIFF" Field */
} TAdc1Config1;

/* AEB General Configuration Area Register "ADC1_CONFIG_2" Struct */
typedef struct Adc1Config2 {
	bool bAin7; /* "AIN7" Field */
	bool bAin6; /* "AIN6" Field */
	bool bAin5; /* "AIN5" Field */
	bool bAin4; /* "AIN4" Field */
	bool bAin3; /* "AIN3" Field */
	bool bAin2; /* "AIN2" Field */
	bool bAin1; /* "AIN1" Field */
	bool bAin0; /* "AIN0" Field */
	bool bAin15; /* "AIN15" Field */
	bool bAin14; /* "AIN14" Field */
	bool bAin13; /* "AIN13" Field */
	bool bAin12; /* "AIN12" Field */
	bool bAin11; /* "AIN11" Field */
	bool bAin10; /* "AIN10" Field */
	bool bAin9; /* "AIN9" Field */
	bool bAin8; /* "AIN8" Field */
	alt_u8 ucReserved0; /* "RESERVED_0" Field */
	bool bRef; /* "REF" Field */
	bool bGain; /* "GAIN" Field */
	bool bTemp; /* "TEMP" Field */
	bool bVcc; /* "VCC" Field */
	bool bReserved1; /* "RESERVED_1" Field */
	bool bOffset; /* "OFFSET" Field */
	bool bCio7; /* "CIO7" Field */
	bool bCio6; /* "CIO6" Field */
	bool bCio5; /* "CIO5" Field */
	bool bCio4; /* "CIO4" Field */
	bool bCio3; /* "CIO3" Field */
	bool bCio2; /* "CIO2" Field */
	bool bCio1; /* "CIO1" Field */
	bool bCio0; /* "CIO0" Field */
} TAdc1Config2;

/* AEB General Configuration Area Register "ADC1_CONFIG_3" Struct */
typedef struct Adc1Config3 {
	bool bDio7; /* "DIO7" Field */
	bool bDio6; /* "DIO6" Field */
	bool bDio5; /* "DIO5" Field */
	bool bDio4; /* "DIO4" Field */
	bool bDio3; /* "DIO3" Field */
	bool bDio2; /* "DIO2" Field */
	bool bDio1; /* "DIO1" Field */
	bool bDio0; /* "DIO0" Field */
	alt_u32 uliReserved; /* "RESERVED" Field */
} TAdc1Config3;

/* AEB General Configuration Area Register "ADC2_CONFIG_1" Struct */
typedef struct Adc2Config1 {
	bool bReserved0; /* "RESERVED_0" Field */
	bool bSpirst; /* "SPIRST" Field */
	bool bMuxmod; /* "MUXMOD" Field */
	bool bBypas; /* "BYPAS" Field */
	bool bClkenb; /* "CLKENB" Field */
	bool bChop; /* "CHOP" Field */
	bool bStat; /* "STAT" Field */
	bool bReserved1; /* "RESERVED_1" Field */
	bool bIdlmod; /* "IDLMOD" Field */
	alt_u8 ucDly; /* "DLY" Field */
	alt_u8 ucSbcs; /* "SBCS" Field */
	alt_u8 ucDrate; /* "DRATE" Field */
	alt_u8 ucAinp; /* "AINP" Field */
	alt_u8 ucAinn; /* "AINN" Field */
	alt_u8 ucDiff; /* "DIFF" Field */
} TAdc2Config1;

/* AEB General Configuration Area Register "ADC2_CONFIG_2" Struct */
typedef struct Adc2Config2 {
	bool bAin7; /* "AIN7" Field */
	bool bAin6; /* "AIN6" Field */
	bool bAin5; /* "AIN5" Field */
	bool bAin4; /* "AIN4" Field */
	bool bAin3; /* "AIN3" Field */
	bool bAin2; /* "AIN2" Field */
	bool bAin1; /* "AIN1" Field */
	bool bAin0; /* "AIN0" Field */
	bool bAin15; /* "AIN15" Field */
	bool bAin14; /* "AIN14" Field */
	bool bAin13; /* "AIN13" Field */
	bool bAin12; /* "AIN12" Field */
	bool bAin11; /* "AIN11" Field */
	bool bAin10; /* "AIN10" Field */
	bool bAin9; /* "AIN9" Field */
	bool bAin8; /* "AIN8" Field */
	alt_u8 ucReserved0; /* "RESERVED_0" Field */
	bool bRef; /* "REF" Field */
	bool bGain; /* "GAIN" Field */
	bool bTemp; /* "TEMP" Field */
	bool bVcc; /* "VCC" Field */
	bool bReserved1; /* "RESERVED_1" Field */
	bool bOffset; /* "OFFSET" Field */
	bool bCio7; /* "CIO7" Field */
	bool bCio6; /* "CIO6" Field */
	bool bCio5; /* "CIO5" Field */
	bool bCio4; /* "CIO4" Field */
	bool bCio3; /* "CIO3" Field */
	bool bCio2; /* "CIO2" Field */
	bool bCio1; /* "CIO1" Field */
	bool bCio0; /* "CIO0" Field */
} TAdc2Config2;

/* AEB General Configuration Area Register "ADC2_CONFIG_3" Struct */
typedef struct Adc2Config3 {
	bool bDio7; /* "DIO7" Field */
	bool bDio6; /* "DIO6" Field */
	bool bDio5; /* "DIO5" Field */
	bool bDio4; /* "DIO4" Field */
	bool bDio3; /* "DIO3" Field */
	bool bDio2; /* "DIO2" Field */
	bool bDio1; /* "DIO1" Field */
	bool bDio0; /* "DIO0" Field */
	alt_u32 uliReserved; /* "RESERVED" Field */
} TAdc2Config3;

/* AEB General Configuration Area Register "RESERVED_118" Struct */
typedef struct Reserved118 {
	alt_u32 uliReserved; /* "RESERVED" Field */
} TReserved118;

/* AEB General Configuration Area Register "RESERVED_11C" Struct */
typedef struct Reserved11C {
	alt_u32 uliReserved; /* "RESERVED" Field */
} TReserved11C;

/* AEB General Configuration Area Register "SEQ_CONFIG_1" Struct */
typedef struct SeqConfig1 {
	alt_u8 ucReserved0; /* "RESERVED_0" Field */
	bool bSeqOeCcdEnable; /* "SEQ_OE_CCD_ENABLE" Field */
	bool bSeqOeSpare; /* "SEQ_OE_SPARE" Field */
	bool bSeqOeTstline; /* "SEQ_OE_TSTLINE" Field */
	bool bSeqOeTstfrm; /* "SEQ_OE_TSTFRM" Field */
	bool bSeqOeVaspclamp; /* "SEQ_OE_VASPCLAMP" Field */
	bool bSeqOePreclamp; /* "SEQ_OE_PRECLAMP" Field */
	bool bSeqOeIg; /* "SEQ_OE_IG" Field */
	bool bSeqOeTg; /* "SEQ_OE_TG" Field */
	bool bSeqOeDg; /* "SEQ_OE_DG" Field */
	bool bSeqOeRphir; /* "SEQ_OE_RPHIR" Field */
	bool bSeqOeSw; /* "SEQ_OE_SW" Field */
	bool bSeqOeRphi3; /* "SEQ_OE_RPHI3" Field */
	bool bSeqOeRphi2; /* "SEQ_OE_RPHI2" Field */
	bool bSeqOeRphi1; /* "SEQ_OE_RPHI1" Field */
	bool bSeqOeSphi4; /* "SEQ_OE_SPHI4" Field */
	bool bSeqOeSphi3; /* "SEQ_OE_SPHI3" Field */
	bool bSeqOeSphi2; /* "SEQ_OE_SPHI2" Field */
	bool bSeqOeSphi1; /* "SEQ_OE_SPHI1" Field */
	bool bSeqOeIphi4; /* "SEQ_OE_IPHI4" Field */
	bool bSeqOeIphi3; /* "SEQ_OE_IPHI3" Field */
	bool bSeqOeIphi2; /* "SEQ_OE_IPHI2" Field */
	bool bSeqOeIphi1; /* "SEQ_OE_IPHI1" Field */
	bool bReserved1; /* "RESERVED_1" Field */
	alt_u8 ucAdcClkDiv; /* "ADC_CLK_DIV" Field */
} TSeqConfig1;

/* AEB General Configuration Area Register "SEQ_CONFIG_2" Struct */
typedef struct SeqConfig2 {
	alt_u8 ucAdcClkLowPos; /* "ADC_CLK_LOW_POS" Field */
	alt_u8 ucAdcClkHighPos; /* "ADC_CLK_HIGH_POS" Field */
	alt_u8 ucCdsClkLowPos; /* "CDS_CLK_LOW_POS" Field */
	alt_u8 ucCdsClkHighPos; /* "CDS_CLK_HIGH_POS" Field */
} TSeqConfig2;

/* AEB General Configuration Area Register "SEQ_CONFIG_3" Struct */
typedef struct SeqConfig3 {
	alt_u8 ucRphirClkLowPos; /* "RPHIR_CLK_LOW_POS" Field */
	alt_u8 ucRphirClkHighPos; /* "RPHIR_CLK_HIGH_POS" Field */
	alt_u8 ucRphi1ClkLowPos; /* "RPHI1_CLK_LOW_POS" Field */
	alt_u8 ucRphi1ClkHighPos; /* "RPHI1_CLK_HIGH_POS" Field */
} TSeqConfig3;

/* AEB General Configuration Area Register "SEQ_CONFIG_4" Struct */
typedef struct SeqConfig4 {
	alt_u8 ucRphi2ClkLowPos; /* "RPHI2_CLK_LOW_POS" Field */
	alt_u8 ucRphi2ClkHighPos; /* "RPHI2_CLK_HIGH_POS" Field */
	alt_u8 ucRphi3ClkLowPos; /* "RPHI3_CLK_LOW_POS" Field */
	alt_u8 ucRphi3ClkHighPos; /* "RPHI3_CLK_HIGH_POS" Field */
} TSeqConfig4;

/* AEB General Configuration Area Register "SEQ_CONFIG_5" Struct */
typedef struct SeqConfig5 {
	alt_u8 ucSwClkLowPos; /* "SW_CLK_LOW_POS" Field */
	alt_u8 ucSwClkHighPos; /* "SW_CLK_HIGH_POS" Field */
	bool bVaspOutCtrl; /* "VASP_OUT_CTRL" Field */
	bool bReserved; /* "RESERVED" Field */
	alt_u16 usiVaspOutEnPos; /* "VASP_OUT_EN_POS" Field */
} TSeqConfig5;

/* AEB General Configuration Area Register "SEQ_CONFIG_6" Struct */
typedef struct SeqConfig6 {
	bool bVaspOutCtrlInv; /* "VASP_OUT_CTRL_INV" Field */
	bool bReserved0; /* "RESERVED_0" Field */
	alt_u16 usiVaspOutDisPos; /* "VASP_OUT_DIS_POS" Field */
	alt_u16 usiReserved1; /* "RESERVED_1" Field */
} TSeqConfig6;

/* AEB General Configuration Area Register "SEQ_CONFIG_7" Struct */
typedef struct SeqConfig7 {
	alt_u32 uliReserved; /* "RESERVED" Field */
} TSeqConfig7;

/* AEB General Configuration Area Register "SEQ_CONFIG_8" Struct */
typedef struct SeqConfig8 {
	alt_u32 uliReserved; /* "RESERVED" Field */
} TSeqConfig8;

/* AEB General Configuration Area Register "SEQ_CONFIG_9" Struct */
typedef struct SeqConfig9 {
	alt_u8 ucReserved0; /* "RESERVED_0" Field */
	alt_u16 usiFtLoopCnt; /* "FT_LOOP_CNT" Field */
	bool bLt0Enabled; /* "LT0_ENABLED" Field */
	bool bReserved1; /* "RESERVED_1" Field */
	alt_u16 usiLt0LoopCnt; /* "LT0_LOOP_CNT" Field */
} TSeqConfig9;

/* AEB General Configuration Area Register "SEQ_CONFIG_10" Struct */
typedef struct SeqConfig10 {
	bool bLt1Enabled; /* "LT1_ENABLED" Field */
	bool bReserved0; /* "RESERVED_0" Field */
	alt_u16 usiLt1LoopCnt; /* "LT1_LOOP_CNT" Field */
	bool bLt2Enabled; /* "LT2_ENABLED" Field */
	bool bReserved1; /* "RESERVED_1" Field */
	alt_u16 usiLt2LoopCnt; /* "LT2_LOOP_CNT" Field */
} TSeqConfig10;

/* AEB General Configuration Area Register "SEQ_CONFIG_11" Struct */
typedef struct SeqConfig11 {
	bool bLt3Enabled; /* "LT3_ENABLED" Field */
	bool bReserved; /* "RESERVED" Field */
	alt_u16 usiLt3LoopCnt; /* "LT3_LOOP_CNT" Field */
	alt_u16 usiPixLoopCntWord1; /* "PIX_LOOP_CNT_WORD_1" Field */
} TSeqConfig11;

/* AEB General Configuration Area Register "SEQ_CONFIG_12" Struct */
typedef struct SeqConfig12 {
	alt_u16 usiPixLoopCntWord0; /* "PIX_LOOP_CNT_WORD_0" Field */
	bool bPcEnabled; /* "PC_ENABLED" Field */
	bool bReserved; /* "RESERVED" Field */
	alt_u16 usiPcLoopCnt; /* "PC_LOOP_CNT" Field */
} TSeqConfig12;

/* AEB General Configuration Area Register "SEQ_CONFIG_13" Struct */
typedef struct SeqConfig13 {
	alt_u8 ucReserved0; /* "RESERVED_0" Field */
	alt_u16 usiInt1LoopCnt; /* "INT1_LOOP_CNT" Field */
	alt_u8 ucReserved1; /* "RESERVED_1" Field */
	alt_u16 usiInt2LoopCnt; /* "INT2_LOOP_CNT" Field */
} TSeqConfig13;

/* AEB General Configuration Area Register "SEQ_CONFIG_14" Struct */
typedef struct SeqConfig14 {
	alt_u8 ucReserved0; /* "RESERVED_0" Field */
	bool bSphiInv; /* "SPHI_INV" Field */
	alt_u8 ucReserved1; /* "RESERVED_1" Field */
	bool bRphiInv; /* "RPHI_INV" Field */
	alt_u16 usiReserved2; /* "RESERVED_2" Field */
} TSeqConfig14;

/* AEB Housekeeping Area Register "AEB_STATUS" Struct */
typedef struct AebStatus {
	alt_u8 ucAebStatus; /* "AEB_STATUS" Field */
	bool bVasp2CfgRun; /* "VASP2_CFG_RUN" Field */
	bool bVasp1CfgRun; /* "VASP1_CFG_RUN" Field */
	bool bDacCfgWrRun; /* "DAC_CFG_WR_RUN" Field */
	bool bAdcCfgRdRun; /* "ADC_CFG_RD_RUN" Field */
	bool bAdcCfgWrRun; /* "ADC_CFG_WR_RUN" Field */
	bool bAdcDatRdRun; /* "ADC_DAT_RD_RUN" Field */
	bool bAdcError; /* "ADC_ERROR" Field */
	bool bAdc2Lu; /* "ADC2_LU" Field */
	bool bAdc1Lu; /* "ADC1_LU" Field */
	bool bAdcDatRd; /* "ADC_DAT_RD" Field */
	bool bAdcCfgRd; /* "ADC_CFG_RD" Field */
	bool bAdcCfgWr; /* "ADC_CFG_WR" Field */
	bool bAdc2Busy; /* "ADC2_BUSY" Field */
	bool bAdc1Busy; /* "ADC1_BUSY" Field */
} TAebStatus;

/* AEB Housekeeping Area Register "TIMESTAMP_1" Struct */
typedef struct Timestamp1 {
	alt_u32 uliTimestampDword1; /* "TIMESTAMP_DWORD_1" Field */
} TTimestamp1;

/* AEB Housekeeping Area Register "TIMESTAMP_2" Struct */
typedef struct Timestamp2 {
	alt_u32 uliTimestampDword0; /* "TIMESTAMP_DWORD_0" Field */
} TTimestamp2;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_L" Struct */
typedef struct AdcRdDataTVaspL {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataTVaspL; /* "ADC_CHX_DATA_T_VASP_L" Field */
} TAdcRdDataTVaspL;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" Struct */
typedef struct AdcRdDataTVaspR {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataTVaspR; /* "ADC_CHX_DATA_T_VASP_R" Field */
} TAdcRdDataTVaspR;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" Struct */
typedef struct AdcRdDataTBiasP {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataTBiasP; /* "ADC_CHX_DATA_T_BIAS_P" Field */
} TAdcRdDataTBiasP;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" Struct */
typedef struct AdcRdDataTHkP {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataTHkP; /* "ADC_CHX_DATA_T_HK_P" Field */
} TAdcRdDataTHkP;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" Struct */
typedef struct AdcRdDataTTou1P {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataTTou1P; /* "ADC_CHX_DATA_T_TOU_1_P" Field */
} TAdcRdDataTTou1P;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" Struct */
typedef struct AdcRdDataTTou2P {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataTTou2P; /* "ADC_CHX_DATA_T_TOU_2_P" Field */
} TAdcRdDataTTou2P;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" Struct */
typedef struct AdcRdDataHkVode {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataHkVode; /* "ADC_CHX_DATA_HK_VODE" Field */
} TAdcRdDataHkVode;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" Struct */
typedef struct AdcRdDataHkVodf {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataHkVodf; /* "ADC_CHX_DATA_HK_VODF" Field */
} TAdcRdDataHkVodf;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" Struct */
typedef struct AdcRdDataHkVrd {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataHkVrd; /* "ADC_CHX_DATA_HK_VRD" Field */
} TAdcRdDataHkVrd;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" Struct */
typedef struct AdcRdDataHkVog {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataHkVog; /* "ADC_CHX_DATA_HK_VOG" Field */
} TAdcRdDataHkVog;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" Struct */
typedef struct AdcRdDataTCcd {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataTCcd; /* "ADC_CHX_DATA_T_CCD" Field */
} TAdcRdDataTCcd;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" Struct */
typedef struct AdcRdDataTRef1KMea {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataTRef1KMea; /* "ADC_CHX_DATA_T_REF1K_MEA" Field */
} TAdcRdDataTRef1KMea;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" Struct */
typedef struct AdcRdDataTRef649RMea {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataTRef649RMea; /* "ADC_CHX_DATA_T_REF649R_MEA" Field */
} TAdcRdDataTRef649RMea;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" Struct */
typedef struct AdcRdDataHkAnaN5V {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataHkAnaN5V; /* "ADC_CHX_DATA_HK_ANA_N5V" Field */
} TAdcRdDataHkAnaN5V;

/* AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" Struct */
typedef struct AdcRdDataSRef {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataSRef; /* "ADC_CHX_DATA_S_REF" Field */
} TAdcRdDataSRef;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" Struct */
typedef struct AdcRdDataHkCcdP31V {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataHkCcdP31V; /* "ADC_CHX_DATA_HK_CCD_P31V" Field */
} TAdcRdDataHkCcdP31V;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" Struct */
typedef struct AdcRdDataHkClkP15V {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataHkClkP15V; /* "ADC_CHX_DATA_HK_CLK_P15V" Field */
} TAdcRdDataHkClkP15V;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" Struct */
typedef struct AdcRdDataHkAnaP5V {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataHkAnaP5V; /* "ADC_CHX_DATA_HK_ANA_P5V" Field */
} TAdcRdDataHkAnaP5V;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" Struct */
typedef struct AdcRdDataHkAnaP3V3 {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataHkAnaP3V3; /* "ADC_CHX_DATA_HK_ANA_P3V3" Field */
} TAdcRdDataHkAnaP3V3;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" Struct */
typedef struct AdcRdDataHkDigP3V3 {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u32 uliAdcChxDataHkDigP3V3; /* "ADC_CHX_DATA_HK_DIG_P3V3" Field */
} TAdcRdDataHkDigP3V3;

/* AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" Struct */
typedef struct AdcRdDataAdcRefBuf2 {
	bool bNewData; /* "NEW" Field */
	bool bOvf; /* "OVF" Field */
	bool bSupply; /* "SUPPLY" Field */
	alt_u8 ucChid; /* "CHID" Field */
	alt_u8 ucAdcChxDataAdcRefBuf2; /* "ADC_CHX_DATA_ADC_REF_BUF_2" Field */
} TAdcRdDataAdcRefBuf2;

/* AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" Struct */
typedef struct Adc1RdConfig1 {
	bool bSpirst; /* "SPIRST" Field */
	bool bMuxmod; /* "MUXMOD" Field */
	bool bBypas; /* "BYPAS" Field */
	bool bClkenb; /* "CLKENB" Field */
	bool bChop; /* "CHOP" Field */
	bool bStat; /* "STAT" Field */
	bool bIdlmod; /* "IDLMOD" Field */
	bool bDly2; /* "DLY2" Field */
	bool bDly1; /* "DLY1" Field */
	bool bDly0; /* "DLY0" Field */
	bool bSbcs1; /* "SBCS1" Field */
	bool bSbcs0; /* "SBCS0" Field */
	bool bDrate1; /* "DRATE1" Field */
	bool bDrate0; /* "DRATE0" Field */
	bool bAinp3; /* "AINP3" Field */
	bool bAinp2; /* "AINP2" Field */
	bool bAinp1; /* "AINP1" Field */
	bool bAinp0; /* "AINP0" Field */
	bool bAinn3; /* "AINN3" Field */
	bool bAinn2; /* "AINN2" Field */
	bool bAinn1; /* "AINN1" Field */
	bool bAinn0; /* "AINN0" Field */
	bool bDiff7; /* "DIFF7" Field */
	bool bDiff6; /* "DIFF6" Field */
	bool bDiff5; /* "DIFF5" Field */
	bool bDiff4; /* "DIFF4" Field */
	bool bDiff3; /* "DIFF3" Field */
	bool bDiff2; /* "DIFF2" Field */
	bool bDiff1; /* "DIFF1" Field */
	bool bDiff0; /* "DIFF0" Field */
} TAdc1RdConfig1;

/* AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" Struct */
typedef struct Adc1RdConfig2 {
	bool bAin7; /* "AIN7" Field */
	bool bAin6; /* "AIN6" Field */
	bool bAin5; /* "AIN5" Field */
	bool bAin4; /* "AIN4" Field */
	bool bAin3; /* "AIN3" Field */
	bool bAin2; /* "AIN2" Field */
	bool bAin1; /* "AIN1" Field */
	bool bAin0; /* "AIN0" Field */
	bool bAin15; /* "AIN15" Field */
	bool bAin14; /* "AIN14" Field */
	bool bAin13; /* "AIN13" Field */
	bool bAin12; /* "AIN12" Field */
	bool bAin11; /* "AIN11" Field */
	bool bAin10; /* "AIN10" Field */
	bool bAin9; /* "AIN9" Field */
	bool bAin8; /* "AIN8" Field */
	bool bRef; /* "REF" Field */
	bool bGain; /* "GAIN" Field */
	bool bTemp; /* "TEMP" Field */
	bool bVcc; /* "VCC" Field */
	bool bOffset; /* "OFFSET" Field */
	bool bCio7; /* "CIO7" Field */
	bool bCio6; /* "CIO6" Field */
	bool bCio5; /* "CIO5" Field */
	bool bCio4; /* "CIO4" Field */
	bool bCio3; /* "CIO3" Field */
	bool bCio2; /* "CIO2" Field */
	bool bCio1; /* "CIO1" Field */
	bool bCio0; /* "CIO0" Field */
} TAdc1RdConfig2;

/* AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" Struct */
typedef struct Adc1RdConfig3 {
	bool bDio7; /* "DIO7" Field */
	bool bDio6; /* "DIO6" Field */
	bool bDio5; /* "DIO5" Field */
	bool bDio4; /* "DIO4" Field */
	bool bDio3; /* "DIO3" Field */
	bool bDio2; /* "DIO2" Field */
	bool bDio1; /* "DIO1" Field */
	bool bDio0; /* "DIO0" Field */
} TAdc1RdConfig3;

/* AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" Struct */
typedef struct Adc2RdConfig1 {
	bool bSpirst; /* "SPIRST" Field */
	bool bMuxmod; /* "MUXMOD" Field */
	bool bBypas; /* "BYPAS" Field */
	bool bClkenb; /* "CLKENB" Field */
	bool bChop; /* "CHOP" Field */
	bool bStat; /* "STAT" Field */
	bool bIdlmod; /* "IDLMOD" Field */
	bool bDly2; /* "DLY2" Field */
	bool bDly1; /* "DLY1" Field */
	bool bDly0; /* "DLY0" Field */
	bool bSbcs1; /* "SBCS1" Field */
	bool bSbcs0; /* "SBCS0" Field */
	bool bDrate1; /* "DRATE1" Field */
	bool bDrate0; /* "DRATE0" Field */
	bool bAinp3; /* "AINP3" Field */
	bool bAinp2; /* "AINP2" Field */
	bool bAinp1; /* "AINP1" Field */
	bool bAinp0; /* "AINP0" Field */
	bool bAinn3; /* "AINN3" Field */
	bool bAinn2; /* "AINN2" Field */
	bool bAinn1; /* "AINN1" Field */
	bool bAinn0; /* "AINN0" Field */
	bool bDiff7; /* "DIFF7" Field */
	bool bDiff6; /* "DIFF6" Field */
	bool bDiff5; /* "DIFF5" Field */
	bool bDiff4; /* "DIFF4" Field */
	bool bDiff3; /* "DIFF3" Field */
	bool bDiff2; /* "DIFF2" Field */
	bool bDiff1; /* "DIFF1" Field */
	bool bDiff0; /* "DIFF0" Field */
} TAdc2RdConfig1;

/* AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" Struct */
typedef struct Adc2RdConfig2 {
	bool bAin7; /* "AIN7" Field */
	bool bAin6; /* "AIN6" Field */
	bool bAin5; /* "AIN5" Field */
	bool bAin4; /* "AIN4" Field */
	bool bAin3; /* "AIN3" Field */
	bool bAin2; /* "AIN2" Field */
	bool bAin1; /* "AIN1" Field */
	bool bAin0; /* "AIN0" Field */
	bool bAin15; /* "AIN15" Field */
	bool bAin14; /* "AIN14" Field */
	bool bAin13; /* "AIN13" Field */
	bool bAin12; /* "AIN12" Field */
	bool bAin11; /* "AIN11" Field */
	bool bAin10; /* "AIN10" Field */
	bool bAin9; /* "AIN9" Field */
	bool bAin8; /* "AIN8" Field */
	bool bRef; /* "REF" Field */
	bool bGain; /* "GAIN" Field */
	bool bTemp; /* "TEMP" Field */
	bool bVcc; /* "VCC" Field */
	bool bOffset; /* "OFFSET" Field */
	bool bCio7; /* "CIO7" Field */
	bool bCio6; /* "CIO6" Field */
	bool bCio5; /* "CIO5" Field */
	bool bCio4; /* "CIO4" Field */
	bool bCio3; /* "CIO3" Field */
	bool bCio2; /* "CIO2" Field */
	bool bCio1; /* "CIO1" Field */
	bool bCio0; /* "CIO0" Field */
} TAdc2RdConfig2;

/* AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" Struct */
typedef struct Adc2RdConfig3 {
	bool bDio7; /* "DIO7" Field */
	bool bDio6; /* "DIO6" Field */
	bool bDio5; /* "DIO5" Field */
	bool bDio4; /* "DIO4" Field */
	bool bDio3; /* "DIO3" Field */
	bool bDio2; /* "DIO2" Field */
	bool bDio1; /* "DIO1" Field */
	bool bDio0; /* "DIO0" Field */
} TAdc2RdConfig3;

/* AEB Housekeeping Area Register "VASP_RD_CONFIG" Struct */
typedef struct VaspRdConfig {
	alt_u8 ucVasp1ReadData; /* "VASP1_READ_DATA" Field */
	alt_u8 ucVasp2ReadData; /* "VASP2_READ_DATA" Field */
} TVaspRdConfig;

/* AEB Housekeeping Area Register "REVISION_ID_1" Struct */
typedef struct RevisionId1 {
	alt_u16 usiFpgaVersion; /* "FPGA_VERSION" Field */
	alt_u16 usiFpgaDate; /* "FPGA_DATE" Field */
} TRevisionId1;

/* AEB Housekeeping Area Register "REVISION_ID_2" Struct */
typedef struct RevisionId2 {
	alt_u16 usiFpgaTimeH; /* "FPGA_TIME_H" Field */
	alt_u8 ucFpgaTimeM; /* "FPGA_TIME_M" Field */
	alt_u16 usiFpgaSvn; /* "FPGA_SVN" Field */
} TRevisionId2;

/* General Struct for RMAP AEB Critical Config Area Registers Access */
typedef struct RmapAebAreaCritCfg {
	TAebControl xAebControl;
	TAebConfig xAebConfig;
	TAebConfigKey xAebConfigKey;
	TAebConfigAit xAebConfigAit;
	TAebConfigPattern xAebConfigPattern;
	TVaspI2CControl xVaspI2CControl;
	TDacConfig1 xDacConfig1;
	TDacConfig2 xDacConfig2;
	TReserved20 xReserved20;
	TPwrConfig1 xPwrConfig1;
	TPwrConfig2 xPwrConfig2;
	TPwrConfig3 xPwrConfig3;
} TRmapAebAreaCritCfg;

/* General Struct for RMAP AEB General Config Area Registers Access */
typedef struct RmapAebAreaGenCfg {
	TAdc1Config1 xAdc1Config1;
	TAdc1Config2 xAdc1Config2;
	TAdc1Config3 xAdc1Config3;
	TAdc2Config1 xAdc2Config1;
	TAdc2Config2 xAdc2Config2;
	TAdc2Config3 xAdc2Config3;
	TReserved118 xReserved118;
	TReserved11C xReserved11C;
	TSeqConfig1 xSeqConfig1;
	TSeqConfig2 xSeqConfig2;
	TSeqConfig3 xSeqConfig3;
	TSeqConfig4 xSeqConfig4;
	TSeqConfig5 xSeqConfig5;
	TSeqConfig6 xSeqConfig6;
	TSeqConfig7 xSeqConfig7;
	TSeqConfig8 xSeqConfig8;
	TSeqConfig9 xSeqConfig9;
	TSeqConfig10 xSeqConfig10;
	TSeqConfig11 xSeqConfig11;
	TSeqConfig12 xSeqConfig12;
	TSeqConfig13 xSeqConfig13;
	TSeqConfig14 xSeqConfig14;
} TRmapAebAreaGenCfg;

/* General Struct for RMAP AEB Housekeeping Area Registers Access */
typedef struct RmapAebAreaHk {
	TAebStatus xAebStatus;
	TTimestamp1 xTimestamp1;
	TTimestamp2 xTimestamp2;
	TAdcRdDataTVaspL xAdcRdDataTVaspL;
	TAdcRdDataTVaspR xAdcRdDataTVaspR;
	TAdcRdDataTBiasP xAdcRdDataTBiasP;
	TAdcRdDataTHkP xAdcRdDataTHkP;
	TAdcRdDataTTou1P xAdcRdDataTTou1P;
	TAdcRdDataTTou2P xAdcRdDataTTou2P;
	TAdcRdDataHkVode xAdcRdDataHkVode;
	TAdcRdDataHkVodf xAdcRdDataHkVodf;
	TAdcRdDataHkVrd xAdcRdDataHkVrd;
	TAdcRdDataHkVog xAdcRdDataHkVog;
	TAdcRdDataTCcd xAdcRdDataTCcd;
	TAdcRdDataTRef1KMea xAdcRdDataTRef1KMea;
	TAdcRdDataTRef649RMea xAdcRdDataTRef649RMea;
	TAdcRdDataHkAnaN5V xAdcRdDataHkAnaN5V;
	TAdcRdDataSRef xAdcRdDataSRef;
	TAdcRdDataHkCcdP31V xAdcRdDataHkCcdP31V;
	TAdcRdDataHkClkP15V xAdcRdDataHkClkP15V;
	TAdcRdDataHkAnaP5V xAdcRdDataHkAnaP5V;
	TAdcRdDataHkAnaP3V3 xAdcRdDataHkAnaP3V3;
	TAdcRdDataHkDigP3V3 xAdcRdDataHkDigP3V3;
	TAdcRdDataAdcRefBuf2 xAdcRdDataAdcRefBuf2;
	TAdc1RdConfig1 xAdc1RdConfig1;
	TAdc1RdConfig2 xAdc1RdConfig2;
	TAdc1RdConfig3 xAdc1RdConfig3;
	TAdc2RdConfig1 xAdc2RdConfig1;
	TAdc2RdConfig2 xAdc2RdConfig2;
	TAdc2RdConfig3 xAdc2RdConfig3;
	TVaspRdConfig xVaspRdConfig;
	TRevisionId1 xRevisionId1;
	TRevisionId2 xRevisionId2;
} TRmapAebAreaHk;

/* General Struct for RMAP DEB Memory Area Access */
typedef struct RmapMemDebArea {
	TRmapDebAreaCritCfg xRmapDebAreaCritCfg; /* RMAP DEB Critical Config Memory Area */
	TRmapDebAreaGenCfg xRmapDebAreaGenCfg; /* RMAP DEB General Config Memory Area */
	TRmapDebAreaHk xRmapDebAreaHk; /* RMAP DEB Housekeeping Memory Area */
} TRmapMemDebArea;

/* General Struct for RMAP AEB Memory Area Access */
typedef struct RmapMemAebArea {
	TRmapAebAreaCritCfg xRmapAebAreaCritCfg; /* RMAP AEB Critical Config Memory Area */
	TRmapAebAreaGenCfg xRmapAebAreaGenCfg; /* RMAP AEB General Config Memory Area */
	TRmapAebAreaHk xRmapAebAreaHk; /* RMAP AEB Housekeeping Memory Area */
} TRmapMemAebArea;

//! [public module structs definition]

//! [public function prototypes]
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DRIVER_COMM_RMAP_RMAP_MEM_AREA_H_ */
