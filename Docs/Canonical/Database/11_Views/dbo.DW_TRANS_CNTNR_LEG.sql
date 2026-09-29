SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[DW_TRANS_CNTNR_LEG]

AS

select
	Null																			[SNP_ID]
	,CH.Num_Proc_HIM																[FRWDR_REF_NBR]
	,'01BDPBRSAO' 																	[BDP_SS_ID]
	,ROW_NUMBER() OVER(PARTITION BY CH.Num_Proc_HIM ORDER BY CH.Num_Proc_HIM ASC)	[TRANS_CNTNR_LEG_ID]
	,ROW_NUMBER() OVER(PARTITION BY CH.Num_Proc_HIM ORDER BY CH.Num_Proc_HIM ASC)	[TRANS_CNTNR_SEQ_ID]
	,REPLACE(UPPER(CM.Num_Cont_IM),'-','')											[CNTNR_NBR]
	,FORMAT(TP38.Dt_Conclusao , 'dd/MM/yy')											[ARRT_DT]   --"<Request><Header><Equipment><Legs><InterimPointActArrivalDate></InterimPointActArrivalDate></Legs></Equipment></Header></Request>"
	,FORMAT(TP38.Dt_Conclusao , 'dd/MM/yy')											[ARRT_DTM]  
	,NULL																			[ARRVL_INTRM_PNT_ACT_TM] --Not Send <Request><Header><Equipment><Legs><InterimPointActArrivalTime></InterimPointActArrivalTime></Legs></Equipment></Header></Request>"
	,NULL																			[ARRVL_INTRM_PNT_EST_TM] --Not Send <Request><Header><Equipment><Legs><InterimPointEstArrivalTime></InterimPointEstArrivalTime></Legs></Equipment></Header></Request>"
	,null /*cp44.Campo_Dados	id_campo=44, Nome_Local*/							[ARRVL_INTRM_PNT_LOCTN_NM] --"<Request><Header><Equipment><Legs><InterimPointArrvLocation></InterimPointArrvLocation></Legs></Equipment></Header></Request>"
	,NULL /* id_campo=44, cd_pais + Isnull(SCAC,cd_local) */						[ARRVL_INTRM_PNT_UNLOC_CD] --"<Request><Header><Equipment><Legs><InterimPointArrvUNLOCCode></InterimPointArrvUNLOCCode></Legs></Equipment></Header></Request>"
	,NULL																			[BOL_AWB_NUM] --Not Send "<Request><Header><Equipment><Legs><InterimPointBolAwbNumber></InterimPointBolAwbNumber></Legs></Equipment></Header></Request>"
	,NULL																			[DEPTR_INTRM_MOT_CD] --Not Send "<Request><Header><Equipment><Legs><InterimPointDeptMOT></InterimPointDeptMOT></Legs></Equipment></Header></Request>"
	,FORMAT(TP37.Dt_Conclusao , 'dd/MM/yy')											[DEPTR_INTRM_PNT_ACT_DT]-- "<Request><Header><Equipment><Legs><InterimPointActDepartureDate></InterimPointActDepartureDate></Legs></Equipment></Header></Request>"
	,FORMAT(TP37.Dt_Previsao , 'dd/MM/yy')											[DEPTR_INTRM_PNT_ACT_DTM]
	,NULL																			[DEPTR_INTRM_PNT_ACT_TM] -- Not Send "<Request><Header><Equipment><Legs><InterimPointActDepartureTime></InterimPointActDepartureTime></Legs></Equipment></Header></Request>"
	,NULL																			[DEPTR_INTRM_PNT_CARR_NM] -- Not Send "<Request><Header><Equipment><Legs><InterimPointDeptCarrierName></InterimPointDeptCarrierName></Legs></Equipment></Header></Request>"
	,NULL																			[DEPTR_INTRM_PNT_CARR_SCAC_CD] -- Not Send "<Request><Header><Equipment><Legs><InterimPointDeptCarrierSCAC></InterimPointDeptCarrierSCAC></Legs></Equipment></Header></Request>"
	,FORMAT(TP37.Dt_Previsao , 'dd/MM/yy')											[DEPTR_INTRM_PNT_EST_DT] -- "<Request><Header><Equipment><Legs><InterimPointEstDepartureDate></InterimPointEstDepartureDate></Legs></Equipment></Header></Request>"
	,FORMAT(TP37.Dt_Previsao , 'dd/MM/yy')											[DEPTR_INTRM_PNT_EST_DTM]
	,NULL																			[DEPTR_INTRM_PNT_EST_TM] -- "<Request><Header><Equipment><Legs><InterimPointEstDepartureTime></InterimPointEstDepartureTime></Legs></Equipment></Header></Request>"
	,NULL /*id_campo=44, Nome_Local*/												[DEPTR_INTRM_PNT_LOCTN_NM] -- "<Request><Header><Equipment><Legs><InterimPointDeptLocation></InterimPointDeptLocation></Legs></Equipment></Header></Request>"
	,NULL /*id_campo=44, cd_pais + Isnull(SCAC,cd_local)*/							[DEPTR_INTRM_PNT_UNLOC_CD] -- "<Request><Header><Equipment><Legs><InterimPointDeptUNLOCCode></InterimPointDeptUNLOCCode></Legs></Equipment></Header></Request>"
	,NULL																			[DEPTR_INTRM_PNT_VOYG_FLGHT_NBR] -- "<Request><Header><Equipment><Legs><InterimPointDeptVesFlghtNumber></InterimPointDeptVesFlghtNumber></Legs></Equipment></Header></Request>"
	,NULL																			[DEPTR_INTRM_PNT_VSSL_CD]
	,NULL																			[DEPTR_INTRM_PNT_VSSL_NM] -- "<Request><Header><Equipment><Legs><InterimPointDeptVesselName></InterimPointDeptVesselName></Legs></Equipment></Header></Request>"
	,FORMAT(TP38.Dt_Previsao , 'dd/MM/yy')											[ERRT_DT] -- "<Request><Header><Equipment><Legs><InterimPointEstArrivalDate></InterimPointEstArrivalDate></Legs></Equipment></Header></Request>"
	,FORMAT(TP38.Dt_Previsao , 'dd/MM/yy')											[ERRT_DTM]

