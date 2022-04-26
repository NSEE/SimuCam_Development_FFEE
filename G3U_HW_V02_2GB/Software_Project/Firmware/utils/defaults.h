/*
 * defaults.h
 *
 *  Created on: 29 de set de 2020
 *      Author: rfranca
 */

#ifndef UTILS_DEFAULTS_H_
#define UTILS_DEFAULTS_H_

#include "../simucam_definitions.h"
#include "meb.h"
#include "configs_simucam.h"
#include "../driver/comm/comm.h"

//! [constants definition]
#define DEFT_MEB_DEFS_ID_LOWER_LIM      0
#define DEFT_FEE_DEFS_ID_LOWER_LIM      1000
#define DEFT_NUC_DEFS_ID_LOWER_LIM      10000
#define DEFT_NUC_DEFS_ID_RESERVED       0xFFFF
#define DEFT_NUC_DEFS_ID_CURRENT_IP     0xD02A
#define DEFT_RETRANSMISSION_TIMEOUT     5

/* General Simulation Parameters IDs */
enum DeftGenSimulationParamsID {
	eDeftMebOverScanSerialId       = 4,  /* CCD Serial Overscan Columns */
	eDeftMebPreScanSerialId        = 5,  /* CCD Serial Prescan Columns */
	eDeftMebOLNId                  = 6,  /* CCD Parallel Overscan Lines */
	eDeftMebColsId                 = 7,  /* CCD Columns */
	eDeftMebRowsId                 = 8,  /* CCD Image Lines */
	eDeftMebExposurePeriodId       = 9,  /* SimuCam Exposure Period [ms] */
	eDeftMebBufferOverflowEnId     = 11, /* Output Buffer Overflow Enable */
	eDeftMebStartDelayId           = 12, /* CCD Start Readout Delay [ms] */
	eDeftMebSkipDelayId            = 13, /* CCD Line Skip Delay [ns] */
	eDeftMebLineDelayId            = 14, /* CCD Line Transfer Delay [ns] */
	eDeftMebADCPixelDelayId        = 15, /* CCD ADC And Pixel Transfer Delay [ns] */
	eDeftMebDebugLevelId           = 20, /* Serial Messages Debug Level */
	eDeftMebGuardFeeDelayId        = 22, /* FEEs Guard Delay [ms] */
	eDeftMebSyncSourceId           = 26, /* SimuCam Synchronism Source (0 = Internal / 1 = External) */
	eDeftMebUseBackupSpwChannelsId = 30  /* Activate the backup SpaceWire channels for the F-FEE Simulation entity */
} EDeftGenSimulationParamsID;

/* SpaceWire Interface Parameters */
enum DeftSpwInterfaceParamsID {
	eDeftSpwSpwLinkStartId           = 3000, /* SpaceWire link set as Link Start */
	eDeftSpwSpwLinkAutostartId       = 3001, /* SpaceWire link set as Link Auto-Start */
	eDeftSpwSpwLinkSpeedId           = 3002, /* SpaceWire Link Speed [Mhz] */
	eDeftSpwTimeCodeTransmissionEnId = 3003, /* Timecode Transmission Enable */
	eDeftSpwLogicalAddrId            = 3004, /* RMAP Logical Address */
	eDeftSpwRmapKeyId                = 3005, /* RMAP Key */
	eDeftSpwDataProtIdId             = 3006, /* Data Packet Protocol ID */
	eDeftSpwDpuLogicalAddrId         = 3007, /* Data Packet Target Logical Address */
	eDeftSpwWinSpwPLengthId          = 3008, /* Window Mode Data packet length [B] */
	eDeftSpwFullSpwPLengthId         = 3009  /* Full-Image Mode Data packet length [B] */
} EDeftSpwInterfaceParamsID;

/* F-FEE DEB Critical Configuration RMAP Area */
enum DeftFfeeDebCritCfgRmapAreaID {
	eDeftFfeeDebAreaCritCfgDtcAebOnoffAebIdx4Id = 4000, /* F-FEE DEB Critical Configuration Area Register "DTC_AEB_ONOFF", "AEB_IDX4" Field */
	eDeftFfeeDebAreaCritCfgDtcAebOnoffAebIdx3Id = 4001, /* F-FEE DEB Critical Configuration Area Register "DTC_AEB_ONOFF", "AEB_IDX3" Field */
	eDeftFfeeDebAreaCritCfgDtcAebOnoffAebIdx2Id = 4002, /* F-FEE DEB Critical Configuration Area Register "DTC_AEB_ONOFF", "AEB_IDX2" Field */
	eDeftFfeeDebAreaCritCfgDtcAebOnoffAebIdx1Id = 4003, /* F-FEE DEB Critical Configuration Area Register "DTC_AEB_ONOFF", "AEB_IDX1" Field */
	eDeftFfeeDebAreaCritCfgDtcPllReg0PfdfcId    = 4004, /* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_0", "PFDFC" Field */
	eDeftFfeeDebAreaCritCfgDtcPllReg0GtmeId     = 4005, /* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_0", "GTME" Field */
	eDeftFfeeDebAreaCritCfgDtcPllReg0HoldtrId   = 4006, /* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_0", "HOLDTR" Field */
	eDeftFfeeDebAreaCritCfgDtcPllReg0HoldfId    = 4007, /* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_0", "HOLDF" Field */
	eDeftFfeeDebAreaCritCfgDtcPllReg0OthersId   = 4008, /* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_0", FOFF, "LOCK1", "LOCK0", "LOCKW1", "LOCKW0", "C1", "C0" Fields */
	eDeftFfeeDebAreaCritCfgDtcPllReg1OthersId   = 4009, /* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_1", "HOLD", "RESET", "RESHOL", "PD", "Y4MUX", "Y3MUX", "Y2MUX", "Y1MUX", "Y0MUX", "FB_MUX", "PFD", "CP_current", "PRECP", "CP_DIR", "C1", "C0" Fields */
	eDeftFfeeDebAreaCritCfgDtcPllReg2OthersId   = 4010, /* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_2", 90DIV8, "90DIV4", "ADLOCK", "SXOIREF", "SREF", "Output_Y4_Mode", "Output_Y3_Mode", "Output_Y2_Mode", "Output_Y1_Mode", "Output_Y0_Mode", "OUTSEL4", "OUTSEL3", "OUTSEL2", "OUTSEL1", "OUTSEL0", "C1", "C0" Fields */
	eDeftFfeeDebAreaCritCfgDtcPllReg3OthersId   = 4011, /* F-FEE DEB Critical Configuration Area Register "DTC_PLL_REG_3", REFDEC, "MANAUT", "DLYN", "DLYM", "N", "M", "C1", "C0" Fields */
	eDeftFfeeDebAreaCritCfgDtcFeeModOperModId   = 4012, /* F-FEE DEB Critical Configuration Area Register "DTC_FEE_MOD", "OPER_MOD" Field */
	eDeftFfeeDebAreaCritCfgDtcImmOnmodImmOnId   = 4013  /* F-FEE DEB Critical Configuration Area Register "DTC_IMM_ONMOD", "IMM_ON" Field */
} EDeftFfeeDebCritCfgRmapAreaID;

/* F-FEE DEB General Configuration RMAP Area */
enum DeftFfeeDebGenCfgRmapAreaID {
	eDeftFfeeDebAreaGenCfgCfgDtcInModT7InModId     = 4200, /* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T7_IN_MOD" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcInModT6InModId     = 4201, /* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T6_IN_MOD" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcInModT5InModId     = 4202, /* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T5_IN_MOD" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcInModT4InModId     = 4203, /* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T4_IN_MOD" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcInModT3InModId     = 4204, /* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T3_IN_MOD" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcInModT2InModId     = 4205, /* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T2_IN_MOD" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcInModT1InModId     = 4206, /* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T1_IN_MOD" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcInModT0InModId     = 4207, /* F-FEE DEB General Configuration Area Register "DTC_IN_MOD", "T0_IN_MOD" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcWdwSizWSizXId      = 4208, /* F-FEE DEB General Configuration Area Register "DTC_WDW_SIZ", "W_SIZ_X" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcWdwSizWSizYId      = 4209, /* F-FEE DEB General Configuration Area Register "DTC_WDW_SIZ", "W_SIZ_Y" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwIdx4Id    = 4210, /* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_IDX_4" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwLen4Id    = 4211, /* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_LEN_4" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwIdx3Id    = 4212, /* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_IDX_3" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwLen3Id    = 4213, /* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_LEN_3" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwIdx2Id    = 4214, /* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_IDX_2" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwLen2Id    = 4215, /* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_LEN_2" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwIdx1Id    = 4216, /* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_IDX_1" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcWdwIdxWdwLen1Id    = 4217, /* F-FEE DEB General Configuration Area Register "DTC_WDW_IDX", "WDW_LEN_1" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcOvsDebOvsLinDebId  = 4218, /* F-FEE DEB General Configuration Area Register "DTC_OVS_DEB", "OVS_LIN_DEB" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcSizDebNbLinDebId   = 4219, /* F-FEE DEB General Configuration Area Register "DTC_SIZ_DEB", "NB_LIN_DEB" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcSizDebNbPixDebId   = 4220, /* F-FEE DEB General Configuration Area Register "DTC_SIZ_DEB", "NB_PIX_DEB" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcTrg25SN25SNCycId   = 4221, /* F-FEE DEB General Configuration Area Register "DTC_TRG_25S", "2_5S_N_CYC" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcSelTrgTrgSrcId     = 4222, /* F-FEE DEB General Configuration Area Register "DTC_SEL_TRG", "TRG_SRC" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcFrmCntPsetFrmCntId = 4223, /* F-FEE DEB General Configuration Area Register "DTC_FRM_CNT", "PSET_FRM_CNT" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcSelSynSynFrqId     = 4224, /* F-FEE DEB General Configuration Area Register "DTC_SEL_SYN", "SYN_FRQ" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcRstCpsRstSpwId     = 4225, /* F-FEE DEB General Configuration Area Register "DTC_RST_CPS", "RST_SPW" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcRstCpsRstWdgId     = 4226, /* F-FEE DEB General Configuration Area Register "DTC_RST_CPS", "RST_WDG" Field */
	eDeftFfeeDebAreaGenCfgCfgDtc25SDlyN25SDlyId    = 4227, /* F-FEE DEB General Configuration Area Register "DTC_25S_DLY", "25S_DLY" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcTmodConfReservedId = 4228, /* F-FEE DEB General Configuration Area Register "DTC_TMOD_CONF", "RESERVED" Field */
	eDeftFfeeDebAreaGenCfgCfgDtcSpwCfgTimecodeId   = 4229  /* F-FEE DEB General Configuration Area Register "DTC_SPW_CFG", "TIMECODE" Field */
} EDeftFfeeDebGenCfgRmapAreaID;

