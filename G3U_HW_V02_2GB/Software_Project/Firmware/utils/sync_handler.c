/*
 * sync_handle.c
 *
 *  Created on: 25/01/2019
 *      Author: Tiago-note
 */

#include "sync_handler.h"

/* todo: Create a struct that will contain all config, and pass as parameter to the functions */

bool bInitSync(void) {
	bool bSuccess;

#if DEBUG_ON
	if (xDefaults.usiDebugLevel <= dlMinorMessage) {
		debug(fp, "Initializing Sync Module.\n");
	}
#endif

#if DEBUG_ON
	if (xDefaults.usiDebugLevel <= dlMajorMessage) {
		fprintf(fp, "xDefaults.usiPreBtSync = %hu\n", xDefaults.usiPreBtSync);
	}
#endif

	/* Configure the internal sync, default period = 2.5 s */
	bSuccess = bSyncConfigFFeeSyncPeriod(cusiSyncFFeeSyncPeriodMs);
	if (bSuccess == FALSE) {
		return bSuccess;
	}

	/* Set mux to internal sync */
	bSuccess = bSyncCtrIntern(TRUE);
	if (bSuccess == FALSE) {
		return bSuccess;
	}

	/* Enable sync output (sync output should be the internal sync) */
	bSuccess = bSyncCtrSyncOutEnable(TRUE);
	if (bSuccess == FALSE) {
		return bSuccess;
	}

	/* Enable sync output for channel 1 (releases the sync signal to Ch 1) */
	bSuccess = bSyncCtrCh1OutEnable(TRUE);
	if (bSuccess == FALSE) {
		return bSuccess;
	}

	/* Enable sync output for channel 2 (releases the sync signal to Ch 2) */
	bSuccess = bSyncCtrCh2OutEnable(TRUE);
	if (bSuccess == FALSE) {
		return bSuccess;
	}

	/* Enable sync output for channel 3 (releases the sync signal to Ch 3) */
	bSuccess = bSyncCtrCh3OutEnable(TRUE);
	if (bSuccess == FALSE) {
		return bSuccess;
	}

	/* Enable sync output for channel 4 (releases the sync signal to Ch 4) */
	bSuccess = bSyncCtrCh4OutEnable(TRUE);
	if (bSuccess == FALSE) {
		return bSuccess;
	}

	bSuccess = bSyncCtrStart();
	bSyncCtrReset();

	vSyncInitIrq();
	vSyncPreInitIrq();

	/* Blank Pulse IRQ triggers at all sync pulses */
	bSyncIrqEnableBlankPulse(TRUE);

	/* Blank Pulse IRQ triggers at all pre-sync pulses */
	bSyncPreIrqEnableBlankPulse(TRUE);

	return bSuccess;
}

bool bStartSync(void) {

	bool bSuccess;
	bSyncCtrReset();
	bSuccess = bSyncCtrStart();

	return bSuccess;
}

bool bStopSync(void) {
	return bSyncCtrReset();
}

void bClearCounterSync(void) {
	vSyncClearCounter();
}
