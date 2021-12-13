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

/* RMAP RAM Memories Sizes (Dwords) */
#define RMAP_RAM_DEB_SIZE_DWORDS        32
#define RMAP_RAM_AEB_SIZE_DWORDS        128

/* Registers Addresses */

/* DEB Critical Configuration Area Registers Addresses */
enum RmapDebCritCfgRegsAddr {
	eRmapDebCritCfgDtcAebOnoffAddr = 0x00000000,
	eRmapDebCritCfgDtcPllReg_1Addr = 0x00000004,
	eRmapDebCritCfgDtcPllReg_2Addr = 0x00000008,
	eRmapDebCritCfgDtcPllReg_3Addr = 0x0000000C,
	eRmapDebCritCfgDtcPllReg_4Addr = 0x00000010,
	eRmapDebCritCfgDtcFeeModAddr   = 0x00000014,
	eRmapDebCritCfgDtcImmOnmodAddr = 0x00000018
} ERmapDebCritCfgRegsAddr;

/* DEB General Configuration Area Registers Addresses */
enum RmapDebGenCfgRegsAddr {
	eRmapDebGenCfgDtcInMod1Addr   = 0x00000104,
	eRmapDebGenCfgDtcInMod2Addr   = 0x00000108,
	eRmapDebGenCfgDtcWdwSizAddr   = 0x0000010C,
	eRmapDebGenCfgDtcWdwIdx1Addr  = 0x00000110,
	eRmapDebGenCfgDtcWdwIdx2Addr  = 0x00000114,
	eRmapDebGenCfgDtcWdwIdx3Addr  = 0x00000118,
	eRmapDebGenCfgDtcWdwIdx4Addr  = 0x0000011C,
	eRmapDebGenCfgDtcOvsDebAddr   = 0x00000120,
	eRmapDebGenCfgDtcSizDebAddr   = 0x00000124,
	eRmapDebGenCfgDtcTrg25SAddr   = 0x00000128,
	eRmapDebGenCfgDtcSelTrgAddr   = 0x0000012C,
	eRmapDebGenCfgDtcFrmCntAddr   = 0x00000130,
	eRmapDebGenCfgDtcSelSynAddr   = 0x00000134,
	eRmapDebGenCfgDtcRspCpsAddr   = 0x00000138,
	eRmapDebGenCfgDtc25SDlyAddr   = 0x0000013C,
	eRmapDebGenCfgDtcTmodConfAddr = 0x00000140,
	eRmapDebGenCfgDtcSpwCfgAddr   = 0x00000144
} ERmapDebGenCfgRegsAddr;

/* DEB Housekeeping Area Registers Addresses */
enum RmapDebHkRegsAddr {
	eRmapDebHkDebStatusAddr = 0x00001000,
	eRmapDebHkDebOvfAddr    = 0x00001004,
	eRmapDebHkSpwStatusAddr = 0x00001008,
	eRmapDebHkDebAhk1Addr   = 0x0000100C,
	eRmapDebHkDebAhk2Addr   = 0x00001010,
	eRmapDebHkDebAhk3Addr   = 0x00001014
} ERmapDebHkRegsAddr;

/* AEB Critical Configuration Area Registers Addresses */
enum RmapAebCritCfgRegsAddr {
	eRmapAebCritCfgAebControlAddr       = 0x00000000,
	eRmapAebCritCfgAebConfigAddr        = 0x00000004,
	eRmapAebCritCfgAebConfigKeyAddr     = 0x00000008,
	eRmapAebCritCfgAebConfigAit1Addr    = 0x0000000C,
	eRmapAebCritCfgAebConfigPatternAddr = 0x00000010,
	eRmapAebCritCfgVaspI2CControlAddr   = 0x00000014,
	eRmapAebCritCfgDacConfig1Addr       = 0x00000018,
	eRmapAebCritCfgDacConfig2Addr       = 0x0000001C,
	eRmapAebCritCfgPwrConfig1Addr       = 0x00000024,
	eRmapAebCritCfgPwrConfig2Addr       = 0x00000028,
	eRmapAebCritCfgPwrConfig3Addr       = 0x0000002C
} ERmapAebCritCfgRegsAddr;

