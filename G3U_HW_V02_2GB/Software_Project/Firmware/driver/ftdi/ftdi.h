/*
 * ftdi.h
 *
 *  Created on: 5 de set de 2019
 *      Author: rfranca
 */

#ifndef DRIVER_FTDI_FTDI_H_
#define DRIVER_FTDI_FTDI_H_

#include "../../simucam_definitions.h"
#include "../../utils/queue_commands_list.h"
#include "../../utils/meb.h"
#include "../../utils/communication_configs.h"
#include "../../rtos/tasks_configurations.h"

//! [constants definition]
#define FTDI_RX_BUFFER_IRQ               2
#define FTDI_TX_BUFFER_IRQ               3
#define FTDI_MODULE_BASE_ADDR            FTDI_UMFT601A_MODULE_BASE

#define FTDI_TRANSFER_MIN_BYTES          (alt_u32)32
#define FTDI_TRANSFER_MAX_BYTES          (alt_u32)67108864
#define FTDI_DATA_ACCESS_WIDTH_BYTES     (alt_u32)32
#define FTDI_DATA_TRANSFER_SIZE_MASK     (alt_u32)0xFFFFFFE0

#define FTDI_WIN_AREA_WINDOING_SIZE      512
#define FTDI_WIN_AREA_PAYLOAD_SIZE       8388608

#define FTDI_MAX_HCCD_IMG_WIDTH          2295
#define FTDI_MAX_HCCD_IMG_HEIGHT         4560

/* Timeout scale is 0.5 ms. Timeout = 2000 = 1s */
#define FTDI_HALFCCD_REQ_TIMEOUT         2000
#define FTDI_LUT_TRANS_TIMEOUT           2000
#define FTDI_IMGT_RCPT_TIMEOUT           2000

#define FTDI_IMGT_FEE_QTD                6
#define FTDI_IMGT_CCD_QTD                4
#define FTDI_IMGT_SIDE_QTD               2
#define FTDI_IMGT_MEMORY_QTD             2

//! [constants definition]

//! [public module structs definition]

/* FTDI Module Control Register Struct */
typedef struct FtdiFtdiModuleControl {
	bool bModuleStart; /* Stop Module Operation */
	bool bModuleStop; /* Start Module Operation */
	bool bModuleClear; /* Clear Module Memories */
} TFtdiFtdiModuleControl;

/* FTDI IRQ Control Register Struct */
typedef struct FtdiFtdiIrqControl {
	bool bFtdiGlobalIrqEn; /* FTDI Global IRQ Enable */
} TFtdiFtdiIrqControl;

/* FTDI Rx IRQ Control Register Struct */
typedef struct FtdiRxIrqControl {
	bool bRxHccdReceivedIrqEn; /* Rx Half-CCD Received IRQ Flag */
	bool bRxHccdCommErrIrqEn; /* Rx Half-CCD Communication Error IRQ Enable */
	bool bRxPatchRcptErrIrqEn; /* Rx Patch Reception Error IRQ Enable */
} TFtdiRxIrqControl;

/* FTDI Rx IRQ Flag Register Struct */
typedef struct FtdiRxIrqFlag {
	bool bRxHccdReceivedIrqFlag; /* Rx Half-CCD Received IRQ Flag */
	bool bRxHccdCommErrIrqFlag; /* Rx Half-CCD Communication Error IRQ Flag */
	bool bRxPatchRcptErrIrqFlag; /* Rx Patch Reception Error IRQ Flag */
} TFtdiRxIrqFlag;

/* FTDI Rx IRQ Flag Clear Register Struct */
typedef struct FtdiRxIrqFlagClr {
	bool bRxHccdReceivedIrqFlagClr; /* Rx Half-CCD Received IRQ Flag Clear */
	bool bRxHccdCommErrIrqFlagClr; /* Rx Half-CCD Communication Error IRQ Flag Clear */
	bool bRxPatchRcptErrIrqFlagClr; /* Rx Patch Reception Error IRQ Flag Clear */
} TFtdiRxIrqFlagClr;

/* FTDI Tx IRQ Control Register Struct */
typedef struct FtdiTxIrqControl {
	bool bTxLutFinishedIrqEn; /* Tx LUT Finished Transmission IRQ Enable */
	bool bTxLutCommErrIrqEn; /* Tx LUT Communication Error IRQ Enable */
} TFtdiTxIrqControl;

/* FTDI Tx IRQ Flag Register Struct */
typedef struct FtdiTxIrqFlag {
	bool bTxLutFinishedIrqFlag; /* Tx LUT Finished Transmission IRQ Flag */
	bool bTxLutCommErrIrqFlag; /* Tx LUT Communication Error IRQ Flag */
} TFtdiTxIrqFlag;

