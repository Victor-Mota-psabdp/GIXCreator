SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATLReportSchneiderItineraryID_Rel '2020-01-01','2021-01-01'
CREATE Procedure spATLReportSchneiderItineraryID_Rel  

 @DtInicial datetime,  
 @DtFinal datetime  
  
  AS  


select
'Import'														AS [Type]
,HOU.Num_Proc_HIM												AS [Job Number]
,HOU.MAWB_HIM													AS [MAWB]
,HOU.HAWB_HIM													AS [Housebill / Shipment]
,Num_Cont_IM													AS [Container]
,Cd_Org_HiM + ' - ' + ORI.Nome_Local							AS [Origin]
,Cd_Dst_HiM + ' - ' + DEST.Nome_LocaL							AS [Destination]
,ETA_Lim  as ETA
,ETD_Lim  AS ETD
,ATA_Lim  AS ATA
,ATD_Lim  AS ATD
,ISNULL(ISNULL(CONTHAI.Itinerary_ID,CP202.Campo_Dados),'')		AS [Itinerary ID]
,ISNULL(CONTHAI.Itinerary_ID,'')								AS [Itinerary ID - Container]
,ISNULL(CP202.Campo_Dados,'')									AS [Itinerary ID - Add Fields]

FROM House_Imp_Mar HOU (nolock)
INNER JOIN LLP_imp_Mar LLP (nolock)  
	ON HOU.Num_Proc_HiM = LLP.Num_Proc_Lim  
INNER JOIN Localidade ORI (nolock)  
	ON HOU.Cd_Org_HiM  = ORI.Cd_Local  
INNER JOIN Localidade DEST (nolock)    
	ON HOU.Cd_Dst_HiM  = DEST.Cd_Local  

LEFT JOIN Container_Hou_Imp_Mar CONTH (nolock) 
	ON HOU.Num_Proc_HIM = CONTH.num_proc_him

LEFT JOIN container_mas_imp_mar CONTM (nolock) 
	ON CONTH.item_cont_im = CONTM.item_cont_im AND CONTH.Num_Proc_MIM = CONTM.Num_Proc_MIM

LEFT JOIN container_additional_info CONTHAI (NOLOCK)
	ON CONTH.num_proc_him = CONTHAI.NUM_PROC
	AND REPLACE(CONTM.Num_Cont_IM ,'-','') = REPLACE(CONTHAI.num_cont,'-','')
-- Itinerary ID
LEFT JOIN Campo_Processo CP202 (nolock)  
	ON HOU.Num_Proc_HIM collate SQL_Latin1_General_CP1_CI_AS = CP202.Num_Proc collate SQL_Latin1_General_CP1_CI_AS  AND CP202.Id_Campo = 202 
WHERE DBO.FBusca_GrupoporJOB(HOU.Num_Proc_HIM) = 'GRUPO SCHNEIDER'
and eta_lim between @DtInicial and @DtFinal 

UNION

select
'Export'														AS [Type]
,HOU.Num_Proc_HeM												AS [Job Number]
,HOU.MAWB_HEM													AS [MAWB]
,HOU.HAWB_HEM													AS [Housebill / Shipment]
,Num_Cont_EM													AS [Container]
,Cd_Org_HEM + ' - ' + ORI.Nome_Local							AS [Origin]
,Cd_Dst_HEM + ' - ' + DEST.Nome_LocaL							AS [Destination]
,ETA_Lem  as ETA
,ETD_Lem  AS ETD
,ATA_Lem  AS ATA
,ATD_Lem  AS ATD

,ISNULL(ISNULL(CONTHAI.Itinerary_ID,CP202.Campo_Dados),'')		AS [Itinerary ID]
,ISNULL(CONTHAI.Itinerary_ID,'')								AS [Itinerary ID - Container]
,ISNULL(CP202.Campo_Dados,'')									AS [Itinerary ID - Add Fields]
FROM House_EXP_Mar HOU (nolock)
INNER JOIN LLP_EXP_Mar LLP (nolock)  
	ON HOU.Num_Proc_HEM = LLP.Num_Proc_LEm  
INNER JOIN Localidade ORI (nolock)  
	ON HOU.Cd_Org_HEM  = ORI.Cd_Local  
INNER JOIN Localidade DEST (nolock)    
	ON HOU.Cd_Dst_HEM  = DEST.Cd_Local  
LEFT JOIN Container_Hou_Exp_Mar CONTH (nolock) 
	ON HOU.Num_Proc_HEM = CONTH.num_proc_hEm
LEFT JOIN container_mas_exp_mar CONTM (nolock) 
	ON CONTH.item_cont_em = CONTM.item_cont_em AND CONTH.Num_Proc_MeM = CONTM.Num_Proc_MeM
LEFT JOIN container_additional_info CONTHAI (NOLOCK)
	ON CONTH.num_proc_hem = CONTHAI.NUM_PROC
	AND REPLACE(CONTM.Num_Cont_eM ,'-','') = REPLACE(CONTHAI.num_cont,'-','')
-- Itinerary ID
LEFT JOIN Campo_Processo CP202 (nolock)  
	ON HOU.Num_Proc_HEM collate SQL_Latin1_General_CP1_CI_AS = CP202.Num_Proc collate SQL_Latin1_General_CP1_CI_AS  AND CP202.Id_Campo = 202 
WHERE DBO.FBusca_GrupoporJOB(HOU.Num_Proc_HEM) = 'GRUPO SCHNEIDER'
and eta_lem between @DtInicial and @DtFinal 
GO
