/*
 * data_controller.c
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */


#include "data_controller.h"


void vDataControllerInit( TNData_Control *xDataControlL, TFFee_Control *xFfeeCOntrolL ) {
	unsigned char ucIL;

	xDataControlL->sMode = sMebInit;

	for ( ucIL = 0 ; ucIL < N_OF_FastFEE; ucIL++ ) {
		xDataControlL->xReadOnlyFeeControl.xNfee[ucIL] = &xFfeeCOntrolL->xFfee[ucIL];
		/* We need the same structure of the FEE_Control to manipulate the data load of the memory, MEMORY MAP ONLY, this will not be updated, so we still need the xReadOnlyFeeControl */
		xDataControlL->xCopyFfee[ucIL] = xFfeeCOntrolL->xFfee[ucIL];
		xDataControlL->xReadOnlyFeeControl.pbEnabledNFEEs[ucIL] = xFfeeCOntrolL->pbEnabledFFEEs[ucIL];
		xDataControlL->bInsgestionSchedule[ucIL] = FALSE;
		xDataControlL->ucMoreThan2MSyncWithoutUpdate[ucIL] = FALSE;
	}
	
	xDataControlL->xReadOnlyFeeControl.ucTimeCode = &xFfeeCOntrolL->ucTimeCode;
	xDataControlL->bUpdateComplete = FALSE;
	xDataControlL->usiEPn = 0;

	/* The only inverse attribution */
	/* This variable indicates when the DataControl finishs to use the RAM, then FeeControl can start fill the buffer to the next MasterSync */
	xFfeeCOntrolL->pbUpdateCReadOnly = &xDataControlL->bUpdateComplete;
}
