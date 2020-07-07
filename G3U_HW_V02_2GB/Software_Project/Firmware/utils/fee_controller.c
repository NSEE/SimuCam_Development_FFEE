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
    /* Load Default Id for NFEE master */
    vLoadDefaultIdNFEEMaster( xFeeControlL );

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
/* Load Default Config for IdNFEEMaster */
void vLoadDefaultIdNFEEMaster( TFFee_Control *xFeeControlL ) {
    //bGetIdNFEEMasterSDCard();
    //todo: For now is hardcoded
    //xFeeControlL->ucIdNFEEMaster = 0;
}

/* Only in MEB_CONFIG */
/* Change the Config for IdNFEEMaster*/
void vChangeIdNFEEMaster( TFFee_Control *xFeeControlL, unsigned char ucIdMaster ) {
    //xFeeControlL->ucIdNFEEMaster = ucIdMaster;
}

/* Only in MEB_CONFIG */
/* Change the Default Config for IdNFEEMaster */
void vChangeDefaultIdNFEEMaster( TFFee_Control *xFeeControlL, unsigned char ucIdMaster ) {
    //bSaveIdNFEEMasterSDCard(ucIdMaster);
}
