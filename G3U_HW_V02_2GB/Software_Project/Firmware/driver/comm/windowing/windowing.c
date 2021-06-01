/*
 * windowing.c
 *
 *  Created on: 17 de jan de 2020
 *      Author: rfranca
 */

#include "windowing.h"

//! [private function prototypes]
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]
bool bWindCopyMebWindowingParam(alt_u32 uliMebWindowingParamAddr, alt_u8 ucMemoryId, alt_u8 ucFFeeId, alt_u8 ucAebId){
	bool bStatus = FALSE;
	bool bValidMem = FALSE;
	bool bValidCh = FALSE;
	volatile TCommChannel *vpxCommChannel = NULL;
	volatile TRmapMemDebArea *vpxRmapMemDebArea = NULL;
	volatile TWindMebWindowingParam *vpxMebWindowingParam = NULL;

	bValidMem = bDdr2SwitchMemory(ucMemoryId);

	switch (ucFFeeId) {
	case eCommFFee1Id:
		switch (ucAebId) {
		case eCommFFeeAeb1Id:
			vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
			vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxMebWindowingParam = (TWindMebWindowingParam *) uliMebWindowingParamAddr;
			bValidCh = TRUE;
			break;
		case eCommFFeeAeb2Id:
			vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
			vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxMebWindowingParam = (TWindMebWindowingParam *) uliMebWindowingParamAddr;
			bValidCh = TRUE;
			break;
		case eCommFFeeAeb3Id:
			vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
			vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxMebWindowingParam = (TWindMebWindowingParam *) uliMebWindowingParamAddr;
			bValidCh = TRUE;
			break;
		case eCommFFeeAeb4Id:
			vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
			vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxMebWindowingParam = (TWindMebWindowingParam *) uliMebWindowingParamAddr;
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}
		break;
	case eCommFFee2Id:
		switch (ucAebId) {
		case eCommFFeeAeb1Id:
			vpxCommChannel = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
			vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxMebWindowingParam = (TWindMebWindowingParam *) uliMebWindowingParamAddr;
			bValidCh = TRUE;
			break;
		case eCommFFeeAeb2Id:
			vpxCommChannel = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
			vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxMebWindowingParam = (TWindMebWindowingParam *) uliMebWindowingParamAddr;
			bValidCh = TRUE;
			break;
		case eCommFFeeAeb3Id:
			vpxCommChannel = (TCommChannel *) (COMM_CH_7_BASE_ADDR);
			vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxMebWindowingParam = (TWindMebWindowingParam *) uliMebWindowingParamAddr;
			bValidCh = TRUE;
			break;
		case eCommFFeeAeb4Id:
			vpxCommChannel = (TCommChannel *) (COMM_CH_8_BASE_ADDR);
			vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
			vpxMebWindowingParam = (TWindMebWindowingParam *) uliMebWindowingParamAddr;
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if ((bValidMem) && (bValidCh) && (uliMebWindowingParamAddr < DDR2_M1_MEMORY_SIZE)) {

		vpxCommChannel->xDataPacket.xDpktWindowingParam = vpxMebWindowingParam->xDpktWindowingParam;

		if (COMM_WIN_LIST_FFEE_ENT_MAX < (vpxMebWindowingParam->xWindWindowsLength.uliCcd1SideEWinLen +
				vpxMebWindowingParam->xWindWindowsLength.uliCcd1SideFWinLen +
				vpxMebWindowingParam->xWindWindowsLength.uliCcd2SideEWinLen +
				vpxMebWindowingParam->xWindWindowsLength.uliCcd2SideFWinLen +
				vpxMebWindowingParam->xWindWindowsLength.uliCcd3SideEWinLen +
				vpxMebWindowingParam->xWindWindowsLength.uliCcd3SideFWinLen +
				vpxMebWindowingParam->xWindWindowsLength.uliCcd4SideEWinLen +
				vpxMebWindowingParam->xWindWindowsLength.uliCcd4SideFWinLen))
		{
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf = 1;
		} else {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf = 0;
		}

		if (COMM_WIN_LIST_FFEE_CCD_MAX < vpxMebWindowingParam->xWindWindowsLength.uliCcd1SideEWinLen) {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList1 = TRUE;
		} else {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList1 = FALSE;
		}

		if (COMM_WIN_LIST_FFEE_CCD_MAX < vpxMebWindowingParam->xWindWindowsLength.uliCcd1SideFWinLen) {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList2 = TRUE;
		} else {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList2 = FALSE;
		}

		if (COMM_WIN_LIST_FFEE_CCD_MAX < vpxMebWindowingParam->xWindWindowsLength.uliCcd2SideEWinLen) {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList3 = TRUE;
		} else {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList3 = FALSE;
		}

		if (COMM_WIN_LIST_FFEE_CCD_MAX < vpxMebWindowingParam->xWindWindowsLength.uliCcd2SideFWinLen) {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList4 = TRUE;
		} else {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList4 = FALSE;
		}

		if (COMM_WIN_LIST_FFEE_CCD_MAX < vpxMebWindowingParam->xWindWindowsLength.uliCcd3SideEWinLen) {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList5 = TRUE;
		} else {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList5 = FALSE;
		}

		if (COMM_WIN_LIST_FFEE_CCD_MAX < vpxMebWindowingParam->xWindWindowsLength.uliCcd3SideFWinLen) {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList6 = TRUE;
		} else {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList6 = FALSE;
		}

		if (COMM_WIN_LIST_FFEE_CCD_MAX < vpxMebWindowingParam->xWindWindowsLength.uliCcd4SideEWinLen) {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList7 = TRUE;
		} else {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList7 = FALSE;
		}

		if (COMM_WIN_LIST_FFEE_CCD_MAX < vpxMebWindowingParam->xWindWindowsLength.uliCcd4SideFWinLen) {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList8 = TRUE;
		} else {
			vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList8 = FALSE;
		}

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bWindCopyCcdXWindowingConfig(alt_u8 ucFFeeId) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	volatile TRmapMemDebArea *vpxRmapMemDebArea = NULL;
	volatile TFtdiModule *vpxFtdiModule = NULL;

	switch (ucFFeeId) {
	case eCommFFee1Id:
		vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
		vpxFtdiModule = (TFtdiModule *) (FTDI_MODULE_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommFFee2Id:
		vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
		vpxFtdiModule = (TFtdiModule *) (FTDI_MODULE_BASE_ADDR);
		bValidCh = TRUE;
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	if (bValidCh) {

		vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowListPrt = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1 * COMM_WINDOING_RMAP_WORD_SIZE);
		vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1PacketOrderListPrt = (alt_u32) (COMM_WINDOING_RMAP_AREA_SIZE / 2); /* Dummy address because FFEE does not have an order packet list */
		vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowListLength = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1);
		vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowsSizeX = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX);
		vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowsSizeY = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY);
		vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1LastEPacket = (alt_u32) (0xFFFFFFFF);
		vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1LastFPacket = (alt_u32) (0xFFFFFFFF);
		if (COMM_WINDOING_RMAP_AREA_SIZE < vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowListPrt) {
			vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowListPrt = (alt_u32) (COMM_WINDOING_RMAP_AREA_SIZE / 2);
		}
		if (COMM_WIN_LIST_FFEE_CCD_MAX < vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowListLength) {
			vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowListLength = (alt_u32) (COMM_WIN_LIST_FFEE_CCD_MAX);
		}

		vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2WindowListPrt = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2 * COMM_WINDOING_RMAP_WORD_SIZE);
		vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2PacketOrderListPrt = (alt_u32) (COMM_WINDOING_RMAP_AREA_SIZE / 2); /* Dummy address because FFEE does not have an order packet list */
		vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2WindowListLength = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2);
		vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2WindowsSizeX = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX);
		vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2WindowsSizeY = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY);
		vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2LastEPacket = (alt_u32) (0xFFFFFFFF);
		vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2LastFPacket = (alt_u32) (0xFFFFFFFF);
		if (COMM_WINDOING_RMAP_AREA_SIZE < vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowListPrt) {
			vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2WindowListPrt = (alt_u32) (COMM_WINDOING_RMAP_AREA_SIZE / 2);
		}
		if (COMM_WIN_LIST_FFEE_CCD_MAX < vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2WindowListLength) {
			vpxFtdiModule->xFtdiLutCcd2WindCfg.uliCcd2WindowListLength = (alt_u32) (COMM_WIN_LIST_FFEE_CCD_MAX);
		}

		vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3WindowListPrt = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3 * COMM_WINDOING_RMAP_WORD_SIZE);
		vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3PacketOrderListPrt = (alt_u32) (COMM_WINDOING_RMAP_AREA_SIZE / 2); /* Dummy address because FFEE does not have an order packet list */
		vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3WindowListLength = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3);
		vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3WindowsSizeX = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX);
		vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3WindowsSizeY = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY);
		vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3LastEPacket = (alt_u32) (0xFFFFFFFF);
		vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3LastFPacket = (alt_u32) (0xFFFFFFFF);
		if (COMM_WINDOING_RMAP_AREA_SIZE < vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowListPrt) {
			vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3WindowListPrt = (alt_u32) (COMM_WINDOING_RMAP_AREA_SIZE / 2);
		}
		if (COMM_WIN_LIST_FFEE_CCD_MAX < vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3WindowListLength) {
			vpxFtdiModule->xFtdiLutCcd3WindCfg.uliCcd3WindowListLength = (alt_u32) (COMM_WIN_LIST_FFEE_CCD_MAX);
		}

		vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4WindowListPrt = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4 * COMM_WINDOING_RMAP_WORD_SIZE);
		vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4PacketOrderListPrt = (alt_u32) (COMM_WINDOING_RMAP_AREA_SIZE / 2); /* Dummy address because FFEE does not have an order packet list */
		vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4WindowListLength = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4);
		vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4WindowsSizeX = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX);
		vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4WindowsSizeY = (alt_u32) (vpxRmapMemDebArea->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY);
		vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4LastEPacket = (alt_u32) (0xFFFFFFFF);
		vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4LastFPacket = (alt_u32) (0xFFFFFFFF);
		if (COMM_WINDOING_RMAP_AREA_SIZE < vpxFtdiModule->xFtdiLutCcd1WindCfg.uliCcd1WindowListPrt) {
			vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4WindowListPrt = (alt_u32) (COMM_WINDOING_RMAP_AREA_SIZE / 2);
		}
		if (COMM_WIN_LIST_FFEE_CCD_MAX < vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4WindowListLength) {
			vpxFtdiModule->xFtdiLutCcd4WindCfg.uliCcd4WindowListLength = (alt_u32) (COMM_WIN_LIST_FFEE_CCD_MAX);
		}

		bStatus = TRUE;

	}

	return (bStatus);
}