/* FTDI Tx IRQ Flag Clear Register Struct */
typedef struct FtdiTxIrqFlagClr {
	bool bTxLutFinishedIrqFlagClr; /* Tx LUT Finished Transmission IRQ Flag Clear */
	bool bTxLutCommErrIrqFlagClr; /* Tx LUT Communication Error IRQ Flag Clear */
} TFtdiTxIrqFlagClr;

/* FTDI Half-CCD Request Control Register Struct */
typedef struct FtdiHalfCcdReqControl {
	alt_u32 usiHalfCcdReqTimeout; /* Half-CCD Request Timeout */
	alt_u32 ucHalfCcdFeeNumber; /* Half-CCD FEE Number */
	alt_u32 ucHalfCcdCcdNumber; /* Half-CCD CCD Number */
	alt_u32 ucHalfCcdCcdSide; /* Half-CCD CCD Side */
	alt_u32 usiHalfCcdCcdHeight; /* Half-CCD CCD Height */
	alt_u32 usiHalfCcdCcdWidth; /* Half-CCD CCD Width */
	alt_u32 usiHalfCcdExpNumber; /* Half-CCD Exposure Number */
	bool bRequestHalfCcd; /* Request Half-CCD */
	bool bAbortHalfCcdReq; /* Abort Half-CCD Request */
	bool bRstHalfCcdController; /* Reset Half-CCD Controller */
} TFtdiHalfCcdReqControl;

/* FTDI Half-CCD Reply Status Register Struct */
typedef struct FtdiHalfCcdReplyStatus {
	alt_u32 ucHalfCcdFeeNumber; /* Half-CCD FEE Number */
	alt_u32 ucHalfCcdCcdNumber; /* Half-CCD CCD Number */
	alt_u32 ucHalfCcdCcdSide; /* Half-CCD CCD Side */
	alt_u32 usiHalfCcdCcdHeight; /* Half-CCD CCD Height */
	alt_u32 usiHalfCcdCcdWidth; /* Half-CCD CCD Width */
	alt_u32 usiHalfCcdExpNumber; /* Half-CCD Exposure Number */
	alt_u32 uliHalfCcdImgLengthBytes; /* Half-CCD Image Length [Bytes] */
	bool bHalfCcdReceived; /* Half-CCD Received */
	bool bHalfCcdControllerBusy; /* Half-CCD Controller Busy */
	bool bHalfCcdLastRxBuff; /* Half-CCD Last Rx Buffer */
} TFtdiHalfCcdReplyStatus;

/* FTDI LUT Transmission Control Register Struct */
typedef struct FtdiLutTransControl {
	alt_u32 ucLutFeeNumber; /* LUT FEE Number */
	alt_u32 ucLutCcdNumber; /* LUT CCD Number */
	alt_u32 ucLutCcdSide; /* LUT CCD Side */
	alt_u32 usiLutCcdHeight; /* LUT CCD Height */
	alt_u32 usiLutCcdWidth; /* LUT CCD Width */
	alt_u32 usiLutExpNumber; /* LUT Exposure Number */
	alt_u32 uliLutLengthBytes; /* LUT Length [Bytes] */
	alt_u32 usiLutTransTimeout; /* LUT Request Timeout */
	bool bInvert16bWords; /* Invert LUT 16-bits Words */
	bool bTransmitLut; /* Transmit LUT */
	bool bAbortLutTrans; /* Abort LUT Transmission */
	bool bRstLutController; /* Reset LUT Controller */
} TFtdiLutTransControl;

/* FTDI LUT Transmission Status Register Struct */
typedef struct FtdiLutTransStatus {
	bool bLutTransmitted; /* LUT Transmitted */
	bool bLutControllerBusy; /* LUT Controller Busy */
} TFtdiLutTransStatus;

/* FTDI Payload Delay Register Struct */
typedef struct FtdiPayloadDelay {
	alt_u32 usiRxPayRdQqwordDly; /* Rx Payload Reader Qqword Delay */
	alt_u32 usiTxPayWrQqwordDly; /* Tx Payload Writer Qqword Delay */
} TFtdiPayloadDelay;

/* FTDI Tx Data Control Register Struct */
typedef struct FtdiTxDataControl {
	alt_u32 uliTxRdInitAddrHighDword; /* Tx Initial Read Address [High Dword] */
	alt_u32 uliTxRdInitAddrLowDword; /* Tx Initial Read Address [Low Dword] */
	alt_u32 uliTxRdDataLenghtBytes; /* Tx Read Data Length [Bytes] */
	bool bTxRdStart; /* Tx Data Read Start */
	bool bTxRdReset; /* Tx Data Read Reset */
} TFtdiTxDataControl;

