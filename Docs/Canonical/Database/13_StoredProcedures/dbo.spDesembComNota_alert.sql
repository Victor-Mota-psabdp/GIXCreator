SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select  * from nota_cliente






CREATE Procedure [dbo].[spDesembComNota_alert]

as

select tp.num_proc Referencia,
tp.dt_conclusao Dt_Desembaraco,nc.nota_fiscal Nota_Fiscal,isnull(nc.emissao,'') Emissao_NF,
l.nome_local Dst_final,cast(getdate()-tp.dt_conclusao as int) Dias,left(nc.data_envio,11) Data_de_Envio 
from tarefas_processos TP with(nolock) 
left join nota_cliente NC with(nolock)  on nc.num_proc=tp.num_proc
left join llp_imp_mar LLP with(nolock)  on llp.num_proc_lim=nc.num_proc
left join localidade L with(nolock)  on l.cd_local=llp.cd_dstfinal_lim
where nc.num_proc is not null
and dt_conclusao <= getdate()+2
and tp.id_task='4'
and right(left(tp.num_proc,5),3)='CSR'
and left(tp.num_proc,1)='I'
and tp.dt_conclusao>'2009-01-31'
and l.nome_local is not null

union

select tp.num_proc Referencia,
tp.dt_conclusao Dt_Desembaraco,nc.nota_fiscal Nota_Fiscal,isnull(nc.emissao,'') Emissao_NF,
l.nome_local Dst_final,cast(getdate()-tp.dt_conclusao as int) Dias,left(nc.data_envio,11) Data_de_Envio 
from tarefas_processos TP  with(nolock) 
left join nota_cliente NC with(nolock)  on nc.num_proc=tp.num_proc
left join llp_imp_aer LLP with(nolock)  on llp.num_proc_lia=nc.num_proc
left join localidade L with(nolock)  on l.cd_local=llp.cd_dstfinal_lia
where nc.num_proc is not null
and dt_conclusao <= getdate()+2
and tp.id_task='4'
and right(left(tp.num_proc,5),3)='CSR'
and left(tp.num_proc,1)='I'
and tp.dt_conclusao>'2009-01-31'
and l.nome_local is not null

union

select tp.num_proc Referencia,
tp.dt_conclusao Dt_Desembaraco,nc.nota_fiscal Nota_Fiscal,isnull(nc.emissao,'') Emissao_NF,
l.nome_local Dst_final,cast(getdate()-tp.dt_conclusao as int) Dias,left(nc.data_envio,11) Data_de_Envio 
from tarefas_processos TP  with(nolock) 
left join nota_cliente NC with(nolock)  on nc.num_proc=tp.num_proc
left join llp_imp_out LLP with(nolock)  on llp.num_proc_lio=nc.num_proc
left join localidade L with(nolock)  on l.cd_local=llp.cd_dstfinal_lio
where nc.num_proc is not null
and dt_conclusao <= getdate()+2
and tp.id_task='4'
and right(left(tp.num_proc,5),3)='CSR'
and left(tp.num_proc,1)='I'
and tp.dt_conclusao>'2009-01-31'
and l.nome_local is not null

order by emissao_nf desc





GO
