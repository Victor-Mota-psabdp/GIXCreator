SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   Procedure spICIRec_rel

as

select 
	
	month(emissao) Mes,org.nome_local Origem, dst.nome_local Destino, sum(dbo.valor(Vlr_Pgto_NF_HIA,cta.dc_hia)) Nota

from 
	house_imp_aer HOU
	Join cta_cte_hou_imp_aer CTA on CTA.num_proc_hia=hou.num_proc_hia
	Join localidade ORG on Org.cd_local=hou.cd_org_hia
	Join localidade DST on dst.cd_local=hou.cd_dst_hia
	Join base_nota_fiscal NF on nf.nota_fiscal=num_nf_hia and cta.ref_acesso_nf_hia=ref_acesso
	Join Pessoa PP on pp.cd_pes=cd_import_hia

where 
	emissao >='01-01-2005' and apelido like 'ICI%'

Group by
	month(emissao),org.nome_local, dst.nome_local

Union


select 
	
	month(emissao) Mes,org.nome_local Origem, dst.nome_local Destino, sum(dbo.valor(Vlr_Pgto_NF_HIM,cta.dc_him)) Nota

from 
	house_imp_mar HOU
	Join cta_cte_hou_imp_mar CTA on CTA.num_proc_him=hou.num_proc_him
	Join localidade ORG on Org.cd_local=hou.cd_org_him
	Join localidade DST on dst.cd_local=hou.cd_dst_him
	Join base_nota_fiscal NF on nf.nota_fiscal=num_nf_him and cta.ref_acesso_nf_him=ref_acesso
	Join Pessoa PP on pp.cd_pes=cd_import_him

where 
	emissao >='01-01-2005' and apelido like 'ICI%'

Group by
	month(emissao),org.nome_local, dst.nome_local




GO