/* FTDI Tx Data Status Register Struct */
typedef struct FtdiTxDataStatus {
	bool bTxRdBusy; /* Tx Data Read Busy */
} TFtdiTxDataStatus;

/* FTDI Rx Data Control Register Struct */
typedef struct FtdiRxDataControl {
	alt_u32 uliRxWrInitAddrHighDword; /* Rx Initial Write Address [High Dword] */
	alt_u32 uliRxWrInitAddrLowDword; /* Rx Initial Write Address [Low Dword] */
	alt_u32 uliRxWrDataLenghtBytes; /* Rx Write Data Length [Bytes] */
	bool bRxWrStart; /* Rx Data Write Start */
	bool bRxWrReset; /* Rx Data Write Reset */
} TFtdiRxDataControl;

/* FTDI Rx Data Status Register Struct */
typedef struct FtdiRxDataStatus {
	bool bRxWrBusy; /* Rx Data Write Busy */
} TFtdiRxDataStatus;

/* FTDI LUT CCD1 Windowing Configuration Struct */
typedef struct FtdiLutCcd1WindCfg {
	alt_u32 uliCcd1WindowListPrt; /* CCD1 Window List Pointer */
	alt_u32 uliCcd1PacketOrderListPrt; /* CCD1 Packet Order List Pointer */
	alt_u32 uliCcd1WindowListLength; /* CCD1 Window List Length */
	alt_u32 uliCcd1WindowsSizeX; /* CCD1 Windows Size X */
	alt_u32 uliCcd1WindowsSizeY; /* CCD1 Windows Size Y */
	alt_u32 uliCcd1LastEPacket; /* CCD1 Last E Packet */
	alt_u32 uliCcd1LastFPacket; /* CCD1 Last F Packet */
} TFtdiLutCcd1WindCfg;

/* FTDI LUT CCD2 Windowing Configuration Struct */
typedef struct FtdiLutCcd2WindCfg {
	alt_u32 uliCcd2WindowListPrt; /* CCD2 Window List Pointer */
	alt_u32 uliCcd2PacketOrderListPrt; /* CCD2 Packet Order List Pointer */
	alt_u32 uliCcd2WindowListLength; /* CCD2 Window List Length */
	alt_u32 uliCcd2WindowsSizeX; /* CCD2 Windows Size X */
	alt_u32 uliCcd2WindowsSizeY; /* CCD2 Windows Size Y */
	alt_u32 uliCcd2LastEPacket; /* CCD2 Last E Packet */
	alt_u32 uliCcd2LastFPacket; /* CCD2 Last F Packet */
} TFtdiLutCcd2WindCfg;

/* FTDI LUT CCD3 Windowing Configuration Struct */
typedef struct FtdiLutCcd3WindCfg {
	alt_u32 uliCcd3WindowListPrt; /* CCD3 Window List Pointer */
	alt_u32 uliCcd3PacketOrderListPrt; /* CCD3 Packet Order List Pointer */
	alt_u32 uliCcd3WindowListLength; /* CCD3 Window List Length */
	alt_u32 uliCcd3WindowsSizeX; /* CCD3 Windows Size X */
	alt_u32 uliCcd3WindowsSizeY; /* CCD3 Windows Size Y */
	alt_u32 uliCcd3LastEPacket; /* CCD3 Last E Packet */
	alt_u32 uliCcd3LastFPacket; /* CCD3 Last F Packet */
} TFtdiLutCcd3WindCfg;

/* FTDI LUT CCD4 Windowing Configuration Struct */
typedef struct FtdiLutCcd4WindCfg {
	alt_u32 uliCcd4WindowListPrt; /* CCD4 Window List Pointer */
	alt_u32 uliCcd4PacketOrderListPrt; /* CCD4 Packet Order List Pointer */
	alt_u32 uliCcd4WindowListLength; /* CCD4 Window List Length */
	alt_u32 uliCcd4WindowsSizeX; /* CCD4 Windows Size X */
	alt_u32 uliCcd4WindowsSizeY; /* CCD4 Windows Size Y */
	alt_u32 uliCcd4LastEPacket; /* CCD4 Last E Packet */
	alt_u32 uliCcd4LastFPacket; /* CCD4 Last F Packet */
} TFtdiLutCcd4WindCfg;

