/*
 * data_packet.c
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#include "data_packet.h"

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
bool bDpktSetPacketConfig(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktDataPacketConfig = pxDpktCh->xDpktDataPacketConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktGetPacketConfig(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktDataPacketConfig = vpxCommChannel->xDataPacket.xDpktDataPacketConfig;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetDebPktCfg(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktDebDataPktCfg = pxDpktCh->xDpktDebDataPktCfg;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktGetDebPktCfg(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktDebDataPktCfg = vpxCommChannel->xDataPacket.xDpktDebDataPktCfg;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktUpdateDebPktCfg(TDpktChannel *pxDpktCh){
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

//		if (xDefaults.usiRows >= vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat) {
//			vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebDataYSize = vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat;
//		} else {
//			vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebDataYSize = xDefaults.usiRows;
//		}
//
//		if (xDefaults.usiOLN >= vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat) {
//			vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebOverscanYSize = vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat;
//		} else {
//			vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebOverscanYSize = xDefaults.usiOLN;
//		}
//
//		vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebCcdYSize = vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebDataYSize + vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebOverscanYSize;
//
//		if (xDefaults.usiCols >= vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat) {
//			vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebCcdXSize = vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat;
//		} else {
//			vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebCcdXSize = xDefaults.usiCols;
//		}

		vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebDataYSize = xDefaults.usiRows;
		vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebOverscanYSize = xDefaults.usiOLN;
		vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebCcdYSize = vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebDataYSize + vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebOverscanYSize;
		vpxCommChannel->xDataPacket.xDpktDebDataPktCfg.usiDebCcdXSize = xDefaults.usiCols;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetAebPktCfg(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktAebDataPktCfg = pxDpktCh->xDpktAebDataPktCfg;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktGetAebPktCfg(TDpktChannel *pxDpktCh){
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktAebDataPktCfg = vpxCommChannel->xDataPacket.xDpktAebDataPktCfg;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktUpdateAebPktCfg(TDpktChannel *pxDpktCh, alt_u8 ucAebId) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if ((pxDpktCh != NULL) && (COMM_FFEE_AEB_QUANTITY > ucAebId)) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

//		vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.ucAebCcdId = vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebId]->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid;
//
//		if (xDefaults.usiRows >= vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebId]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows) {
//			vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.usiAebDataYSize = vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebId]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows;
//		} else {
//			vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.usiAebDataYSize = xDefaults.usiRows;
//		}
//
//		vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.usiAebOverscanYSize = xDefaults.usiOLN;
//
//		vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.usiAebCcdYSize = vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.usiAebDataYSize + vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.usiAebOverscanYSize;
//
//		if (xDefaults.usiCols >= vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebId]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols) {
//			vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.usiAebCcdXSize = vpxCommChannel->xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucAebId]->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols;
//		} else {
//			vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.usiAebCcdXSize = xDefaults.usiCols;
//		}

		vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.ucAebCcdId = ucAebId;
		vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.usiAebDataYSize = xDefaults.usiRows;
		vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.usiAebOverscanYSize = xDefaults.usiOLN;
		vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.usiAebCcdYSize = vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.usiAebDataYSize + vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.usiAebOverscanYSize;
		vpxCommChannel->xDataPacket.xDpktAebDataPktCfg.usiAebCcdXSize = xDefaults.usiCols;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetPacketErrors(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktDataPacketErrors = pxDpktCh->xDpktDataPacketErrors;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktGetPacketErrors(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktDataPacketErrors = vpxCommChannel->xDataPacket.xDpktDataPacketErrors;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktGetPacketHeader(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktDataPacketHeader = vpxCommChannel->xDataPacket.xDpktDataPacketHeader;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetPixelDelay(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktPixelDelay = pxDpktCh->xDpktPixelDelay;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetPixelDelay(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktPixelDelay = vpxCommChannel->xDataPacket.xDpktPixelDelay;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetPresetFrmCnt(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktPresetFrmCnt = pxDpktCh->xDpktPresetFrmCnt;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetPresetFrmCnt(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktPresetFrmCnt = vpxCommChannel->xDataPacket.xDpktPresetFrmCnt;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetFrameCounterValue(TDpktChannel *pxDpktCh, alt_u16 usiFrmCntVal) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktPresetFrmCnt.usiFrmCntValue = usiFrmCntVal;
		vpxCommChannel->xDataPacket.xDpktPresetFrmCnt.bFrmCntSet = TRUE;

		pxDpktCh->xDpktPresetFrmCnt.usiFrmCntValue = usiFrmCntVal;
		pxDpktCh->xDpktPresetFrmCnt.bFrmCntSet = FALSE;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktSetErrorInjection(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktErrorInjection = pxDpktCh->xDpktErrorInjection;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetErrorInjection(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktErrorInjection = vpxCommChannel->xDataPacket.xDpktErrorInjection;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktSetWindowingParams(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		vpxCommChannel->xDataPacket.xDpktWindowingParam = pxDpktCh->xDpktWindowingParam;

		bStatus = TRUE;
	}

	return bStatus;
}

bool bDpktGetWindowingParams(TDpktChannel *pxDpktCh) {
	bool bStatus = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		vpxCommChannel = (TCommChannel *) (pxDpktCh->xDpktDevAddr.uliDpktBaseAddr);

		pxDpktCh->xDpktWindowingParam = vpxCommChannel->xDataPacket.xDpktWindowingParam;

		bStatus = TRUE;

	}

	return bStatus;
}

bool bDpktInitCh(TDpktChannel *pxDpktCh, alt_u8 ucCommCh) {
	bool bStatus = FALSE;
	bool bValidCh = FALSE;
	bool bInitFail = FALSE;
	volatile TCommChannel *vpxCommChannel;

	if (pxDpktCh != NULL) {

		switch (ucCommCh) {
		case eCommSpwCh1:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_1_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh2:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_2_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh3:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_3_BASE_ADDR);
			bValidCh = TRUE;
			break;
		case eCommSpwCh4:
			pxDpktCh->xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel = (TCommChannel *) (COMM_CH_4_BASE_ADDR);
			vpxCommChannel->xDataPacket.xDpktDevAddr.uliDpktBaseAddr = (alt_u32) (COMM_CH_4_BASE_ADDR);
			bValidCh = TRUE;
			break;
		default:
			bValidCh = FALSE;
			break;
		}

		if (bValidCh) {
			if (!bDpktGetPacketConfig(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetDebPktCfg(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetAebPktCfg(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetPacketErrors(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetPacketHeader(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetPixelDelay(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetPresetFrmCnt(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetErrorInjection(pxDpktCh)) {
				bInitFail = TRUE;
			}
			if (!bDpktGetWindowingParams(pxDpktCh)) {
				bInitFail = TRUE;
			}

			if (!bInitFail) {
				bStatus = TRUE;
			}
		}
	}
	return bStatus;
}

/*
 * Return the necessary delay value for a
 * Pixel Delay period in uliPeriodNs ns.
 */