/* AEB General Configuration Area Registers Addresses */
enum RmapAebGenCfgRegsAddr {
	eRmapAebGenCfgAdc1Config1Addr = 0x00000100,
	eRmapAebGenCfgAdc1Config2Addr = 0x00000104,
	eRmapAebGenCfgAdc1Config3Addr = 0x00000108,
	eRmapAebGenCfgAdc2Config1Addr = 0x0000010C,
	eRmapAebGenCfgAdc2Config2Addr = 0x00000110,
	eRmapAebGenCfgAdc2Config3Addr = 0x00000114,
	eRmapAebGenCfgSeqConfig1Addr  = 0x00000120,
	eRmapAebGenCfgSeqConfig2Addr  = 0x00000124,
	eRmapAebGenCfgSeqConfig3Addr  = 0x00000128,
	eRmapAebGenCfgSeqConfig4Addr  = 0x0000012C,
	eRmapAebGenCfgSeqConfig5Addr  = 0x00000130,
	eRmapAebGenCfgSeqConfig6Addr  = 0x00000134,
	eRmapAebGenCfgSeqConfig7Addr  = 0x00000138,
	eRmapAebGenCfgSeqConfig8Addr  = 0x0000013C,
	eRmapAebGenCfgSeqConfig9Addr  = 0x00000140,
	eRmapAebGenCfgSeqConfig10Addr = 0x00000144,
	eRmapAebGenCfgSeqConfig11Addr = 0x00000148,
	eRmapAebGenCfgSeqConfig12Addr = 0x0000014C,
	eRmapAebGenCfgSeqConfig13Addr = 0x00000150,
	eRmapAebGenCfgSeqConfig14Addr = 0x00000154,
	eRmapAebGenCfgSeqConfig15Addr = 0x00000158,
	eRmapAebGenCfgSeqConfig16Addr = 0x0000015C,
	eRmapAebGenCfgSeqConfig17Addr = 0x00000160,
	eRmapAebGenCfgSeqConfig18Addr = 0x00000164,
	eRmapAebGenCfgSeqConfig19Addr = 0x00000168,
	eRmapAebGenCfgSeqConfig20Addr = 0x0000016C,
	eRmapAebGenCfgSeqConfig21Addr = 0x00000170,
	eRmapAebGenCfgSeqConfig22Addr = 0x00000174,
	eRmapAebGenCfgSeqConfig23Addr = 0x00000178,
	eRmapAebGenCfgSeqConfig24Addr = 0x0000017C,
	eRmapAebGenCfgSeqConfig25Addr = 0x00000180,
	eRmapAebGenCfgSeqConfig26Addr = 0x00000184,
	eRmapAebGenCfgSeqConfig27Addr = 0x00000188,
	eRmapAebGenCfgSeqConfig28Addr = 0x0000018C,
	eRmapAebGenCfgSeqConfig29Addr = 0x00000190
} ERmapAebGenCfgRegsAddr;

/* AEB Housekeeping Area Registers Addresses */
enum RmapAebHkRegsAddr {
	eRmapAebHkAebStatusAddr     = 0x00001000,
	eRmapAebHkTimestamp1Addr    = 0x00001008,
	eRmapAebHkTimestamp2Addr    = 0x0000100C,
	eRmapAebHkAdcRdDataAddr     = 0x00001010,
	eRmapAebHkAdc1RdConfig1Addr = 0x00001080,
	eRmapAebHkAdc1RdConfig2Addr = 0x00001084,
	eRmapAebHkAdc1RdConfig3Addr = 0x00001088,
	eRmapAebHkAdc1RdConfig4Addr = 0x0000108C,
	eRmapAebHkAdc2RdConfig1Addr = 0x00001090,
	eRmapAebHkAdc2RdConfig2Addr = 0x00001094,
	eRmapAebHkAdc2RdConfig3Addr = 0x00001098,
	eRmapAebHkAdc2RdConfig4Addr = 0x0000109C,
	eRmapAebHkVaspRdConfigAddr  = 0x000010A0,
	eRmapAebHkSyncPeriod1Addr   = 0x000010E8,
	eRmapAebHkSyncPeriod2Addr   = 0x000010EC,
	eRmapAebHkRevisionId1Addr   = 0x000010F0,
	eRmapAebHkRevisionId2Addr   = 0x000010F4,
	eRmapAebHkRevisionId3Addr   = 0x000010F8,
	eRmapAebHkRevisionId4Addr   = 0x000010FC
} ERmapAebHkRegsAddr;

//! [constants definition]

//! [public module structs definition]

/* DEB Critical Configuration Area Register "DTC_AEB_ONOFF" Struct */
typedef struct DtcAebOnoff {
	bool bAebIdx4; /* "AEB_IDX4" Field */
	bool bAebIdx3; /* "AEB_IDX3" Field */
	bool bAebIdx2; /* "AEB_IDX2" Field */
	bool bAebIdx1; /* "AEB_IDX1" Field */
} TDtcAebOnoff;

/* DEB Critical Configuration Area Register "DTC_PLL_REG_0" Struct */
typedef struct DtcPllReg0 {
	bool bPfdfc; /* "PFDFC" Field */
	bool bGtme; /* "GTME" Field */
	bool bHoldtr; /* "HOLDTR" Field */
	bool bHoldf; /* "HOLDF" Field */
	alt_u32 ucOthers; /* FOFF, "LOCK1", "LOCK0", "LOCKW1", "LOCKW0", "C1", "C0" Fields */
} TDtcPllReg0;

