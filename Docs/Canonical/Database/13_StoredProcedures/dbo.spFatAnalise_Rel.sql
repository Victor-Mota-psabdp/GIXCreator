SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure spFatAnalise_Rel

as

select 
	'EA' Modal,dbo.strGM_Grupo(Nome_raz_soc, cd_consig_hea) Cliente,month(emissao) Mes,sum(dbo.valor(Vlr_Pgto_NF_HEA,cta.dc_hea)) Valor
from 
	cta_cte_hou_exp_aer cta
	Join base_nota_fiscal nf on nf.nota_fiscal=num_nf_hea and nf.ref_acesso=ref_acesso_nf_hea
	Join house_exp_aer hou on hou.num_proc_hea=hou.num_proc_hea
	Join Pessoa pp on pp.cd_pes=cd_export_hea
Where 
	emissao >='01-01-2005'
Group by 	
	dbo.strGM_Grupo(Nome_raz_soc, cd_consig_hea),month(emissao)


UNION ALL

select 
	'EA' Modal,dbo.strGM_Grupo(Nome_raz_soc, cd_consig_hea) Cliente,month(emissao) Mes,sum(dbo.valor(Vlr_Pgto_NF_MEA,cta.dc_Mea)) Valor
from 
	cta_cte_MAS_exp_aer cta
	Join base_nota_fiscal nf on nf.nota_fiscal=num_nf_mea and nf.ref_acesso=ref_acesso_nf_mea
	Join house_exp_aer hou on hou.num_proc_Mea=hou.num_proc_Mea
	Join Pessoa pp on pp.cd_pes=cd_export_hea
Where 
	emissao >='01-01-2005'
Group by 	
	dbo.strGM_Grupo(Nome_raz_soc, cd_consig_hea),month(emissao)

union 


select 
	'EM' Modal,Nome_raz_soc,month(emissao) Mes,sum(dbo.valor(Vlr_Pgto_NF_hem,cta.dc_hem)) Valor
from 
	cta_cte_hou_exp_mar cta
	Join base_nota_fiscal nf on nf.nota_fiscal=num_nf_hem and nf.ref_acesso=ref_acesso_nf_hem
	Join house_exp_mar hou on hou.num_proc_hem=hou.num_proc_hem
	Join Pessoa pp on pp.cd_pes=cd_export_hem
Where 
	emissao >='01-01-2005'
Group by 	
	Nome_raz_soc,month(emissao)


UNION ALL

select 
	'EM' Modal,Nome_raz_soc,month(emissao) Mes,sum(dbo.valor(Vlr_Pgto_NF_mem,cta.dc_mem)) Valor
from 
	cta_cte_MAS_exp_mar cta
	Join base_nota_fiscal nf on nf.nota_fiscal=num_nf_mem and nf.ref_acesso=ref_acesso_nf_mem
	Join house_exp_mar hou on hou.num_proc_mem=hou.num_proc_mem
	Join Pessoa pp on pp.cd_pes=cd_export_hem
Where 
	emissao >='01-01-2005'
Group by 	
	Nome_raz_soc,month(emissao)

union


select 
	'IM' Modal,Nome_raz_soc,month(emissao) Mes,sum(dbo.valor(Vlr_Pgto_NF_him,cta.dc_him)) Valor
from 
	cta_cte_hou_imp_mar cta
	Join base_nota_fiscal nf on nf.nota_fiscal=num_nf_him and nf.ref_acesso=ref_acesso_nf_him
	Join house_imp_mar hou on hou.num_proc_him=hou.num_proc_him
	Join Pessoa pp on pp.cd_pes=cd_import_him
Where 
	emissao >='01-01-2005'
Group by 	
	Nome_raz_soc,month(emissao)


UNION ALL

select 
	'IM' Modal,Nome_raz_soc,month(emissao) Mes,sum(dbo.valor(Vlr_Pgto_NF_mim,cta.dc_mim)) Valor
from 
	cta_cte_MAS_imp_mar cta
	Join base_nota_fiscal nf on nf.nota_fiscal=num_nf_mim and nf.ref_acesso=ref_acesso_nf_mim
	Join house_imp_mar hou on hou.num_proc_mim=hou.num_proc_mim
	Join Pessoa pp on pp.cd_pes=cd_import_him
Where 
	emissao >='01-01-2005'
Group by 	
	Nome_raz_soc,month(emissao)

UNION 


select 
	'IA' Modal,Nome_raz_soc,month(emissao) Mes,sum(dbo.valor(Vlr_Pgto_NF_hia,cta.dc_hia)) Valor
from 
	cta_cte_hou_imp_aer cta
	Join base_nota_fiscal nf on nf.nota_fiscal=num_nf_hia and nf.ref_acesso=ref_acesso_nf_hia
	Join house_imp_aer hou on hou.num_proc_hia=hou.num_proc_hia
	Join Pessoa pp on pp.cd_pes=cd_import_hia
Where 
	emissao >='01-01-2005'
Group by 	
	Nome_raz_soc,month(emissao)


UNION ALL

select 
	'IA' Modal,Nome_raz_soc,month(emissao) Mes,sum(dbo.valor(Vlr_Pgto_NF_mia,cta.dc_mia)) Valor
from 
	cta_cte_MAS_imp_aer cta
	Join base_nota_fiscal nf on nf.nota_fiscal=num_nf_mia and nf.ref_acesso=ref_acesso_nf_mia
	Join house_imp_aer hou on hou.num_proc_mia=hou.num_proc_mia
	Join Pessoa pp on pp.cd_pes=cd_import_hia
Where 
	emissao >='01-01-2005'
Group by 	
	Nome_raz_soc,month(emissao)


GO
