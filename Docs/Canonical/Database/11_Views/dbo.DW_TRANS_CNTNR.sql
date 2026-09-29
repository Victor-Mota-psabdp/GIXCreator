SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--SELECT * from [dbo].[DW_TRANS_CNTNR]

CREATE VIEW [dbo].[DW_TRANS_CNTNR]
AS
	select
	CH.NUM_PROC_HEM														FRWDR_REF_NBR
	,HOU.Peso_Bruto_HEM													CNTNR_GROSS_KILO_QTY
	,NULL																CNTNR_GROSS_PND_QTY
	,[dbo].[fBusca_Volume_Mar](CH.NUM_PROC_HEM,CM.num_cont_em)			CNTNR_PCKG_CT --[spIntSmartVolumeCC_Sel] --spIntSmartVolumePLT_Sel
	,NULL																CNTNR_CFT_QTY
	,NULL																CNTNR_CBM_QTY
	,ISNULL(CAI.Itinerary_ID,CP202.Campo_Dados)				  			CNTNR_ITINERARY_ID
	,CONVERT(VARCHAR, TP10.Dt_Conclusao	, 112) 							CNTNR_LOAD_DT

	,LEFT(TC.cd_tp_cont,2)												CNTNR_SZ_CD --<EquipmentSummary><EquipmentSize></EquipmentSize></EquipmentSummary>
	
	--,(CASE 
	--	when 
	--		LEFT(TC.Nome_Tp_Cont,2)='20' or LEFT(TC.Nome_Tp_Cont,2) ='40' 
	--	then 
	--		LEFT(TC.Nome_Tp_Cont,2)	else null
	--END)																CNTNR_SZ_CD --<Equipment><EquipmentSize></EquipmentSize></Equipment>


	,NULL																CNTNR_EMPTY_DEL_DT
	,NULL																CNTNR_EQUIP_ID
	,(CASE 
		when 
			LEFT(TC.Nome_Tp_Cont,2)='20' or LEFT(TC.Nome_Tp_Cont,2) ='40' 
		then 
			TC.cd_smart	else NULL END)									CNTNR_TYP_CD
	,	(CASE WHEN 
		CM.Dt_Vcto_Devol_EM is null or  CM.Dt_Vcto_Devol_EM  = '' THEN NULL 
		ELSE 
		CONVERT(VARCHAR, convert(datetime,CM.Dt_Vcto_Devol_EM,105), 112)   
	END)																FREE_TIME_EXPIR_ACT_DT
	,NULL																FREE_TIME_EXPIR_EST_DT
	,CM.num_lacre_em													SEAL_1_NBR
	,CM.Lacre_02_EM														SEAL_2_NBR
	,CAI.Metodo_VGM														SOLAS_MTHD
	,CAI.Nome_Responsavel_VGM											SOLAS_RESPONSIBLE_PRTY
	,CONVERT(VARCHAR, CAI.Dt_Envio_VGM, 112)							SOLAS_VERFICATION_DT
	,NULL																SOLAS_VRD_GRSS_MASS_UOM
	,CAI.UOM_VGM														SOLAS_VRFD_GRSS_MASS
	,NULL																BDP_CNTNR_EQUIP_DESC
	,REPLACE(UPPER(CM.NUM_CONT_EM),'-','')								CNTNR_NBR
	,NULL																CNTNR_PLLT_SKID_CT
FROM dbo.CONTAINER_MAS_EXP_MAR CM WITH(NOLOCK)
JOIN dbo.TIPO_CONTAINER TC WITH(NOLOCK) ON TC.CD_TP_CONT=CM.CD_TP_CONT
JOIN dbo.CONTAINER_HOU_EXP_MAR CH WITH(NOLOCK) ON CH.NUM_PROC_MEM=CM.NUM_PROC_MEM AND CH.ITEM_CONT_EM=CM.ITEM_CONT_EM
JOIN dbo.HOUSE_EXP_MAR HOU WITH(NOLOCK) ON CH.NUM_PROC_HEM = HOU.NUM_PROC_HEM
LEFT JOIN dbo.CONTAINER_ADDITIONAL_INFO CAI WITH(NOLOCK) ON CH.NUM_PROC_HEM = CAI.NUM_PROC AND CAI.NUM_CONT = REPLACE(CM.NUM_CONT_EM,'-','') AND ATIVO = 1
LEFT JOIN dbo.Campo_Processo CP202 WITH(NOLOCK) ON CP202.ID_CAMPO=202 AND CP202.NUM_PROC=CH.NUM_PROC_HEM
LEFT JOIN dbo.Tarefas_Processos TP10 WITH(NOLOCK) ON TP10.id_task=10 AND TP10.NUM_PROC=CH.NUM_PROC_HEM


WHERE 
	--convert(datetime,HOU.Dt_Emis_HEM,105) > getdate() -120
	CH.NUM_PROC_HEM = 'EMOXT201612024BR' --'EMATL202208002BR' --'EMATL202406022BR' 