/* DEB Critical Configuration Area Register "DTC_PLL_REG_1" Struct */
typedef struct DtcPllReg1 {
	alt_u32 uliOthers; /* "HOLD", "RESET", "RESHOL", "PD", "Y4MUX", "Y3MUX", "Y2MUX", "Y1MUX", "Y0MUX", "FB_MUX", "PFD", "CP_current", "PRECP", "CP_DIR", "C1", "C0" Fields */
} TDtcPllReg1;

/* DEB Critical Configuration Area Register "DTC_PLL_REG_2" Struct */
typedef struct DtcPllReg2 {
	alt_u32 uliOthers; /* 90DIV8, "90DIV4", "ADLOCK", "SXOIREF", "SREF", "Output_Y4_Mode", "Output_Y3_Mode", "Output_Y2_Mode", "Output_Y1_Mode", "Output_Y0_Mode", "OUTSEL4", "OUTSEL3", "OUTSEL2", "OUTSEL1", "OUTSEL0", "C1", "C0" Fields */
} TDtcPllReg2;

/* DEB Critical Configuration Area Register "DTC_PLL_REG_3" Struct */
typedef struct DtcPllReg3 {
	alt_u32 uliOthers; /* REFDEC, "MANAUT", "DLYN", "DLYM", "N", "M", "C1", "C0" Fields */
} TDtcPllReg3;

/* DEB Critical Configuration Area Register "DTC_FEE_MOD" Struct */
typedef struct DtcFeeMod {
	alt_u32 ucOperMod; /* "OPER_MOD" Field */
} TDtcFeeMod;

/* DEB Critical Configuration Area Register "DTC_IMM_ONMOD" Struct */
typedef struct DtcImmOnmod {
	bool bImmOn; /* "IMM_ON" Field */
} TDtcImmOnmod;

/* DEB General Configuration Area Register "DTC_IN_MOD" Struct */
typedef struct CfgDtcInMod {
	alt_u32 ucT7InMod; /* "T7_IN_MOD" Field */
	alt_u32 ucT6InMod; /* "T6_IN_MOD" Field */
	alt_u32 ucT5InMod; /* "T5_IN_MOD" Field */
	alt_u32 ucT4InMod; /* "T4_IN_MOD" Field */
	alt_u32 ucT3InMod; /* "T3_IN_MOD" Field */
	alt_u32 ucT2InMod; /* "T2_IN_MOD" Field */
	alt_u32 ucT1InMod; /* "T1_IN_MOD" Field */
	alt_u32 ucT0InMod; /* "T0_IN_MOD" Field */
} TCfgDtcInMod;

/* DEB General Configuration Area Register "DTC_WDW_SIZ" Struct */
typedef struct CfgDtcWdwSiz {
	alt_u32 ucWSizX; /* "W_SIZ_X" Field */
	alt_u32 ucWSizY; /* "W_SIZ_Y" Field */
} TCfgDtcWdwSiz;

/* DEB General Configuration Area Register "DTC_WDW_IDX" Struct */
typedef struct CfgDtcWdwIdx {
	alt_u32 usiWdwIdx4; /* "WDW_IDX_4" Field */
	alt_u32 usiWdwLen4; /* "WDW_LEN_4" Field */
	alt_u32 usiWdwIdx3; /* "WDW_IDX_3" Field */
	alt_u32 usiWdwLen3; /* "WDW_LEN_3" Field */
	alt_u32 usiWdwIdx2; /* "WDW_IDX_2" Field */
	alt_u32 usiWdwLen2; /* "WDW_LEN_2" Field */
	alt_u32 usiWdwIdx1; /* "WDW_IDX_1" Field */
	alt_u32 usiWdwLen1; /* "WDW_LEN_1" Field */
} TCfgDtcWdwIdx;

/* DEB General Configuration Area Register "DTC_OVS_DEB" Struct */
typedef struct CfgDtcOvsDeb {
	alt_u32 ucOvsLinDeb; /* "OVS_LIN_DEB" Field */
} TCfgDtcOvsDeb;

/* DEB General Configuration Area Register "DTC_SIZ_DEB" Struct */
typedef struct TCfgDtcSizDeb {
	alt_u32 usiNbLinDeb; /* "NB_LIN_DEB" Field */
	alt_u32 usiNbPixDeb; /* "NB_PIX_DEB" Field */
} TCfgDtcSizDeb;

/* DEB General Configuration Area Register "DTC_TRG_25S" Struct */
typedef struct CfgDtcTrg25S {
	alt_u32 ucN25SNCyc; /* "2_5S_N_CYC" Field */
} TCfgDtcTrg25S;

/* DEB General Configuration Area Register "DTC_SEL_TRG" Struct */
typedef struct CfgDtcSelTrg {
	bool bTrgSrc; /* "TRG_SRC" Field */
} TCfgDtcSelTrg;

/* DEB General Configuration Area Register "DTC_FRM_CNT" Struct */
typedef struct CfgDtcFrmCnt {
	alt_u32 usiPsetFrmCnt; /* "PSET_FRM_CNT" Field */
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
	alt_u32 ucTimecode; /* "TIMECODE" Field */
} TCfgDtcSpwCfg;

