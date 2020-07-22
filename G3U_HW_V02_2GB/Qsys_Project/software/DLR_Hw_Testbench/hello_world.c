/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <sys/alt_stdio.h>
#include "simucam_definitions.h"
#include "utils/initialization_simucam.h"
#include "utils/test_module_simucam.h"
#include <sys/ioctl.h>

#include "driver/sync/sync.h"
#include "driver/comm/comm_channel.h"
#include "driver/ctrl_io_lvds/ctrl_io_lvds.h"

#include <stdio.h>

#if DEBUG_ON
FILE* fp;
#endif

int main() {

	/* Debug device initialization - JTAG USB */
#if DEBUG_ON
	fp = fopen(JTAG_UART_0_NAME, "r+");
#endif

#if DEBUG_ON
	debug(fp, "Main entry point.\n");
#endif

	/* Initialization of core HW */
	if (bInitSimucamCoreHW()) {
#if DEBUG_ON
		fprintf(fp, "\n");
		fprintf(fp, "SimuCam Release: %s\n", SIMUCAM_RELEASE);
		fprintf(fp, "SimuCam HW Version: %s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION);
		fprintf(fp, "SimuCam FW Version: %s.%s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION, SIMUCAM_FW_VERSION);
		fprintf(fp, "\n");
#endif
	} else {
#if DEBUG_ON
		fprintf(fp, "\n");
		fprintf(fp, "CRITICAL HW FAILURE: Hardware TimeStamp or System ID does not match the expected! SimuCam will be halted.\n");
		fprintf(fp, "CRITICAL HW FAILURE: Expected HW release: %s.%s\n", SIMUCAM_RELEASE, SIMUCAM_HW_VERSION);
		fprintf(fp, "CRITICAL HW FAILURE: SimuCam will be halted.\n");
		fprintf(fp, "\n");
#endif
		while (1) {
		}
	}

	/* Test of some critical IPCores HW interfaces in the Simucam */
	bTestSimucamCriticalHW();

	/* Initialization of basic HW */
//	vInitSimucamBasicHW();

	/* Start Testbench */

	bEnableIsoDrivers();
	bEnableLvdsBoard();

	/* Channels Variables */
	volatile TCommChannel *vpxCommChannel[4] = { NULL, NULL, NULL, NULL };
	volatile TRmapMemDebArea *vpxRmapMemDebArea = NULL;
	volatile TRmapMemAebArea *vpxRmapMemAebArea[4] = { NULL, NULL, NULL, NULL };

	vpxCommChannel[0] = (TCommChannel *) (COMM_CH_1_BASE_ADDR);
	vpxCommChannel[1] = (TCommChannel *) (COMM_CH_2_BASE_ADDR);
	vpxCommChannel[2] = (TCommChannel *) (COMM_CH_3_BASE_ADDR);
	vpxCommChannel[3] = (TCommChannel *) (COMM_CH_4_BASE_ADDR);

	vpxRmapMemDebArea = (TRmapMemDebArea *) (COMM_RMAP_MEM_DEB_BASE_ADDR);
	vpxRmapMemAebArea[0] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_1_BASE_ADDR);
	vpxRmapMemAebArea[1] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_2_BASE_ADDR);
	vpxRmapMemAebArea[2] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_3_BASE_ADDR);
	vpxRmapMemAebArea[3] = (TRmapMemAebArea *) (COMM_RMAP_MEM_AEB_4_BASE_ADDR);

	volatile TSyncModule *vpxSyncModule = (TSyncModule *) SYNC_BASE_ADDR;

	/* Channels Config */

	alt_u8 ucChCnt = 0;
	for (ucChCnt = 0; ucChCnt < 2; ucChCnt++) {

		vRmapInitIrq(ucChCnt);
		vpxCommChannel[ucChCnt]->xCommIrqControl.bGlobalIrqEn = TRUE;
		vpxCommChannel[ucChCnt]->xRmap.xRmapIrqControl.bWriteConfigEn = TRUE;
		vpxCommChannel[ucChCnt]->xRmap.xRmapIrqControl.bWriteWindowEn = TRUE;

		vFeebInitIrq(ucChCnt);
		vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebIrqControl.bLeftBufferEmptyEn = TRUE;
		vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebIrqControl.bRightBufferEmptyEn = TRUE;

		vpxCommChannel[ucChCnt]->xRmap.xRmapCodecConfig.ucLogicalAddress = 0x51;
		vpxCommChannel[ucChCnt]->xRmap.xRmapCodecConfig.ucKey = 0xD1;
		vpxCommChannel[ucChCnt]->xRmap.xRmapCodecConfig.bEnable = TRUE;

		vpxCommChannel[ucChCnt]->xSpacewire.xSpwcLinkConfig.bDisconnect = FALSE;
		vpxCommChannel[ucChCnt]->xSpacewire.xSpwcLinkConfig.bAutostart = TRUE;
		vpxCommChannel[ucChCnt]->xSpacewire.xSpwcLinkConfig.bLinkStart = FALSE;

		vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebMachineControl.bStop = TRUE;
		vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebMachineControl.bClear = TRUE;
		vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebMachineControl.bStart = TRUE;

		vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebMachineControl.bBufferOverflowEn = FALSE;
		vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebMachineControl.bDigitaliseEn = TRUE;
		vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebMachineControl.bReadoutEn = TRUE;

		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.usiCcdXSize            = 2295;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.usiCcdYSize            = 2265;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.usiDataYSize           = 2255;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.usiOverscanYSize       = 10;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.usiCcdVStart           = 0;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.usiCcdVEnd             = 2264;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.usiPacketLength        = 4602;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucLogicalAddr          = 0x50;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucProtocolId           = 0xF0;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer    = eDpktOff;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer   = eDpktOff;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdNumberLeftBuffer  = 0;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdNumberRightBuffer = 0;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdSideLeftBuffer    = eDpktCcdSideE;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdSideRightBuffer   = eDpktCcdSideE;

		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDebDataPktCfg.usiDebCcdXSize      = 2295;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDebDataPktCfg.usiDebCcdYSize      = 2265;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDebDataPktCfg.usiDebDataYSize     = 2255;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDebDataPktCfg.usiDebOverscanYSize = 10;

		vpxCommChannel[ucChCnt]->xDataPacket.xDpktAebDataPktCfg.usiAebCcdXSize      = 2295;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktAebDataPktCfg.usiAebCcdYSize      = 2265;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktAebDataPktCfg.usiAebDataYSize     = 2255;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktAebDataPktCfg.usiAebOverscanYSize = 10;
		vpxCommChannel[ucChCnt]->xDataPacket.xDpktAebDataPktCfg.ucAebCcdId          = 0;

	}

	bSyncConfigFFeeSyncPeriod(12500);

	bSyncCtrIntern(TRUE);
	bSyncCtrCh1OutEnable(TRUE);
	bSyncCtrCh2OutEnable(TRUE);
	bSyncCtrCh3OutEnable(TRUE);
	bSyncCtrCh4OutEnable(TRUE);

	/* Testbench Code */

	printf("Ready!\n");

