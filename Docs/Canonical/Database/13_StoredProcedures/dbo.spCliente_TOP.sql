SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   Procedure spCliente_TOP 

	@DataInicial Varchar(10),
	@DataFinal Varchar(10)

AS

select apelido,sum(dbo.valor(vlr_pgto_nf_hia,cta.dc_hia)) Valor from house_imp_aer hou
inner join pessoa pp on pp.cd_pes=cd_import_hia
inner join cta_cte_hou_imp_aer cta on cta.num_proc_hia=hou.num_proc_hia
inner join base_nota_fiscal nf on nf.nota_fiscal=cta.num_nf_hia and nf.ref_acesso=cta.ref_acesso_nf_hia
where emissao between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)
group by apelido


union all


select apelido,sum(dbo.valor(vlr_pgto_nf_him,cta.dc_him)) Valor from house_imp_mar hou
inner join pessoa pp on pp.cd_pes=cd_import_him
inner join cta_cte_hou_imp_mar cta on cta.num_proc_him=hou.num_proc_him
inner join base_nota_fiscal nf on nf.nota_fiscal=cta.num_nf_him and nf.ref_acesso=cta.ref_acesso_nf_him
where emissao between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)
group by apelido

union all

select dbo.strGM_Grupo(apelido,cd_consig_hea) Cliente, sum(dbo.valor(vlr_pgto_nf_hea,cta.dc_hea)) Valor from house_exp_aer hou
inner join pessoa pp on pp.cd_pes=cd_export_hea
inner join cta_cte_hou_exp_aer cta on cta.num_proc_hea=hou.num_proc_hea
inner join base_nota_fiscal nf on nf.nota_fiscal=cta.num_nf_hea and nf.ref_acesso=cta.ref_acesso_nf_hea
where emissao between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)group by  dbo.strGM_Grupo(apelido,cd_consig_hea)


union all


select apelido,sum(dbo.valor(vlr_pgto_nf_hem,cta.dc_hem)) Valor from house_exp_mar hou
inner join pessoa pp on pp.cd_pes=cd_export_hem
inner join cta_cte_hou_exp_mar cta on cta.num_proc_hem=hou.num_proc_hem
inner join base_nota_fiscal nf on nf.nota_fiscal=cta.num_nf_hem and nf.ref_acesso=cta.ref_acesso_nf_hem
where emissao between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)group by apelido

union all

select dbo.strGM_Grupo(apelido,cd_consig_hea) Cliente, sum(dbo.valor(vlr_pgto_nf_mea,cta.dc_mea)) Valor from house_exp_aer hou
inner join pessoa pp on pp.cd_pes=cd_export_hea
inner join cta_cte_mas_exp_aer cta on cta.num_proc_mea=hou.num_proc_mea
inner join base_nota_fiscal nf on nf.nota_fiscal=cta.num_nf_mea and nf.ref_acesso=cta.ref_acesso_nf_mea
where emissao between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)group by  dbo.strGM_Grupo(apelido,cd_consig_hea)





GO
