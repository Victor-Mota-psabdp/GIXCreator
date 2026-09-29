SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--,FORMAT(CP.DT_COURIER, 'dd/MM/yy')
					
CREATE VIEW [dbo].[DW_TRANS_CURRENT]
AS
	SELECT
		HOU.Num_Proc_HEM															[FRWDR_REF_NBR]
		,FORMAT(TP59.Dt_Conclusao , 'dd/MM/yy')										[ADVANCEMENT_REQ_DT]--I think it is 59 - -Solicitação de Numerário - <StatusType type="AdvancementReqDt"/>
		,NULL																		[AFRMM_PAYMENT_DT]
		,FORMAT( TP161.Dt_Conclusao , 'dd/MM/yy')									[ARR_DT]--i think is 161	DEPÓSITO CONTAINER NO TERMINAL	EA	S	-7	ETD	NULL	AtTerminalDate
		,isnull(GRP.Smart_Exp,HOU.Cd_Export_HEM)									[BDP_CLIENT_CD] -- spIntPessoa_Sel I = Smart_Imp,E = Smart_Exp <Request><Header><References type="ClientCode"><ReferenceNumber></ReferenceNumber>
		,FORMAT( TP40.Dt_Conclusao , 'dd/MM/yy')									[BDP_INVC_ACT_DT]	--Smart_Conclusao - spSmartBilledDate_Sel -   <Request><Header><Status><StatusType type="BilledDate"></StatusType>
		,FORMAT( TP40.Dt_Conclusao , 'dd/MM/yy')									[BDP_INVC_ACT_DTM]
		,[dbo].[fDW_BDP_INVC_REF_NBR](HOU.Num_Proc_HEM)									[BDP_INVC_REF_NBR]
		,NULL																		[BDP_REP_PRTY_ID]
		,LEFT(HOU.NUM_PROC_HEM,1)													[BDP_SERVICE_CD]--<Request><Header Type="Export"></Header ></Request> then E
		,'01BDPBRSAO' 																[BDP_SS_ID]
		,(CASE WHEN HOU.Num_Proc_MEM <> 'JOB' THEN 'Y' ELSE
			(CASE WHEN ARM.SCAC = 'BOPT' THEN 'Y' ELSE
				(CASE WHEN ARM.SCAC = 'SBHG' THEN 'S' ELSE
					'N'
				END)
			END)
		END)																		[BDP_TRANS_IND] --"IIF(rtrim(ltrim(CARR_SCAC_CD))='BOPT', 'Y',IIF(rtrim(ltrim(CARR_SCAC_CD))='SBHG', 'S', 'N'))"	
		,(CASE WHEN HOU.Tp_Frete_HEM = 'P' THEN HOU.Vlr_Frete_Tot_HEM 
			ELSE '0.00' END)														[BF_BOL_AWB_PRPD_AMT]--<Request><Header><Amounts><AmountType>BaseFreightBolAwbAmountPrepaid</AmountType></Amounts></Header></Request>
		,FORMAT( TP5.Dt_Conclusao , 'dd/MM/yy')										[BKNG_CNFRM_DT]
		,FORMAT( TP217.Dt_Conclusao , 'dd/MM/yy')									[BOL_POST_AUDT_BCK_DT]	--Smart_Conclusao - <Request><Header><Status><StatusType type="BOLBackDate"></StatusType>		
		,FORMAT( TP217.Dt_Conclusao , 'dd/MM/yy')									[BOL_POST_AUDT_BCK_DTM]		
		,FORMAT( TP66.Dt_Conclusao , 'dd/MM/yy')									[BOL_PRE_AUDT_RCV_DT]	-- Code - 66	Envio do draft do BL--<Request><Header><Status><StatusType type="BillofLadingRetreivedDate"></StatusType>
		,FORMAT( TP66.Dt_Conclusao , 'dd/MM/yy')									[BOL_PRE_AUDT_RCV_DTM]
		,FORMAT( TP5.Dt_Conclusao , 'dd/MM/yy')										[BKNG_CNFRMTN_RCVD_FROM_SS_DT]
		,FORMAT( TP58.Dt_Conclusao , 'dd/MM/yy')									[BKNG_DT]
		,FORMAT( TP58.Dt_Conclusao , 'dd/MM/yy')									[BKNG_DTM]
		,(CASE WHEN HOU.num_proc_mem = 'JOB' THEN JOB.Nr_Reserva ELSE HOU.Num_Proc_HEM END)	[BKNG_NBR]--HouseBookingNumber
		,FORMAT(DL_Cargo_Lem, 'dd/MM/yy')											[BOL_ACTN_DT]--talvez só EM
		,FORMAT(LLP.Dt_BL_Lem	, 'dd/MM/yy')										[BOL_AWB_ISS_DT]
		,HOU.HAWB_HEM																[BOL_AWB_NBR] --HouseBillofLadingNumber-- HouseAirwayBill- verificar
		--,FORMAT( TP45.Dt_Conclusao , 'dd/MM/yy')									[BOL_SBMT_DT]-- Smart_Conclusao45	Envio Shipping <Request><Header><Status><StatusType type="BOLSubmitDate"></StatusType></Status></Header></Request>
		,FORMAT(LLP.Dt_BL_Lem	, 'dd/MM/yy')										[BOL_SBMT_DT]
		,FORMAT(LLP.Dt_BL_Lem	, 'dd/MM/yy')										[BOL_SBMT_DTM]
		,NULL																		[BYR_PRTY_ID]
		--"<Request><Header><References type=""CargoType""><ReferenceNumber></ReferenceNumber></References></Header></Request>Request><Header>
		,(CASE WHEN LEFT(HOU.Num_Proc_HEM,2) = 'IM' or LEFT(hou.Num_Proc_HEM,2) = 'EM' THEN TC.Nome_Tp_Carga ELSE 'LCL' END)	[CARGO_TYP]
		,FORMAT( LLP.DL_Draft_Lem , 'dd/MM/yy')										[CARRIER_DOC_CUTOFF_DT]--<Request><Header><Status><StatusType type="CarrierDocCutoffDate"></StatusType>

		,FORMAT(LLP.DL_Draft_Lem , 'dd/MM/yy')										[CARRIER_DOC_CUTOFF_DTM]--<Request><Header><Status><StatusType type="CarrierDocCutoffDate"></StatusType>		
		,NULL																		[CHB_REF_NBR]--<Request><Header><References type="ClearingAgentReferenceNumber"><ReferenceNumber></ReferenceNumber>
		,NULL																		[CHRG_WGHT_QTY] --EA e IA
		,LEFT([dbo].[RemoveNonAlphaCharacters](NG.Descr),100)						[CARGO_DESC]--CargoDescription <Request><Header><CodesNames><CodesNamesType></CodesNamesType></CodesNames></Header></Request>
		,(CASE WHEN HOU.Num_Proc_MEM <> 'JOB' THEN 'BDP TRANSPORT, INC' ELSE
		UPPER(ARM.Nome_Armador)	END)												[CARR_NM]--If Request/Header/Transportation MethodofTransportation  is  Air and   <Request><Header><Transportation><Carrier><CarrierName></CarrierName></Carrier></Transportation></Header></Request>
		,FORMAT( TP21.Dt_Conclusao, 'dd/MM/yy')										[CARR_PYMNT_DT]--NOt Mapped in The File
		,(CASE WHEN HOU.Num_Proc_MEM <> 'JOB' THEN 'BOPT' ELSE ARM.SCAC END)		[CARR_SCAC_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First"" thenIf Request/Header/Transportation/Carrier/CarrierCode/type is not equal to null then <Request><Header><Transportation><Carrier><CarrierCode></CarrierCode></Carrier></Transportation></Header></Request>"		
		,NULL																		[CHB_PRTY_ID]
		,NULL																		[CHRG_RATE_AMT]
		,isnull(GRP.Smart_Exp,HOU.Cd_Export_HEM)+HOU.Cd_Export_HEM					[CLNT_CD] --<Request><Header><References type=""BDPClientCode""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,(CASE WHEN hou.Num_Proc_MEM <> 'JOB'  AND substring(hou.Num_Proc_MEM,3,3) <> 'CLI' THEN 'C' ELSE 'D' END)		[CNSOL_DRCT_CD]--"<Request><Header><References type=""ConsolIndicator""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,(CASE WHEN hou.Num_Proc_MEM <> 'JOB'  THEN hou.Num_Proc_MEM ELSE NULL END)  [CNSOL_NBR] --<Request><Header><References type=""ConsolNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,[dbo].[fDW_CNTNR_EQUIP_CT](HOU.Num_Proc_HEM)								[CNTNR_EQUIP_CT]--<Request><Header><EquipmentSummary><EquipmentQuantity><EquipmentQuantity></EquipmentSummary></Header></Request>
		,[dbo].[fDW_CNTNR_TYP_CD](HOU.Num_Proc_HEM,1)	[CNTNR_TYP_CD_1]--"From 1st Occurence of EquipmentSummary <Request><Header><EquipmentSummary><EquipmentDescription></EquipmentDescription></EquipmentSummary></Header></Request>"
		,[dbo].[fDW_CNTNR_TYP_CD](HOU.Num_Proc_HEM,2)	[CNTNR_TYP_CD_2]--"From 2nd Occurence of EquipmentSummary<Request><Header><EquipmentSummary><EquipmentDescription></EquipmentDescription></EquipmentSummary></Header></Request>"
		,[dbo].[fDW_CNTNR_TYP_CD](HOU.Num_Proc_HEM,3)	[CNTNR_TYP_CD_3]--"From 3rd Occurence of EquipmentSummary<Request><Header><EquipmentSummary><EquipmentDescription></EquipmentDescription></EquipmentSummary></Header></Request>"
		,HOU.Cd_Consig_HEM															[CONSG_PRTY_CD]
		,NULL																		[CONSG_PRTY_ID]
		,NULL																		[CSTMS_ENTRY_PRMT_NBR]-- Only IM<Request><Header><References type=""CustomsEntryNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,FORMAT( TP4.Dt_Conclusao, 'dd/MM/yy')										[CSTMS_ENTRY_PRMT_REL_DT]
		,FORMAT( TP4.Dt_Conclusao, 'dd/MM/yy')										[CSTMS_ENTRY_PRMT_REL_DTM]
		,FORMAT( PO4.Data_PO_HEM, 'dd/MM/yy')										[CSTMS_ENTRY_PRMT_SBMT_DT]--Code - "<Request><Header><Status><StatusType type=""CustomsEntryPermitSubmissionDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																		[CSTMS_ENTRY_PRT_NM]-- Only IM ,EO,IO
		,NULL																		[CSTMS_ENTRY_PRT_UNLOC_CD]-- Only IM ,EO,IO
		,LEFT(UPPER(LLP.Canal_Lem),2)												[CSTMS_ENTRY_TYP_CD]--"<Request><Header><References type=""CustomsEntrytypeCode""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																		[CSTMS_PRT_ACT_DT]
		,NULL																		[CSTMS_PRT_EST_DT]
		,NULL																		[CSTMS_RLS_DT] --If Request/Header Type="Import"<Request><Header><Status><StatusType type="CustomsReleaseDate"></StatusType>           <StatusDate></StatusDate></Status></Header></Request>
		,NULL																		[CSTMS_RLS_DTM]
		,[dbo].[fDW_CUSTOMER_CSR_NM](HOU.Num_Proc_HEM)								[CUSTOMER_CSR_NM]--spCSRJob_SEL - <Request><Header><Parties><Party-Contacts type="CSR"><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
		,UPPER(DST.Cd_Pais)															[DEST_CNTRY_CD]--If Request/Header/Transportation LegType="Primary" or "First"<Request><Header><Transportation><DestinationCountryCode></DestinationCountryCode></Transportation></Header></Request>
		,UPPER(DSTPais.Nome_Pais)													[DEST_CNTRY_NM]
		,UPPER(DST.Cd_Pais)															[DEST_CNTRY_UNLOC_CD]
		,NULL																		[DEST_DEL_ACT_DT]---- Only Import ID_Task 13 Dt_Conclusao --<Request><Header><Status><StatusType type="ActDestinationDeliveryDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,NULL																		[DEST_DEL_ACT_DTM]
		,NULL																		[DEST_DEL_EST_DT]---- Only Import ID_Task 13 Dt_Previsao--<Request><Header><Status><StatusType type="EstDestinationDeliveryDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,NULL																		[DEST_DEL_EST_DTM]
		,NULL																		[DEST_INL_CARR_NM]--NOt SENt<Request><Header><References type="DestinationInlandCarrier"><ReferenceNumber></ReferenceNumber></References></Header></Request>--<Request><Header><Transportation><ReferenceType type="DestinationInlandCarrier"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,NULL																		[DEST_INL_CARR_SCAC_CD]--NOt SENt<Request><Header><References type="DestinationInlandCarrier"><ReferenceNumber></ReferenceNumber></References></Header></Request>--<Request><Header><Transportation><ReferenceType type="DestinationInlandCarrier"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,NULL																		[DLVRY_ORDR_CREATN_DT_ACT_DT]--Only Import ID_Task 7 Dt_Conclusao <Request><Header><Status><StatusType type="ActDeliveryOrderCreationDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,NULL																		[DLVRY_ORDR_DISTRIB_DT_ACT_DT]--Only Import ID_Task 7 Dt_Conclusao <Request><Header><Status><StatusType type="ActDeliveryOrderDistributionDate"></StatusType><StatusTime></StatusTime></Status></Header></Request>
		,FORMAT(DATEADD(day,-1, TP66.Dt_Conclusao ), 'dd/MM/yy')					[DOC_DIST_RCV_ACT_DT]--Code Only EM  ID_Task 66 Dt_Conclusao
		,FORMAT(DATEADD(day,-1, TP66.Dt_Conclusao ), 'dd/MM/yy')					[DOC_DIST_RCV_ACT_DTM]--Code Only EM  ID_Task 66 Dt_Conclusao
		,FORMAT( TP12.Dt_Conclusao , 'dd/MM/yy')									[DOC_DIST_SEND_ACT_DT]
		,FORMAT( TP12.Dt_Conclusao , 'dd/MM/yy')									[DOC_DIST_SEND_ACT_DTM]
		,FORMAT( TP12.Dt_Previsao , 'dd/MM/yy')										[DOC_DIST_SEND_EST_DT]
		,FORMAT( TP12.Dt_Previsao , 'dd/MM/yy')										[DOC_DIST_SEND_EST_DTM]
		,NULL																		[DOC_DIST_BY_NM]
		,NULL																		[DOCK_RCPT_CRTN_DT]--Only Import ID_Task 109 Dt_Conclusao--<Request><Header><Status><StatusType type="DockReceiptCreationDate"></StatusType></Status></Header></Request>
		--,FORMAT( TP66.Dt_Conclusao , 'dd/MM/yy')									[DRAFT_BOL_INSTR_RECVD_DT]--Only EM  ID_Task 66 Dt_Conclusao--<Request><Header><Status><StatusType type="DraftBOLInstrRecvdDt"></StatusType></Status></Header></Request>
		,isnull(FORMAT( TP50.Dt_Conclusao , 'dd/MM/yy'),FORMAT( TP66.Dt_Conclusao , 'dd/MM/yy')	)	[DRAFT_BOL_INSTR_RECVD_DT]--Only EM  ID_Task 50	Recebimento do processo/ordem Dt_Conclusao--<Request><Header><Status><StatusType type="DraftBOLInstrRecvdDt"></StatusType></Status></Header></Request>
		,NULL																		[ENTRY_IMM_DEL_RCV_DT]
		,NULL																		[ENTRY_IMM_DEL_RCV_DTM]
		,NULL																		[ENTRY_SUMM_SBMT_DT]--Not Sent"<Request><Header><Status><StatusType type=""EntrySummaryRejectDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																		[ENTRY_SUMM_SBMT_DTM]
		,FORMAT(LLP.ATD_LEM, 'dd/MM/yy')											[EXIT_CITY_ACT_DT]
		,UPPER(ORG.Cd_Pais)															[EXP_CNTRY_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First""  <Request><Header><Transportation><OriginCountryCode></OriginCountryCode></Transportation></Header></Request>"
		,UPPER(ORG.Cd_Pais)															[EXP_CNTRY_UNLOC_CD]
		,HOU.Num_Proc_HEM															[EXPRT_JOB_NBR]
		,NULL																		[EXPTR_SHPR_PRTY_CD]
		,NULL																		[EXPTR_SHPR_PRTY_ID]
		,NULL																		[FEU_QTY]--<Request><Header><Amounts><AmountType>NumberOfFEUs</AmountType></Amounts></Header></Request>
		,FORMAT( TP12.Dt_Conclusao , 'dd/MM/yy')									[FILE_CLS_DT]	--"<Request><Header><Status><StatusType type=""ClosedDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( TP12.Dt_Conclusao , 'dd/MM/yy')									[FILE_CLS_DTM]
		,NULL																		[FILE_CREATED_BY_NM]
		--,FORMAT(CONVERT(datetime, HOU.Dt_Emis_HEM , 102), 'dd/MM/yy')				[FILE_CRTN_DT]--"<Request><Header><Status><StatusType type=""FileCreationDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,CONVERT(VARCHAR(8), CONVERT(DATE, HOU.Dt_Emis_HEM, 103), 3)				[FILE_CRTN_DT]
		--, HOU.Dt_Emis_HEM 														[FILE_CRTN_DT]
		,CONVERT(VARCHAR(8), CONVERT(DATE, HOU.Dt_Emis_HEM, 103), 3)				[FILE_CRTN_DTM]
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')									[FINAL_GOODS_ISS_DT]
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')									[FINAL_GOODS_ISS_DTM]
		,NULL																		[FRWDR_PRTY_ID]
		--,HOU.Num_Proc_HEM															[FRWDR_REF_NBR]	--"<Request><Header><References type=""BDPJobNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"		--"<Request><Header><References type=""ExportForwarderRefNbr""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"		--"<Request><Header><References type=""ImportForwarderRefNbr""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																		[GE_DIVISION_CD]
		,NULL																		[GE_GROUP_CD]
		,NULL																		[GE_SBU_CD]
		,Exporter.GLOBAL_ENTITY_ID													[GEID]--"<Request><Header><Parties type=""Exporter""><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>"--"<Request><Header><Parties type=""Importer""><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>"
		,NULL																		[GLBL_AGNT_PRTY_ID]
		,UPPER(replace(replace(replace(ltrim(rtrim(HOU.Obs_HEM)),char(10),' '),char(13),' '),char(160),' ')) [GNRL_DESC]--"<Request><Header><References type=""GeneralDescription""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')									[GOODS_AVLBL_SHP_ACT_DT]--ONly for EA,EM,EO,IOActualPlantShipDate --"If the file is not  Meridian If <Request><Header><Status><StatusType type=""ActGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		<Request><Header><Status><StatusType type=""ActualPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')									[GOODS_AVLBL_SHP_ACT_DTM]
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')										[GOODS_AVLBL_SHP_EST_DT] --ONly for EA,EM,EO,IO	--"<Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"	--"If the file is not for Meridian 		--If <Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		--<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"		--"If the file is not for Meridian		--If <Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		--<Request><Header><Status><StatusType type=""EstimatedShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')										[GOODS_AVLBL_SHP_EST_DTM]
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')										[GOV_EXP_PRMSS_RLS_DT]--ONly for EA,EM,EO - "If Request/Header Type=""Export""<Request><Header><Status><StatusType type=""CustomsReleaseDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')										[GOV_EXP_PRMSS_RLS_DTM]
		,ISNULL(PO12.Numero_PO_HEM,PO204.Numero_PO_HEM)								[GOV_EXP_PRMSS_RLS_NBR]--ONly for EA,EM,EO"<Request><Header><References type=""GovernmentPermissionToExportReleaseNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																		[GOV_EXP_PRMSS_SBMT_DT]--Not Send -"If Request/Header Type=""Export""   <Request><Header><Status><StatusType type=""CustomsSubmitDate""></StatusType>           <StatusDate></StatusDate></Status></Header></Request>"
		,NULL																		[GOV_EXP_PRMSS_SBMT_DTM]
		,NULL																		[GOV_EXP_PRMSS_SBMT_NBR]
		,FORMAT( PO4.Data_PO_HEM, 'dd/MM/yy')										[GOV_PYMNT_STMNT_SBMT_DT]--IMP ID_DC 5, EXP-ID-DC 4<Request><Header><Status><StatusType type="GovernmentPaymentStatementSubmissionDate"></StatusType></Status></Header></Request>
		,FORMAT( PO4.Data_PO_HEM, 'dd/MM/yy')										[GOV_PYMNT_STMNT_SBMT_DTM]

		,HOU.Peso_Bruto_HEM															[GROSS_TRANS_KILO_QTY]--"<Request><Header><Detail><ProductDetail><Measurements type=""GrsWtKgs""><MeasurementValue></MeasurementValue></Measurements></ProductDetail></Detail></Header></Request>"
		,HOU.Peso_Bruto_HEM * 2.2046												[GROSS_TRANS_POUND_QTY]
		,NULL																		[IMPORT_DCLRTN_DRFT_DT]
		,NULL																		[IMPORT_LIC_NEEDED_IND]
		,NULL																		[IMPTR_PRTY_CD]
		,NULL																		[IMPTR_PRTY_ID]
		,NULL																		[INSPECTN_DT_ACT_DT]
		,HOU.tp_frete_hem															[INTL_FRGHT_TERM_CD]--<Request><Header><Transportation><PrepaidorCollect></PrepaidorCollect></Transportation></Header></Request>
		,UPPER(ISNULL(DSTFNL.Nome_Local,DST.Nome_Local))							[ITS_PLACE_OF_DLVRY_NM]	--"If Request/Header/Transportation MethodofTransportation  is not Air and  If <Request><Header><Transportation><Destination LocationType=""PlaceofDelivery""><DestinationName></DestinationName> </Destination></Transportation></Header></Request>"
		,UPPER(ISNULL(ORGPLNT.Nome_Local,ORG.Nome_Local))							[ITS_PLACE_OF_RCPT_NM]
		,UPPER(DST.Nome_Local)														[ITS_PORT_OF_DSCHRG_NM]
		,NULL																		[ITS_PORT_OF_ENTRY_NM]
		,UPPER(ORG.Nome_Local)														[ITS_PORT_OF_LOAD_NM]
		,UPPER(ISNULL(ORGPLNT.Nome_Local,ORG.Nome_Local))							[ITS_PORT_OF_ORGN_NM]
		,FORMAT( [dbo].[fDW_LAST_MDFD_BY_DT](HOU.Num_Proc_HEM), 'dd/MM/yy')		[LAST_MDFD_BY_DT]--"<Request><Header><Status><StatusType type=""LastModifiedByDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,(CASE WHEN PO71.Numero_PO_HEM is not null THEN 'Y' ELSE 'N' END)			[LETTR_OF_CRDT_IND]--<Request><Header><LetterofCredit><RequiredYN></RequiredYN></LetterofCredit></Header></Request>
		,NULL	[LQDTN_DT]--Only Import Data da DI and id_dc=5 --<Request><Header><Status><StatusType type="LiquidationDate"></StatusType></Status></Header></Request>
		,FORMAT(DL_Cargo_Lem, 'dd/MM/yy')											[LTST_DEL_CUTOFF_DT] -- Ony FOR EM --<Request><Header><Status><StatusType type=""LatestDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT(DL_Cargo_Lem, 'dd/MM/yy')											[LTST_DEL_CUTOFF_DTM]-- Ony FOR EM--<Request><Header><Status><StatusType type=""LatestDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"


		,NULL																		[MANIFEST_DT]
		,NULL																		[MANUF_PLNT_PRTY_ID]
		,NULL																		[MBOL_ACTN_DT]--Not Send--<Request><Header><FileStatus><Code>"MbolActionDate"</Code></FileStatus></Header></Request>
		,HOU.MAWB_HEM																[MBOL_MAWB_NBR]--If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""MasterBillofLadingNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,NULL																		[MBOL_RCV_DT]
		,NULL																		[MBOL_RCV_DTM]
		,'V'																		[MOT_CD]--" Request><Header><Transportation MethodofTransportation= ""V""></Transportation></Header></Request>
		,NULL																		[MOVE_TYP_CD]
		,(CASE WHEN HOU.cd_tp_oper='DDP' or HOU.cd_tp_oper='DDU' THEN 'DOOR TO DOOR' ELSE 
		(CASE WHEN HOU.cd_tp_oper='FOB' or HOU.cd_tp_oper='FCA' THEN 'PORT TO PORT' ELSE 'DOOR TO PORT' END)END)	[MOVE_TYP_DESC]--Request><Header><Transportation><TypeofMoveCode Type="DP"></TypeofMoveCode></Transportation></Header></Request>---<Request><Header><Transportation><TypeofMoveDescription></TypeofMoveDescription></Transportation></Header></Request>

		,JOB.Nr_Reserva																[MSTR_BKNG_NBR]-- If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""BookingNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
		
		,(CASE WHEN hou.Num_Proc_MEM <> 'JOB'  AND substring(hou.Num_Proc_MEM,3,3) <> 'CLI'
			THEN UPPER(ARM.Nome_Armador) ELSE NULL END)								[MSTR_CARR_NM]
				,(CASE WHEN hou.Num_Proc_MEM <> 'JOB'  AND substring(hou.Num_Proc_MEM,3,3) <> 'CLI'
			THEN UPPER(ARM.SCAC) ELSE NULL END)										[MSTR_CARR_SCAC_CD]
		
		,HOU.Peso_Liquido_HEM														[NET_TRANS_KILO_QTY]--<Request><Footer><Measurements item="NetWtKgs"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>-<Request><Footer><Measurements item="NetWeightKilograms"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,HOU.Peso_Liquido_HEM * 2.2046												[NET_TRANS_POUND_QTY]--<Request><Footer><Measurements item="NetWeightPounds"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,NULL																		[NF_COMPLIMENTARY_DT]
		,NULL																		[NF_DRFT_DT]
		,NULL																		[NTFY_PRTY_ID]
		,FORMAT(LLP.ATD_LEM, 'dd/MM/yy')											[ONBRD_CONFRM_DT]--If Request/Header/Transportation LegType=""Primary"" or ""First"" 	and If Request/Header/Transportation MethodofTransportation  is ""Ocean"" or ""V"" or ""Barge"" or ""B"" or ""C"" Request><Header><Transportation><OriginDate Type=""Actual""></OriginDate></Transportation></Header></Request>"
		,FORMAT(LLP.ATD_LEM, 'dd/MM/yy')											[ONBRD_CONFRM_DTM]
		,FORMAT( TP160.Dt_Conclusao , 'dd/MM/yy')									[OPEN_GATE_DT] -- Only EM 160
		,(CASE WHEN CP32.Campo_DADOS = '2' THEN 'FFD' ELSE 'CHB' END)				[OPRTG_UNT_CL_CD]--<Request><Header><References type=""OperatingUnitClassification""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,left([dbo].[fDW_ORDR_TYP_CD](HOU.Num_Proc_HEM),1)							[ORDR_TYP_CD]--<Request><Header><References type="OrderType"><ReferenceNumber></ReferenceNumber></References></Header></Request>		--<Request><Header><Transportation><ReferenceType type="OrderType"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,FORMAT(LLP.ATD_LEM, 'dd/MM/yy')											[ORGN_CITY_ACT_DT]--<Request><Header><Amounts><AmountType>ActCityOfOriginDate</AmountType></Amounts></Header></Request>
		,UPPER(ORG.cd_pais)															[ORGN_CNTRY_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First"" <Request><Header><Transportation><OriginCountryCode></OriginCountryCode></Transportation></Header></Request>"
		,UPPER(ORGPais.Nome_Pais)													[ORGN_CNTRY_NM]
		,UPPER(ORG.Cd_Pais)															[ORGN_CNTRY_UNLOC_CD]
		,FORMAT( TP5.Dt_Conclusao , 'dd/MM/yy')										[ORGN_INL_BOOK_ACT_DT]
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')									[ORGN_INL_DEL_ACT_DT]--<Request><Header><Status><StatusType type="ActDomesticInlandDeliveryDate"></StatusType></Status></Header></Request>
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')									[ORGN_INL_DEL_ACT_DTM]
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')										[ORGN_INL_DEL_EST_DT]--<Request><Header><Status><StatusType type="EstDomesticInlandDeliveryDate"></StatusType></Status></Header></Request>
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')										[ORGN_INL_DEL_EST_DTM]
		,UPPER(ORGPLNT.Nome_Local)													[ORGN_INL_LOCTN_NM]
		,(CASE WHEN ORGPLNT.SCAC is null THEN ORGPLNT.Cd_Pais+ORGPLNT.Cd_Local 
			ELSE ORGPLNT.Cd_Pais + ORGPLNT.SCAC END)								[ORGN_INL_LOCTN_UNLOC_CD]

		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')									[ORGN_INL_PCKP_ACT_DT]--10	EA,10	EM,10	EO - "If the file is not for Meridian If <Request><Header><Status><StatusType type=""ActGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')									[ORGN_INL_PCKP_ACT_DTM]
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')										[ORGN_INL_PCKP_EST_DT]--<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')										[ORGN_INL_PCKP_EST_DTM]
		,NULL																		[ORGN_PORT_NM]--if Request/Header/Transportation MethodofTransportation  is not Air and <Request><Header><Transportation><ReferenceType type=""OriginPort""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
		,NULL																		[ORGN_PORT_UNLOC_CD]--If Request/Header/Transportation LegType=""Primary"" or ""First"" then If Request/Header/Transportation/OriginCodeType/type = ""IATA"" or ""IATACode"" then		--<Request><Header><Transportation><OriginCodeType><OriginCode></OriginCode></OriginCodeType></Transportation></Header></Request>"
		,FORMAT( TP13.Dt_Conclusao , 'dd/MM/yy')									[PLACE_OF_DEL_ACT_DT]----<Request><Header><Status><StatusType type=""ActPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"--<Request><Header><Status><StatusType type=""ActualPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																		[PLACE_OF_DEL_ACT_DTM]
		,FORMAT( TP13.Dt_Previsao , 'dd/MM/yy')										[PLACE_OF_DEL_EST_DT]--"<Request><Header><Status><StatusType type=""EstimatedPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"--<Request><Header><Status><StatusType type=""EstPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( TP13.Dt_Previsao , 'dd/MM/yy')										[PLACE_OF_DEL_EST_DTM]
		,UPPER(DSTFNL.Nome_Local)													[PLACE_OF_DEL_NM]----"Request><Header><References type=""PlaceofDelivery Name""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="PlaceofDelivery Name"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,(CASE WHEN DSTFNL.SCAC is null THEN DSTFNL.Cd_Pais+DSTFNL.Cd_Local
			ELSE DSTFNL.Cd_Pais + DSTFNL.SCAC END)									[PLACE_OF_DEL_UNLOC_CD]

		,(CASE WHEN FORMAT(isnull(TP10.Dt_Conclusao,getdate()) , 'dd/MM/yy') = FORMAT(isnull(LLP.ATD_Lem,getdate()), 'dd/MM/yy')  
				then FORMAT(TP10.Dt_Conclusao , 'dd/MM/yy')	
				else FORMAT(DATEADD(day,1,TP10.Dt_Conclusao ),'dd/MM/yy') end)									[PLACE_OF_RCPT_ACT_DT]--"<Request><Header><Status><StatusType type=""ActPlaceofReceiptDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"

		,(CASE WHEN FORMAT(isnull(TP10.Dt_Conclusao,getdate()) , 'dd/MM/yy') = FORMAT(isnull(LLP.ATD_Lem,getdate()), 'dd/MM/yy') 
				then FORMAT(TP10.Dt_Previsao , 'dd/MM/yy')	
				else FORMAT(DATEADD(day,1,TP10.Dt_Previsao ),'dd/MM/yy') end)		[PLACE_OF_RCPT_EST_DT]--"<Request><Header><Status><StatusType type=""EstPlaceofReceiptDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"

		,(CASE WHEN FORMAT(isnull(TP10.Dt_Conclusao,getdate()) , 'dd/MM/yy') = FORMAT(isnull(LLP.ATD_Lem,getdate()), 'dd/MM/yy') 
				then FORMAT(TP10.Dt_Previsao , 'dd/MM/yy')	
				else FORMAT(DATEADD(day,1,TP10.Dt_Previsao ),'dd/MM/yy') end)		[PLACE_OF_RCPT_EST_DTM]

		,UPPER(ORGPLNT.Nome_Local)													[PLACE_OF_RCPT_NM]--"<Request><Header><References type=""PlaceofReceipt Name""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="PlaceofReceipt Name"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,(CASE WHEN ORGPLNT.SCAC is null THEN ORGPLNT.Cd_Pais+ORGPLNT.Cd_Local
			ELSE ORGPLNT.Cd_Pais + ORGPLNT.SCAC END)									[PLACE_OF_RCPT_UNLOC_CD]
		,FORMAT(LLP.ATA_Lem , 'dd/MM/yy')																			[PORT_OF_ARRVL_ACT_DT]
		,FORMAT(LLP.ETA_Lem , 'dd/MM/yy')												[PORT_OF_ARRVL_EST_DT]

		,UPPER(DST.Nome_Local)															[PORT_OF_ARRVL_NM]
		,(CASE WHEN DST.SCAC is null THEN DST.Cd_Pais+DST.Cd_Local
			ELSE DST.Cd_Pais + DST.SCAC END)											[PORT_OF_ARRVL_UNLOC_CD]
		,FORMAT(LLP.ATD_Lem	, 'dd/MM/yy')												[PORT_OF_DEPTR_ACT_DT]
		,FORMAT(LLP.ETD_Lem	, 'dd/MM/yy')												[PORT_OF_DEPTR_EST_DT]
		,UPPER(ORG.Nome_Local)															[PORT_OF_DEPTR_NM]
		,(CASE WHEN ORG.SCAC is null THEN ORG.Cd_Pais+ORG.Cd_Local
			ELSE ORG.Cd_Pais + ORG.SCAC END)											[PORT_OF_DEPTR_UNLOC_CD]
		,NULL																			[PORT_OF_ENTRY_ACT_DT]
		,NULL																			[PORT_OF_ENTRY_EST_DT]-- Import		
		,NULL																			[PORT_OF_ENTRY_NM]
		,NULL																			[PORT_OF_ENTRY_UNLOC_CD]
		,FORMAT( LLP.ATD_LEM, 'dd/MM/yy')												[PORT_OF_EXIT_ACT_DT]--<Request><Header><Status><StatusType type="ActPortOfExitDate"></StatusType></Status></Header></Request>
		,FORMAT( LLP.ATD_LEM, 'dd/MM/yy')												[PORT_OF_EXIT_EST_DT]--"<Request><Header><Status><StatusType type=""EstPortOfExitDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,NULL																			[PORT_OF_EXIT_UNLOC_CD]
		,FORMAT( TP1.Dt_Conclusao, 'dd/MM/yy')											[PRESHPMNT_ADVC_DT]--"<Request><Header><Status><StatusType type=""PreShipmentAdviceDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
			
			
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.NUm_PROC_HEM) > 0 
			THEN 
				(Case when [dbo].[fDW_REPRT_VAL_AMT](HOU.NUm_PROC_HEM) < isnull(HOU.vlr_frete_tot_hem,0) 
					THEN 
						[dbo].[fDW_REPRT_VAL_AMT](HOU.NUm_PROC_HEM)
					ELSE
						[dbo].[fDW_REPRT_VAL_AMT](HOU.NUm_PROC_HEM) - isnull(HOU.vlr_frete_tot_hem,0)
				END)
			ELSE 
				LLP.Vlr_Invoice - isnull(HOU.vlr_frete_tot_hem,0) END)					[REPRT_VAL_AMT]--<Request><Footer><Measurements item="ReportableValueAmount"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>--<Request><Footer><Measurements item="TotalFAS"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		
		,FORMAT( LLP.ETA_LEM, 'dd/MM/yy')												[RQST_ETA_DEST_DT]--"<Request><Header><Status><StatusType type=""RequestedETADestinationDate""></StatusType>           <StatusTime></StatusTime></Status></Header></Request>"
		,Sales.Nome_Usuario																[SALES_PERSON_NM]--spINTSmartVendedor_Sel <Request><Header><CodesNames><CodesNamesName></CodesNamesName></CodesNames></Header></Request>
		,isnull(PO8.Numero_PO_HEM,HOU.HAWB_HEM)											[SAP_SHPMNT_NBR]--"<Request><Header><References type=""SAPShipmentNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"

		,NULL																			[SBU]--Request><Header><Transportation><ReferenceType type="SBU"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>--"<Request><Header><References type=""SBU""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																			[SBU_DESC]--"<Request><Header><References type=""SBUDescription""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="SBUDescription"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,FORMAT([dbo].[fDW_SDA_PAYMENT_DT]('SDA'), 'dd/MM/yy')						[SDA_PAYMENT_DT]--[spINTSmartPagamentos_Sel]'EMATL202407001BR','SDA'
		,UPPER(cast(LLP.ID_Status as varchar(2)) + '-' + TSP.Status_Descricao_Ingles)	[SHIPMENT_STATUS]
		,NULL																			[SHP_TO_PRTY_ID]
		,NULL																			[SLD_TO_PRTY_ID]
		,NULL																			[SLLR_PRTY_ID]
		,[dbo].[fBusca_TEUS](HOU.NUm_PROC_HEM)											[TEU_QTY]--<Request><Header><Amounts><AmountType>NumberOfTEUs</AmountType></Amounts></Header></Request>
		,HOU.Vol_Tot_HEM																[TOT_CUBIC_FT_QTY]--<Request><Footer><Measurements><MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,UPPER(TER.Nome_Terminal)														[TRMNL_PIER_NM]
		,isnull(HOU.vlr_frete_tot_hem,0)												[TTL_FRGHT_BOL_AWB_PRPD_AMT]--<Request><Header><Transportation><ReferenceType type="FreightAmount"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,HOU.Viagem_Hem																	[VOYG_FLGHT_NBR]--"If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""VoyageNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"--"If Request/Header/Transportation LegType=""Primary"" or ""First"" Request><Header><Transportation><ReferenceType type=""FlightNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
		,FORMAT( LLP.DL_VGM_LEM, 'dd/MM/yy')											[SOLAS_VRFDGRSSMASSCUTOFF_DT]-- only EM"<Request><Header><Status><StatusType type=""SolasVrfdGrMassCutDt""></StatusType>StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT( LLP.DL_VGM_LEM, 'dd/MM/yy')											[SOLAS_VRFDGRSSMASSCUTOFF_DTM]--<Request><Header><Status><StatusType type="SolasVrfdGrMassCutDt"></StatusType></Status></Header></Request>
		,NULL																			[LC_ISSUING_NBR]--"If Request/Header/LetterofCredit/BankParties type = ""IssuingBank"" then <Request><Header><LetterofCredit><BankParties><BankPartyName></BankPartyName></BankParties></LetterofCredit></Header></Request>"
		,FORMAT([dbo].fDW_ORDR_CRTN_DT(HOU.NUm_PROC_HEM), 'dd/MM/yy')					[ORDR_CRTN_DT]--spINTDtPedido '" & ProcessoDT.Rows(0)("processo").ToString() & "'--"<Request><Header><Status><StatusType type=""OrderReceiveDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( PO13.Data_PO_HEM, 'dd/MM/yy')											[CERT_OF_ORGN_APPLIED_DT]--<Request><Header><Status><StatusType type="CertOriginApplied"></StatusType></Status></Header></Request>
			
	FROM DBO.HOUSE_EXP_MAR			HOU			WITH (NOLOCK) 
		JOIN LLP_EXP_MAR			LLP			WITH (NOLOCK) ON LLP.NUM_PROC_LEM	=	HOU.NUM_PROC_HEM
		Left Join Tipo_Carga		TC			WITH (NOLOCK) ON TC.Cd_Tp_Carga		=	LLP.Cd_Tp_Carga
		JOIN JOB_EXP_MAR			JOB			WITH (NOLOCK) ON JOB.NUM_PROC_HEM	=	HOU.NUM_PROC_HEM
		LEFT JOIN MASTER_EXP_MAR	MAS			WITH (NOLOCK) ON MAS.NUM_PROC_MEM	=	HOU.NUM_PROC_MEM
		LEFT JOIN PESSOA			Exporter	WITH (NOLOCK) ON Exporter.CD_PES	=	HOU.CD_EXPORT_HEM
		LEFT JOIN PESSOA			Consignee	WITH (NOLOCK) ON Consignee.CD_PES	=	HOU.Cd_Consig_HEM	
		LEFT JOIN PESSOA			Notify		WITH (NOLOCK) ON Notify.CD_PES		=	HOU.Cd_Notify_HEM	
		LEFT JOIN PESSOA_LLP		PLLP		WITH (NOLOCK) ON HOU.CD_EXPORT_HEM	=	PLLP.CD_PES
		LEFT JOIN GRUPO				GRP			WITH (NOLOCK) ON GRP.CD_PES_GRUPO	=   PLLP.CD_PES_GRUPO
		LEFT JOIN Tarefas_Processos TP40		WITH (NOLOCK) ON TP40.NUM_PROC		=	HOU.NUM_PROC_HEM and TP40.ID_Task = 40
		LEFT JOIN Tarefas_Processos TP217		WITH (NOLOCK) ON TP217.NUM_PROC		=	HOU.NUM_PROC_HEM and TP217.ID_Task = 217
		LEFT JOIN Tarefas_Processos TP83		WITH (NOLOCK) ON TP83.NUM_PROC		=	HOU.NUM_PROC_HEM and TP83.ID_Task = 83
		LEFT JOIN Tarefas_Processos TP66		WITH (NOLOCK) ON TP66.NUM_PROC		=	HOU.NUM_PROC_HEM and TP66.ID_Task = 66
		LEFT JOIN Tarefas_Processos TP50		WITH (NOLOCK) ON TP50.NUM_PROC		=	HOU.NUM_PROC_HEM and TP50.ID_Task = 50
		LEFT JOIN Tarefas_Processos TP45		WITH (NOLOCK) ON TP45.NUM_PROC		=	HOU.NUM_PROC_HEM and TP45.ID_Task = 45
		LEFT JOIN TAREFAS_PROCESSOS TP4			WITH (NOLOCK) ON TP4.NUM_PROC		=	HOU.NUM_PROC_HEM AND TP4.ID_TASK = 4
		LEFT JOIN TAREFAS_PROCESSOS TP10		WITH (NOLOCK) ON TP10.NUM_PROC		=	HOU.NUM_PROC_HEM AND TP10.ID_TASK = 10
		LEFT JOIN TAREFAS_PROCESSOS TP13		WITH (NOLOCK) ON TP13.NUM_PROC		=	HOU.NUM_PROC_HEM AND TP13.ID_TASK = 13
		LEFT JOIN TAREFAS_PROCESSOS TP1			WITH (NOLOCK) ON TP1.NUM_PROC		=	HOU.NUM_PROC_HEM AND TP1.ID_TASK = 1
		LEFT JOIN TAREFAS_PROCESSOS TP5			WITH (NOLOCK) ON TP5.NUM_PROC		=	HOU.NUM_PROC_HEM AND TP5.ID_TASK = 5
		LEFT JOIN TAREFAS_PROCESSOS TP58		WITH (NOLOCK) ON TP58.NUM_PROC		=	HOU.NUM_PROC_HEM AND TP58.ID_TASK = 58
		LEFT JOIN TAREFAS_PROCESSOS TP21		WITH (NOLOCK) ON TP21.NUM_PROC		=	HOU.NUM_PROC_HEM AND TP21.ID_TASK = 21
		LEFT JOIN TAREFAS_PROCESSOS TP12		WITH (NOLOCK) ON TP12.NUM_PROC		=	HOU.NUM_PROC_HEM AND TP12.ID_TASK = 12
		LEFT JOIN TAREFAS_PROCESSOS TP161		WITH (NOLOCK) ON TP161.NUM_PROC		=	HOU.NUM_PROC_HEM AND TP161.ID_TASK = 161
		LEFT JOIN TAREFAS_PROCESSOS TP160		WITH (NOLOCK) ON TP160.NUM_PROC		=	HOU.NUM_PROC_HEM AND TP160.ID_TASK = 160
		LEFT JOIN TAREFAS_PROCESSOS TP59		WITH (NOLOCK) ON TP59.NUM_PROC		=	HOU.NUM_PROC_HEM AND TP59.ID_TASK = 59

		LEFT JOIN Nature_Goods		NG			WITH (NOLOCK) ON NG.Num_Proc		=	HOU.NUM_PROC_HEM
		LEFT JOIN Armador			ARM			WITH (NOLOCK) ON ARM.Cd_Armador		=	LLP.cd_armador_LEM AND ARM.SCAC IS NOT NULL
		LEFT JOIN PO_HEM			PO4			WITH (NOLOCK) ON PO4.Num_Proc_HEM	=	HOU.NUM_PROC_HEM AND PO4.ID_DC = 4
		LEFT JOIN PO_HEM			PO12		WITH (NOLOCK) ON PO12.Num_Proc_HEM	=	HOU.NUM_PROC_HEM AND PO12.ID_DC = 12
		LEFT JOIN PO_HEM			PO204		WITH (NOLOCK) ON PO204.Num_Proc_HEM	=	HOU.NUM_PROC_HEM AND PO204.ID_DC = 204
		LEFT JOIN PO_HEM			PO71		WITH (NOLOCK) ON PO71.Num_Proc_HEM	=	HOU.NUM_PROC_HEM AND PO71.ID_DC = 71
		LEFT JOIN PO_HEM			PO13		WITH (NOLOCK) ON PO13.Num_Proc_HEM	=	HOU.NUM_PROC_HEM AND PO13.ID_DC = 13
		LEFT JOIN PO_HEM			PO8			WITH (NOLOCK) ON PO8.Num_Proc_HEM	=	HOU.NUM_PROC_HEM AND PO8.ID_DC = 8
		--LEFT JOIN PO_HEM			PO2			WITH (NOLOCK) ON PO2.Num_Proc_HEM	=	HOU.NUM_PROC_HEM AND PO2.ID_DC = 2

		LEFT JOIN Localidade		DST			WITH (NOLOCK) ON DST.Cd_Local		=	HOU.Cd_Dst_HEM
		LEFT JOIN Localidade		ORG			WITH (NOLOCK) ON ORG.Cd_Local		=	HOU.Cd_Org_HEM
		LEFT JOIN Pais				DSTPais		WITH (NOLOCK) ON DSTPais.cd_pais	=	DST.cd_pais
		LEFT JOIN Pais				ORGPais		WITH (NOLOCK) ON ORGPais.cd_pais	=	ORG.cd_pais

		LEFT JOIN Localidade		DSTFNL		WITH (NOLOCK) ON DSTFNL.Cd_Local	=	LLP.Cd_DstFinal_Lem
		LEFT JOIN Localidade		ORGPLNT		WITH (NOLOCK) ON ORGPLNT.Cd_Local	=	LLP.Cd_Planta_Lem
		LEFT JOIN Usuario			US			WITH (NOLOCK) ON US.cd_usuario		=	JOB.Cd_Usuario
		LEFT JOIN Campo_Processo	CP32		WITH (NOLOCK) ON CP32.NUM_PROC		=	HOU.NUM_PROC_HEM AND CP32.ID_Campo = 32	
		LEFT JOIN Usuario			Sales		WITH (NOLOCK) ON Sales.cd_usuario	=	JOB.cd_Vendedor
		LEFT JOIN Tipo_Status_Processo TSP		WITH (NOLOCK) ON LLP.id_status		=	TSP.id_status
		LEFT JOIN Terminal			TER			WITH (NOLOCK) ON TER.cd_terminal	=	LLP.cd_terminal
	Where
		HOU.Num_Proc_HEM in ('EMCSR202407023BR')
		--('EMOXT202407139BR','EMSUE202407005BR','EMSAM202407004BR','EMATL202407001BR' ,'EMOXT202407012BR')
		--AND
		--convert(datetime,HOU.Dt_Emis_HEM,105) > getdate() -31
				
