SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spIntAXJMD_Sel_Debug] 

AS




select excprocesso Job, 'I' strInstrucao,J.Num_Proc, LBO.Id_TP_Servico 
  
from exchange C with(nolock)
	join vwALL_JOBs AL with(nolock) on C.ExcProcesso = AL.Num_Proc
	Left Join Exchange_JMD_AX_ATL EX with(nolock) on EX.num_proc=c.excprocesso
	left join LLP_BDP_OUT LBO with(nolock) on LBO.Num_Proc_LBO = C.ExcProcesso
	left join JOB_HBO J with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO 
where 
c.ExcProcesso = 'BOCSR202005020BR'
/*
	--len(c.excprocesso)=16 
and 	 ex.num_proc is null 	 and c.dt_envio_jmd_ax is null 
	--and LEFT(c.ExcProcesso,2) ='BO'	
	and
	(
		J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1
		or
		J.Num_Proc is not null and LBO.Id_TP_Servico = 1		
	)
	and c.ExcProcesso = 'BOCSR202005020BR'
	--and SUBSTRING(excprocesso,6,4) >='2014'
*/
group by excprocesso,J.Num_Proc, LBO.Id_TP_Servico 


GO
