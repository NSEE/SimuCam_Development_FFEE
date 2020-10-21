/*
 * initialization_simucam.c
 *
 *  Created on: 20/10/2018
 *      Author: TiagoLow
 */

#include "initialization_simucam.h"
#include "../driver/comm/rmap/rmap_mem_area.h"

void vDumpDebAddr( void );
void vDumpAebAddr( void );

bool bInitSimucamCoreHW(void) {
	bool bSuccess = FALSE;

	/* Release SimuCam Reset Signal */
	vRstcReleaseSimucamReset(0);

	/* Check System ID and Timestamp */
	TSidpRegisters *pxSidpRegisters = (TSidpRegisters *) (SYSID_QSYS_BASE);

	if (( SYSID_QSYS_ID == pxSidpRegisters->uliId) && ( SYSID_QSYS_TIMESTAMP == pxSidpRegisters->uliTimestamp)) {
		bSuccess = TRUE;
	}

	// vDumpDebAddr();

	// vDumpAebAddr();

	return (bSuccess);
}

void vInitSimucamBasicHW(void) {

	/* Turn Off all LEDs */
	bSetBoardLeds(LEDS_OFF, LEDS_BOARD_ALL_MASK);
	bSetPainelLeds(LEDS_OFF, LEDS_PAINEL_ALL_MASK);

	/* Turn On Power LED */
	bSetPainelLeds(LEDS_ON, LEDS_POWER_MASK);

	/* Configure Seven Segments Display */
//	bSSDisplayConfig(SSDP_NORMAL_MODE);
//	bSSDisplayUpdate(0);

	/* Reset the RS232 Device */
	vRstcHoldDeviceReset(RSTC_DEV_RS232_RST_CTRL_MSK);
	vRstcReleaseDeviceReset(RSTC_DEV_RS232_RST_CTRL_MSK);

	/* Disable the Isolation and LVDS driver boards*/
	bDisableIsoDrivers();
	bDisableLvdsBoard();
	
	/* Set LVDS pre-emphasys to off */
	bSetPreEmphasys(LVDS_PEM_OFF);

	/* Turn on all Panel Leds */
	bSetPainelLeds( LEDS_ON, LEDS_PAINEL_ALL_MASK);
	usleep(5000000);
	/* Initial values for the Leds */
	bSetPainelLeds( LEDS_OFF, LEDS_PAINEL_ALL_MASK);
	bSetPainelLeds( LEDS_ON, LEDS_POWER_MASK);

}

void vDumpDebAddr( void ){
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

void vDumpAebAddr( void ){
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