UNION ALL

	SELECT
		HOU.Num_Proc_HIM																[FRWDR_REF_NBR]
		,FORMAT(TP59.Dt_Conclusao , 'dd/MM/yy')											[ADVANCEMENT_REQ_DT]--I think it is 59 - -Solicitação de Numerário - <StatusType type="AdvancementReqDt"/>
		,FORMAT(TP25.Dt_Conclusao , 'dd/MM/yy')											[AFRMM_PAYMENT_DT]
		,FORMAT( TP28.Dt_Conclusao , 'dd/MM/yy')										[ARR_DT]--i think it is 28	Entrada no Terminal	IM	S	1	ETA	NULL	AtTerminalDate
		,isnull(GRP.Smart_Imp,HOU.Cd_Consig_HIM)										[BDP_CLIENT_CD] -- spIntPessoa_Sel I = Smart_Imp,E = Smart_Exp <Request><Header><References type="ClientCode"><ReferenceNumber></ReferenceNumber>
		,FORMAT( TP40.Dt_Conclusao , 'dd/MM/yy')										[BDP_INVC_ACT_DT]	--Smart_Conclusao - spSmartBilledDate_Sel -   <Request><Header><Status><StatusType type="BilledDate"></StatusType>
		,FORMAT( TP40.Dt_Conclusao , 'dd/MM/yy')										[BDP_INVC_ACT_DTM]
		,[dbo].[fDW_BDP_INVC_REF_NBR](HOU.NUM_PROC_HIM)									[BDP_INVC_REF_NBR]
		,NULL																			[BDP_REP_PRTY_ID]		
		,LEFT(HOU.Num_Proc_HIM,1)														[BDP_SERVICE_CD]--<Request><Header Type="Export"></Header ></Request> then E
		,'01BDPBRSAO' 																	[BDP_SS_ID]
		,(CASE WHEN HOU.Num_Proc_MIM <> 'JOB' THEN 'Y' ELSE
			(CASE WHEN ARM.SCAC = 'BOPT' THEN 'Y' ELSE
				(CASE WHEN ARM.SCAC = 'SBHG' THEN 'S' ELSE
					'N'
				END)
			END)
		END)																					[BDP_TRANS_IND]
		,(CASE WHEN HOU.Tp_Frete_HIM = 'P' THEN HOU.vlr_frete_efet_him ELSE '0.00' END)	[BF_BOL_AWB_PRPD_AMT]--<Request><Header><Amounts><AmountType>BaseFreightBolAwbAmountPrepaid</AmountType></Amounts></Header></Request>
		--,FORMAT( TP5.Dt_Conclusao , 'dd/MM/yy')											[BKNG_CNFRM_DT]
		,NULL																			[BKNG_CNFRM_DT]
		,FORMAT( isnull(TP41.Dt_Conclusao,DATEADD(day,-1, LLP.ATD_lim)) , 'dd/MM/yy')	[BOL_POST_AUDT_BCK_DT]	--Smart_Conclusao - <Request><Header><Status><StatusType type="BOLBackDate"></StatusType>		
		,FORMAT( isnull(TP41.Dt_Conclusao,DATEADD(day,-1, LLP.ATD_lim)) , 'dd/MM/yy')	[BOL_POST_AUDT_BCK_DTM]		
		,NULL																			[BOL_PRE_AUDT_RCV_DT]	-- Code - 66	Envio do draft do BL--<Request><Header><Status><StatusType type="BillofLadingRetreivedDate"></StatusType>
		,NULL																			[BOL_PRE_AUDT_RCV_DTM]
		,FORMAT( TP5.Dt_Conclusao , 'dd/MM/yy')										[BKNG_CNFRMTN_RCVD_FROM_SS_DT]
		,FORMAT( TP58.Dt_Conclusao , 'dd/MM/yy')									[BKNG_DT]
		,FORMAT( TP58.Dt_Conclusao , 'dd/MM/yy')									[BKNG_DTM]
		,(CASE WHEN hou.Num_Proc_MIM = 'JOB' THEN LLP.Nr_Reserva ELSE HOU.Num_Proc_HIM END)	[BKNG_NBR]--HouseBookingNumber
		,NULL																			[BOL_ACTN_DT]
		,FORMAT(LLP.ATD_lim, 'dd/MM/yy')												[BOL_AWB_ISS_DT]
		,HOU.HAWB_HIM																	[BOL_AWB_NBR] --HouseBillofLadingNumber-- HouseAirwayBill- verificar
		--,FORMAT( TP45.Dt_Conclusao , 'dd/MM/yy')										[BOL_SBMT_DT]-- Smart_Conclusao 45	Envio Shipping <Request><Header><Status><StatusType type="BOLSubmitDate"></StatusType></Status></Header></Request>
		,FORMAT(LLP.ATD_lim, 'dd/MM/yy')												[BOL_SBMT_DT]
		,FORMAT(LLP.ATD_lim, 'dd/MM/yy')												[BOL_SBMT_DTM]
		,NULL																			[BYR_PRTY_ID]
		--"<Request><Header><References type=""CargoType""><ReferenceNumber></ReferenceNumber></References></Header></Request>Request><Header>
		,(CASE WHEN LEFT(hou.Num_Proc_HIM,2) = 'IM' or LEFT(hou.Num_Proc_HIM,2) = 'EM' THEN TC.Nome_Tp_Carga ELSE 'LCL' END)	[CARGO_TYP]
		,NULL																			[CARRIER_DOC_CUTOFF_DT]--Only EM
		,NULL																			[CARRIER_DOC_CUTOFF_DTM]--Only EM
		,HOU.Num_Proc_HIM																[CHB_REF_NBR]--<Request><Header><References type="ClearingAgentReferenceNumber"><ReferenceNumber></ReferenceNumber>
		,NULL																			[CHRG_WGHT_QTY] --EA e IA
		,LEFT([dbo].[RemoveNonAlphaCharacters](NG.Descr),100)							[CARGO_DESC]--CargoDescription <Request><Header><CodesNames><CodesNamesType></CodesNamesType></CodesNames></Header></Request>
		,(CASE WHEN HOU.Num_Proc_MIM <> 'JOB' THEN 'BDP TRANSPORT, INC' ELSE
		UPPER(ARM.Nome_Armador)	END)														[CARR_NM]--If Request/Header/Transportation MethodofTransportation  is  Air and   <Request><Header><Transportation><Carrier><CarrierName></CarrierName></Carrier></Transportation></Header></Request>
		,FORMAT( TP21.Dt_Conclusao, 'dd/MM/yy')										[CARR_PYMNT_DT]
		,(CASE WHEN HOU.Num_Proc_MIM <> 'JOB' THEN 'BOPT' ELSE ARM.SCAC END)			[CARR_SCAC_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First"" thenIf Request/Header/Transportation/Carrier/CarrierCode/type is not equal to null then <Request><Header><Transportation><Carrier><CarrierCode></CarrierCode></Carrier></Transportation></Header></Request>"		
		,NULL																			[CHB_PRTY_ID]
		,NULL																			[CHRG_RATE_AMT]		
		,isnull(GRP.Smart_Imp,HOU.Cd_Consig_HIM)+isnull(GRP.Smart_Imp,HOU.Cd_Consig_HIM)	[CLNT_CD] --<Request><Header><References type=""BDPClientCode""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,(CASE WHEN hou.Num_Proc_MIM <> 'JOB'  AND substring(hou.Num_Proc_MIM,3,3) <> 'CLI' THEN 'C' ELSE 'D' END)		[CNSOL_DRCT_CD]--"<Request><Header><References type=""ConsolIndicator""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,(CASE WHEN hou.Num_Proc_MIM <> 'JOB'  THEN hou.Num_Proc_MIM ELSE NULL END)     [CNSOL_NBR] --<Request><Header><References type=""ConsolNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,[dbo].[fDW_CNTNR_EQUIP_CT](HOU.Num_Proc_HIM)									[CNTNR_EQUIP_CT]--<Request><Header><EquipmentSummary><EquipmentQuantity><EquipmentQuantity></EquipmentSummary></Header></Request>
		,[dbo].[fDW_CNTNR_TYP_CD](HOU.Num_Proc_HIM,1)	[CNTNR_TYP_CD_1]--"From 1st Occurence of EquipmentSummary <Request><Header><EquipmentSummary><EquipmentDescription></EquipmentDescription></EquipmentSummary></Header></Request>"
		,[dbo].[fDW_CNTNR_TYP_CD](HOU.Num_Proc_HIM,2)	[CNTNR_TYP_CD_2]--"From 2nd Occurence of EquipmentSummary<Request><Header><EquipmentSummary><EquipmentDescription></EquipmentDescription></EquipmentSummary></Header></Request>"
		,[dbo].[fDW_CNTNR_TYP_CD](HOU.Num_Proc_HIM,3)	[CNTNR_TYP_CD_3]--"From 3rd Occurence of EquipmentSummary<Request><Header><EquipmentSummary><EquipmentDescription></EquipmentDescription></EquipmentSummary></Header></Request>"
		,isnull(GRP.Smart_Imp,HOU.Cd_Consig_HIM)										[CONSG_PRTY_CD]
		,NULL																			[CONSG_PRTY_ID]
		,PO5.Numero_PO_HIM																[CSTMS_ENTRY_PRMT_NBR]-- Only IM<Request><Header><References type=""CustomsEntryNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')											[CSTMS_ENTRY_PRMT_REL_DT]--Smart_Conclusao <Request><Header><Status><StatusType type=""CustomsEntryPermitReleaseDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')											[CSTMS_ENTRY_PRMT_REL_DTM]
		,FORMAT( PO5.Data_PO_HIM, 'dd/MM/yy')											[CSTMS_ENTRY_PRMT_SBMT_DT]--Code - "<Request><Header><Status><StatusType type=""CustomsEntryPermitSubmissionDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,UPPER(DST.Nome_Local)														[CSTMS_ENTRY_PRT_NM]--If Request/Header/Transportation MethodofTransportation  is not Air and <Request><Header><Transportation><Destination LocationType=""PortofEntry""><DestinationName></DestinationName></Destination></Transportation></Header></Request>"
		,(CASE WHEN DST.SCAC is null THEN DST.Cd_Pais+DST.Cd_Local ELSE DST.Cd_Pais + DST.SCAC END) [CSTMS_ENTRY_PRT_UNLOC_CD] -- spSmartBITRI_Sel--"If Request/Header/Transportation MethodofTransportation  is not Air and  If <Request><Header><Transportation><Destination LocationType=""PortofEntry""> then  <Request><Header><Transportation><DestinationCodeType Type=""UNLOCCode""> <DestinationCode></DestinationCode></DestinationCodeType></Transportation></Header></Request>"
		,LEFT(UPPER(LLP.Canal_Lim),2)												[CSTMS_ENTRY_TYP_CD]--"<Request><Header><References type=""CustomsEntrytypeCode""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,FORMAT( TP15.Dt_Conclusao , 'dd/MM/yy')										[CSTMS_PRT_ACT_DT]
		,FORMAT( TP15.Dt_Previsao , 'dd/MM/yy')											[CSTMS_PRT_EST_DT]
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')											[CSTMS_RLS_DT] --If Request/Header Type="Import"<Request><Header><Status><StatusType type="CustomsReleaseDate"></StatusType>           <StatusDate></StatusDate></Status></Header></Request>
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')											[CSTMS_RLS_DTM]
		,[dbo].[fDW_CUSTOMER_CSR_NM](HOU.Num_Proc_HIM)									[CUSTOMER_CSR_NM]--spCSRJob_SEL - <Request><Header><Parties><Party-Contacts type="CSR"><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
		,UPPER(DST.Cd_Pais)																[DEST_CNTRY_CD]--If Request/Header/Transportation LegType="Primary" or "First"<Request><Header><Transportation><DestinationCountryCode></DestinationCountryCode></Transportation></Header></Request>
		,UPPER(DSTPais.Nome_Pais)														[DEST_CNTRY_NM]
		,UPPER(DST.Cd_Pais)																[DEST_CNTRY_UNLOC_CD]
		,FORMAT( TP13.Dt_Conclusao , 'dd/MM/yy')										[DEST_DEL_ACT_DT]---- Only Import ID_Task 13 Dt_Conclusao --<Request><Header><Status><StatusType type="ActDestinationDeliveryDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,FORMAT( TP13.Dt_Conclusao , 'dd/MM/yy')										[DEST_DEL_ACT_DTM]
		,(Case when TP13.Dt_Conclusao is not null then FORMAT( TP13.Dt_Previsao , 'dd/MM/yy') else NULL end)	[DEST_DEL_EST_DT]---- Only Import ID_Task 13 Dt_Previsao--<Request><Header><Status><StatusType type="EstDestinationDeliveryDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,(Case when TP13.Dt_Conclusao is not null then FORMAT( TP13.Dt_Previsao , 'dd/MM/yy') else NULL end)	[DEST_DEL_EST_DTM]

		,Transp.Nome_Raz_Soc															[DEST_INL_CARR_NM]--spINTSmartBuscaTransportadora_Sel				
		,Left(TRANSPPLLP.cd_Vendor,4)													[DEST_INL_CARR_SCAC_CD]
		,FORMAT( TP7.Dt_Conclusao , 'dd/MM/yy')											[DLVRY_ORDR_CREATN_DT_ACT_DT]--Only Import ID_Task 7 Dt_Conclusao <Request><Header><Status><StatusType type="ActDeliveryOrderCreationDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,FORMAT( TP7.Dt_Conclusao , 'dd/MM/yy')											[DLVRY_ORDR_DISTRIB_DT_ACT_DT]--Only Import ID_Task 7 Dt_Conclusao <Request><Header><Status><StatusType type="ActDeliveryOrderDistributionDate"></StatusType><StatusTime></StatusTime></Status></Header></Request>
		,FORMAT( TP63.Dt_Conclusao , 'dd/MM/yy')										[DOC_DIST_RCV_ACT_DT]
		,FORMAT( TP63.Dt_Conclusao , 'dd/MM/yy')										[DOC_DIST_RCV_ACT_DTM]
		,NULL																			[DOC_DIST_SEND_ACT_DT]
		,NULL																			[DOC_DIST_SEND_ACT_DTM]
		,NULL																			[DOC_DIST_SEND_EST_DT]
		,NULL																			[DOC_DIST_SEND_EST_DTM]
		,NULL																			[DOC_DIST_BY_NM]
		,FORMAT( TP109.Dt_Conclusao , 'dd/MM/yy')										[DOCK_RCPT_CRTN_DT]--Only Import ID_Task 109 Dt_Conclusao--<Request><Header><Status><StatusType type="DockReceiptCreationDate"></StatusType></Status></Header></Request>
		,NULL																			[DRAFT_BOL_INSTR_RECVD_DT]--Only EM  ID_Task 66 Dt_Conclusao--<Request><Header><Status><StatusType type="DraftBOLInstrRecvdDt"></StatusType></Status></Header></Request>
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')											[ENTRY_IMM_DEL_RCV_DT]
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')											[ENTRY_IMM_DEL_RCV_DTM]
		,FORMAT( PO5.Data_PO_HIM, 'dd/MM/yy')											[ENTRY_SUMM_SBMT_DT]--Not Sent"<Request><Header><Status><StatusType type=""EntrySummaryRejectDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( PO5.Data_PO_HIM, 'dd/MM/yy')											[ENTRY_SUMM_SBMT_DTM]
		,FORMAT(LLP.ATD_lim, 'dd/MM/yy')												[EXIT_CITY_ACT_DT]
		,UPPER(ORG.Cd_Pais)																[EXP_CNTRY_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First""  <Request><Header><Transportation><OriginCountryCode></OriginCountryCode></Transportation></Header></Request>"
		,UPPER(ORG.Cd_Pais)																[EXP_CNTRY_UNLOC_CD]--<Request><Header><References type=""CountryOfExportUNLOCCode""><ReferenceNumber></ReferenceNumber></References></Header></Request> If Request/Header/Transportation LegType=""Primary"" or ""First""  <Request><Header><Transportation><OriginCountryCode></OriginCountryCode></Transportation></Header></Request>"
		,NULL																			[EXPRT_JOB_NBR]--NOT SEND"<Request><Header><References type=""ExportReferenceNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																			[EXPTR_SHPR_PRTY_CD]
		,NULL																			[EXPTR_SHPR_PRTY_ID]
		,NULL																			[FEU_QTY]--<Request><Header><Amounts><AmountType>NumberOfFEUs</AmountType></Amounts></Header></Request>
		,FORMAT( TP40.Dt_Conclusao , 'dd/MM/yy')										[FILE_CLS_DT]--"<Request><Header><Status><StatusType type=""FileClosedDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"	--"<Request><Header><Status><StatusType type=""ClosedDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( TP40.Dt_Conclusao , 'dd/MM/yy')										[FILE_CLS_DTM]
		,NULL																			[FILE_CREATED_BY_NM]
		,CONVERT(VARCHAR(8), CONVERT(DATE, HOU.Dt_Emis_HIM, 103), 3)				[FILE_CRTN_DT]
		--, HOU.Dt_Emis_HIM 														[FILE_CRTN_DT]
		,CONVERT(VARCHAR(8), CONVERT(DATE, HOU.Dt_Emis_HIM, 103), 3)				[FILE_CRTN_DTM]
		,NULL																			[FINAL_GOODS_ISS_DT]
		,NULL																			[FINAL_GOODS_ISS_DTM]
		,NULL																			[FRWDR_PRTY_ID]
		--,HOU.Num_Proc_HIM																[FRWDR_REF_NBR]	--"<Request><Header><References type=""BDPJobNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"		--"<Request><Header><References type=""ExportForwarderRefNbr""><ReferenceNumber></ReferenceNumber> </References></Header></Request>"		--"<Request><Header><References type=""ImportForwarderRefNbr""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																			[GE_DIVISION_CD]
		,NULL																			[GE_GROUP_CD]
		,NULL																			[GE_SBU_CD]
		,Consignee.GLOBAL_ENTITY_ID														[GEID]--"<Request><Header><Parties type=""Exporter""><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>"--"<Request><Header><Parties type=""Importer""><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>"
		,NULL																			[GLBL_AGNT_PRTY_ID]
		,UPPER(replace(replace(replace(ltrim(rtrim(HOU.Obs_HIM)),char(10),' '),char(13),' '),char(160),' ')) [GNRL_DESC]--"<Request><Header><References type=""GeneralDescription""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																			[GOODS_AVLBL_SHP_ACT_DT]--ONly for EA,EM,EO,IOActualPlantShipDate --"If the file is not  Meridian If <Request><Header><Status><StatusType type=""ActGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		<Request><Header><Status><StatusType type=""ActualPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,NULL																			[GOODS_AVLBL_SHP_ACT_DTM]
		,NULL																			[GOODS_AVLBL_SHP_EST_DT] --ONly for EA,EM,EO,IO	--"<Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"	--"If the file is not for Meridian 		--If <Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		--<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"		--"If the file is not for Meridian		--If <Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		--<Request><Header><Status><StatusType type=""EstimatedShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,NULL																			[GOODS_AVLBL_SHP_EST_DTM]
		,NULL																			[GOV_EXP_PRMSS_RLS_DT]--ONly for EA,EM,EO - "If Request/Header Type=""Export""<Request><Header><Status><StatusType type=""CustomsReleaseDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[GOV_EXP_PRMSS_RLS_DTM]
		,NULL																			[GOV_EXP_PRMSS_RLS_NBR]--ONly for EA,EM,EO"<Request><Header><References type=""GovernmentPermissionToExportReleaseNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																			[GOV_EXP_PRMSS_SBMT_DT]--Not Send -"If Request/Header Type=""Export""   <Request><Header><Status><StatusType type=""CustomsSubmitDate""></StatusType>           <StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[GOV_EXP_PRMSS_SBMT_DTM]
		,NULL																			[GOV_EXP_PRMSS_SBMT_NBR]
		,FORMAT( PO5.Data_PO_HIM, 'dd/MM/yy')											[GOV_PYMNT_STMNT_SBMT_DT]--IMP ID_DC 5, EXP-ID-DC 4<Request><Header><Status><StatusType type="GovernmentPaymentStatementSubmissionDate"></StatusType></Status></Header></Request>
		,FORMAT( PO5.Data_PO_HIM, 'dd/MM/yy')											[GOV_PYMNT_STMNT_SBMT_DTM]

		,HOU.Peso_Bruto_HIM																[GROSS_TRANS_KILO_QTY]--"<Request><Header><Detail><ProductDetail><Measurements type=""GrsWtKgs""><MeasurementValue></MeasurementValue></Measurements></ProductDetail></Detail></Header></Request>"
		,HOU.Peso_Bruto_HIM * 2.2046													[GROSS_TRANS_POUND_QTY]
		,FORMAT( TP27.Dt_Conclusao , 'dd/MM/yy')										[IMPORT_DCLRTN_DRFT_DT]
		,(CASE WHEN CP5.Campo_DADOS is null then NULL ELSE
		(CASE WHEN CP5.Campo_DADOS = '2' THEN 'N' ELSE 'Y' END)	END)				[IMPORT_LIC_NEEDED_IND]--spSmartNecessidadeLI_Sel
		,NULL																			[IMPTR_PRTY_CD]
		,NULL																			[IMPTR_PRTY_ID]
		,FORMAT(TP114.Dt_Conclusao , 'dd/MM/yy')										[INSPECTN_DT_ACT_DT]
		,HOU.tp_frete_him																[INTL_FRGHT_TERM_CD]--<Request><Header><Transportation><PrepaidorCollect></PrepaidorCollect></Transportation></Header></Request>
		,UPPER(ISNULL(DSTFNL.Nome_Local,DST.Nome_Local))								[ITS_PLACE_OF_DLVRY_NM]	--"If Request/Header/Transportation MethodofTransportation  is not Air and  If <Request><Header><Transportation><Destination LocationType=""PlaceofDelivery""><DestinationName></DestinationName> </Destination></Transportation></Header></Request>"
		,UPPER(ISNULL(ORGPLNT.Nome_Local,ORG.Nome_Local))								[ITS_PLACE_OF_RCPT_NM]
		,UPPER(DST.Nome_Local)															[ITS_PORT_OF_DSCHRG_NM]
		,UPPER(DST.Nome_Local)															[ITS_PORT_OF_ENTRY_NM]
		,UPPER(ORG.Nome_Local)															[ITS_PORT_OF_LOAD_NM]
		,UPPER(ISNULL(ORGPLNT.Nome_Local,ORG.Nome_Local))								[ITS_PORT_OF_ORGN_NM]
		,FORMAT( [dbo].[fDW_LAST_MDFD_BY_DT](HOU.Num_Proc_HIM), 'dd/MM/yy')				[LAST_MDFD_BY_DT]--"<Request><Header><Status><StatusType type=""LastModifiedByDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,(CASE WHEN PO71.Numero_PO_HIM is not null THEN 'Y' ELSE 'N' END)				[LETTR_OF_CRDT_IND]--<Request><Header><LetterofCredit><RequiredYN></RequiredYN></LetterofCredit></Header></Request>
		,FORMAT( PO5.Data_PO_HIM, 'dd/MM/yy')											[LQDTN_DT]--Only Import Data da DI and id_dc=5 --<Request><Header><Status><StatusType type="LiquidationDate"></StatusType></Status></Header></Request>
		,NULL																			[LTST_DEL_CUTOFF_DT] -- Ony FOR EM --<Request><Header><Status><StatusType type=""LatestDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[LTST_DEL_CUTOFF_DTM]-- Ony FOR EM--<Request><Header><Status><StatusType type=""LatestDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[MANIFEST_DT]
		,NULL																			[MANUF_PLNT_PRTY_ID]
		,NULL																			[MBOL_ACTN_DT]--Not Send--<Request><Header><FileStatus><Code>"MbolActionDate"</Code></FileStatus></Header></Request>
		,HOU.MAWB_HIM																	[MBOL_MAWB_NBR]--If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""MasterBillofLadingNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>--If Request/Header/Transportation MethodofTransportation  is  Air and <Request><Header><Transportation><ReferenceType type=""MasterAirWayBill""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>--If Request/Header/Transportation MethodofTransportation  is  Air and <Request><Header><Transportation><ReferenceType type=""MasterBillofLadingNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,NULL																			[MBOL_RCV_DT]
		,NULL																			[MBOL_RCV_DTM]
		,'V'																			[MOT_CD]--" Request><Header><Transportation MethodofTransportation= ""V""></Transportation></Header></Request>
		,NULL																			[MOVE_TYP_CD]
		,(CASE WHEN HOU.cd_tp_oper='DDP' or HOU.cd_tp_oper='DDU' THEN 'DOOR TO DOOR' ELSE 
		(CASE WHEN HOU.cd_tp_oper='FOB' or HOU.cd_tp_oper='FCA' THEN 'PORT TO PORT' 
		ELSE 'DOOR TO PORT' END)END)													[MOVE_TYP_DESC]--Request><Header><Transportation><TypeofMoveCode Type="DP"></TypeofMoveCode></Transportation></Header></Request>---<Request><Header><Transportation><TypeofMoveDescription></TypeofMoveDescription></Transportation></Header></Request>

		,LLP.Nr_Reserva																	[MSTR_BKNG_NBR]-- If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""BookingNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
	
		,(CASE WHEN hou.Num_Proc_MIM <> 'JOB'  AND substring(hou.Num_Proc_MIM,3,3) <> 'CLI'
			THEN UPPER(ARM.Nome_Armador) ELSE NULL END)									[MSTR_CARR_NM]
				,(CASE WHEN hou.Num_Proc_MIM <> 'JOB'  AND substring(hou.Num_Proc_MIM,3,3) <> 'CLI'
			THEN UPPER(ARM.SCAC) ELSE NULL END)											[MSTR_CARR_SCAC_CD]
		
		,HOU.Peso_Liquido_HIM															[NET_TRANS_KILO_QTY]--<Request><Footer><Measurements item="NetWtKgs"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>-<Request><Footer><Measurements item="NetWeightKilograms"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,HOU.Peso_Liquido_HIM * 2.2046													[NET_TRANS_POUND_QTY]--<Request><Footer><Measurements item="NetWeightPounds"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,NULL																			[NF_COMPLIMENTARY_DT]
		,FORMAT( TP67.Dt_Conclusao , 'dd/MM/yy')											[NF_DRFT_DT]
		,NULL																			[NTFY_PRTY_ID]
		,FORMAT(LLP.ATD_LiM, 'dd/MM/yy')												[ONBRD_CONFRM_DT]--If Request/Header/Transportation LegType=""Primary"" or ""First"" 	and If Request/Header/Transportation MethodofTransportation  is ""Ocean"" or ""V"" or ""Barge"" or ""B"" or ""C"" Request><Header><Transportation><OriginDate Type=""Actual""></OriginDate></Transportation></Header></Request>"
		,FORMAT(LLP.ATD_LiM, 'dd/MM/yy')												[ONBRD_CONFRM_DTM]
		,FORMAT(TP160.Dt_Conclusao , 'dd/MM/yy')										[OPEN_GATE_DT]
		,(CASE WHEN CP32.Campo_DADOS = '2' THEN 'FFD' ELSE 'CHB' END)					[OPRTG_UNT_CL_CD]--<Request><Header><References type=""OperatingUnitClassification""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,left([dbo].[fDW_ORDR_TYP_CD](HOU.Num_Proc_HIM),1)								[ORDR_TYP_CD]--<Request><Header><References type="OrderType"><ReferenceNumber></ReferenceNumber></References></Header></Request>		--<Request><Header><Transportation><ReferenceType type="OrderType"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,FORMAT(LLP.ATD_LiM, 'dd/MM/yy')												[ORGN_CITY_ACT_DT]--<Request><Header><Amounts><AmountType>ActCityOfOriginDate</AmountType></Amounts></Header></Request>
		,UPPER(ORG.cd_pais)																[ORGN_CNTRY_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First"" <Request><Header><Transportation><OriginCountryCode></OriginCountryCode></Transportation></Header></Request>"
		,UPPER(ORGPais.Nome_Pais)														[ORGN_CNTRY_NM]
		,UPPER(ORG.Cd_Pais)																[ORGN_CNTRY_UNLOC_CD]
		,FORMAT( TP5.Dt_Conclusao , 'dd/MM/yy')		[ORGN_INL_BOOK_ACT_DT]
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')										[ORGN_INL_DEL_ACT_DT]--<Request><Header><Status><StatusType type="ActDomesticInlandDeliveryDate"></StatusType></Status></Header></Request>
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')										[ORGN_INL_DEL_ACT_DTM]
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')										[ORGN_INL_DEL_EST_DT]--<Request><Header><Status><StatusType type="EstDomesticInlandDeliveryDate"></StatusType></Status></Header></Request>
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')										[ORGN_INL_DEL_EST_DTM]
		,NULL																			[ORGN_INL_LOCTN_NM]
		,NULL																			[ORGN_INL_LOCTN_UNLOC_CD]
		,NULL																			[ORGN_INL_PCKP_ACT_DT]--10	EA,10	EM,10	EO - "If the file is not for Meridian If <Request><Header><Status><StatusType type=""ActGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,NULL																			[ORGN_INL_PCKP_ACT_DTM]
		,NULL											[ORGN_INL_PCKP_EST_DT]--<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,NULL										[ORGN_INL_PCKP_EST_DTM]
		,NULL																			[ORGN_PORT_NM]--if Request/Header/Transportation MethodofTransportation  is not Air and <Request><Header><Transportation><ReferenceType type=""OriginPort""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
		,NULL																			[ORGN_PORT_UNLOC_CD]--If Request/Header/Transportation LegType=""Primary"" or ""First"" then If Request/Header/Transportation/OriginCodeType/type = ""IATA"" or ""IATACode"" then		--<Request><Header><Transportation><OriginCodeType><OriginCode></OriginCode></OriginCodeType></Transportation></Header></Request>"
		,FORMAT( TP13.Dt_Conclusao , 'dd/MM/yy')										[PLACE_OF_DEL_ACT_DT]----<Request><Header><Status><StatusType type=""ActPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"--<Request><Header><Status><StatusType type=""ActualPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[PLACE_OF_DEL_ACT_DTM]
		,FORMAT( TP13.Dt_Previsao , 'dd/MM/yy')											[PLACE_OF_DEL_EST_DT]--"<Request><Header><Status><StatusType type=""EstimatedPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"--<Request><Header><Status><StatusType type=""EstPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( TP13.Dt_Previsao , 'dd/MM/yy')											[PLACE_OF_DEL_EST_DTM]
		,UPPER(DSTFNL.Nome_Local)															[PLACE_OF_DEL_NM]----"Request><Header><References type=""PlaceofDelivery Name""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="PlaceofDelivery Name"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,(CASE WHEN DSTFNL.SCAC is null THEN DSTFNL.Cd_Pais+DSTFNL.Cd_Local
			ELSE DSTFNL.Cd_Pais + DSTFNL.SCAC END)										[PLACE_OF_DEL_UNLOC_CD]
		,NULL																			[PLACE_OF_RCPT_ACT_DT]--"<Request><Header><Status><StatusType type=""ActPlaceofReceiptDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"

		,NULL																		[PLACE_OF_RCPT_EST_DT]--"<Request><Header><Status><StatusType type=""EstPlaceofReceiptDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
--"<Request><Header><Status><StatusType type=""EstimatedPlaceofReceiptDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[PLACE_OF_RCPT_EST_DTM]
				
		,UPPER(ORGPLNT.Nome_Local)														[PLACE_OF_RCPT_NM]--"<Request><Header><References type=""PlaceofReceipt Name""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="PlaceofReceipt Name"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,(CASE WHEN ORGPLNT.SCAC is null THEN ORGPLNT.Cd_Pais+ORGPLNT.Cd_Local
			ELSE ORGPLNT.Cd_Pais + ORGPLNT.SCAC END)									[PLACE_OF_RCPT_UNLOC_CD]
		,FORMAT(LLP.ATA_Lim , 'dd/MM/yy')												[PORT_OF_ARRVL_ACT_DT]
		,FORMAT(LLP.ETA_Lim , 'dd/MM/yy')												[PORT_OF_ARRVL_EST_DT]
		,UPPER(DST.Nome_Local)															[PORT_OF_ARRVL_NM]
		,(CASE WHEN DST.SCAC is null THEN DST.Cd_Pais+DST.Cd_Local
		ELSE DST.Cd_Pais + DST.SCAC END)												[PORT_OF_ARRVL_UNLOC_CD]
		,FORMAT(LLP.ATD_lim, 'dd/MM/yy')												[PORT_OF_DEPTR_ACT_DT]
		,FORMAT(LLP.ETD_Lim, 'dd/MM/yy')												[PORT_OF_DEPTR_EST_DT]
		,UPPER(ORG.Nome_Local)															[PORT_OF_DEPTR_NM]	
		,(CASE WHEN ORG.SCAC is null THEN ORG.Cd_Pais+ORG.Cd_Local
			ELSE ORG.Cd_Pais + ORG.SCAC END)											[PORT_OF_DEPTR_UNLOC_CD]
		,FORMAT(TP15.Dt_Conclusao, 'dd/MM/yy')										[PORT_OF_ENTRY_ACT_DT]
		,FORMAT( LLP.ETA_LIM, 'dd/MM/yy')											[PORT_OF_ENTRY_EST_DT]
		,UPPER(DST.Nome_Local)														[PORT_OF_ENTRY_NM]
		,(CASE WHEN DST.SCAC is null THEN DST.Cd_Pais+DST.Cd_Local
			ELSE DST.Cd_Pais + DST.SCAC END)										[PORT_OF_ENTRY_UNLOC_CD]			
		,FORMAT( LLP.ATD_LIM, 'dd/MM/yy')											[PORT_OF_EXIT_ACT_DT]--<Request><Header><Status><StatusType type="ActPortOfExitDate"></StatusType></Status></Header></Request>
		,FORMAT( LLP.ATD_LIM, 'dd/MM/yy')											[PORT_OF_EXIT_EST_DT]--"<Request><Header><Status><StatusType type=""EstPortOfExitDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,NULL																		[PORT_OF_EXIT_UNLOC_CD]

		,FORMAT( TP1.Dt_Conclusao, 'dd/MM/yy')										[PRESHPMNT_ADVC_DT]--"<Request><Header><Status><StatusType type=""PreShipmentAdviceDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"

		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIM) > 0 
			THEN 
				(Case when [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIM) < isnull(HOU.vlr_frete_efet_him,0) 
					THEN 
						[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIM)
					ELSE
						[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIM) - isnull(HOU.vlr_frete_efet_him,0)
				END)
			ELSE 
				LLP.Vlr_Invoice - isnull(HOU.vlr_frete_efet_him,0) END)					[REPRT_VAL_AMT]--<Request><Footer><Measurements item="ReportableValueAmount"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>--<Request><Footer><Measurements item="TotalFAS"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		
		,FORMAT( LLP.ETA_LIM, 'dd/MM/yy')												[RQST_ETA_DEST_DT]--"<Request><Header><Status><StatusType type=""RequestedETADestDate""></StatusType>           <StatusTime></StatusTime></Status></Header></Request>"
		,Sales.Nome_Usuario																[SALES_PERSON_NM]--spINTSmartVendedor_Sel <Request><Header><CodesNames><CodesNamesName></CodesNamesName></CodesNames></Header></Request>
		,isnull(PO8.Numero_PO_HIM,HOU.HAWB_HIM)											[SAP_SHPMNT_NBR]--"<Request><Header><References type=""SAPShipmentNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--<Request><Header><Transportation><ReferenceType type="SAPShipmentNumber"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,NULL																			[SBU]--Request><Header><Transportation><ReferenceType type="SBU"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>--"<Request><Header><References type=""SBU""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																			[SBU_DESC]--"<Request><Header><References type=""SBUDescription""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="SBUDescription"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,FORMAT([dbo].[fDW_SDA_PAYMENT_DT]('SDA'), 'dd/MM/yy')						[SDA_PAYMENT_DT]--[spINTSmartPagamentos_Sel]'EMATL202407001BR','SDA'
		,UPPER(cast(LLP.ID_Status as varchar(2)) + '-' + TSP.Status_Descricao_Ingles)	[SHIPMENT_STATUS]
		,NULL																			[SHP_TO_PRTY_ID]
		,NULL																			[SLD_TO_PRTY_ID]
		,NULL																			[SLLR_PRTY_ID]
		,[dbo].[fBusca_TEUS](HOU.NUm_PROC_HIM)											[TEU_QTY]--<Request><Header><Amounts><AmountType>NumberOfTEUs</AmountType></Amounts></Header></Request>
		,HOU.Vol_Tot_HIM																	[TOT_CUBIC_FT_QTY]--<Request><Footer><Measurements><MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,UPPER(TER.Nome_Terminal)														[TRMNL_PIER_NM]
		,isnull(HOU.vlr_frete_efet_him,0)												[TTL_FRGHT_BOL_AWB_PRPD_AMT]--<Request><Header><Transportation><ReferenceType type="FreightAmount"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,HOU.Viagem_him																	[VOYG_FLGHT_NBR]--"If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""VoyageNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"--"If Request/Header/Transportation LegType=""Primary"" or ""First"" Request><Header><Transportation><ReferenceType type=""FlightNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
		,NULL																			[SOLAS_VRFDGRSSMASSCUTOFF_DT]-- only EM"<Request><Header><Status><StatusType type=""SolasVrfdGrMassCutDt""></StatusType>StatusTime></StatusTime></Status></Header></Request>"
		,NULL																			[SOLAS_VRFDGRSSMASSCUTOFF_DTM]--<Request><Header><Status><StatusType type="SolasVrfdGrMassCutDt"></StatusType></Status></Header></Request>
		,NULL																			[LC_ISSUING_NBR]--"If Request/Header/LetterofCredit/BankParties type = ""IssuingBank"" then <Request><Header><LetterofCredit><BankParties><BankPartyName></BankPartyName></BankParties></LetterofCredit></Header></Request>"
		,FORMAT([dbo].fDW_ORDR_CRTN_DT(HOU.NUm_PROC_HIM), 'dd/MM/yy')					[ORDR_CRTN_DT]--spINTDtPedido '" & ProcessoDT.Rows(0)("processo").ToString() & "'--"<Request><Header><Status><StatusType type=""OrderReceiveDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( PO13.Data_PO_HIM, 'dd/MM/yy')										[CERT_OF_ORGN_APPLIED_DT]--<Request><Header><Status><StatusType type="CertOriginApplied"></StatusType></Status></Header></Request>
			
	FROM DBO.HOUSE_IMP_MAR		HOU			WITH (NOLOCK) 
	JOIN LLP_IMP_MAR			LLP			WITH (NOLOCK) ON LLP.NUM_PROC_LIM	=	HOU.NUM_PROC_HIM
	JOIN JOB_IMP_MAR			JOB			WITH (NOLOCK) ON JOB.NUM_PROC_HIM	=	HOU.NUM_PROC_HIM
	LEFT JOIN MASTER_IMP_MAR	MAS			WITH (NOLOCK) ON MAS.NUM_PROC_MIM	=	HOU.NUM_PROC_MIM
	LEFT JOIN PESSOA			Exporter	WITH (NOLOCK) ON Exporter.CD_PES	=	HOU.Cd_Export_HIM
	LEFT JOIN PESSOA			Consignee	WITH (NOLOCK) ON Consignee.CD_PES	=	HOU.Cd_Consig_HIM	
	LEFT JOIN PESSOA			Notify		WITH (NOLOCK) ON Notify.CD_PES		=	HOU.Cd_Import_HIM	
	
	LEFT JOIN PESSOA			TRANSP		WITH (NOLOCK) ON TRANSP.CD_PES		=	LLP.Cd_Transportadora
	LEFT JOIN PESSOA_LLP		TRANSPPLLP	WITH (NOLOCK) ON TRANSPPLLP.CD_PES	=	LLP.Cd_Transportadora
	LEFT JOIN Tipo_Carga		TC			WITH (NOLOCK) ON TC.Cd_Tp_Carga		=	LLP.Cd_Tp_Carga
	LEFT JOIN PESSOA_LLP		PLLP		WITH (NOLOCK) ON HOU.CD_CONSIG_HIM	=	PLLP.CD_PES
	LEFT JOIN GRUPO				GRP			WITH (NOLOCK) ON GRP.CD_PES_GRUPO	=   PLLP.CD_PES_GRUPO
	LEFT JOIN TAREFAS_PROCESSOS TP40		WITH (NOLOCK) ON TP40.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP40.ID_TASK = 40
	LEFT JOIN TAREFAS_PROCESSOS TP217		WITH (NOLOCK) ON TP217.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP217.ID_TASK = 217
	LEFT JOIN TAREFAS_PROCESSOS TP83		WITH (NOLOCK) ON TP83.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP83.ID_TASK = 83
	LEFT JOIN TAREFAS_PROCESSOS TP66		WITH (NOLOCK) ON TP66.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP66.ID_TASK = 66
	LEFT JOIN TAREFAS_PROCESSOS TP45		WITH (NOLOCK) ON TP45.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP45.ID_TASK = 45
	LEFT JOIN TAREFAS_PROCESSOS TP4			WITH (NOLOCK) ON TP4.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP4.ID_TASK = 4
	LEFT JOIN TAREFAS_PROCESSOS TP13		WITH (NOLOCK) ON TP13.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP13.ID_TASK = 13
	LEFT JOIN TAREFAS_PROCESSOS TP7			WITH (NOLOCK) ON TP7.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP7.ID_TASK = 7
	LEFT JOIN TAREFAS_PROCESSOS TP109		WITH (NOLOCK) ON TP109.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP109.ID_TASK = 109
	LEFT JOIN TAREFAS_PROCESSOS TP10		WITH (NOLOCK) ON TP10.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP10.ID_TASK = 10
	LEFT JOIN TAREFAS_PROCESSOS TP1			WITH (NOLOCK) ON TP1.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP1.ID_TASK = 1
	LEFT JOIN TAREFAS_PROCESSOS TP5			WITH (NOLOCK) ON TP5.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP5.ID_TASK = 5
	LEFT JOIN TAREFAS_PROCESSOS TP58		WITH (NOLOCK) ON TP58.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP58.ID_TASK = 58
	LEFT JOIN TAREFAS_PROCESSOS TP21		WITH (NOLOCK) ON TP21.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP21.ID_TASK = 21
	LEFT JOIN TAREFAS_PROCESSOS TP28		WITH (NOLOCK) ON TP28.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP28.ID_TASK = 28
	LEFT JOIN TAREFAS_PROCESSOS TP160		WITH (NOLOCK) ON TP160.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP160.ID_TASK = 160
	LEFT JOIN TAREFAS_PROCESSOS TP59		WITH (NOLOCK) ON TP59.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP59.ID_TASK = 59
	LEFT JOIN TAREFAS_PROCESSOS TP25		WITH (NOLOCK) ON TP25.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP25.ID_TASK = 25
	LEFT JOIN TAREFAS_PROCESSOS TP15		WITH (NOLOCK) ON TP15.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP15.ID_TASK = 15
	LEFT JOIN TAREFAS_PROCESSOS TP63		WITH (NOLOCK) ON TP63.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP63.ID_TASK = 63
	LEFT JOIN TAREFAS_PROCESSOS TP27		WITH (NOLOCK) ON TP27.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP27.ID_TASK = 27
	LEFT JOIN TAREFAS_PROCESSOS TP67		WITH (NOLOCK) ON TP67.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP67.ID_TASK = 67
	LEFT JOIN TAREFAS_PROCESSOS TP114		WITH (NOLOCK) ON TP114.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP114.ID_TASK = 114
	LEFT JOIN TAREFAS_PROCESSOS TP41		WITH (NOLOCK) ON TP41.NUM_PROC		=	HOU.NUM_PROC_HIM AND TP41.ID_TASK = 41

	LEFT JOIN NATURE_GOODS		NG			WITH (NOLOCK) ON NG.NUM_PROC		=	HOU.NUM_PROC_HIM
	LEFT JOIN Armador			ARM			WITH (NOLOCK) ON ARM.Cd_Armador		=	JOB.cd_Armador AND ARM.SCAC IS NOT NULL
	LEFT JOIN PO_HIM			PO5			WITH (NOLOCK) ON PO5.Num_Proc_HIM	=	HOU.NUM_PROC_HIM AND PO5.ID_DC = 5
	LEFT JOIN PO_HIM			PO71		WITH (NOLOCK) ON PO71.Num_Proc_HIM	=	HOU.Num_Proc_HIM AND PO71.ID_DC = 71
	LEFT JOIN PO_HIM			PO8			WITH (NOLOCK) ON PO8.Num_Proc_HIM	=	HOU.NUM_PROC_HIM AND PO8.ID_DC = 8
	LEFT JOIN PO_HIM			PO13		WITH (NOLOCK) ON PO13.Num_Proc_HIM	=	HOU.Num_Proc_HIM AND PO13.ID_DC = 13
	--LEFT JOIN PO_HIM			PO2			WITH (NOLOCK) ON PO2.Num_Proc_HIM	=	HOU.Num_Proc_HIM AND PO2.ID_DC = 2

	LEFT JOIN Localidade		DST			WITH (NOLOCK) ON DST.Cd_Local		=	HOU.Cd_Dst_HIM
	LEFT JOIN Localidade		ORG			WITH (NOLOCK) ON ORG.Cd_Local		=	HOU.Cd_Org_HIM
	LEFT JOIN Pais				DSTPais		WITH (NOLOCK) ON DSTPais.cd_pais	=	DST.cd_pais
	LEFT JOIN Pais				ORGPais		WITH (NOLOCK) ON ORGPais.cd_pais	=	ORG.cd_pais
	LEFT JOIN Localidade		DSTFNL		WITH (NOLOCK) ON DSTFNL.Cd_Local	=	LLP.Cd_DstFinal_Lim
	LEFT JOIN Localidade		ORGPLNT		WITH (NOLOCK) ON ORGPLNT.Cd_Local	=	LLP.Cd_planta_Lim
	LEFT JOIN Usuario			US			WITH (NOLOCK) ON US.cd_usuario		=	JOB.Cd_Usuario
	LEFT JOIN Campo_Processo	CP32		WITH (NOLOCK) ON CP32.NUM_PROC		=	HOU.Num_Proc_HIM AND CP32.ID_Campo = 32	
	LEFT JOIN Campo_Processo	CP5			WITH (NOLOCK) ON CP5.NUM_PROC		=	HOU.Num_Proc_HIM AND CP5.ID_Campo = 5	

	LEFT JOIN Usuario			Sales		WITH (NOLOCK) ON Sales.cd_usuario	=	JOB.cd_Vendedor
	LEFT JOIN Tipo_Status_Processo TSP		WITH (NOLOCK) ON LLP.id_status		=	TSP.id_status
	LEFT JOIN Terminal			TER			WITH (NOLOCK) ON TER.cd_terminal	=	LLP.cd_terminal

	Where
		HOU.Num_Proc_HIM in ('IMOXT202408014BR')
		--AND
		--convert(datetime,HOU.Dt_emis_him,105) > getdate() -31


