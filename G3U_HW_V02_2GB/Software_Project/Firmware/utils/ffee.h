/*
 * ffee.h
 *
 *  Created on: 27 de jun de 2020
 *      Author: Tiago-note
 */

#ifndef UTILS_FFEE_H_
#define UTILS_FFEE_H_

#include "../simucam_definitions.h"
#include "ccd.h"
#include "deb.h"
#include "aeb.h"
#include "../driver/comm/comm_channel.h"


/* Meb state is here to Data controller and NFEE controller use the same enum */
typedef enum { sMebInit  = 0, sMebConfig, sMebRun, sMebToConfig, sMebToRun } tSimucamStates;

/* Packet Size in Window Mode: 257 Bytes */
#define FAST_SIZE_BUFFER_WIN	257
/* Packet Size in Full-Image Mode: 4603 Bytes = 2295 * 2 + 11 + 2 (1 Line + Header + CRCs) */
#define FAST_SIZE_BUFFER_FULL	4603

/* Definition of offset for each FEE in the DDR Memory */
/* Worksheet: ccd_logic_math.xlsx */
/* OFFESETs = [ 0, 224907824, 449815648, 674723472, 899631296, 1124539120, 1349446944, 1574354768  ] */
#define OFFSET_STEP_FEE         224907840
#define LUT_SIZE                10485760
#define LUT_INITIAL_ADDR        ( OFFSET_STEP_FEE - LUT_SIZE )
#define RESERVED_FEE_X          1048576
#define RESERVED_HALF_CCD_X     102400

/*  In the memory for each 64 pixels in the memory, that is 16 lines of a 64bits memory, will have 1 line for WindowMask.
    One Block is 17 lines of a 64bits memory = 16 lines of pixels + 1 line for mask */
#define BLOCK_MEM_SIZE          16
#define BLOCK_MASK_MEM_SIZE     1
#define BLOCK_UNITY_SIZE        BLOCK_PIXELS_MEM_SIZE + BLOCK_MASK_MEM_SIZE

/*  For a 64 bits memory the value of bytes per line is 8. For a 32 bits memory the value will be 4*/
#define BYTES_PER_MEM_LINE      8
#define PIXEL_PER_MEM_LINE      (unsigned int)(BYTES_PER_MEM_LINE / BYTES_PER_PIXEL)

/* Number of CCDS per FEE */
#define N_OF_CCD                4


/*For TRAP Mode*/
#define CHARGE_TIME 			0.5 //Seconds

#define DEFAULT_SYNC_TIME 		2.5 //Seconds


 /* Error Injection Control Register Struct */
typedef struct DpktErrorCopy {
	volatile bool bEnabled;		/*Is error injection Enabled?*/
	volatile bool bTxDisabled; /* Error Injection Tx Disabled Enable */
	volatile bool bMissingPkts; /* Error Injection Missing Packets Enable */
	volatile bool bMissingData; /* Error Injection Missing Data Enable */
	volatile alt_u8 ucFrameNum; /* Error Injection Frame Number of Error */
	volatile alt_u16 usiSequenceCnt; /* Error Injection Sequence Counter of Error */
	volatile alt_u16 usiDataCnt; /* Error Injection Data Counter of Error */
	volatile alt_u16 usiNRepeat; /* Error Injection Number of Error Repeats */
} TDpktErrorCopy;


typedef struct FEEMemoryMap{
    unsigned long ulOffsetRoot;     /* Root Addr Ofset of the FEE*/
    unsigned long ulTotalBytes;     /* Total of bytes of the FEE in the memory */
    unsigned long ulLUTAddr;        /* Initial Addr of the Look Up Table */
    TFullCcdMemMap xAebMemCcd[4]; /* Memory map of the four Full CCDs [0..1] (xLeft,xRight) */
} TFEEMemoryMap;

typedef struct DataPktErrorData{
	alt_u16 usiFrameCounter;
	alt_u16 usiSequenceCounter;
	alt_u16 usiFieldId;
	alt_u16 usiFieldValue;
} TDataPktErrorData;