bool bWindClearWindowingArea(alt_u8 ucMemoryId, alt_u32 uliWindowingAreaAddr, alt_u32 uliWinAreaLengthBytes) {
	bool bStatus = FALSE;
	bool bValidMem = FALSE;
	alt_u32 *puliWindowingArea = NULL;
	alt_u32 uliWinLengthDwords = 0;
	alt_u32 uliAddrCnt = 0;

	bValidMem = bDdr2SwitchMemory(ucMemoryId);

	if ((bValidMem) && (uliWindowingAreaAddr < DDR2_M1_MEMORY_SIZE) && (uliWinAreaLengthBytes <= FTDI_WIN_AREA_PAYLOAD_SIZE)) {

		if (uliWinAreaLengthBytes % 4) {
			uliWinLengthDwords = (alt_u32) ((uliWinAreaLengthBytes / 4) + 1);
		} else {
			uliWinLengthDwords = (alt_u32) (uliWinAreaLengthBytes / 4);
		}

		puliWindowingArea = (alt_u32 *) uliWindowingAreaAddr;
		for (uliAddrCnt = 0; uliAddrCnt < uliWinLengthDwords; uliAddrCnt++) {
			*(puliWindowingArea + uliAddrCnt) = 0x00000000;
		}

		bStatus = TRUE;
	}

	return (bStatus);
}

