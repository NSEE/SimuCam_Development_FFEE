/*
 * data_packet.h
 *
 *  Created on: 09/01/2019
 *      Author: rfranca
 */

#ifndef DATA_PACKET_H_
#define DATA_PACKET_H_

#include "../comm.h"

//! [constants definition]
// address
// bit masks
//! [constants definition]

/* Data Packet Mode */
enum DpktMode {
	eDpktOff                      = 0u,  /* F-FEE Off Mode */
	eDpktOn                       = 1u,  /* F-FEE On Mode */
	eDpktFullImagePatternDeb      = 2u,  /* F-FEE Full-Image Pattern DEB Mode */
	eDpktWindowingPatternDeb      = 3u,  /* F-FEE Windowing Pattern DEB Mode */
	eDpktStandby                  = 4u,  /* F-FEE Standby Mode */
	eDpktFullImagePatternAeb      = 5u,  /* F-FEE Full-Image Pattern AEB Mode */
	eDpktWindowingPatternAeb      = 6u,  /* F-FEE Windowing Pattern AEB Mode */
	eDpktFullImage			      = 7u,  /* F-FEE Full-Image Mode */
	eDpktWindowing			      = 8u   /* F-FEE Windowing Mode */
} EDpktMode;

enum DpktCcdSide {
	eDpktCcdSideE                 = 0u,  /* F-FEE CCD Side E (Left) */
	eDpktCcdSideF                 = 1u,  /* F-FEE CCD Side F (Right) */
} EDpktCcdSide;

//! [public module structs definition]
//! [public module structs definition]

//! [public function prototypes]

// Get functions -> get data from hardware to channel variable
// Set functions -> set data from channel variable to hardware

bool bDpktSetPacketConfig(TDpktChannel *pxDpktCh);
bool bDpktGetPacketConfig(TDpktChannel *pxDpktCh);

bool bDpktSetPacketErrors(TDpktChannel *pxDpktCh);
bool bDpktGetPacketErrors(TDpktChannel *pxDpktCh);

bool bDpktGetPacketHeader(TDpktChannel *pxDpktCh);

bool bDpktSetPixelDelay(TDpktChannel *pxDpktCh);
bool bDpktGetPixelDelay(TDpktChannel *pxDpktCh);

bool bDpktSetPresetFrmCnt(TDpktChannel *pxDpktCh);
bool bDpktGetPresetFrmCnt(TDpktChannel *pxDpktCh);

bool bDpktSetFrameCounterValue(TDpktChannel *pxDpktCh, alt_u16 usiFrmCntVal);

bool bDpktSetErrorInjection(TDpktChannel *pxDpktCh);
bool bDpktGetErrorInjection(TDpktChannel *pxDpktCh);

bool bDpktSetWindowingParams(TDpktChannel *pxDpktCh);
bool bDpktGetWindowingParams(TDpktChannel *pxDpktCh);

bool bDpktSetWindowListError(TDpktChannel *pxDpktCh);
bool bDpktGetWindowListError(TDpktChannel *pxDpktCh);

bool bDpktInitCh(TDpktChannel *pxDpktCh, alt_u8 ucCommCh);
alt_u32 uliPxDelayCalcPeriodNs(alt_u32 uliPeriodNs);
alt_u32 uliPxDelayCalcPeriodMs(alt_u32 uliPeriodMs);
//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* DATA_PACKET_H_ */