/* FTDI Rx Communication Error Register Struct */
typedef struct FtdiRxCommError {
	bool bRxCommErrState; /* Rx Communication Error State */
	alt_u32 usiRxCommErrCode; /* Rx Communication Error Code */
	bool bHalfCcdReqNackErr; /* Half-CCD Request Nack Error */
	bool bHalfCcdReplyHeadCrcErr; /* Half-CCD Reply Wrong Header CRC Error */
	bool bHalfCcdReplyHeadEohErr; /* Half-CCD Reply End of Header Error */
	bool bHalfCcdReplyPayCrcErr; /* Half-CCD Reply Wrong Payload CRC Error */
	bool bHalfCcdReplyPayEopErr; /* Half-CCD Reply End of Payload Error */
	bool bHalfCcdReqMaxTriesErr; /* Half-CCD Request Maximum Tries Error */
	bool bHalfCcdReplyCcdSizeErr; /* Half-CCD Request CCD Size Error */
	bool bHalfCcdReqTimeoutErr; /* Half-CCD Request Timeout Error */
} TFtdiRxCommError;

/* FTDI Tx LUT Communication Error Register Struct */
typedef struct FtdiTxCommError {
	bool bTxLutCommErrState; /* Tx LUT Communication Error State */
	alt_u32 usiTxLutCommErrCode; /* Tx LUT Communication Error Code */
	bool bLutTransmitNackErr; /* LUT Transmit NACK Error */
	bool bLutReplyHeadCrcErr; /* LUT Reply Wrong Header CRC Error */
	bool bLutReplyHeadEohErr; /* LUT Reply End of Header Error */
	bool bLutTransMaxTriesErr; /* LUT Transmission Maximum Tries Error */
	bool bLutPayloadNackErr; /* LUT Payload NACK Error */
	bool bLutTransTimeoutErr; /* LUT Transmission Timeout Error */
} TFtdiTxCommError;

/* FTDI Rx Buffer Status Register Struct */
typedef struct FtdiRxBufferStatus {
	bool bRxBuffRdable; /* Rx Buffer Readable */
	bool bRxBuffEmpty; /* Rx Buffer Empty */
	alt_u32 usiRxBuffUsedBytes; /* Rx Buffer Used [Bytes] */
	bool bRxBuffFull; /* Rx Buffer Full */
} TFtdiRxBufferStatus;

/* FTDI Tx Buffer Status Register Struct */
typedef struct FtdiTxBufferStatus {
	bool bTxBuffWrable; /* Tx Buffer Writeable */
	bool bTxBuffEmpty; /* Tx Buffer Empty */
	alt_u32 usiTxBuffUsedBytes; /* Tx Buffer Used [Bytes] */
	bool bTxBuffFull; /* Tx Buffer Full */
} TFtdiTxBufferStatus;

/* FTDI Patch Reception Control Register Struct */
typedef struct PatchRcptControl {
	alt_u32 usiTimeout; /* Patch Reception Timeout */
	bool bEnable; /* Patch Reception Enable */
	bool bDiscard; /* Patch Reception Discard */
	bool bInvPixelsByteOrder; /* Patch Reception Invert Pixels Byte Order */
} TPatchRcptControl;

/* FTDI Patch Reception Status Register Struct */
typedef struct PatchRcptStatus {
	bool bBusy; /* Patch Reception Busy */
} TPatchRcptStatus;