/* F-FEE DEB Housekeeping Configuration RMAP Area */
enum DeftFfeeDebHkRmapAreaID {
	eDeftFfeeDebAreaHkDebStatusOperModId           = 4400, /* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "OPER_MOD" Field */
	eDeftFfeeDebAreaHkDebStatusEdacListCorrErrId   = 4401, /* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "EDAC_LIST_CORR_ERR" Field */
	eDeftFfeeDebAreaHkDebStatusEdacListUncorrErrId = 4402, /* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "EDAC_LIST_UNCORR_ERR" Field */
	eDeftFfeeDebAreaHkDebStatusOthersId            = 4403, /* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "NB_PLLPERIOD", "PLL_REF", "PLL_VCXO", "PLL_LOCK" Fields */
	eDeftFfeeDebAreaHkDebStatusVdigAeb4Id          = 4404, /* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "VDIG_AEB_4" Field */
	eDeftFfeeDebAreaHkDebStatusVdigAeb3Id          = 4405, /* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "VDIG_AEB_3" Field */
	eDeftFfeeDebAreaHkDebStatusVdigAeb2Id          = 4406, /* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "VDIG_AEB_2" Field */
	eDeftFfeeDebAreaHkDebStatusVdigAeb1Id          = 4407, /* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "VDIG_AEB_1" Field */
	eDeftFfeeDebAreaHkDebStatusWdwListCntOvfId     = 4408, /* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "WDW_LIST_CNT_OVF" Field */
	eDeftFfeeDebAreaHkDebStatusWdgId               = 4409, /* F-FEE DEB Housekeeping Area Register "DEB_STATUS", "WDG" Field */
	eDeftFfeeDebAreaHkDebOvfRowActList8Id          = 4410, /* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_8" Field */
	eDeftFfeeDebAreaHkDebOvfRowActList7Id          = 4411, /* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_7" Field */
	eDeftFfeeDebAreaHkDebOvfRowActList6Id          = 4412, /* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_6" Field */
	eDeftFfeeDebAreaHkDebOvfRowActList5Id          = 4413, /* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_5" Field */
	eDeftFfeeDebAreaHkDebOvfRowActList4Id          = 4414, /* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_4" Field */
	eDeftFfeeDebAreaHkDebOvfRowActList3Id          = 4415, /* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_3" Field */
	eDeftFfeeDebAreaHkDebOvfRowActList2Id          = 4416, /* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_2" Field */
	eDeftFfeeDebAreaHkDebOvfRowActList1Id          = 4417, /* F-FEE DEB Housekeeping Area Register "DEB_OVF", "ROW_ACT_LIST_1" Field */
	eDeftFfeeDebAreaHkDebAhk1VioId                 = 4419, /* F-FEE DEB Housekeeping Area Register "DEB_AHK1", "VIO" Field */
	eDeftFfeeDebAreaHkDebAhk2VcorId                = 4420, /* F-FEE DEB Housekeeping Area Register "DEB_AHK2", "VCOR" Field */
	eDeftFfeeDebAreaHkDebAhk2VlvdId                = 4421, /* F-FEE DEB Housekeeping Area Register "DEB_AHK2", "VLVD" Field */
	eDeftFfeeDebAreaHkDebAhk1DebTempId             = 4422, /* F-FEE DEB Housekeeping Area Register "DEB_AHK1", "DEB_TEMP" Field */
	eDeftFfeeDebAreaHkDebAhk3StatusAeb4Id          = 4423, /* F-FEE DEB Housekeeping Area Register "DEB_AHK3", "STATUS_AEB4" Field */
	eDeftFfeeDebAreaHkDebAhk3StatusAeb3Id          = 4424, /* F-FEE DEB Housekeeping Area Register "DEB_AHK3", "STATUS_AEB3" Field */
	eDeftFfeeDebAreaHkDebAhk3StatusAeb2Id          = 4425, /* F-FEE DEB Housekeeping Area Register "DEB_AHK3", "STATUS_AEB2" Field */
	eDeftFfeeDebAreaHkDebAhk3StatusAeb1Id          = 4426  /* F-FEE DEB Housekeeping Area Register "DEB_AHK3", "STATUS_AEB1" Field */
} EDeftFfeeDebHkRmapAreaID;

/* F-FEE AEB 1 Critical Configuration RMAP Area */
enum DeftFfeeAeb1CritCfgRmapAreaID {
	eDeftFfeeAeb1AreaCritCfgAebControlReserved0Id          = 5000, /* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONTROL", "RESERVED" Field */
	eDeftFfeeAeb1AreaCritCfgAebControlNewStateId           = 5001, /* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONTROL", "NEW_STATE" Field */
	eDeftFfeeAeb1AreaCritCfgAebControlSetStateId           = 5002, /* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONTROL", "SET_STATE" Field */
	eDeftFfeeAeb1AreaCritCfgAebControlAebResetId           = 5003, /* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONTROL", "AEB_RESET" Field */
	eDeftFfeeAeb1AreaCritCfgAebControlOthersId             = 5004, /* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONTROL", RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields */
	eDeftFfeeAeb1AreaCritCfgAebConfigOthersId              = 5005, /* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONFIG", RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields */
	eDeftFfeeAeb1AreaCritCfgAebConfigKeyKeyId              = 5006, /* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONFIG_KEY", "KEY" Field */
	eDeftFfeeAeb1AreaCritCfgAebConfigAitOthersId           = 5007, /* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONFIG_AIT", "OVERRIDE_SW", "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields */
	eDeftFfeeAeb1AreaCritCfgAebConfigPatternPatternCcdidId = 5008, /* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_CCDID" Field */
	eDeftFfeeAeb1AreaCritCfgAebConfigPatternPatternColsId  = 5009, /* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_COLS" Field */
	eDeftFfeeAeb1AreaCritCfgAebConfigPatternReservedId     = 5010, /* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "RESERVED" Field */
	eDeftFfeeAeb1AreaCritCfgAebConfigPatternPatternRowsId  = 5011, /* F-FEE AEB 1 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_ROWS" Field */
	eDeftFfeeAeb1AreaCritCfgVaspI2CControlOthersId         = 5012, /* F-FEE AEB 1 Critical Configuration Area Register "VASP_I2C_CONTROL", VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields */
	eDeftFfeeAeb1AreaCritCfgDacConfig1OthersId             = 5013, /* F-FEE AEB 1 Critical Configuration Area Register "DAC_CONFIG_1", RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields */
	eDeftFfeeAeb1AreaCritCfgDacConfig2OthersId             = 5014, /* F-FEE AEB 1 Critical Configuration Area Register "DAC_CONFIG_2", RESERVED_0, "DAC_VOD", "RESERVED_1" Fields */
	eDeftFfeeAeb1AreaCritCfgReserved20ReservedId           = 5015, /* F-FEE AEB 1 Critical Configuration Area Register "RESERVED_20", "RESERVED" Field */
	eDeftFfeeAeb1AreaCritCfgPwrConfig1TimeVccdOnId         = 5016, /* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCCD_ON" Field */
	eDeftFfeeAeb1AreaCritCfgPwrConfig1TimeVclkOnId         = 5017, /* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCLK_ON" Field */
	eDeftFfeeAeb1AreaCritCfgPwrConfig1TimeVan1OnId         = 5018, /* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN1_ON" Field */
	eDeftFfeeAeb1AreaCritCfgPwrConfig1TimeVan2OnId         = 5019, /* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN2_ON" Field */
	eDeftFfeeAeb1AreaCritCfgPwrConfig2TimeVan3OnId         = 5020, /* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN3_ON" Field */
	eDeftFfeeAeb1AreaCritCfgPwrConfig2TimeVccdOffId        = 5021, /* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCCD_OFF" Field */
	eDeftFfeeAeb1AreaCritCfgPwrConfig2TimeVclkOffId        = 5022, /* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCLK_OFF" Field */
	eDeftFfeeAeb1AreaCritCfgPwrConfig2TimeVan1OffId        = 5023, /* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN1_OFF" Field */
	eDeftFfeeAeb1AreaCritCfgPwrConfig3TimeVan2OffId        = 5024, /* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN2_OFF" Field */
	eDeftFfeeAeb1AreaCritCfgPwrConfig3TimeVan3OffId        = 5025  /* F-FEE AEB 1 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN3_OFF" Field */
} EDeftFfeeAeb1CritCfgRmapAreaID;

