SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[spExportTemp]
as


select num_proc_lem,numero_po_hem from llp_exp_mar with(nolock)
Join Po_HEM PO with(nolock) on PO.num_proc_hem=num_proc_lem and id_dc=10
Join TarefaS_processos TF with(nolock) on TF.num_proc=num_proc_lem and id_task=15
where
	substring(num_proc_lem,3,3) in ('CSR','ROB','STB')-- and num_proc_lem='EMCSR20090107901'
and dt_conclusao between '01-01-2010' and '09-30-2012'



union

select num_proc_lea,numero_po_hea from llp_exp_aer with(nolock)
Join Po_HEa PO with(nolock) on PO.num_proc_hea=num_proc_lea and id_dc=10
Join TarefaS_processos TF with(nolock) on TF.num_proc=num_proc_lea and id_task=15
where
	substring(num_proc_lea,3,3) in ('CSR','ROB','STB')
	and dt_conclusao between '01-01-2010' and '09-30-2012'


union

select num_proc_leo,numero_po_heo from llp_exp_out with(nolock)
Join Po_HEo PO with(nolock) on PO.num_proc_heo=num_proc_leo and id_dc=10
Join TarefaS_processos TF with(nolock) on TF.num_proc=num_proc_leo and id_task=15
where
	substring(num_proc_leo,3,3) in ('CSR','ROB','STB')
	and dt_conclusao between '01-01-2010' and '09-30-2012'





























GO
