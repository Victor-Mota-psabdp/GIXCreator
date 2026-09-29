SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE Procedure [dbo].[spScriptSaida]
as

-- 16-06 Stored para gerar script de Saida
-- Anderson


SELECT  
	'M' Modal,right(left(Cd_Planta,5),2) Planta,right(Numero_PO_HeM,8) Numero_PO_HeM,Original_ETa_LEM,
	TP.Dt_previsao Desp_P,SDP.Dt_Conclusao Saida_Planta, ETD_LEM,ATD_LEM,
	TP.Dt_Conclusao,ATA_LEM,ETA_LEM,DOC.Dt_Conclusao DOC_S,DOC.Dt_Previsao DOC_P,
	Dl_Cargo_lem Dead_Line,PGI.HSGDataFU PGI ,num_proc_lem,dbo.fBusca_Containers(hou.num_proc_hem) Container,
	Dt_BL_LEM DT_BL, [dbo].[fBusca_Tarefa](num_proc_lem,37) Trans_Saida,[dbo].[fBusca_Tarefa](num_proc_lem,38) Trans_Chegada
from PO_HEM
	Join LLP_Exp_MAR LLP on num_proc_lem=num_proc_hem  
	Left Join Tarefas_Processos TP on TP.num_proc=num_proc_lem and TP.ID_TASK=4  
	Left Join Tarefas_processos  DOC on DOC.num_proc=num_proc_lem and DOC.Id_Task=12  
	Left Join Tarefas_processos  SDP on SDP.num_proc=num_proc_lem and SDP.Id_Task=10  
	Join house_exp_mar hou on hou.num_proc_hem=num_proc_lem 
	Join Pessoa_llp PP on PP.cd_pes=cd_export_hem  
--	Left Join Hist_Geral_Sistema HG on HG.hsgprocesso=num_proc_lem and HG.cd_tp_ocor=47 
	Left Join Hist_Geral PGI on PGI.hsgprocesso=num_proc_lem and PGI.cd_tp_ocor=70

where 
	id_dc=8 and   
	(atd_lem >=getdate()-90)


	and right(left(num_proc_lem, 5),3) ='CSR' --and num_proc_lem='EMCSR20091211001'
--Order by 2,1 w

union

SELECT 
	'O' Modal,right(left(Cd_Planta,5),2) Planta,right(Numero_PO_heo,8),Original_ETa_leo,
	TP.Dt_previsao Desp_P,SDP.Dt_Conclusao Saida_Planta, ETD_leo,ATD_leo,
	TP.Dt_Conclusao,ATA_leo,ETA_leo,DOC.Dt_Conclusao DOC_S,DOC.Dt_Previsao DOC_P,
	Dl_Cargo_leo Dead_Line,PGI.HSGDataFU PGI,num_proc_leo,
	null Container , null  DT_BL,null,null

from PO_heo
	Join LLP_Exp_out LLP on num_proc_leo=num_proc_heo  
	Left Join Tarefas_Processos TP on TP.num_proc=num_proc_leo and TP.ID_TASK=4  
	Left Join Tarefas_processos  DOC on DOC.num_proc=num_proc_leo and DOC.Id_Task=12  
	Left Join Tarefas_processos  SDP on SDP.num_proc=num_proc_leo and SDP.Id_Task=10  
	Join house_exp_out hou on hou.num_proc_heo=num_proc_leo  Join Pessoa_llp PP on PP.cd_pes=cd_export_heo  
--	Left Join Hist_Geral_Sistema HG on HG.hsgprocesso=num_proc_leo and hg.cd_tp_ocor=47 
	Left Join Hist_Geral PGI on PGI.hsgprocesso=num_proc_leo and PGI.cd_tp_ocor=70
where 
	id_dc=8 AND 

	(atd_leo >=getdate()-90)

	and right(left (num_proc_leo, 5),3) = 'CSR'
--	and num_proc_leo='EMCSR20080800501'


union

SELECT 
	'A' Modal,right(left(Cd_Planta,5),2) Planta,right(Numero_PO_hea,8),Original_ETa_lea,
	TP.Dt_previsao Desp_P,SDP.Dt_Conclusao Saida_Planta, ETD_lea,ATD_lea,
	TP.Dt_Conclusao,ATA_lea,ETA_lea,DOC.Dt_Conclusao DOC_S,DOC.Dt_Previsao DOC_P,
	Dl_Cargo_lea Dead_Line,PGI.HSGDataFU PGI,num_proc_lea,
	null container, 	null DT_BL,null,null

from PO_hea
	Join LLP_Exp_aer LLP on num_proc_lea=num_proc_hea  
	Left Join Tarefas_Processos TP on TP.num_proc=num_proc_lea and TP.ID_TASK=4  
	Left Join Tarefas_processos  DOC on DOC.num_proc=num_proc_lea and DOC.Id_Task=12  
	Left Join Tarefas_processos  SDP on SDP.num_proc=num_proc_lea and SDP.Id_Task=10  
	Join house_exp_aer hou on hou.num_proc_hea=num_proc_lea  Join Pessoa_llp PP on PP.cd_pes=cd_export_hea  
--	Left Join Hist_Geral_Sistema HG on HG.hsgprocesso=num_proc_lea and HG.cd_tp_ocor=47 
	Left Join Hist_Geral PGI on PGI.hsgprocesso=num_proc_lea and PGI.cd_tp_ocor=70
where 
	id_dc=8 AND 

	(atd_lea=getdate()-90

)



	and right(left(num_proc_lea, 5),3) = 'CSR'
--	and num_proc_lea='EMCSR20080800501'

Order by 2,1 

























GO