FROM dbo.CONTAINER_MAS_IMP_MAR CM WITH(NOLOCK)
JOIN dbo.TIPO_CONTAINER TC WITH(NOLOCK) ON TC.CD_TP_CONT=CM.CD_TP_CONT
JOIN dbo.CONTAINER_HOU_IMP_MAR CH WITH(NOLOCK) ON CH.NUM_PROC_MIM=CM.NUM_PROC_MIM AND CH.ITEM_CONT_IM=CM.ITEM_CONT_IM
JOIN dbo.HOUSE_IMP_MAR HOU WITH(NOLOCK) ON CH.NUM_PROC_HIM = HOU.NUM_PROC_HIM
left join Tarefas_Processos tp37 with(nolock) on CH.Num_Proc_him = tp37.Num_Proc and tp37.ID_Task = 37
left join Tarefas_Processos tp38 with(nolock) on CH.Num_Proc_him = tp38.Num_Proc and tp38.ID_Task = 38
where
	HOU.Num_Proc_HIM = 'IMATN202408025BR'
--convert(datetime,Hou.Dt_Emis_HIM,105) > getdate() -31
 
 
 union all


 select
	Null																			[SNP_ID]
	,CH.Num_Proc_HEM																[FRWDR_REF_NBR]
	,'01BDPBRSAO' 																	[BDP_SS_ID]
	,ROW_NUMBER() OVER(PARTITION BY CH.Num_Proc_HEM ORDER BY CH.Num_Proc_HEM ASC)	[TRANS_CNTNR_LEG_ID]
	,ROW_NUMBER() OVER(PARTITION BY CH.Num_Proc_HEM ORDER BY CH.Num_Proc_HEM ASC)	[TRANS_CNTNR_SEQ_ID]
	,REPLACE(UPPER(CM.Num_Cont_EM),'-','')											[CNTNR_NBR]
	,FORMAT(TP38.Dt_Conclusao , 'dd/MM/yy')											[ARRT_DT]   --"<Request><Header><Equipment><Legs><InterimPointActArrivalDate></InterimPointActArrivalDate></Legs></Equipment></Header></Request>"
	,FORMAT(TP38.Dt_Conclusao , 'dd/MM/yy')											[ARRT_DTM]   
	,NULL																			[ARRVL_INTRM_PNT_ACT_TM] --Not Send <Request><Header><Equipment><Legs><InterimPointActArrivalTime></InterimPointActArrivalTime></Legs></Equipment></Header></Request>"
	,NULL																			[ARRVL_INTRM_PNT_EST_TM] --Not Send <Request><Header><Equipment><Legs><InterimPointEstArrivalTime></InterimPointEstArrivalTime></Legs></Equipment></Header></Request>"
	,NULL /*cp44.Campo_Dados	id_campo=44, Nome_Local*/							[ARRVL_INTRM_PNT_LOCTN_NM] --"<Request><Header><Equipment><Legs><InterimPointArrvLocation></InterimPointArrvLocation></Legs></Equipment></Header></Request>"
	,NULL /* id_campo=44, cd_pais + Isnull(SCAC,cd_local) */						[ARRVL_INTRM_PNT_UNLOC_CD] --"<Request><Header><Equipment><Legs><InterimPointArrvUNLOCCode></InterimPointArrvUNLOCCode></Legs></Equipment></Header></Request>"
	,NULL																			[BOL_AWB_NUM] --Not Send "<Request><Header><Equipment><Legs><InterimPointBolAwbNumber></InterimPointBolAwbNumber></Legs></Equipment></Header></Request>"
	,NULL																			[DEPTR_INTRM_MOT_CD] --Not Send "<Request><Header><Equipment><Legs><InterimPointDeptMOT></InterimPointDeptMOT></Legs></Equipment></Header></Request>"
	,FORMAT(TP37.Dt_Conclusao , 'dd/MM/yy')											[DEPTR_INTRM_PNT_ACT_DT]-- "<Request><Header><Equipment><Legs><InterimPointActDepartureDate></InterimPointActDepartureDate></Legs></Equipment></Header></Request>"
	,FORMAT(TP37.Dt_Previsao , 'dd/MM/yy')											[DEPTR_INTRM_PNT_ACT_DTM]
	,NULL																			[DEPTR_INTRM_PNT_ACT_TM] -- Not Send "<Request><Header><Equipment><Legs><InterimPointActDepartureTime></InterimPointActDepartureTime></Legs></Equipment></Header></Request>"
	,NULL																			[DEPTR_INTRM_PNT_CARR_NM] -- Not Send "<Request><Header><Equipment><Legs><InterimPointDeptCarrierName></InterimPointDeptCarrierName></Legs></Equipment></Header></Request>"
	,NULL																			[DEPTR_INTRM_PNT_CARR_SCAC_CD] -- Not Send "<Request><Header><Equipment><Legs><InterimPointDeptCarrierSCAC></InterimPointDeptCarrierSCAC></Legs></Equipment></Header></Request>"
	,FORMAT(TP37.Dt_Previsao , 'dd/MM/yy')											[DEPTR_INTRM_PNT_EST_DT] -- "<Request><Header><Equipment><Legs><InterimPointEstDepartureDate></InterimPointEstDepartureDate></Legs></Equipment></Header></Request>"
	,FORMAT(TP37.Dt_Previsao , 'dd/MM/yy')											[DEPTR_INTRM_PNT_EST_DTM]
	,NULL																			[DEPTR_INTRM_PNT_EST_TM] -- "<Request><Header><Equipment><Legs><InterimPointEstDepartureTime></InterimPointEstDepartureTime></Legs></Equipment></Header></Request>"
	,NULL /*id_campo=44, Nome_Local*/												[DEPTR_INTRM_PNT_LOCTN_NM] -- "<Request><Header><Equipment><Legs><InterimPointDeptLocation></InterimPointDeptLocation></Legs></Equipment></Header></Request>"
	,NULL /*id_campo=44, cd_pais + Isnull(SCAC,cd_local)*/							[DEPTR_INTRM_PNT_UNLOC_CD] -- "<Request><Header><Equipment><Legs><InterimPointDeptUNLOCCode></InterimPointDeptUNLOCCode></Legs></Equipment></Header></Request>"
	,NULL																			[DEPTR_INTRM_PNT_VOYG_FLGHT_NBR] -- "<Request><Header><Equipment><Legs><InterimPointDeptVesFlghtNumber></InterimPointDeptVesFlghtNumber></Legs></Equipment></Header></Request>"
	,NULL																			[DEPTR_INTRM_PNT_VSSL_CD]
	,NULL																			[DEPTR_INTRM_PNT_VSSL_NM] -- "<Request><Header><Equipment><Legs><InterimPointDeptVesselName></InterimPointDeptVesselName></Legs></Equipment></Header></Request>"
	,FORMAT(TP38.Dt_Previsao , 'dd/MM/yy')											[ERRT_DT] -- "<Request><Header><Equipment><Legs><InterimPointEstArrivalDate></InterimPointEstArrivalDate></Legs></Equipment></Header></Request>"
	,FORMAT(TP38.Dt_Previsao , 'dd/MM/yy')											[ERRT_DTM]

FROM dbo.CONTAINER_MAS_EXP_MAR CM WITH(NOLOCK)
JOIN dbo.TIPO_CONTAINER TC WITH(NOLOCK) ON TC.CD_TP_CONT=CM.CD_TP_CONT
JOIN dbo.CONTAINER_HOU_EXP_MAR CH WITH(NOLOCK) ON CH.NUM_PROC_MEM=CM.NUM_PROC_MEM AND CH.ITEM_CONT_EM=CM.ITEM_CONT_EM
JOIN dbo.HOUSE_EXP_MAR HOU WITH(NOLOCK) ON CH.NUM_PROC_HEM = HOU.NUM_PROC_HEM
left join Tarefas_Processos tp37 with(nolock) on CH.Num_Proc_hem = tp37.Num_Proc and tp37.ID_Task = 37
left join Tarefas_Processos tp38 with(nolock) on CH.Num_Proc_hem = tp38.Num_Proc and tp38.ID_Task = 38
where
HOU.Num_Proc_HEM = 'EMLVS202408028BR'
--convert(datetime,Hou.Dt_Emis_Hem,105) > getdate() -31





GO
