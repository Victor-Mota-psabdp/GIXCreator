SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view Tb_Comercial

as
select 
	nome_raz_soc, count(DISTINCT(PROP.NUM_PROP_IA)) P, min(convert(datetime,dt_pia,105)) Primeira, count(distinct(num_proc_hia)) Qty, max(convert(datetime,dt_cheg_mia, 105)) Ultimo 

from proposta_imp_aer PROP

	Join Pessoa pp on pp.cd_pes=cd_import_pia
	left Join House_imp_aer hou on cd_import_hia=cd_import_pia
	Left join master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia

group by nome_raz_soc


union


select 
	nome_raz_soc, count(DISTINCT(PROP.NUM_prop_ea)) P, min(convert(datetime,dt_pea,105)) Primeira, count(distinct(num_proc_hea)) Qty, max(convert(datetime,dt_saida_mea, 105)) Ultimo 

from proposta_exp_aer PROP

	Join Pessoa pp on pp.cd_pes=cd_export_pea
	left Join House_exp_aer hou on cd_export_hea=cd_export_pea
	Left join master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea

group by nome_raz_soc

union


select 
	nome_raz_soc, count(DISTINCT(PROP.NUM_PROP_Im)) P, min(convert(datetime,dt_pim,105)) Primeira, count(distinct(num_proc_him)) Qty, max(convert(datetime,dt_atrac_mim, 105)) Ultimo 

from proposta_imp_mar PROP

	Join Pessoa pp on pp.cd_pes=cd_import_pim
	left Join House_imp_mar hou on cd_import_him=cd_import_pim
	Left join master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim

group by nome_raz_soc


union


select 
	nome_raz_soc, count(DISTINCT(PROP.NUM_prop_em)) P, min(convert(datetime,dt_pem,105)) Primeira, count(distinct(num_proc_hem)) Qty, max(convert(datetime,dt_saida_mem, 105)) Ultimo 

from proposta_exp_mar PROP

	Join Pessoa pp on pp.cd_pes=cd_export_pem
	left Join House_exp_mar hou on cd_export_hem=cd_export_pem
	Left join master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem

group by nome_raz_soc


GO