UNION ALL

	SELECT 
		HOU.Num_Proc_HEA																[FRWDR_REF_NBR]
		,FORMAT(TP59.Dt_Conclusao , 'dd/MM/yy')											[ADVANCEMENT_REQ_DT]--I think it is 59 - -Solicitação de Numerário - <StatusType type="AdvancementReqDt"/>
		,NULL																			[AFRMM_PAYMENT_DT]
		,FORMAT(TP161.Dt_Conclusao , 'dd/MM/yy')										[ARR_DT]
		,isnull(GRP.Smart_Exp,HOU.Cd_Export_HEA)										[BDP_CLIENT_CD] -- spIntPessoa_Sel I = Smart_Imp,E = Smart_Exp <Request><Header><References type="ClientCode"><ReferenceNumber></ReferenceNumber>
		,FORMAT(TP40.Dt_Conclusao , 'dd/MM/yy')											[BDP_INVC_ACT_DT]	--Smart_Conclusao - spSmartBilledDate_Sel -   <Request><Header><Status><StatusType type="BilledDate"></StatusType>
		,FORMAT(TP40.Dt_Conclusao , 'dd/MM/yy')											[BDP_INVC_ACT_DTM]
		,[dbo].[fDW_BDP_INVC_REF_NBR](HOU.Num_Proc_HEA)									[BDP_INVC_REF_NBR]
		,NULL																			[BDP_REP_PRTY_ID]
		,LEFT(HOU.Num_Proc_HEA,1)														[BDP_SERVICE_CD]--<Request><Header Type="Export"></Header ></Request> then E
		,'01BDPBRSAO' 																	[BDP_SS_ID]
		,(CASE WHEN HOU.Num_Proc_MEA <> 'JOB' THEN 'Y' ELSE
			(CASE WHEN ARM.SCAC = 'BOPT' THEN 'Y' ELSE
				(CASE WHEN ARM.SCAC = 'SBHG' THEN 'S' ELSE
					'N'
				END)
			END)
		END)																			[BDP_TRANS_IND]
		,(CASE WHEN HOU.Tp_Frete_HEA = 'P' THEN HOU.Vlr_Frete_Tot_HEA ELSE '0.00' END)	[BF_BOL_AWB_PRPD_AMT]--<Request><Header><Amounts><AmountType>BaseFreightBolAwbAmountPrepaid</AmountType></Amounts></Header></Request>
		,NULL																			[BKNG_CNFRM_DT]
		,FORMAT(isnull(DATEADD(day,-1, LLP.ATD_Lea),TP41.Dt_Conclusao) , 'dd/MM/yy')	[BOL_POST_AUDT_BCK_DT]	--Smart_Conclusao - <Request><Header><Status><StatusType type="BOLBackDate"></StatusType>		
		,FORMAT(isnull(DATEADD(day,-1, LLP.ATD_Lea),TP41.Dt_Conclusao) , 'dd/MM/yy')	[BOL_POST_AUDT_BCK_DTM]	
		,NULL																			[BOL_PRE_AUDT_RCV_DT]	-- Code - 66	Envio do draft do BL--<Request><Header><Status><StatusType type="BillofLadingRetreivedDate"></StatusType>
		,NULL																			[BOL_PRE_AUDT_RCV_DTM]
		,FORMAT(TP5.Dt_Conclusao,'dd/MM/yy')											[BKNG_CNFRMTN_RCVD_FROM_SS_DT]
		,FORMAT(TP58.Dt_Conclusao,'dd/MM/yy')											[BKNG_DT]
		,FORMAT(TP58.Dt_Conclusao,'dd/MM/yy')											[BKNG_DTM]
		,(CASE WHEN hou.Num_Proc_MEA = 'JOB' THEN NULL  ELSE HOU.Num_Proc_HEA END)		[BKNG_NBR]--HouseBookingNumber
		,NULL																			[BOL_ACTN_DT]

		,FORMAT(LLP.Dt_Impres_Lea,'dd/MM/yy')											[BOL_AWB_ISS_DT]
		,HOU.HAWB_HEA																	[BOL_AWB_NBR] --HouseBillofLadingNumber-- HouseAirwayBill- verificar		
		,FORMAT(LLP.ATD_Lea,'dd/MM/yy')													[BOL_SBMT_DT]
		,FORMAT(LLP.ATD_Lea,'dd/MM/yy')													[BOL_SBMT_DTM]
		,NULL																			[BYR_PRTY_ID]
		,'LCL' 																			[CARGO_TYP]
		,NULL																			[CARRIER_DOC_CUTOFF_DT]--<Request><Header><Status><StatusType type="CarrierDocCutoffDate"></StatusType>
		,NULL																			[CARRIER_DOC_CUTOFF_DTM]--<Request><Header><Status><StatusType type="CarrierDocCutoffDate"></StatusType>
		,NULL																			[CHB_REF_NBR]--<Request><Header><References type="ClearingAgentReferenceNumber"><ReferenceNumber></ReferenceNumber>
		,LLP.Peso_Cubado_lea															[CHRG_WGHT_QTY] --EA e IA	"<Request><Header><Amounts><AmountType>ChargeableWeight</AmountType><AmountValue></AmountValue></Amounts></Header></Request>"
		,LEFT([dbo].[RemoveNonAlphaCharacters](NG.Descr),100)							[CARGO_DESC]--CargoDescription <Request><Header><CodesNames><CodesNamesType></CodesNamesType></CodesNames></Header></Request>		
		,(CASE WHEN HOU.Num_Proc_MEA <> 'JOB' THEN 'BDP TRANSPORT, INC' ELSE
		NULL END)																		[CARR_NM]--If Request/Header/Transportation MethodofTransportation  is  Air and   <Request><Header><Transportation><Carrier><CarrierName></CarrierName></Carrier></Transportation></Header></Request>
		,FORMAT(TP21.Dt_Conclusao, 'dd/MM/yy')											[CARR_PYMNT_DT]--NOt Mapped in The File
		,(CASE WHEN HOU.Num_Proc_MEA <> 'JOB' THEN 'BOPT' ELSE NULL END)				[CARR_SCAC_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First"" thenIf Request/Header/Transportation/Carrier/CarrierCode/type is not equal to null then <Request><Header><Transportation><Carrier><CarrierCode></CarrierCode></Carrier></Transportation></Header></Request>"		
		,NULL	[CHB_PRTY_ID]
		,LLP.Selling_Rates_Lea															[CHRG_RATE_AMT]--only ea
		,isnull(GRP.Smart_Exp,HOU.Cd_Export_HEA)+HOU.Cd_Export_HEA						[CLNT_CD] --<Request><Header><References type=""BDPClientCode""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,(CASE WHEN hou.Num_Proc_MEA <> 'JOB'  AND substring(hou.Num_Proc_MEA,3,3) <> 'CLI' THEN 'C' ELSE 'D' END)		[CNSOL_DRCT_CD]--"<Request><Header><References type=""ConsolIndicator""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,(CASE WHEN hou.Num_Proc_MEA <> 'JOB'  THEN hou.Num_Proc_MEA ELSE NULL END)     [CNSOL_NBR] --<Request><Header><References type=""ConsolNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																			[CNTNR_EQUIP_CT]
		,NULL																			[CNTNR_TYP_CD_1]
		,NULL																			[CNTNR_TYP_CD_2]
		,NULL																			[CNTNR_TYP_CD_3]
		,HOU.Cd_Consig_HEA																[CONSG_PRTY_CD]
		,NULL																			[CONSG_PRTY_ID]
		,NULL																			[CSTMS_ENTRY_PRMT_NBR] --Only IM
		,FORMAT(TP4.Dt_Conclusao, 'dd/MM/yy')											[CSTMS_ENTRY_PRMT_REL_DT]
		,FORMAT(TP4.Dt_Conclusao, 'dd/MM/yy')											[CSTMS_ENTRY_PRMT_REL_DTM]
		,FORMAT(PO4.Data_PO_Hea, 'dd/MM/yy')											[CSTMS_ENTRY_PRMT_SBMT_DT]--Code - "<Request><Header><Status><StatusType type=""CustomsEntryPermitSubmissionDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[CSTMS_ENTRY_PRT_NM]--ONLY IM ,EO,IO
		,NULL																			[CSTMS_ENTRY_PRT_UNLOC_CD]--ONLY IM ,EO,IO
		
		,LEFT(UPPER(LLP.Canal_Lea),2)													[CSTMS_ENTRY_TYP_CD]--"<Request><Header><References type=""CustomsEntrytypeCode""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																			[CSTMS_PRT_ACT_DT]
		,NULL																			[CSTMS_PRT_EST_DT]
		,NULL																			[CSTMS_RLS_DT] --If Request/Header Type="Import"<Request><Header><Status><StatusType type="CustomsReleaseDate"></StatusType>           <StatusDate></StatusDate></Status></Header></Request>
		,NULL																			[CSTMS_RLS_DTM]
		,[dbo].[fDW_CUSTOMER_CSR_NM](HOU.Num_Proc_HEA)									[CUSTOMER_CSR_NM]--spCSRJob_SEL - <Request><Header><Parties><Party-Contacts type="CSR"><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
		,UPPER(DST.Cd_Pais)																[DEST_CNTRY_CD]--If Request/Header/Transportation LegType="Primary" or "First"<Request><Header><Transportation><DestinationCountryCode></DestinationCountryCode></Transportation></Header></Request>
		,UPPER(DSTPais.Nome_Pais)														[DEST_CNTRY_NM]
		,UPPER(DST.Cd_Pais)																[DEST_CNTRY_UNLOC_CD]
		,NULL																			[DEST_DEL_ACT_DT]---- Only Import ID_Task 13 Dt_Conclusao --<Request><Header><Status><StatusType type="ActDestinationDeliveryDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,NULL																			[DEST_DEL_ACT_DTM]
		,NULL																			[DEST_DEL_EST_DT]---- Only Import ID_Task 13 Dt_Previsao--<Request><Header><Status><StatusType type="EstDestinationDeliveryDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,NULL																			[DEST_DEL_EST_DTM]
		,NULL																			[DEST_INL_CARR_NM]
		,NULL																			[DEST_INL_CARR_SCAC_CD]
		,NULL																			[DLVRY_ORDR_CREATN_DT_ACT_DT]--Only Import ID_Task 7 Dt_Conclusao <Request><Header><Status><StatusType type="ActDeliveryOrderCreationDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,NULL																			[DLVRY_ORDR_DISTRIB_DT_ACT_DT]--Only Import ID_Task 7 Dt_Conclusao <Request><Header><Status><StatusType type="ActDeliveryOrderDistributionDate"></StatusType><StatusTime></StatusTime></Status></Header></Request>
		,NULL																			[DOC_DIST_RCV_ACT_DT]
		,NULL																			[DOC_DIST_RCV_ACT_DTM]
		,NULL																			[DOC_DIST_SEND_ACT_DT]
		,NULL																			[DOC_DIST_SEND_ACT_DTM]
		,FORMAT(TP12.Dt_Previsao , 'dd/MM/yy')											[DOC_DIST_SEND_EST_DT]
		,FORMAT(TP12.Dt_Previsao , 'dd/MM/yy')											[DOC_DIST_SEND_EST_DTM]
		,NULL																			[DOC_DIST_BY_NM]
		,NULL																			[DOCK_RCPT_CRTN_DT]--Only Import ID_Task 109 Dt_Conclusao--<Request><Header><Status><StatusType type="DockReceiptCreationDate"></StatusType></Status></Header></Request>
		,NULL																			[DRAFT_BOL_INSTR_RECVD_DT]--Only EM  ID_Task 66 Dt_Conclusao--<Request><Header><Status><StatusType type="DraftBOLInstrRecvdDt"></StatusType></Status></Header></Request>
		,NULL																			[ENTRY_IMM_DEL_RCV_DT]
		,NULL																			[ENTRY_IMM_DEL_RCV_DTM]
		,NULL																			[ENTRY_SUMM_SBMT_DT]--Not Sent"<Request><Header><Status><StatusType type=""EntrySummaryRejectDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[ENTRY_SUMM_SBMT_DTM]
		,FORMAT(LLP.ATD_Lea, 'dd/MM/yy')												[EXIT_CITY_ACT_DT]
		,NULL																			[EXP_CNTRY_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First""  <Request><Header><Transportation><OriginCountryCode></OriginCountryCode></Transportation></Header></Request>"
		,UPPER(ORG.Cd_Pais)																[EXP_CNTRY_UNLOC_CD]
		,HOU.Num_Proc_HEA																[EXPRT_JOB_NBR]
		,NULL																			[EXPTR_SHPR_PRTY_CD]
		,NULL																			[EXPTR_SHPR_PRTY_ID]
		,NULL																			[FEU_QTY]
		,FORMAT(TP12.Dt_Conclusao , 'dd/MM/yy')											[FILE_CLS_DT]--"<Request><Header><Status><StatusType type=""FileClosedDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"	--"<Request><Header><Status><StatusType type=""ClosedDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT(TP12.Dt_Conclusao , 'dd/MM/yy')											[FILE_CLS_DTM]
		,NULL																			[FILE_CREATED_BY_NM]		
		,CONVERT(VARCHAR(8), CONVERT(DATE, HOU.Dt_Emis_HEA, 103), 3)					[FILE_CRTN_DT]
		,CONVERT(VARCHAR(8), CONVERT(DATE, HOU.Dt_Emis_HEA, 103), 3)					[FILE_CRTN_DTM]
		,FORMAT(TP10.Dt_Conclusao , 'dd/MM/yy')											[FINAL_GOODS_ISS_DT]
		,FORMAT(TP10.Dt_Conclusao , 'dd/MM/yy')											[FINAL_GOODS_ISS_DTM]
		,NULL																			[FRWDR_PRTY_ID]		
		,NULL																			[GE_DIVISION_CD]
		,NULL																			[GE_GROUP_CD]
		,NULL																			[GE_SBU_CD]
		,Exporter.GLOBAL_ENTITY_ID														[GEID]--"<Request><Header><Parties type=""Exporter""><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>"--"<Request><Header><Parties type=""Importer""><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>"
		,NULL																			[GLBL_AGNT_PRTY_ID]
		,UPPER(replace(replace(replace(ltrim(rtrim(HOU.Obs_HEA)),char(10),' '),char(13),' '),char(160),' ')) [GNRL_DESC]--"<Request><Header><References type=""GeneralDescription""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,FORMAT(TP10.Dt_Conclusao,'dd/MM/yy')											[GOODS_AVLBL_SHP_ACT_DT]--ONly for EA,EM,EO,IOActualPlantShipDate --"If the file is not  Meridian If <Request><Header><Status><StatusType type=""ActGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		<Request><Header><Status><StatusType type=""ActualPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT(TP10.Dt_Conclusao,'dd/MM/yy')											[GOODS_AVLBL_SHP_ACT_DTM]
		,FORMAT(TP10.Dt_Previsao,'dd/MM/yy')											[GOODS_AVLBL_SHP_EST_DT] --ONly for EA,EM,EO,IO	--"<Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"	--"If the file is not for Meridian 		--If <Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		--<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"		--"If the file is not for Meridian		--If <Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		--<Request><Header><Status><StatusType type=""EstimatedShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT(TP10.Dt_Previsao,'dd/MM/yy')											[GOODS_AVLBL_SHP_EST_DTM]
		,FORMAT(TP4.Dt_Conclusao,'dd/MM/yy')											[GOV_EXP_PRMSS_RLS_DT]--ONly for EA,EM,EO - "If Request/Header Type=""Export""<Request><Header><Status><StatusType type=""CustomsReleaseDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT(TP4.Dt_Conclusao,'dd/MM/yy')											[GOV_EXP_PRMSS_RLS_DTM]
		,ISNULL(PO12.Numero_PO_HEA,PO204.Numero_PO_HEA)									[GOV_EXP_PRMSS_RLS_NBR]--ONly for EA,EM,EO"<Request><Header><References type=""GovernmentPermissionToExportReleaseNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																			[GOV_EXP_PRMSS_SBMT_DT]--Not Send -"If Request/Header Type=""Export""   <Request><Header><Status><StatusType type=""CustomsSubmitDate""></StatusType>           <StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[GOV_EXP_PRMSS_SBMT_DTM]
		,NULL																			[GOV_EXP_PRMSS_SBMT_NBR]
		,FORMAT(PO4.Data_PO_HEA, 'dd/MM/yy')											[GOV_PYMNT_STMNT_SBMT_DT]--IMP ID_DC 5, EXP-ID-DC 4<Request><Header><Status><StatusType type="GovernmentPaymentStatementSubmissionDate"></StatusType></Status></Header></Request>
		,FORMAT(PO4.Data_PO_HEA, 'dd/MM/yy')											[GOV_PYMNT_STMNT_SBMT_DTM]
		,HOU.Peso_Bruto_HEA																[GROSS_TRANS_KILO_QTY]--"<Request><Header><Detail><ProductDetail><Measurements type=""GrsWtKgs""><MeasurementValue></MeasurementValue></Measurements></ProductDetail></Detail></Header></Request>"
		,HOU.Peso_Bruto_HEA * 2.2046													[GROSS_TRANS_POUND_QTY]
		,NULL																			[IMPORT_DCLRTN_DRFT_DT]
		,NULL																			[IMPORT_LIC_NEEDED_IND]
		,NULL																			[IMPTR_PRTY_CD]
		,NULL																			[IMPTR_PRTY_ID]
		,NULL																			[INSPECTN_DT_ACT_DT]
		,HOU.tp_frete_hea																[INTL_FRGHT_TERM_CD]--<Request><Header><Transportation><PrepaidorCollect></PrepaidorCollect></Transportation></Header></Request>
		,NULL																			[ITS_PLACE_OF_DLVRY_NM]	--"If Request/Header/Transportation MethodofTransportation  is not Air and  If <Request><Header><Transportation><Destination LocationType=""PlaceofDelivery""><DestinationName></DestinationName> </Destination></Transportation></Header></Request>"
		,NULL																			[ITS_PLACE_OF_RCPT_NM]
		,NULL																			[ITS_PORT_OF_DSCHRG_NM]
		,NULL																			[ITS_PORT_OF_ENTRY_NM]
		,NULL																			[ITS_PORT_OF_LOAD_NM]
		,NULL																			[ITS_PORT_OF_ORGN_NM]
		,FORMAT([dbo].[fDW_LAST_MDFD_BY_DT](HOU.Num_Proc_HEA), 'dd/MM/yy')				[LAST_MDFD_BY_DT]--"<Request><Header><Status><StatusType type=""LastModifiedByDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,(CASE WHEN PO71.Numero_PO_HEA is not null THEN 'Y' ELSE 'N' END)				[LETTR_OF_CRDT_IND]--<Request><Header><LetterofCredit><RequiredYN></RequiredYN></LetterofCredit></Header></Request>
		,NULL																			[LQDTN_DT]--Only Import Data da DI and id_dc=5 --<Request><Header><Status><StatusType type="LiquidationDate"></StatusType></Status></Header></Request>
		,NULL																			[LTST_DEL_CUTOFF_DT] -- Ony FOR EM --<Request><Header><Status><StatusType type=""LatestDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[LTST_DEL_CUTOFF_DTM]-- Ony FOR EM--<Request><Header><Status><StatusType type=""LatestDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[MANIFEST_DT]
		,NULL																			[MANUF_PLNT_PRTY_ID]
		,NULL																			[MBOL_ACTN_DT]--Not Send--<Request><Header><FileStatus><Code>"MbolActionDate"</Code></FileStatus></Header></Request>
		,HOU.MAWB_HEA																	[MBOL_MAWB_NBR]
		,NULL																			[MBOL_RCV_DT]
		,NULL																			[MBOL_RCV_DTM]
		,'A'																			[MOT_CD]--" Request><Header><Transportation MethodofTransportation= ""V""></Transportation></Header></Request>
		,(CASE WHEN HOU.cd_tp_oper='DDP' or HOU.cd_tp_oper='DDU' THEN 'DD' ELSE 
		'AA' END)																		[MOVE_TYP_CD]
		,(CASE WHEN HOU.cd_tp_oper='DDP' or HOU.cd_tp_oper='DDU' THEN 'DOOR TO DOOR' ELSE 
		'AIRPORT TO AIRPORT H/H (DUP)' END)												[MOVE_TYP_DESC]--Request><Header><Transportation><TypeofMoveCode Type="DP"></TypeofMoveCode></Transportation></Header></Request>---<Request><Header><Transportation><TypeofMoveDescription></TypeofMoveDescription></Transportation></Header></Request>			   	
		,HOU.MAWB_HEA																	[MSTR_BKNG_NBR]-- If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""BookingNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"		
		,UPPER(ARM.Nome_Cia_Aer)														[MSTR_CARR_NM]--If Request/Header/Transportation MethodofTransportation  is  Air and   <Request><Header><Transportation><Carrier><CarrierName></CarrierName></Carrier></Transportation></Header></Request>
		,ARM.SCAC																		[MSTR_CARR_SCAC_CD]		
		,HOU.Peso_Real_HEA																[NET_TRANS_KILO_QTY]--<Request><Footer><Measurements item="NetWtKgs"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>-<Request><Footer><Measurements item="NetWeightKilograms"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,HOU.Peso_Real_HEA * 2.2046														[NET_TRANS_POUND_QTY]--<Request><Footer><Measurements item="NetWeightPounds"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,NULL																			[NF_COMPLIMENTARY_DT]
		,NULL																			[NF_DRFT_DT]
		,NULL																			[NTFY_PRTY_ID]
		,NULL																			[ONBRD_CONFRM_DT]--If Request/Header/Transportation LegType=""Primary"" or ""First"" 	and If Request/Header/Transportation MethodofTransportation  is ""Ocean"" or ""V"" or ""Barge"" or ""B"" or ""C"" Request><Header><Transportation><OriginDate Type=""Actual""></OriginDate></Transportation></Header></Request>"
		,NULL																			[ONBRD_CONFRM_DTM]
		,NULL																			[OPEN_GATE_DT]
		,(CASE WHEN CP32.Campo_DADOS = '2' THEN 'FFD' ELSE 'CHB' END)					[OPRTG_UNT_CL_CD]--<Request><Header><References type=""OperatingUnitClassification""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,left([dbo].[fDW_ORDR_TYP_CD](HOU.Num_Proc_HEA),1)								[ORDR_TYP_CD]--<Request><Header><References type="OrderType"><ReferenceNumber></ReferenceNumber></References></Header></Request>		--<Request><Header><Transportation><ReferenceType type="OrderType"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,FORMAT(LLP.ATD_Lea, 'dd/MM/yy')												[ORGN_CITY_ACT_DT]--<Request><Header><Amounts><AmountType>ActCityOfOriginDate</AmountType></Amounts></Header></Request>
		,UPPER(ORG.cd_pais)																[ORGN_CNTRY_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First"" <Request><Header><Transportation><OriginCountryCode></OriginCountryCode></Transportation></Header></Request>"
		,UPPER(ORGPais.Nome_Pais)														[ORGN_CNTRY_NM]
		,UPPER(ORG.Cd_Pais)																[ORGN_CNTRY_UNLOC_CD]
		,FORMAT(TP5.Dt_Conclusao , 'dd/MM/yy')											[ORGN_INL_BOOK_ACT_DT]
		,FORMAT(TP10.Dt_Conclusao , 'dd/MM/yy')											[ORGN_INL_DEL_ACT_DT]--<Request><Header><Status><StatusType type="ActDomesticInlandDeliveryDate"></StatusType></Status></Header></Request>
		,FORMAT(TP10.Dt_Conclusao , 'dd/MM/yy')											[ORGN_INL_DEL_ACT_DTM]
		,FORMAT(TP10.Dt_Previsao , 'dd/MM/yy')											[ORGN_INL_DEL_EST_DT]--<Request><Header><Status><StatusType type="EstDomesticInlandDeliveryDate"></StatusType></Status></Header></Request>
		,FORMAT(TP10.Dt_Previsao , 'dd/MM/yy')											[ORGN_INL_DEL_EST_DTM]
		,UPPER(ORGPLNT.Nome_Local)														[ORGN_INL_LOCTN_NM]
		,(CASE WHEN ORGPLNT.IATACODE is null THEN ORGPLNT.Cd_Pais+ORGPLNT.Cd_Local 
			ELSE ORGPLNT.Cd_Pais + ORGPLNT.IATACODE END)								[ORGN_INL_LOCTN_UNLOC_CD]
		,FORMAT(TP10.Dt_Conclusao , 'dd/MM/yy')											[ORGN_INL_PCKP_ACT_DT]--10	EA,10	EM,10	EO - "If the file is not for Meridian If <Request><Header><Status><StatusType type=""ActGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT(TP10.Dt_Conclusao , 'dd/MM/yy')											[ORGN_INL_PCKP_ACT_DTM]
		,FORMAT(TP10.Dt_Previsao , 'dd/MM/yy')											[ORGN_INL_PCKP_EST_DT]--<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT(TP10.Dt_Previsao , 'dd/MM/yy')											[ORGN_INL_PCKP_EST_DTM]
		,UPPER(ORG.Nome_Local)															[ORGN_PORT_NM]--if Request/Header/Transportation MethodofTransportation  is not Air and <Request><Header><Transportation><ReferenceType type=""OriginPort""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
		,HOU.Cd_Org_HEA																	[ORGN_PORT_UNLOC_CD]--If Request/Header/Transportation LegType=""Primary"" or ""First"" then If Request/Header/Transportation/OriginCodeType/type = ""IATA"" or ""IATACode"" then		--<Request><Header><Transportation><OriginCodeType><OriginCode></OriginCode></OriginCodeType></Transportation></Header></Request>"
		,FORMAT(TP13.Dt_Conclusao , 'dd/MM/yy')											[PLACE_OF_DEL_ACT_DT]----<Request><Header><Status><StatusType type=""ActPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"--<Request><Header><Status><StatusType type=""ActualPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[PLACE_OF_DEL_ACT_DTM]	
		,FORMAT(TP13.Dt_Previsao , 'dd/MM/yy')											[PLACE_OF_DEL_EST_DT]--"<Request><Header><Status><StatusType type=""EstimatedPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"--<Request><Header><Status><StatusType type=""EstPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT(TP13.Dt_Previsao , 'dd/MM/yy')											[PLACE_OF_DEL_EST_DTM]
		,UPPER(DSTFNL.Nome_Local)														[PLACE_OF_DEL_NM]----"Request><Header><References type=""PlaceofDelivery Name""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="PlaceofDelivery Name"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,(CASE WHEN DSTFNL.IATACODE is null THEN DSTFNL.Cd_Pais+DSTFNL.Cd_Local
			ELSE DSTFNL.Cd_Pais + DSTFNL.IATACODE END)									[PLACE_OF_DEL_UNLOC_CD]
		,(CASE WHEN FORMAT(isnull(TP10.Dt_Conclusao,getdate()) , 'dd/MM/yy') = FORMAT(isnull(LLP.ATD_Lea,getdate()), 'dd/MM/yy')  
				then FORMAT(TP10.Dt_Conclusao , 'dd/MM/yy')	
				else FORMAT(DATEADD(day,1,TP10.Dt_Conclusao ),'dd/MM/yy') end)			[PLACE_OF_RCPT_ACT_DT]--"<Request><Header><Status><StatusType type=""ActPlaceofReceiptDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,(CASE WHEN FORMAT(isnull(TP10.Dt_Conclusao,getdate()) , 'dd/MM/yy') = FORMAT(isnull(LLP.ATD_Lea,getdate()), 'dd/MM/yy')  
				then FORMAT(TP10.Dt_Previsao , 'dd/MM/yy')	
				else FORMAT(DATEADD(day,1,TP10.Dt_Previsao ),'dd/MM/yy') end)			[PLACE_OF_RCPT_EST_DT]
		,(CASE WHEN FORMAT(isnull(TP10.Dt_Conclusao,getdate()) , 'dd/MM/yy') = FORMAT(isnull(LLP.ATD_Lea,getdate()), 'dd/MM/yy') 
				then FORMAT(TP10.Dt_Previsao , 'dd/MM/yy')	
				else FORMAT(DATEADD(day,1,TP10.Dt_Previsao ),'dd/MM/yy') end)			[PLACE_OF_RCPT_EST_DTM]	
		,UPPER(ORGPLNT.Nome_Local)														[PLACE_OF_RCPT_NM]--"<Request><Header><References type=""PlaceofReceipt Name""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="PlaceofReceipt Name"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,(CASE WHEN ORGPLNT.IATACODE is null THEN ORGPLNT.Cd_Pais+ORGPLNT.Cd_Local
			ELSE ORGPLNT.Cd_Pais + ORGPLNT.IATACODE END)								[PLACE_OF_RCPT_UNLOC_CD]
		,FORMAT(LLP.ATA_Lea, 'dd/MM/yy')												[PORT_OF_ARRVL_ACT_DT]
		,FORMAT(LLP.ETA_Lea, 'dd/MM/yy')												[PORT_OF_ARRVL_EST_DT]
		,UPPER(DST.Nome_Local)															[PORT_OF_ARRVL_NM]
		,UPPER(DST.IATACODE)															[PORT_OF_ARRVL_UNLOC_CD]
		,FORMAT(LLP.ATD_Lea, 'dd/MM/yy')												[PORT_OF_DEPTR_ACT_DT]
		,FORMAT(LLP.ETD_Lea, 'dd/MM/yy')												[PORT_OF_DEPTR_EST_DT]
		,UPPER(ORG.Nome_Local)															[PORT_OF_DEPTR_NM]
		,UPPER(ORG.IATACODE)															[PORT_OF_DEPTR_UNLOC_CD]
		,NULL																			[PORT_OF_ENTRY_ACT_DT]
		,NULL																			[PORT_OF_ENTRY_EST_DT]
		,UPPER(DST.Nome_Local)															[PORT_OF_ENTRY_NM]
		,UPPER(DST.IATACODE)															[PORT_OF_ENTRY_UNLOC_CD]		
		,FORMAT(LLP.ATD_LEA, 'dd/MM/yy')												[PORT_OF_EXIT_ACT_DT]--<Request><Header><Status><StatusType type="ActPortOfExitDate"></StatusType></Status></Header></Request>
		,NULL																			[PORT_OF_EXIT_EST_DT]--"<Request><Header><Status><StatusType type=""EstPortOfExitDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,UPPER(ORG.IATACODE)															[PORT_OF_EXIT_UNLOC_CD]
		,FORMAT(TP1.Dt_Conclusao, 'dd/MM/yy')											[PRESHPMNT_ADVC_DT]--"<Request><Header><Status><StatusType type=""PreShipmentAdviceDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEA) > 0 
			THEN 
				(Case when [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEA) < isnull(HOU.vlr_frete_tot_hea,0) 
					THEN 
						[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEA)
					ELSE
						[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEA) - isnull(HOU.vlr_frete_tot_hea,0)
				END)
			ELSE 
				LLP.Vlr_Invoice - isnull(HOU.vlr_frete_tot_hea,0) END)					[REPRT_VAL_AMT]--<Request><Footer><Measurements item="ReportableValueAmount"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>--<Request><Footer><Measurements item="TotalFAS"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,FORMAT( LLP.ETA_Lea, 'dd/MM/yy')												[RQST_ETA_DEST_DT]--"<Request><Header><Status><StatusType type=""RequestedETADestDate""></StatusType>           <StatusTime></StatusTime></Status></Header></Request>"
		,Sales.Nome_Usuario																[SALES_PERSON_NM]--spINTSmartVendedor_Sel <Request><Header><CodesNames><CodesNamesName></CodesNamesName></CodesNames></Header></Request>
		,isnull(PO8.Numero_PO_HEA,HOU.HAWB_HEA)											[SAP_SHPMNT_NBR]--"<Request><Header><References type=""SAPShipmentNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--<Request><Header><Transportation><ReferenceType type="SAPShipmentNumber"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,NULL																			[SBU]--Request><Header><Transportation><ReferenceType type="SBU"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>--"<Request><Header><References type=""SBU""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																			[SBU_DESC]--"<Request><Header><References type=""SBUDescription""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="SBUDescription"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,FORMAT([dbo].[fDW_SDA_PAYMENT_DT]('SDA'), 'dd/MM/yy')							[SDA_PAYMENT_DT]--[spINTSmartPagamentos_Sel]'EMATL202407001BR','SDA'
		,UPPER(cast(LLP.ID_Status as varchar(2)) + '-' + TSP.Status_Descricao_Ingles)	[SHIPMENT_STATUS]
		,NULL																			[SHP_TO_PRTY_ID]
		,NULL																			[SLD_TO_PRTY_ID]
		,NULL																			[SLLR_PRTY_ID]
		,[dbo].[fBusca_TEUS](HOU.NUm_PROC_HEA)											[TEU_QTY]--<Request><Header><Amounts><AmountType>NumberOfTEUs</AmountType></Amounts></Header></Request>
		,HOU.Vol_Tot_HEA																[TOT_CUBIC_FT_QTY]--<Request><Footer><Measurements><MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,UPPER(TER.Nome_Terminal)														[TRMNL_PIER_NM]
		,isnull(HOU.vlr_frete_tot_hea,0)												[TTL_FRGHT_BOL_AWB_PRPD_AMT]--<Request><Header><Transportation><ReferenceType type="FreightAmount"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,HOU.Voo_Hea																	[VOYG_FLGHT_NBR]--"If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""VoyageNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"--"If Request/Header/Transportation LegType=""Primary"" or ""First"" Request><Header><Transportation><ReferenceType type=""FlightNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
		,NULL																			[SOLAS_VRFDGRSSMASSCUTOFF_DT]-- only EM"<Request><Header><Status><StatusType type=""SolasVrfdGrMassCutDt""></StatusType>StatusTime></StatusTime></Status></Header></Request>"
		,NULL																			[SOLAS_VRFDGRSSMASSCUTOFF_DTM]--<Request><Header><Status><StatusType type="SolasVrfdGrMassCutDt"></StatusType></Status></Header></Request>
		,NULL																			[LC_ISSUING_NBR]--"If Request/Header/LetterofCredit/BankParties type = ""IssuingBank"" then <Request><Header><LetterofCredit><BankParties><BankPartyName></BankPartyName></BankParties></LetterofCredit></Header></Request>"
		,FORMAT([dbo].fDW_ORDR_CRTN_DT(HOU.NUm_PROC_HEA), 'dd/MM/yy')					[ORDR_CRTN_DT]--spINTDtPedido '" & ProcessoDT.Rows(0)("processo").ToString() & "'--"<Request><Header><Status><StatusType type=""OrderReceiveDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT(PO13.Data_PO_HEA, 'dd/MM/yy')											[CERT_OF_ORGN_APPLIED_DT]--<Request><Header><Status><StatusType type="CertOriginApplied"></StatusType></Status></Header></Request>
	FROM DBO.HOUSE_EXP_AER		HOU			WITH (NOLOCK) 
	JOIN LLP_EXP_AER			LLP			WITH (NOLOCK) ON LLP.NUM_PROC_LEA	=	HOU.NUM_PROC_HEA
	JOIN JOB_EXP_AER			JOB			WITH (NOLOCK) ON JOB.NUM_PROC_HEA	=	HOU.NUM_PROC_HEA
	LEFT JOIN PESSOA			Exporter	WITH (NOLOCK) ON Exporter.CD_PES	=	HOU.Cd_Export_HEA
	LEFT JOIN PESSOA			Consignee	WITH (NOLOCK) ON Consignee.CD_PES	=	HOU.Cd_Consig_HEA	
	LEFT JOIN PESSOA			Notify		WITH (NOLOCK) ON Notify.CD_PES		=	HOU.Cd_Notify_HEA	
	LEFT JOIN MASTER_EXP_AER	MAS			WITH (NOLOCK) ON MAS.NUM_PROC_MEA	=	HOU.NUM_PROC_MEA
	LEFT JOIN PESSOA_LLP		PLLP		WITH (NOLOCK) ON HOU.CD_EXPORT_HEA	=	PLLP.CD_PES
	LEFT JOIN GRUPO				GRP			WITH (NOLOCK) ON GRP.CD_PES_GRUPO	=   PLLP.CD_PES_GRUPO
	LEFT JOIN TAREFAS_PROCESSOS TP40		WITH (NOLOCK) ON TP40.NUM_PROC		=	HOU.NUM_PROC_HEA AND TP40.ID_TASK = 40
	LEFT JOIN TAREFAS_PROCESSOS TP217		WITH (NOLOCK) ON TP217.NUM_PROC		=	HOU.NUM_PROC_HEA AND TP217.ID_TASK = 217
	LEFT JOIN TAREFAS_PROCESSOS TP83		WITH (NOLOCK) ON TP83.NUM_PROC		=	HOU.NUM_PROC_HEA AND TP83.ID_TASK = 83
	LEFT JOIN TAREFAS_PROCESSOS TP66		WITH (NOLOCK) ON TP66.NUM_PROC		=	HOU.NUM_PROC_HEA AND TP66.ID_TASK = 66
	LEFT JOIN TAREFAS_PROCESSOS TP45		WITH (NOLOCK) ON TP45.NUM_PROC		=	HOU.NUM_PROC_HEA AND TP45.ID_TASK = 45
	LEFT JOIN TAREFAS_PROCESSOS TP4			WITH (NOLOCK) ON TP4.NUM_PROC		=	HOU.Num_Proc_HEA AND TP4.ID_TASK = 4
	LEFT JOIN TAREFAS_PROCESSOS TP10		WITH (NOLOCK) ON TP10.NUM_PROC		=	HOU.Num_Proc_HEA AND TP10.ID_TASK = 10
	LEFT JOIN TAREFAS_PROCESSOS TP13		WITH (NOLOCK) ON TP13.NUM_PROC		=	HOU.Num_Proc_HEA AND TP13.ID_TASK = 13
	LEFT JOIN TAREFAS_PROCESSOS TP1			WITH (NOLOCK) ON TP1.NUM_PROC		=	HOU.Num_Proc_HEA AND TP1.ID_TASK = 1
	LEFT JOIN TAREFAS_PROCESSOS TP5			WITH (NOLOCK) ON TP5.NUM_PROC		=	HOU.Num_Proc_HEA AND TP5.ID_TASK = 5
	LEFT JOIN TAREFAS_PROCESSOS TP58		WITH (NOLOCK) ON TP58.NUM_PROC		=	HOU.Num_Proc_HEA AND TP58.ID_TASK = 58
	LEFT JOIN TAREFAS_PROCESSOS TP21		WITH (NOLOCK) ON TP21.NUM_PROC		=	HOU.Num_Proc_HEA AND TP21.ID_TASK = 21
	LEFT JOIN TAREFAS_PROCESSOS TP12		WITH (NOLOCK) ON TP12.NUM_PROC		=	HOU.Num_Proc_HEA AND TP12.ID_TASK = 12
	LEFT JOIN TAREFAS_PROCESSOS TP161		WITH (NOLOCK) ON TP161.NUM_PROC		=	HOU.Num_Proc_HEA AND TP161.ID_TASK = 161
	LEFT JOIN TAREFAS_PROCESSOS TP59		WITH (NOLOCK) ON TP59.NUM_PROC		=	HOU.Num_Proc_HEA AND TP59.ID_TASK = 59
	LEFT JOIN TAREFAS_PROCESSOS TP41		WITH (NOLOCK) ON TP41.NUM_PROC		=	HOU.Num_Proc_HEA AND TP41.ID_TASK = 41

	LEFT JOIN NATURE_GOODS		NG			WITH (NOLOCK) ON NG.NUM_PROC		=	HOU.NUM_PROC_HEA
	LEFT JOIN Cia_Aerea			ARM			WITH (NOLOCK) ON ARM.Cd_Cia_Aer		=	LLP.Cd_CiaAerea_Lea
	LEFT JOIN PO_HEA			PO4			WITH (NOLOCK) ON PO4.Num_Proc_HEA	=	HOU.NUM_PROC_HEA AND PO4.ID_DC = 4
	LEFT JOIN PO_HEA			PO12		WITH (NOLOCK) ON PO12.Num_Proc_HEA	=	HOU.Num_Proc_HEA AND PO12.ID_DC = 12
	LEFT JOIN PO_HEA			PO204		WITH (NOLOCK) ON PO204.Num_Proc_HEA	=	HOU.Num_Proc_HEA AND PO204.ID_DC = 204
	LEFT JOIN PO_HEA			PO71		WITH (NOLOCK) ON PO71.Num_Proc_HEA	=	HOU.Num_Proc_HEA AND PO71.ID_DC = 71
	LEFT JOIN PO_HEA			PO8			WITH (NOLOCK) ON PO8.Num_Proc_HEA	=	HOU.Num_Proc_HEA AND PO8.ID_DC = 8
	LEFT JOIN PO_HEA			PO13		WITH (NOLOCK) ON PO13.Num_Proc_HEA	=	HOU.Num_Proc_HEA AND PO13.ID_DC = 13
	--LEFT JOIN PO_HEA			PO2			WITH (NOLOCK) ON PO2.Num_Proc_HEA	=	HOU.Num_Proc_HEA AND PO2.ID_DC = 2

	LEFT JOIN Localidade		DST			WITH (NOLOCK) ON DST.Cd_Local		=	HOU.Cd_Dst_HEA
	LEFT JOIN Localidade		ORG			WITH (NOLOCK) ON ORG.Cd_Local		=	HOU.Cd_Org_HEA
	LEFT JOIN Pais				DSTPais		WITH (NOLOCK) ON DSTPais.cd_pais	=	DST.cd_pais
	LEFT JOIN Pais				ORGPais		WITH (NOLOCK) ON ORGPais.cd_pais	=	ORG.cd_pais
	LEFT JOIN Localidade		DSTFNL		WITH (NOLOCK) ON DSTFNL.Cd_Local	=	LLP.Cd_DstFinal_Lea
	LEFT JOIN Localidade		ORGPLNT		WITH (NOLOCK) ON ORGPLNT.Cd_Local	=	LLP.Cd_Planta_Lea
	LEFT JOIN Usuario			US			WITH (NOLOCK) ON US.cd_usuario		=	JOB.Cd_Usuario
	LEFT JOIN Campo_Processo	CP32		WITH (NOLOCK) ON CP32.NUM_PROC		=	HOU.Num_Proc_HEA AND CP32.ID_Campo = 32	
	LEFT JOIN Usuario			Sales		WITH (NOLOCK) ON Sales.cd_usuario	=	JOB.cd_Vendedor
	LEFT JOIN Tipo_Status_Processo TSP		WITH (NOLOCK) ON LLP.id_status		=	TSP.id_status
	LEFT JOIN Terminal			TER			WITH (NOLOCK) ON TER.cd_terminal	=	LLP.cd_terminal
	Where
		HOU.Num_Proc_HEA = 'EACTV202408007BR' 
		--AND
		--convert(datetime,HOU.Dt_emis_hea,105) > getdate() -31

