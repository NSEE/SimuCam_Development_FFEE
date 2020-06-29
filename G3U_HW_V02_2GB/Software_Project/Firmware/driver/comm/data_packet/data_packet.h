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
	eDpktOff                      = 0u,  /* N-FEE Off Mode */
	eDpktOn                       = 1u,  /* N-FEE On Mode */
	eDpktFullImagePatternDeb      = 2u,  /* N-FEE Full-Image Pattern Mode */
	eDpktWindowingPatternDeb      = 3u,  /* N-FEE Windowing Pattern Mode */
	eDpktStandby                  = 4u,  /* N-FEE Standby Mode */
	eDpktFullImagePatternAeb      = 5u,  /* N-FEE Full-Image Mode / Pattern Mode */
	eDpktWindowingPatternAeb      = 6u,  /* N-FEE Full-Image Mode / SSD Mode */
	eDpktFullImage			      = 7u,  /* N-FEE Windowing Mode / Pattern Mode */
	eDpktWindowing			      = 8u,  /* N-FEE Windowing Mode / SSD Image Mode */
} EDpktMode;

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

bool bDpktSetErrorInjection(TDpktChannel *pxDpktCh);
bool bDpktGetErrorInjection(TDpktChannel *pxDpktCh);

bool bDpktSetWindowingParams(TDpktChannel *pxDpktCh);
bool bDpktGetWindowingParams(TDpktChannel *pxDpktCh);

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
