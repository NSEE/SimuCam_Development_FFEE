/*
 * ffee.c
 *
 *  Created on: 27 de jun de 2020
 *      Author: Tiago-note
 */

#include "ffee.h"


/* Initialize the structure of control of FFEE with the default Configurations */
void vFFeeStructureInit( TFFee *pxFfeeL, unsigned char ucIdFFEE ) {
    unsigned char ucIL = 0;

    /* FFEE id [0..1] */
    pxFfeeL->ucId = ucIdFFEE;

    /* Load the default values of the CCDs regarding pixels configuration */
    vCCDLoadDefaultValues(&pxFfeeL->xCcdInfo);

    /* Update the values of memory mapping for this FEE */
    vUpdateMemMapFEE(pxFfeeL);

    /* Initilizing control variables */
    pxFfeeL->xControl.bEnabled = TRUE;
    pxFfeeL->xControl.bChannelEnable = FALSE;
    pxFfeeL->xControl.bSimulating = FALSE;
    pxFfeeL->xControl.bWatingSync = FALSE;
    pxFfeeL->xControl.bEchoing = FALSE;
    pxFfeeL->xControl.bLogging = FALSE;
    pxFfeeL->xControl.bTransientMode = FALSE;
    /* The default side is left */
    pxFfeeL->xControl.xDeb.ucTimeCode = 0;
    pxFfeeL->xControl.xDeb.ucTimeCodeSpwChannel = 0;
    pxFfeeL->xControl.xDeb.ucRmapSpwChannel = 0;

    /* The FFEE initialize in the Config mode by default */
    pxFfeeL->xControl.xDeb.eState = sInit;
    pxFfeeL->xControl.xDeb.eLastMode = sInit;
    pxFfeeL->xControl.xDeb.eMode = sInit;
    pxFfeeL->xControl.xDeb.eNextMode = sInit;

    pxFfeeL->xControl.xDeb.eDebRealMode = eDebRealStOff;

    pxFfeeL->xControl.xDeb.eDataSource = dsPattern;

    /*  todo: This function supposed to load the values from a SD Card in the future, for now it will load
        hard coded values */

    /* 4 AEBs */
    for (ucIL = 0; ucIL < N_OF_CCD; ucIL++) {
    	pxFfeeL->xControl.xAeb[ucIL].bSwitchedOn = FALSE;

    	pxFfeeL->ucSPWId[ ucIL + ucIdFFEE*N_OF_CCD] = (unsigned char)xDefaultsCH.ucFEEtoChanell[ ucIL + ucIdFFEE*N_OF_CCD ];

        /* Initialize the structs of the Channel, Double Buffer, RMAP and Data packet */
        if ( FALSE == bCommInitCh(&pxFfeeL->xChannel[ucIL + ucIdFFEE*N_OF_CCD ], pxFfeeL->ucSPWId[ ucIL + ucIdFFEE*N_OF_CCD ] )) {
    		#if DEBUG_ON
        	if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
    			fprintf(fp, "\n CRITICAL! Can't Initialized SPW Channel %i \n", pxFfeeL->ucId);
        	}
    		#endif
        }

        if ( bCommSetGlobalIrqEn( TRUE, pxFfeeL->ucSPWId[ ucIL + ucIdFFEE*N_OF_CCD ] ) == FALSE ) {
    		#if DEBUG_ON
        	if ( xDefaults.ucDebugLevel <= dlCriticalOnly ) {
    			fprintf(fp, "\n CRITICAL! Can't Enable global interrupt for the channel %i \n", pxFfeeL->ucId);
        	}
    		#endif
        }

		bDpktGetPixelDelay(&pxFfeeL->xChannel[ucIL].xDataPacket);
		pxFfeeL->xChannel[ucIL].xDataPacket.xDpktPixelDelay.uliStartDelay = uliPxDelayCalcPeriodMs(xDefaults.ulStartDelay);
		pxFfeeL->xChannel[ucIL].xDataPacket.xDpktPixelDelay.uliSkipDelay = uliPxDelayCalcPeriodNs(xDefaults.ulSkipDelay);
		pxFfeeL->xChannel[ucIL].xDataPacket.xDpktPixelDelay.uliLineDelay = uliPxDelayCalcPeriodNs(xDefaults.ulLineDelay);
		pxFfeeL->xChannel[ucIL].xDataPacket.xDpktPixelDelay.uliAdcDelay = uliPxDelayCalcPeriodNs(xDefaults.ulADCPixelDelay);
		bDpktSetPixelDelay(&pxFfeeL->xChannel[ucIL].xDataPacket);

		/* Copy to control what should be applied in the master Sync - FullImage */
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.bEnabled = FALSE;
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.bMissingData = FALSE;
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.bMissingPkts = FALSE;
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.bTxDisabled = FALSE;
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.ucFrameNum = 0;
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiDataCnt = 0;
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiNRepeat = 0;
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiSequenceCnt = 0;

		/* Copy to control what should be applied in the master Sync - Windowing */
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.bEnabled = FALSE;
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.bMissingData = FALSE;
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.bMissingPkts = FALSE;
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.bTxDisabled = FALSE;
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.ucFrameNum = 0;
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.usiDataCnt = 0;
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.usiNRepeat = 0;
		pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlWin.usiSequenceCnt = 0;

		bDpktGetTransmissionErrInj(&pxFfeeL->xChannel[ucIL].xDataPacket);
		pxFfeeL->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bMissingDataEn = pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.bMissingData;
		pxFfeeL->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bMissingPktsEn = pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.bMissingPkts;
		pxFfeeL->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.bTxDisabledEn = pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.bTxDisabled;
		pxFfeeL->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.ucFrameNum = pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.ucFrameNum;
		pxFfeeL->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiDataCnt = pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiDataCnt;
		pxFfeeL->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiNRepeat = pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiNRepeat;
		pxFfeeL->xChannel[ucIL].xDataPacket.xDpktTransmissionErrInj.usiSequenceCnt = pxFfeeL->xErrorInjControl[ucIL].xErrorSWCtrlFull.usiSequenceCnt;
		bDpktSetTransmissionErrInj(&pxFfeeL->xChannel[ucIL].xDataPacket);

		pxFfeeL->xErrorInjControl[ucIL].xSpacewireErrInj.bDestinationErrorEn = FALSE;
		pxFfeeL->xErrorInjControl[ucIL].xSpacewireErrInj.ucOriginalDestAddr = 0;

		pxFfeeL->xErrorInjControl[ucIL].xDataPktError.ucErrorCnt = 0;
		pxFfeeL->xErrorInjControl[ucIL].xDataPktError.bStartErrorInj = FALSE;

		pxFfeeL->xErrorInjControl[ucIL].xImgWinContentErr.ucLeftErrorCnt = 0;
		pxFfeeL->xErrorInjControl[ucIL].xImgWinContentErr.ucRightErrorCnt = 0;
		pxFfeeL->xErrorInjControl[ucIL].xImgWinContentErr.bStartLeftErrorInj = FALSE;
		pxFfeeL->xErrorInjControl[ucIL].xImgWinContentErr.bStartRightErrorInj = FALSE;
    }

    for (ucIL = 0; ucIL < 8; ucIL++) {
    	pxFfeeL->xControl.xDeb.ucTxInMode[ucIL] = 0;
    }

}

