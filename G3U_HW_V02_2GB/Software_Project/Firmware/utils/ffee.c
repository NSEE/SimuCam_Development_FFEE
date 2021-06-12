/*
 * ffee.c
 *
 *  Created on: 27 de jun de 2020
 *      Author: Tiago-note
 */

#include "ffee.h"


/* Initialize the structure of control of NFEE with the default Configurations */
void vFFeeStructureInit( TFFee *pxNfeeL, unsigned char ucIdFFEE ) {
    unsigned char ucIL = 0;

    /* NFEE id [0..5] */
    pxNfeeL->ucId = ucIdFFEE;

    /* Load the default values of the CCDs regarding pixels configuration */
    vCCDLoadDefaultValues(&pxNfeeL->xCcdInfo);

    /* Update the values of memory mapping for this FEE */
    vUpdateMemMapFEE(pxNfeeL);

    /* Initilizing control variables */
    pxNfeeL->xControl.bEnabled = TRUE;
    pxNfeeL->xControl.bChannelEnable = FALSE;
    pxNfeeL->xControl.bSimulating = FALSE;
    pxNfeeL->xControl.bWatingSync = FALSE;
    pxNfeeL->xControl.bEchoing = FALSE;
    pxNfeeL->xControl.bLogging = FALSE;
    pxNfeeL->xControl.bTransientMode = FALSE;
    /* The default side is left */
    pxNfeeL->xControl.xDeb.ucTimeCode = 0;
    pxNfeeL->xControl.xDeb.ucTimeCodeSpwChannel = 0;


    /* The NFEE initialize in the Config mode by default */
    pxNfeeL->xControl.xDeb.eState = sInit;
    pxNfeeL->xControl.xDeb.eLastMode = sInit;
    pxNfeeL->xControl.xDeb.eMode = sInit;
    pxNfeeL->xControl.xDeb.eNextMode = sInit;

    pxNfeeL->xControl.xDeb.eDataSource = dsPattern;

    /*  todo: This function supposed to load the values from a SD Card in the future, for now it will load
        hard coded values */

    /* 4 AEBs */
    for (ucIL=0; ucIL<N_OF_CCD; ucIL++) {
    	pxNfeeL->xControl.xAeb[ucIL].bSwitchedOn = FALSE;

    	pxNfeeL->ucSPWId[ ucIL + ucIdFFEE*N_OF_CCD] = (unsigned char)xDefaultsCH.ucFEEtoChanell[ ucIL + ucIdFFEE*N_OF_CCD ];

        /* Initialize the structs of the Channel, Double Buffer, RMAP and Data packet */
        if ( FALSE == bCommInitCh(&pxNfeeL->xChannel[ucIL + ucIdFFEE*N_OF_CCD ], pxNfeeL->ucSPWId[ ucIL + ucIdFFEE*N_OF_CCD ] )) {
    		#if DEBUG_ON
        	if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
    			fprintf(fp, "\n CRITICAL! Can't Initialized SPW Channel %i \n", pxNfeeL->ucId);
        	}
    		#endif
        }

        if ( bCommSetGlobalIrqEn( TRUE, pxNfeeL->ucSPWId[ ucIL + ucIdFFEE*N_OF_CCD ] ) == FALSE ) {
    		#if DEBUG_ON
        	if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
    			fprintf(fp, "\n CRITICAL! Can't Enable global interrupt for the channel %i \n", pxNfeeL->ucId);
        	}
    		#endif
        }

		bDpktGetPixelDelay(&pxNfeeL->xChannel[ucIL].xDataPacket);
		pxNfeeL->xChannel[ucIL].xDataPacket.xDpktPixelDelay.uliStartDelay = uliPxDelayCalcPeriodMs(xDefaults.ulStartDelay);
		pxNfeeL->xChannel[ucIL].xDataPacket.xDpktPixelDelay.uliSkipDelay = uliPxDelayCalcPeriodNs(xDefaults.ulSkipDelay);
		pxNfeeL->xChannel[ucIL].xDataPacket.xDpktPixelDelay.uliLineDelay = uliPxDelayCalcPeriodNs(xDefaults.ulLineDelay);
		pxNfeeL->xChannel[ucIL].xDataPacket.xDpktPixelDelay.uliAdcDelay = uliPxDelayCalcPeriodNs(xDefaults.ulADCPixelDelay);
		bDpktSetPixelDelay(&pxNfeeL->xChannel[ucIL].xDataPacket);

		/* Copy to control what should be applied in the master Sync - FullImage */
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.bEnabled = FALSE;
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.bMissingData = FALSE;
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.bMissingPkts = FALSE;
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.bTxDisabled = FALSE;
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.ucFrameNum = 0;
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiDataCnt = 0;
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiNRepeat = 0;
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiSequenceCnt = 0;

		/* Copy to control what should be applied in the master Sync - Windowing */
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.bEnabled = FALSE;
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.bMissingData = FALSE;
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.bMissingPkts = FALSE;
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.bTxDisabled = FALSE;
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.ucFrameNum = 0;
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.usiDataCnt = 0;
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.usiNRepeat = 0;
		pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.usiSequenceCnt = 0;

		bDpktGetTransmissionErrInj(&pxNfeeL->xChannel[ucIL].xDataPacket);
		pxNfeeL->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bMissingDataEn = pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.bMissingData;
		pxNfeeL->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bMissingPktsEn = pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.bMissingPkts;
		pxNfeeL->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bTxDisabledEn = pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.bTxDisabled;
		pxNfeeL->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.ucFrameNum = pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.ucFrameNum;
		pxNfeeL->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiDataCnt = pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiDataCnt;
		pxNfeeL->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiNRepeat = pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiNRepeat;
		pxNfeeL->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiSequenceCnt = pxNfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiSequenceCnt;
		bDpktSetTransmissionErrInj(&pxNfeeL->xChannel[ucIL].xDataPacket);

		pxNfeeL->xErrorInjControl[ucIL].xSpacewireErrInj.bDestinationErrorEn = FALSE;
		pxNfeeL->xErrorInjControl[ucIL].xSpacewireErrInj.ucOriginalDestAddr = 0;

		pxNfeeL->xErrorInjControl[ucIL].xDataPktError.ucErrorCnt = 0;
		pxNfeeL->xErrorInjControl[ucIL].xDataPktError.bStartErrorInj = FALSE;

		pxNfeeL->xErrorInjControl[ucIL].xImgWinContentErr.ucLeftErrorCnt = 0;
		pxNfeeL->xErrorInjControl[ucIL].xImgWinContentErr.ucRightErrorCnt = 0;
		pxNfeeL->xErrorInjControl[ucIL].xImgWinContentErr.bStartLeftErrorInj = FALSE;
		pxNfeeL->xErrorInjControl[ucIL].xImgWinContentErr.bStartRightErrorInj = FALSE;
    }

    for (ucIL=0; ucIL<8; ucIL++) {
    	pxNfeeL->xControl.xDeb.ucTxInMode[ucIL] = 0;
    }

}