/* F-FEE AEB 1 General Configuration RMAP Area */
enum DeftFfeeAeb1GenCfgRmapAreaID {
	eDeftFfeeAeb1AreaGenCfgAdc1Config1OthersId          = 5200, /* F-FEE AEB 1 General Configuration Area Register "ADC1_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
	eDeftFfeeAeb1AreaGenCfgAdc1Config2OthersId          = 5201, /* F-FEE AEB 1 General Configuration Area Register "ADC1_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
	eDeftFfeeAeb1AreaGenCfgAdc1Config3OthersId          = 5202, /* F-FEE AEB 1 General Configuration Area Register "ADC1_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
	eDeftFfeeAeb1AreaGenCfgAdc2Config1OthersId          = 5203, /* F-FEE AEB 1 General Configuration Area Register "ADC2_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
	eDeftFfeeAeb1AreaGenCfgAdc2Config2OthersId          = 5204, /* F-FEE AEB 1 General Configuration Area Register "ADC2_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
	eDeftFfeeAeb1AreaGenCfgAdc2Config3OthersId          = 5205, /* F-FEE AEB 1 General Configuration Area Register "ADC2_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
	eDeftFfeeAeb1AreaGenCfgReserved118ReservedId        = 5206, /* F-FEE AEB 1 General Configuration Area Register "RESERVED_118", "RESERVED" Field */
	eDeftFfeeAeb1AreaGenCfgReserved11CReservedId        = 5207, /* F-FEE AEB 1 General Configuration Area Register "RESERVED_11C", "RESERVED" Field */
	eDeftFfeeAeb1AreaGenCfgSeqConfig1OthersId           = 5208, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_1", "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig2OthersId           = 5209, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_2", ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig3OthersId           = 5210, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_3", RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig4OthersId           = 5211, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_4", RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig5OthersId           = 5212, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_5", SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig6OthersId           = 5213, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_6", "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig14OthersId          = 5239,  /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_14", "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig7OthersId           = 5240, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_7", "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig8OthersId           = 5241, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_8", "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig9OthersId           = 5242, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_9", "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig10OthersId          = 5243, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_10", "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig11OthersId          = 5244, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_11", "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig12OthersId          = 5245, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_12", "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig13OthersId          = 5246, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_13", "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig15OthersId          = 5247, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_15", "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig16OthersId          = 5248, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_16", "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig17OthersId          = 5249, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_17", "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig18OthersId          = 5250, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_18", "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig19OthersId          = 5251, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_19", "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig20OthersId          = 5252, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_20", "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig21OthersId          = 5253, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_21", "RESERVED" Field */
	eDeftFfeeAeb1AreaGenCfgSeqConfig22OthersId          = 5254, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_22", "RESERVED" Field */
	eDeftFfeeAeb1AreaGenCfgSeqConfig23OthersId          = 5255, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_23", "RESERVED" Field */
	eDeftFfeeAeb1AreaGenCfgSeqConfig24OthersId          = 5256, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_24", "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig25OthersId          = 5257, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_25", "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig26OthersId          = 5258, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_26", "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig27OthersId          = 5259, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_27", "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig28OthersId          = 5260, /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_28", "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields */
	eDeftFfeeAeb1AreaGenCfgSeqConfig29OthersId          = 5261  /* F-FEE AEB 1 General Configuration Area Register "SEQ_CONFIG_29", "RESERVED" Field */
} EDeftFfeeAeb1GenCfgRmapAreaID;

