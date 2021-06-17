/*
 * aeb.h
 *
 *  Created on: 27 de jun de 2020
 *      Author: Tiago-note
 */

#ifndef UTILS_AEB_H_
#define UTILS_AEB_H_

typedef enum { sAebOFF = 0, sAebInit, sAebConfig, sAebPattern, sAebImage, sAebPowerDown, sAebPowerUp} tAebStates;

/* FEE AEB SpaceWire Status*/
typedef enum AebSpwStatus {
	eAebSpwDisconnected = 0,
	eAebSpwDisconnectedAutoStart,
	eAebSpwConnecting,
	eAebSpwStarted,
	eAebSpwRunning
} TAebSpwStatus;

/*AEB_CONFIG_PATTERN register (0x0010):*/
typedef struct AeBConfigPattern{
	unsigned short int usiCcdId;		/* PATTERN_CCDID */
	unsigned short int usiCols;			/* PATTERN_COLS */
	unsigned short int usiRows;			/* PATTERN_ROWS */
}TAeBConfigPattern;

typedef enum { sLeft = 0, sRight, sBoth } tAebSide;
typedef struct AeBControl{
	bool 		bSwitchedOn;
	tAebSide   	eSide;     	/* Side of CCD (don't sure if Fast is gona use it. let here for now) */
	volatile tAebStates eState;                   /* Real State of FFEE */
	TAeBConfigPattern xConfigPattern;

	/*Not used for now*/
	unsigned int uiSeqConfig[14];			/* SEQ_CONFIG_1 .. SEQ_CONFIG_14 */ 	//todo: Not used in simulation
	unsigned int uiAdc1Config[3];			/* ADC1_CONFIG_1 .. ADC1_CONFIG_3 */ 	//todo: Not used in simulation
	unsigned int uiAdc2Config[3];			/* ADC2_CONFIG_1 .. ADC2_CONFIG_3 */ 	//todo: Not used in simulation
}TAeBControl;





#endif /* UTILS_AEB_H_ */