/* Update the memory mapping for the FEE due to the CCD informations */
void vUpdateMemMapFEE( TFFee *pxNfeeL ) {
    unsigned long ulTotalSizeL = 0; /* pixels */
    unsigned long ulMemLinesL = 0; /* mem lines */
    unsigned long ulTotalMemLinesL = 0;
    unsigned long ulMemLeftBytesL = 0; /* bytes */
    unsigned long ulMemLeftLinesL = 0; /* mem lines */
    unsigned long ulMaskMemLinesL = 0; /* mem lines */
    unsigned char ucPixelsInLastBlockL = 0;
    unsigned char ucShiftsL = 0;
    unsigned char ucIL = 0;
    unsigned long ulLastOffset = 0;
    unsigned long ulStepHalfCCD = 0;


    /* Size of the footprint of the CCD in the DDR memory */
    pxNfeeL->xMemMap.ulTotalBytes = ( OFFSET_STEP_FEE );

    /* Offset of the FEE in the DDR memory */
    pxNfeeL->xMemMap.ulOffsetRoot = OFFSET_STEP_FEE * pxNfeeL->ucId;

    /* LUT Addrs */
    pxNfeeL->xMemMap.ulLUTAddr = LUT_INITIAL_ADDR + pxNfeeL->xMemMap.ulOffsetRoot;

    /* (HEIGHT + usiOLN)*(usiSPrescanN + usiSOverscanN + usiHalfWidth) */
    ulTotalSizeL =  ( pxNfeeL->xCcdInfo.usiHeight + pxNfeeL->xCcdInfo.usiOLN ) *
                    ( pxNfeeL->xCcdInfo.usiHalfWidth + pxNfeeL->xCcdInfo.usiSOverscanN + pxNfeeL->xCcdInfo.usiSPrescanN );

    /* Total size in Bytes of a half CCD */
    pxNfeeL->xCommon.usiTotalBytes = ulTotalSizeL * BYTES_PER_PIXEL;

    /* Total of Memory lines (64 bits memory) */
    ulMemLinesL = (unsigned long) pxNfeeL->xCommon.usiTotalBytes / BYTES_PER_MEM_LINE;
    ulMemLeftBytesL = pxNfeeL->xCommon.usiTotalBytes % BYTES_PER_MEM_LINE;   /* Word memory Alignment check: how much bytes left not align in the last word of the memory */
    if ( ulMemLeftBytesL > 0 ) {
        ulMemLinesL = ulMemLinesL + 1;
        pxNfeeL->xCommon.usiTotalBytes = pxNfeeL->xCommon.usiTotalBytes - ulMemLeftBytesL + BYTES_PER_MEM_LINE; /* Add a full line, after will be filled with zero padding */
        pxNfeeL->xCommon.ucPaddingBytes = BYTES_PER_MEM_LINE - ulMemLeftBytesL;
    } else {
        pxNfeeL->xCommon.ucPaddingBytes = 0;
    }

    /* At this point we have mapping the pixel in the CCD and calculate the zero padding for the last WORD of the line memory of the half ccd */

    /* For every 16 mem line will be 1 mask mem line */
    ulMaskMemLinesL = (unsigned long) ulMemLinesL / BLOCK_MEM_SIZE;
    ulMemLeftLinesL = ulMemLinesL % BLOCK_MEM_SIZE;
    if ( ulMemLeftLinesL >= 1 ) {
        ulMaskMemLinesL = ulMaskMemLinesL + 1;
        ulTotalMemLinesL = ( ulMemLinesL - ulMemLeftLinesL + BLOCK_MEM_SIZE ) + ulMaskMemLinesL; /* One extra 16 sized block, will be filled with zero padding the ret os spare lines */
    } else {
        ulTotalMemLinesL = ulMemLinesL + ulMaskMemLinesL;
    }

    pxNfeeL->xCommon.usiTotalBytes = ulTotalMemLinesL * BYTES_PER_MEM_LINE;


    /* Calculating how is the final mask with zero padding */
    if ( ulMemLeftBytesL >= 1 ) {
        ucPixelsInLastBlockL = (unsigned char) (( ulMemLeftLinesL * PIXEL_PER_MEM_LINE ) + (unsigned int) ( ulMemLeftBytesL / BYTES_PER_PIXEL ));
    } else {
        ucPixelsInLastBlockL = (unsigned char) ( ulMemLeftLinesL * PIXEL_PER_MEM_LINE );
    }

    /* 16 * 4 = 64 - (number of pixels in the last block)) */
    ucShiftsL = ( BLOCK_MEM_SIZE * PIXEL_PER_MEM_LINE ) - ucPixelsInLastBlockL;

    /* WARNING: Verify the memory allocation (endianess) */
    pxNfeeL->xCommon.ucPaddingMask.ullWord = (unsigned long long)(0xFFFFFFFFFFFFFFFF << ucShiftsL);

    /* Number of block is te same as the number of line masks in the memory */
    pxNfeeL->xCommon.usiNTotalBlocks = ulMaskMemLinesL;


    /* Set the addr for every CCD of the FEE, left and right sides */
	ulLastOffset = pxNfeeL->xMemMap.ulOffsetRoot + RESERVED_FEE_X + RESERVED_HALF_CCD_X; //todo: Tiago WARNING DLR modification
	ulStepHalfCCD = RESERVED_HALF_CCD_X + pxNfeeL->xCommon.usiTotalBytes;
	for ( ucIL = 0; ucIL < 4; ucIL++ ) {
		/* Verify and round the start address to be 256 bits (32 bytes) aligned */
		if (ulLastOffset % 32) {
			/* Address is not aligned, set it to the next aligned address */
			ulLastOffset = ((unsigned long) (ulLastOffset / 32) + 1) * 32;
		}
		pxNfeeL->xMemMap.xAebMemCcd[ ucIL ].xSide[eCcdSideELeft].ulOffsetAddr = ulLastOffset; /*xSide[eCcdSideELeft] == left*/
		ulLastOffset = ulLastOffset + ulStepHalfCCD;
		/* Verify and round the start address to be 256 bits (32 bytes) aligned */
		if (ulLastOffset % 32) {
			/* Address is not aligned, set it to the next aligned address */
			ulLastOffset = ((unsigned long) (ulLastOffset / 32) + 1) * 32;
		}
		pxNfeeL->xMemMap.xAebMemCcd[ ucIL ].xSide[eCcdSideFRight].ulOffsetAddr = ulLastOffset; /*xSide[eCcdSideFRight] == right*/
		ulLastOffset = ulLastOffset + ulStepHalfCCD;
	}

}