/* Update the memory mapping for the FEE due to the CCD informations */
void vUpdateMemMapFEE( TFFee *pxFfeeL ) {
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
    pxFfeeL->xMemMap.ulTotalBytes = ( OFFSET_STEP_FEE );

    /* Offset of the FEE in the DDR memory */
    pxFfeeL->xMemMap.ulOffsetRoot = OFFSET_STEP_FEE * pxFfeeL->ucId;

    /* LUT Addrs */
    pxFfeeL->xMemMap.ulLUTAddr = LUT_INITIAL_ADDR + pxFfeeL->xMemMap.ulOffsetRoot;

    /* (HEIGHT + usiOLN)*(usiSPrescanN + usiSOverscanN + usiHalfWidth) */
    ulTotalSizeL =  ( pxFfeeL->xCcdInfo.usiHeight + pxFfeeL->xCcdInfo.usiOLN ) *
                    ( pxFfeeL->xCcdInfo.usiHalfWidth + pxFfeeL->xCcdInfo.usiSOverscanN + pxFfeeL->xCcdInfo.usiSPrescanN );

    /* Total size in Bytes of a half CCD */
    pxFfeeL->xCommon.usiTotalBytes = ulTotalSizeL * BYTES_PER_PIXEL;

    /* Total of Memory lines (64 bits memory) */
    ulMemLinesL = (unsigned long) pxFfeeL->xCommon.usiTotalBytes / BYTES_PER_MEM_LINE;
    ulMemLeftBytesL = pxFfeeL->xCommon.usiTotalBytes % BYTES_PER_MEM_LINE;   /* Word memory Alignment check: how much bytes left not align in the last word of the memory */
    if ( ulMemLeftBytesL > 0 ) {
        ulMemLinesL = ulMemLinesL + 1;
        pxFfeeL->xCommon.usiTotalBytes = pxFfeeL->xCommon.usiTotalBytes - ulMemLeftBytesL + BYTES_PER_MEM_LINE; /* Add a full line, after will be filled with zero padding */
        pxFfeeL->xCommon.ucPaddingBytes = BYTES_PER_MEM_LINE - ulMemLeftBytesL;
    } else {
        pxFfeeL->xCommon.ucPaddingBytes = 0;
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

    pxFfeeL->xCommon.usiTotalBytes = ulTotalMemLinesL * BYTES_PER_MEM_LINE;


    /* Calculating how is the final mask with zero padding */
    if ( ulMemLeftBytesL >= 1 ) {
        ucPixelsInLastBlockL = (unsigned char) (( ulMemLeftLinesL * PIXEL_PER_MEM_LINE ) + (unsigned int) ( ulMemLeftBytesL / BYTES_PER_PIXEL ));
    } else {
        ucPixelsInLastBlockL = (unsigned char) ( ulMemLeftLinesL * PIXEL_PER_MEM_LINE );
    }

    /* 16 * 4 = 64 - (number of pixels in the last block)) */
    ucShiftsL = ( BLOCK_MEM_SIZE * PIXEL_PER_MEM_LINE ) - ucPixelsInLastBlockL;

    /* WARNING: Verify the memory allocation (endianess) */
    pxFfeeL->xCommon.ucPaddingMask.ullWord = (unsigned long long)(0xFFFFFFFFFFFFFFFF << ucShiftsL);

    /* Number of block is te same as the number of line masks in the memory */
    pxFfeeL->xCommon.usiNTotalBlocks = ulMaskMemLinesL;


    /* Set the addr for every CCD of the FEE, left and right sides */
	ulLastOffset = pxFfeeL->xMemMap.ulOffsetRoot + RESERVED_FEE_X + RESERVED_HALF_CCD_X; //todo: Tiago WARNING DLR modification
	ulStepHalfCCD = RESERVED_HALF_CCD_X + pxFfeeL->xCommon.usiTotalBytes;
	for ( ucIL = 0; ucIL < 4; ucIL++ ) {
		/* Verify and round the start address to be 256 bits (32 bytes) aligned */
		if (ulLastOffset % 32) {
			/* Address is not aligned, set it to the next aligned address */
			ulLastOffset = ((unsigned long) (ulLastOffset / 32) + 1) * 32;
		}
		pxFfeeL->xMemMap.xAebMemCcd[ ucIL ].xSide[eCcdSideELeft].ulOffsetAddr = ulLastOffset; /*xSide[eCcdSideELeft] == left*/
		ulLastOffset = ulLastOffset + ulStepHalfCCD;
		/* Verify and round the start address to be 256 bits (32 bytes) aligned */
		if (ulLastOffset % 32) {
			/* Address is not aligned, set it to the next aligned address */
			ulLastOffset = ((unsigned long) (ulLastOffset / 32) + 1) * 32;
		}
		pxFfeeL->xMemMap.xAebMemCcd[ ucIL ].xSide[eCcdSideFRight].ulOffsetAddr = ulLastOffset; /*xSide[eCcdSideFRight] == right*/
		ulLastOffset = ulLastOffset + ulStepHalfCCD;
	}

}

/* This function will provide updated value for:
 * - unsigned long ulStartAddrTrans;
   - unsigned long ulEndAddrTrans;
 */
bool bMemNewLimits( TFFee *pxFfeeL, unsigned short int usiVStart, unsigned short int usiVEnd ) {
	bool bSucess = FALSE;

	/* Verify the limits */
	if ( usiVEnd > (pxFfeeL->xCcdInfo.usiHeight + pxFfeeL->xCcdInfo.usiOLN) )
		return bSucess;

	/* Verify is start > end*/
	if ( usiVStart >= usiVEnd )
		return bSucess;



	/* Need implementation*/
	bSucess = TRUE;
	return bSucess;

}




/* Update the memory mapping for the FEE due to the CCD informations */
void vResetMemCCDFEE( TFFee *pxFfeeL ) {
	unsigned char ucIL = 0;

    for ( ucIL = 0; ucIL < 4; ucIL++ ) {
        pxFfeeL->xMemMap.xAebMemCcd[ ucIL ].xSide[eCcdSideELeft].ulAddrI = 0;
        pxFfeeL->xMemMap.xAebMemCcd[ ucIL ].xSide[eCcdSideELeft].ulBlockI = 0;
        pxFfeeL->xMemMap.xAebMemCcd[ ucIL ].xSide[eCcdSideFRight].ulAddrI = 0;
        pxFfeeL->xMemMap.xAebMemCcd[ ucIL ].xSide[eCcdSideFRight].ulBlockI = 0;
    }
}