/* FTDI Patch Reception Config Register Struct */
typedef struct PatchRcptConfig {
	alt_u32 usiFeesCcdsHalfwidthPixels; /* FEEs CCDs Half-Width Pixels Size */
	alt_u32 usiFeesCcdsHeightPixels; /* FEEs CCDs Height Pixels Size */
	alt_u32 uliFee0Ccd0LeftInitAddrHighDword; /* FEE 0 CCD 0 Left Initial Address [High Dword] */
	alt_u32 uliFee0Ccd0LeftInitAddrLowDword; /* FEE 0 CCD 0 Left Initial Address [Low Dword] */
	alt_u32 uliFee0Ccd0RightInitAddrHighDword; /* FEE 0 CCD 0 Right Initial Address [High Dword] */
	alt_u32 uliFee0Ccd0RightInitAddrLowDword; /* FEE 0 CCD 0 Right Initial Address [Low Dword] */
	alt_u32 uliFee0Ccd1LeftInitAddrHighDword; /* FEE 0 CCD 1 Left Initial Address [High Dword] */
	alt_u32 uliFee0Ccd1LeftInitAddrLowDword; /* FEE 0 CCD 1 Left Initial Address [Low Dword] */
	alt_u32 uliFee0Ccd1RightInitAddrHighDword; /* FEE 0 CCD 1 Right Initial Address [High Dword] */
	alt_u32 uliFee0Ccd1RightInitAddrLowDword; /* FEE 0 CCD 1 Right Initial Address [Low Dword] */
	alt_u32 uliFee0Ccd2LeftInitAddrHighDword; /* FEE 0 CCD 2 Left Initial Address [High Dword] */
	alt_u32 uliFee0Ccd2LeftInitAddrLowDword; /* FEE 0 CCD 2 Left Initial Address [Low Dword] */
	alt_u32 uliFee0Ccd2RightInitAddrHighDword; /* FEE 0 CCD 2 Right Initial Address [High Dword] */
	alt_u32 uliFee0Ccd2RightInitAddrLowDword; /* FEE 0 CCD 2 Right Initial Address [Low Dword] */
	alt_u32 uliFee0Ccd3LeftInitAddrHighDword; /* FEE 0 CCD 3 Left Initial Address [High Dword] */
	alt_u32 uliFee0Ccd3LeftInitAddrLowDword; /* FEE 0 CCD 3 Left Initial Address [Low Dword] */
	alt_u32 uliFee0Ccd3RightInitAddrHighDword; /* FEE 0 CCD 3 Right Initial Address [High Dword] */
	alt_u32 uliFee0Ccd3RightInitAddrLowDword; /* FEE 0 CCD 3 Right Initial Address [Low Dword] */
	alt_u32 uliFee1Ccd0LeftInitAddrHighDword; /* FEE 1 CCD 0 Left Initial Address [High Dword] */
	alt_u32 uliFee1Ccd0LeftInitAddrLowDword; /* FEE 1 CCD 0 Left Initial Address [Low Dword] */
	alt_u32 uliFee1Ccd0RightInitAddrHighDword; /* FEE 1 CCD 0 Right Initial Address [High Dword] */
	alt_u32 uliFee1Ccd0RightInitAddrLowDword; /* FEE 1 CCD 0 Right Initial Address [Low Dword] */
	alt_u32 uliFee1Ccd1LeftInitAddrHighDword; /* FEE 1 CCD 1 Left Initial Address [High Dword] */
	alt_u32 uliFee1Ccd1LeftInitAddrLowDword; /* FEE 1 CCD 1 Left Initial Address [Low Dword] */
	alt_u32 uliFee1Ccd1RightInitAddrHighDword; /* FEE 1 CCD 1 Right Initial Address [High Dword] */
	alt_u32 uliFee1Ccd1RightInitAddrLowDword; /* FEE 1 CCD 1 Right Initial Address [Low Dword] */
	alt_u32 uliFee1Ccd2LeftInitAddrHighDword; /* FEE 1 CCD 2 Left Initial Address [High Dword] */
	alt_u32 uliFee1Ccd2LeftInitAddrLowDword; /* FEE 1 CCD 2 Left Initial Address [Low Dword] */
	alt_u32 uliFee1Ccd2RightInitAddrHighDword; /* FEE 1 CCD 2 Right Initial Address [High Dword] */
	alt_u32 uliFee1Ccd2RightInitAddrLowDword; /* FEE 1 CCD 2 Right Initial Address [Low Dword] */
	alt_u32 uliFee1Ccd3LeftInitAddrHighDword; /* FEE 1 CCD 3 Left Initial Address [High Dword] */
	alt_u32 uliFee1Ccd3LeftInitAddrLowDword; /* FEE 1 CCD 3 Left Initial Address [Low Dword] */
	alt_u32 uliFee1Ccd3RightInitAddrHighDword; /* FEE 1 CCD 3 Right Initial Address [High Dword] */
	alt_u32 uliFee1Ccd3RightInitAddrLowDword; /* FEE 1 CCD 3 Right Initial Address [Low Dword] */
	alt_u32 uliFee2Ccd0LeftInitAddrHighDword; /* FEE 2 CCD 0 Left Initial Address [High Dword] */
	alt_u32 uliFee2Ccd0LeftInitAddrLowDword; /* FEE 2 CCD 0 Left Initial Address [Low Dword] */
	alt_u32 uliFee2Ccd0RightInitAddrHighDword; /* FEE 2 CCD 0 Right Initial Address [High Dword] */
	alt_u32 uliFee2Ccd0RightInitAddrLowDword; /* FEE 2 CCD 0 Right Initial Address [Low Dword] */
	alt_u32 uliFee2Ccd1LeftInitAddrHighDword; /* FEE 2 CCD 1 Left Initial Address [High Dword] */
	alt_u32 uliFee2Ccd1LeftInitAddrLowDword; /* FEE 2 CCD 1 Left Initial Address [Low Dword] */
	alt_u32 uliFee2Ccd1RightInitAddrHighDword; /* FEE 2 CCD 1 Right Initial Address [High Dword] */
	alt_u32 uliFee2Ccd1RightInitAddrLowDword; /* FEE 2 CCD 1 Right Initial Address [Low Dword] */
	alt_u32 uliFee2Ccd2LeftInitAddrHighDword; /* FEE 2 CCD 2 Left Initial Address [High Dword] */
	alt_u32 uliFee2Ccd2LeftInitAddrLowDword; /* FEE 2 CCD 2 Left Initial Address [Low Dword] */
	alt_u32 uliFee2Ccd2RightInitAddrHighDword; /* FEE 2 CCD 2 Right Initial Address [High Dword] */
	alt_u32 uliFee2Ccd2RightInitAddrLowDword; /* FEE 2 CCD 2 Right Initial Address [Low Dword] */
	alt_u32 uliFee2Ccd3LeftInitAddrHighDword; /* FEE 2 CCD 3 Left Initial Address [High Dword] */
	alt_u32 uliFee2Ccd3LeftInitAddrLowDword; /* FEE 2 CCD 3 Left Initial Address [Low Dword] */
	alt_u32 uliFee2Ccd3RightInitAddrHighDword; /* FEE 2 CCD 3 Right Initial Address [High Dword] */
	alt_u32 uliFee2Ccd3RightInitAddrLowDword; /* FEE 2 CCD 3 Right Initial Address [Low Dword] */
	alt_u32 uliFee3Ccd0LeftInitAddrHighDword; /* FEE 3 CCD 0 Left Initial Address [High Dword] */
	alt_u32 uliFee3Ccd0LeftInitAddrLowDword; /* FEE 3 CCD 0 Left Initial Address [Low Dword] */
	alt_u32 uliFee3Ccd0RightInitAddrHighDword; /* FEE 3 CCD 0 Right Initial Address [High Dword] */
	alt_u32 uliFee3Ccd0RightInitAddrLowDword; /* FEE 3 CCD 0 Right Initial Address [Low Dword] */
	alt_u32 uliFee3Ccd1LeftInitAddrHighDword; /* FEE 3 CCD 1 Left Initial Address [High Dword] */
	alt_u32 uliFee3Ccd1LeftInitAddrLowDword; /* FEE 3 CCD 1 Left Initial Address [Low Dword] */
	alt_u32 uliFee3Ccd1RightInitAddrHighDword; /* FEE 3 CCD 1 Right Initial Address [High Dword] */
	alt_u32 uliFee3Ccd1RightInitAddrLowDword; /* FEE 3 CCD 1 Right Initial Address [Low Dword] */
	alt_u32 uliFee3Ccd2LeftInitAddrHighDword; /* FEE 3 CCD 2 Left Initial Address [High Dword] */
	alt_u32 uliFee3Ccd2LeftInitAddrLowDword; /* FEE 3 CCD 2 Left Initial Address [Low Dword] */
	alt_u32 uliFee3Ccd2RightInitAddrHighDword; /* FEE 3 CCD 2 Right Initial Address [High Dword] */
	alt_u32 uliFee3Ccd2RightInitAddrLowDword; /* FEE 3 CCD 2 Right Initial Address [Low Dword] */
	alt_u32 uliFee3Ccd3LeftInitAddrHighDword; /* FEE 3 CCD 3 Left Initial Address [High Dword] */
	alt_u32 uliFee3Ccd3LeftInitAddrLowDword; /* FEE 3 CCD 3 Left Initial Address [Low Dword] */
	alt_u32 uliFee3Ccd3RightInitAddrHighDword; /* FEE 3 CCD 3 Right Initial Address [High Dword] */
	alt_u32 uliFee3Ccd3RightInitAddrLowDword; /* FEE 3 CCD 3 Right Initial Address [Low Dword] */
	alt_u32 uliFee4Ccd0LeftInitAddrHighDword; /* FEE 4 CCD 0 Left Initial Address [High Dword] */
	alt_u32 uliFee4Ccd0LeftInitAddrLowDword; /* FEE 4 CCD 0 Left Initial Address [Low Dword] */
	alt_u32 uliFee4Ccd0RightInitAddrHighDword; /* FEE 4 CCD 0 Right Initial Address [High Dword] */
	alt_u32 uliFee4Ccd0RightInitAddrLowDword; /* FEE 4 CCD 0 Right Initial Address [Low Dword] */
	alt_u32 uliFee4Ccd1LeftInitAddrHighDword; /* FEE 4 CCD 1 Left Initial Address [High Dword] */
	alt_u32 uliFee4Ccd1LeftInitAddrLowDword; /* FEE 4 CCD 1 Left Initial Address [Low Dword] */
	alt_u32 uliFee4Ccd1RightInitAddrHighDword; /* FEE 4 CCD 1 Right Initial Address [High Dword] */
	alt_u32 uliFee4Ccd1RightInitAddrLowDword; /* FEE 4 CCD 1 Right Initial Address [Low Dword] */
	alt_u32 uliFee4Ccd2LeftInitAddrHighDword; /* FEE 4 CCD 2 Left Initial Address [High Dword] */
	alt_u32 uliFee4Ccd2LeftInitAddrLowDword; /* FEE 4 CCD 2 Left Initial Address [Low Dword] */
	alt_u32 uliFee4Ccd2RightInitAddrHighDword; /* FEE 4 CCD 2 Right Initial Address [High Dword] */
	alt_u32 uliFee4Ccd2RightInitAddrLowDword; /* FEE 4 CCD 2 Right Initial Address [Low Dword] */
	alt_u32 uliFee4Ccd3LeftInitAddrHighDword; /* FEE 4 CCD 3 Left Initial Address [High Dword] */
	alt_u32 uliFee4Ccd3LeftInitAddrLowDword; /* FEE 4 CCD 3 Left Initial Address [Low Dword] */
	alt_u32 uliFee4Ccd3RightInitAddrHighDword; /* FEE 4 CCD 3 Right Initial Address [High Dword] */
	alt_u32 uliFee4Ccd3RightInitAddrLowDword; /* FEE 4 CCD 3 Right Initial Address [Low Dword] */
	alt_u32 uliFee5Ccd0LeftInitAddrHighDword; /* FEE 5 CCD 0 Left Initial Address [High Dword] */
	alt_u32 uliFee5Ccd0LeftInitAddrLowDword; /* FEE 5 CCD 0 Left Initial Address [Low Dword] */
	alt_u32 uliFee5Ccd0RightInitAddrHighDword; /* FEE 5 CCD 0 Right Initial Address [High Dword] */
	alt_u32 uliFee5Ccd0RightInitAddrLowDword; /* FEE 5 CCD 0 Right Initial Address [Low Dword] */
	alt_u32 uliFee5Ccd1LeftInitAddrHighDword; /* FEE 5 CCD 1 Left Initial Address [High Dword] */
	alt_u32 uliFee5Ccd1LeftInitAddrLowDword; /* FEE 5 CCD 1 Left Initial Address [Low Dword] */
	alt_u32 uliFee5Ccd1RightInitAddrHighDword; /* FEE 5 CCD 1 Right Initial Address [High Dword] */
	alt_u32 uliFee5Ccd1RightInitAddrLowDword; /* FEE 5 CCD 1 Right Initial Address [Low Dword] */
	alt_u32 uliFee5Ccd2LeftInitAddrHighDword; /* FEE 5 CCD 2 Left Initial Address [High Dword] */
	alt_u32 uliFee5Ccd2LeftInitAddrLowDword; /* FEE 5 CCD 2 Left Initial Address [Low Dword] */
	alt_u32 uliFee5Ccd2RightInitAddrHighDword; /* FEE 5 CCD 2 Right Initial Address [High Dword] */
	alt_u32 uliFee5Ccd2RightInitAddrLowDword; /* FEE 5 CCD 2 Right Initial Address [Low Dword] */
	alt_u32 uliFee5Ccd3LeftInitAddrHighDword; /* FEE 5 CCD 3 Left Initial Address [High Dword] */
	alt_u32 uliFee5Ccd3LeftInitAddrLowDword; /* FEE 5 CCD 3 Left Initial Address [Low Dword] */
	alt_u32 uliFee5Ccd3RightInitAddrHighDword; /* FEE 5 CCD 3 Right Initial Address [High Dword] */
	alt_u32 uliFee5Ccd3RightInitAddrLowDword; /* FEE 5 CCD 3 Right Initial Address [Low Dword] */
} TPatchRcptConfig;