UNION

select 
	CH.NUM_PROC_HIM														FRWDR_REF_NBR
	,HOU.Peso_Bruto_HIM													CNTNR_GROSS_KILO_QTY
	,NULL																CNTNR_GROSS_PND_QTY
	,[dbo].[fBusca_Volume_Mar](CH.Num_Proc_HIM,CM.Num_Cont_IM)			CNTNR_PCKG_CT
	,NULL																CNTNR_CFT_QTY
	,NULL																CNTNR_CBM_QTY
	,ISNULL(CAI.Itinerary_ID,CP202.Campo_Dados)				  			CNTNR_ITINERARY_ID
	,CONVERT(VARCHAR,TP10.Dt_Conclusao, 112)							CNTNR_LOAD_DT

	,LEFT(TC.cd_tp_cont,2)												CNTNR_SZ_CD --<EquipmentSummary><EquipmentSize></EquipmentSize></EquipmentSummary>
	
	--,(CASE 
	--	when 
	--		LEFT(TC.Nome_Tp_Cont,2)='20' or LEFT(TC.Nome_Tp_Cont,2) ='40' 
	--	then 
	--		LEFT(TC.Nome_Tp_Cont,2)	else null END)						CNTNR_SZ_CD --<Equipment><EquipmentSize></EquipmentSize></Equipment>
	,
	(CASE WHEN 
		CM.Dt_Vcto_Devol_IM is null or  CM.Dt_Vcto_Devol_IM  = '' THEN NULL 
		ELSE 
		CONVERT(VARCHAR, convert(datetime,CM.Dt_Vcto_Devol_IM,105), 112)
	END)																CNTNR_EMPTY_DEL_DT
	
									
	,NULL																CNTNR_EQUIP_ID
	,(CASE 
		when 
			LEFT(TC.Nome_Tp_Cont,2)='20' or LEFT(TC.Nome_Tp_Cont,2) ='40' 
		then 
			TC.cd_smart	else NULL END)									CNTNR_TYP_CD
	,NULL																FREE_TIME_EXPIR_ACT_DT
	,(CASE WHEN 
		CM.Dt_Devol_IM is null or  CM.Dt_Devol_IM  = '' THEN NULL 
		ELSE 
		CONVERT(VARCHAR, convert(datetime,CM.Dt_Devol_IM,105), 112)
	END)																FREE_TIME_EXPIR_EST_DT
	,CM.Num_Lacre_IM													SEAL_1_NBR
	,CM.Lacre_02_IM														SEAL_2_NBR
	,CAI.Metodo_VGM														SOLAS_MTHD
	,CAI.Nome_Responsavel_VGM											SOLAS_RESPONSIBLE_PRTY
	,CONVERT(VARCHAR, CAI.Dt_Envio_VGM, 112)							SOLAS_VERFICATION_DT
	,NULL																SOLAS_VRD_GRSS_MASS_UOM
	,CAI.UOM_VGM														SOLAS_VRFD_GRSS_MASS
	,NULL																BDP_CNTNR_EQUIP_DESC
	,REPLACE(UPPER(CM.NUM_CONT_IM),'-','')								CNTNR_NBR
	,NULL																CNTNR_PLLT_SKID_CT

FROM dbo.CONTAINER_MAS_IMP_MAR CM WITH(NOLOCK)
JOIN dbo.TIPO_CONTAINER TC WITH(NOLOCK) ON TC.CD_TP_CONT=CM.CD_TP_CONT
JOIN dbo.CONTAINER_HOU_IMP_MAR CH WITH(NOLOCK) ON CH.NUM_PROC_MIM=CM.NUM_PROC_MIM AND CH.ITEM_CONT_IM=CM.ITEM_CONT_IM
JOIN dbo.HOUSE_IMP_MAR HOU WITH(NOLOCK) ON CH.NUM_PROC_HIM = HOU.NUM_PROC_HIM
LEFT JOIN dbo.CONTAINER_ADDITIONAL_INFO CAI WITH(NOLOCK) ON CH.NUM_PROC_HiM = CAI.NUM_PROC AND CAI.NUM_CONT = REPLACE(CM.NUM_CONT_IM,'-','') AND ATIVO = 1
LEFT JOIN dbo.Campo_Processo CP202 WITH(NOLOCK) ON CP202.ID_CAMPO=202 AND CH.Num_Proc_HIM = CP202.NUM_PROC
LEFT JOIN dbo.Tarefas_Processos TP10 WITH(NOLOCK) ON TP10.id_task=10 AND CH.Num_Proc_HIM = TP10.NUM_PROC
WHERE
	--convert(datetime,HOU.Dt_Emis_HIM,105) > getdate() -120
	CH.NUM_PROC_HIM = 'IMLVS202408015BR'

GO
