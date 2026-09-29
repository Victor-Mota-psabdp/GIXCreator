SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spBuscaProcessoGeraCtaCte_Sel]
as
select 
	distinct db.num_proc Job, AX.Id_AX
from 
dbo.Log_CHB_Integracao_Debito_CC DB  
Join cta_cte CTA with (nolock) on CTA.cd_agencia=DB.agencia and replace(replace(cta.num_cta_cte,'-',''),'.','')=DB.cta_cte  
Left Join vwcxas CXA on CXA.num_proc_hia=DB.num_proc and cxa.cd_tp_Tx IN ('XAD') and cxa.dc_hia='D'  
Left Join vwAXDOCs AX on DB.num_proc = AX.Num_Proc and AX.cd_tp_tx_atl IN ('XAD') and AX.dc ='D' 
Join Tarefas_Processos TP with (nolock) on TP.num_proc=db.num_proc and id_task=4 and dt_conclusao is null  
where cxa.num_lcto is null and dt_leitura is null and id_AX is NULL


GO
