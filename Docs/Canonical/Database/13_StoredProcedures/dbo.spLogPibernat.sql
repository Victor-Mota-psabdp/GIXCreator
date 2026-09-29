SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[spLogPibernat]

AS


select HOU.NUM_PROC_HIM,NUMERO_PO_HIM, DT_CONCLUSAO,Nome_local from house_imp_mar HOU with(nolock)
Left Join PO_HIM PO with(nolock) on PO.num_proc_him=hou.num_proc_him and ID_DC=1
Left Join Tarefas_Processos TF with(nolock) on HOU.num_proc_him=TF.num_proc and Id_Task=13
Left Join Nota_Cliente NC with(nolock) on HOU.num_proc_him=NC.num_proC
Join Localidade DST with(nolock) on DST.cd_local=cd_dst_him
Where left(HOU.num_proc_him,5)='IMCSR'
and cd_dst_him in ('ITJ','NVT','SFS') 
and NC.num_proc is null
and Dt_Conclusao is not null
and dt_conclusao > '01-01-2008'

union all

select HOU.NUM_PROC_hio,NUMERO_PO_hio, DT_CONCLUSAO,nome_local from house_imp_out HOU with(nolock)
Left Join PO_hio PO with(nolock) on PO.num_proc_hio=hou.num_proc_hio and ID_DC=1
Left Join Tarefas_Processos TF with(nolock) on HOU.num_proc_hio=TF.num_proc and Id_Task=13
Left Join Nota_Cliente NC with(nolock) on HOU.num_proc_hio=NC.num_proC
Left Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hio
Where left(HOU.num_proc_hio,5)='IOCSR'
and NC.num_proc is null
and Dt_Conclusao is not null
and dt_conclusao > '01-01-2008'





GO