UNION ALL

	SELECT 
		HOU.Num_Proc_HIA																[FRWDR_REF_NBR]
		,FORMAT(TP59.Dt_Conclusao , 'dd/MM/yy')											[ADVANCEMENT_REQ_DT]--I think it is 59 - -Solicitação de Numerário - <StatusType type="AdvancementReqDt"/>
		,NULL																			[AFRMM_PAYMENT_DT]
		,NULL																			[ARR_DT]
		,isnull(GRP.Smart_Imp,HOU.Cd_Consig_HiA)										[BDP_CLIENT_CD] -- spIntPessoa_Sel I = Smart_Imp,E = Smart_Exp <Request><Header><References type="ClientCode"><ReferenceNumber></ReferenceNumber>
		,FORMAT( TP40.Dt_Conclusao , 'dd/MM/yy')										[BDP_INVC_ACT_DT]	--Smart_Conclusao - spSmartBilledDate_Sel -   <Request><Header><Status><StatusType type="BilledDate"></StatusType>
		,FORMAT( TP40.Dt_Conclusao , 'dd/MM/yy')										[BDP_INVC_ACT_DTM]
		,[dbo].[fDW_BDP_INVC_REF_NBR](HOU.Num_Proc_HIA)									[BDP_INVC_REF_NBR]
		,NULL																			[BDP_REP_PRTY_ID]
		,LEFT(HOU.Num_Proc_HIA,1)														[BDP_SERVICE_CD]--<Request><Header Type="Export"></Header ></Request> then E
		,'01BDPBRSAO' 																	[BDP_SS_ID]
		,(CASE WHEN HOU.Num_Proc_MIA <> 'JOB' THEN 'Y' ELSE
			(CASE WHEN ARM.SCAC = 'BOPT' THEN 'Y' ELSE
				(CASE WHEN ARM.SCAC = 'SBHG' THEN 'S' ELSE
					'N'
				END)
			END)
		END)																			[BDP_TRANS_IND]
		,(CASE WHEN HOU.Tp_Frete_HIA = 'P' THEN HOU.vlr_frete_efet_hia ELSE '0.00' END)	[BF_BOL_AWB_PRPD_AMT]--<Request><Header><Amounts><AmountType>BaseFreightBolAwbAmountPrepaid</AmountType></Amounts></Header></Request>
		,NULL																			[BKNG_CNFRM_DT]
		,FORMAT(isnull(DATEADD(day,-1, LLP.ATD_LIA),TP41.Dt_Conclusao) , 'dd/MM/yy')	[BOL_POST_AUDT_BCK_DT]	--Smart_Conclusao - <Request><Header><Status><StatusType type="BOLBackDate"></StatusType>		
		,FORMAT(isnull(DATEADD(day,-1, LLP.ATD_LIA),TP41.Dt_Conclusao) , 'dd/MM/yy')	[BOL_POST_AUDT_BCK_DTM]	
		,NULL																			[BOL_PRE_AUDT_RCV_DT]	-- Code - 66	Envio do draft do BL--<Request><Header><Status><StatusType type="BillofLadingRetreivedDate"></StatusType>
		,NULL																			[BOL_PRE_AUDT_RCV_DTM]
		,FORMAT(TP5.Dt_Conclusao , 'dd/MM/yy')											[BKNG_CNFRMTN_RCVD_FROM_SS_DT]
		,FORMAT(TP58.Dt_Conclusao , 'dd/MM/yy')											[BKNG_DT]
		,FORMAT(TP58.Dt_Conclusao , 'dd/MM/yy')											[BKNG_DTM]
		,NULL																			[BKNG_NBR]--HouseBookingNumber
		,NULL																			[BOL_ACTN_DT]
		,FORMAT(LLP.ATD_LIA, 'dd/MM/yy')												[BOL_AWB_ISS_DT]
		,HOU.HAWB_HIA																	[BOL_AWB_NBR] --HouseBillofLadingNumber-- HouseAirwayBill- verificar
		,FORMAT(LLP.ATD_LIA, 'dd/MM/yy')												[BOL_SBMT_DT]
		,FORMAT(LLP.ATD_LIA, 'dd/MM/yy')												[BOL_SBMT_DTM]
		,NULL																			[BYR_PRTY_ID]
		,'LCL'																			[CARGO_TYP]
		,NULL																			[CARRIER_DOC_CUTOFF_DT]--Only EM
		,NULL																			[CARRIER_DOC_CUTOFF_DTM]--Only EM
		,HOU.Num_Proc_HIA																[CHB_REF_NBR]--<Request><Header><References type="ClearingAgentReferenceNumber"><ReferenceNumber></ReferenceNumber>
		,LLP.Peso_Cubado_LIA															[CHRG_WGHT_QTY] --EA e IA	"<Request><Header><Amounts><AmountType>ChargeableWeight</AmountType><AmountValue></AmountValue></Amounts></Header></Request>"
		,LEFT([dbo].[RemoveNonAlphaCharacters](NG.Descr),100)							[CARGO_DESC]--CargoDescription <Request><Header><CodesNames><CodesNamesType></CodesNamesType></CodesNames></Header></Request>
		,(CASE WHEN HOU.Num_Proc_MIA <> 'JOB' THEN 'BDP TRANSPORT, INC' ELSE
		NULL	END)																	[CARR_NM]--If Request/Header/Transportation MethodofTransportation  is  Air and   <Request><Header><Transportation><Carrier><CarrierName></CarrierName></Carrier></Transportation></Header></Request>
		,FORMAT( TP21.Dt_Conclusao, 'dd/MM/yy')											[CARR_PYMNT_DT]--NOt Mapped in The File
		,(CASE WHEN HOU.Num_Proc_MIA <> 'JOB' THEN 'BOPT' ELSE NULL END)				[CARR_SCAC_CD]
		,NULL	[CHB_PRTY_ID]
		,NULL	[CHRG_RATE_AMT]
		,isnull(GRP.Smart_Imp,HOU.Cd_Consig_HiA)+isnull(GRP.Smart_Imp,HOU.Cd_Consig_HiA)[CLNT_CD] --<Request><Header><References type=""BDPClientCode""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,(CASE WHEN hou.Num_Proc_MIA <> 'JOB'  AND substring(hou.Num_Proc_MIA,3,3) <> 'CLI' THEN 'C' ELSE 'D' END)  [CNSOL_DRCT_CD]--"<Request><Header><References type=""ConsolIndicator""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,(CASE WHEN hou.Num_Proc_MIA <> 'JOB'  THEN hou.Num_Proc_MIA ELSE NULL END)     [CNSOL_NBR] --<Request><Header><References type=""ConsolNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																			[CNTNR_EQUIP_CT]
		,NULL																			[CNTNR_TYP_CD_1]
		,NULL																			[CNTNR_TYP_CD_2]
		,NULL																			[CNTNR_TYP_CD_3]
		,isnull(GRP.Smart_Imp,HOU.Cd_Consig_HIA)										[CONSG_PRTY_CD]
		,NULL																			[CONSG_PRTY_ID]
		,PO5.Numero_PO_HIA																[CSTMS_ENTRY_PRMT_NBR]
		,FORMAT(TP4.Dt_Conclusao,'dd/MM/yy')											[CSTMS_ENTRY_PRMT_REL_DT]--Smart_Conclusao <Request><Header><Status><StatusType type=""CustomsEntryPermitReleaseDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT(TP4.Dt_Conclusao,'dd/MM/yy')											[CSTMS_ENTRY_PRMT_REL_DTM]
		,FORMAT(PO5.Data_PO_HiA,'dd/MM/yy')												[CSTMS_ENTRY_PRMT_SBMT_DT]--Code - "<Request><Header><Status><StatusType type=""CustomsEntryPermitSubmissionDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[CSTMS_ENTRY_PRT_NM]--ONLY IM ,EO,IO
		,NULL																			[CSTMS_ENTRY_PRT_UNLOC_CD]--ONLY IM ,EO,IO		
		,LEFT(UPPER(LLP.Canal_Lia),2)													[CSTMS_ENTRY_TYP_CD]--"<Request><Header><References type=""CustomsEntrytypeCode""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,FORMAT(TP15.Dt_Conclusao,'dd/MM/yy')											[CSTMS_PRT_ACT_DT]
		,FORMAT(TP15.Dt_Previsao,'dd/MM/yy')											[CSTMS_PRT_EST_DT]
		,FORMAT(TP4.Dt_Conclusao,'dd/MM/yy')											[CSTMS_RLS_DT] --If Request/Header Type="Import"<Request><Header><Status><StatusType type="CustomsReleaseDate"></StatusType>           <StatusDate></StatusDate></Status></Header></Request>
		,FORMAT(TP4.Dt_Conclusao,'dd/MM/yy')											[CSTMS_RLS_DTM]
		,[dbo].[fDW_CUSTOMER_CSR_NM](HOU.Num_Proc_HIA)									[CUSTOMER_CSR_NM]--spCSRJob_SEL - <Request><Header><Parties><Party-Contacts type="CSR"><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
		,UPPER(DST.Cd_Pais)																[DEST_CNTRY_CD]--If Request/Header/Transportation LegType="Primary" or "First"<Request><Header><Transportation><DestinationCountryCode></DestinationCountryCode></Transportation></Header></Request>
		,UPPER(DSTPais.Nome_Pais)														[DEST_CNTRY_NM]
		,UPPER(DST.Cd_Pais)																[DEST_CNTRY_UNLOC_CD]
		,FORMAT(TP13.Dt_Conclusao,'dd/MM/yy')											[DEST_DEL_ACT_DT]---- Only Import ID_Task 13 Dt_Conclusao --<Request><Header><Status><StatusType type="ActDestinationDeliveryDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,FORMAT(TP13.Dt_Conclusao,'dd/MM/yy')											[DEST_DEL_ACT_DTM]
		,(Case when TP13.Dt_Conclusao is not null then 
			FORMAT(TP13.Dt_Previsao,'dd/MM/yy') else NULL end)							[DEST_DEL_EST_DT]---- Only Import ID_Task 13 Dt_Previsao--<Request><Header><Status><StatusType type="EstDestinationDeliveryDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,(Case when TP13.Dt_Conclusao is not null then		
			FORMAT(TP13.Dt_Previsao,'dd/MM/yy') else NULL end)							[DEST_DEL_EST_DTM]
		,Transp.nome_raz_soc															[DEST_INL_CARR_NM]
		,Left(TRANSPPLLP.cd_Vendor,4)													[DEST_INL_CARR_SCAC_CD]
		,FORMAT(TP7.Dt_Conclusao,'dd/MM/yy')											[DLVRY_ORDR_CREATN_DT_ACT_DT]--Only Import ID_Task 7 Dt_Conclusao <Request><Header><Status><StatusType type="ActDeliveryOrderCreationDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,FORMAT(TP7.Dt_Conclusao,'dd/MM/yy')											[DLVRY_ORDR_DISTRIB_DT_ACT_DT]--Only Import ID_Task 7 Dt_Conclusao <Request><Header><Status><StatusType type="ActDeliveryOrderDistributionDate"></StatusType><StatusTime></StatusTime></Status></Header></Request>
		,FORMAT(TP63.Dt_Conclusao,'dd/MM/yy')											[DOC_DIST_RCV_ACT_DT]
		,FORMAT(TP63.Dt_Conclusao,'dd/MM/yy')											[DOC_DIST_RCV_ACT_DTM]
		,NULL																			[DOC_DIST_SEND_ACT_DT]
		,NULL																			[DOC_DIST_SEND_ACT_DTM]
		,NULL																			[DOC_DIST_SEND_EST_DT]
		,NULL																			[DOC_DIST_SEND_EST_DTM]
		,NULL																			[DOC_DIST_BY_NM]
		,FORMAT(TP109.Dt_Conclusao,'dd/MM/yy')											[DOCK_RCPT_CRTN_DT]--Only Import ID_Task 109 Dt_Conclusao--<Request><Header><Status><StatusType type="DockReceiptCreationDate"></StatusType></Status></Header></Request>
		,NULL																			[DRAFT_BOL_INSTR_RECVD_DT]--Only EM  ID_Task 66 Dt_Conclusao--<Request><Header><Status><StatusType type="DraftBOLInstrRecvdDt"></StatusType></Status></Header></Request>
		,FORMAT(TP4.Dt_Conclusao,'dd/MM/yy')											[ENTRY_IMM_DEL_RCV_DT]
		,FORMAT(TP4.Dt_Conclusao,'dd/MM/yy')											[ENTRY_IMM_DEL_RCV_DTM]
		,FORMAT(PO5.Data_PO_HIA,'dd/MM/yy')												[ENTRY_SUMM_SBMT_DT]--Not Sent"<Request><Header><Status><StatusType type=""EntrySummaryRejectDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT(PO5.Data_PO_HIA,'dd/MM/yy')												[ENTRY_SUMM_SBMT_DTM]
		,FORMAT(LLP.ATD_LIA, 'dd/MM/yy')												[EXIT_CITY_ACT_DT]
		,NULL																			[EXP_CNTRY_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First""  <Request><Header><Transportation><OriginCountryCode></OriginCountryCode></Transportation></Header></Request>"
		,UPPER(ORG.Cd_Pais)																[EXP_CNTRY_UNLOC_CD]
		,NULL																			[EXPRT_JOB_NBR]
		,NULL																			[EXPTR_SHPR_PRTY_CD]
		,NULL																			[EXPTR_SHPR_PRTY_ID]
		,NULL																			[FEU_QTY]
		,FORMAT(TP40.Dt_Conclusao,'dd/MM/yy')											[FILE_CLS_DT]--"<Request><Header><Status><StatusType type=""FileClosedDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"	--"<Request><Header><Status><StatusType type=""ClosedDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT(TP40.Dt_Conclusao,'dd/MM/yy')											[FILE_CLS_DTM]
		,NULL																			[FILE_CREATED_BY_NM]		
		,CONVERT(VARCHAR(8),CONVERT(DATE,HOU.Dt_Emis_HIA, 103), 3)						[FILE_CRTN_DT]
		,CONVERT(VARCHAR(8),CONVERT(DATE,HOU.Dt_Emis_HIA, 103), 3)						[FILE_CRTN_DTM]
		,NULL																			[FINAL_GOODS_ISS_DT]
		,NULL																			[FINAL_GOODS_ISS_DTM]
		,NULL																			[FRWDR_PRTY_ID]		
		,NULL																			[GE_DIVISION_CD]
		,NULL																			[GE_GROUP_CD]
		,NULL																			[GE_SBU_CD]
		,Consignee.GLOBAL_ENTITY_ID														[GEID]--"<Request><Header><Parties type=""Exporter""><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>"--"<Request><Header><Parties type=""Importer""><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>"
		,NULL																			[GLBL_AGNT_PRTY_ID]
		,UPPER(replace(replace(replace(ltrim(rtrim(HOU.Obs_HIA)),char(10),' '),char(13),' '),char(160),' ')) [GNRL_DESC]--"<Request><Header><References type=""GeneralDescription""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																			[GOODS_AVLBL_SHP_ACT_DT]--ONly for EA,EM,EO,IOActualPlantShipDate --"If the file is not  Meridian If <Request><Header><Status><StatusType type=""ActGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		<Request><Header><Status><StatusType type=""ActualPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,NULL																			[GOODS_AVLBL_SHP_ACT_DTM]
		,NULL																			[GOODS_AVLBL_SHP_EST_DT] --ONly for EA,EM,EO,IO	--"<Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"	--"If the file is not for Meridian 		--If <Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		--<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"		--"If the file is not for Meridian		--If <Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		--<Request><Header><Status><StatusType type=""EstimatedShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,NULL																			[GOODS_AVLBL_SHP_EST_DTM]
		,NULL																			[GOV_EXP_PRMSS_RLS_DT]--ONly for EA,EM,EO - "If Request/Header Type=""Export""<Request><Header><Status><StatusType type=""CustomsReleaseDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[GOV_EXP_PRMSS_RLS_DTM]
		,NULL																			[GOV_EXP_PRMSS_RLS_NBR]--ONly for EA,EM,EO"<Request><Header><References type=""GovernmentPermissionToExportReleaseNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																			[GOV_EXP_PRMSS_SBMT_DT]--Not Send -"If Request/Header Type=""Export""   <Request><Header><Status><StatusType type=""CustomsSubmitDate""></StatusType>           <StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[GOV_EXP_PRMSS_SBMT_DTM]
		,NULL																			[GOV_EXP_PRMSS_SBMT_NBR]
		,FORMAT(PO5.Data_PO_HIA,'dd/MM/yy')												[GOV_PYMNT_STMNT_SBMT_DT]--IMP ID_DC 5, EXP-ID-DC 4<Request><Header><Status><StatusType type="GovernmentPaymentStatementSubmissionDate"></StatusType></Status></Header></Request>
		,FORMAT(PO5.Data_PO_HIA,'dd/MM/yy')												[GOV_PYMNT_STMNT_SBMT_DTM]

		,HOU.Peso_Bruto_HIA																[GROSS_TRANS_KILO_QTY]--"<Request><Header><Detail><ProductDetail><Measurements type=""GrsWtKgs""><MeasurementValue></MeasurementValue></Measurements></ProductDetail></Detail></Header></Request>"
		,HOU.Peso_Bruto_HIA * 2.2046													[GROSS_TRANS_POUND_QTY]
		,FORMAT(TP27.Dt_Conclusao , 'dd/MM/yy')										[IMPORT_DCLRTN_DRFT_DT]
		,(CASE WHEN CP5.Campo_DADOS is null then NULL ELSE
		(CASE WHEN CP5.Campo_DADOS = '2' THEN 'N' ELSE 'Y' END)	END)					[IMPORT_LIC_NEEDED_IND]--spSmartNecessidadeLI_Sel
		,NULL																			[IMPTR_PRTY_CD]
		,NULL																			[IMPTR_PRTY_ID]
		,NULL																			[INSPECTN_DT_ACT_DT]
		,HOU.tp_frete_hia																[INTL_FRGHT_TERM_CD]--<Request><Header><Transportation><PrepaidorCollect></PrepaidorCollect></Transportation></Header></Request>
		,NULL																			[ITS_PLACE_OF_DLVRY_NM]	--"If Request/Header/Transportation MethodofTransportation  is not Air and  If <Request><Header><Transportation><Destination LocationType=""PlaceofDelivery""><DestinationName></DestinationName> </Destination></Transportation></Header></Request>"
		,NULL																			[ITS_PLACE_OF_RCPT_NM]
		,NULL																			[ITS_PORT_OF_DSCHRG_NM]
		,NULL																			[ITS_PORT_OF_ENTRY_NM]
		,NULL																			[ITS_PORT_OF_LOAD_NM]
		,NULL																			[ITS_PORT_OF_ORGN_NM]
		,FORMAT( [dbo].[fDW_LAST_MDFD_BY_DT](HOU.Num_Proc_HIA), 'dd/MM/yy')				[LAST_MDFD_BY_DT]--"<Request><Header><Status><StatusType type=""LastModifiedByDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,(CASE WHEN PO71.Numero_PO_HIA is not null THEN 'Y' ELSE 'N' END)				[LETTR_OF_CRDT_IND]--<Request><Header><LetterofCredit><RequiredYN></RequiredYN></LetterofCredit></Header></Request>
		,FORMAT( PO5.Data_PO_HIA, 'dd/MM/yy')											[LQDTN_DT]--Only Import Data da DI and id_dc=5 --<Request><Header><Status><StatusType type="LiquidationDate"></StatusType></Status></Header></Request>
		,NULL																			[LTST_DEL_CUTOFF_DT] -- Ony FOR EM --<Request><Header><Status><StatusType type=""LatestDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[LTST_DEL_CUTOFF_DTM]-- Ony FOR EM--<Request><Header><Status><StatusType type=""LatestDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[MANIFEST_DT]
		,NULL																			[MANUF_PLNT_PRTY_ID]
		,NULL																			[MBOL_ACTN_DT]--Not Send--<Request><Header><FileStatus><Code>"MbolActionDate"</Code></FileStatus></Header></Request>
		,HOU.MAWB_HIA																	[MBOL_MAWB_NBR]--If Request/Header/Transportation MethodofTransportation  is  Air and <Request><Header><Transportation><ReferenceType type=""MasterAirWayBill""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>--If Request/Header/Transportation MethodofTransportation  is  Air and <Request><Header><Transportation><ReferenceType type=""MasterBillofLadingNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,NULL																			[MBOL_RCV_DT]
		,NULL																			[MBOL_RCV_DTM]
		,'A'																			[MOT_CD]--" Request><Header><Transportation MethodofTransportation= ""V""></Transportation></Header></Request>
		,(CASE WHEN HOU.cd_tp_oper='DDP' or HOU.cd_tp_oper='DDU' THEN 
			'DD' ELSE 'AA' END)															[MOVE_TYP_CD]
		,(CASE WHEN HOU.cd_tp_oper='DDP' or HOU.cd_tp_oper='DDU' THEN 
			'DOOR TO DOOR' ELSE 'AIRPORT TO AIRPORT H/H (DUP)' END)						[MOVE_TYP_DESC]--Request><Header><Transportation><TypeofMoveCode Type="DP"></TypeofMoveCode></Transportation></Header></Request>---<Request><Header><Transportation><TypeofMoveDescription></TypeofMoveDescription></Transportation></Header></Request>			   	
		,NULL																			[MSTR_BKNG_NBR]-- If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""BookingNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"	
		,UPPER(ARM.Nome_Cia_Aer)														[MSTR_CARR_NM]--If Request/Header/Transportation MethodofTransportation  is  Air and   <Request><Header><Transportation><Carrier><CarrierName></CarrierName></Carrier></Transportation></Header></Request>
		,ARM.SCAC																		[MSTR_CARR_SCAC_CD]			
		,HOU.Peso_Real_HIA																[NET_TRANS_KILO_QTY]--<Request><Footer><Measurements item="NetWtKgs"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>-<Request><Footer><Measurements item="NetWeightKilograms"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,HOU.Peso_Real_HIA * 2.2046														[NET_TRANS_POUND_QTY]--<Request><Footer><Measurements item="NetWeightPounds"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,NULL																			[NF_COMPLIMENTARY_DT]
		,FORMAT( TP67.Dt_Conclusao , 'dd/MM/yy')										[NF_DRFT_DT]
		,NULL																			[NTFY_PRTY_ID]
		,NULL																			[ONBRD_CONFRM_DT]--If Request/Header/Transportation LegType=""Primary"" or ""First"" 	and If Request/Header/Transportation MethodofTransportation  is ""Ocean"" or ""V"" or ""Barge"" or ""B"" or ""C"" Request><Header><Transportation><OriginDate Type=""Actual""></OriginDate></Transportation></Header></Request>"
		,NULL																			[ONBRD_CONFRM_DTM]
		,NULL																			[OPEN_GATE_DT]
		,(CASE WHEN CP32.Campo_DADOS = '2' THEN 'FFD' ELSE 'CHB' END)					[OPRTG_UNT_CL_CD]--<Request><Header><References type=""OperatingUnitClassification""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,left([dbo].[fDW_ORDR_TYP_CD](HOU.Num_Proc_HIA),1)								[ORDR_TYP_CD]--<Request><Header><References type="OrderType"><ReferenceNumber></ReferenceNumber></References></Header></Request>		--<Request><Header><Transportation><ReferenceType type="OrderType"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,FORMAT(LLP.ATD_Lia, 'dd/MM/yy')												[ORGN_CITY_ACT_DT]--<Request><Header><Amounts><AmountType>ActCityOfOriginDate</AmountType></Amounts></Header></Request>
		,UPPER(ORG.cd_pais)																[ORGN_CNTRY_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First"" <Request><Header><Transportation><OriginCountryCode></OriginCountryCode></Transportation></Header></Request>"
		,UPPER(ORGPais.Nome_Pais)														[ORGN_CNTRY_NM]
		,UPPER(ORG.Cd_Pais)																[ORGN_CNTRY_UNLOC_CD]
		,FORMAT(TP5.Dt_Conclusao,'dd/MM/yy')											[ORGN_INL_BOOK_ACT_DT]
		,FORMAT(TP10.Dt_Conclusao,'dd/MM/yy')											[ORGN_INL_DEL_ACT_DT]--<Request><Header><Status><StatusType type="ActDomesticInlandDeliveryDate"></StatusType></Status></Header></Request>
		,FORMAT(TP10.Dt_Conclusao,'dd/MM/yy')											[ORGN_INL_DEL_ACT_DTM]
		,FORMAT(TP10.Dt_Previsao,'dd/MM/yy')											[ORGN_INL_DEL_EST_DT]--<Request><Header><Status><StatusType type="EstDomesticInlandDeliveryDate"></StatusType></Status></Header></Request>
		,FORMAT(TP10.Dt_Previsao,'dd/MM/yy')											[ORGN_INL_DEL_EST_DTM]
		,NULL																			[ORGN_INL_LOCTN_NM]
		,NULL																			[ORGN_INL_LOCTN_UNLOC_CD]
		,NULL																			[ORGN_INL_PCKP_ACT_DT]--<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType>StatusTime></StatusTime></Status></Header></Request>"
		,NULL																			[ORGN_INL_PCKP_ACT_DTM]
		,NULL																			[ORGN_INL_PCKP_EST_DT]--<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,NULL																			[ORGN_INL_PCKP_EST_DTM]
		,UPPER(ORG.Nome_Local)															[ORGN_PORT_NM]--if Request/Header/Transportation MethodofTransportation  is not Air and <Request><Header><Transportation><ReferenceType type=""OriginPort""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
		,UPPER(HOU.Cd_Org_HIA)															[ORGN_PORT_UNLOC_CD]--If Request/Header/Transportation LegType=""Primary"" or ""First"" then If Request/Header/Transportation/OriginCodeType/type = ""IATA"" or ""IATACode"" then		--<Request><Header><Transportation><OriginCodeType><OriginCode></OriginCode></OriginCodeType></Transportation></Header></Request>"
		,FORMAT(TP13.Dt_Conclusao , 'dd/MM/yy')											[PLACE_OF_DEL_ACT_DT]----<Request><Header><Status><StatusType type=""ActPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"--<Request><Header><Status><StatusType type=""ActualPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[PLACE_OF_DEL_ACT_DTM]	
		,FORMAT(TP13.Dt_Previsao , 'dd/MM/yy')											[PLACE_OF_DEL_EST_DT]--"<Request><Header><Status><StatusType type=""EstimatedPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"--<Request><Header><Status><StatusType type=""EstPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT(TP13.Dt_Previsao , 'dd/MM/yy')											[PLACE_OF_DEL_EST_DTM]
		,UPPER(DSTFNL.Nome_Local)														[PLACE_OF_DEL_NM]----"Request><Header><References type=""PlaceofDelivery Name""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="PlaceofDelivery Name"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,UPPER((CASE WHEN DSTFNL.IATACODE is null THEN DSTFNL.Cd_Pais+DSTFNL.Cd_Local
			ELSE DSTFNL.Cd_Pais + DSTFNL.IATACODE END))									[PLACE_OF_DEL_UNLOC_CD]
		,NULL																			[PLACE_OF_RCPT_ACT_DT]--"<Request><Header><Status><StatusType type=""ActPlaceofReceiptDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NUll																			[PLACE_OF_RCPT_EST_DT]--"<Request><Header><Status><StatusType type=""EstPlaceofReceiptDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																			[PLACE_OF_RCPT_EST_DTM]		
		,UPPER(ORGPLNT.Nome_Local)														[PLACE_OF_RCPT_NM]--"<Request><Header><References type=""PlaceofReceipt Name""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="PlaceofReceipt Name"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,UPPER((CASE WHEN ORGPLNT.IATACODE is null THEN ORGPLNT.Cd_Pais+ORGPLNT.Cd_Local
			ELSE ORGPLNT.Cd_Pais + ORGPLNT.IATACODE END))								[PLACE_OF_RCPT_UNLOC_CD]
		,FORMAT(LLP.ATA_LIA , 'dd/MM/yy')												[PORT_OF_ARRVL_ACT_DT]
		,FORMAT(LLP.ETA_LIA , 'dd/MM/yy')												[PORT_OF_ARRVL_EST_DT]
		,UPPER(DST.Nome_Local)															[PORT_OF_ARRVL_NM]
		,UPPER(DST.SCAC)																[PORT_OF_ARRVL_UNLOC_CD]
		,FORMAT(LLP.ATD_LIA	, 'dd/MM/yy')												[PORT_OF_DEPTR_ACT_DT]
		,FORMAT(LLP.ETD_LIA	, 'dd/MM/yy')												[PORT_OF_DEPTR_EST_DT]
		,UPPER(ORG.Nome_Local)															[PORT_OF_DEPTR_NM]
		,UPPER((CASE WHEN isnull(ORG.IATACODE,'') = '' THEN ORG.Cd_Local
			ELSE ORG.IATACODE END))														[PORT_OF_DEPTR_UNLOC_CD]
		,FORMAT(TP15.Dt_Conclusao, 'dd/MM/yy')											[PORT_OF_ENTRY_ACT_DT]
		,FORMAT(LLP.ETA_LIA, 'dd/MM/yy')												[PORT_OF_ENTRY_EST_DT]
		,UPPER(DST.Nome_Local)															[PORT_OF_ENTRY_NM]
		,upper(DST.IATACODE)															[PORT_OF_ENTRY_UNLOC_CD]			
		,FORMAT(LLP.ATD_LIA, 'dd/MM/yy')												[PORT_OF_EXIT_ACT_DT]--<Request><Header><Status><StatusType type="ActPortOfExitDate"></StatusType></Status></Header></Request>
		,NULL																			[PORT_OF_EXIT_EST_DT]--"<Request><Header><Status><StatusType type=""EstPortOfExitDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,UPPER((CASE WHEN isnull(ORG.IATACODE,'') = '' THEN ORG.Cd_Local
			ELSE ORG.IATACODE END))														[PORT_OF_EXIT_UNLOC_CD]
		,FORMAT( TP1.Dt_Conclusao, 'dd/MM/yy')											[PRESHPMNT_ADVC_DT]--"<Request><Header><Status><StatusType type=""PreShipmentAdviceDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"			
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIA) > 0 
			THEN 
				(Case when [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIA) < isnull(HOU.vlr_frete_efet_hia,0) 
					THEN 
						[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIA)
					ELSE
						[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIA) - isnull(HOU.vlr_frete_efet_hia,0)
				END)
			ELSE 
				LLP.Vlr_Invoice - isnull(HOU.vlr_frete_efet_hia,0) END)					[REPRT_VAL_AMT]--<Request><Footer><Measurements item="ReportableValueAmount"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>--<Request><Footer><Measurements item="TotalFAS"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		
		,FORMAT( LLP.ETA_Lia, 'dd/MM/yy')												[RQST_ETA_DEST_DT]--"<Request><Header><Status><StatusType type=""RequestedETADestDate""></StatusType>           <StatusTime></StatusTime></Status></Header></Request>"
		,Sales.Nome_Usuario																[SALES_PERSON_NM]--spINTSmartVendedor_Sel <Request><Header><CodesNames><CodesNamesName></CodesNamesName></CodesNames></Header></Request>
		,isnull(PO8.Numero_PO_HIA,HOU.HAWB_HIA)											[SAP_SHPMNT_NBR]--"<Request><Header><References type=""SAPShipmentNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--<Request><Header><Transportation><ReferenceType type="SAPShipmentNumber"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,NULL																			[SBU]--Request><Header><Transportation><ReferenceType type="SBU"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>--"<Request><Header><References type=""SBU""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																			[SBU_DESC]--"<Request><Header><References type=""SBUDescription""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="SBUDescription"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,FORMAT([dbo].[fDW_SDA_PAYMENT_DT]('SDA'), 'dd/MM/yy')							[SDA_PAYMENT_DT]--[spINTSmartPagamentos_Sel]'EMATL202407001BR','SDA'
		,UPPER(cast(LLP.ID_Status as varchar(2)) + '-' + TSP.Status_Descricao_Ingles)	[SHIPMENT_STATUS]
		,NULL																			[SHP_TO_PRTY_ID]
		,NULL																			[SLD_TO_PRTY_ID]
		,NULL																			[SLLR_PRTY_ID]
		,[dbo].[fBusca_TEUS](HOU.NUm_PROC_HIA)											[TEU_QTY]--<Request><Header><Amounts><AmountType>NumberOfTEUs</AmountType></Amounts></Header></Request>
		,HOU.Vol_Tot_HIA																[TOT_CUBIC_FT_QTY]--<Request><Footer><Measurements><MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,UPPER(TER.Nome_Terminal)														[TRMNL_PIER_NM]
		,isnull(HOU.vlr_frete_efet_hia,0)												[TTL_FRGHT_BOL_AWB_PRPD_AMT]--<Request><Header><Transportation><ReferenceType type="FreightAmount"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,HOU.Voo_hia																	[VOYG_FLGHT_NBR]--"If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""VoyageNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"--"If Request/Header/Transportation LegType=""Primary"" or ""First"" Request><Header><Transportation><ReferenceType type=""FlightNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
		,NULL																			[SOLAS_VRFDGRSSMASSCUTOFF_DT]-- only EM"<Request><Header><Status><StatusType type=""SolasVrfdGrMassCutDt""></StatusType>StatusTime></StatusTime></Status></Header></Request>"
		,NULL																			[SOLAS_VRFDGRSSMASSCUTOFF_DTM]--<Request><Header><Status><StatusType type="SolasVrfdGrMassCutDt"></StatusType></Status></Header></Request>
		,NULL																			[LC_ISSUING_NBR]--"If Request/Header/LetterofCredit/BankParties type = ""IssuingBank"" then <Request><Header><LetterofCredit><BankParties><BankPartyName></BankPartyName></BankParties></LetterofCredit></Header></Request>"
		,FORMAT([dbo].fDW_ORDR_CRTN_DT(HOU.NUm_PROC_HIA), 'dd/MM/yy')					[ORDR_CRTN_DT]--spINTDtPedido '" & ProcessoDT.Rows(0)("processo").ToString() & "'--"<Request><Header><Status><StatusType type=""OrderReceiveDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( PO13.Data_PO_HIA, 'dd/MM/yy')											[CERT_OF_ORGN_APPLIED_DT]--<Request><Header><Status><StatusType type="CertOriginApplied"></StatusType></Status></Header></Request>
	FROM DBO.HOUSE_IMP_AER		HOU			WITH (NOLOCK) 
	JOIN LLP_IMP_AER			LLP			WITH (NOLOCK) ON LLP.NUM_PROC_LIA	= HOU.NUM_PROC_HIA
	JOIN JOB_IMP_AER			JOB			WITH (NOLOCK) ON JOB.NUM_PROC_HIA	= HOU.NUM_PROC_HIA
	LEFT JOIN PESSOA			Exporter	WITH (NOLOCK) ON Exporter.CD_PES	=	HOU.Cd_Export_HIA
	LEFT JOIN PESSOA			Consignee	WITH (NOLOCK) ON Consignee.CD_PES	=	HOU.Cd_Consig_HIA	
	LEFT JOIN PESSOA			Notify		WITH (NOLOCK) ON Notify.CD_PES		=	HOU.Cd_Import_HIA
	LEFT JOIN PESSOA			TRANSP		WITH (NOLOCK) ON TRANSP.CD_PES		=	LLP.Cd_Transportadora
	LEFT JOIN PESSOA_LLP		TRANSPPLLP	WITH (NOLOCK) ON TRANSPPLLP.CD_PES	=	LLP.Cd_Transportadora
	LEFT JOIN MASTER_IMP_AER	MAS			WITH (NOLOCK) ON MAS.NUM_PROC_MIA	= HOU.NUM_PROC_MIA
	LEFT JOIN PESSOA_LLP		PLLP		WITH (NOLOCK) ON HOU.Cd_Consig_HIA	=  PLLP.CD_PES
	LEFT JOIN GRUPO				GRP			WITH (NOLOCK) ON GRP.CD_PES_GRUPO	=   PLLP.CD_PES_GRUPO
	LEFT JOIN TAREFAS_PROCESSOS TP40		WITH (NOLOCK) ON TP40.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP40.ID_TASK = 40
	LEFT JOIN TAREFAS_PROCESSOS TP217		WITH (NOLOCK) ON TP217.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP217.ID_TASK = 217
	LEFT JOIN TAREFAS_PROCESSOS TP83		WITH (NOLOCK) ON TP83.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP83.ID_TASK = 83
	LEFT JOIN TAREFAS_PROCESSOS TP66		WITH (NOLOCK) ON TP66.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP66.ID_TASK = 66
	LEFT JOIN TAREFAS_PROCESSOS TP45		WITH (NOLOCK) ON TP45.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP45.ID_TASK = 45
	LEFT JOIN TAREFAS_PROCESSOS TP4			WITH (NOLOCK) ON TP4.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP4.ID_TASK = 4
	LEFT JOIN TAREFAS_PROCESSOS TP13		WITH (NOLOCK) ON TP13.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP13.ID_TASK = 13
	LEFT JOIN TAREFAS_PROCESSOS TP7			WITH (NOLOCK) ON TP7.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP7.ID_TASK = 7
	LEFT JOIN TAREFAS_PROCESSOS TP109		WITH (NOLOCK) ON TP109.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP109.ID_TASK = 109
	LEFT JOIN TAREFAS_PROCESSOS TP10		WITH (NOLOCK) ON TP10.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP10.ID_TASK = 10
	LEFT JOIN TAREFAS_PROCESSOS TP1			WITH (NOLOCK) ON TP1.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP1.ID_TASK = 1
	LEFT JOIN TAREFAS_PROCESSOS TP5			WITH (NOLOCK) ON TP5.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP5.ID_TASK = 5
	LEFT JOIN TAREFAS_PROCESSOS TP58		WITH (NOLOCK) ON TP58.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP58.ID_TASK = 58
	LEFT JOIN TAREFAS_PROCESSOS TP21		WITH (NOLOCK) ON TP21.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP21.ID_TASK = 21
	LEFT JOIN TAREFAS_PROCESSOS TP59		WITH (NOLOCK) ON TP59.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP59.ID_TASK = 59
	LEFT JOIN TAREFAS_PROCESSOS TP15		WITH (NOLOCK) ON TP15.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP15.ID_TASK = 15
	LEFT JOIN TAREFAS_PROCESSOS TP63		WITH (NOLOCK) ON TP63.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP63.ID_TASK = 63
	LEFT JOIN TAREFAS_PROCESSOS TP27		WITH (NOLOCK) ON TP27.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP27.ID_TASK = 27
	LEFT JOIN TAREFAS_PROCESSOS TP67		WITH (NOLOCK) ON TP67.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP67.ID_TASK = 67
	LEFT JOIN TAREFAS_PROCESSOS TP41		WITH (NOLOCK) ON TP41.NUM_PROC		=	HOU.NUM_PROC_HIA AND TP41.ID_TASK = 41

	LEFT JOIN NATURE_GOODS		NG			WITH (NOLOCK) ON NG.NUM_PROC		=	HOU.NUM_PROC_HIA
	Left Join Cia_Aerea			ARM			WITH (NOLOCK) ON ARM.Cd_Cia_Aer		=	JOB.Cd_Cia_Aer
	LEFT JOIN PO_HIA			PO5			WITH (NOLOCK) ON PO5.Num_Proc_HIA	=	HOU.NUM_PROC_HIA AND PO5.ID_DC = 5
	LEFT JOIN PO_HIA			PO71		WITH (NOLOCK) ON PO71.Num_Proc_HIA	=	HOU.Num_Proc_HIA AND PO71.ID_DC = 71
	LEFT JOIN PO_HIA			PO8			WITH (NOLOCK) ON PO8.Num_Proc_HIA	=	HOU.NUM_PROC_HIA AND PO8.ID_DC = 8
	LEFT JOIN PO_HIA			PO13		WITH (NOLOCK) ON PO13.Num_Proc_HIA	=	HOU.NUM_PROC_HIA AND PO13.ID_DC = 13
	--LEFT JOIN PO_HIA			PO2		WITH (NOLOCK) ON PO2.Num_Proc_HIA	=	HOU.NUM_PROC_HIA AND PO2.ID_DC = 2

	LEFT JOIN Localidade		DST			WITH (NOLOCK) ON DST.Cd_Local		=	HOU.Cd_Dst_HIA
	LEFT JOIN Localidade		ORG			WITH (NOLOCK) ON ORG.Cd_Local		=	HOU.Cd_Org_HIA
	LEFT JOIN Pais				DSTPais		WITH (NOLOCK) ON DSTPais.cd_pais	=	DST.cd_pais
	LEFT JOIN Pais				ORGPais		WITH (NOLOCK) ON ORGPais.cd_pais	=	ORG.cd_pais
	LEFT JOIN Localidade		DSTFNL		WITH (NOLOCK) ON DSTFNL.Cd_Local	=	LLP.Cd_DstFinal_LIA
	LEFT JOIN Localidade		ORGPLNT		WITH (NOLOCK) ON ORGPLNT.Cd_Local	=	LLP.Cd_Planta_LIA
	LEFT JOIN Usuario			US			WITH (NOLOCK) ON US.cd_usuario		=	JOB.Cd_Usuario
	LEFT JOIN Campo_Processo	CP32		WITH (NOLOCK) ON CP32.NUM_PROC		=	HOU.Num_Proc_HIA AND CP32.ID_Campo = 32	
	LEFT JOIN Campo_Processo	CP5			WITH (NOLOCK) ON CP5.NUM_PROC		=	HOU.Num_Proc_HIA AND CP5.ID_Campo = 5

	LEFT JOIN Usuario			SALES		WITH (NOLOCK) ON US.cd_usuario		=	JOB.cd_Vendedor
	LEFT JOIN Tipo_Status_Processo TSP		WITH (NOLOCK) ON LLP.id_status		=	TSP.id_status
	LEFT JOIN Terminal			TER			WITH (NOLOCK) ON TER.cd_terminal	=	LLP.cd_terminal
	Where
		HOU.Num_Proc_HIA = 'IASWB202408005BR' 
		--AND
		--convert(datetime,HOU.Dt_emis_hia,105) > getdate() -31