/* FTDI Patch Reception Error Register Struct */
typedef struct PatchRcptError {
	bool bErrState; /* Patch Reception Error State */
	alt_u32 ucErrCode; /* Patch Reception Error Code */
	bool bNackErr; /* Patch Reception Nack Error */
	bool bWrongHeaderCrcErr; /* Patch Reception Wrong Header CRC Error */
	bool bEndOfHeaderErr; /* Patch Reception End of Header Error */
	bool bWrongPayloadCrcErr; /* Patch Reception Wrong Payload CRC Error */
	bool bEndOfPayloadErr; /* Patch Reception End of Payload Error */
	bool bMaximumTriesErr; /* Patch Reception Maximum Tries Error */
	bool bTimeoutErr; /* Patch Reception Timeout Error */
} TPatchRcptError;

/* General Struct for Registers Access */
typedef struct FtdiModule {
	TFtdiFtdiModuleControl xFtdiFtdiModuleControl;
	TFtdiFtdiIrqControl xFtdiFtdiIrqControl;
	TFtdiRxIrqControl xFtdiRxIrqControl;
	TFtdiRxIrqFlag xFtdiRxIrqFlag;
	TFtdiRxIrqFlagClr xFtdiRxIrqFlagClr;
	TFtdiTxIrqControl xFtdiTxIrqControl;
	TFtdiTxIrqFlag xFtdiTxIrqFlag;
	TFtdiTxIrqFlagClr xFtdiTxIrqFlagClr;
	TFtdiHalfCcdReqControl xFtdiHalfCcdReqControl;
	TFtdiHalfCcdReplyStatus xFtdiHalfCcdReplyStatus;
	TFtdiLutTransControl xFtdiLutTransControl;
	TFtdiLutTransStatus xFtdiLutTransStatus;
	TFtdiPayloadDelay xFtdiPayloadDelay;
	TFtdiTxDataControl xFtdiTxDataControl;
	TFtdiTxDataStatus xFtdiTxDataStatus;
	TFtdiRxDataControl xFtdiRxDataControl;
	TFtdiRxDataStatus xFtdiRxDataStatus;
	TFtdiLutCcd1WindCfg xFtdiLutCcd1WindCfg;
	TFtdiLutCcd2WindCfg xFtdiLutCcd2WindCfg;
	TFtdiLutCcd3WindCfg xFtdiLutCcd3WindCfg;
	TFtdiLutCcd4WindCfg xFtdiLutCcd4WindCfg;
	TFtdiRxCommError xFtdiRxCommError;
	TFtdiTxCommError xFtdiTxCommError;
	TFtdiRxBufferStatus xFtdiRxBufferStatus;
	TFtdiTxBufferStatus xFtdiTxBufferStatus;
	TPatchRcptControl xPatchRcptControl;
	TPatchRcptStatus xPatchRcptStatus;
	TPatchRcptConfig xPatchRcptConfig;
	TPatchRcptError xPatchRcptError;
} TFtdiModule;