bool bWindSetWindowingAreaOffset(alt_u8 ucFFeeId, alt_u8 ucMemoryId, alt_u32 uliWindowingAreaAddr) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bValidMem = FALSE;
	alt_u32 uliDdrMemOffset = 0;
	alt_u8 ucAebCnt = 0;
	volatile TCommChannel *vpxCommAebCh[COMM_FFEE_AEB_QUANTITY] = {NULL, NULL, NULL, NULL};

	switch (ucFFeeId) {
	case eCommFFee1Id:
		vpxCommAebCh[eCommFFeeAeb1Id] = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
		vpxCommAebCh[eCommFFeeAeb2Id] = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
		vpxCommAebCh[eCommFFeeAeb3Id] = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
		vpxCommAebCh[eCommFFeeAeb4Id] = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
		bValidCh = TRUE;
		break;
	case eCommFFee2Id:
		vpxCommAebCh[eCommFFeeAeb1Id] = (TCommChannel *) (COMM_CH_5_BASE_ADDR);
		vpxCommAebCh[eCommFFeeAeb2Id] = (TCommChannel *) (COMM_CH_6_BASE_ADDR);
		vpxCommAebCh[eCommFFeeAeb3Id] = (TCommChannel *) (COMM_CH_7_BASE_ADDR);
		vpxCommAebCh[eCommFFeeAeb4Id] = (TCommChannel *) (COMM_CH_8_BASE_ADDR);
		bValidCh = TRUE;
		break;
	default:
		bValidCh = FALSE;
		break;
	}

	switch (ucMemoryId) {
	case eDdr2Memory1:
		uliDdrMemOffset = DDR2_M1_MEMORY_BASE;
		bValidMem = TRUE;
		break;
	case eDdr2Memory2:
		uliDdrMemOffset = DDR2_M2_MEMORY_BASE;
		bValidMem = TRUE;
		break;
	default:
		bValidMem = FALSE;
		break;
	}

	if ((bValidCh) && (bValidMem) && (DDR2_M1_MEMORY_SIZE > uliWindowingAreaAddr)) {

		for (ucAebCnt = 0; ucAebCnt < COMM_FFEE_AEB_QUANTITY; ucAebCnt++) {
			vpxCommAebCh[ucAebCnt]->xRmap.xRmapMemConfig.uliWinAreaOffHighDword = 0x00000000;
			vpxCommAebCh[ucAebCnt]->xRmap.xRmapMemConfig.uliWinAreaOffLowDword = uliDdrMemOffset + uliWindowingAreaAddr;
		}
		bStatus = TRUE;

	}

	return (bStatus);
}
//! [public functions]

//! [private functions]
//! [private functions]