UNION ALL

	SELECT 
		HOU.Num_Proc_HEO																	[FRWDR_REF_NBR]
		,FORMAT(TP59.Dt_Conclusao , 'dd/MM/yy')												[ADVANCEMENT_REQ_DT]--I think it is 59 - -Solicitação de Numerário - <StatusType type="AdvancementReqDt"/>
		,NULL																				[AFRMM_PAYMENT_DT]
		,FORMAT( TP161.Dt_Conclusao , 'dd/MM/yy')											[ARR_DT]
		,isnull(GRP.Smart_Exp,HOU.Cd_Export_HEO)											[BDP_CLIENT_CD] -- spIntPessoa_Sel I = Smart_Imp,E = Smart_Exp <Request><Header><References type="ClientCode"><ReferenceNumber></ReferenceNumber>
		,FORMAT( TP40.Dt_Conclusao , 'dd/MM/yy')											[BDP_INVC_ACT_DT]	--Smart_Conclusao - spSmartBilledDate_Sel -   <Request><Header><Status><StatusType type="BilledDate"></StatusType>
		,FORMAT( TP40.Dt_Conclusao , 'dd/MM/yy')											[BDP_INVC_ACT_DTM]
		,[dbo].[fDW_BDP_INVC_REF_NBR](HOU.Num_Proc_HEO)										[BDP_INVC_REF_NBR]
		,NULL																				[BDP_REP_PRTY_ID]
		,LEFT(HOU.Num_Proc_HEO,1)															[BDP_SERVICE_CD]--<Request><Header Type="Export"></Header ></Request> then E
		,'01BDPBRSAO' 																		[BDP_SS_ID]
		,'N'																				[BDP_TRANS_IND]
		,(CASE WHEN HOU.Tp_Frete_HEO = 'P' THEN HOU.Vlr_Frete_Efet_HEO ELSE '0.00' END)		[BF_BOL_AWB_PRPD_AMT]--<Request><Header><Amounts><AmountType>BaseFreightBolAwbAmountPrepaid</AmountType></Amounts></Header></Request>
		,NULL																				[BKNG_CNFRM_DT]
		,FORMAT( isnull(TP41.Dt_Conclusao,DATEADD(day,-1, LLP.ATD_Leo)) , 'dd/MM/yy')		[BOL_POST_AUDT_BCK_DT]	--Smart_Conclusao - <Request><Header><Status><StatusType type="BOLBackDate"></StatusType>		
		,FORMAT( isnull(TP41.Dt_Conclusao,DATEADD(day,-1, LLP.ATD_Leo)) , 'dd/MM/yy')		[BOL_POST_AUDT_BCK_DTM]	
		,NULL																				[BOL_PRE_AUDT_RCV_DT]	-- Code - 66	Envio do draft do BL--<Request><Header><Status><StatusType type="BillofLadingRetreivedDate"></StatusType>
		,NULL																				[BOL_PRE_AUDT_RCV_DTM]
		,FORMAT( TP5.Dt_Conclusao , 'dd/MM/yy')												[BKNG_CNFRMTN_RCVD_FROM_SS_DT]
		,FORMAT( TP58.Dt_Conclusao , 'dd/MM/yy')											[BKNG_DT]
		,FORMAT( TP58.Dt_Conclusao , 'dd/MM/yy')											[BKNG_DTM]
		,HOU.Num_Proc_HEO																	[BKNG_NBR]--HouseBookingNumber
		,NULL																				[BOL_ACTN_DT]
		,FORMAT(LLP.ATD_Leo, 'dd/MM/yy')													[BOL_AWB_ISS_DT]
		,NULL																				[BOL_AWB_NBR] --HouseBillofLadingNumber-- HouseAirwayBill- verificar		
		,FORMAT(LLP.ATD_Leo, 'dd/MM/yy')													[BOL_SBMT_DT]
		,FORMAT(LLP.ATD_Leo, 'dd/MM/yy')													[BOL_SBMT_DTM]
		,NULL																				[BYR_PRTY_ID]		
		, 'LCL'																				[CARGO_TYP]--"<Request><Header><References type=""CargoType""><ReferenceNumber></ReferenceNumber></References></Header></Request>Request><Header>
		,NULL																				[CARRIER_DOC_CUTOFF_DT]--Only EM
		,NULL																				[CARRIER_DOC_CUTOFF_DTM]--Only EM
		,NULL																				[CHB_REF_NBR]--<Request><Header><References type="ClearingAgentReferenceNumber"><ReferenceNumber></ReferenceNumber>
		,NULL																				[CHRG_WGHT_QTY] --EA e IA
		,LEFT([dbo].[RemoveNonAlphaCharacters](NG.Descr),100)								[CARGO_DESC]--CargoDescription <Request><Header><CodesNames><CodesNamesType></CodesNamesType></CodesNames></Header></Request>
		,(CASE WHEN isnull(SCAC.Cd_Vendor,'') <> '' Then UPPER(ARM.Nome_Raz_SOC)
			else NULL	END)															    [CARR_NM]--If Request/Header/Transportation MethodofTransportation  is  Air and   <Request><Header><Transportation><Carrier><CarrierName></CarrierName></Carrier></Transportation></Header></Request>
		,FORMAT(TP21.Dt_Conclusao, 'dd/MM/yy')												[CARR_PYMNT_DT]
		,SCAC.Cd_Vendor																		[CARR_SCAC_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First"" thenIf Request/Header/Transportation/Carrier/CarrierCode/type is not equal to null then <Request><Header><Transportation><Carrier><CarrierCode></CarrierCode></Carrier></Transportation></Header></Request>"		
		,NULL																				[CHB_PRTY_ID]
		,NULL	[CHRG_RATE_AMT]
		,isnull(GRP.Smart_Exp,HOU.Cd_Export_HEO)+HOU.Cd_Export_HEO							[CLNT_CD] --<Request><Header><References type=""BDPClientCode""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,(CASE WHEN isnull(HOU.HAWB_HEO,'') = '' then 'D' else 'C' END)						[CNSOL_DRCT_CD]--"<Request><Header><References type=""ConsolIndicator""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,(CASE WHEN isnull(HOU.HAWB_HEO,'') = '' then NULL else HOU.HAWB_HEO  END)			[CNSOL_NBR] --<Request><Header><References type=""ConsolNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																				[CNTNR_EQUIP_CT]
		,NULL																				[CNTNR_TYP_CD_1]
		,NULL																				[CNTNR_TYP_CD_2]
		,NULL																				[CNTNR_TYP_CD_3]
		,HOU.Cd_Consig_HEO																	[CONSG_PRTY_CD]
		,NULL																				[CONSG_PRTY_ID]
		,NULL																				[CSTMS_ENTRY_PRMT_NBR] -- Only IM
		,FORMAT( TP4.Dt_Conclusao, 'dd/MM/yy')												[CSTMS_ENTRY_PRMT_REL_DT]
		,FORMAT( TP4.Dt_Conclusao, 'dd/MM/yy')												[CSTMS_ENTRY_PRMT_REL_DTM]
		,FORMAT( PO4.Data_PO_Heo, 'dd/MM/yy')												[CSTMS_ENTRY_PRMT_SBMT_DT]--Code - "<Request><Header><Status><StatusType type=""CustomsEntryPermitSubmissionDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,UPPER(DST.Nome_Local)																[CSTMS_ENTRY_PRT_NM]--ONLY IM ,EO,IO
		,(CASE WHEN DST.SCAC is null THEN
			DST.Cd_Pais+DST.Cd_Local ELSE DST.Cd_Pais + DST.SCAC END)						[CSTMS_ENTRY_PRT_UNLOC_CD]--ONLY IM ,EO,IO		
		,LEFT(UPPER(LLP.Canal_Leo),2)														[CSTMS_ENTRY_TYP_CD]--"<Request><Header><References type=""CustomsEntrytypeCode""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																				[CSTMS_PRT_ACT_DT]
		,NULL																				[CSTMS_PRT_EST_DT]
		,NULL																				[CSTMS_RLS_DT] --If Request/Header Type="Import"<Request><Header><Status><StatusType type="CustomsReleaseDate"></StatusType>           <StatusDate></StatusDate></Status></Header></Request>
		,NULL																				[CSTMS_RLS_DTM]
		,[dbo].[fDW_CUSTOMER_CSR_NM](HOU.Num_Proc_HEO)										[CUSTOMER_CSR_NM]--spCSRJob_SEL - <Request><Header><Parties><Party-Contacts type="CSR"><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
		,UPPER(DST.Cd_Pais)																	[DEST_CNTRY_CD]--If Request/Header/Transportation LegType="Primary" or "First"<Request><Header><Transportation><DestinationCountryCode></DestinationCountryCode></Transportation></Header></Request>
		,UPPER(DSTPais.Nome_Pais)															[DEST_CNTRY_NM]
		,UPPER(DST.Cd_Pais)																	[DEST_CNTRY_UNLOC_CD]
		,NULL																				[DEST_DEL_ACT_DT]---- Only Import ID_Task 13 Dt_Conclusao --<Request><Header><Status><StatusType type="ActDestinationDeliveryDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,NULL																				[DEST_DEL_ACT_DTM]
		,NULL																				[DEST_DEL_EST_DT]---- Only Import ID_Task 13 Dt_Previsao--<Request><Header><Status><StatusType type="EstDestinationDeliveryDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,NULL																				[DEST_DEL_EST_DTM]
		,NULL																				[DEST_INL_CARR_NM]
		,NULL																				[DEST_INL_CARR_SCAC_CD]
		,NULL																				[DLVRY_ORDR_CREATN_DT_ACT_DT]--Only Import ID_Task 7 Dt_Conclusao <Request><Header><Status><StatusType type="ActDeliveryOrderCreationDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,NULL																				[DLVRY_ORDR_DISTRIB_DT_ACT_DT]--Only Import ID_Task 7 Dt_Conclusao <Request><Header><Status><StatusType type="ActDeliveryOrderDistributionDate"></StatusType><StatusTime></StatusTime></Status></Header></Request>
		,FORMAT(TP12.Dt_Conclusao,'dd/MM/yy')												[DOC_DIST_RCV_ACT_DT]
		,FORMAT(TP12.Dt_Conclusao,'dd/MM/yy')												[DOC_DIST_RCV_ACT_DTM]
		,NULL																				[DOC_DIST_SEND_ACT_DT]
		,NULL																				[DOC_DIST_SEND_ACT_DTM]
		,FORMAT( TP12.Dt_Previsao , 'dd/MM/yy')												[DOC_DIST_SEND_EST_DT]
		,FORMAT( TP12.Dt_Previsao , 'dd/MM/yy')												[DOC_DIST_SEND_EST_DTM]
		,NULL																				[DOC_DIST_BY_NM]
		,NULL																				[DOCK_RCPT_CRTN_DT]--Only Import ID_Task 109 Dt_Conclusao--<Request><Header><Status><StatusType type="DockReceiptCreationDate"></StatusType></Status></Header></Request>
		,NULL																				[DRAFT_BOL_INSTR_RECVD_DT]--Only EM  ID_Task 66 Dt_Conclusao--<Request><Header><Status><StatusType type="DraftBOLInstrRecvdDt"></StatusType></Status></Header></Request>
		,NULL																				[ENTRY_IMM_DEL_RCV_DT]
		,NULL																				[ENTRY_IMM_DEL_RCV_DTM]
		,NULL																				[ENTRY_SUMM_SBMT_DT]--Not Sent"<Request><Header><Status><StatusType type=""EntrySummaryRejectDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																				[ENTRY_SUMM_SBMT_DTM]
		,FORMAT(LLP.ATD_Leo, 'dd/MM/yy')													[EXIT_CITY_ACT_DT]
		,UPPER(ORG.Cd_Pais)																	[EXP_CNTRY_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First""  <Request><Header><Transportation><OriginCountryCode></OriginCountryCode></Transportation></Header></Request>"
		,UPPER(ORG.Cd_Pais)																	[EXP_CNTRY_UNLOC_CD]
		,HOU.Num_Proc_HEO																	[EXPRT_JOB_NBR]
		,NULL																				[EXPTR_SHPR_PRTY_CD]
		,NULL																				[EXPTR_SHPR_PRTY_ID]
		,NULL																				[FEU_QTY]
		,FORMAT( TP12.Dt_Conclusao , 'dd/MM/yy')											[FILE_CLS_DT]--"<Request><Header><Status><StatusType type=""FileClosedDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"	--"<Request><Header><Status><StatusType type=""ClosedDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( TP12.Dt_Conclusao , 'dd/MM/yy')											[FILE_CLS_DTM]
		,NULL																				[FILE_CREATED_BY_NM]		
		,CONVERT(VARCHAR(8), CONVERT(DATE, HOU.Dt_Emis_HEO, 103), 3)						[FILE_CRTN_DT]
		,CONVERT(VARCHAR(8), CONVERT(DATE, HOU.Dt_Emis_HEO, 103), 3)						[FILE_CRTN_DTM]
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')											[FINAL_GOODS_ISS_DT]
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')											[FINAL_GOODS_ISS_DTM]
		,NULL																				[FRWDR_PRTY_ID]		
		,NULL																				[GE_DIVISION_CD]
		,NULL																				[GE_GROUP_CD]
		,NULL																				[GE_SBU_CD]
		,Exporter.GLOBAL_ENTITY_ID															[GEID]--"<Request><Header><Parties type=""Exporter""><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>"--"<Request><Header><Parties type=""Importer""><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>"
		,NULL																				[GLBL_AGNT_PRTY_ID]
		,UPPER(replace(replace(replace(ltrim(rtrim(HOU.Obs_HEO)),char(10),' '),char(13),' '),char(160),' ')) [GNRL_DESC]--"<Request><Header><References type=""GeneralDescription""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')											[GOODS_AVLBL_SHP_ACT_DT]--ONly for EA,EM,EO,IOActualPlantShipDate --"If the file is not  Meridian If <Request><Header><Status><StatusType type=""ActGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		<Request><Header><Status><StatusType type=""ActualPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')											[GOODS_AVLBL_SHP_ACT_DTM]
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')												[GOODS_AVLBL_SHP_EST_DT] --ONly for EA,EM,EO,IO	--"<Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"	--"If the file is not for Meridian 		--If <Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		--<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"		--"If the file is not for Meridian		--If <Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		--<Request><Header><Status><StatusType type=""EstimatedShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')												[GOODS_AVLBL_SHP_EST_DTM]
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')												[GOV_EXP_PRMSS_RLS_DT]--ONly for EA,EM,EO - "If Request/Header Type=""Export""<Request><Header><Status><StatusType type=""CustomsReleaseDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')												[GOV_EXP_PRMSS_RLS_DTM]
		,ISNULL(PO12.Numero_PO_HEO,PO204.Numero_PO_HEO)										[GOV_EXP_PRMSS_RLS_NBR]--ONly for EA,EM,EO"<Request><Header><References type=""GovernmentPermissionToExportReleaseNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																				[GOV_EXP_PRMSS_SBMT_DT]--Not Send -"If Request/Header Type=""Export""   <Request><Header><Status><StatusType type=""CustomsSubmitDate""></StatusType>           <StatusDate></StatusDate></Status></Header></Request>"
		,NULL																				[GOV_EXP_PRMSS_SBMT_DTM]
		,NULL																				[GOV_EXP_PRMSS_SBMT_NBR]
		,FORMAT( PO4.Data_PO_HEO, 'dd/MM/yy')												[GOV_PYMNT_STMNT_SBMT_DT]--IMP ID_DC 5, EXP-ID-DC 4<Request><Header><Status><StatusType type="GovernmentPaymentStatementSubmissionDate"></StatusType></Status></Header></Request>
		,FORMAT( PO4.Data_PO_HEO, 'dd/MM/yy')												[GOV_PYMNT_STMNT_SBMT_DTM]
		,HOU.Peso_Bruto_HEO																	[GROSS_TRANS_KILO_QTY]--"<Request><Header><Detail><ProductDetail><Measurements type=""GrsWtKgs""><MeasurementValue></MeasurementValue></Measurements></ProductDetail></Detail></Header></Request>"
		,HOU.Peso_Bruto_HEO * 2.2046														[GROSS_TRANS_POUND_QTY]
		,NULL																				[IMPORT_DCLRTN_DRFT_DT]
		,NULL																				[IMPORT_LIC_NEEDED_IND]
		,NULL																				[IMPTR_PRTY_CD]
		,NULL																				[IMPTR_PRTY_ID]
		,NULL																				[INSPECTN_DT_ACT_DT]
		,HOU.tp_frete_heO																	[INTL_FRGHT_TERM_CD]--<Request><Header><Transportation><PrepaidorCollect></PrepaidorCollect></Transportation></Header></Request>
		,UPPER(ISNULL(DSTFNL.Nome_Local,DST.Nome_Local))									[ITS_PLACE_OF_DLVRY_NM]	--"If Request/Header/Transportation MethodofTransportation  is not Air and  If <Request><Header><Transportation><Destination LocationType=""PlaceofDelivery""><DestinationName></DestinationName> </Destination></Transportation></Header></Request>"
		,UPPER(ISNULL(ORGPLNT.Nome_Local,ORG.Nome_Local))									[ITS_PLACE_OF_RCPT_NM]
		,UPPER(DST.Nome_Local)																[ITS_PORT_OF_DSCHRG_NM]
		,UPPER(DST.Nome_Local)																[ITS_PORT_OF_ENTRY_NM]
		,UPPER(ORG.Nome_Local)																[ITS_PORT_OF_LOAD_NM]
		,UPPER(ISNULL(ORGPLNT.Nome_Local,ORG.Nome_Local))									[ITS_PORT_OF_ORGN_NM]
		,FORMAT( [dbo].[fDW_LAST_MDFD_BY_DT](HOU.Num_Proc_HEO), 'dd/MM/yy')					[LAST_MDFD_BY_DT]--"<Request><Header><Status><StatusType type=""LastModifiedByDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,(CASE WHEN PO71.Numero_PO_HEO is not null THEN 'Y' ELSE 'N' END)					[LETTR_OF_CRDT_IND]--<Request><Header><LetterofCredit><RequiredYN></RequiredYN></LetterofCredit></Header></Request>
		,NULL																				[LQDTN_DT]--Only Import Data da DI and id_dc=5 --<Request><Header><Status><StatusType type="LiquidationDate"></StatusType></Status></Header></Request>
		,NULL																				[LTST_DEL_CUTOFF_DT] -- Ony FOR EM --<Request><Header><Status><StatusType type=""LatestDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																				[LTST_DEL_CUTOFF_DTM]-- Ony FOR EM--<Request><Header><Status><StatusType type=""LatestDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																				[MANIFEST_DT]
		,NULL																				[MANUF_PLNT_PRTY_ID]
		,NULL																				[MBOL_ACTN_DT]--Not Send--<Request><Header><FileStatus><Code>"MbolActionDate"</Code></FileStatus></Header></Request>
		,HOU.MAWB_HEO																		[MBOL_MAWB_NBR]--If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""MasterBillofLadingNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,NULL																				[MBOL_RCV_DT]
		,NULL																				[MBOL_RCV_DTM]
		,(CASE WHEN LLP.Tipo_Leo = 'T' then 'T' ELSE 'R' END)								[MOT_CD]--" Request><Header><Transportation MethodofTransportation= ""V""></Transportation></Header></Request>
		,(CASE WHEN HOU.cd_tp_oper='DDP' or HOU.cd_tp_oper='DDU' THEN 'DD' ELSE		
			(CASE WHEN HOU.cd_tp_oper ='FOB' or HOU.cd_tp_oper='FCA' THEN 'PP' ELSE
			'DP' END) END)	 																[MOVE_TYP_CD]

		,(CASE WHEN HOU.cd_tp_oper='DDP' or HOU.cd_tp_oper='DDU' THEN 'DOOR TO DOOR' ELSE		
			(CASE WHEN HOU.cd_tp_oper ='FOB' or HOU.cd_tp_oper='FCA' THEN  'PORT TO PORT H/H (DUP)' else
			'DOOR TO PORT (DUP)' END) END)													[MOVE_TYP_DESC]--Request><Header><Transportation><TypeofMoveCode Type="DP"></TypeofMoveCode></Transportation></Header></Request>---<Request><Header><Transportation><TypeofMoveDescription></TypeofMoveDescription></Transportation></Header></Request>
		
		,LLP.Nr_Reserva																		[MSTR_BKNG_NBR]-- If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""BookingNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
		,NULL																				[MSTR_CARR_NM]
		,NULL																				[MSTR_CARR_SCAC_CD]
		,HOU.Peso_Real_HEO																	[NET_TRANS_KILO_QTY]--<Request><Footer><Measurements item="NetWtKgs"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>-<Request><Footer><Measurements item="NetWeightKilograms"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,HOU.Peso_Real_HEO * 2.2046															[NET_TRANS_POUND_QTY]--<Request><Footer><Measurements item="NetWeightPounds"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,NULL																				[NF_COMPLIMENTARY_DT]
		,NULL																				[NF_DRFT_DT]
		,NULL																				[NTFY_PRTY_ID]
		,NULL																				[ONBRD_CONFRM_DT]--If Request/Header/Transportation LegType=""Primary"" or ""First"" 	and If Request/Header/Transportation MethodofTransportation  is ""Ocean"" or ""V"" or ""Barge"" or ""B"" or ""C"" Request><Header><Transportation><OriginDate Type=""Actual""></OriginDate></Transportation></Header></Request>"
		,NULL																				[ONBRD_CONFRM_DTM]
		,NULL																				[OPEN_GATE_DT]
		,(CASE WHEN CP32.Campo_DADOS = '2' THEN 'FFD' ELSE 'CHB' END)						[OPRTG_UNT_CL_CD]--<Request><Header><References type=""OperatingUnitClassification""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,left([dbo].[fDW_ORDR_TYP_CD](HOU.Num_Proc_HEO),1)									[ORDR_TYP_CD]--<Request><Header><References type="OrderType"><ReferenceNumber></ReferenceNumber></References></Header></Request>		--<Request><Header><Transportation><ReferenceType type="OrderType"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,FORMAT(LLP.ATD_LEo, 'dd/MM/yy')													[ORGN_CITY_ACT_DT]--<Request><Header><Amounts><AmountType>ActCityOfOriginDate</AmountType></Amounts></Header></Request>
		,UPPER(ORG.cd_pais)																	[ORGN_CNTRY_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First"" <Request><Header><Transportation><OriginCountryCode></OriginCountryCode></Transportation></Header></Request>"
		,UPPER(ORGPais.Nome_Pais)															[ORGN_CNTRY_NM]
		,UPPER(ORG.Cd_Pais)																	[ORGN_CNTRY_UNLOC_CD]
		,FORMAT( TP5.Dt_Conclusao , 'dd/MM/yy')												[ORGN_INL_BOOK_ACT_DT]
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')											[ORGN_INL_DEL_ACT_DT]--<Request><Header><Status><StatusType type="ActDomesticInlandDeliveryDate"></StatusType></Status></Header></Request>
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')											[ORGN_INL_DEL_ACT_DTM]
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')												[ORGN_INL_DEL_EST_DT]--<Request><Header><Status><StatusType type="EstDomesticInlandDeliveryDate"></StatusType></Status></Header></Request>
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')												[ORGN_INL_DEL_EST_DTM]
		,UPPER(ORGPLNT.Nome_Local)															[ORGN_INL_LOCTN_NM]
		,(CASE WHEN ORGPLNT.SCAC is null THEN ORGPLNT.Cd_Pais+ORGPLNT.Cd_Local 
			ELSE ORGPLNT.Cd_Pais + ORGPLNT.SCAC END)										[ORGN_INL_LOCTN_UNLOC_CD]
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')											[ORGN_INL_PCKP_ACT_DT]--10	EA,10	EM,10	EO - "If the file is not for Meridian If <Request><Header><Status><StatusType type=""ActGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')											[ORGN_INL_PCKP_ACT_DTM]
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')												[ORGN_INL_PCKP_EST_DT]--<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')												[ORGN_INL_PCKP_EST_DTM]
		,NULL																				[ORGN_PORT_NM]--if Request/Header/Transportation MethodofTransportation  is not Air and <Request><Header><Transportation><ReferenceType type=""OriginPort""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
		,NULL																				[ORGN_PORT_UNLOC_CD]--If Request/Header/Transportation LegType=""Primary"" or ""First"" then If Request/Header/Transportation/OriginCodeType/type = ""IATA"" or ""IATACode"" then		--<Request><Header><Transportation><OriginCodeType><OriginCode></OriginCode></OriginCodeType></Transportation></Header></Request>"
		,FORMAT( TP13.Dt_Conclusao , 'dd/MM/yy')											[PLACE_OF_DEL_ACT_DT]----<Request><Header><Status><StatusType type=""ActPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"--<Request><Header><Status><StatusType type=""ActualPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																				[PLACE_OF_DEL_ACT_DTM]	
		,FORMAT( TP13.Dt_Previsao , 'dd/MM/yy')												[PLACE_OF_DEL_EST_DT]--"<Request><Header><Status><StatusType type=""EstimatedPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"--<Request><Header><Status><StatusType type=""EstPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( TP13.Dt_Previsao , 'dd/MM/yy')												[PLACE_OF_DEL_EST_DTM]
		,UPPER(DSTFNL.Nome_Local)															[PLACE_OF_DEL_NM]----"Request><Header><References type=""PlaceofDelivery Name""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="PlaceofDelivery Name"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,(CASE WHEN DSTFNL.SCAC is null THEN DSTFNL.Cd_Pais+DSTFNL.Cd_Local
			ELSE DSTFNL.Cd_Pais + DSTFNL.SCAC END)											[PLACE_OF_DEL_UNLOC_CD]
		,(CASE WHEN FORMAT(isnull(TP10.Dt_Conclusao,getdate()) , 'dd/MM/yy') = FORMAT(isnull(LLP.ATD_Leo,getdate()), 'dd/MM/yy')  
				then FORMAT(TP10.Dt_Conclusao , 'dd/MM/yy')	
				else FORMAT(DATEADD(day,1,TP10.Dt_Conclusao ),'dd/MM/yy') end)				[PLACE_OF_RCPT_ACT_DT]--"<Request><Header><Status><StatusType type=""ActPlaceofReceiptDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"

		,(CASE WHEN FORMAT(isnull(TP10.Dt_Conclusao,getdate()) , 'dd/MM/yy') = FORMAT(isnull(LLP.ATD_Leo,getdate()), 'dd/MM/yy') 
				then FORMAT(TP10.Dt_Previsao , 'dd/MM/yy')	
				else FORMAT(DATEADD(day,1,TP10.Dt_Previsao ),'dd/MM/yy') end)				[PLACE_OF_RCPT_EST_DT]--"<Request><Header><Status><StatusType type=""EstPlaceofReceiptDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"

	,(CASE WHEN FORMAT(isnull(TP10.Dt_Conclusao,getdate()) , 'dd/MM/yy') = FORMAT(isnull(LLP.ATD_Leo,getdate()), 'dd/MM/yy') 
				then FORMAT(TP10.Dt_Previsao , 'dd/MM/yy')	
				else FORMAT(DATEADD(day,1,TP10.Dt_Previsao ),'dd/MM/yy') end)				[PLACE_OF_RCPT_EST_DTM]
		,UPPER(ORGPLNT.Nome_Local)															[PLACE_OF_RCPT_NM]
		,(CASE WHEN ORGPLNT.SCAC is null THEN ORGPLNT.Cd_Pais+ORGPLNT.Cd_Local
			ELSE ORGPLNT.Cd_Pais + ORGPLNT.SCAC END)										[PLACE_OF_RCPT_UNLOC_CD]
		,FORMAT(LLP.ATA_Leo , 'dd/MM/yy')													[PORT_OF_ARRVL_ACT_DT]
		,FORMAT(LLP.ETA_Leo , 'dd/MM/yy')													[PORT_OF_ARRVL_EST_DT]
		,UPPER(DST.Nome_Local)																[PORT_OF_ARRVL_NM]
		,(CASE WHEN DST.SCAC is null THEN DST.Cd_Pais+DST.Cd_Local
			ELSE DST.Cd_Pais + DST.SCAC END)												[PORT_OF_ARRVL_UNLOC_CD]
		,FORMAT(LLP.ATD_Leo	, 'dd/MM/yy')													[PORT_OF_DEPTR_ACT_DT]
		,FORMAT(LLP.ETD_Leo	, 'dd/MM/yy')													[PORT_OF_DEPTR_EST_DT]
		,UPPER(ORG.Nome_Local)																[PORT_OF_DEPTR_NM]				
		,(CASE WHEN ORG.SCAC is null THEN ORG.Cd_Pais+ORG.Cd_Local
			ELSE ORG.Cd_Pais + ORG.SCAC END)												[PORT_OF_DEPTR_UNLOC_CD]
		,NULL																				[PORT_OF_ENTRY_ACT_DT]
		,NULL																				[PORT_OF_ENTRY_EST_DT]
		,UPPER(DST.Nome_Local)																[PORT_OF_ENTRY_NM]
		,(CASE WHEN DST.SCAC is null THEN DST.Cd_Pais+DST.Cd_Local
			ELSE DST.Cd_Pais + DST.SCAC END)												[PORT_OF_ENTRY_UNLOC_CD]		
		,FORMAT( LLP.ATD_LEO, 'dd/MM/yy')													[PORT_OF_EXIT_ACT_DT]--<Request><Header><Status><StatusType type="ActPortOfExitDate"></StatusType></Status></Header></Request>
		,NULL																				[PORT_OF_EXIT_EST_DT]--"<Request><Header><Status><StatusType type=""EstPortOfExitDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,NULL																				[PORT_OF_EXIT_UNLOC_CD]
		,FORMAT( TP1.Dt_Conclusao, 'dd/MM/yy')												[PRESHPMNT_ADVC_DT]--"<Request><Header><Status><StatusType type=""PreShipmentAdviceDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"			
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEO) > 0 
			THEN 
				(Case when [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEO) < isnull(HOU.vlr_frete_efet_heo,0) 
					THEN 
						[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEO)
					ELSE
						[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HEO) - isnull(HOU.vlr_frete_efet_heo,0)
				END)
			ELSE 
				LLP.Vlr_Invoice - isnull(HOU.vlr_frete_efet_heo,0) END)						[REPRT_VAL_AMT]--<Request><Footer><Measurements item="ReportableValueAmount"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>--<Request><Footer><Measurements item="TotalFAS"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>		
		,FORMAT( LLP.ETA_Leo, 'dd/MM/yy')													[RQST_ETA_DEST_DT]--"<Request><Header><Status><StatusType type=""RequestedETADestDate""></StatusType>           <StatusTime></StatusTime></Status></Header></Request>"
		,Sales.Nome_Usuario																	[SALES_PERSON_NM]--spINTSmartVendedor_Sel <Request><Header><CodesNames><CodesNamesName></CodesNamesName></CodesNames></Header></Request>
		,isnull(PO8.Numero_PO_HEO,HOU.HAWB_HEO)												[SAP_SHPMNT_NBR]--"<Request><Header><References type=""SAPShipmentNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--<Request><Header><Transportation><ReferenceType type="SAPShipmentNumber"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,NULL																				[SBU]--Request><Header><Transportation><ReferenceType type="SBU"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>--"<Request><Header><References type=""SBU""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																				[SBU_DESC]--"<Request><Header><References type=""SBUDescription""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="SBUDescription"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,FORMAT([dbo].[fDW_SDA_PAYMENT_DT]('SDA'), 'dd/MM/yy')								[SDA_PAYMENT_DT]--[spINTSmartPagamentos_Sel]'EMATL202407001BR','SDA'
		,UPPER(cast(LLP.ID_Status as varchar(2)) + '-' + TSP.Status_Descricao_Ingles)		[SHIPMENT_STATUS]
		,NULL																				[SHP_TO_PRTY_ID]
		,NULL																				[SLD_TO_PRTY_ID]
		,NULL																				[SLLR_PRTY_ID]
		,[dbo].[fBusca_TEUS](HOU.NUm_PROC_HEO)												[TEU_QTY]--<Request><Header><Amounts><AmountType>NumberOfTEUs</AmountType></Amounts></Header></Request>
		,HOU.Vol_Tot_HEO																	[TOT_CUBIC_FT_QTY]--<Request><Footer><Measurements><MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,UPPER(TER.Nome_Terminal)															[TRMNL_PIER_NM]
		,isnull(HOU.vlr_frete_efet_heo,0)													[TTL_FRGHT_BOL_AWB_PRPD_AMT]--<Request><Header><Transportation><ReferenceType type="FreightAmount"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,NULL																				[VOYG_FLGHT_NBR]--"If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""VoyageNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"--"If Request/Header/Transportation LegType=""Primary"" or ""First"" Request><Header><Transportation><ReferenceType type=""FlightNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
		,NULL																				[SOLAS_VRFDGRSSMASSCUTOFF_DT]-- only EM"<Request><Header><Status><StatusType type=""SolasVrfdGrMassCutDt""></StatusType>StatusTime></StatusTime></Status></Header></Request>"
		,NULL																				[SOLAS_VRFDGRSSMASSCUTOFF_DTM]--<Request><Header><Status><StatusType type="SolasVrfdGrMassCutDt"></StatusType></Status></Header></Request>
		,NULL																				[LC_ISSUING_NBR]--"If Request/Header/LetterofCredit/BankParties type = ""IssuingBank"" then <Request><Header><LetterofCredit><BankParties><BankPartyName></BankPartyName></BankParties></LetterofCredit></Header></Request>"
		,FORMAT([dbo].fDW_ORDR_CRTN_DT(HOU.NUm_PROC_HEO), 'dd/MM/yy')						[ORDR_CRTN_DT]--spINTDtPedido '" & ProcessoDT.Rows(0)("processo").ToString() & "'--"<Request><Header><Status><StatusType type=""OrderReceiveDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( PO13.Data_PO_HEO, 'dd/MM/yy')												[CERT_OF_ORGN_APPLIED_DT]--<Request><Header><Status><StatusType type="CertOriginApplied"></StatusType></Status></Header></Request>
	FROM DBO.HOUSE_EXP_OUT		HOU			WITH (NOLOCK) 
	JOIN LLP_EXP_OUT			LLP			WITH (NOLOCK) ON LLP.NUM_PROC_LEO	=	HOU.NUM_PROC_HEO
	LEFT JOIN PESSOA			Exporter	WITH (NOLOCK) ON Exporter.CD_PES	=	HOU.Cd_Export_HEO
	LEFT JOIN PESSOA			Consignee	WITH (NOLOCK) ON Consignee.CD_PES	=	HOU.Cd_Consig_HEO	
	LEFT JOIN PESSOA			Notify		WITH (NOLOCK) ON Notify.CD_PES		=	HOU.Cd_Notify_HEO	
	LEFT JOIN PESSOA_LLP		PLLP		WITH (NOLOCK) ON HOU.CD_EXPORT_HEO	=	PLLP.CD_PES
	LEFT JOIN GRUPO				GRP			WITH (NOLOCK) ON GRP.CD_PES_GRUPO	=   PLLP.CD_PES_GRUPO
	LEFT JOIN TAREFAS_PROCESSOS TP40		WITH (NOLOCK) ON TP40.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP40.ID_TASK = 40
	LEFT JOIN TAREFAS_PROCESSOS TP217		WITH (NOLOCK) ON TP217.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP217.ID_TASK = 217
	LEFT JOIN TAREFAS_PROCESSOS TP83		WITH (NOLOCK) ON TP83.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP83.ID_TASK = 83
	LEFT JOIN TAREFAS_PROCESSOS TP66		WITH (NOLOCK) ON TP66.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP66.ID_TASK = 66
	LEFT JOIN TAREFAS_PROCESSOS TP45		WITH (NOLOCK) ON TP45.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP45.ID_TASK = 45
	LEFT JOIN TAREFAS_PROCESSOS TP4			WITH (NOLOCK) ON TP4.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP4.ID_TASK = 4
	LEFT JOIN TAREFAS_PROCESSOS TP10		WITH (NOLOCK) ON TP10.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP10.ID_TASK = 10
	LEFT JOIN TAREFAS_PROCESSOS TP13		WITH (NOLOCK) ON TP13.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP13.ID_TASK = 13
	LEFT JOIN TAREFAS_PROCESSOS TP1			WITH (NOLOCK) ON TP1.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP1.ID_TASK = 1
	LEFT JOIN TAREFAS_PROCESSOS TP5			WITH (NOLOCK) ON TP5.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP5.ID_TASK = 5
	LEFT JOIN TAREFAS_PROCESSOS TP58		WITH (NOLOCK) ON TP58.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP58.ID_TASK = 58
	LEFT JOIN TAREFAS_PROCESSOS TP21		WITH (NOLOCK) ON TP21.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP21.ID_TASK = 21
	LEFT JOIN TAREFAS_PROCESSOS TP12		WITH (NOLOCK) ON TP12.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP12.ID_TASK = 12
	LEFT JOIN TAREFAS_PROCESSOS TP161		WITH (NOLOCK) ON TP161.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP161.ID_TASK = 161
	LEFT JOIN TAREFAS_PROCESSOS TP59		WITH (NOLOCK) ON TP59.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP59.ID_TASK = 59
	LEFT JOIN TAREFAS_PROCESSOS TP41		WITH (NOLOCK) ON TP41.NUM_PROC		=	HOU.NUM_PROC_HEO AND TP41.ID_TASK = 41

	LEFT JOIN NATURE_GOODS		NG			WITH (NOLOCK) ON NG.NUM_PROC		=	HOU.NUM_PROC_HEO
	Left Join Pessoa			ARM			WITH (NOLOCK) ON ARM.Cd_Pes			=	LLP.Cd_Carrier
	Left Join Pessoa_LLP		SCAC		WITH (NOLOCK) ON SCAC.Cd_Pes		=	LLP.Cd_Carrier
	LEFT JOIN PO_HEO			PO4			WITH (NOLOCK) ON PO4.Num_Proc_HEO	=	HOU.NUM_PROC_HEO AND PO4.ID_DC = 4
	LEFT JOIN PO_HEO			PO12		WITH (NOLOCK) ON PO12.Num_Proc_HEO	=	HOU.NUM_PROC_HEO AND PO12.ID_DC = 12
	LEFT JOIN PO_HEO			PO204		WITH (NOLOCK) ON PO204.Num_Proc_HEO	=	HOU.NUM_PROC_HEO AND PO204.ID_DC = 204
	LEFT JOIN PO_HEO			PO71		WITH (NOLOCK) ON PO71.Num_Proc_HEO	=	HOU.NUM_PROC_HEO AND PO71.ID_DC = 71
	LEFT JOIN PO_HEO			PO8			WITH (NOLOCK) ON PO8.Num_Proc_HEO	=	HOU.NUM_PROC_HEO AND PO8.ID_DC = 8
	LEFT JOIN PO_HEO			PO13		WITH (NOLOCK) ON PO13.Num_Proc_HEO	=	HOU.NUM_PROC_HEO AND PO13.ID_DC = 13
	--LEFT JOIN PO_HEO			PO2			WITH (NOLOCK) ON PO2.Num_Proc_HEO	=	HOU.NUM_PROC_HEO AND PO2.ID_DC = 2

	LEFT JOIN Localidade		DST			WITH (NOLOCK) ON DST.Cd_Local		=	HOU.Cd_Dst_HEO
	LEFT JOIN Localidade		ORG			WITH (NOLOCK) ON ORG.Cd_Local		=	HOU.Cd_Org_HEO
	LEFT JOIN Pais				DSTPais		WITH (NOLOCK) ON DSTPais.cd_pais	=	DST.cd_pais
	LEFT JOIN Pais				ORGPais		WITH (NOLOCK) ON ORGPais.cd_pais	=	ORG.cd_pais
	LEFT JOIN Localidade		DSTFNL		WITH (NOLOCK) ON DSTFNL.Cd_Local	=	LLP.Cd_DstFinal_Leo
	LEFT JOIN Localidade		ORGPLNT		WITH (NOLOCK) ON ORGPLNT.Cd_Local	=	LLP.Cd_Planta_Leo
	LEFT JOIN Usuario			US			WITH (NOLOCK) ON US.cd_usuario		=	LLP.Cd_Usuario
	LEFT JOIN Campo_Processo	CP32		WITH (NOLOCK) ON CP32.NUM_PROC		=	HOU.NUM_PROC_HEO AND CP32.ID_Campo = 32	
	LEFT JOIN Usuario			Sales		WITH (NOLOCK) ON Sales.cd_usuario	=	LLP.cd_Vendedor
	LEFT JOIN Tipo_Status_Processo TSP		WITH (NOLOCK) ON LLP.id_status		=	TSP.id_status
	LEFT JOIN Terminal			TER			WITH (NOLOCK) ON TER.cd_terminal	=	LLP.cd_terminal
	Where
		HOU.Num_Proc_HEO in ('EOQSB202408002BR','EORHO202408020BR')
		--AND
		--convert(datetime,HOU.Dt_emis_heo,105) > getdate() -31
				