//	usleep(10*1000000);

//	ucChCnt = 0;
//	vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer    = eDpktOff;
//	vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer   = eDpktFullImagePatternDeb;
//	vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdNumberLeftBuffer  = 0;
//	vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdNumberRightBuffer = 0;
//	vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdSideLeftBuffer    = eDpktCcdSideE;
//	vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdSideRightBuffer   = eDpktCcdSideE;
//
//	if (bSdmaCommDmaTransfer(eDdr2Memory1, (alt_u32 *)0x0000F000, 81222, eSdmaRightBuffer, eSdmaCh1Buffer)){
//		printf("DMA Transfer 2 Successful\n");
//	}

//	ucChCnt = 0;
//	vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer    = eDpktFullImagePatternDeb;
//	vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer   = eDpktOff;
//	vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdNumberLeftBuffer  = 0;
//	vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdNumberRightBuffer = 0;
//	vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdSideLeftBuffer    = eDpktCcdSideE;
//	vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdSideRightBuffer   = eDpktCcdSideE;
//
//	if (bSdmaCommDmaTransfer(eDdr2Memory1, (alt_u32 *)0x00000000, 81222, eSdmaLeftBuffer, eSdmaCh1Buffer)){
//		printf("DMA Transfer 1 Successful\n");
//	}

	bDdr2SwitchMemory(eDdr2Memory1);

	alt_u32 uliAddrCnt = 0;
	alt_u32 *puliDdr2Addr = (alt_u32 *)0x00000000;
//	for (uliAddrCnt = 0; uliAddrCnt < (11046208 / 4); uliAddrCnt++) {
	for (uliAddrCnt = 0; uliAddrCnt < 11046208; uliAddrCnt++) {
		*(puliDdr2Addr) = 0xFFFFFFFF;
		puliDdr2Addr++;
	}

	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucOperMod           = 0xFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucEdacListCorrErr   = 0xFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucEdacListUncorrErr = 0xFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bPllRef             = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bPllVcxo            = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bPllLock            = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb4           = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb3           = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb2           = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bVdigAeb1           = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.ucWdwListCntOvf     = 0xFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebStatus.bWdg                = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList8           = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList7           = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList6           = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList5           = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList4           = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList3           = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList2           = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebOvf.bRowActList1           = TRUE;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk1.usiVdigIn             = 0xFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk1.usiVio                = 0xFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk2.usiVcor               = 0xFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk2.usiVlvd               = 0xFFFF;
	vpxRmapMemDebArea->xRmapDebAreaHk.xDebAhk3.usiDebTemp            = 0xFFFF;

