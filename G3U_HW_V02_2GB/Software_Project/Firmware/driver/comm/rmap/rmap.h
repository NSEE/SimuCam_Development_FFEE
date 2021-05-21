/*
 * rmap.h
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#ifndef RMAP_H_
#define RMAP_H_

#include "../comm.h"
#include "../../../utils/queue_commands_list.h"
#include "../../../utils/configs_simucam.h"
#include "../../../utils/error_handler_simucam.h"
#include "../../../simucam_definitions.h"
#include "../../../utils/configs_bind_channel_FEEinst.h"

//! [constants definition]
// address
// bit masks
//! [constants definition]

extern OS_EVENT *xFeeQ[N_OF_FastFEE];
extern OS_EVENT *xLutQ;
//extern OS_EVENT *xWaitSyncQFee[N_OF_NFEE];

//! [public module structs definition]
enum RmapDebOpMode {
	eRmapDebOpModeFullImg     = 0b000, /* DEB Operational Mode 0 : DEB Full-Image Mode */
	eRmapDebOpModeFullImgPatt = 0b001, /* DEB Operational Mode 1 : DEB Full-Image Pattern Mode */
	eRmapDebOpModeWin         = 0b010, /* DEB Operational Mode 2 : DEB Windowing Mode */
	eRmapDebOpModeWinPatt     = 0b011, /* DEB Operational Mode 3 : DEB Windowing Pattern Mode */
	eRmapDebOpModeReserved0   = 0b100, /* DEB Operational Mode 4 : Reserved */
	eRmapDebOpModeReserved1   = 0b101, /* DEB Operational Mode 5 : Reserved */
	eRmapDebOpModeStandby     = 0b110, /* DEB Operational Mode 6 : DEB Standby Mode */
	eRmapDebOpModeOn          = 0b111  /* DEB Operational Mode 7 : DEB On Mode */
} ERmapDebOpMode;

enum RmapT7InModSpw4R {
	eRmapT7InModSpw4RNoData0       = 0b000, /* Data source for right Fifo of SpW n°4 : No data */
	eRmapT7InModSpw4RAebDataCcd4F  = 0b001, /* Data source for right Fifo of SpW n°4 : AEB data, CCD4 output F */
	eRmapT7InModSpw4RUnused0       = 0b010, /* Data source for right Fifo of SpW n°4 : Unused */
	eRmapT7InModSpw4RNoData1       = 0b100, /* Data source for right Fifo of SpW n°4 : No data */
	eRmapT7InModSpw4RPattDataCcd4F = 0b101, /* Data source for right Fifo of SpW n°4 : Pattern data, CCD4 output F */
	eRmapT7InModSpw4RUnused1       = 0b110, /* Data source for right Fifo of SpW n°4 : Unused */
	eRmapT7InModSpw4RUnused2       = 0b111, /* Data source for right Fifo of SpW n°4 : Unused */
} ERmapT7InModSpw4R;

enum RmapT6InModSpw4L {
	eRmapT6InModSpw4LNoData0       = 0b000, /* Data source for left Fifo of SpW n°4 : No data */
	eRmapT6InModSpw4LAebDataCcd4E  = 0b001, /* Data source for left Fifo of SpW n°4 : AEB data, CCD4 output E */
	eRmapT6InModSpw4LAebDataCcd3F  = 0b010, /* Data source for left Fifo of SpW n°4 : AEB data, CCD3 output F */
	eRmapT6InModSpw4LNoData1       = 0b100, /* Data source for left Fifo of SpW n°4 : No data */
	eRmapT6InModSpw4LPattDataCcd4E = 0b101, /* Data source for left Fifo of SpW n°4 : Pattern data, CCD4 output E */
	eRmapT6InModSpw4LPattDataCcd3F = 0b110, /* Data source for left Fifo of SpW n°4 : Pattern data, CCD3 output F */
	eRmapT6InModSpw4LUnused        = 0b111, /* Data source for left Fifo of SpW n°4 : Unused */
} ERmapT6InModSpw4L;