typedef struct DataPktError{
	alt_u8 ucErrorCnt;
	TDataPktErrorData xErrorList[16];
	bool bStartErrorInj;
} TDataPktError;

typedef struct ImgWinContentErrData {
	alt_u16 usiPxColX; /* Pixel Column (x-position) of Left Content Error */
	alt_u16 usiPxRowY; /* Pixel Row (y-position) of Left Content Error */
	alt_u16 usiCountFrames; /* Start Frame of Left Content Error */
	alt_u16 usiFramesActive; /* Stop Frame of Left Content Error */
	alt_u16 usiPxValue; /* Pixel Value of Left Content Error */
} TImgWinContentErrData;

typedef struct ImgWinContentErr{
	alt_u8 ucLeftErrorCnt;
	alt_u8 ucRightErrorCnt;
	TImgWinContentErrData xLeftErrorList[128];
	TImgWinContentErrData xRightErrorList[128];
	bool bStartLeftErrorInj;
	bool bStartRightErrorInj;
} TImgWinContentErr;

typedef struct ErrorControl {
	TDataPktError xDataPktError;
	TDpktErrorCopy xErrorSWCtrlFull;
	TDpktErrorCopy xErrorSWCtrlWin;
	TImgWinContentErr xImgWinContentErr;
} TErrorControl;

typedef struct FeeControl{
    bool bEnabled;
    bool bUsingDMA;
    bool bLogging;                      /* Log the RMAP Packets */
    bool bEchoing;                      /* Echo the RMAP Packets */
    bool bChannelEnable;                /* SPW Channel is enable? */
    bool bSimulating;                   /* Start at any running mode - needs sync */
    bool bWatingSync;
    bool bTransientMode;
    unsigned char *pActualMem;				/* Point to the actual memory in simulation */

    /* AEBs */
    TAeBControl xAeb[N_OF_CCD];

    /* DEB */
    TDebControl xDeb;

    /* Error Control */
    TErrorControl xError[N_OF_CCD];

} TFeeControl;

typedef struct tInMode {
	bool bSent;
	bool bDataOn;
	bool bPattern;
	unsigned char ucAebNumber;
	unsigned char ucSpWChannel;
	unsigned char ucSideCcd;
	unsigned char ucSideSpw;
} TtInMode;


typedef struct NFee {
    unsigned char      ucId;                /* ID of the NFEE instance */
    unsigned char      ucSPWId[N_OF_CCD];   /* ID of the SPW instance For This NFEE Instance */
    TCcdMemDef         xCommon;             /* Common value of memory definitions for the 4 CCds */
    TFEEMemoryMap      xMemMap;             /* Memory map of the NFEE */
    TFeeControl        xControl;            /* Operation Control of the NFEE */
    TCcdInfos          xCcdInfo;            /* Pixel configuration of the NFEE */
    unsigned short int ucTimeCode;
    TCommChannel       xChannel[N_OF_CCD];
} TFFee;

/*Ter um desse para cada ldo do buffer*/
typedef struct AEBTransmission{
	bool bFirstT;
	bool bDmaReturn[2];				/*Two half CCDs-> Left and Right*/
	bool bFinal[2];					/*Two half CCDs-> Left and Right*/
	unsigned long ulAddrIni;		/* (byte) Initial transmission data, calculated after */
	unsigned long ulAddrFinal;
	unsigned long ulTotalBlocks;
	unsigned long ulSMD_MAX_BLOCKS;
	unsigned char ucMemory;
	TCcdMemMap *xCcdMapLocal[2]; 	/*Two half CCDs-> Left and Right*/
} TAEBTransmission;

void vFFeeStructureInit( TFFee *pxNfeeL, unsigned char ucIdFFEE );
void vResetMemCCDFEE( TFFee *pxNfeeL );
void vNFeeStructureInit( TFFee *pxNfeeL, unsigned char ucIdNFEE );
void vUpdateMemMapFEE( TFFee *pxNfeeL );
bool bMemNewLimits( TFFee *pxNfeeL, unsigned short int usiVStart, unsigned short int usiVEnd );
void vResetMemCCDFEE( TFFee *pxNfeeL );

#endif /* UTILS_FFEE_H_ */
