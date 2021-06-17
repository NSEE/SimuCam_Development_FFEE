/*
 * Fee_Controller.h
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */

#ifndef FEE_CONTROLLER_H_
#define FEE_CONTROLLER_H_


#include "../simucam_definitions.h"
#include "ffee.h"
#include "ccd.h"



#define N_OF_MSG_QUEUE 	64 	/* N_OF_FFEE * 2 => Two empty buffer ISRs */
#define N_MSG_FEE		128	/* The FEE entities will receive comands through the Queue, and this define is the length */
#define	N_MESG_SYNCRST	8	/* sync reset qck msg stack size [bndky] */


//#define N_MSG_SYNC		8	/* The FEE entities will receive comands through the Queue, and this define is the length */

#define N_OF_MSG_QUEUE_MASK 	64 	/* N of commands in the Queue to Data controller and FFEE Controller */

typedef struct FFee_Control {
	TFFee   xFfee[N_OF_FastFEE];               /* All instances of control for the FFEE */
	unsigned char *pActualMem;				/* Point to the actual memory in simulation */
	bool    *pbEnabledFFEEs[N_OF_FastFEE];     /* Which are the FFEEs that are enabled */
	bool    *pbSimulatingFFEEs[N_OF_FastFEE];     /* Which are the FFEEs that are enabled */
	unsigned char ucTimeCode;               /* Timecode */
	//unsigned char ucIdFFEEMaster;       /* Set which F-FEE simulation is the master */
	bool 	*pbUpdateCReadOnly;
} TFFee_Control;

void vFFeeControlInit( TFFee_Control *xFeeControlL );
void vSetTimeCode( TFFee_Control *xFeeControlL, unsigned char ucTime );
void vResetTimeCode( TFFee_Control *xFeeControlL );
void vLoadDefaultIdFFEEMaster( TFFee_Control *xFeeControlL );
void vChangeIdFFEEMaster( TFFee_Control *xFeeControlL, unsigned char ucIdMaster );
void vChangeDefaultIdFFEEMaster( TFFee_Control *xFeeControlL, unsigned char ucIdMaster );



#endif /* FEE_CONTROLLER_H_ */