enum RmapT5InModSpw3R {
	eRmapT5InModSpw3RNoData0       = 0b000, /* Data source for right Fifo of SpW n°3 : No data */
	eRmapT5InModSpw3RAebDataCcd3F  = 0b001, /* Data source for right Fifo of SpW n°3 : AEB data, CCD3 output F */
	eRmapT5InModSpw3RAebDataCcd4E  = 0b010, /* Data source for right Fifo of SpW n°3 : AEB data, CCD4 output E */
	eRmapT5InModSpw3RNoData1       = 0b100, /* Data source for right Fifo of SpW n°3 : No data */
	eRmapT5InModSpw3RPattDataCcd3F = 0b101, /* Data source for right Fifo of SpW n°3 : Pattern data, CCD3 output F */
	eRmapT5InModSpw3RPattDataCcd4E = 0b110, /* Data source for right Fifo of SpW n°3 : Pattern data, CCD4 output E */
	eRmapT5InModSpw3RUnused        = 0b111, /* Data source for right Fifo of SpW n°3 : Unused */
} ERmapT5InModSpw3R;

enum RmapT4InModSpw3L {
	eRmapT4InModSpw3LNoData0       = 0b000, /* Data source for left Fifo of SpW n°3 : No data */
	eRmapT4InModSpw3LAebDataCcd3E  = 0b001, /* Data source for left Fifo of SpW n°3 : AEB data, CCD3 output E */
	eRmapT4InModSpw3LUnused0       = 0b010, /* Data source for left Fifo of SpW n°3 : Unused */
	eRmapT4InModSpw3LNoData1       = 0b100, /* Data source for left Fifo of SpW n°3 : No data */
	eRmapT4InModSpw3LPattDataCcd3E = 0b101, /* Data source for left Fifo of SpW n°3 : Pattern data, CCD3 output E */
	eRmapT4InModSpw3LUnused1       = 0b110, /* Data source for left Fifo of SpW n°3 : Unused */
	eRmapT4InModSpw3LUnused2       = 0b111, /* Data source for left Fifo of SpW n°3 : Unused */
} ERmapT4InModSpw3L;

enum RmapT3InModSpw2R {
	eRmapT3InModSpw2RNoData0       = 0b000, /* Data source for right Fifo of SpW n°2 : No data */
	eRmapT3InModSpw2RAebDataCcd2F  = 0b001, /* Data source for right Fifo of SpW n°2 : AEB data, CCD2 output F */
	eRmapT3InModSpw2RUnused0       = 0b010, /* Data source for right Fifo of SpW n°2 : Unused */
	eRmapT3InModSpw2RNoData1       = 0b100, /* Data source for right Fifo of SpW n°2 : No data */
	eRmapT3InModSpw2RPattDataCcd2F = 0b101, /* Data source for right Fifo of SpW n°2 : Pattern data, CCD2 output F */
	eRmapT3InModSpw2RUnused1       = 0b110, /* Data source for right Fifo of SpW n°2 : Unused */
	eRmapT3InModSpw2RUnused2       = 0b111, /* Data source for right Fifo of SpW n°2 : Unused */
} ERmapT3InModSpw2R;

enum RmapT2InModSpw2L {
	eRmapT2InModSpw2LNoData0       = 0b000, /* Data source for left Fifo of SpW n°2 : No data */
	eRmapT2InModSpw2LAebDataCcd2E  = 0b001, /* Data source for left Fifo of SpW n°2 : AEB data, CCD2 output E */
	eRmapT2InModSpw2LAebDataCcd1F  = 0b010, /* Data source for left Fifo of SpW n°2 : AEB data, CCD1 output F */
	eRmapT2InModSpw2LNoData1       = 0b100, /* Data source for left Fifo of SpW n°2 : No data */
	eRmapT2InModSpw2LPattDataCcd2E = 0b101, /* Data source for left Fifo of SpW n°2 : Pattern data, CCD2 output E */
	eRmapT2InModSpw2LPattDataCcd1F = 0b110, /* Data source for left Fifo of SpW n°2 : Pattern data, CCD1 output F */
	eRmapT2InModSpw2LUnused        = 0b111, /* Data source for left Fifo of SpW n°2 : Unused */
} ERmapT2InModSpw2L;

