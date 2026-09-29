SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE Procedure [dbo].[spDesembSemNota_alert]

as

select tp.num_proc Referencia,
tp.dt_conclusao Dt_Desembaraco,l.nome_local Destino_Final,cast(getdate()-tp.dt_conclusao as int) Dias
from tarefas_processos TP  with(nolock)
left join nota_cliente NC with(nolock) on nc.num_proc=tp.num_proc
left join llp_imp_mar DM with(nolock) on dm.num_proc_lim=tp.num_proc
left join localidade L with(nolock) on l.cd_local=dm.cd_dstfinal_lim 

where nc.num_proc is null
and dt_conclusao <= getdate()-2
and tp.id_task='4'
and left(tp.num_proc,1)='I'
and right(left(tp.num_proc,5),3)='CSR'
and tp.dt_conclusao>'2009-01-31'
and l.nome_local is not null

union

select tp.num_proc Referencia,
tp.dt_conclusao Dt_Desembaraco,l.nome_local Destino_Final,cast(getdate()-tp.dt_conclusao as int) Dias
from tarefas_processos TP with(nolock) 
left join nota_cliente NC with(nolock) on nc.num_proc=tp.num_proc
left join llp_imp_aer LLP with(nolock) on llp.num_proc_lia=tp.num_proc
left join localidade L with(nolock) on l.cd_local=llp.cd_dstfinal_lia 
left Join PO_HIA DI with(nolock) on DI.num_proc_hia=tp.num_proc AND ID_DC=5
where nc.num_proc is null
and dt_conclusao <= getdate()-2
and tp.id_task='4'
and left(tp.num_proc,1)='I'
and right(left(tp.num_proc,5),3)='CSR'
and tp.dt_conclusao>'2009-01-31'
and l.nome_local is not null
AND NUMERO_PO_hIa <> 'Courier'


union

select tp.num_proc Referencia,
tp.dt_conclusao Dt_Desembaraco,l.nome_local Destino_Final,cast(getdate()-tp.dt_conclusao as int) Dias
from tarefas_processos TP with(nolock) 
left join nota_cliente NC with(nolock) on nc.num_proc=tp.num_proc
left join llp_imp_out LLP with(nolock) on llp.num_proc_lio=tp.num_proc
left join localidade L with(nolock) on l.cd_local=llp.cd_dstfinal_lio 
where nc.num_proc is null
and dt_conclusao <= getdate()-5
and tp.id_task='4'
and left(tp.num_proc,1)='I'
and right(left(tp.num_proc,5),3)='CSR'
and tp.dt_conclusao>'2009-01-31'
and l.nome_local is not null

order by dias desc




GO
