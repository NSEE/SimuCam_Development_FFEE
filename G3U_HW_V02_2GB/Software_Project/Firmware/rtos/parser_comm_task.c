/*
 * parser_comm_task.c
 *
 *  Created on: 27/12/2018
 *      Author: Tiago-Low
 */

#include "parser_comm_task.h"

#define BCHECK_FEE_PARAM(ucParam) (ucParam < N_OF_FastFEE)
#define BCHECK_FEE_AEB_PARAM(ucParam) (ucParam < (N_OF_FastFEE*N_OF_CCD))

void vParserCommTask(void *task_data) {
	bool bSuccess = FALSE;
	INT8U error_code;
	tParserStates eParserMode;
	unsigned char ucIL, ucFFeeInstL;
	static tTMPus xTcPusL;
	static tPreParsed PreParsedLocal;

	alt_u16 usiMebFee       = 0;
	alt_u16 usiDefaultId    = 0;
	alt_u32 uliDefaultValue = 0;

    #if DEBUG_ON
		if ( xDefaults.ucDebugLevel <= dlMajorMessage )
			fprintf(fp,"Parser Comm Task. (Task on)\n");
    #endif

	eParserMode = sConfiguring;
	for(;;){
		switch (eParserMode) {
			case sConfiguring:
				/*For future implementations*/
				eParserMode = sWaitingMessage;
				break;

			case sWaitingMessage:

				bSuccess = FALSE;
				eParserMode = sWaitingMessage;

				OSSemPend(xSemCountPreParsed, 0, &error_code); /*Blocking*/
				if ( error_code == OS_ERR_NONE ) {
					/* There's command waiting to be threat */
					bSuccess = getPreParsedPacket(&PreParsedLocal); /*Blocking*/
					if (bSuccess == TRUE) {
						/* PreParsed Content copied to the local variable */
						if ( PreParsedLocal.cType == START_REPLY_CHAR ) {
							eParserMode = sReplyParsing;
						}
						else {
							eParserMode = sRequestParsing;
						}
					} else {
						/* Semaphore was post by some task but has no message in the PreParsedBuffer*/
						vNoContentInPreParsedBuffer();
					}
				} else
					vFailGetCountSemaphorePreParsedBuffer();
				break;

			case sRequestParsing:
				/* Final parssing after identify that is a request packet */
				/* ATTENTION: In order to avoid overhead of process the response to NUC of simple Requests
				   will be threat here, and send from here the parser_rx.*/
			   	switch (PreParsedLocal.cCommand)
				{
					case ETH_CMD: /*NUC requested the ETH Configuration*/
						vSendEthConf();

						#if DEBUG_ON
						if ( xDefaults.ucDebugLevel <= dlMajorMessage ) {
							fprintf(fp,"\n__________ Load Completed, Simucam is ready to be used _________ \n\n");
						}
						#endif
						/* Send Event Log */
						vSendEventLogArr(EVT_MEBFEE_MEB_ID, cucEvtListData[eEvtPowerOn]);
						eParserMode = sWaitingMessage;
						break;

                    case PUS_CMD: /*PUS command to MEB - TC*/
						#if DEBUG_ON
                    	if ( xDefaults.ucDebugLevel <= dlMinorMessage )
							fprintf(fp, "\nParser Task: TC-> pid: %hu; pcat: %hu; srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", PreParsedLocal.usiValues[1], PreParsedLocal.usiValues[2], PreParsedLocal.usiValues[3], PreParsedLocal.usiValues[4], PreParsedLocal.usiValues[5] );
						#endif
						/* Loading the values to the variable that will be used for the state that perform
						the action from PUS command*/
						xTcPusL.usiPid	= PreParsedLocal.usiValues[1];
						xTcPusL.usiCat	= PreParsedLocal.usiValues[2];
						xTcPusL.usiType = PreParsedLocal.usiValues[3];
						xTcPusL.usiSubType = PreParsedLocal.usiValues[4];
						xTcPusL.usiPusId = PreParsedLocal.usiValues[5];
						xTcPusL.ucNofValues = 0; /* Don't assume that has values */
						eParserMode = sPusHandling;
                        break;

					default:
						eParserMode = sWaitingMessage;
				}
				break;
			case sReplyParsing:
				eParserMode = sWaitingMessage;
				if ((PreParsedLocal.cType == '!') && (PreParsedLocal.cCommand == 'X')) {

					usiMebFee       = PreParsedLocal.usiValues[1];
					usiDefaultId    = PreParsedLocal.usiValues[2];
					uliDefaultValue = (alt_u32) ((alt_u32)(PreParsedLocal.usiValues[3] & 0x0000FFFF) << 16 | (alt_u32)(PreParsedLocal.usiValues[4] & 0x0000FFFF));

					if (255 == usiMebFee) {
						vbDeftDefaultsReceived = TRUE;
						vSendEventLogArr(EVT_MEBFEE_MEB_ID, cucEvtListData[eEvtPowerOn]);
					} else {
						if (bDeftSetDefaultValues(usiMebFee, usiDefaultId, uliDefaultValue)) {
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlMajorMessage )
								fprintf(fp, "Parser Task: Valid default - MEBFEE = %u, ID = %u, Value = %lu\n", usiMebFee, usiDefaultId, uliDefaultValue);
							#endif
						} else {
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlMajorMessage )
								fprintf(fp, "Parser Task: Non-valid default - MEBFEE = %u, ID = %u, Value = %lu\n", usiMebFee, usiDefaultId, uliDefaultValue);
							#endif
						}
					}

				}

                switch ( xTcPusL.usiType ) {
                    case NUC_STATUS_CMD: /*Status from NUC*/
						/*todo*/
                        break;

                    case HEART_BEAT_CMD: /*Heart beating (NUC are you there?)*/
						/*todo*/
                        break;

                    default:
						eParserMode = sWaitingMessage;
                }
				break;
			case sPusHandling:
			/* This state identify the command of PUS, if the command is for any FEE than will be send to
			MEB_Task than foward to the FEE using the queue internal command*/
				eParserMode = sWaitingMessage;
				/*Check the type of the PUS command*/
                switch ( xTcPusL.usiType ) {
                    case 17: /* srv-Type = 17 */
						switch ( xTcPusL.usiSubType ) {
							case 1: /* TC_SCAM_TEST_CONNECTION */
								#if DEBUG_ON
								if ( xDefaults.ucDebugLevel <= dlMajorMessage )
									fprintf(fp,"Parser Task: TC_SCAM_TEST_CONNECTION\n");
								#endif

								/* Reply with the TM of connection */
								vTMPusTestConnection( xTcPusL.usiPusId, xTcPusL.usiPid, xTcPusL.usiCat );
								break;

							default:
								#if DEBUG_ON
								if ( xDefaults.ucDebugLevel <= dlMinorMessage )
									fprintf(fp, "Parser Task: Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xTcPusL.usiType, xTcPusL.usiSubType, xTcPusL.usiPusId );
								#endif
								eParserMode = sWaitingMessage;
						}
                        break;

                    case 250: /* srv-Type = 250 */
						switch ( xTcPusL.usiSubType ) {
							case 29: /* TC_SYNCH_SOURCE */
								#if DEBUG_ON
								if ( xDefaults.ucDebugLevel <= dlMinorMessage )
									fprintf(fp,"Parser Task: TC_SYNCH_SOURCE\n");
								#endif
								/*source*/
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[6];
								xTcPusL.ucNofValues++;
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;


							/* TC_SYNCH_RESET */
							case 31:
								#if DEBUG_ON
								if ( xDefaults.ucDebugLevel <= dlMinorMessage )
									fprintf(fp,"Parser Task: TC_SYNCH_RESET\n");
								#endif
								/* Get the value */
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[6];
								xTcPusL.ucNofValues++;
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							/* TC_SCAMxx_DEB_RMAP_CONF_DUMP */
							case 39:
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								if ( BCHECK_FEE_PARAM(ucFFeeInstL) ) {
									tTMPus xTmPusL;
									TRmapChannel *pRmap = &xSimMeb.xFeeControl.xFfee[ucFFeeInstL].xChannel[ucFFeeInstL*N_OF_CCD].xRmap;
									bRmapGetRmapMemCfgArea(pRmap);
									xTmPusL.usiPusId = xTcPusL.usiPusId;
									xTmPusL.usiPid = xTcPusL.usiPid;
									xTmPusL.usiCat = xTcPusL.usiCat;
									xTmPusL.usiType = 250;
									xTmPusL.usiSubType = 40;
									xTmPusL.ucNofValues = 0;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = ucFFeeInstL;																							xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx3;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx2;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx1;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcAebOnoff.bAebIdx0;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg0.bPfdfc;						xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg0.bGtme;						xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldtr;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg0.bHoldf;						xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg0.ucOthers;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg1.uliOthers >> 0x10;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg1.uliOthers & 0xFFFF;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg2.uliOthers >> 0x10;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg2.uliOthers & 0xFFFF;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg3.uliOthers >> 0x10;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcPllReg3.uliOthers & 0xFFFF;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcFeeMod.ucOperMod;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaCritCfg.xDtcImmOnmod.bImmOn;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT7InMod;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT6InMod;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT5InMod;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT4InMod;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT3InMod;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT2InMod;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT1InMod;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcInMod.ucT0InMod;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizX;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwSiz.ucWSizY;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx4;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen4;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx3;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen3;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx2;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen2;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwIdx1;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcWdwIdx.usiWdwLen1;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcOvsPat.ucOvsLinPat;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbLinPat;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSizPat.usiNbPixPat;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcTrg25S.ucN25SNCyc;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSelTrg.bTrgSrc;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcFrmCnt.usiPsetFrmCnt;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSelSyn.bSynFrq;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstSpw;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcRstCps.bRstWdg;					xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtc25SDly.uliN25SDly & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcTmodConf.uliReserved & 0xFFFF;	xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmap->xRmapMemAreaPrt.puliRmapDebAreaPrt->xRmapDebAreaGenCfg.xCfgDtcSpwCfg.ucTimecode;				xTmPusL.ucNofValues++;
									vSendPusTM512(xTmPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							/* TC_SCAMxx_AEB_RMAP_CONF_DUMP */
							case 41:
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {
									tTMPus xTmPusL;
									bRmapGetRmapMemCfgArea(&xSimMeb.xFeeControl.xFfee[ucFFeeInstL/N_OF_CCD].xChannel[ucFFeeInstL%N_OF_CCD].xRmap);
									TRmapMemAebArea *pRmapMem = xSimMeb.xFeeControl.xFfee[ucFFeeInstL/N_OF_CCD].xChannel[ucFFeeInstL%N_OF_CCD].xRmap.xRmapMemAreaPrt.puliRmapAebAreaPrt[ucFFeeInstL%N_OF_CCD];
									xTmPusL.usiPusId = xTcPusL.usiPusId;
									xTmPusL.usiPid = xTcPusL.usiPid;
									xTmPusL.usiCat = xTcPusL.usiCat;
									xTmPusL.usiType = 250;
									xTmPusL.usiSubType = 42;
									xTmPusL.ucNofValues = 0;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = ucFFeeInstL;														xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebControl.ucReserved;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebControl.ucNewState;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebControl.bSetState;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebControl.bAebReset;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebControl.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebControl.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebConfig.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebConfig.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebConfigKey.uliKey >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebConfigKey.uliKey & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebConfigAit.uliOthers & 0xFFFF;	xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebConfigPattern.ucPatternCcdid;	xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternCols;	xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebConfigPattern.ucReserved;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xAebConfigPattern.usiPatternRows;	xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers >> 0x10;	xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xVaspI2CControl.uliOthers & 0xFFFF;	xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xDacConfig1.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xDacConfig1.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xDacConfig2.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xDacConfig2.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xReserved20.uliReserved >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xReserved20.uliReserved & 0xFFFF;	xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVccdOn;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVclkOn;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan1On;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xPwrConfig1.ucTimeVan2On;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan3On;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVccdOff;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVclkOff;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xPwrConfig2.ucTimeVan1Off;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan2Off;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaCritCfg.xPwrConfig3.ucTimeVan3Off;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xAdc1Config1.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xAdc1Config2.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xAdc1Config3.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xAdc2Config1.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xAdc2Config2.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xAdc2Config3.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xReserved118.uliReserved >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xReserved118.uliReserved & 0xFFFF;	xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xReserved11C.uliReserved >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xReserved11C.uliReserved & 0xFFFF;	xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig1.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig2.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig3.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig4.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig5.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig6.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig7.uliReserved & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig8.uliReserved & 0xFFFF;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig9.ucReserved0;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig9.usiFtLoopCnt;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig9.bLt0Enabled;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig9.bReserved1;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig9.usiLt0LoopCnt;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig10.bLt1Enabled;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig10.bReserved0;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig10.usiLt1LoopCnt;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig10.bLt2Enabled;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig10.bReserved1;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig10.usiLt2LoopCnt;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig11.bLt3Enabled;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig11.bReserved;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig11.usiLt3LoopCnt;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig11.usiPixLoopCntWord1;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig12.usiPixLoopCntWord0;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig12.bPcEnabled;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig12.bReserved;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig12.usiPcLoopCnt;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved0;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig13.usiInt1LoopCnt;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig13.ucReserved1;				xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig13.usiInt2LoopCnt;			xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers >> 0x10;		xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = pRmapMem->xRmapAebAreaGenCfg.xSeqConfig14.uliOthers & 0xFFFF;		xTmPusL.ucNofValues++;
									vSendPusTM512(xTmPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu/%hu;\n", ucFFeeInstL/N_OF_CCD, ucFFeeInstL%N_OF_CCD );
									#endif
								}
								break;
							case 36: // TC_SCAMxx_RMAP_ECHO_ENABLE - FIXME in the spec this is LESIA ONLY
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								if ( BCHECK_FEE_PARAM(ucFFeeInstL) ) {
									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 37: // TC_SCAMxx_RMAP_ECHO_DISABLE - FIXME in the spec this is LESIA ONLY
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								if ( BCHECK_FEE_PARAM(ucFFeeInstL) ) {
									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 44: /* TC_SCAMxx_EP_UPDATE  */
								/* Exposure value */
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[6];
								xTcPusL.ucNofValues++;
								/* Send the command to the MEB task */
								bSendMessagePUStoMebTask(&xTcPusL);
								break;
							case 46: /* TC_SCAMxx_SPW_ERR_TRIG */
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {
									/* FEE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* N repeat */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/* Sequence Counter */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
									xTcPusL.ucNofValues++;
									/* Error Type */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;
									/* Send the command to the MEB task */
									bSendMessagePUStoMebTask(&xTcPusL);
								}else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 47: /* TC_SCAMxx_RMAP_ERR_TRIG */
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {
									/* FEE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* ERROR ID */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/* VALUE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
									xTcPusL.ucNofValues++;
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;
									/* N REPEAT */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[10];
									xTcPusL.ucNofValues++;
									/* Send the command to the MEB task */
									bSendMessagePUStoMebTask(&xTcPusL);
								}else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 48: /* TC_SCAMxx_TICO_ERR_TRIG */
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {
									/* FEE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* OFFSET */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/* Sync Value Part1 */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
									xTcPusL.ucNofValues++;
									/* Sync Value Part2 */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;
									/* N Repeat */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[10];
									xTcPusL.ucNofValues++;
									/* ID */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[11];
									xTcPusL.ucNofValues++;
									/* Send the command to the MEB task */
									bSendMessagePUStoMebTask(&xTcPusL);
								}else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 49: /* TC_SCAM_IMAGE_ERR_MISS_PKT_TRIG  */

								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* FN */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/* SQ */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
									xTcPusL.ucNofValues++;
									/* N repeat */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;

									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 52: /* TC_SCAM_WIN_ERR_NOMOREPKT_TRIG  */
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* FN */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 62: /* TC_SCAM_WIN_ERR_ENABLE_WIN_PROG  */
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 63: /* TC_SCAM_WIN_ERR_DISABLE_WIN_PROG  */
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 67: /* TC_SCAM_IMAGE_ERR_MISSDATA_TRIG  */
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* FN */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/* SQ */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
									xTcPusL.ucNofValues++;
									/* N repeat */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;
									/* StartByte */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;

									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;

							case 50: /* TC_SCAM_IMAGE_ERR_NOMOREPKT_TRIG  */
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* FN */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 51: /* TC_SCAM_WIN_ERR_MISS_PKT_TRIG  */

								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* FN */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/* SQ */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
									xTcPusL.ucNofValues++;
									/* N repeat */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;

									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 53: /* TC_SCAM_ERR_OFF  */
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;

							case 58: /* Update HK [bndky] */ // TC_SCAMxx_FEE_HK_UPDATE_VALUE

								ucFFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( !BCHECK_FEE_PARAM(ucFFeeInstL) ) {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlMajorMessage )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", ucFFeeInstL );
									#endif
								/* todo: Enviar mensagem de erro se aplicavel */
								} else {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* HK ID */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/* HK Value */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
									xTcPusL.ucNofValues++;
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;

									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								}
								break;

							case 59: /* TC_SCAM_RESET */
								#if DEBUG_ON
								if ( xDefaults.ucDebugLevel <= dlMinorMessage )
									fprintf(fp,"Parser Task: TC_SCAM_RESET\n");
								#endif
								/* Send Event Log */
								vSendEventLogArr(EVT_MEBFEE_MEB_ID, cucEvtListData[eEvtMebReset]);
								/*Send the command to NUC in order to reset the NUC*/
								vSendReset();
								/* Send to Meb the reset command */
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							case 60: /* TC_SCAM_CONFIG */
								#if DEBUG_ON
								if ( xDefaults.ucDebugLevel <= dlMinorMessage )
									fprintf(fp,"Parser Task: TC_SCAM_CONFIG\n");
								#endif
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							case 61: /* TC_SCAM_RUN */
								#if DEBUG_ON
								if ( xDefaults.ucDebugLevel <= dlMinorMessage )
									fprintf(fp,"Parser Task: TC_SCAM_RUN\n");
								#endif
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							case 66: /* TC_SCAM_TURNOFF */
								#if DEBUG_ON
								if ( xDefaults.ucDebugLevel <= dlMinorMessage )
									fprintf(fp,"Parser Task: TC_SCAM_TURNOFF\n");
								#endif
								/* Send Event Log */
								vSendEventLogArr(EVT_MEBFEE_MEB_ID, cucEvtListData[eEvtShutdown]);
								/*Send the command to NUC in order to shutdown the NUC*/
								vSendTurnOff();
								/* Send to Meb the shutdown command */
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							case 64: /* TC_SCAM_FEE_TIME_CONFIG */

								/* EP */
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[6];
								xTcPusL.ucNofValues++;
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
								xTcPusL.ucNofValues++;
								/* DELTA_START */
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
								xTcPusL.ucNofValues++;
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
								xTcPusL.ucNofValues++;
								/* DELTA_PX  */
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[10];
								xTcPusL.ucNofValues++;
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[11];
								xTcPusL.ucNofValues++;
								/* DELTA_LINE  */
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[12];
								xTcPusL.ucNofValues++;
								xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[13];
								xTcPusL.ucNofValues++;

								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);

								break;
							case 72: /* TC_SCAM_WIN_ERR_MISSDATA_TRIG  */
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* FN */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/* SQ */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
									xTcPusL.ucNofValues++;
									/* N repeat */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;
									/* StartByte */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[10];
									xTcPusL.ucNofValues++;

									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 73: /* TC_SCAM_IMGWIN_CONTENT_ERR_CONFIG  */
								ucFFeeInstL = (unsigned char)PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {
									/* FEE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* PX */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/* PY */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
									xTcPusL.ucNofValues++;
									/* SIDE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;
									/* COUNT FRAMES */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[10];
									xTcPusL.ucNofValues++;
									/* ACTIVE FRAMES */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[11];
									xTcPusL.ucNofValues++;
									/* PIXEL VALUE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[12];
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 74: /* TC_SCAM_IMGWIN_CONTENT_ERR_CONFIG_FINISH  */
								ucFFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {
									/* FEE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* SIDE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								}else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 75: /* TC_SCAM_IMGWIN_CONTENT_ERR_CLEAR  */
								ucFFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {
									/* FEE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* SIDE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								}else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 76: /* TC_SCAM_IMGWIN_CONTENT_ERR_START_INJ  */
								ucFFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {
									/* FEE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* SIDE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								}else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 77: /* TC_SCAM_IMGWIN_CONTENT_ERR_STOP_INJ  */
								ucFFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL)) {
									/* FEE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* SIDE */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								}else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 78: /* TC_SCAMxx_DATA_PKT_ERR_CONFIG  */
								ucFFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/* FN */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];
									xTcPusL.ucNofValues++;
									/* SQ */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[8];
									xTcPusL.ucNofValues++;
									/* N repeat */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[9];
									xTcPusL.ucNofValues++;
									/* StartByte */
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[10];
									xTcPusL.ucNofValues++;

									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 79: /* TC_SCAMxx_DATA_PKT_ERR_CONFIG_FINISH  */
								ucFFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {
									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 80: /* TC_SCAMxx_DATA_PKT_ERR_CLEAR  */
								ucFFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {
									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 81: /* TC_SCAMxx_DATA_PKT_ERR_START_INJ  */
								ucFFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {
									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 82: /* TC_SCAMxx_DATA_PKT_ERR_STOP_INJ  */
								ucFFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {
									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 86: /* TC_SCAMxx_FEE_FGS_ON  */
								ucFFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_PARAM(ucFFeeInstL) ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 87: /* TC_SCAMxx_FEE_FGS_OFF  */
								ucFFeeInstL = PreParsedLocal.usiValues[6];
								/* Verify valid FEE */
								if ( BCHECK_FEE_PARAM(ucFFeeInstL) ) {

									xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;

							default:
								#if DEBUG_ON
								if ( xDefaults.ucDebugLevel <= dlMinorMessage )
									fprintf(fp, "Parser Task: Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xTcPusL.usiType, xTcPusL.usiSubType, xTcPusL.usiPusId );
								#endif
								eParserMode = sWaitingMessage;
						}
                        break;

                    case 251: /* srv-Type = 251 */
					/*Commands of these srv-Type (251), are to simulation FEE instances*/
						ucFFeeInstL = PreParsedLocal.usiValues[6];
						if ( !BCHECK_FEE_PARAM(ucFFeeInstL) ) {
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlMajorMessage )
								fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", ucFFeeInstL );
							#endif
							/* todo: Enviar mensagem de erro se aplicavel */
						} else {
							xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
							xTcPusL.ucNofValues++;

							switch ( xTcPusL.usiSubType ) {
								case 1: /* TC_SCAM_FEE_CONFIG_ENTER */
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: TC_SCAM_FEE_CONFIG_ENTER (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;

								case 2: /* TC_SCAM_FEE_STANDBY_ENTER */
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: TC_SCAM_FEE_STANDBY_ENTER (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								case 3: /* FFEE_RUNNING_FULLIMAGE  */
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: FFEE_RUNNING_FULLIMAGE (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								case 4: /* FFEE_RUNNING_WINDOWING  */
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: FFEE_RUNNING_WINDOWING (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								case 5: /* FFEE_RUNNING_FULLIMAGE_PATTERN */
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: FFEE_RUNNING_FULLIMAGE_PATTERN (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								case 6: /* FFEE_RUNNING_WINDOWING_PATTERN  */
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: FFEE_RUNNING_WINDOWING_PATTERN (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								case 11: /* FFEE_RUNNING_ON  */
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: FFEE_RUNNING_ON (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
									#endif
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
//								case 12: /* FFEE_RUNNING_PARALLEL_TRAP_PUMP_1  */
//									#if DEBUG_ON
//									if ( xDefaults.ucDebugLevel <= dlMinorMessage )
//										fprintf(fp, "Parser Task: FFEE_RUNNING_PARALLEL_TRAP_PUMP_1 (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
//									#endif
//									/*Send the command to the MEB task*/
//									bSendMessagePUStoMebTask(&xTcPusL);
//									break;
//								case 13: /* FFEE_RUNNING_PARALLEL_TRAP_PUMP_2  */
//									#if DEBUG_ON
//									if ( xDefaults.ucDebugLevel <= dlMinorMessage )
//										fprintf(fp, "Parser Task: FFEE_RUNNING_PARALLEL_TRAP_PUMP_2 (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
//									#endif
//									/*Send the command to the MEB task*/
//									bSendMessagePUStoMebTask(&xTcPusL);
//									break;
//								case 14: /* FFEE_RUNNING_SERIAL_TRAP_PUMP_1  */
//									#if DEBUG_ON
//									if ( xDefaults.ucDebugLevel <= dlMinorMessage )
//										fprintf(fp, "Parser Task: FFEE_RUNNING_SERIAL_TRAP_PUMP_1 (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
//									#endif
//									/*Send the command to the MEB task*/
//									bSendMessagePUStoMebTask(&xTcPusL);
//									break;
//								case 15: /* FFEE_RUNNING_SERIAL_TRAP_PUMP_2  */
//									#if DEBUG_ON
//									if ( xDefaults.ucDebugLevel <= dlMinorMessage )
//										fprintf(fp, "Parser Task: FFEE_RUNNING_SERIAL_TRAP_PUMP_2 (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
//									#endif
//									/*Send the command to the MEB task*/
//									bSendMessagePUStoMebTask(&xTcPusL);
//									break;
								case 16: /* TC_SCAMxx_AEB_SET_STATE  */
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: TC_SCAMxx_AEB_SET_STATE (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
									#endif
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];/*AEB number*/
									xTcPusL.ucNofValues++;
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7];/*AEB AEB_STATE*/
									xTcPusL.ucNofValues++;
									/*Send the command to the MEB task*/
									bSendMessagePUStoMebTask(&xTcPusL);
									break;
								default:
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlMinorMessage )
										fprintf(fp, "Parser Task: Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xTcPusL.usiType, xTcPusL.usiSubType, xTcPusL.usiPusId );
									#endif
									eParserMode = sWaitingMessage;
							}
						}
                        break;

					case 252: /* srv-Type = 252 */
						ucFFeeInstL = PreParsedLocal.usiValues[6];
						xTcPusL.usiValues[xTcPusL.ucNofValues] = ucFFeeInstL;
						xTcPusL.ucNofValues++;

						switch ( xTcPusL.usiSubType ) {
							case 3: /* TC_SCAM_SPW_LINK_ENABLE */
								#if DEBUG_ON
								if ( xDefaults.ucDebugLevel <= dlMinorMessage )
									fprintf(fp, "Parser Task: TC_SCAM_SPW_LINK_ENABLE (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
								#endif
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							case 4: /* TC_SCAM_SPW_LINK_DISABLE */
								#if DEBUG_ON
								if ( xDefaults.ucDebugLevel <= dlMinorMessage )
									fprintf(fp, "Parser Task: TC_SCAM_SPW_LINK_DISABLE (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
								#endif
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							case 5: /* TC_SCAM_SPW_LINK_RESET */
								#if DEBUG_ON
								if ( xDefaults.ucDebugLevel <= dlMinorMessage )
									fprintf(fp, "Parser Task: TC_SCAM_SPW_LINK_RESET (FEESIM_INSTANCE: %hu)\n", ucFFeeInstL );
								#endif
								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							case 2: /* TC_SCAM_SPW_RMAP_CONFIG_UPDATE */

								for ( ucIL = 0; ucIL < 6; ucIL++) {
									xTcPusL.usiValues[xTcPusL.ucNofValues] = PreParsedLocal.usiValues[7+ucIL];
									xTcPusL.ucNofValues++; /*todo: Will be needed for future command, don't remove until you sure it will not be used anymore*/
								}

								/*Send the command to the MEB task*/
								bSendMessagePUStoMebTask(&xTcPusL);
								break;

							default:
								#if DEBUG_ON
								if ( xDefaults.ucDebugLevel <= dlMinorMessage )
									fprintf(fp, "Parser Task: Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xTcPusL.usiType, xTcPusL.usiSubType, xTcPusL.usiPusId );
								#endif
								eParserMode = sWaitingMessage;
						}
                        break;
					case 254: /* srv-Type = 254 */
						switch ( xTcPusL.usiSubType ) {
							case 3: // TC_SCAMxx_MEB_STATUS_DUMP
								ucFFeeInstL = PreParsedLocal.usiValues[6];
								if ( BCHECK_FEE_PARAM(ucFFeeInstL) ) {
									unsigned int uiEPinMilliSeconds;
									unsigned int uiRTinMilliSeconds;
									tTMPus xTmPusL;
									xTmPusL.usiPusId = xTcPusL.usiPusId;
									xTmPusL.usiPid = xTcPusL.usiPid;
									xTmPusL.usiCat = xTcPusL.usiCat;
									xTmPusL.usiType = 254;
									xTmPusL.usiSubType = 4;
									xTmPusL.ucNofValues = 0;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = xSimMeb.eMebRealMode; /* MEB operation MODE */
									xTmPusL.ucNofValues++;
									uiEPinMilliSeconds = xSimMeb.usiEP;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = uiEPinMilliSeconds >> 16; 	/* EP in Milliseconds 1st Word */
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = uiEPinMilliSeconds;		/* EP in Milliseconds 2nd Word */
									xTmPusL.ucNofValues++;
									uiRTinMilliSeconds = xSimMeb.usiRT;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = uiRTinMilliSeconds >> 16; 	/* RT in Milliseconds 1st Word */
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = uiRTinMilliSeconds;		/* RT in Milliseconds 2nd Word */
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = xSimMeb.eSync;				/* Sync Source				  */
									xTmPusL.ucNofValues++;
									vSendPusTM512(xTmPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							case 8: // TC_SCAMxx_FEE_STATUS_DUMP
								ucFFeeInstL = PreParsedLocal.usiValues[6];
								if ( BCHECK_FEE_AEB_PARAM(ucFFeeInstL) ) {
									unsigned char ucFFeeInst = ucFFeeInstL/N_OF_CCD;
									unsigned char ucAebInst = ucFFeeInstL%N_OF_CCD;
									unsigned short int usiSPWStatus;
									
									tTMPus xTmPusL;
									xTmPusL.usiPusId = xTcPusL.usiPusId;
									xTmPusL.usiPid = xTcPusL.usiPid;
									xTmPusL.usiCat = xTcPusL.usiCat;
									xTmPusL.usiType = 254;
									xTmPusL.usiSubType = 9;
									xTmPusL.ucNofValues = 0;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = ucFFeeInstL;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues] = (xSimMeb.xFeeControl.xFfee[ucFFeeInst].xControl.xDeb.eDebRealMode & 0xFF) << 0x08;
									xTmPusL.usiValues[xTmPusL.ucNofValues] |= (xSimMeb.xFeeControl.xFfee[ucFFeeInst].xControl.xAeb[ucAebInst].eState & 0xFF);
									xTmPusL.ucNofValues++;
									if (TRUE == xSimMeb.xFeeControl.xFfee[ucFFeeInst].xChannel[ucAebInst].xSpacewire.xSpwcLinkStatus.bStarted){
										usiSPWStatus = eAebSpwStarted;
									} else if (TRUE == xSimMeb.xFeeControl.xFfee[ucFFeeInst].xChannel[ucAebInst].xSpacewire.xSpwcLinkStatus.bConnecting) {
										usiSPWStatus = eAebSpwConnecting;
									} else if (TRUE == xSimMeb.xFeeControl.xFfee[ucFFeeInst].xChannel[ucAebInst].xSpacewire.xSpwcLinkStatus.bRunning) {
										usiSPWStatus = eAebSpwRunning;
									} else if (TRUE == xSimMeb.xFeeControl.xFfee[ucFFeeInst].xChannel[ucAebInst].xSpacewire.xSpwcLinkConfig.bAutostart) {
										usiSPWStatus = eAebSpwDisconnectedAutoStart;
									} else {
										usiSPWStatus = eAebSpwDisconnected;
									}
									xTmPusL.usiValues[xTmPusL.ucNofValues] = usiSPWStatus;
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Incoming packets 1 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Incoming packets 2 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Outgoing packets 1 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Outgoing packets 2 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Number of fails  1 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Number of fails  2 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Last Error       1 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Last Error       2 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Last Error Time  1 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Last Error Time  2 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Last Error Time  3 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Warning ID       1 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Warning ID       2 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Warning ID Time  1 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Warning ID Time  2 Word*/
									xTmPusL.ucNofValues++;
									xTmPusL.usiValues[xTmPusL.ucNofValues]=0; /*Warning ID Time  3 Word*/
									xTmPusL.ucNofValues++;
									vSendPusTM512(xTmPusL);
								} else {
									#if DEBUG_ON
									if ( xDefaults.ucDebugLevel <= dlCriticalOnly )
										fprintf(fp, "Parser Task: Doesn't exist the Fee/Aeb Instance number: %hu;\n", ucFFeeInstL );
									#endif
								}
								break;
							default:
							#if DEBUG_ON
							if ( xDefaults.ucDebugLevel <= dlMinorMessage )
								fprintf(fp, "Parser Task: Default - TC-> srv-type: %hu; srv-subtype: %hu; pus-id: %hu;\n", xTcPusL.usiType, xTcPusL.usiSubType, xTcPusL.usiPusId );
							#endif
							eParserMode = sWaitingMessage;
						}
						break;
                    default:
						eParserMode = sWaitingMessage;
                }
				break;
			default:
				eParserMode = sWaitingMessage;
		}
	}
}

bool getPreParsedPacket( tPreParsed *xPreParsedParser ) {
    bool bSuccess = FALSE;
    INT8U error_code;
    unsigned char i;

	OSMutexPend(xMutexPreParsed, 0, &error_code); /*Blocking*/
	if (error_code == OS_ERR_NONE) {
		/* Got the Mutex */
		/*For now, will only get the first, not the packet that is waiting for longer time*/
		for( i = 0; i < N_PREPARSED_ENTRIES; i++)
		{
            if ( xPreParsed[i].cType != 0 ) {
                /* Locate a filled PreParsed variable in the array*/
            	/* Perform a copy to a local variable */
            	(*xPreParsedParser) = xPreParsed[i];
                bSuccess = TRUE;
                xPreParsed[i].cType = 0;
                break;
            }
		}
		OSMutexPost(xMutexPreParsed);
	} else {
		/* Couldn't get Mutex. (Should not get here since is a blocking call without timeout)*/
		vFailGetxMutexPreParsedParserRxTask();
	}
	return bSuccess;
}


/* Search for some free location in the xPus array to put the full command to send to the meb task */
bool bSendMessagePUStoMebTask( tTMPus *xPusL ) {
    bool bSuccess;
    INT8U error_code;
    tQMask xCdmLocal;
    unsigned char i = 0;

    bSuccess = FALSE;
    xCdmLocal.ulWord = 0;
    OSMutexPend(xMutexPus, 10, &error_code); /* Try to get mutex that protects the xPus buffer. Wait max 10 ticks = 10 ms */
    if ( error_code == OS_NO_ERR ) {

        for(i = 0; i < N_PUS_PIPE; i++)
        {
            if ( xPus[i].bInUse == FALSE ) {
                /* Locate a free place*/
                /* Need to check if the performance is the same as memcpy*/
            	xPus[i] = (*xPusL);
            	xPus[i].bInUse = TRUE;

            	/* Build the command to Meb using the Mask Queue */
            	xCdmLocal.ucByte[3] = M_MEB_ADDR;
            	xCdmLocal.ucByte[2] = Q_MEB_PUS;

            	/* Sync the Meb task and tell that has a PUS command waiting */
            	error_code = OSQPost(xMebQ, (void *)xCdmLocal.ulWord);
                if ( error_code != OS_ERR_NONE ) {
                	vFailSendPUStoMebTask();
                	xPus[i].bInUse = FALSE;
                } else
                    bSuccess = TRUE;
                break;
            }
        }
        OSMutexPost(xMutexPus);
    }
    return bSuccess;
}