alt_u32 uliPxDelayCalcPeriodNs(alt_u32 uliPeriodNs) {

	/*
	 * Delay = PxDelay * ClkCycles@100MHz
	 * PxDelay = Delay / ClkCycles@100MHz
	 *
	 * ClkCycles@100MHz = 10 ns
	 *
	 * Delay[ns] / 10 = Delay[ns] * 1e-1
	 * PxDelay = Delay[ns] * 1e-1
	 */

	alt_u32 uliPxDelay;
	//    uliPxDelay = (alt_u32) ((float) uliPeriodNs * 1e-1);
	uliPxDelay = (alt_u32) (uliPeriodNs / (alt_u32) 10);

	return uliPxDelay;
}

alt_u32 uliPxDelayCalcPeriodMs(alt_u32 uliPeriodMs) {

	/*
	 * Delay = PxDelay * ClkCycles@100MHz
	 * PxDelay = Delay / ClkCycles@100MHz
	 *
	 * ClkCycles@100MHz = 10 ns = 1e-5 ms
	 *
	 * Delay[ms] / 1e-5 = Delay[ms] * 1e+5
	 * PxDelay = Delay[ms] * 1e+5
	 */

	alt_u32 uliPxDelay;
	//    uliPxDelay = (alt_u32) ((float) uliPeriodMs * 1e+5);
	uliPxDelay = (alt_u32) (uliPeriodMs * (alt_u32) 100000);

	return uliPxDelay;
}

//! [public functions]

//! [private functions]
//! [private functions]
