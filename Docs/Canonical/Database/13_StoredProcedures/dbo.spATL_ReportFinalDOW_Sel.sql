SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure spATL_ReportFinalDOW_Sel
	@NF int
AS
select Num_Proc,Nome_Taxa,dt_adto,valor,Status_Descricao,Nome_raz_Soc, dbo.fBusca_Tarefa(num_proc,4),dbo.fBusca_Tarefa(num_proc,35),dt_devol,encerrado,isnull(RPS_NFE,NotA_Fiscal),saldo
 from ADM_Adiantamentos
Join LLP_Imp_mar L on num_proc_lim=num_Proc
LEft Join Tipo_Status_Processo T on T.id_status=L.id_status
Join House_Imp_mar hou on hou.num_proc_him=num_proC_lim
Join Pessoa PP on pp.cd_pes=cd_consig_him
Left Join vwcta_cte cta on cta.num_proc_hia=num_proc_him and cta.cd_tp_Tx='SRV' and dc_hia='C' 
Left Join BAse_Nota_Fiscal Nf on nf.notA_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia 
where encerrado=0
union all

select Num_Proc,Nome_Taxa,dt_adto,valor,Status_Descricao,Nome_raz_Soc, dbo.fBusca_Tarefa(num_proc,4),dbo.fBusca_Tarefa(num_proc,35),dt_devol,encerrado,isnull(RPS_NFE,NotA_Fiscal),saldo from ADM_Adiantamentos
Join LLP_Imp_aer L on num_proc_lia=num_Proc
LEft Join Tipo_Status_Processo T on T.id_status=L.id_status
Join House_Imp_aer hou on hou.num_proc_hia=num_proC_lia
Join Pessoa PP on pp.cd_pes=cd_consig_hia
Left Join vwcta_cte cta on cta.num_proc_hia=num_proc and cta.cd_tp_Tx='SRV' and dc_hia='C' 
Left Join BAse_Nota_Fiscal Nf on nf.notA_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia 
where encerrado=0


Union all

select Num_Proc,Nome_Taxa,dt_adto,valor,Status_Descricao,Nome_raz_Soc, dbo.fBusca_Tarefa(num_proc,4),dbo.fBusca_Tarefa(num_proc,35),dt_devol,encerrado,isnull(RPS_NFE,NotA_Fiscal),saldo from ADM_Adiantamentos
Join LLP_Imp_out L on num_proc_lio=num_Proc
LEft Join Tipo_Status_Processo T on T.id_status=L.id_status
Join House_Imp_out hou on hou.num_proc_hio=num_proC_lio
Join Pessoa PP on pp.cd_pes=cd_consig_hio
Left Join vwcta_cte cta on cta.num_proc_hia=num_proc and cta.cd_tp_Tx='SRV' and dc_hia='C' 
Left Join BAse_Nota_Fiscal Nf on nf.notA_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia 
where encerrado=0


Union all

select Num_Proc,Nome_Taxa,dt_adto,valor,Status_Descricao,Nome_raz_Soc, dbo.fBusca_Tarefa(num_proc,4),dbo.fBusca_Tarefa(num_proc,35),dt_devol,encerrado,isnull(RPS_NFE,NotA_Fiscal),saldo from ADM_Adiantamentos
Join LLP_exp_out L on num_proc_leo=num_Proc
LEft Join Tipo_Status_Processo T on T.id_status=L.id_status
Join House_exp_out hou on hou.num_proc_heo=num_proC_leo
Join Pessoa PP on pp.cd_pes=cd_export_heo
Left Join vwcta_cte cta on cta.num_proc_hia=num_proc and cta.cd_tp_Tx='SRV' and dc_hia='C' 
Left Join BAse_Nota_Fiscal Nf on nf.notA_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia 
where encerrado=0

Union all


select Num_Proc,Nome_Taxa,dt_adto,valor,Status_Descricao,Nome_raz_Soc, dbo.fBusca_Tarefa(num_proc,4),dbo.fBusca_Tarefa(num_proc,35),dt_devol,encerrado,isnull(RPS_NFE,NotA_Fiscal),saldo from ADM_Adiantamentos
Join LLP_exp_aer L on num_proc_lea=num_Proc
LEft Join Tipo_Status_Processo T on T.id_status=L.id_status
Join House_exp_aer hou on hou.num_proc_hea=num_proC_lea
Join Pessoa PP on pp.cd_pes=cd_export_hea
Left Join vwcta_cte cta on cta.num_proc_hia=num_proc and cta.cd_tp_Tx='SRV' and dc_hia='C' 
Left Join BAse_Nota_Fiscal Nf on nf.notA_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia 
where encerrado=0

Union all


select Num_Proc,Nome_Taxa,dt_adto,valor,Status_Descricao,Nome_raz_Soc, dbo.fBusca_Tarefa(num_proc,4),dbo.fBusca_Tarefa(num_proc,35),dt_devol,encerrado,isnull(RPS_NFE,NotA_Fiscal),saldo from ADM_Adiantamentos
Join LLP_exp_mar L on num_proc_lem=num_Proc
LEft Join Tipo_Status_Processo T on T.id_status=L.id_status
Join House_exp_mar hou on hou.num_proc_hem=num_proC_lem
Join Pessoa PP on pp.cd_pes=cd_export_hem
Left Join vwcta_cte cta on cta.num_proc_hia=num_proc and cta.cd_tp_Tx='SRV' and dc_hia='C' 
Left Join BAse_Nota_Fiscal Nf on nf.notA_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia 
where encerrado=0
GO
