/*
 * fee_controler.c
 *
 *  Created on: 22/01/2019
 *      Author: Tiago-note
 */


#include "fee_controller.h"

void vFFeeControlInit( TFFee_Control *xFeeControlL ) {
    unsigned char ucIL = 0;
    
    /* Reset TimeCode */
    vResetTimeCode( xFeeControlL );
    /* Load Default Id for FFEE master */
    vLoadDefaultIdFFEEMaster( xFeeControlL );

    /* Calculate the */
    for ( ucIL = 0; ucIL < N_OF_FastFEE; ucIL++ ) {
    	vFFeeStructureInit( &xFeeControlL->xFfee[ ucIL ], ucIL);
        xFeeControlL->pbEnabledFFEEs[ ucIL ] = &xFeeControlL->xFfee[ ucIL ].xControl.bEnabled;
        xFeeControlL->pbSimulatingFFEEs[ ucIL ] = &xFeeControlL->xFfee[ ucIL ].xControl.bSimulating;
        xFeeControlL->xFfee[ ucIL ].xControl.pActualMem = xFeeControlL->pActualMem;
    }

}

/* Any mode */
/* Set the time code of the Simucam */
void vSetTimeCode( TFFee_Control *xFeeControlL, unsigned char ucTime ) {
    xFeeControlL->ucTimeCode = ucTime;
}

/* Reset the time code of the Simucam */
void vResetTimeCode( TFFee_Control *xFeeControlL ) {
    xFeeControlL->ucTimeCode = 0;
}

/* Only in MEB_CONFIG */
/* Load Default Config for IdFFEEMaster */
void vLoadDefaultIdFFEEMaster( TFFee_Control *xFeeControlL ) {
    //bGetIdFFEEMasterSDCard();
    //todo: For now is hardcoded
    //xFeeControlL->ucIdFFEEMaster = 0;
}

/* Only in MEB_CONFIG */
/* Change the Config for IdFFEEMaster*/
void vChangeIdFFEEMaster( TFFee_Control *xFeeControlL, unsigned char ucIdMaster ) {
    //xFeeControlL->ucIdFFEEMaster = ucIdMaster;
}

/* Only in MEB_CONFIG */
/* Change the Default Config for IdFFEEMaster */
void vChangeDefaultIdFFEEMaster( TFFee_Control *xFeeControlL, unsigned char ucIdMaster ) {
    //bSaveIdFFEEMasterSDCard(ucIdMaster);
}