//! [public module structs definition]

//! [public function prototypes]

void vFtdiRxIrqHandler(void* pvContext);
void vFtdiTxIrqHandler(void* pvContext);

bool bFtdiRxIrqInit(void);
bool bFtdiTxIrqInit(void);

bool bFtdiRequestHalfCcdImg(alt_u8 ucFee, alt_u8 ucCcdNumber, alt_u8 ucCcdSide, alt_u16 usiExposureNum, alt_u16 usiCcdHalfWidth, alt_u16 usiCcdHeight);
bool bFtdiTransmitLutWinArea(alt_u8 ucFee, alt_u16 usiCcdHalfWidth, alt_u16 usiCcdHeight, alt_u32 uliLutLengthBytes);

void vFtdiResetHalfCcdImg(void);
void vFtdiResetLutWinArea(void);

alt_u8 ucFtdiGetRxErrorCode(void);
alt_u8 ucFtdiGetTxErrorCode(void);

alt_u16 usiFtdiRxBufferUsedBytes(void);
alt_u16 usiFtdiTxBufferUsedBytes(void);

void vFtdiStopModule(void);
void vFtdiStartModule(void);
void vFtdiClearModule(void);
void vFtdiAbortOperation(void);

void vFtdiIrqGlobalEn(bool bEnable);

void vFtdiIrqRxHccdReceivedEn(bool bEnable);
void vFtdiIrqRxHccdCommErrEn(bool bEnable);
void vFtdiIrqRxPatchRcptErrEn(bool bEnable);

void vFtdiIrqTxLutFinishedEn(bool bEnable);
void vFtdiIrqTxLutCommErrEn(bool bEnable);

/*
 * Imagettes functions prototypes:
 */

/* Enable/Disable the Imagettes machine. */
void vFtdiEnableImagettes(bool bEnable);

/* Abort any Imagette receival and clear the Imagettes machine. */
void vFtdiAbortImagettes(void);

/* Set Half-CCD parameters. Need to be called onde in the initialization. */
bool bFtdiSetImagettesParams(alt_u8 ucFee, alt_u8 ucCcdNumber, alt_u8 ucCcdSide, alt_u16 usiCcdHalfWidth, alt_u16 usiCcdHeight, alt_u32 *uliDdrInitialAddr);

/* Swap the memory to be patched with Imagettes. Need to be called every memory swap. */
bool bFtdiSwapImagettesMem(alt_u8 ucDdrMemId);

//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DRIVER_FTDI_FTDI_H_ */