/* DEB Housekeeping Area Register "DEB_STATUS" Struct */
typedef struct DebStatus {
	alt_u32 ucOperMod; /* "OPER_MOD" Field */
	alt_u32 ucEdacListCorrErr; /* "EDAC_LIST_CORR_ERR" Field */
	alt_u32 ucEdacListUncorrErr; /* "EDAC_LIST_UNCORR_ERR" Field */
	alt_u32 ucOthers; /* "NB_PLLPERIOD", "PLL_REF", "PLL_VCXO", "PLL_LOCK" Fields */
	bool bVdigAeb4; /* "VDIG_AEB_4" Field */
	bool bVdigAeb3; /* "VDIG_AEB_3" Field */
	bool bVdigAeb2; /* "VDIG_AEB_2" Field */
	bool bVdigAeb1; /* "VDIG_AEB_1" Field */
	alt_u32 ucWdwListCntOvf; /* "WDW_LIST_CNT_OVF" Field */
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
	alt_u32 ucState4; /* "STATE_4" Field */
	bool bCrd4; /* "CRD_4" Field */
	bool bFifo4; /* "FIFO_4" Field */
	bool bEsc4; /* "ESC_4" Field */
	bool bPar4; /* "PAR_4" Field */
	bool bDisc4; /* "DISC_4" Field */
	alt_u32 ucState3; /* "STATE_3" Field */
	bool bCrd3; /* "CRD_3" Field */
	bool bFifo3; /* "FIFO_3" Field */
	bool bEsc3; /* "ESC_3" Field */
	bool bPar3; /* "PAR_3" Field */
	bool bDisc3; /* "DISC_3" Field */
	alt_u32 ucState2; /* "STATE_2" Field */
	bool bCrd2; /* "CRD_2" Field */
	bool bFifo2; /* "FIFO_2" Field */
	bool bEsc2; /* "ESC_2" Field */
	bool bPar2; /* "PAR_2" Field */
	bool bDisc2; /* "DISC_2" Field */
	alt_u32 ucState1; /* "STATE_1" Field */
	bool bCrd1; /* "CRD_1" Field */
	bool bFifo1; /* "FIFO_1" Field */
	bool bEsc1; /* "ESC_1" Field */
	bool bPar1; /* "PAR_1" Field */
	bool bDisc1; /* "DISC_1" Field */
} TSpwStatus;

/* DEB Housekeeping Area Register "DEB_AHK1" Struct */
typedef struct DebAhk1 {
	alt_u32 usiDebTemp; /* "DEB_TEMP" Field */
	alt_u32 usiVio; /* "VIO" Field */
} TDebAhk1;

/* DEB Housekeeping Area Register "DEB_AHK2" Struct */
typedef struct DebAhk2 {
	alt_u32 usiVlvd; /* "VLVD" Field */
	alt_u32 usiVcor; /* "VCOR" Field */
} TDebAhk2;

/* DEB Housekeeping Area Register "DEB_AHK3" Struct */
typedef struct DebAhk3 {
	alt_u32 ucStatusAeb4; /* "STATUS_AEB4" Field */
	alt_u32 ucStatusAeb3; /* "STATUS_AEB3" Field */
	alt_u32 ucStatusAeb2; /* "STATUS_AEB2" Field */
	alt_u32 ucStatusAeb1; /* "STATUS_AEB1" Field */
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
	TCfgDtcOvsDeb xCfgDtcOvsDeb;
	TCfgDtcSizDeb xCfgDtcSizDeb;
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
	alt_u32 ucReserved; /* "RESERVED" Field */
	alt_u32 ucNewState; /* "NEW_STATE" Field */
	bool bSetState; /* "SET_STATE" Field */
	bool bAebReset; /* "AEB_RESET" Field */
	alt_u32 uliOthers; /* RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields */
} TAebControl;

/* AEB Critical Configuration Area Register "AEB_CONFIG" Struct */
typedef struct AebConfig {
	alt_u32 uliOthers; /* RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields */
} TAebConfig;

/* AEB Critical Configuration Area Register "AEB_CONFIG_KEY" Struct */
typedef struct AebConfigKey {
	alt_u32 uliKey; /* "KEY" Field */
} TAebConfigKey;

/* AEB Critical Configuration Area Register "AEB_CONFIG_AIT" Struct */
typedef struct AebConfigAit {
	alt_u32 uliOthers; /* OVERRIDE_SW, "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields */
} TAebConfigAit;

/* AEB Critical Configuration Area Register "AEB_CONFIG_PATTERN" Struct */
typedef struct AebConfigPattern {
	alt_u32 ucPatternCcdid; /* "PATTERN_CCDID" Field */
	alt_u32 usiPatternCols; /* "PATTERN_COLS" Field */
	alt_u32 ucReserved; /* "RESERVED" Field */
	alt_u32 usiPatternRows; /* "PATTERN_ROWS" Field */
} TAebConfigPattern;