/* This function will provide updated value for:
 * - unsigned long ulStartAddrTrans;
   - unsigned long ulEndAddrTrans;
 */
bool bMemNewLimits( TFFee *pxNfeeL, unsigned short int usiVStart, unsigned short int usiVEnd ) {
	bool bSucess = FALSE;

	/* Verify the limits */
	if ( usiVEnd > (pxNfeeL->xCcdInfo.usiHeight + pxNfeeL->xCcdInfo.usiOLN) )
		return bSucess;

	/* Verify is start > end*/
	if ( usiVStart >= usiVEnd )
		return bSucess;



	/* Need implementation*/
	bSucess = TRUE;
	return bSucess;

}




/* Update the memory mapping for the FEE due to the CCD informations */
void vResetMemCCDFEE( TFFee *pxNfeeL ) {
	unsigned char ucIL = 0;

    for ( ucIL = 0; ucIL < 4; ucIL++ ) {
        pxNfeeL->xMemMap.xAebMemCcd[ ucIL ].xSide[eCcdSideELeft].ulAddrI = 0;
        pxNfeeL->xMemMap.xAebMemCcd[ ucIL ].xSide[eCcdSideELeft].ulBlockI = 0;
        pxNfeeL->xMemMap.xAebMemCcd[ ucIL ].xSide[eCcdSideFRight].ulAddrI = 0;
        pxNfeeL->xMemMap.xAebMemCcd[ ucIL ].xSide[eCcdSideFRight].ulBlockI = 0;
    }
}
