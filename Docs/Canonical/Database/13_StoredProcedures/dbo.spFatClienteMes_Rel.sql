SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   procedure spFatClienteMes_Rel
		@DataInicial varchar(10),
		@DataFinal varchar(10)

AS


select 
	'IA' Modal, month(emissao) Mes, year(emissao) Ano, nome_raz_soc, SUM(dbo.valor(Vlr_Pgto_NF_HIA,cta.dc_hia)) Valor
from 
	cta_cte_hou_imp_aer cta
	Join Base_nota_fiscal nf on nf.nota_fiscal=cta.num_nf_hia and ref_acesso=ref_acesso_nf_hia
	Join house_imp_aer hou on hou.num_proc_hia=cta.num_Proc_hia
	Join Pessoa pp on pp.cd_pes=cd_import_hia
where
	emissao between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)

Group by
	
	month(emissao), year(emissao) , nome_raz_soc

UNION ALL

select 
	'IM' Modal, month(emissao) Mes, year(emissao) Ano, nome_raz_soc, SUM(dbo.valor(Vlr_Pgto_NF_him,cta.dc_him)) Valor
from 
	cta_cte_hou_imp_mar cta
	Join Base_nota_fiscal nf on nf.nota_fiscal=cta.num_nf_him and ref_acesso=ref_acesso_nf_him
	Join house_imp_mar hou on hou.num_proc_him=cta.num_Proc_him
	Join Pessoa pp on pp.cd_pes=cd_import_him
where
	emissao between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)

Group by
	
	month(emissao), year(emissao) , nome_raz_soc

UNION ALL

select 
	'EA' Modal, month(emissao) Mes, year(emissao) Ano, dbo.strGM_grupo(nome_raz_soc,cd_consig_hea), SUM(dbo.valor(Vlr_Pgto_NF_hea,cta.dc_hea)) Valor
from 
	cta_cte_hou_exp_aer cta
	Join Base_nota_fiscal nf on nf.nota_fiscal=cta.num_nf_hea and ref_acesso=ref_acesso_nf_hea
	Join house_exp_aer hou on hou.num_proc_hea=cta.num_Proc_hea
	Join Pessoa pp on pp.cd_pes=cd_export_hea
where
	emissao between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)

Group by
	
	month(emissao), year(emissao) ,dbo.strGM_grupo(nome_raz_soc,cd_consig_hea)

UNION ALL

select 
	'EM' Modal, month(emissao) Mes, year(emissao) Ano, nome_raz_soc, SUM(dbo.valor(Vlr_Pgto_NF_hem,cta.dc_hem)) Valor
from 
	cta_cte_hou_exp_mar cta
	Join Base_nota_fiscal nf on nf.nota_fiscal=cta.num_nf_hem and ref_acesso=ref_acesso_nf_hem
	Join house_exp_mar hou on hou.num_proc_hem=cta.num_Proc_hem
	Join Pessoa pp on pp.cd_pes=cd_export_hem
where
	emissao between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)

Group by
	
	month(emissao), year(emissao) , nome_raz_soc

UNION ALL

select 
	'EA' Modal, month(emissao) Mes, year(emissao) Ano, dbo.strGM_grupo(nome_raz_soc,cd_consig_hea), SUM(dbo.valor(Vlr_Pgto_NF_Mea,cta.dc_Mea)) Valor
from 
	cta_cte_MAS_exp_aer cta
	Join Base_nota_fiscal nf on nf.nota_fiscal=cta.num_nf_Mea and ref_acesso=ref_acesso_nf_Mea
	Join house_exp_aer hou on hou.num_proc_Mea=cta.num_Proc_Mea
	Join Pessoa pp on pp.cd_pes=cd_export_hea
where
	emissao between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)

Group by
	
	month(emissao), year(emissao) , dbo.strGM_grupo(nome_raz_soc,cd_consig_hea)



	

GO