/* AEB Critical Configuration Area Register "VASP_I2C_CONTROL" Struct */
typedef struct VaspI2CControl {
	alt_u32 uliOthers; /* VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields */
} TVaspI2CControl;

/* AEB Critical Configuration Area Register "DAC_CONFIG_1" Struct */
typedef struct DacConfig1 {
	alt_u32 uliOthers; /* RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields */
} TDacConfig1;

/* AEB Critical Configuration Area Register "DAC_CONFIG_2" Struct */
typedef struct DacConfig2 {
	alt_u32 uliOthers; /* RESERVED_0, "DAC_VOD", "RESERVED_1" Fields */
} TDacConfig2;

/* AEB Critical Configuration Area Register "RESERVED_20" Struct */
typedef struct Reserved20 {
	alt_u32 uliReserved; /* "RESERVED" Field */
} TReserved20;

/* AEB Critical Configuration Area Register "PWR_CONFIG1" Struct */
typedef struct PwrConfig1 {
	alt_u32 ucTimeVccdOn; /* "TIME_VCCD_ON" Field */
	alt_u32 ucTimeVclkOn; /* "TIME_VCLK_ON" Field */
	alt_u32 ucTimeVan1On; /* "TIME_VAN1_ON" Field */
	alt_u32 ucTimeVan2On; /* "TIME_VAN2_ON" Field */
} TPwrConfig1;

/* AEB Critical Configuration Area Register "PWR_CONFIG2" Struct */
typedef struct PwrConfig2 {
	alt_u32 ucTimeVan3On; /* "TIME_VAN3_ON" Field */
	alt_u32 ucTimeVccdOff; /* "TIME_VCCD_OFF" Field */
	alt_u32 ucTimeVclkOff; /* "TIME_VCLK_OFF" Field */
	alt_u32 ucTimeVan1Off; /* "TIME_VAN1_OFF" Field */
} TPwrConfig2;

/* AEB Critical Configuration Area Register "PWR_CONFIG3" Struct */
typedef struct PwrConfig3 {
	alt_u32 ucTimeVan2Off; /* "TIME_VAN2_OFF" Field */
	alt_u32 ucTimeVan3Off; /* "TIME_VAN3_OFF" Field */
} TPwrConfig3;

