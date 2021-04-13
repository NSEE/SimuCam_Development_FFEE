/*
 * spw_controller.h
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#ifndef SPW_CONTROLLER_H_
#define SPW_CONTROLLER_H_

#include "../comm.h"
#include <math.h>

//! [constants definition]

enum SpwdCh1DemuxSelId {
	eSpwdCh1DemuxSelIdChA  = 0u, /* Communication Channel 1 Demux Select ID for SpaceWire Channel A */
	eSpwdCh1DemuxSelIdChE  = 1u, /* Communication Channel 1 Demux Select ID for SpaceWire Channel E */
	eSpwdCh1DemuxSelIdNone = 2u  /* Communication Channel 1 Demux Select ID for None Selected */
} ESpwdCh1DemuxSelId;

enum SpwdCh2DemuxSelId {
	eSpwdCh2DemuxSelIdChB  = 0u, /* Communication Channel 2 Demux Select ID for SpaceWire Channel B */
	eSpwdCh2DemuxSelIdChF  = 1u, /* Communication Channel 2 Demux Select ID for SpaceWire Channel F */
	eSpwdCh2DemuxSelIdNone = 2u  /* Communication Channel 2 Demux Select ID for None Selected */
} ESpwdCh2DemuxSelId;

enum SpwdCh3DemuxSelId {
	eSpwdCh3DemuxSelIdChC  = 0u, /* Communication Channel 3 Demux Select ID for SpaceWire Channel C */
	eSpwdCh3DemuxSelIdChG  = 1u, /* Communication Channel 3 Demux Select ID for SpaceWire Channel G */
	eSpwdCh3DemuxSelIdNone = 2u  /* Communication Channel 3 Demux Select ID for None Selected */
} ESpwdCh3DemuxSelId;

enum SpwdCh4DemuxSelId {
	eSpwdCh4DemuxSelIdChD  = 0u, /* Communication Channel 4 Demux Select ID for SpaceWire Channel D */
	eSpwdCh4DemuxSelIdChH  = 1u, /* Communication Channel 4 Demux Select ID for SpaceWire Channel H */
	eSpwdCh4DemuxSelIdNone = 2u  /* Communication Channel 4 Demux Select ID for None Selected */
} ESpwdCh4DemuxSelId;

//! [constants definition]

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]

// Get functions -> get data from hardware to channel variable
// Set functions -> set data from channel variable to hardware

bool bSpwcSetLinkConfig(TSpwcChannel *pxSpwcCh);
bool bSpwcGetLinkConfig(TSpwcChannel *pxSpwcCh);

bool bSpwcGetLinkStatus(TSpwcChannel *pxSpwcCh);

bool bSpwcGetLinkError(TSpwcChannel *pxSpwcCh);

bool bSpwcSetTimecodeConfig(TSpwcChannel *pxSpwcCh);
bool bSpwcGetTimecodeConfig(TSpwcChannel *pxSpwcCh);

bool bSpwcGetTimecodeStatus(TSpwcChannel *pxSpwcCh);

bool bSpwcClearTimecode(TSpwcChannel *pxSpwcCh);
bool bSpwcEnableTimecodeTrans(TSpwcChannel *pxSpwcCh, bool bEnable);

bool bSpwcInitCh(TSpwcChannel *pxSpwcCh, alt_u8 ucCommCh);

bool bSpwdCh1DemuxSelect(alt_u32 uliDemuxSelect);
bool bSpwdCh2DemuxSelect(alt_u32 uliDemuxSelect);
bool bSpwdCh3DemuxSelect(alt_u32 uliDemuxSelect);
bool bSpwdCh4DemuxSelect(alt_u32 uliDemuxSelect);

alt_u8 ucSpwcCalculateLinkDiv(alt_8 ucLinkSpeed);
alt_u32 uliTimecodeCalcDelayNs(alt_u32 uliDelayNs);
alt_u32 uliTimecodeCalcDelayMs(alt_u32 uliDelayMs);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* SPW_CONTROLLER_H_ */
