/*
 * data_controller.h
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */

#ifndef DATA_CONTROLLER_H_
#define DATA_CONTROLLER_H_


#include "../simucam_definitions.h"
#include "fee_controller.h"
#include "ffee.h"
#include "ccd.h"

typedef enum { sSubInit  = 0, sSubMemUpdated, sSubSetupEpoch, sSubRequest, sSubWaitIRQBuffer, sSubScheduleDMA, sSubLastPckt, sWaitForEmptyBufferIRQ } tDTCSubStates;

typedef struct Fee_CtrlReadOnly {
	TFFee   *xFee[N_OF_FastFEE];               /* All instances of control for the FEE */
	bool    *pbEnabledFee[N_OF_FastFEE];     /* Which are the FEEs that are enabled */
	unsigned char *ucTimeCode;               /* Timecode */
} TFee_CtrlReadOnly;


/* Data Controller for a Simucam of FFEEs.
 * The data controller is responsible for prepare the Ram memory for the N+1 master sync Simulation */
typedef struct Data_Control {
	unsigned char ucMoreThan2MSyncWithoutUpdate[N_OF_FastFEE];
	bool bInsgestionSchedule[N_OF_FastFEE];
	OS_EVENT *xSemDmaAccess[N_OF_FastFEE];
	TFee_CtrlReadOnly xReadOnlyFeeControl;
	bool bUpdateComplete;
	tSimucamStates sMode;
	volatile tDTCSubStates sRunMode;
	unsigned char *pNextMem;				/* Point to the actual memory in simulation */
	TFFee   xCopyFfee[N_OF_FastFEE];           /* All instances of control for the FFEE */
	bool bFirstMaster;
	unsigned short int usiEPn;
	unsigned short int usiUpdatedEPn;
	bool bEPnUpdated;
} TData_Control; /* Read Only Structure */

void vDataControllerInit( TData_Control *xDataControlL, TFFee_Control *xFfeeCOntrolL );

#endif /* DATA_CONTROLLER_H_ */