enum RmapT1InModSpw1R {
	eRmapT1InModSpw1RNoData0       = 0b000, /* Data source for right Fifo of SpW n°1 : No data */
	eRmapT1InModSpw1RAebDataCcd1F  = 0b001, /* Data source for right Fifo of SpW n°1 : AEB data, CCD1 output F */
	eRmapT1InModSpw1RAebDataCcd2E  = 0b010, /* Data source for right Fifo of SpW n°1 : AEB data, CCD2 output E */
	eRmapT1InModSpw1RNoData1       = 0b100, /* Data source for right Fifo of SpW n°1 : No data */
	eRmapT1InModSpw1RPattDataCcd1F = 0b101, /* Data source for right Fifo of SpW n°1 : Pattern data, CCD1 output F */
	eRmapT1InModSpw1RPattDataCcd2E = 0b110, /* Data source for right Fifo of SpW n°1 : Pattern data, CCD2 output E */
	eRmapT1InModSpw1RUnused        = 0b111, /* Data source for right Fifo of SpW n°1 : Unused */
} ERmapT1InModSpw1R;

enum RmapT0InModSpw1L {
	eRmapT0InModSpw1LNoData0       = 0b000, /* Data source for left Fifo of SpW n°1 : No data */
	eRmapT0InModSpw1LAebDataCcd1E  = 0b001, /* Data source for left Fifo of SpW n°1 : AEB data, CCD1 output E */
	eRmapT0InModSpw1LUnused0       = 0b010, /* Data source for left Fifo of SpW n°1 : Unused */
	eRmapT0InModSpw1LNoData1       = 0b100, /* Data source for left Fifo of SpW n°1 : No data */
	eRmapT0InModSpw1LPattDataCcd1E = 0b101, /* Data source for left Fifo of SpW n°1 : Pattern data, CCD1 output E */
	eRmapT0InModSpw1LUnused1       = 0b110, /* Data source for left Fifo of SpW n°1 : Unused */
	eRmapT0InModSpw1LUnused2       = 0b111, /* Data source for left Fifo of SpW n°1 : Unused */
} ERmapT0InModSpw1L;

enum RmapTrgSource {
	eRmapTrgSourceExternal = 0, /* Active source for the generation of 2.5s synchronization signal : external source */
	eRmapTrgSourceInternal = 1  /* Active source for the generation of 2.5s synchronization signal : internal source */
} ERmapTrgSource;

enum RmapTimecodeSpw {
	eRmapTimecodeSpw1 = 0b00, /* SpW link sends the Timecode : SpW n° 1 */
	eRmapTimecodeSpw2 = 0b01, /* SpW link sends the Timecode : SpW n° 2 */
	eRmapTimecodeSpw3 = 0b10, /* SpW link sends the Timecode : SpW n° 3 */
	eRmapTimecodeSpw4 = 0b11  /* SpW link sends the Timecode : SpW n° 4 */
} ERmapTimecodeSpw;

enum RmapAebState {
	eRmapAebStateOff       = 0b0000, /* AEB State : AEB_STATE_OFF */
	eRmapAebStateInit      = 0b0001, /* AEB State : AEB_STATE_INIT */
	eRmapAebStateConfig    = 0b0010, /* AEB State : AEB_STATE_CONFIG */
	eRmapAebStateImage     = 0b0011, /* AEB State : AEB_STATE_IMAGE */
	eRmapAebStatePowerDown = 0b0100, /* AEB State : AEB_STATE_POWER_DOWN */
	eRmapAebStatePowerUp   = 0b0101, /* AEB State : AEB_STATE_POWER_UP */
	eRmapAebStatePattern   = 0b0110, /* AEB State : AEB_STATE_PATTERN */
	eRmapAebStateFailure   = 0b0111, /* AEB State : AEB_STATE_FAILURE */
	eRmapAebStateUnused0   = 0b1000, /* AEB State : Unused/Spare */
	eRmapAebStateUnused1   = 0b1001, /* AEB State : Unused/Spare */
	eRmapAebStateUnused2   = 0b1010, /* AEB State : Unused/Spare */
	eRmapAebStateUnused3   = 0b1011, /* AEB State : Unused/Spare */
	eRmapAebStateUnused4   = 0b1100, /* AEB State : Unused/Spare */
	eRmapAebStateUnused5   = 0b1101, /* AEB State : Unused/Spare */
	eRmapAebStateUnused6   = 0b1110, /* AEB State : Unused/Spare */
	eRmapAebStateUnused7   = 0b1111  /* AEB State : Unused/Spare */
} ERmapAebState;
//! [public module structs definition]