//	alt_u8 ucAebCnt = 0;
//	for (ucAebCnt = 0; ucAebCnt < 4; ucAebCnt++) {
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.ucAebStatus                         = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.bVasp2CfgRun                        = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.bVasp1CfgRun                        = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.bDacCfgWrRun                        = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.bAdcCfgRdRun                        = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.bAdcCfgWrRun                        = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.bAdcDatRdRun                        = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.bAdcError                           = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.bAdc2Lu                             = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.bAdc1Lu                             = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.bAdcDatRd                           = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.bAdcCfgRd                           = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.bAdcCfgWr                           = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.bAdc2Busy                           = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAebStatus.bAdc1Busy                           = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1                 = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0                 = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTVaspL.bNewData                      = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTVaspL.bOvf                          = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTVaspL.bSupply                       = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTVaspL.ucChid                        = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliAdcChxDataTVaspL           = 0xFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTVaspR.bNewData                      = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTVaspR.bOvf                          = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTVaspR.bSupply                       = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTVaspR.ucChid                        = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliAdcChxDataTVaspR           = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTBiasP.bNewData                      = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTBiasP.bOvf                          = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTBiasP.bSupply                       = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTBiasP.ucChid                        = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliAdcChxDataTBiasP           = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTHkP.bNewData                        = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTHkP.bOvf                            = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTHkP.bSupply                         = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTHkP.ucChid                          = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTHkP.uliAdcChxDataTHkP               = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTTou1P.bNewData                      = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTTou1P.bOvf                          = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTTou1P.bSupply                       = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTTou1P.ucChid                        = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliAdcChxDataTTou1P           = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTTou2P.bNewData                      = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTTou2P.bOvf                          = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTTou2P.bSupply                       = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTTou2P.ucChid                        = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliAdcChxDataTTou2P           = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVode.bNewData                      = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVode.bOvf                          = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVode.bSupply                       = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVode.ucChid                        = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVode.uliAdcChxDataHkVode           = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVodf.bNewData                      = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVodf.bOvf                          = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVodf.bSupply                       = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVodf.ucChid                        = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliAdcChxDataHkVodf           = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVrd.bNewData                       = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVrd.bOvf                           = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVrd.bSupply                        = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVrd.ucChid                         = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliAdcChxDataHkVrd             = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVog.bNewData                       = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVog.bOvf                           = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVog.bSupply                        = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVog.ucChid                         = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkVog.uliAdcChxDataHkVog             = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTCcd.bNewData                        = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTCcd.bOvf                            = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTCcd.bSupply                         = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTCcd.ucChid                          = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTCcd.uliAdcChxDataTCcd               = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bNewData                   = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bOvf                       = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bSupply                    = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.ucChid                     = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliAdcChxDataTRef1KMea     = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bNewData                 = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bOvf                     = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bSupply                  = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.ucChid                   = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliAdcChxDataTRef649RMea = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bNewData                    = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bOvf                        = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bSupply                     = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.ucChid                      = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliAdcChxDataHkAnaN5V       = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataSRef.bNewData                        = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataSRef.bOvf                            = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataSRef.bSupply                         = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataSRef.ucChid                          = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataSRef.uliAdcChxDataSRef               = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bNewData                   = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bOvf                       = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bSupply                    = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.ucChid                     = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliAdcChxDataHkCcdP31V     = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bNewData                   = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bOvf                       = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bSupply                    = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.ucChid                     = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliAdcChxDataHkClkP15V     = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bNewData                    = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bOvf                        = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bSupply                     = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.ucChid                      = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliAdcChxDataHkAnaP5V       = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bNewData                   = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bOvf                       = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bSupply                    = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.ucChid                     = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliAdcChxDataHkAnaP3V3     = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bNewData                   = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bOvf                       = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bSupply                    = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.ucChid                     = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliAdcChxDataHkDigP3V3     = 0xFFFFFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bNewData                  = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bOvf                      = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bSupply                   = TRUE;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.ucChid                    = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.ucAdcChxDataAdcRefBuf2    = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xVaspRdConfig.ucVasp1ReadData                  = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xVaspRdConfig.ucVasp2ReadData                  = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xRevisionId1.usiFpgaVersion                    = 0xFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xRevisionId1.usiFpgaDate                       = 0xFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xRevisionId2.usiFpgaTimeH                      = 0xFFFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xRevisionId2.ucFpgaTimeM                       = 0xFF;
//		vpxRmapMemAebArea[ucAebCnt]->xRmapAebAreaHk.xRevisionId2.usiFpgaSvn                        = 0xFFFF;
//	}

	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.ucAebStatus                         = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.bVasp2CfgRun                        = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.bVasp1CfgRun                        = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.bDacCfgWrRun                        = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.bAdcCfgRdRun                        = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.bAdcCfgWrRun                        = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.bAdcDatRdRun                        = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.bAdcError                           = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.bAdc2Lu                             = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.bAdc1Lu                             = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.bAdcDatRd                           = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.bAdcCfgRd                           = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.bAdcCfgWr                           = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.bAdc2Busy                           = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAebStatus.bAdc1Busy                           = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1                 = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0                 = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTVaspL.bNewData                      = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTVaspL.bOvf                          = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTVaspL.bSupply                       = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTVaspL.ucChid                        = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliAdcChxDataTVaspL           = 0xAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTVaspR.bNewData                      = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTVaspR.bOvf                          = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTVaspR.bSupply                       = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTVaspR.ucChid                        = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliAdcChxDataTVaspR           = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTBiasP.bNewData                      = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTBiasP.bOvf                          = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTBiasP.bSupply                       = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTBiasP.ucChid                        = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliAdcChxDataTBiasP           = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTHkP.bNewData                        = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTHkP.bOvf                            = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTHkP.bSupply                         = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTHkP.ucChid                          = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTHkP.uliAdcChxDataTHkP               = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTTou1P.bNewData                      = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTTou1P.bOvf                          = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTTou1P.bSupply                       = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTTou1P.ucChid                        = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliAdcChxDataTTou1P           = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTTou2P.bNewData                      = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTTou2P.bOvf                          = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTTou2P.bSupply                       = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTTou2P.ucChid                        = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliAdcChxDataTTou2P           = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVode.bNewData                      = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVode.bOvf                          = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVode.bSupply                       = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVode.ucChid                        = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVode.uliAdcChxDataHkVode           = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVodf.bNewData                      = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVodf.bOvf                          = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVodf.bSupply                       = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVodf.ucChid                        = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliAdcChxDataHkVodf           = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVrd.bNewData                       = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVrd.bOvf                           = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVrd.bSupply                        = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVrd.ucChid                         = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliAdcChxDataHkVrd             = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVog.bNewData                       = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVog.bOvf                           = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVog.bSupply                        = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVog.ucChid                         = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkVog.uliAdcChxDataHkVog             = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTCcd.bNewData                        = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTCcd.bOvf                            = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTCcd.bSupply                         = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTCcd.ucChid                          = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTCcd.uliAdcChxDataTCcd               = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bNewData                   = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bOvf                       = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bSupply                    = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.ucChid                     = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliAdcChxDataTRef1KMea     = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bNewData                 = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bOvf                     = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bSupply                  = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.ucChid                   = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliAdcChxDataTRef649RMea = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bNewData                    = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bOvf                        = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bSupply                     = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.ucChid                      = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliAdcChxDataHkAnaN5V       = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataSRef.bNewData                        = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataSRef.bOvf                            = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataSRef.bSupply                         = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataSRef.ucChid                          = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataSRef.uliAdcChxDataSRef               = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bNewData                   = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bOvf                       = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bSupply                    = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.ucChid                     = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliAdcChxDataHkCcdP31V     = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bNewData                   = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bOvf                       = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bSupply                    = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.ucChid                     = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliAdcChxDataHkClkP15V     = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bNewData                    = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bOvf                        = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bSupply                     = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.ucChid                      = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliAdcChxDataHkAnaP5V       = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bNewData                   = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bOvf                       = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bSupply                    = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.ucChid                     = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliAdcChxDataHkAnaP3V3     = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bNewData                   = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bOvf                       = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bSupply                    = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.ucChid                     = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliAdcChxDataHkDigP3V3     = 0xAAAAAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bNewData                  = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bOvf                      = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bSupply                   = TRUE;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.ucChid                    = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.ucAdcChxDataAdcRefBuf2    = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xVaspRdConfig.ucVasp1ReadData                  = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xVaspRdConfig.ucVasp2ReadData                  = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xRevisionId1.usiFpgaVersion                    = 0xAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xRevisionId1.usiFpgaDate                       = 0xAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xRevisionId2.usiFpgaTimeH                      = 0xAAAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xRevisionId2.ucFpgaTimeM                       = 0xAA;
	vpxRmapMemAebArea[0]->xRmapAebAreaHk.xRevisionId2.usiFpgaSvn                        = 0xAAAA;

	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.ucAebStatus                         = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.bVasp2CfgRun                        = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.bVasp1CfgRun                        = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.bDacCfgWrRun                        = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.bAdcCfgRdRun                        = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.bAdcCfgWrRun                        = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.bAdcDatRdRun                        = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.bAdcError                           = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.bAdc2Lu                             = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.bAdc1Lu                             = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.bAdcDatRd                           = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.bAdcCfgRd                           = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.bAdcCfgWr                           = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.bAdc2Busy                           = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAebStatus.bAdc1Busy                           = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1                 = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0                 = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTVaspL.bNewData                      = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTVaspL.bOvf                          = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTVaspL.bSupply                       = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTVaspL.ucChid                        = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliAdcChxDataTVaspL           = 0xBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTVaspR.bNewData                      = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTVaspR.bOvf                          = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTVaspR.bSupply                       = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTVaspR.ucChid                        = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliAdcChxDataTVaspR           = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTBiasP.bNewData                      = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTBiasP.bOvf                          = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTBiasP.bSupply                       = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTBiasP.ucChid                        = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliAdcChxDataTBiasP           = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTHkP.bNewData                        = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTHkP.bOvf                            = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTHkP.bSupply                         = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTHkP.ucChid                          = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTHkP.uliAdcChxDataTHkP               = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTTou1P.bNewData                      = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTTou1P.bOvf                          = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTTou1P.bSupply                       = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTTou1P.ucChid                        = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliAdcChxDataTTou1P           = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTTou2P.bNewData                      = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTTou2P.bOvf                          = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTTou2P.bSupply                       = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTTou2P.ucChid                        = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliAdcChxDataTTou2P           = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVode.bNewData                      = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVode.bOvf                          = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVode.bSupply                       = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVode.ucChid                        = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVode.uliAdcChxDataHkVode           = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVodf.bNewData                      = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVodf.bOvf                          = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVodf.bSupply                       = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVodf.ucChid                        = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliAdcChxDataHkVodf           = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVrd.bNewData                       = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVrd.bOvf                           = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVrd.bSupply                        = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVrd.ucChid                         = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliAdcChxDataHkVrd             = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVog.bNewData                       = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVog.bOvf                           = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVog.bSupply                        = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVog.ucChid                         = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkVog.uliAdcChxDataHkVog             = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTCcd.bNewData                        = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTCcd.bOvf                            = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTCcd.bSupply                         = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTCcd.ucChid                          = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTCcd.uliAdcChxDataTCcd               = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bNewData                   = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bOvf                       = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bSupply                    = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.ucChid                     = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliAdcChxDataTRef1KMea     = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bNewData                 = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bOvf                     = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bSupply                  = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.ucChid                   = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliAdcChxDataTRef649RMea = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bNewData                    = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bOvf                        = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bSupply                     = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.ucChid                      = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliAdcChxDataHkAnaN5V       = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataSRef.bNewData                        = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataSRef.bOvf                            = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataSRef.bSupply                         = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataSRef.ucChid                          = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataSRef.uliAdcChxDataSRef               = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bNewData                   = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bOvf                       = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bSupply                    = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.ucChid                     = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliAdcChxDataHkCcdP31V     = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bNewData                   = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bOvf                       = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bSupply                    = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.ucChid                     = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliAdcChxDataHkClkP15V     = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bNewData                    = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bOvf                        = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bSupply                     = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.ucChid                      = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliAdcChxDataHkAnaP5V       = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bNewData                   = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bOvf                       = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bSupply                    = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.ucChid                     = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliAdcChxDataHkAnaP3V3     = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bNewData                   = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bOvf                       = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bSupply                    = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.ucChid                     = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliAdcChxDataHkDigP3V3     = 0xBBBBBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bNewData                  = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bOvf                      = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bSupply                   = TRUE;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.ucChid                    = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.ucAdcChxDataAdcRefBuf2    = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xVaspRdConfig.ucVasp1ReadData                  = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xVaspRdConfig.ucVasp2ReadData                  = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xRevisionId1.usiFpgaVersion                    = 0xBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xRevisionId1.usiFpgaDate                       = 0xBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xRevisionId2.usiFpgaTimeH                      = 0xBBBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xRevisionId2.ucFpgaTimeM                       = 0xBB;
	vpxRmapMemAebArea[1]->xRmapAebAreaHk.xRevisionId2.usiFpgaSvn                        = 0xBBBB;

	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.ucAebStatus                         = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.bVasp2CfgRun                        = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.bVasp1CfgRun                        = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.bDacCfgWrRun                        = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.bAdcCfgRdRun                        = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.bAdcCfgWrRun                        = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.bAdcDatRdRun                        = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.bAdcError                           = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.bAdc2Lu                             = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.bAdc1Lu                             = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.bAdcDatRd                           = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.bAdcCfgRd                           = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.bAdcCfgWr                           = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.bAdc2Busy                           = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAebStatus.bAdc1Busy                           = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1                 = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0                 = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTVaspL.bNewData                      = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTVaspL.bOvf                          = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTVaspL.bSupply                       = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTVaspL.ucChid                        = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliAdcChxDataTVaspL           = 0xCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTVaspR.bNewData                      = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTVaspR.bOvf                          = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTVaspR.bSupply                       = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTVaspR.ucChid                        = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliAdcChxDataTVaspR           = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTBiasP.bNewData                      = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTBiasP.bOvf                          = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTBiasP.bSupply                       = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTBiasP.ucChid                        = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliAdcChxDataTBiasP           = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTHkP.bNewData                        = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTHkP.bOvf                            = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTHkP.bSupply                         = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTHkP.ucChid                          = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTHkP.uliAdcChxDataTHkP               = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTTou1P.bNewData                      = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTTou1P.bOvf                          = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTTou1P.bSupply                       = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTTou1P.ucChid                        = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliAdcChxDataTTou1P           = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTTou2P.bNewData                      = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTTou2P.bOvf                          = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTTou2P.bSupply                       = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTTou2P.ucChid                        = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliAdcChxDataTTou2P           = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVode.bNewData                      = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVode.bOvf                          = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVode.bSupply                       = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVode.ucChid                        = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVode.uliAdcChxDataHkVode           = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVodf.bNewData                      = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVodf.bOvf                          = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVodf.bSupply                       = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVodf.ucChid                        = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliAdcChxDataHkVodf           = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVrd.bNewData                       = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVrd.bOvf                           = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVrd.bSupply                        = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVrd.ucChid                         = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliAdcChxDataHkVrd             = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVog.bNewData                       = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVog.bOvf                           = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVog.bSupply                        = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVog.ucChid                         = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkVog.uliAdcChxDataHkVog             = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTCcd.bNewData                        = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTCcd.bOvf                            = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTCcd.bSupply                         = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTCcd.ucChid                          = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTCcd.uliAdcChxDataTCcd               = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bNewData                   = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bOvf                       = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bSupply                    = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.ucChid                     = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliAdcChxDataTRef1KMea     = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bNewData                 = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bOvf                     = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bSupply                  = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.ucChid                   = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliAdcChxDataTRef649RMea = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bNewData                    = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bOvf                        = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bSupply                     = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.ucChid                      = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliAdcChxDataHkAnaN5V       = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataSRef.bNewData                        = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataSRef.bOvf                            = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataSRef.bSupply                         = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataSRef.ucChid                          = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataSRef.uliAdcChxDataSRef               = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bNewData                   = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bOvf                       = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bSupply                    = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.ucChid                     = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliAdcChxDataHkCcdP31V     = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bNewData                   = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bOvf                       = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bSupply                    = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.ucChid                     = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliAdcChxDataHkClkP15V     = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bNewData                    = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bOvf                        = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bSupply                     = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.ucChid                      = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliAdcChxDataHkAnaP5V       = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bNewData                   = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bOvf                       = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bSupply                    = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.ucChid                     = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliAdcChxDataHkAnaP3V3     = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bNewData                   = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bOvf                       = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bSupply                    = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.ucChid                     = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliAdcChxDataHkDigP3V3     = 0xCCCCCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bNewData                  = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bOvf                      = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bSupply                   = TRUE;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.ucChid                    = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.ucAdcChxDataAdcRefBuf2    = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xVaspRdConfig.ucVasp1ReadData                  = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xVaspRdConfig.ucVasp2ReadData                  = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xRevisionId1.usiFpgaVersion                    = 0xCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xRevisionId1.usiFpgaDate                       = 0xCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xRevisionId2.usiFpgaTimeH                      = 0xCCCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xRevisionId2.ucFpgaTimeM                       = 0xCC;
	vpxRmapMemAebArea[2]->xRmapAebAreaHk.xRevisionId2.usiFpgaSvn                        = 0xCCCC;

	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.ucAebStatus                         = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.bVasp2CfgRun                        = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.bVasp1CfgRun                        = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.bDacCfgWrRun                        = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.bAdcCfgRdRun                        = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.bAdcCfgWrRun                        = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.bAdcDatRdRun                        = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.bAdcError                           = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.bAdc2Lu                             = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.bAdc1Lu                             = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.bAdcDatRd                           = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.bAdcCfgRd                           = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.bAdcCfgWr                           = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.bAdc2Busy                           = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAebStatus.bAdc1Busy                           = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xTimestamp1.uliTimestampDword1                 = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xTimestamp2.uliTimestampDword0                 = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTVaspL.bNewData                      = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTVaspL.bOvf                          = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTVaspL.bSupply                       = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTVaspL.ucChid                        = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTVaspL.uliAdcChxDataTVaspL           = 0xDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTVaspR.bNewData                      = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTVaspR.bOvf                          = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTVaspR.bSupply                       = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTVaspR.ucChid                        = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTVaspR.uliAdcChxDataTVaspR           = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTBiasP.bNewData                      = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTBiasP.bOvf                          = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTBiasP.bSupply                       = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTBiasP.ucChid                        = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTBiasP.uliAdcChxDataTBiasP           = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTHkP.bNewData                        = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTHkP.bOvf                            = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTHkP.bSupply                         = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTHkP.ucChid                          = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTHkP.uliAdcChxDataTHkP               = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTTou1P.bNewData                      = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTTou1P.bOvf                          = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTTou1P.bSupply                       = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTTou1P.ucChid                        = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTTou1P.uliAdcChxDataTTou1P           = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTTou2P.bNewData                      = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTTou2P.bOvf                          = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTTou2P.bSupply                       = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTTou2P.ucChid                        = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTTou2P.uliAdcChxDataTTou2P           = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVode.bNewData                      = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVode.bOvf                          = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVode.bSupply                       = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVode.ucChid                        = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVode.uliAdcChxDataHkVode           = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVodf.bNewData                      = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVodf.bOvf                          = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVodf.bSupply                       = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVodf.ucChid                        = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVodf.uliAdcChxDataHkVodf           = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVrd.bNewData                       = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVrd.bOvf                           = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVrd.bSupply                        = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVrd.ucChid                         = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVrd.uliAdcChxDataHkVrd             = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVog.bNewData                       = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVog.bOvf                           = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVog.bSupply                        = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVog.ucChid                         = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkVog.uliAdcChxDataHkVog             = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTCcd.bNewData                        = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTCcd.bOvf                            = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTCcd.bSupply                         = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTCcd.ucChid                          = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTCcd.uliAdcChxDataTCcd               = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bNewData                   = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bOvf                       = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.bSupply                    = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.ucChid                     = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTRef1KMea.uliAdcChxDataTRef1KMea     = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bNewData                 = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bOvf                     = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.bSupply                  = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.ucChid                   = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataTRef649RMea.uliAdcChxDataTRef649RMea = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bNewData                    = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bOvf                        = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.bSupply                     = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.ucChid                      = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaN5V.uliAdcChxDataHkAnaN5V       = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataSRef.bNewData                        = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataSRef.bOvf                            = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataSRef.bSupply                         = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataSRef.ucChid                          = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataSRef.uliAdcChxDataSRef               = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bNewData                   = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bOvf                       = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.bSupply                    = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.ucChid                     = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkCcdP31V.uliAdcChxDataHkCcdP31V     = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bNewData                   = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bOvf                       = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.bSupply                    = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.ucChid                     = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkClkP15V.uliAdcChxDataHkClkP15V     = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bNewData                    = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bOvf                        = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.bSupply                     = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.ucChid                      = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP5V.uliAdcChxDataHkAnaP5V       = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bNewData                   = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bOvf                       = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.bSupply                    = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.ucChid                     = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkAnaP3V3.uliAdcChxDataHkAnaP3V3     = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bNewData                   = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bOvf                       = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.bSupply                    = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.ucChid                     = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataHkDigP3V3.uliAdcChxDataHkDigP3V3     = 0xDDDDDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bNewData                  = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bOvf                      = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.bSupply                   = TRUE;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.ucChid                    = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xAdcRdDataAdcRefBuf2.ucAdcChxDataAdcRefBuf2    = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xVaspRdConfig.ucVasp1ReadData                  = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xVaspRdConfig.ucVasp2ReadData                  = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xRevisionId1.usiFpgaVersion                    = 0xDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xRevisionId1.usiFpgaDate                       = 0xDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xRevisionId2.usiFpgaTimeH                      = 0xDDDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xRevisionId2.ucFpgaTimeM                       = 0xDD;
	vpxRmapMemAebArea[3]->xRmapAebAreaHk.xRevisionId2.usiFpgaSvn                        = 0xDDDD;

	usleep(2*1000000);

	printf("Releasing Sync...\n");
	bSyncCtrReset();
	bSyncCtrStart();

	usleep(1*1000000);

	vpxSyncModule->xPreSyncIrqFlagClr.bPreBlankPulseIrqFlagClr = TRUE;
	vpxSyncModule->xPreSyncIrqEn.bPreBlankPulseIrqEn = TRUE;
	vpxSyncModule->xSyncIrqFlagClr.bBlankPulseIrqFlagClr = TRUE;
	vpxSyncModule->xSyncIrqEn.bBlankPulseIrqEn = TRUE;


	alt_u32 uliTransCnt = 0;
	for (uliTransCnt = 0; uliTransCnt < 4; uliTransCnt++) {
		printf("\nIteration %lu\n", uliTransCnt);
//	while (1){

		while (!vpxSyncModule->xPreSyncIrqFlag.bPreBlankPulseIrqFlag){}
		printf("Pre-Sync\n");
		vpxSyncModule->xPreSyncIrqFlagClr.bPreBlankPulseIrqFlagClr = TRUE;

//		ucChCnt = 0;
//		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer    = eDpktOff;
//		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer   = eDpktFullImagePatternDeb;
//		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdNumberLeftBuffer  = 0;
//		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdNumberRightBuffer = 0;
//		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdSideLeftBuffer    = eDpktCcdSideE;
//		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdSideRightBuffer   = eDpktCcdSideE;
//
//		if (bSdmaCommDmaTransfer(eDdr2Memory2, (alt_u32 *)0x0000F000, 81222, eSdmaRightBuffer, eSdmaCh1Buffer)){
//			printf("DMA Transfer 2 Successful\n");
//		}

			ucChCnt = 0;

			vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer    = eDpktFullImagePatternDeb;
			vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer   = eDpktOff;
			vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdNumberLeftBuffer  = (alt_u8)uliTransCnt;
			vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdNumberRightBuffer = (alt_u8)uliTransCnt;
			vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdSideLeftBuffer    = eDpktCcdSideE;
			vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdSideRightBuffer   = eDpktCcdSideF;

			vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebMachineControl.bStop = TRUE;
			vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebMachineControl.bClear = TRUE;
			vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebMachineControl.bStart = TRUE;
			if (bSdmaCommDmaTransfer(eDdr2Memory1, (alt_u32 *)0x00000000, 81222, eSdmaLeftBuffer, eSdmaCh1Buffer)){
				printf("DMA Transfer 1 Successful\n");
			}
//			if (bSdmaCommDmaTransfer(eDdr2Memory1, (alt_u32 *)0x00000000, 81222, eSdmaRightBuffer, eSdmaCh1Buffer)){
//				printf("DMA Transfer 2 Successful\n");
//			}


//			ucChCnt = 1;
//
//			vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer    = eDpktOff;
//			vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer   = eDpktFullImagePatternDeb;
//			vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdNumberLeftBuffer  = 3;
//			vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdNumberRightBuffer = 3;
//			vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdSideLeftBuffer    = eDpktCcdSideE;
//			vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdSideRightBuffer   = eDpktCcdSideF;
//
//			vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebMachineControl.bStop = TRUE;
//			vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebMachineControl.bClear = TRUE;
//			vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebMachineControl.bStart = TRUE;
//			if (bSdmaCommDmaTransfer(eDdr2Memory2, (alt_u32 *)0x0000F000, 81222, eSdmaRightBuffer, eSdmaCh2Buffer)){
//				printf("DMA Transfer 2 Successful\n");
//			}

		while (!vpxSyncModule->xSyncIrqFlag.bBlankPulseIrqFlag){}
		printf("Sync\n");
		vpxSyncModule->xSyncIrqFlagClr.bBlankPulseIrqFlagClr = TRUE;

//		ucChCnt = 0;
//		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucFeeModeLeftBuffer    = eDpktFullImagePatternDeb;
//		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucFeeModeRightBuffer   = eDpktOff;
//		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdNumberLeftBuffer  = 0;
//		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdNumberRightBuffer = 0;
//		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdSideLeftBuffer    = eDpktCcdSideE;
//		vpxCommChannel[ucChCnt]->xDataPacket.xDpktDataPacketConfig.ucCcdSideRightBuffer   = eDpktCcdSideE;
//
//		if (bSdmaCommDmaTransfer(eDdr2Memory1, (alt_u32 *)0x00000000, 81222, eSdmaLeftBuffer, eSdmaCh1Buffer)){
//			printf("DMA Transfer 1 Successful\n");
//		}

//	ucChCnt = 0;
//	vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebBufferDataControl.uliRightRdInitAddrLowDword = 0;
//	vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebBufferDataControl.uliRightRdInitAddrHighDword = 0;
//	vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebBufferDataControl.uliRightRdDataLenghtBytes = 11046208 - FEEB_DATA_ACCESS_WIDTH_BYTES;
//	vpxCommChannel[ucChCnt]->xFeeBuffer.xFeebBufferDataControl.bRightRdStart = TRUE;

	}

	printf("\n\nFinished!!\n\n\n");

	while(1) {}

	return 0;
}
