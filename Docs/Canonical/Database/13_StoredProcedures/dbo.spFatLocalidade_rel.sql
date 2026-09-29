SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   Procedure [dbo].[spFatLocalidade_rel]
		@datainicial	varchar(10),
		@datafinal	varchar(10),
		@Local		varchar(30)

AS

--HOUSE IA
select 

	'Importacao Aérea' as Modal, dst.nome_local,cast(sum(dbo.valor(cta.vlr_pgto_nf_hia,cta.dc_hia)) as money)  as Valor

from 
	cta_cte_hou_imp_aer cta

inner join house_imp_aer hou on (hou.num_proc_hia=cta.num_proc_hia)
inner join localidade dst on (dst.cd_local=hou.cd_dst_hia)
inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_hia and nf.ref_acesso=ref_acesso_nf_hia)

where 
	nf.emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105) and nome_local like @local

group by 

	dst.nome_local


UNION ALL

--MASTER IA

select 
	'Importação Aérea' as Modal,dst.nome_local,cast(sum(dbo.valor(cta.vlr_pgto_nf_mia,cta.dc_mia)) as money) 

from 
	cta_cte_mas_imp_aer cta

inner join master_imp_aer mas on (mas.num_proc_mia=cta.num_proc_mia)
inner join localidade dst on (dst.cd_local=mas.cd_dst_mia)
inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_mia and nf.ref_acesso=ref_acesso_nf_mia)

where 
	nf.emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105) and nome_local like @local

group by 
	dst.nome_local

UNION ALL

--house IM
select 

	'Importação Marítima' as Modal, dst.nome_local,cast(sum(dbo.valor(cta.vlr_pgto_nf_him,cta.dc_him)) as money) 

from 
	cta_cte_hou_imp_mar cta

inner join house_imp_mar hou on (hou.num_proc_him=cta.num_proc_him)
inner join localidade dst on (dst.cd_local=hou.cd_dst_him)
inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_him and nf.ref_acesso=ref_acesso_nf_him)

where 	

	nf.emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105) and nome_local like @local

group by dst.nome_local

UNION ALL

--Master IM
select 
	'Importação Marítima' as Modal,dst.nome_local,cast(sum(dbo.valor(cta.vlr_pgto_nf_mim,cta.dc_mim)) as money) from cta_cte_mas_imp_mar cta

inner join master_imp_mar mas on (mas.num_proc_mim=cta.num_proc_mim)
inner join localidade dst on (dst.cd_local=mas.cd_dst_mim)
inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_mim and nf.ref_acesso=ref_acesso_nf_mim)

where 

	nf.emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105) and nome_local like @local

group by dst.nome_local


UNION ALL
--House EA

select 
	'Exportação Aérea' as Modal, dst.nome_local,cast(sum(dbo.valor(cta.vlr_pgto_nf_hea,cta.dc_hea)) as money) from cta_cte_hou_exp_aer cta

inner join house_exp_aer hou on (hou.num_proc_hea=cta.num_proc_hea)
inner join localidade dst on (dst.cd_local=hou.cd_org_hea)
inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_hea and nf.ref_acesso=ref_acesso_nf_hea)

where 

	nf.emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105) and nome_local like @local

group by 
	dst.nome_local

--Master EA
UNION ALL

select 
	'Exportação Aérea' as Modal, dst.nome_local,cast(sum(dbo.valor(cta.vlr_pgto_nf_mea,cta.dc_mea)) as money) from cta_cte_mas_exp_aer cta

inner join master_exp_aer mas on (mas.num_proc_mea=cta.num_proc_mea)
inner join localidade dst on (dst.cd_local=mas.cd_org_mea)
inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_mea and nf.ref_acesso=ref_acesso_nf_mea)

where 

	nf.emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105) and nome_local like @local

group by 
	dst.nome_local

UNION ALL
--House EM

select 
	'Exportação Marítima' as Modal,dst.nome_local,cast(sum(dbo.valor(cta.vlr_pgto_nf_hem,cta.dc_hem)) as money) from cta_cte_hou_exp_mar cta

inner join house_exp_mar hou on (hou.num_proc_hem=cta.num_proc_hem)
inner join localidade dst on (dst.cd_local=hou.cd_org_hem)
inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_hem and nf.ref_acesso=ref_acesso_nf_hem)

where 

	nf.emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105) and nome_local like @local

group by 
	
	dst.nome_local

UNION ALL
--Master EM

select 
	'Exportação Marítima' as Modal,dst.nome_local,cast(sum(dbo.valor(cta.vlr_pgto_nf_mem,cta.dc_mem)) as money) 

from 
	cta_cte_mas_exp_mar cta

inner join master_exp_mar mas on (mas.num_proc_mem=cta.num_proc_mem)
inner join localidade dst on (dst.cd_local=mas.cd_org_mem)
inner join base_nota_fiscal nf on (nf.nota_fiscal=cta.num_nf_mem and nf.ref_acesso=ref_acesso_nf_mem)

where 

	nf.emissao between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105) and nome_local like @local

group by 
	dst.nome_local






GO
