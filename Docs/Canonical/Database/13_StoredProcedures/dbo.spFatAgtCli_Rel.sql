SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure spFatAgtCli_Rel 

		@datainicial	varchar(10),
		@datafinal	varchar(10)
AS

select 
	'Importação Aérea' Modal,pp.apelido Cliente,pp.cd_tp_grupo,agt.apelido,dc_hia,cast(vlr_pgto_nf_hia as money) Valor 
from 
	cta_cte_hou_imp_aer cta

	inner join house_imp_aer hou on (hou.num_proc_hia=cta.num_proc_hia)
	inner join master_imp_aer mas on (hou.num_proc_mia=mas.num_proc_mia)
	inner join pessoa pp on (pp.cd_pes=hou.cd_import_hia)
	inner join pessoa agt on (agt.cd_pes=mas.cd_export_mia)
	inner join base_nota_fiscal nf on (nota_fiscal=cta.num_nf_hia and nf.ref_Acesso=cta.ref_Acesso_nf_hia)
where 
	emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)


UNION ALL

select 
	'Importação Aérea' Modal,pp.apelido Cliente,pp.cd_tp_grupo,agt.apelido,dc_mia,cast(vlr_pgto_nf_mia as money) Valor 
from 
	cta_cte_mas_imp_aer cta

	inner join house_imp_aer hou on (hou.num_proc_mia=cta.num_proc_mia)
	inner join master_imp_aer mas on (hou.num_proc_mia=mas.num_proc_mia)
	inner join pessoa pp on (pp.cd_pes=hou.cd_import_hia)
	inner join pessoa agt on (agt.cd_pes=mas.cd_export_mia)
	inner join base_nota_fiscal nf on (nota_fiscal=cta.num_nf_mia and nf.ref_Acesso=cta.ref_Acesso_nf_mia)
where 
	emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)

UNION ALL

select 
	'Importação Marítima' Modal,pp.apelido Cliente,pp.cd_tp_grupo,agt.apelido,dc_him,cast(vlr_pgto_nf_him as money) Valor 
from 
	cta_cte_hou_imp_mar cta

	inner join house_imp_mar hou on (hou.num_proc_him=cta.num_proc_him)
	inner join master_imp_mar mas on (hou.num_proc_mim=mas.num_proc_mim)
	inner join pessoa pp on (pp.cd_pes=hou.cd_import_him)
	inner join pessoa agt on (agt.cd_pes=mas.cd_export_mim)
	inner join base_nota_fiscal nf on (nota_fiscal=cta.num_nf_him and nf.ref_Acesso=cta.ref_Acesso_nf_him)
where 
	emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)


UNION ALL

select 
	'Importação Marítima' Modal,pp.apelido Cliente,pp.cd_tp_grupo,agt.apelido,dc_mim,cast(vlr_pgto_nf_mim as money) Valor 
from 
	cta_cte_mas_imp_mar cta

	inner join house_imp_mar hou on (hou.num_proc_mim=cta.num_proc_mim)
	inner join master_imp_mar mas on (hou.num_proc_mim=mas.num_proc_mim)
	inner join pessoa pp on (pp.cd_pes=hou.cd_import_him)
	inner join pessoa agt on (agt.cd_pes=mas.cd_export_mim)
	inner join base_nota_fiscal nf on (nota_fiscal=cta.num_nf_mim and nf.ref_Acesso=cta.ref_Acesso_nf_mim)
where 
	emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)

union ALL

select 
	'Exportação Aérea' Modal,dbo.strgm_grupo(pp.apelido,Cd_Consig_HEA) Cliente,pp.cd_tp_grupo,agt.apelido,dc_hea,cast(vlr_pgto_nf_hea as money) Valor 
from 
	cta_cte_hou_exp_aer cta

	inner join house_exp_aer hou on (hou.num_proc_hea=cta.num_proc_hea)
	inner join master_exp_aer mas on (hou.num_proc_mea=mas.num_proc_mea)
	inner join pessoa pp on (pp.cd_pes=hou.cd_export_hea)
	inner join pessoa agt on (agt.cd_pes=mas.cd_consig_mea)
	inner join base_nota_fiscal nf on (nota_fiscal=cta.num_nf_hea and nf.ref_Acesso=cta.ref_Acesso_nf_hea)
where 
	emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)


UNION ALL

select 
	'Exportação Aérea' Modal,dbo.strgm_grupo(pp.apelido,Cd_Consig_HEA) Cliente,pp.cd_tp_grupo,agt.apelido,dc_mea,cast(vlr_pgto_nf_mea as money) Valor 
from 
	cta_cte_mas_exp_aer cta

	inner join house_exp_aer hou on (hou.num_proc_mea=cta.num_proc_mea)
	inner join master_exp_aer mas on (hou.num_proc_mea=mas.num_proc_mea)
	inner join pessoa pp on (pp.cd_pes=hou.cd_export_hea)
	inner join pessoa agt on (agt.cd_pes=mas.cd_consig_mea)
	inner join base_nota_fiscal nf on (nota_fiscal=cta.num_nf_mea and nf.ref_Acesso=cta.ref_Acesso_nf_mea)
where 
	emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)

union ALL

select 
	'Exportação Marítima' Modal,pp.apelido Cliente,pp.cd_tp_grupo,agt.apelido,dc_hem,cast(vlr_pgto_nf_hem as money) Valor 
from 
	cta_cte_hou_exp_mar cta

	inner join house_exp_mar hou on (hou.num_proc_hem=cta.num_proc_hem)
	inner join master_exp_mar mas on (hou.num_proc_mem=mas.num_proc_mem)
	inner join pessoa pp on (pp.cd_pes=hou.cd_export_hem)
	inner join pessoa agt on (agt.cd_pes=mas.cd_consig_mem)
	inner join base_nota_fiscal nf on (nota_fiscal=cta.num_nf_hem and nf.ref_Acesso=cta.ref_Acesso_nf_hem)

where 
	emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)


UNION ALL

select 
	'Exportação Marítima' Modal,pp.apelido Cliente,pp.cd_tp_grupo,agt.apelido,dc_mem,cast(vlr_pgto_nf_mem as money) Valor 
from 
	cta_cte_mas_exp_mar cta

	inner join house_exp_mar hou on (hou.num_proc_mem=cta.num_proc_mem)
	inner join master_exp_mar mas on (hou.num_proc_mem=mas.num_proc_mem)
	inner join pessoa pp on (pp.cd_pes=hou.cd_export_hem)
	inner join pessoa agt on (agt.cd_pes=mas.cd_consig_mem)
	inner join base_nota_fiscal nf on (nota_fiscal=cta.num_nf_mem and nf.ref_Acesso=cta.ref_Acesso_nf_mem)
where 
	emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)




GO