//! [public function prototypes]
void vRmapCh1HandleIrq(void* pvContext);
void vRmapCh2HandleIrq(void* pvContext);
void vRmapCh3HandleIrq(void* pvContext);
void vRmapCh4HandleIrq(void* pvContext);
void vRmapCh5HandleIrq(void* pvContext);
void vRmapCh6HandleIrq(void* pvContext);
void vRmapCh7HandleIrq(void* pvContext);
void vRmapCh8HandleIrq(void* pvContext);

alt_u32 uliRmapCh1WriteCmdAddress(void);
alt_u32 uliRmapCh2WriteCmdAddress(void);
alt_u32 uliRmapCh3WriteCmdAddress(void);
alt_u32 uliRmapCh4WriteCmdAddress(void);
alt_u32 uliRmapCh5WriteCmdAddress(void);
alt_u32 uliRmapCh6WriteCmdAddress(void);
alt_u32 uliRmapCh7WriteCmdAddress(void);
alt_u32 uliRmapCh8WriteCmdAddress(void);

void vRmapCh1EnableCodec(bool bEnable);
void vRmapCh2EnableCodec(bool bEnable);
void vRmapCh3EnableCodec(bool bEnable);
void vRmapCh4EnableCodec(bool bEnable);
void vRmapCh5EnableCodec(bool bEnable);
void vRmapCh6EnableCodec(bool bEnable);
void vRmapCh7EnableCodec(bool bEnable);
void vRmapCh8EnableCodec(bool bEnable);

bool bRmapChEnableCodec(alt_u8 ucCommCh, bool bEnable);

bool vRmapInitIrq(alt_u8 ucCommCh);

bool bRmapClrAebTimestamp(alt_u8 ucAebId);
bool bRmapIncAebTimestamp(alt_u8 ucAebId, bool bAebOn);

void vRmapZeroFillDebRamMem(void);
bool bRmapZeroFillAebRamMem(alt_u8 ucAebId);

void vRmapSoftRstDebMemArea(void);
bool bRmapSoftRstAebMemArea(alt_u8 ucAebId);

// Get functions -> get data from hardware to channel variable
// Set functions -> set data from channel variable to hardware

bool bRmapSetIrqControl(TRmapChannel *pxRmapCh);
bool bRmapGetIrqControl(TRmapChannel *pxRmapCh);
bool bRmapGetIrqFlags(TRmapChannel *pxRmapCh);

bool bRmapSetCodecConfig(TRmapChannel *pxRmapCh);
bool bRmapGetCodecConfig(TRmapChannel *pxRmapCh);

bool bRmapGetCodecStatus(TRmapChannel *pxRmapCh);

bool bRmapGetCodecError(TRmapChannel *pxRmapCh);

bool bRmapGetMemStatus(TRmapChannel *pxRmapCh);

bool bRmapSetMemConfig(TRmapChannel *pxRmapCh);
bool bRmapGetMemConfig(TRmapChannel *pxRmapCh);

bool bRmapSetRmapMemCfgArea(TRmapChannel *pxRmapCh);
bool bRmapGetRmapMemCfgArea(TRmapChannel *pxRmapCh);

bool bRmapSetRmapMemHkArea(TRmapChannel *pxRmapCh);
bool bRmapGetRmapMemHkArea(TRmapChannel *pxRmapCh);

bool bRmapSetEchoingMode(TRmapChannel *pxRmapCh);
bool bRmapGetEchoingMode(TRmapChannel *pxRmapCh);

bool bRmapInitCh(TRmapChannel *pxRmapCh, alt_u8 ucCommCh);

/* Code for test purposes, should always be disabled in a release! */
#if DEV_MODE_ON
void vRmapDummyCmd(alt_u32 uliDummyAdddr);
#endif

alt_u32 uliRmapReadReg(alt_u32 *puliAddr, alt_u32 uliOffset);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* RMAP_H_ */
