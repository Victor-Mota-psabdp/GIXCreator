SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE Procedure [dbo].[spDesembComErro_alert]

as


select tp.num_proc Referencia,
nc.nota_fiscal Nota_Fiscal,isnull(nc.emissao,'') Emissao_NF,
l.nome_local Dst_final,
nc.mensagem_erro,usu.nome_usuario,nc.envio
from tarefas_processos TP with(nolock)
left join nota_cliente NC with(nolock) on nc.num_proc=tp.num_proc
left join llp_imp_mar LLP with(nolock) on llp.num_proc_lim=nc.num_proc
left join localidade L with(nolock) on l.cd_local=llp.cd_dstfinal_lim
left join job_imp_mar JOB with(nolock) on job.num_proc_him=tp.num_proc
left join usuario USU with(nolock) on job.cd_usuario=usu.cd_usuario
where nc.num_proc is not null
and dt_conclusao <= getdate()
and tp.id_task='4'
and right(left(tp.num_proc,5),3)='CSR'
and left(tp.num_proc,1)='I'
and tp.dt_conclusao>'2009-01-31'
and l.nome_local is not null
and nc.mensagem_erro is not null
and nc.envio is null
--and left(nc.nota_fiscal,2)<>'00'


union

select tp.num_proc Referencia,
nc.nota_fiscal Nota_Fiscal,isnull(nc.emissao,'') Emissao_NF,
l.nome_local Dst_final,
nc.mensagem_erro,usu.nome_usuario,nc.envio
from tarefas_processos TP with(nolock)
left join nota_cliente NC with(nolock) on nc.num_proc=tp.num_proc
left join llp_imp_aer LLP with(nolock) on llp.num_proc_lia=nc.num_proc
left join localidade L with(nolock) on l.cd_local=llp.cd_dstfinal_lia
left join job_imp_aer JOB with(nolock) on job.num_proc_hia=tp.num_proc
left join usuario USU with(nolock) on job.cd_usuario=usu.cd_usuario
where nc.num_proc is not null
and dt_conclusao <= getdate()
and tp.id_task='4'
and right(left(tp.num_proc,5),3)='CSR'
and left(tp.num_proc,1)='I'
and tp.dt_conclusao>'2009-01-31'
and l.nome_local is not null
and nc.mensagem_erro is not null
and nc.envio is null
--and left(nc.nota_fiscal,2)<>'00'

union

select tp.num_proc Referencia,
nc.nota_fiscal Nota_Fiscal,isnull(nc.emissao,'') Emissao_NF,
l.nome_local Dst_final,
nc.mensagem_erro,usu.nome_usuario,nc.envio
from tarefas_processos TP with(nolock)
left join nota_cliente NC with(nolock) on nc.num_proc=tp.num_proc
left join llp_imp_out NUMP with(nolock) on nump.num_proc_lio=nc.num_proc
left join localidade L with(nolock) on l.cd_local=nump.cd_dstfinal_lio
left join usuario USU with(nolock) on nump.cd_usuario=usu.cd_usuario
where nc.num_proc is not null
and dt_conclusao <= getdate()
and tp.id_task='4'
and right(left(tp.num_proc,5),3)='CSR'
and left(tp.num_proc,1)='I'
and tp.dt_conclusao>'2009-01-31'
and l.nome_local is not null
and nc.mensagem_erro is not null
and nc.envio is null
--and left(nc.nota_fiscal,2)<>'00'

order by referencia





GO