/* F-FEE AEB 1 Housekeeping Configuration RMAP Area */
enum DeftFfeeAeb1HkRmapAreaID {
	eDeftFfeeAeb1AreaHkAebStatusAebStatusId         = 5400, /* F-FEE AEB 1 Housekeeping Area Register "AEB_STATUS", "AEB_STATUS" Field */
	eDeftFfeeAeb1AreaHkAebStatusOthers0Id           = 5401, /* F-FEE AEB 1 Housekeeping Area Register "AEB_STATUS", VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields */
	eDeftFfeeAeb1AreaHkAebStatusOthers1Id           = 5402, /* F-FEE AEB 1 Housekeeping Area Register "AEB_STATUS", DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields */
	eDeftFfeeAeb1AreaHkTimestamp1TimestampDword1Id  = 5403, /* F-FEE AEB 1 Housekeeping Area Register "TIMESTAMP_1", "TIMESTAMP_DWORD_1" Field */
	eDeftFfeeAeb1AreaHkTimestamp2TimestampDword0Id  = 5404, /* F-FEE AEB 1 Housekeeping Area Register "TIMESTAMP_2", "TIMESTAMP_DWORD_0" Field */
	eDeftFfeeAeb1AreaHkAdcRdDataTVaspLOthersId      = 5405, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_VASP_L", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataTVaspROthersId      = 5406, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_VASP_R", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataTBiasPOthersId      = 5407, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataTHkPOthersId        = 5408, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_HK_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataTTou1POthersId      = 5409, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataTTou2POthersId      = 5410, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataHkVodeOthersId      = 5411, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_VODE", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataHkVodfOthersId      = 5412, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_VODF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataHkVrdOthersId       = 5413, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_VRD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataHkVogOthersId       = 5414, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_VOG", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataTCcdOthersId        = 5415, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_CCD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataTRef1KMeaOthersId   = 5416, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataTRef649RMeaOthersId = 5417, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataHkAnaN5VOthersId    = 5418, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataSRefOthersId        = 5419, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_S_REF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataHkCcdP31VOthersId   = 5420, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataHkClkP15VOthersId   = 5421, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataHkAnaP5VOthersId    = 5422, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataHkAnaP3V3OthersId   = 5423, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataHkDigP3V3OthersId   = 5424, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields */
	eDeftFfeeAeb1AreaHkAdcRdDataAdcRefBuf2OthersId  = 5425, /* F-FEE AEB 1 Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields */
	eDeftFfeeAeb1AreaHkVaspRdConfigOthersId         = 5426, /* F-FEE AEB 1 Housekeeping Area Register "VASP_RD_CONFIG", VASP1_READ_DATA, "VASP2_READ_DATA" Fields */
	eDeftFfeeAeb1AreaHkRevisionId1OthersId          = 5427, /* F-FEE AEB 1 Housekeeping Area Register "REVISION_ID_1", FPGA_VERSION, "FPGA_DATE" Fields */
	eDeftFfeeAeb1AreaHkRevisionId2OthersId          = 5428, /* F-FEE AEB 1 Housekeeping Area Register "REVISION_ID_2", FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields */
	eDeftFfeeAeb1AreaHkAebStatusucOthers2Id         = 5429, /* F-FEE AEB 1 Housekeeping Area Register "AEB_STATUS", "VASP2_DELAYED", "VASP1_DELAYED", "VASP2_ERROR", "VASP1_ERROR" Fields */
	eDeftFfeeAeb1AreaHkAdc1RdConfig3ucOthers1Id     = 5430, /* F-FEE AEB 1 Housekeeping Area Register "ADC1_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
	eDeftFfeeAeb1AreaHkAdc2RdConfig3ucOthers1Id     = 5431  /* F-FEE AEB 1 Housekeeping Area Register "ADC2_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
} EDeftFfeeAeb1HkRmapAreaID;

/* F-FEE AEB 2 Critical Configuration RMAP Area */
enum DeftFfeeAeb2CritCfgRmapAreaID {
	eDeftFfeeAeb2AreaCritCfgAebControlReserved0Id          = 6000, /* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONTROL", "RESERVED" Field */
	eDeftFfeeAeb2AreaCritCfgAebControlNewStateId           = 6001, /* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONTROL", "NEW_STATE" Field */
	eDeftFfeeAeb2AreaCritCfgAebControlSetStateId           = 6002, /* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONTROL", "SET_STATE" Field */
	eDeftFfeeAeb2AreaCritCfgAebControlAebResetId           = 6003, /* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONTROL", "AEB_RESET" Field */
	eDeftFfeeAeb2AreaCritCfgAebControlOthersId             = 6004, /* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONTROL", RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields */
	eDeftFfeeAeb2AreaCritCfgAebConfigOthersId              = 6005, /* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONFIG", RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields */
	eDeftFfeeAeb2AreaCritCfgAebConfigKeyKeyId              = 6006, /* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONFIG_KEY", "KEY" Field */
	eDeftFfeeAeb2AreaCritCfgAebConfigAitOthersId           = 6007, /* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONFIG_AIT", "OVERRIDE_SW", "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields */
	eDeftFfeeAeb2AreaCritCfgAebConfigPatternPatternCcdidId = 6008, /* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_CCDID" Field */
	eDeftFfeeAeb2AreaCritCfgAebConfigPatternPatternColsId  = 6009, /* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_COLS" Field */
	eDeftFfeeAeb2AreaCritCfgAebConfigPatternReservedId     = 6010, /* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "RESERVED" Field */
	eDeftFfeeAeb2AreaCritCfgAebConfigPatternPatternRowsId  = 6011, /* F-FEE AEB 2 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_ROWS" Field */
	eDeftFfeeAeb2AreaCritCfgVaspI2CControlOthersId         = 6012, /* F-FEE AEB 2 Critical Configuration Area Register "VASP_I2C_CONTROL", VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields */
	eDeftFfeeAeb2AreaCritCfgDacConfig1OthersId             = 6013, /* F-FEE AEB 2 Critical Configuration Area Register "DAC_CONFIG_1", RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields */
	eDeftFfeeAeb2AreaCritCfgDacConfig2OthersId             = 6014, /* F-FEE AEB 2 Critical Configuration Area Register "DAC_CONFIG_2", RESERVED_0, "DAC_VOD", "RESERVED_1" Fields */
	eDeftFfeeAeb2AreaCritCfgReserved20ReservedId           = 6015, /* F-FEE AEB 2 Critical Configuration Area Register "RESERVED_20", "RESERVED" Field */
	eDeftFfeeAeb2AreaCritCfgPwrConfig1TimeVccdOnId         = 6016, /* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCCD_ON" Field */
	eDeftFfeeAeb2AreaCritCfgPwrConfig1TimeVclkOnId         = 6017, /* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCLK_ON" Field */
	eDeftFfeeAeb2AreaCritCfgPwrConfig1TimeVan1OnId         = 6018, /* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN1_ON" Field */
	eDeftFfeeAeb2AreaCritCfgPwrConfig1TimeVan2OnId         = 6019, /* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN2_ON" Field */
	eDeftFfeeAeb2AreaCritCfgPwrConfig2TimeVan3OnId         = 6020, /* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN3_ON" Field */
	eDeftFfeeAeb2AreaCritCfgPwrConfig2TimeVccdOffId        = 6021, /* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCCD_OFF" Field */
	eDeftFfeeAeb2AreaCritCfgPwrConfig2TimeVclkOffId        = 6022, /* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCLK_OFF" Field */
	eDeftFfeeAeb2AreaCritCfgPwrConfig2TimeVan1OffId        = 6023, /* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN1_OFF" Field */
	eDeftFfeeAeb2AreaCritCfgPwrConfig3TimeVan2OffId        = 6024, /* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN2_OFF" Field */
	eDeftFfeeAeb2AreaCritCfgPwrConfig3TimeVan3OffId        = 6025  /* F-FEE AEB 2 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN3_OFF" Field */
} EDeftFfeeAeb2CritCfgRmapAreaID;

/* F-FEE AEB 2 General Configuration RMAP Area */
enum DeftFfeeAeb2GenCfgRmapAreaID {
	eDeftFfeeAeb2AreaGenCfgAdc1Config1OthersId          = 6200, /* F-FEE AEB 2 General Configuration Area Register "ADC1_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
	eDeftFfeeAeb2AreaGenCfgAdc1Config2OthersId          = 6201, /* F-FEE AEB 2 General Configuration Area Register "ADC1_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
	eDeftFfeeAeb2AreaGenCfgAdc1Config3OthersId          = 6202, /* F-FEE AEB 2 General Configuration Area Register "ADC1_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
	eDeftFfeeAeb2AreaGenCfgAdc2Config1OthersId          = 6203, /* F-FEE AEB 2 General Configuration Area Register "ADC2_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
	eDeftFfeeAeb2AreaGenCfgAdc2Config2OthersId          = 6204, /* F-FEE AEB 2 General Configuration Area Register "ADC2_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
	eDeftFfeeAeb2AreaGenCfgAdc2Config3OthersId          = 6205, /* F-FEE AEB 2 General Configuration Area Register "ADC2_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
	eDeftFfeeAeb2AreaGenCfgReserved118ReservedId        = 6206, /* F-FEE AEB 2 General Configuration Area Register "RESERVED_118", "RESERVED" Field */
	eDeftFfeeAeb2AreaGenCfgReserved11CReservedId        = 6207, /* F-FEE AEB 2 General Configuration Area Register "RESERVED_11C", "RESERVED" Field */
	eDeftFfeeAeb2AreaGenCfgSeqConfig1OthersId           = 6208, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_1", "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig2OthersId           = 6209, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_2", ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig3OthersId           = 6210, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_3", RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig4OthersId           = 6211, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_4", RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig5OthersId           = 6212, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_5", SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig6OthersId           = 6213, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_6", "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig14OthersId          = 6239, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_14", "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig7OthersId           = 6240, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_7", "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig8OthersId           = 6241, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_8", "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig9OthersId           = 6242, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_9", "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig10OthersId          = 6243, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_10", "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig11OthersId          = 6244, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_11", "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig12OthersId          = 6245, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_12", "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig13OthersId          = 6246, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_13", "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig15OthersId          = 6247, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_15", "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig16OthersId          = 6248, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_16", "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig17OthersId          = 6249, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_17", "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig18OthersId          = 6250, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_18", "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig19OthersId          = 6251, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_19", "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig20OthersId          = 6252, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_20", "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig21OthersId          = 6253, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_21", "RESERVED" Field */
	eDeftFfeeAeb2AreaGenCfgSeqConfig22OthersId          = 6254, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_22", "RESERVED" Field */
	eDeftFfeeAeb2AreaGenCfgSeqConfig23OthersId          = 6255, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_23", "RESERVED" Field */
	eDeftFfeeAeb2AreaGenCfgSeqConfig24OthersId          = 6256, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_24", "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig25OthersId          = 6257, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_25", "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig26OthersId          = 6258, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_26", "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig27OthersId          = 6259, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_27", "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig28OthersId          = 6260, /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_28", "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields */
	eDeftFfeeAeb2AreaGenCfgSeqConfig29OthersId          = 6261  /* F-FEE AEB 2 General Configuration Area Register "SEQ_CONFIG_29", "RESERVED" Field */
} EDeftFfeeAeb2GenCfgRmapAreaID;

/* F-FEE AEB 2 Housekeeping Configuration RMAP Area */
enum DeftFfeeAeb2HkRmapAreaID {
	eDeftFfeeAeb2AreaHkAebStatusAebStatusId         = 6400, /* F-FEE AEB 2 Housekeeping Area Register "AEB_STATUS", "AEB_STATUS" Field */
	eDeftFfeeAeb2AreaHkAebStatusOthers0Id           = 6401, /* F-FEE AEB 2 Housekeeping Area Register "AEB_STATUS", VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields */
	eDeftFfeeAeb2AreaHkAebStatusOthers1Id           = 6402, /* F-FEE AEB 2 Housekeeping Area Register "AEB_STATUS", DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields */
	eDeftFfeeAeb2AreaHkTimestamp1TimestampDword1Id  = 6403, /* F-FEE AEB 2 Housekeeping Area Register "TIMESTAMP_1", "TIMESTAMP_DWORD_1" Field */
	eDeftFfeeAeb2AreaHkTimestamp2TimestampDword0Id  = 6404, /* F-FEE AEB 2 Housekeeping Area Register "TIMESTAMP_2", "TIMESTAMP_DWORD_0" Field */
	eDeftFfeeAeb2AreaHkAdcRdDataTVaspLOthersId      = 6405, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_VASP_L", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataTVaspROthersId      = 6406, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_VASP_R", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataTBiasPOthersId      = 6407, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataTHkPOthersId        = 6408, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_HK_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataTTou1POthersId      = 6409, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataTTou2POthersId      = 6410, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataHkVodeOthersId      = 6411, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_VODE", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataHkVodfOthersId      = 6412, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_VODF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataHkVrdOthersId       = 6413, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_VRD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataHkVogOthersId       = 6414, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_VOG", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataTCcdOthersId        = 6415, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_CCD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataTRef1KMeaOthersId   = 6416, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataTRef649RMeaOthersId = 6417, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataHkAnaN5VOthersId    = 6418, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataSRefOthersId        = 6419, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_S_REF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataHkCcdP31VOthersId   = 6420, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataHkClkP15VOthersId   = 6421, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataHkAnaP5VOthersId    = 6422, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataHkAnaP3V3OthersId   = 6423, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataHkDigP3V3OthersId   = 6424, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields */
	eDeftFfeeAeb2AreaHkAdcRdDataAdcRefBuf2OthersId  = 6425, /* F-FEE AEB 2 Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields */
	eDeftFfeeAeb2AreaHkVaspRdConfigOthersId         = 6426, /* F-FEE AEB 2 Housekeeping Area Register "VASP_RD_CONFIG", VASP1_READ_DATA, "VASP2_READ_DATA" Fields */
	eDeftFfeeAeb2AreaHkRevisionId1OthersId          = 6427, /* F-FEE AEB 2 Housekeeping Area Register "REVISION_ID_1", FPGA_VERSION, "FPGA_DATE" Fields */
	eDeftFfeeAeb2AreaHkRevisionId2OthersId          = 6428, /* F-FEE AEB 2 Housekeeping Area Register "REVISION_ID_2", FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields */
	eDeftFfeeAeb2AreaHkAebStatusucOthers2Id         = 6429, /* F-FEE AEB 2 Housekeeping Area Register "AEB_STATUS", "VASP2_DELAYED", "VASP1_DELAYED", "VASP2_ERROR", "VASP1_ERROR" Fields */
	eDeftFfeeAeb2AreaHkAdc1RdConfig3ucOthers1Id     = 6430, /* F-FEE AEB 2 Housekeeping Area Register "ADC1_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
	eDeftFfeeAeb2AreaHkAdc2RdConfig3ucOthers1Id     = 6431  /* F-FEE AEB 2 Housekeeping Area Register "ADC2_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
} EDeftFfeeAeb2HkRmapAreaID;

/* F-FEE AEB 3 Critical Configuration RMAP Area */
enum DeftFfeeAeb3CritCfgRmapAreaID {
	eDeftFfeeAeb3AreaCritCfgAebControlReserved0Id          = 7000, /* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONTROL", "RESERVED" Field */
	eDeftFfeeAeb3AreaCritCfgAebControlNewStateId           = 7001, /* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONTROL", "NEW_STATE" Field */
	eDeftFfeeAeb3AreaCritCfgAebControlSetStateId           = 7002, /* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONTROL", "SET_STATE" Field */
	eDeftFfeeAeb3AreaCritCfgAebControlAebResetId           = 7003, /* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONTROL", "AEB_RESET" Field */
	eDeftFfeeAeb3AreaCritCfgAebControlOthersId             = 7004, /* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONTROL", RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields */
	eDeftFfeeAeb3AreaCritCfgAebConfigOthersId              = 7005, /* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONFIG", RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields */
	eDeftFfeeAeb3AreaCritCfgAebConfigKeyKeyId              = 7006, /* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONFIG_KEY", "KEY" Field */
	eDeftFfeeAeb3AreaCritCfgAebConfigAitOthersId           = 7007, /* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONFIG_AIT", "OVERRIDE_SW", "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields */
	eDeftFfeeAeb3AreaCritCfgAebConfigPatternPatternCcdidId = 7008, /* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_CCDID" Field */
	eDeftFfeeAeb3AreaCritCfgAebConfigPatternPatternColsId  = 7009, /* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_COLS" Field */
	eDeftFfeeAeb3AreaCritCfgAebConfigPatternReservedId     = 7010, /* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "RESERVED" Field */
	eDeftFfeeAeb3AreaCritCfgAebConfigPatternPatternRowsId  = 7011, /* F-FEE AEB 3 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_ROWS" Field */
	eDeftFfeeAeb3AreaCritCfgVaspI2CControlOthersId         = 7012, /* F-FEE AEB 3 Critical Configuration Area Register "VASP_I2C_CONTROL", VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields */
	eDeftFfeeAeb3AreaCritCfgDacConfig1OthersId             = 7013, /* F-FEE AEB 3 Critical Configuration Area Register "DAC_CONFIG_1", RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields */
	eDeftFfeeAeb3AreaCritCfgDacConfig2OthersId             = 7014, /* F-FEE AEB 3 Critical Configuration Area Register "DAC_CONFIG_2", RESERVED_0, "DAC_VOD", "RESERVED_1" Fields */
	eDeftFfeeAeb3AreaCritCfgReserved20ReservedId           = 7015, /* F-FEE AEB 3 Critical Configuration Area Register "RESERVED_20", "RESERVED" Field */
	eDeftFfeeAeb3AreaCritCfgPwrConfig1TimeVccdOnId         = 7016, /* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCCD_ON" Field */
	eDeftFfeeAeb3AreaCritCfgPwrConfig1TimeVclkOnId         = 7017, /* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCLK_ON" Field */
	eDeftFfeeAeb3AreaCritCfgPwrConfig1TimeVan1OnId         = 7018, /* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN1_ON" Field */
	eDeftFfeeAeb3AreaCritCfgPwrConfig1TimeVan2OnId         = 7019, /* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN2_ON" Field */
	eDeftFfeeAeb3AreaCritCfgPwrConfig2TimeVan3OnId         = 7020, /* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN3_ON" Field */
	eDeftFfeeAeb3AreaCritCfgPwrConfig2TimeVccdOffId        = 7021, /* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCCD_OFF" Field */
	eDeftFfeeAeb3AreaCritCfgPwrConfig2TimeVclkOffId        = 7022, /* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCLK_OFF" Field */
	eDeftFfeeAeb3AreaCritCfgPwrConfig2TimeVan1OffId        = 7023, /* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN1_OFF" Field */
	eDeftFfeeAeb3AreaCritCfgPwrConfig3TimeVan2OffId        = 7024, /* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN2_OFF" Field */
	eDeftFfeeAeb3AreaCritCfgPwrConfig3TimeVan3OffId        = 7025  /* F-FEE AEB 3 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN3_OFF" Field */
} EDeftFfeeAeb3CritCfgRmapAreaID;

/* F-FEE AEB 3 General Configuration RMAP Area */
enum DeftFfeeAeb3GenCfgRmapAreaID {
	eDeftFfeeAeb3AreaGenCfgAdc1Config1OthersId          = 7200, /* F-FEE AEB 3 General Configuration Area Register "ADC1_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
	eDeftFfeeAeb3AreaGenCfgAdc1Config2OthersId          = 7201, /* F-FEE AEB 3 General Configuration Area Register "ADC1_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
	eDeftFfeeAeb3AreaGenCfgAdc1Config3OthersId          = 7202, /* F-FEE AEB 3 General Configuration Area Register "ADC1_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
	eDeftFfeeAeb3AreaGenCfgAdc2Config1OthersId          = 7203, /* F-FEE AEB 3 General Configuration Area Register "ADC2_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
	eDeftFfeeAeb3AreaGenCfgAdc2Config2OthersId          = 7204, /* F-FEE AEB 3 General Configuration Area Register "ADC2_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
	eDeftFfeeAeb3AreaGenCfgAdc2Config3OthersId          = 7205, /* F-FEE AEB 3 General Configuration Area Register "ADC2_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
	eDeftFfeeAeb3AreaGenCfgReserved118ReservedId        = 7206, /* F-FEE AEB 3 General Configuration Area Register "RESERVED_118", "RESERVED" Field */
	eDeftFfeeAeb3AreaGenCfgReserved11CReservedId        = 7207, /* F-FEE AEB 3 General Configuration Area Register "RESERVED_11C", "RESERVED" Field */
	eDeftFfeeAeb3AreaGenCfgSeqConfig1OthersId           = 7208, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_1", "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig2OthersId           = 7209, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_2", ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig3OthersId           = 7210, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_3", RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig4OthersId           = 7211, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_4", RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig5OthersId           = 7212, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_5", SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig6OthersId           = 7213, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_6", "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig14OthersId          = 7239, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_14", "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig7OthersId           = 7240, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_7", "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig8OthersId           = 7241, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_8", "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig9OthersId           = 7242, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_9", "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig10OthersId          = 7243, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_10", "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig11OthersId          = 7244, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_11", "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig12OthersId          = 7245, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_12", "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig13OthersId          = 7246, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_13", "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig15OthersId          = 7247, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_15", "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig16OthersId          = 7248, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_16", "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig17OthersId          = 7249, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_17", "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig18OthersId          = 7250, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_18", "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig19OthersId          = 7251, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_19", "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig20OthersId          = 7252, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_20", "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig21OthersId          = 7253, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_21", "RESERVED" Field */
	eDeftFfeeAeb3AreaGenCfgSeqConfig22OthersId          = 7254, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_22", "RESERVED" Field */
	eDeftFfeeAeb3AreaGenCfgSeqConfig23OthersId          = 7255, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_23", "RESERVED" Field */
	eDeftFfeeAeb3AreaGenCfgSeqConfig24OthersId          = 7256, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_24", "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig25OthersId          = 7257, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_25", "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig26OthersId          = 7258, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_26", "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig27OthersId          = 7259, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_27", "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig28OthersId          = 7260, /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_28", "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields */
	eDeftFfeeAeb3AreaGenCfgSeqConfig29OthersId          = 7261  /* F-FEE AEB 3 General Configuration Area Register "SEQ_CONFIG_29", "RESERVED" Field */
} EDeftFfeeAeb3GenCfgRmapAreaID;

/* F-FEE AEB 3 Housekeeping Configuration RMAP Area */
enum DeftFfeeAeb3HkRmapAreaID {
	eDeftFfeeAeb3AreaHkAebStatusAebStatusId         = 7400, /* F-FEE AEB 3 Housekeeping Area Register "AEB_STATUS", "AEB_STATUS" Field */
	eDeftFfeeAeb3AreaHkAebStatusOthers0Id           = 7401, /* F-FEE AEB 3 Housekeeping Area Register "AEB_STATUS", VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields */
	eDeftFfeeAeb3AreaHkAebStatusOthers1Id           = 7402, /* F-FEE AEB 3 Housekeeping Area Register "AEB_STATUS", DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields */
	eDeftFfeeAeb3AreaHkTimestamp1TimestampDword1Id  = 7403, /* F-FEE AEB 3 Housekeeping Area Register "TIMESTAMP_1", "TIMESTAMP_DWORD_1" Field */
	eDeftFfeeAeb3AreaHkTimestamp2TimestampDword0Id  = 7404, /* F-FEE AEB 3 Housekeeping Area Register "TIMESTAMP_2", "TIMESTAMP_DWORD_0" Field */
	eDeftFfeeAeb3AreaHkAdcRdDataTVaspLOthersId      = 7405, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_VASP_L", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataTVaspROthersId      = 7406, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_VASP_R", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataTBiasPOthersId      = 7407, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataTHkPOthersId        = 7408, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_HK_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataTTou1POthersId      = 7409, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataTTou2POthersId      = 7410, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataHkVodeOthersId      = 7411, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_VODE", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataHkVodfOthersId      = 7412, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_VODF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataHkVrdOthersId       = 7413, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_VRD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataHkVogOthersId       = 7414, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_VOG", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataTCcdOthersId        = 7415, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_CCD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataTRef1KMeaOthersId   = 7416, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataTRef649RMeaOthersId = 7417, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataHkAnaN5VOthersId    = 7418, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataSRefOthersId        = 7419, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_S_REF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataHkCcdP31VOthersId   = 7420, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataHkClkP15VOthersId   = 7421, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataHkAnaP5VOthersId    = 7422, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataHkAnaP3V3OthersId   = 7423, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataHkDigP3V3OthersId   = 7424, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields */
	eDeftFfeeAeb3AreaHkAdcRdDataAdcRefBuf2OthersId  = 7425, /* F-FEE AEB 3 Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields */
	eDeftFfeeAeb3AreaHkVaspRdConfigOthersId         = 7426, /* F-FEE AEB 3 Housekeeping Area Register "VASP_RD_CONFIG", VASP1_READ_DATA, "VASP2_READ_DATA" Fields */
	eDeftFfeeAeb3AreaHkRevisionId1OthersId          = 7427, /* F-FEE AEB 3 Housekeeping Area Register "REVISION_ID_1", FPGA_VERSION, "FPGA_DATE" Fields */
	eDeftFfeeAeb3AreaHkRevisionId2OthersId          = 7428, /* F-FEE AEB 3 Housekeeping Area Register "REVISION_ID_2", FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields */
	eDeftFfeeAeb3AreaHkAebStatusucOthers2Id         = 7429, /* F-FEE AEB 3 Housekeeping Area Register "AEB_STATUS", "VASP2_DELAYED", "VASP1_DELAYED", "VASP2_ERROR", "VASP1_ERROR" Fields */
	eDeftFfeeAeb3AreaHkAdc1RdConfig3ucOthers1Id     = 7430, /* F-FEE AEB 3 Housekeeping Area Register "ADC1_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
	eDeftFfeeAeb3AreaHkAdc2RdConfig3ucOthers1Id     = 7431  /* F-FEE AEB 3 Housekeeping Area Register "ADC2_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
} EDeftFfeeAeb3HkRmapAreaID;

/* F-FEE AEB 4 Critical Configuration RMAP Area */
enum DeftFfeeAeb4CritCfgRmapAreaID {
	eDeftFfeeAeb4AreaCritCfgAebControlReserved0Id          = 8000, /* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONTROL", "RESERVED" Field */
	eDeftFfeeAeb4AreaCritCfgAebControlNewStateId           = 8001, /* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONTROL", "NEW_STATE" Field */
	eDeftFfeeAeb4AreaCritCfgAebControlSetStateId           = 8002, /* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONTROL", "SET_STATE" Field */
	eDeftFfeeAeb4AreaCritCfgAebControlAebResetId           = 8003, /* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONTROL", "AEB_RESET" Field */
	eDeftFfeeAeb4AreaCritCfgAebControlOthersId             = 8004, /* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONTROL", RESERVED_1, "ADC_DATA_RD", "ADC_CFG_WR", "ADC_CFG_RD", "DAC_WR", "RESERVED_2" Fields */
	eDeftFfeeAeb4AreaCritCfgAebConfigOthersId              = 8005, /* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONFIG", RESERVED_0, "WATCH-DOG_DIS", "INT_SYNC", "RESERVED_1", "VASP_CDS_EN", "VASP2_CAL_EN", "VASP1_CAL_EN", "RESERVED_2" Fields */
	eDeftFfeeAeb4AreaCritCfgAebConfigKeyKeyId              = 8006, /* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONFIG_KEY", "KEY" Field */
	eDeftFfeeAeb4AreaCritCfgAebConfigAitOthersId           = 8007, /* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONFIG_AIT", "OVERRIDE_SW", "RESERVED_0", "SW_VAN3", "SW_VAN2", "SW_VAN1", "SW_VCLK", "SW_VCCD", "OVERRIDE_VASP", "RESERVED_1", "VASP2_PIX_EN", "VASP1_PIX_EN", "VASP2_ADC_EN", "VASP1_ADC_EN", "VASP2_RESET", "VASP1_RESET", "OVERRIDE_ADC", "ADC2_EN_P5V0", "ADC1_EN_P5V0", "PT1000_CAL_ON_N", "EN_V_MUX_N", "ADC2_PWDN_N", "ADC1_PWDN_N", "ADC_CLK_EN", "ADC2_SPI_EN", "ADC1_SPI_EN", "OVERRIDE_SEQ", "RESERVED_2", "APPLICOS_MODE", "SEQ_TEST" Fields */
	eDeftFfeeAeb4AreaCritCfgAebConfigPatternPatternCcdidId = 8008, /* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_CCDID" Field */
	eDeftFfeeAeb4AreaCritCfgAebConfigPatternPatternColsId  = 8009, /* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_COLS" Field */
	eDeftFfeeAeb4AreaCritCfgAebConfigPatternReservedId     = 8010, /* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "RESERVED" Field */
	eDeftFfeeAeb4AreaCritCfgAebConfigPatternPatternRowsId  = 8011, /* F-FEE AEB 4 Critical Configuration Area Register "AEB_CONFIG_PATTERN", "PATTERN_ROWS" Field */
	eDeftFfeeAeb4AreaCritCfgVaspI2CControlOthersId         = 8012, /* F-FEE AEB 4 Critical Configuration Area Register "VASP_I2C_CONTROL", VASP_CFG_ADDR, "VASP1_CFG_DATA", "VASP2_CFG_DATA", "RESERVED", "VASP2_SELECT", "VASP1_SELECT", "CALIBRATION_START", "I2C_READ_START", "I2C_WRITE_START" Fields */
	eDeftFfeeAeb4AreaCritCfgDacConfig1OthersId             = 8013, /* F-FEE AEB 4 Critical Configuration Area Register "DAC_CONFIG_1", RESERVED_0, "DAC_VOG", "RESERVED_1", "DAC_VRD" Fields */
	eDeftFfeeAeb4AreaCritCfgDacConfig2OthersId             = 8014, /* F-FEE AEB 4 Critical Configuration Area Register "DAC_CONFIG_2", RESERVED_0, "DAC_VOD", "RESERVED_1" Fields */
	eDeftFfeeAeb4AreaCritCfgReserved20ReservedId           = 8015, /* F-FEE AEB 4 Critical Configuration Area Register "RESERVED_20", "RESERVED" Field */
	eDeftFfeeAeb4AreaCritCfgPwrConfig1TimeVccdOnId         = 8016, /* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCCD_ON" Field */
	eDeftFfeeAeb4AreaCritCfgPwrConfig1TimeVclkOnId         = 8017, /* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VCLK_ON" Field */
	eDeftFfeeAeb4AreaCritCfgPwrConfig1TimeVan1OnId         = 8018, /* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN1_ON" Field */
	eDeftFfeeAeb4AreaCritCfgPwrConfig1TimeVan2OnId         = 8019, /* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG1", "TIME_VAN2_ON" Field */
	eDeftFfeeAeb4AreaCritCfgPwrConfig2TimeVan3OnId         = 8020, /* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN3_ON" Field */
	eDeftFfeeAeb4AreaCritCfgPwrConfig2TimeVccdOffId        = 8021, /* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCCD_OFF" Field */
	eDeftFfeeAeb4AreaCritCfgPwrConfig2TimeVclkOffId        = 8022, /* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VCLK_OFF" Field */
	eDeftFfeeAeb4AreaCritCfgPwrConfig2TimeVan1OffId        = 8023, /* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG2", "TIME_VAN1_OFF" Field */
	eDeftFfeeAeb4AreaCritCfgPwrConfig3TimeVan2OffId        = 8024, /* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN2_OFF" Field */
	eDeftFfeeAeb4AreaCritCfgPwrConfig3TimeVan3OffId        = 8025  /* F-FEE AEB 4 Critical Configuration Area Register "PWR_CONFIG3", "TIME_VAN3_OFF" Field */
} EDeftFfeeAeb4CritCfgRmapAreaID;

/* F-FEE AEB 4 General Configuration RMAP Area */
enum DeftFfeeAeb4GenCfgRmapAreaID {
	eDeftFfeeAeb4AreaGenCfgAdc1Config1OthersId          = 8200, /* F-FEE AEB 4 General Configuration Area Register "ADC1_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
	eDeftFfeeAeb4AreaGenCfgAdc1Config2OthersId          = 8201, /* F-FEE AEB 4 General Configuration Area Register "ADC1_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
	eDeftFfeeAeb4AreaGenCfgAdc1Config3OthersId          = 8202, /* F-FEE AEB 4 General Configuration Area Register "ADC1_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
	eDeftFfeeAeb4AreaGenCfgAdc2Config1OthersId          = 8203, /* F-FEE AEB 4 General Configuration Area Register "ADC2_CONFIG_1", RESERVED_0, "SPIRST", "MUXMOD", "BYPAS", "CLKENB", "CHOP", "STAT", "RESERVED_1", "IDLMOD", "DLY", "SBCS", "DRATE", "AINP", "AINN", "DIFF" Fields */
	eDeftFfeeAeb4AreaGenCfgAdc2Config2OthersId          = 8204, /* F-FEE AEB 4 General Configuration Area Register "ADC2_CONFIG_2", AIN7, "AIN6", "AIN5", "AIN4", "AIN3", "AIN2", "AIN1", "AIN0", "AIN15", "AIN14", "AIN13", "AIN12", "AIN11", "AIN10", "AIN9", "AIN8", "RESERVED_0", "REF", "GAIN", "TEMP", "VCC", "RESERVED_1", "OFFSET", "CIO7", "CIO6", "CIO5", "CIO4", "CIO3", "CIO2", "CIO1", "CIO0" Fields */
	eDeftFfeeAeb4AreaGenCfgAdc2Config3OthersId          = 8205, /* F-FEE AEB 4 General Configuration Area Register "ADC2_CONFIG_3", DIO7, "DIO6", "DIO5", "DIO4", "DIO3", "DIO2", "DIO1", "DIO0", "RESERVED" Fields */
	eDeftFfeeAeb4AreaGenCfgReserved118ReservedId        = 8206, /* F-FEE AEB 4 General Configuration Area Register "RESERVED_118", "RESERVED" Field */
	eDeftFfeeAeb4AreaGenCfgReserved11CReservedId        = 8207, /* F-FEE AEB 4 General Configuration Area Register "RESERVED_11C", "RESERVED" Field */
	eDeftFfeeAeb4AreaGenCfgSeqConfig1OthersId           = 8208, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_1", "RESERVED", "SEQ_OE_CCD_ENABLE", "SEQ_OE_SPARE", "SEQ_OE_TSTLINE", "SEQ_OE_TSTFRM", "SEQ_OE_VASPCLAMP", "SEQ_OE_PRECLAMP", "SEQ_OE_IG", "SEQ_OE_TG", "SEQ_OE_DG", "SEQ_OE_RPHIR", "SEQ_OE_SW", "SEQ_OE_RPHI3", "SEQ_OE_RPHI2", "SEQ_OE_RPHI1", "SEQ_OE_SPHI4", "SEQ_OE_SPHI3", "SEQ_OE_SPHI2", "SEQ_OE_SPHI1", "SEQ_OE_IPHI4", "SEQ_OE_IPHI3", "SEQ_OE_IPHI2", "SEQ_OE_IPHI1", "ADC_CLK_DIV" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig2OthersId           = 8209, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_2", ADC_CLK_LOW_POS, "ADC_CLK_HIGH_POS", "CDS_CLK_LOW_POS", "CDS_CLK_HIGH_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig3OthersId           = 8210, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_3", RPHIR_CLK_LOW_POS, "RPHIR_CLK_HIGH_POS", "RPHI1_CLK_LOW_POS", "RPHI1_CLK_HIGH_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig4OthersId           = 8211, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_4", RPHI2_CLK_LOW_POS, "RPHI2_CLK_HIGH_POS", "RPHI3_CLK_LOW_POS", "RPHI3_CLK_HIGH_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig5OthersId           = 8212, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_5", SW_CLK_LOW_POS, "SW_CLK_HIGH_POS", "RESERVED" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig6OthersId           = 8213, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_6", "RESERVED_0", "SPHI1_HIGH_POS",  "RESERVED_1", "SPHI1_LOW_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig14OthersId          = 8239, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_14", "RESERVED_0", "DG_HIGH_POS",  "RESERVED_1", "DG_LOW_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig7OthersId           = 8240, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_7", "RESERVED_0", "SPHI2_HIGH_POS",  "RESERVED_1", "SPHI2_LOW_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig8OthersId           = 8241, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_8", "RESERVED_0", "SPHI3_HIGH_POS",  "RESERVED_1", "SPHI3_LOW_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig9OthersId           = 8242, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_9", "RESERVED_0", "SPHI4_HIGH_POS",  "RESERVED_1", "SPHI4_LOW_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig10OthersId          = 8243, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_10", "RESERVED_0", "IPHI1_HIGH_POS",  "RESERVED_1", "IPHI1_LOW_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig11OthersId          = 8244, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_11", "RESERVED_0", "IPHI2_HIGH_POS",  "RESERVED_1", "IPHI2_LOW_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig12OthersId          = 8245, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_12", "RESERVED_0", "IPHI3_HIGH_POS",  "RESERVED_1", "IPHI3_LOW_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig13OthersId          = 8246, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_13", "RESERVED_0", "IPHI4_HIGH_POS",  "RESERVED_1", "IPHI4_LOW_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig15OthersId          = 8247, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_15", "RESERVED_0", "TG_HIGH_POS",  "RESERVED_1", "TG_LOW_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig16OthersId          = 8248, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_16", "RESERVED_0", "IG_HIGH_POS",  "RESERVED_1", "IG_LOW_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig17OthersId          = 8249, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_17", "RESERVED_0", "PRECLAMP_HIGH_POS",  "RESERVED_1", "PRECLAMP_LOW_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig18OthersId          = 8250, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_18", "RESERVED_0", "VASPCLAMP_HIGH_POS",  "RESERVED_1", "VASPCLAMP_LOW_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig19OthersId          = 8251, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_19", "VASP_OUT_CTRL_INV", "RESERVED_0", "VASP_OUT_DIS_POS",  "VASP_OUT_CTRL", "RESERVED_1", "VASP_OUT_EN_POS" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig20OthersId          = 8252, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_20", "RESERVED_0", "FT&LT_LENGTH",  "RESERVED_1" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig21OthersId          = 8253, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_21", "RESERVED" Field */
	eDeftFfeeAeb4AreaGenCfgSeqConfig22OthersId          = 8254, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_22", "RESERVED" Field */
	eDeftFfeeAeb4AreaGenCfgSeqConfig23OthersId          = 8255, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_23", "RESERVED" Field */
	eDeftFfeeAeb4AreaGenCfgSeqConfig24OthersId          = 8256, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_24", "RESERVED_0", "FT_LOOP_CNT", "LT0_ENABLED", "RESERVED_1", "LT0_LOOP_CNT" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig25OthersId          = 8257, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_25", "LT1_ENABLED", "RESERVED_0", "LT1_LOOP_CNT", "LT2_ENABLED", "RESERVED_1", "LT2_LOOP_CNT" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig26OthersId          = 8258, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_26", "LT3_ENABLED", "RESERVED_0", "LT3_LOOP_CNT",  "RESERVED_1" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig27OthersId          = 8259, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_27", "RESERVED_0", "PIX_LOOP_CNT", "PC_ENABLED", "RESERVED_1", "PC_LOOP_CNT" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig28OthersId          = 8260, /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_28", "RESERVED_0", "INT1_LOOP_CNT",  "RESERVED_1", "INT2_LOOP_CNT" Fields */
	eDeftFfeeAeb4AreaGenCfgSeqConfig29OthersId          = 8261  /* F-FEE AEB 4 General Configuration Area Register "SEQ_CONFIG_29", "RESERVED" Field */
} EDeftFfeeAeb4GenCfgRmapAreaID;

/* F-FEE AEB 4 Housekeeping Configuration RMAP Area */
enum DeftFfeeAeb4HkRmapAreaID {
	eDeftFfeeAeb4AreaHkAebStatusAebStatusId         = 8400, /* F-FEE AEB 4 Housekeeping Area Register "AEB_STATUS", "AEB_STATUS" Field */
	eDeftFfeeAeb4AreaHkAebStatusOthers0Id           = 8401, /* F-FEE AEB 4 Housekeeping Area Register "AEB_STATUS", VASP2_CFG_RUN, "VASP1_CFG_RUN" Fields */
	eDeftFfeeAeb4AreaHkAebStatusOthers1Id           = 8402, /* F-FEE AEB 4 Housekeeping Area Register "AEB_STATUS", DAC_CFG_WR_RUN, "ADC_CFG_RD_RUN", "ADC_CFG_WR_RUN", "ADC_DAT_RD_RUN", "ADC_ERROR", "ADC2_LU", "ADC1_LU", "ADC_DAT_RD", "ADC_CFG_RD", "ADC_CFG_WR", "ADC2_BUSY", "ADC1_BUSY" Fields */
	eDeftFfeeAeb4AreaHkTimestamp1TimestampDword1Id  = 8403, /* F-FEE AEB 4 Housekeeping Area Register "TIMESTAMP_1", "TIMESTAMP_DWORD_1" Field */
	eDeftFfeeAeb4AreaHkTimestamp2TimestampDword0Id  = 8404, /* F-FEE AEB 4 Housekeeping Area Register "TIMESTAMP_2", "TIMESTAMP_DWORD_0" Field */
	eDeftFfeeAeb4AreaHkAdcRdDataTVaspLOthersId      = 8405, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_VASP_L", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_L" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataTVaspROthersId      = 8406, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_VASP_R", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_VASP_R" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataTBiasPOthersId      = 8407, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_BIAS_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_BIAS_P" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataTHkPOthersId        = 8408, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_HK_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_HK_P" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataTTou1POthersId      = 8409, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_TOU_1_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_1_P" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataTTou2POthersId      = 8410, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_TOU_2_P", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_TOU_2_P" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataHkVodeOthersId      = 8411, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_VODE", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODE" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataHkVodfOthersId      = 8412, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_VODF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VODF" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataHkVrdOthersId       = 8413, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_VRD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VRD" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataHkVogOthersId       = 8414, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_VOG", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_VOG" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataTCcdOthersId        = 8415, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_CCD", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_CCD" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataTRef1KMeaOthersId   = 8416, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_REF1K_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF1K_MEA" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataTRef649RMeaOthersId = 8417, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_T_REF649R_MEA", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_T_REF649R_MEA" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataHkAnaN5VOthersId    = 8418, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_N5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_N5V" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataSRefOthersId        = 8419, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_S_REF", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_S_REF" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataHkCcdP31VOthersId   = 8420, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_CCD_P31V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CCD_P31V" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataHkClkP15VOthersId   = 8421, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_CLK_P15V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_CLK_P15V" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataHkAnaP5VOthersId    = 8422, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P5V", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P5V" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataHkAnaP3V3OthersId   = 8423, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_ANA_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_ANA_P3V3" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataHkDigP3V3OthersId   = 8424, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_HK_DIG_P3V3", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_HK_DIG_P3V3" Fields */
	eDeftFfeeAeb4AreaHkAdcRdDataAdcRefBuf2OthersId  = 8425, /* F-FEE AEB 4 Housekeeping Area Register "ADC_RD_DATA_ADC_REF_BUF_2", NEW, "OVF", "SUPPLY", "CHID", "ADC_CHX_DATA_ADC_REF_BUF_2" Fields */
	eDeftFfeeAeb4AreaHkVaspRdConfigOthersId         = 8426, /* F-FEE AEB 4 Housekeeping Area Register "VASP_RD_CONFIG", VASP1_READ_DATA, "VASP2_READ_DATA" Fields */
	eDeftFfeeAeb4AreaHkRevisionId1OthersId          = 8427, /* F-FEE AEB 4 Housekeeping Area Register "REVISION_ID_1", FPGA_VERSION, "FPGA_DATE" Fields */
	eDeftFfeeAeb4AreaHkRevisionId2OthersId          = 8428, /* F-FEE AEB 4 Housekeeping Area Register "REVISION_ID_2", FPGA_TIME_H, "FPGA_TIME_M", "FPGA_SVN" Fields */
	eDeftFfeeAeb4AreaHkAebStatusucOthers2Id         = 8429, /* F-FEE AEB 4 Housekeeping Area Register "AEB_STATUS", "VASP2_DELAYED", "VASP1_DELAYED", "VASP2_ERROR", "VASP1_ERROR" Fields */
	eDeftFfeeAeb4AreaHkAdc1RdConfig3ucOthers1Id     = 8430, /* F-FEE AEB 4 Housekeeping Area Register "ADC1_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
	eDeftFfeeAeb4AreaHkAdc2RdConfig3ucOthers1Id     = 8431  /* F-FEE AEB 4 Housekeeping Area Register "ADC2_RD_CONFIG_3", "ID7", "ID6", "ID5", "ID4", "ID3", "ID2", "ID1", "ID0" Fields */
} EDeftFfeeAeb4HkRmapAreaID;

/* Ethernet Interface Parameters */
enum DeftEthInterfaceParamsID {
	eDeftEthTcpServerPortId   = 10000, /* PUS TCP Server Port */
	eDeftEthDhcpV4EnableId    = 10001, /* PUS TCP Enable DHCP (dynamic) IP (all IPv4 fields below will be ignored if this is true) */
	eDeftEthIpV4AddressId     = 10002, /* PUS TCP address IPv4 uint32 representation (Example is 192.168.17.10) */
	eDeftEthIpV4SubnetId      = 10003, /* PUS TCP subnet IPv4 uint32 representation (Example is 255.255.255.0) */
	eDeftEthIpV4GatewayId     = 10004, /* PUS TCP gateway IPv4 uint32 representation (Example is 192.168.17.1) */
	eDeftEthIpV4DNSId         = 10005, /* PUS TCP DNS IPv4 uint32 representation (Example is 1.1.1.1) */
	eDeftEthPusHpPidId        = 10006, /* PUS HP_PID identification (>127 to disable verification) */
	eDeftEthPusHpPcatId       = 10007, /* PUS HP_PCAT identification (>15 to disable verification) */
	eDeftEthPusEncapId        = 10008, /* PUS Default Encapsulation Protocol (0 = None, 1 = EDEN) */
	eDeftEthPusHpSourceIdId   = 10009, /* PUS HP_SOURCE_ID parameter */
	eDeftEthPusHpImgGenPidId  = 10010, /* PUS HP_PID parameter for ImageGenerator communication */
	eDeftEthPusHpImgGenPcatId = 10011, /* PUS HP_PCAT parameter for ImageGenerator communication */
} EDeftEthInterfaceParamsID;

/* FEE Default/Config Operation Type */
enum DeftFeeOperationTypeID {
	eDeftFeeDefaultOpTypeId = 0, /* Default operation type */
	eDeftFeeConfigOpTypeId  = 1  /* Config operation type */
} EDeftFeeOperationTypeID;
//! [constants definition]

//! [public module structs definition]

/* MEB defaults */
typedef struct DeftMebDefaults {
	TGenSimulationParams xGenSimulationParams; /* General Simulation Parameters */
} TDeftMebDefaults;

/* FEE defaults */
typedef struct DeftFeeDefaults {
	TRmapDebAreaCritCfg xRmapDebAreaCritCfg; /* F-FEE DEB Critical Configuration RMAP Area */
	TRmapDebAreaGenCfg xRmapDebAreaGenCfg; /* F-FEE DEB General Configuration RMAP Area */
	TRmapDebAreaHk xRmapDebAreaHk; /* F-FEE DEB Housekeeping Configuration RMAP Area */
	TRmapAebAreaCritCfg xRmapAebAreaCritCfg[N_OF_CCD]; /* F-FEE AEB 1-4 Critical Configuration RMAP Area */
	TRmapAebAreaGenCfg xRmapAebAreaGenCfg[N_OF_CCD]; /* F-FEE AEB 1-4 General Configuration RMAP Area */
	TRmapAebAreaHk xRmapAebAreaHk[N_OF_CCD]; /* F-FEE AEB 1-4 Housekeeping Configuration RMAP Area */
	TSpwInterfaceParams xSpwInterfaceParams; /* SpaceWire Interface Parameters */
} TDeftFeeDefaults;

/* NUC defaults */
typedef struct DeftNucDefaults {
	TEthInterfaceParams xEthInterfaceParams; /* Ethernet Interface Parameters */
} TDeftNucDefaults;
//! [public module structs definition]

//! [public function prototypes]
void vDeftInitMebDefault();
bool bDeftInitFeeDefault(alt_u8 ucFee);
void vDeftInitNucDefault();

bool bDeftSetMebDefaultValues(alt_u16 usiDefaultId, alt_u32 uliDefaultValue);
bool bDeftSetFeeDefaultValues(alt_u8 ucFee, alt_u16 usiDefaultId, alt_u32 uliDefaultValue);
bool bDeftSetNucDefaultValues(alt_u16 usiDefaultId, alt_u32 uliDefaultValue);

bool bDeftSetDefaultValues(alt_u16 usiMebFee, alt_u16 usiDefaultId, alt_u32 uliDefaultValue);

bool bDeftGetMebDefaultValues(alt_u16 usiDefaultId, alt_u32 *puliDefaultValue, alt_u8 ucOpType);
bool bDeftGetFeeDefaultValues(alt_u8 ucFee, alt_u16 usiDefaultId, alt_u32 *puliDefaultValue, alt_u8 ucOpType, TFFee_Control *pxFFeeCtrl);
bool bDeftGetNucDefaultValues(alt_u16 usiDefaultId, alt_u32 *puliDefaultValue, alt_u8 ucOpType);

bool bDeftGetDefaultValues(alt_u16 usiMebFee, alt_u16 usiDefaultId, alt_u32 *puliDefaultValue);
bool bDeftGetConfigValues(alt_u16 usiMebFee, alt_u16 usiDefaultId, alt_u32 *puliDefaultValue, TFFee_Control *pxFFeeCtrl);
//! [public function prototypes]

//! [data memory public global variables - use extern]
extern volatile bool vbDeftDefaultsReceived;
extern volatile alt_u32 vuliDeftExpectedDefaultsQtd;
extern volatile alt_u32 vuliDeftReceivedDefaultsQtd;
extern volatile TDeftMebDefaults vxDeftMebDefaults;
extern volatile TDeftFeeDefaults vxDeftFeeDefaults[N_OF_FastFEE];
extern volatile TDeftNucDefaults vxDeftNucDefaults;
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* UTILS_DEFAULTS_H_ */