UNION ALL

	SELECT 
		HOU.Num_Proc_HIO																	[FRWDR_REF_NBR]
		,FORMAT(TP59.Dt_Conclusao , 'dd/MM/yy')												[ADVANCEMENT_REQ_DT]--I think it is 59 - -Solicitação de Numerário - <StatusType type="AdvancementReqDt"/>
		,NULL																				[AFRMM_PAYMENT_DT]
		,NULL																				[ARR_DT]
		,isnull(GRP.Smart_Imp,HOU.Cd_Consig_HIO)											[BDP_CLIENT_CD] -- spIntPessoa_Sel I = Smart_Imp,E = Smart_Exp <Request><Header><References type="ClientCode"><ReferenceNumber></ReferenceNumber>
		,FORMAT( TP40.Dt_Conclusao , 'dd/MM/yy')											[BDP_INVC_ACT_DT]	--Smart_Conclusao - spSmartBilledDate_Sel -   <Request><Header><Status><StatusType type="BilledDate"></StatusType>
		,FORMAT( TP40.Dt_Conclusao , 'dd/MM/yy')											[BDP_INVC_ACT_DTM]
		,[dbo].[fDW_BDP_INVC_REF_NBR](HOU.Num_Proc_HIO)										[BDP_INVC_REF_NBR]
		,NULL																				[BDP_REP_PRTY_ID]
		,LEFT(HOU.Num_Proc_HIO,1)															[BDP_SERVICE_CD]--<Request><Header Type="Export"></Header ></Request> then E
		,'01BDPBRSAO' 																		[BDP_SS_ID]
		,'N'																				[BDP_TRANS_IND]
		,(CASE WHEN HOU.Tp_Frete_HIO = 'P' THEN HOU.vlr_frete_efet_hio ELSE '0.00' END)		[BF_BOL_AWB_PRPD_AMT]--<Request><Header><Amounts><AmountType>BaseFreightBolAwbAmountPrepaid</AmountType></Amounts></Header></Request>
		,NULL																				[BKNG_CNFRM_DT]
		,FORMAT(isnull(DATEADD(day,-1, LLP.ATD_Lio),TP41.Dt_Conclusao) , 'dd/MM/yy')		[BOL_POST_AUDT_BCK_DT]	--Smart_Conclusao - <Request><Header><Status><StatusType type="BOLBackDate"></StatusType>		
		,FORMAT(isnull(DATEADD(day,-1, LLP.ATD_Lio),TP41.Dt_Conclusao) , 'dd/MM/yy')		[BOL_POST_AUDT_BCK_DTM]	
		,NULL																				[BOL_PRE_AUDT_RCV_DT]	-- Code - 66	Envio do draft do BL--<Request><Header><Status><StatusType type="BillofLadingRetreivedDate"></StatusType>
		,NULL																				[BOL_PRE_AUDT_RCV_DTM]
		,FORMAT( TP5.Dt_Conclusao , 'dd/MM/yy')												[BKNG_CNFRMTN_RCVD_FROM_SS_DT]
		,FORMAT( TP58.Dt_Conclusao , 'dd/MM/yy')											[BKNG_DT]
		,FORMAT( TP58.Dt_Conclusao , 'dd/MM/yy')											[BKNG_DTM]
		,HOU.Num_Proc_HIO																	[BKNG_NBR]--HouseBookingNumber
		,NULL																				[BOL_ACTN_DT]--NOt Mapped in The File
		,FORMAT(LLP.ATD_Lio, 'dd/MM/yy')													[BOL_AWB_ISS_DT]
		,NULL																				[BOL_AWB_NBR] --HouseBillofLadingNumber-- HouseAirwayBill- verificar		
		,FORMAT(LLP.ATD_Lio, 'dd/MM/yy')													[BOL_SBMT_DT]
		,FORMAT(LLP.ATD_Lio, 'dd/MM/yy')													[BOL_SBMT_DTM]
		,NULL																				[BYR_PRTY_ID]
		,'LCL'																				[CARGO_TYP]
		,NULL																				[CARRIER_DOC_CUTOFF_DT]--Only EM
		,NULL																				[CARRIER_DOC_CUTOFF_DTM]--Only EM
		,HOU.Num_Proc_HIO																	[CHB_REF_NBR]--<Request><Header><References type="ClearingAgentReferenceNumber"><ReferenceNumber></ReferenceNumber>
		,NULL																				[CHRG_WGHT_QTY] --EA e IA
		,LEFT([dbo].[RemoveNonAlphaCharacters](NG.Descr),100)								[CARGO_DESC]--CargoDescription <Request><Header><CodesNames><CodesNamesType></CodesNamesType></CodesNames></Header></Request>
		,(CASE WHEN isnull(SCAC.Cd_Vendor,'') <> '' Then UPPER(ARM.Nome_Raz_SOC)
			else NULL	END)																[CARR_NM]--If Request/Header/Transportation MethodofTransportation  is  Air and   <Request><Header><Transportation><Carrier><CarrierName></CarrierName></Carrier></Transportation></Header></Request>
		,FORMAT( TP21.Dt_Conclusao, 'dd/MM/yy')												[CARR_PYMNT_DT]
		,LEFT(SCAC.Cd_Vendor,4)																[CARR_SCAC_CD]
		,NULL																				[CHB_PRTY_ID]
		,NULL																				[CHRG_RATE_AMT]
		,isnull(GRP.Smart_Imp,HOU.Cd_Consig_HIO)+isnull(GRP.Smart_Imp,HOU.Cd_Consig_HIO)	[CLNT_CD] --<Request><Header><References type=""BDPClientCode""><ReferenceNumber></ReferenceNumber></References></Header></Request>"		
		,(CASE WHEN isnull(HOU.HAWB_HIO,'') = '' then 'D' else 'C' END)						[CNSOL_DRCT_CD]--"<Request><Header><References type=""ConsolIndicator""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,(CASE WHEN isnull(HOU.HAWB_HIO,'') = '' then NULL else HOU.HAWB_HIO  END)			[CNSOL_NBR] --<Request><Header><References type=""ConsolNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																				[CNTNR_EQUIP_CT]
		,NULL																				[CNTNR_TYP_CD_1]
		,NULL																				[CNTNR_TYP_CD_2]
		,NULL																				[CNTNR_TYP_CD_3]
		,isnull(GRP.Smart_Imp,HOU.Cd_Consig_HIO)											[CONSG_PRTY_CD]
		,NULL																				[CONSG_PRTY_ID]
		,PO5.Numero_PO_HIO																	[CSTMS_ENTRY_PRMT_NBR]
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')												[CSTMS_ENTRY_PRMT_REL_DT]--Smart_Conclusao <Request><Header><Status><StatusType type=""CustomsEntryPermitReleaseDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')												[CSTMS_ENTRY_PRMT_REL_DTM]
		,FORMAT( PO5.Data_PO_Hio, 'dd/MM/yy')												[CSTMS_ENTRY_PRMT_SBMT_DT]--Code - "<Request><Header><Status><StatusType type=""CustomsEntryPermitSubmissionDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,UPPER(DST.Nome_Local)																[CSTMS_ENTRY_PRT_NM]--ONLY IM ,EO,IO
		,(CASE WHEN DST.SCAC is null THEN DST.Cd_Pais+DST.Cd_Local ELSE 
			DST.Cd_Pais + DST.SCAC END)														[CSTMS_ENTRY_PRT_UNLOC_CD]--ONLY IM ,EO,IO 		
		,LEFT(UPPER(LLP.Canal_Lio),2)														[CSTMS_ENTRY_TYP_CD]--"<Request><Header><References type=""CustomsEntrytypeCode""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,FORMAT( TP15.Dt_Conclusao , 'dd/MM/yy')											[CSTMS_PRT_ACT_DT]
		,FORMAT( TP15.Dt_Previsao , 'dd/MM/yy')												[CSTMS_PRT_EST_DT]
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')												[CSTMS_RLS_DT] --If Request/Header Type="Import"<Request><Header><Status><StatusType type="CustomsReleaseDate"></StatusType>           <StatusDate></StatusDate></Status></Header></Request>
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')												[CSTMS_RLS_DTM]
		,UPPER([dbo].[fDW_CUSTOMER_CSR_NM](HOU.Num_Proc_HIO))								[CUSTOMER_CSR_NM]--spCSRJob_SEL - <Request><Header><Parties><Party-Contacts type="CSR"><Contact-Name></Contact-Name></Party-Contacts></Parties></Header></Request>
		,UPPER(DST.Cd_Pais)																	[DEST_CNTRY_CD]--If Request/Header/Transportation LegType="Primary" or "First"<Request><Header><Transportation><DestinationCountryCode></DestinationCountryCode></Transportation></Header></Request>
		,UPPER(DSTPais.Nome_Pais)															[DEST_CNTRY_NM]
		,UPPER(DST.Cd_Pais)																	[DEST_CNTRY_UNLOC_CD]
		,FORMAT( TP13.Dt_Conclusao , 'dd/MM/yy')											[DEST_DEL_ACT_DT]---- Only Import ID_Task 13 Dt_Conclusao --<Request><Header><Status><StatusType type="ActDestinationDeliveryDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,FORMAT( TP13.Dt_Conclusao , 'dd/MM/yy')											[DEST_DEL_ACT_DTM]
		,(Case when TP13.Dt_Conclusao is not null then 
			FORMAT( TP13.Dt_Previsao , 'dd/MM/yy') else NULL end)							[DEST_DEL_EST_DT]---- Only Import ID_Task 13 Dt_Previsao--<Request><Header><Status><StatusType type="EstDestinationDeliveryDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,(Case when TP13.Dt_Conclusao is not null 
			then FORMAT( TP13.Dt_Previsao , 'dd/MM/yy') else NULL end)						[DEST_DEL_EST_DTM]

		,NULL																				[DEST_INL_CARR_NM]
		,NULL																				[DEST_INL_CARR_SCAC_CD]
		,FORMAT( TP7.Dt_Conclusao , 'dd/MM/yy')												[DLVRY_ORDR_CREATN_DT_ACT_DT]--Only Import ID_Task 7 Dt_Conclusao <Request><Header><Status><StatusType type="ActDeliveryOrderCreationDate"></StatusType><StatusDate></StatusDate></Status></Header></Request>
		,FORMAT( TP7.Dt_Conclusao , 'dd/MM/yy')												[DLVRY_ORDR_DISTRIB_DT_ACT_DT]--Only Import ID_Task 7 Dt_Conclusao <Request><Header><Status><StatusType type="ActDeliveryOrderDistributionDate"></StatusType><StatusTime></StatusTime></Status></Header></Request>
		,FORMAT( TP63.Dt_Conclusao , 'dd/MM/yy')											[DOC_DIST_RCV_ACT_DT]
		,FORMAT( TP63.Dt_Conclusao , 'dd/MM/yy')											[DOC_DIST_RCV_ACT_DTM]
		,NULL																				[DOC_DIST_SEND_ACT_DT]
		,NULL																				[DOC_DIST_SEND_ACT_DTM]
		,NULL																				[DOC_DIST_SEND_EST_DT]
		,NULL																				[DOC_DIST_SEND_EST_DTM]
		,NULL																				[DOC_DIST_BY_NM]
		,FORMAT( TP109.Dt_Conclusao , 'dd/MM/yy')											[DOCK_RCPT_CRTN_DT]--Only Import ID_Task 109 Dt_Conclusao--<Request><Header><Status><StatusType type="DockReceiptCreationDate"></StatusType></Status></Header></Request>
		,NULL																				[DRAFT_BOL_INSTR_RECVD_DT]--Only EM  ID_Task 66 Dt_Conclusao--<Request><Header><Status><StatusType type="DraftBOLInstrRecvdDt"></StatusType></Status></Header></Request>
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')												[ENTRY_IMM_DEL_RCV_DT]
		,FORMAT( TP4.Dt_Conclusao , 'dd/MM/yy')												[ENTRY_IMM_DEL_RCV_DTM]
		,FORMAT( PO5.Data_PO_HIO, 'dd/MM/yy')												[ENTRY_SUMM_SBMT_DT]--Not Sent"<Request><Header><Status><StatusType type=""EntrySummaryRejectDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( PO5.Data_PO_HIO, 'dd/MM/yy')												[ENTRY_SUMM_SBMT_DTM]
		,FORMAT(LLP.ATD_Lio, 'dd/MM/yy')													[EXIT_CITY_ACT_DT]
		,UPPER(ORG.Cd_Pais)																	[EXP_CNTRY_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First""  <Request><Header><Transportation><OriginCountryCode></OriginCountryCode></Transportation></Header></Request>"

		,UPPER(ORG.Cd_Pais)																	[EXP_CNTRY_UNLOC_CD]
		,NULL																				[EXPRT_JOB_NBR]
		,NULL																				[EXPTR_SHPR_PRTY_CD]
		,NULL																				[EXPTR_SHPR_PRTY_ID]
		,NULL																				[FEU_QTY]
		,FORMAT( TP40.Dt_Conclusao , 'dd/MM/yy')											[FILE_CLS_DT]--"<Request><Header><Status><StatusType type=""FileClosedDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"	--"<Request><Header><Status><StatusType type=""ClosedDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( TP40.Dt_Conclusao , 'dd/MM/yy')											[FILE_CLS_DTM]
		,NULL																				[FILE_CREATED_BY_NM]		
		,CONVERT(VARCHAR(8), CONVERT(DATE, HOU.Dt_Emis_HIO, 103), 3)						[FILE_CRTN_DT]
		,CONVERT(VARCHAR(8), CONVERT(DATE, HOU.Dt_Emis_HIO, 103), 3)						[FILE_CRTN_DTM]
		,NULL																				[FINAL_GOODS_ISS_DT]
		,NULL																				[FINAL_GOODS_ISS_DTM]
		,NULL																				[FRWDR_PRTY_ID]		
		,NULL																				[GE_DIVISION_CD]
		,NULL																				[GE_GROUP_CD]
		,NULL																				[GE_SBU_CD]
		,Consignee.GLOBAL_ENTITY_ID															[GEID]--"<Request><Header><Parties type=""Exporter""><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>"--"<Request><Header><Parties type=""Importer""><Party-GlobalCode></Party-GlobalCode></Parties></Header></Request>"
		,NULL																				[GLBL_AGNT_PRTY_ID]
		,UPPER(replace(replace(replace(ltrim(rtrim(HOU.Obs_HIO)),char(10),' '),char(13),' '),char(160),' ')) [GNRL_DESC]--"<Request><Header><References type=""GeneralDescription""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																				[GOODS_AVLBL_SHP_ACT_DT]--ONly for EA,EM,EO,IOActualPlantShipDate --"If the file is not  Meridian If <Request><Header><Status><StatusType type=""ActGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		<Request><Header><Status><StatusType type=""ActualPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,NULL																				[GOODS_AVLBL_SHP_ACT_DTM]
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')												[GOODS_AVLBL_SHP_EST_DT] --ONly for EA,EM,EO,IO	--"<Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"	--"If the file is not for Meridian 		--If <Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		--<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"		--"If the file is not for Meridian		--If <Request><Header><Status><StatusType type=""EstGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then		--<Request><Header><Status><StatusType type=""EstimatedShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')												[GOODS_AVLBL_SHP_EST_DTM]
		,NULL																				[GOV_EXP_PRMSS_RLS_DT]--ONly for EA,EM,EO - "If Request/Header Type=""Export""<Request><Header><Status><StatusType type=""CustomsReleaseDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																				[GOV_EXP_PRMSS_RLS_DTM]
		,NULL																				[GOV_EXP_PRMSS_RLS_NBR]--ONly for EA,EM,EO"<Request><Header><References type=""GovernmentPermissionToExportReleaseNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																				[GOV_EXP_PRMSS_SBMT_DT]--Not Send -"If Request/Header Type=""Export""   <Request><Header><Status><StatusType type=""CustomsSubmitDate""></StatusType>           <StatusDate></StatusDate></Status></Header></Request>"
		,NULL																				[GOV_EXP_PRMSS_SBMT_DTM]
		,NULL																				[GOV_EXP_PRMSS_SBMT_NBR]
		,FORMAT( PO5.Data_PO_HIO, 'dd/MM/yy')												[GOV_PYMNT_STMNT_SBMT_DT]--IMP ID_DC 5, EXP-ID-DC 4<Request><Header><Status><StatusType type="GovernmentPaymentStatementSubmissionDate"></StatusType></Status></Header></Request>
		,FORMAT( PO5.Data_PO_HIO, 'dd/MM/yy')												[GOV_PYMNT_STMNT_SBMT_DTM]

		,HOU.Peso_Bruto_HIO																	[GROSS_TRANS_KILO_QTY]--"<Request><Header><Detail><ProductDetail><Measurements type=""GrsWtKgs""><MeasurementValue></MeasurementValue></Measurements></ProductDetail></Detail></Header></Request>"
		,HOU.Peso_Bruto_HIO * 2.2046														[GROSS_TRANS_POUND_QTY]
		,FORMAT( TP27.Dt_Conclusao , 'dd/MM/yy')											[IMPORT_DCLRTN_DRFT_DT]
		,(CASE WHEN CP5.Campo_DADOS is null then NULL ELSE
		(CASE WHEN CP5.Campo_DADOS = '2' THEN 'N' ELSE 'Y' END)	END)						[IMPORT_LIC_NEEDED_IND]--spSmartNecessidadeLI_Sel
		,NULL																				[IMPTR_PRTY_CD]
		,NULL																				[IMPTR_PRTY_ID]
		,NULL																				[INSPECTN_DT_ACT_DT]
		,HOU.Tp_Frete_HIO																	[INTL_FRGHT_TERM_CD]--<Request><Header><Transportation><PrepaidorCollect></PrepaidorCollect></Transportation></Header></Request>
		,UPPER(ISNULL(DSTFNL.Nome_Local,DST.Nome_Local))									[ITS_PLACE_OF_DLVRY_NM]	--"If Request/Header/Transportation MethodofTransportation  is not Air and  If <Request><Header><Transportation><Destination LocationType=""PlaceofDelivery""><DestinationName></DestinationName> </Destination></Transportation></Header></Request>"
		,UPPER(ISNULL(ORGPLNT.Nome_Local,ORG.Nome_Local))									[ITS_PLACE_OF_RCPT_NM]
		,UPPER(DST.Nome_Local)																[ITS_PORT_OF_DSCHRG_NM]
		,UPPER(DST.Nome_Local)																[ITS_PORT_OF_ENTRY_NM]
		,UPPER(ORG.Nome_Local)																[ITS_PORT_OF_LOAD_NM]
		,UPPER(ISNULL(ORGPLNT.Nome_Local,ORG.Nome_Local))									[ITS_PORT_OF_ORGN_NM]
		,FORMAT( [dbo].[fDW_LAST_MDFD_BY_DT](HOU.Num_Proc_HIO), 'dd/MM/yy')					[LAST_MDFD_BY_DT]--"<Request><Header><Status><StatusType type=""LastModifiedByDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,(CASE WHEN PO71.Numero_PO_HIO is not null THEN 'Y' ELSE 'N' END)					[LETTR_OF_CRDT_IND]--<Request><Header><LetterofCredit><RequiredYN></RequiredYN></LetterofCredit></Header></Request>
		,FORMAT( PO5.Data_PO_HIO, 'dd/MM/yy')												[LQDTN_DT]--Only Import Data da DI and id_dc=5 --<Request><Header><Status><StatusType type="LiquidationDate"></StatusType></Status></Header></Request>
		,NULL																				[LTST_DEL_CUTOFF_DT] -- Ony FOR EM --<Request><Header><Status><StatusType type=""LatestDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																				[LTST_DEL_CUTOFF_DTM]-- Ony FOR EM--<Request><Header><Status><StatusType type=""LatestDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																				[MANIFEST_DT]
		,NULL																				[MANUF_PLNT_PRTY_ID]
		,NULL																				[MBOL_ACTN_DT]--Not Send--<Request><Header><FileStatus><Code>"MbolActionDate"</Code></FileStatus></Header></Request>
		,HOU.MAWB_HIO																		[MBOL_MAWB_NBR]--If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""MasterBillofLadingNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,NULL																				[MBOL_RCV_DT]
		,NULL																				[MBOL_RCV_DTM]
		,(CASE WHEN LLP.Tipo_Lio = 'T' then 'T' ELSE 'R' END)								[MOT_CD]--" Request><Header><Transportation MethodofTransportation= ""V""></Transportation></Header></Request>
		,(CASE WHEN HOU.cd_tp_oper='DDP' or HOU.cd_tp_oper='DDU' THEN 'DD' ELSE		
			(CASE WHEN HOU.cd_tp_oper ='FOB' or HOU.cd_tp_oper='FCA' THEN 'PP' ELSE
			'DP' END) END)	 																[MOVE_TYP_CD]

		,(CASE WHEN HOU.cd_tp_oper='DDP' or HOU.cd_tp_oper='DDU' THEN 'DOOR TO DOOR' ELSE		
			(CASE WHEN HOU.cd_tp_oper ='FOB' or HOU.cd_tp_oper='FCA' THEN  'PORT TO PORT H/H (DUP)' else
			'DOOR TO PORT (DUP)' END) END)													[MOVE_TYP_DESC]--Request><Header><Transportation><TypeofMoveCode Type="DP"></TypeofMoveCode></Transportation></Header></Request>---<Request><Header><Transportation><TypeofMoveDescription></TypeofMoveDescription></Transportation></Header></Request>

		,HOU.HAWB_HIO																		[MSTR_BKNG_NBR]-- If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""BookingNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"		
		,NULL																				[MSTR_CARR_NM]
		,NULL																				[MSTR_CARR_SCAC_CD]		
		,HOU.Peso_Real_HIO																	[NET_TRANS_KILO_QTY]--<Request><Footer><Measurements item="NetWtKgs"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>-<Request><Footer><Measurements item="NetWeightKilograms"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,HOU.Peso_Real_HIO * 2.2046															[NET_TRANS_POUND_QTY]--<Request><Footer><Measurements item="NetWeightPounds"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,NULL																				[NF_COMPLIMENTARY_DT]
		,FORMAT( TP67.Dt_Conclusao , 'dd/MM/yy')											[NF_DRFT_DT]
		,NULL																				[NTFY_PRTY_ID]
		,NULL																				[ONBRD_CONFRM_DT]--If Request/Header/Transportation LegType=""Primary"" or ""First"" 	and If Request/Header/Transportation MethodofTransportation  is ""Ocean"" or ""V"" or ""Barge"" or ""B"" or ""C"" Request><Header><Transportation><OriginDate Type=""Actual""></OriginDate></Transportation></Header></Request>"
		,NULL																				[ONBRD_CONFRM_DTM]
		,NULL																				[OPEN_GATE_DT]
		,(CASE WHEN CP32.Campo_DADOS = '2' THEN 'FFD' ELSE 'CHB' END)						[OPRTG_UNT_CL_CD]--<Request><Header><References type=""OperatingUnitClassification""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,left([dbo].[fDW_ORDR_TYP_CD](HOU.Num_Proc_HIO),1)									[ORDR_TYP_CD]--<Request><Header><References type="OrderType"><ReferenceNumber></ReferenceNumber></References></Header></Request>		--<Request><Header><Transportation><ReferenceType type="OrderType"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,FORMAT(LLP.ATD_Lio, 'dd/MM/yy')													[ORGN_CITY_ACT_DT]--<Request><Header><Amounts><AmountType>ActCityOfOriginDate</AmountType></Amounts></Header></Request>
		,UPPER(ORG.cd_pais)																	[ORGN_CNTRY_CD]--"If Request/Header/Transportation LegType=""Primary"" or ""First"" <Request><Header><Transportation><OriginCountryCode></OriginCountryCode></Transportation></Header></Request>"
		,UPPER(ORGPais.Nome_Pais)															[ORGN_CNTRY_NM]
		,UPPER(ORG.Cd_Pais)																	[ORGN_CNTRY_UNLOC_CD]
		,FORMAT( TP5.Dt_Conclusao , 'dd/MM/yy')												[ORGN_INL_BOOK_ACT_DT]
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')											[ORGN_INL_DEL_ACT_DT]--<Request><Header><Status><StatusType type="ActDomesticInlandDeliveryDate"></StatusType></Status></Header></Request>
		,FORMAT( TP10.Dt_Conclusao , 'dd/MM/yy')											[ORGN_INL_DEL_ACT_DTM]
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')												[ORGN_INL_DEL_EST_DT]--<Request><Header><Status><StatusType type="EstDomesticInlandDeliveryDate"></StatusType></Status></Header></Request>
		,FORMAT( TP10.Dt_Previsao , 'dd/MM/yy')												[ORGN_INL_DEL_EST_DTM]
		,NULL																				[ORGN_INL_LOCTN_NM]
		,NULL																				[ORGN_INL_LOCTN_UNLOC_CD]
		,NULL																				[ORGN_INL_PCKP_ACT_DT]--10	EA,10	EM,10	EO - "If the file is not for Meridian If <Request><Header><Status><StatusType type=""ActGoodsAvailableForShippingDate""></StatusType><StatusDate></StatusDate> = """" then<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,NULL																				[ORGN_INL_PCKP_ACT_DTM]
		,FORMAT(TP10.Dt_Previsao , 'dd/MM/yy')												[ORGN_INL_PCKP_EST_DT]--<Request><Header><Status><StatusType type=""RequestedPlantShipDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,FORMAT(TP10.Dt_Previsao , 'dd/MM/yy')												[ORGN_INL_PCKP_EST_DTM]
		,NULL																				[ORGN_PORT_NM]--if Request/Header/Transportation MethodofTransportation  is not Air and <Request><Header><Transportation><ReferenceType type=""OriginPort""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
		,NULL																				[ORGN_PORT_UNLOC_CD]--If Request/Header/Transportation LegType=""Primary"" or ""First"" then If Request/Header/Transportation/OriginCodeType/type = ""IATA"" or ""IATACode"" then		--<Request><Header><Transportation><OriginCodeType><OriginCode></OriginCode></OriginCodeType></Transportation></Header></Request>"
		,FORMAT( TP13.Dt_Conclusao , 'dd/MM/yy')											[PLACE_OF_DEL_ACT_DT]----<Request><Header><Status><StatusType type=""ActPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"--<Request><Header><Status><StatusType type=""ActualPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( TP13.Dt_Conclusao , 'dd/MM/yy')											[PLACE_OF_DEL_ACT_DTM]
		,FORMAT( TP13.Dt_Previsao , 'dd/MM/yy')												[PLACE_OF_DEL_EST_DT]--"<Request><Header><Status><StatusType type=""EstimatedPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"--<Request><Header><Status><StatusType type=""EstPlaceofDeliveryDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( TP13.Dt_Previsao , 'dd/MM/yy')												[PLACE_OF_DEL_EST_DTM]
		,UPPER(DSTFNL.Nome_Local)															[PLACE_OF_DEL_NM]----"Request><Header><References type=""PlaceofDelivery Name""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="PlaceofDelivery Name"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,(CASE WHEN DSTFNL.SCAC is null THEN DSTFNL.Cd_Pais+DSTFNL.Cd_Local
			ELSE DSTFNL.Cd_Pais + DSTFNL.SCAC END)											[PLACE_OF_DEL_UNLOC_CD]
		,NULL																				[PLACE_OF_RCPT_ACT_DT]--"<Request><Header><Status><StatusType type=""ActPlaceofReceiptDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																				[PLACE_OF_RCPT_EST_DT]--"<Request><Header><Status><StatusType type=""EstPlaceofReceiptDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,NULL																				[PLACE_OF_RCPT_EST_DTM]
		,UPPER(ORGPLNT.Nome_Local)															[PLACE_OF_RCPT_NM]--"<Request><Header><References type=""PlaceofReceipt Name""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="PlaceofReceipt Name"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,(CASE WHEN ORGPLNT.SCAC is null THEN ORGPLNT.Cd_Pais+ORGPLNT.Cd_Local
			ELSE ORGPLNT.Cd_Pais + ORGPLNT.SCAC END)										[PLACE_OF_RCPT_UNLOC_CD]
		,FORMAT(LLP.ATA_Lio , 'dd/MM/yy')													[PORT_OF_ARRVL_ACT_DT]
		,FORMAT(LLP.ETA_Lio , 'dd/MM/yy')													[PORT_OF_ARRVL_EST_DT]
		,UPPER(DST.Nome_Local)																[PORT_OF_ARRVL_NM]
		,(CASE WHEN DST.SCAC is null THEN DST.Cd_Pais+DST.Cd_Local
			ELSE DST.Cd_Pais + DST.SCAC END)												[PORT_OF_ARRVL_UNLOC_CD]
		,FORMAT(LLP.ATD_Lio	, 'dd/MM/yy')													[PORT_OF_DEPTR_ACT_DT]
		,FORMAT(LLP.ETD_Lio	, 'dd/MM/yy')													[PORT_OF_DEPTR_EST_DT]
		,UPPER(ORG.Nome_Local)																[PORT_OF_DEPTR_NM]
		,(CASE WHEN ORG.SCAC is null THEN ORG.Cd_Pais+ORG.Cd_Local
			ELSE ORG.Cd_Pais + ORG.SCAC END)												[PORT_OF_DEPTR_UNLOC_CD]
		,FORMAT(TP15.Dt_Conclusao, 'dd/MM/yy')												[PORT_OF_ENTRY_ACT_DT]
		,FORMAT( LLP.ETA_LIO, 'dd/MM/yy')													[PORT_OF_ENTRY_EST_DT]
		,UPPER(DST.Nome_Local)																[PORT_OF_ENTRY_NM]
		,(CASE WHEN DST.SCAC is null THEN DST.Cd_Pais+DST.Cd_Local
			ELSE DST.Cd_Pais + DST.SCAC END)												[PORT_OF_ENTRY_UNLOC_CD]		
		,FORMAT( LLP.ATD_LIO, 'dd/MM/yy')													[PORT_OF_EXIT_ACT_DT]--<Request><Header><Status><StatusType type="ActPortOfExitDate"></StatusType></Status></Header></Request>
		,NULL																				[PORT_OF_EXIT_EST_DT]--"<Request><Header><Status><StatusType type=""EstPortOfExitDate""></StatusType><StatusTime></StatusTime></Status></Header></Request>"
		,NULL																				[PORT_OF_EXIT_UNLOC_CD]
		,FORMAT( TP1.Dt_Conclusao, 'dd/MM/yy')												[PRESHPMNT_ADVC_DT]--"<Request><Header><Status><StatusType type=""PreShipmentAdviceDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"			
		,(CASE WHEN [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIO) > 0 
			THEN 
				(Case when [dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIO) < isnull(HOU.vlr_frete_efet_hio,0) 
					THEN 
						[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIO)
					ELSE
						[dbo].[fDW_REPRT_VAL_AMT](HOU.Num_Proc_HIO) - isnull(HOU.vlr_frete_efet_hio,0)
				END)
			ELSE 
				LLP.Vlr_Invoice - isnull(HOU.vlr_frete_efet_hio,0) END)						[REPRT_VAL_AMT]--<Request><Footer><Measurements item="ReportableValueAmount"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>--<Request><Footer><Measurements item="TotalFAS"> <MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		
		,FORMAT( LLP.ETA_Lio, 'dd/MM/yy')													[RQST_ETA_DEST_DT]--"<Request><Header><Status><StatusType type=""RequestedETADestDate""></StatusType>           <StatusTime></StatusTime></Status></Header></Request>"
		,Sales.Nome_Usuario																	[SALES_PERSON_NM]--spINTSmartVendedor_Sel <Request><Header><CodesNames><CodesNamesName></CodesNamesName></CodesNames></Header></Request>
		,isnull(PO8.Numero_PO_HIO,HOU.HAWB_HIO)												[SAP_SHPMNT_NBR]--"<Request><Header><References type=""SAPShipmentNumber""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--<Request><Header><Transportation><ReferenceType type="SAPShipmentNumber"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,NULL																				[SBU]--Request><Header><Transportation><ReferenceType type="SBU"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>--"<Request><Header><References type=""SBU""><ReferenceNumber></ReferenceNumber></References></Header></Request>"
		,NULL																				[SBU_DESC]--"<Request><Header><References type=""SBUDescription""><ReferenceNumber></ReferenceNumber></References></Header></Request>"--Request><Header><Transportation><ReferenceType type="SBUDescription"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,FORMAT([dbo].[fDW_SDA_PAYMENT_DT]('SDA'), 'dd/MM/yy')								[SDA_PAYMENT_DT]--[spINTSmartPagamentos_Sel]'EMATL202407001BR','SDA'
		,UPPER(cast(LLP.ID_Status as varchar(2)) + '-' + TSP.Status_Descricao_Ingles)		[SHIPMENT_STATUS]
		,NULL																				[SHP_TO_PRTY_ID]
		,NULL																				[SLD_TO_PRTY_ID]
		,NULL																				[SLLR_PRTY_ID]
		,[dbo].[fBusca_TEUS](HOU.NUm_PROC_HIO)												[TEU_QTY]--<Request><Header><Amounts><AmountType>NumberOfTEUs</AmountType></Amounts></Header></Request>
		,HOU.Vol_Tot_HIO																	[TOT_CUBIC_FT_QTY]--<Request><Footer><Measurements><MeasurementValue></MeasurementValue></Measurements></Footer></Request>
		,UPPER(TER.Nome_Terminal)															[TRMNL_PIER_NM]
		,isnull(HOU.vlr_frete_efet_hio,0)													[TTL_FRGHT_BOL_AWB_PRPD_AMT]--<Request><Header><Transportation><ReferenceType type="FreightAmount"><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>
		,NULL																				[VOYG_FLGHT_NBR]--"If Request/Header/Transportation MethodofTransportation  is not Air and Request><Header><Transportation><ReferenceType type=""VoyageNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"--"If Request/Header/Transportation LegType=""Primary"" or ""First"" Request><Header><Transportation><ReferenceType type=""FlightNumber""><ReferenceNumber></ReferenceNumber></ReferenceType></Transportation></Header></Request>"
		,NULL																				[SOLAS_VRFDGRSSMASSCUTOFF_DT]-- only EM"<Request><Header><Status><StatusType type=""SolasVrfdGrMassCutDt""></StatusType>StatusTime></StatusTime></Status></Header></Request>"
		,NULL																				[SOLAS_VRFDGRSSMASSCUTOFF_DTM]--<Request><Header><Status><StatusType type="SolasVrfdGrMassCutDt"></StatusType></Status></Header></Request>
		,NULL																				[LC_ISSUING_NBR]--"If Request/Header/LetterofCredit/BankParties type = ""IssuingBank"" then <Request><Header><LetterofCredit><BankParties><BankPartyName></BankPartyName></BankParties></LetterofCredit></Header></Request>"
		,FORMAT([dbo].fDW_ORDR_CRTN_DT(HOU.NUm_PROC_HIO), 'dd/MM/yy')						[ORDR_CRTN_DT]--spINTDtPedido '" & ProcessoDT.Rows(0)("processo").ToString() & "'--"<Request><Header><Status><StatusType type=""OrderReceiveDate""></StatusType><StatusDate></StatusDate></Status></Header></Request>"
		,FORMAT( PO13.Data_PO_HIO, 'dd/MM/yy')												[CERT_OF_ORGN_APPLIED_DT]--<Request><Header><Status><StatusType type="CertOriginApplied"></StatusType></Status></Header></Request>
	FROM DBO.HOUSE_IMP_OUT		HOU		WITH (NOLOCK) 
	JOIN LLP_IMP_OUT			LLP		WITH (NOLOCK)	ON LLP.NUM_PROC_LIO		=	HOU.NUM_PROC_HIO
	LEFT JOIN PESSOA			Exporter WITH (NOLOCK)	ON Exporter.CD_PES		=	HOU.Cd_Export_HIO
	LEFT JOIN PESSOA			Consignee WITH (NOLOCK)	ON Consignee.CD_PES		=	HOU.Cd_Consig_HIO	
	LEFT JOIN PESSOA			Notify	WITH (NOLOCK)	ON Notify.CD_PES		=	HOU.Cd_Import_HIO	
	LEFT JOIN PESSOA_LLP		PLLP	WITH (NOLOCK)	ON HOU.Cd_Consig_HIO	=	PLLP.CD_PES
	LEFT JOIN GRUPO				GRP		WITH (NOLOCK)	ON GRP.CD_PES_GRUPO		=   PLLP.CD_PES_GRUPO
	LEFT JOIN TAREFAS_PROCESSOS TP40	WITH (NOLOCK)	ON TP40.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP40.ID_TASK =	40
	LEFT JOIN TAREFAS_PROCESSOS TP217	WITH (NOLOCK)	ON TP217.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP217.ID_TASK = 217
	LEFT JOIN TAREFAS_PROCESSOS TP83	WITH (NOLOCK)	ON TP83.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP83.ID_TASK = 83
	LEFT JOIN TAREFAS_PROCESSOS TP66	WITH (NOLOCK)	ON TP66.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP66.ID_TASK = 66
	LEFT JOIN TAREFAS_PROCESSOS TP45	WITH (NOLOCK)	ON TP45.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP45.ID_TASK = 45
	LEFT JOIN TAREFAS_PROCESSOS TP4		WITH (NOLOCK)	ON TP4.NUM_PROC			=	HOU.NUM_PROC_HIO AND TP4.ID_TASK = 4
	LEFT JOIN TAREFAS_PROCESSOS TP13	WITH (NOLOCK)	ON TP13.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP13.ID_TASK = 13
	LEFT JOIN TAREFAS_PROCESSOS TP7		WITH (NOLOCK)	ON TP7.NUM_PROC			=	HOU.NUM_PROC_HIO AND TP7.ID_TASK = 7
	LEFT JOIN TAREFAS_PROCESSOS TP109	WITH (NOLOCK)	ON TP109.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP109.ID_TASK = 109
	LEFT JOIN TAREFAS_PROCESSOS TP10	WITH (NOLOCK)	ON TP10.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP10.ID_TASK = 10
	LEFT JOIN TAREFAS_PROCESSOS TP1		WITH (NOLOCK)	ON TP1.NUM_PROC			=	HOU.NUM_PROC_HIO AND TP1.ID_TASK = 1
	LEFT JOIN TAREFAS_PROCESSOS TP5		WITH (NOLOCK)	ON TP5.NUM_PROC			=	HOU.NUM_PROC_HIO AND TP5.ID_TASK = 5
	LEFT JOIN TAREFAS_PROCESSOS TP58	WITH (NOLOCK)	ON TP58.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP58.ID_TASK = 58
	LEFT JOIN TAREFAS_PROCESSOS TP21	WITH (NOLOCK)	ON TP21.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP21.ID_TASK = 21
	LEFT JOIN TAREFAS_PROCESSOS TP59	WITH (NOLOCK)	ON TP59.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP59.ID_TASK = 59
	LEFT JOIN TAREFAS_PROCESSOS TP15	WITH (NOLOCK)	ON TP15.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP15.ID_TASK = 15
	LEFT JOIN TAREFAS_PROCESSOS TP63	WITH (NOLOCK)	ON TP63.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP63.ID_TASK = 63
	LEFT JOIN TAREFAS_PROCESSOS TP27	WITH (NOLOCK)	ON TP27.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP27.ID_TASK = 27
	LEFT JOIN TAREFAS_PROCESSOS TP67	WITH (NOLOCK)	ON TP67.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP67.ID_TASK = 67
	LEFT JOIN TAREFAS_PROCESSOS TP41		WITH (NOLOCK) ON TP41.NUM_PROC		=	HOU.NUM_PROC_HIO AND TP41.ID_TASK = 41

	LEFT JOIN NATURE_GOODS		NG		WITH (NOLOCK)	ON NG.NUM_PROC			=	HOU.NUM_PROC_HIO
	Left Join Pessoa			ARM		WITH (NOLOCK)	ON ARM.Cd_Pes			=	LLP.Cd_Carrier
	Left Join Pessoa_LLP		SCAC	WITH (NOLOCK)	ON SCAC.Cd_Pes			=	LLP.Cd_Carrier
	LEFT JOIN PO_HIO			PO5		WITH (NOLOCK)	ON PO5.Num_Proc_HIO		=	HOU.NUM_PROC_HIO AND PO5.ID_DC = 5
	LEFT JOIN PO_HIO			PO71	WITH (NOLOCK)	ON PO71.Num_Proc_HIO	=	HOU.NUM_PROC_HIO AND PO71.ID_DC = 71
	LEFT JOIN PO_HIO			PO8		WITH (NOLOCK)	ON PO8.Num_Proc_HIO		=	HOU.NUM_PROC_HIO AND PO8.ID_DC = 8
	LEFT JOIN PO_HIO			PO13	WITH (NOLOCK)	ON PO13.Num_Proc_HIO	=	HOU.NUM_PROC_HIO AND PO13.ID_DC = 13
	--LEFT JOIN PO_HIO			PO2		WITH (NOLOCK)	ON PO2.Num_Proc_HIO		=	HOU.NUM_PROC_HIO AND PO2.ID_DC = 2
	LEFT JOIN Localidade		DST		WITH (NOLOCK)	ON DST.Cd_Local			=	HOU.Cd_Dst_HIO
	LEFT JOIN Localidade		ORG		WITH (NOLOCK)	ON ORG.Cd_Local			=	HOU.Cd_Org_HIO
	LEFT JOIN Pais				DSTPais	WITH (NOLOCK)	ON DSTPais.cd_pais		=	DST.cd_pais
	LEFT JOIN Pais				ORGPais	WITH (NOLOCK)	ON ORGPais.cd_pais		=	ORG.cd_pais
	LEFT JOIN Localidade		DSTFNL  WITH (NOLOCK)	ON DSTFNL.Cd_Local		=	LLP.Cd_DstFinal_Lio
	LEFT JOIN Localidade		ORGPLNT	WITH (NOLOCK)	ON ORGPLNT.Cd_Local		=	LLP.Cd_Planta_Lio
	LEFT JOIN Usuario			US		WITH (NOLOCK)	ON US.cd_usuario		=	LLP.Cd_Usuario
	LEFT JOIN Campo_Processo	CP32	WITH (NOLOCK)	ON CP32.NUM_PROC		=	HOU.NUM_PROC_HIO AND CP32.ID_Campo = 32
	LEFT JOIN Campo_Processo	CP5		WITH (NOLOCK)	ON CP5.NUM_PROC			=	HOU.NUM_PROC_HIO AND CP5.ID_Campo = 5
	LEFT JOIN Usuario			Sales	WITH (NOLOCK)	ON Sales.cd_usuario		=	LLP.cd_Vendedor
	LEFT JOIN Tipo_Status_Processo TSP	WITH (NOLOCK)	ON LLP.id_status		=	TSP.id_status
	LEFT JOIN Terminal			TER			WITH (NOLOCK) ON TER.cd_terminal	=	LLP.cd_terminal
	Where
		HOU.Num_Proc_HIO = 'IOCSR202408004BR' 
		--AND
		--convert(datetime,HOU.Dt_emis_hio,105) > getdate() -31
	




GO