/* AEB General Configuration Area Register "ADC1_CONFIG_1" Struct */
typedef struct Adc1Config1 {
	alt_u32 uliOthers; /* RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
} TAdc1Config1;

/* AEB General Configuration Area Register "ADC1_CONFIG_2" Struct */
typedef struct Adc1Config2 {
	alt_u32 uliOthers; /* AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
} TAdc1Config2;

/* AEB General Configuration Area Register "ADC1_CONFIG_3" Struct */
typedef struct Adc1Config3 {
	alt_u32 uliOthers; /* DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
} TAdc1Config3;

/* AEB General Configuration Area Register "ADC2_CONFIG_1" Struct */
typedef struct Adc2Config1 {
	alt_u32 uliOthers; /* RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
} TAdc2Config1;

/* AEB General Configuration Area Register "ADC2_CONFIG_2" Struct */
typedef struct Adc2Config2 {
	alt_u32 uliOthers; /* AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
} TAdc2Config2;

/* AEB General Configuration Area Register "ADC2_CONFIG_3" Struct */
typedef struct Adc2Config3 {
	alt_u32 uliOthers; /* DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
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
	alt_u32 uliOthers; /* "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields */
} TSeqConfig1;

/* AEB General Configuration Area Register "SEQ_CONFIG_2" Struct */
typedef struct SeqConfig2 {
	alt_u32 uliOthers; /* ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields */
} TSeqConfig2;

/* AEB General Configuration Area Register "SEQ_CONFIG_3" Struct */
typedef struct SeqConfig3 {
	alt_u32 uliOthers; /* RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields */
} TSeqConfig3;

/* AEB General Configuration Area Register "SEQ_CONFIG_4" Struct */
typedef struct SeqConfig4 {
	alt_u32 uliOthers; /* RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields */
} TSeqConfig4;

/* AEB General Configuration Area Register "SEQ_CONFIG_5" Struct */
typedef struct SeqConfig5 {
	alt_u32 uliOthers; /* SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields */
} TSeqConfig5;

/* AEB General Configuration Area Register "SEQ_CONFIG_6" Struct */
typedef struct SeqConfig6 {
	alt_u32 uliOthers; /* "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields */
} TSeqConfig6;

/* AEB General Configuration Area Register "SEQ_CONFIG_7" Struct */
typedef struct SeqConfig7 {
	alt_u32 uliOthers; /* "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields */
} TSeqConfig7;

/* AEB General Configuration Area Register "SEQ_CONFIG_8" Struct */
typedef struct SeqConfig8 {
	alt_u32 uliOthers; /* "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields */
} TSeqConfig8;

/* AEB General Configuration Area Register "SEQ_CONFIG_9" Struct */
typedef struct SeqConfig9 {
	alt_u32 uliOthers; /* "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields */
} TSeqConfig9;

/* AEB General Configuration Area Register "SEQ_CONFIG_10" Struct */
typedef struct SeqConfig10 {
	alt_u32 uliOthers; /* "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields */
} TSeqConfig10;

/* AEB General Configuration Area Register "SEQ_CONFIG_11" Struct */
typedef struct SeqConfig11 {
	alt_u32 uliOthers; /* "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields */
} TSeqConfig11;

/* AEB General Configuration Area Register "SEQ_CONFIG_12" Struct */
typedef struct SeqConfig12 {
	alt_u32 uliOthers; /* "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields */
} TSeqConfig12;

/* AEB General Configuration Area Register "SEQ_CONFIG_13" Struct */
typedef struct SeqConfig13 {
	alt_u32 uliOthers; /* "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields */
} TSeqConfig13;

/* AEB General Configuration Area Register "SEQ_CONFIG_14" Struct */
typedef struct SeqConfig14 {
	alt_u32 uliOthers; /* "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields */
} TSeqConfig14;

/* AEB General Configuration Area Register "SEQ_CONFIG_15" Struct */
typedef struct SeqConfig15 {
	alt_u32 uliOthers; /* "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields */
} TSeqConfig15;

/* AEB General Configuration Area Register "SEQ_CONFIG_16" Struct */
typedef struct SeqConfig16 {
	alt_u32 uliOthers; /* "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields */
} TSeqConfig16;

/* AEB General Configuration Area Register "SEQ_CONFIG_17" Struct */
typedef struct SeqConfig17 {
	alt_u32 uliOthers; /* "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields */
} TSeqConfig17;

/* AEB General Configuration Area Register "SEQ_CONFIG_18" Struct */
typedef struct SeqConfig18 {
	alt_u32 uliOthers; /* "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields */
} TSeqConfig18;

/* AEB General Configuration Area Register "SEQ_CONFIG_19" Struct */
typedef struct SeqConfig19 {
	alt_u32 uliOthers; /* "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields */
} TSeqConfig19;

/* AEB General Configuration Area Register "SEQ_CONFIG_20" Struct */
typedef struct SeqConfig20 {
	alt_u32 uliOthers; /* "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields */
} TSeqConfig20;

/* AEB General Configuration Area Register "SEQ_CONFIG_21" Struct */
typedef struct SeqConfig21 {
	alt_u32 uliOthers; /* "RESERVED" Field */
} TSeqConfig21;

/* AEB General Configuration Area Register "SEQ_CONFIG_22" Struct */
typedef struct SeqConfig22 {
	alt_u32 uliOthers; /* "RESERVED" Field */
} TSeqConfig22;

/* AEB General Configuration Area Register "SEQ_CONFIG_23" Struct */
typedef struct SeqConfig23 {
	alt_u32 uliOthers; /* "RESERVED" Field */
} TSeqConfig23;

/* AEB General Configuration Area Register "SEQ_CONFIG_24" Struct */
typedef struct SeqConfig24 {
	alt_u32 uliOthers; /* "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields */
} TSeqConfig24;

/* AEB General Configuration Area Register "SEQ_CONFIG_25" Struct */
typedef struct SeqConfig25 {
	alt_u32 uliOthers; /* "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields */
} TSeqConfig25;

/* AEB General Configuration Area Register "SEQ_CONFIG_26" Struct */
typedef struct SeqConfig26 {
	alt_u32 uliOthers; /* "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields */
} TSeqConfig26;

/* AEB General Configuration Area Register "SEQ_CONFIG_27" Struct */
typedef struct SeqConfig27 {
	alt_u32 uliOthers; /* "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields */
} TSeqConfig27;

/* AEB General Configuration Area Register "SEQ_CONFIG_28" Struct */
typedef struct SeqConfig28 {
	alt_u32 uliOthers; /* "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields */
} TSeqConfig28;

/* AEB General Configuration Area Register "SEQ_CONFIG_29" Struct */
typedef struct SeqConfig29 {
	alt_u32 uliOthers; /* "RESERVED" Field */
} TSeqConfig29;

/* AEB Housekeeping Area Register "AEB_STATUS" Struct */
typedef struct AebStatus {
	alt_u32 ucAebStatus; /* "AEB_STATUS" Field */
	alt_u32 ucOthers0; /* VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields */
	alt_u32 usiOthers1; /* DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields */
	alt_u32 ucOthers2; /* "VASP2_DELAYED", "VASP1_DELAYED", "VASP2_ERROR", "VASP1_ERROR" Fields */
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
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields */
} TAdcRdDataTVaspL;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_VASP_R" Struct */
typedef struct AdcRdDataTVaspR {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields */
} TAdcRdDataTVaspR;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P" Struct */
typedef struct AdcRdDataTBiasP {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields */
} TAdcRdDataTBiasP;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_HK_P" Struct */
typedef struct AdcRdDataTHkP {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields */
} TAdcRdDataTHkP;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P" Struct */
typedef struct AdcRdDataTTou1P {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields */
} TAdcRdDataTTou1P;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P" Struct */
typedef struct AdcRdDataTTou2P {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields */
} TAdcRdDataTTou2P;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODE" Struct */
typedef struct AdcRdDataHkVode {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields */
} TAdcRdDataHkVode;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_VODF" Struct */
typedef struct AdcRdDataHkVodf {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields */
} TAdcRdDataHkVodf;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_VRD" Struct */
typedef struct AdcRdDataHkVrd {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields */
} TAdcRdDataHkVrd;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_VOG" Struct */
typedef struct AdcRdDataHkVog {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields */
} TAdcRdDataHkVog;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_CCD" Struct */
typedef struct AdcRdDataTCcd {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields */
} TAdcRdDataTCcd;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA" Struct */
typedef struct AdcRdDataTRef1KMea {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields */
} TAdcRdDataTRef1KMea;

/* AEB Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA" Struct */
typedef struct AdcRdDataTRef649RMea {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields */
} TAdcRdDataTRef649RMea;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V" Struct */
typedef struct AdcRdDataHkAnaN5V {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields */
} TAdcRdDataHkAnaN5V;

/* AEB Housekeeping Area Register "ADC_RD_DATA_S_REF" Struct */
typedef struct AdcRdDataSRef {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields */
} TAdcRdDataSRef;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V" Struct */
typedef struct AdcRdDataHkCcdP31V {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields */
} TAdcRdDataHkCcdP31V;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V" Struct */
typedef struct AdcRdDataHkClkP15V {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields */
} TAdcRdDataHkClkP15V;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V" Struct */
typedef struct AdcRdDataHkAnaP5V {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields */
} TAdcRdDataHkAnaP5V;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3" Struct */
typedef struct AdcRdDataHkAnaP3V3 {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields */
} TAdcRdDataHkAnaP3V3;

/* AEB Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3" Struct */
typedef struct AdcRdDataHkDigP3V3 {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields */
} TAdcRdDataHkDigP3V3;

/* AEB Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2" Struct */
typedef struct AdcRdDataAdcRefBuf2 {
	alt_u32 uliOthers; /* NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields */
} TAdcRdDataAdcRefBuf2;

/* AEB Housekeeping Area Register "ADC1_RD_CONFIG_1" Struct */
typedef struct Adc1RdConfig1 {
	alt_u32 ucOthers0; /* SPIRST, "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT" Fields */
	alt_u32 uliOthers1; /* IDLMOD, "DLY2", "DLY1", "DLY0", "SBCS1", "SBCS0", "DRATE1", "DRATE0", "AINP3", "AINP2", "AINP1", "AINP0", "AINN3", "AINN2", "AINN1", "AINN0", "DIFF7", "DIFF6", "DIFF5", "DIFF4", "DIFF3", "DIFF2", "DIFF1", "DIFF0" Fields */
} TAdc1RdConfig1;

/* AEB Housekeeping Area Register "ADC1_RD_CONFIG_2" Struct */
typedef struct Adc1RdConfig2 {
	alt_u32 usiOthers0; /* AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8" Fields */
	alt_u32 ucOthers1; /* REF, "GAIN", "TEMP", "VCC" Fields */
	alt_u32 usiOthers2; /* OFFSET, "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
} TAdc1RdConfig2;

/* AEB Housekeeping Area Register "ADC1_RD_CONFIG_3" Struct */
typedef struct Adc1RdConfig3 {
	alt_u32 ucOthers0; /* DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0" Fields */
	alt_u32 ucOthers1; /* "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
} TAdc1RdConfig3;

/* AEB Housekeeping Area Register "ADC2_RD_CONFIG_1" Struct */
typedef struct Adc2RdConfig1 {
	alt_u32 ucOthers0; /* SPIRST, "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT" Fields */
	alt_u32 uliOthers1; /* IDLMOD, "DLY2", "DLY1", "DLY0", "SBCS1", "SBCS0", "DRATE1", "DRATE0", "AINP3", "AINP2", "AINP1", "AINP0", "AINN3", "AINN2", "AINN1", "AINN0", "DIFF7", "DIFF6", "DIFF5", "DIFF4", "DIFF3", "DIFF2", "DIFF1", "DIFF0" Fields */
} TAdc2RdConfig1;

/* AEB Housekeeping Area Register "ADC2_RD_CONFIG_2" Struct */
typedef struct Adc2RdConfig2 {
	alt_u32 usiOthers0; /* AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8" Fields */
	alt_u32 ucOthers1; /* REF, "GAIN", "TEMP", "VCC" Fields */
	alt_u32 usiOthers2; /* OFFSET, "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
} TAdc2RdConfig2;

/* AEB Housekeeping Area Register "ADC2_RD_CONFIG_3" Struct */
typedef struct Adc2RdConfig3 {
	alt_u32 ucOthers0; /* DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0" Fields */
	alt_u32 ucOthers1; /* "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
} TAdc2RdConfig3;

/* AEB Housekeeping Area Register "ADC2_RD_CONFIG_4" Struct */
typedef struct Adc2RdConfig4 {
	alt_u32 uliOthers; /* "RESERVED" Field */
} TAdc2RdConfig4;

/* AEB Housekeeping Area Register "VASP_RD_CONFIG" Struct */
typedef struct VaspRdConfig {
	alt_u32 usiOthers; /* VASP1_READ_DATA, "VASP2_READ_DATA" Fields */
} TVaspRdConfig;

/* AEB Housekeeping Area Register "SYNC_PERIOD_1" Struct */
typedef struct SyncPeriod1 {
	alt_u32 uliSyncPeriod1; /* "SYNC_PERIOD" Field */
} TSyncPeriod1;

/* AEB Housekeeping Area Register "SYNC_PERIOD_2" Struct */
typedef struct SyncPeriod2 {
	alt_u32 uliSyncPeriod2; /* "SYNC_PERIOD" Field */
} TSyncPeriod2;

/* AEB Housekeeping Area Register "REVISION_ID_1" Struct */
typedef struct RevisionId1 {
	alt_u32 uliOthers; /* FPGA_VERSION, "FPGA_DATE" Fields */
} TRevisionId1;

/* AEB Housekeeping Area Register "REVISION_ID_2" Struct */
typedef struct RevisionId2 {
	alt_u32 uliOthers; /* FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields */
} TRevisionId2;

/* AEB Housekeeping Area Register "REVISION_ID_3" Struct */
typedef struct RevisionId3 {
	alt_u32 uliOthers; /* "RESERVED" Field */
} TRevisionId3;

/* AEB Housekeeping Area Register "REVISION_ID_4" Struct */
typedef struct RevisionId4 {
	alt_u32 uliOthers; /* "RESERVED" Field */
} TRevisionId4;

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
	TSeqConfig15 xSeqConfig15;
	TSeqConfig16 xSeqConfig16;
	TSeqConfig17 xSeqConfig17;
	TSeqConfig18 xSeqConfig18;
	TSeqConfig19 xSeqConfig19;
	TSeqConfig20 xSeqConfig20;
	TSeqConfig21 xSeqConfig21;
	TSeqConfig22 xSeqConfig22;
	TSeqConfig23 xSeqConfig23;
	TSeqConfig24 xSeqConfig24;
	TSeqConfig25 xSeqConfig25;
	TSeqConfig26 xSeqConfig26;
	TSeqConfig27 xSeqConfig27;
	TSeqConfig28 xSeqConfig28;
	TSeqConfig29 xSeqConfig29;
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
	TAdc2RdConfig4 xAdc2RdConfig4;
	TVaspRdConfig xVaspRdConfig;
	TSyncPeriod1 xSyncPeriod1;
	TSyncPeriod2 xSyncPeriod2;
	TRevisionId1 xRevisionId1;
	TRevisionId2 xRevisionId2;
	TRevisionId3 xRevisionId3;
	TRevisionId4 xRevisionId4;
} TRmapAebAreaHk;

/* General Struct for RMAP RAM Memory Direct Access */
typedef struct RmapRamDirAcc {
	alt_u32 uliRamMemAddr;
	alt_u32 uliRamMemData;
} TRmapRamDirAcc;

/* General Struct for RMAP DEB Memory Area Access */
typedef struct RmapMemDebArea {
	TRmapDebAreaCritCfg xRmapDebAreaCritCfg; /* RMAP DEB Critical Config Memory Area */
	TRmapDebAreaGenCfg xRmapDebAreaGenCfg; /* RMAP DEB General Config Memory Area */
	TRmapDebAreaHk xRmapDebAreaHk; /* RMAP DEB Housekeeping Memory Area */
	TRmapRamDirAcc xRmapRamDirAcc; /* RMAP RAM Memory Direct Access */
} TRmapMemDebArea;

/* General Struct for RMAP AEB Memory Area Access */
typedef struct RmapMemAebArea {
	TRmapAebAreaCritCfg xRmapAebAreaCritCfg; /* RMAP AEB Critical Config Memory Area */
	TRmapAebAreaGenCfg xRmapAebAreaGenCfg; /* RMAP AEB General Config Memory Area */
	TRmapAebAreaHk xRmapAebAreaHk; /* RMAP AEB Housekeeping Memory Area */
	TRmapRamDirAcc xRmapRamDirAcc; /* RMAP RAM Memory Direct Access */
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
