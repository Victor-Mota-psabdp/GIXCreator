SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure spPagtos2005 as



select 
	cta.cd_tp_tx,nome_tp_Tx, cta.dc_hia, vlr_pgto_Rcto_hia, isdate(emissao) NF, year(emissao) ano, vlr_pgto_nf_hia 
from 
	caixa_hou_imp_Aer CXA
	Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
	Join ctA_Cte_hou_imp_aer CTA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
	Left Join Base_Nota_Fiscal NF on NF.notA_fiscal=cta.num_nf_hia and ref_Acesso=ref_Acesso_nf_hia and emissao <='02-28-2006'
Where 
	converT(datetime,dt_ins_hia,105) < '01-01-2006' and convert(Datetime,dt_pgto_rcto_hia,105) between '01-01-2006' and '02-28-2006'
	and num_lcto <> 'PROVISÓRIO'
	and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')

UNION ALL


select 
	cta.cd_tp_tx,nome_tp_Tx, cta.dc_mia, vlr_pgto_Rcto_mia, isdate(emissao) NF, year(emissao) ano, vlr_pgto_nf_mia 
from 
	caixa_mas_imp_Aer CXA
	Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
	Join ctA_Cte_mas_imp_aer CTA on CTA.num_proc_mia=CXA.num_proc_mia and CTA.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia
	Left Join Base_Nota_Fiscal NF on NF.notA_fiscal=cta.num_nf_mia and ref_Acesso=ref_Acesso_nf_mia and emissao <='02-28-2006'
Where 
	converT(datetime,dt_ins_mia,105) < '01-01-2006' and convert(Datetime,dt_pgto_rcto_mia,105) between '01-01-2006' and '02-28-2006'
	and num_lcto <> 'PROVISÓRIO'
	and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')

union all

select
	cta.cd_tp_tx,nome_tp_Tx, cta.dc_HEA, vlr_pgto_Rcto_HEA, isdate(emissao) NF, year(emissao) ano, vlr_pgto_nf_HEA 
from 
	caixa_hou_EXP_Aer CXA
	Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
	Join ctA_Cte_hou_EXP_aer CTA on CTA.num_proc_HEA=CXA.num_proc_HEA and CTA.cd_tp_tx=cxa.cd_tp_tx and cta.dc_HEA=cxa.dc_HEA
	Left Join Base_Nota_Fiscal NF on NF.notA_fiscal=cta.num_nf_HEA and ref_Acesso=ref_Acesso_nf_HEA and emissao <='02-28-2006'
Where 
	converT(datetime,dt_ins_HEA,105) < '01-01-2006' and convert(Datetime,dt_pgto_rcto_HEA,105) between '01-01-2006' and '02-28-2006'
	and num_lcto <> 'PROVISÓRIO'
	and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')

UNION ALL


select 
	cta.cd_tp_tx,nome_tp_Tx, cta.dc_MEA, vlr_pgto_Rcto_MEA, isdate(emissao) NF, year(emissao) ano, vlr_pgto_nf_MEA 
from 
	caixa_mas_EXP_Aer CXA
	Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
	Join ctA_Cte_mas_EXP_aer CTA on CTA.num_proc_MEA=CXA.num_proc_MEA and CTA.cd_tp_tx=cxa.cd_tp_tx and cta.dc_MEA=cxa.dc_MEA
	Left Join Base_Nota_Fiscal NF on NF.notA_fiscal=cta.num_nf_MEA and ref_Acesso=ref_Acesso_nf_MEA and emissao <='02-28-2006'
Where 
	converT(datetime,dt_ins_MEA,105) < '01-01-2006' and convert(Datetime,dt_pgto_rcto_MEA,105) between '01-01-2006' and '02-28-2006'
	and num_lcto <> 'PROVISÓRIO'
	and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')
union all




select 
	cta.cd_tp_tx,nome_tp_Tx, cta.dc_him, vlr_pgto_Rcto_him, isdate(emissao) NF, year(emissao) ano, vlr_pgto_nf_him 
from 
	caixa_hou_imp_mar CXA
	Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
	Join ctA_Cte_hou_imp_mar CTA on CTA.num_proc_him=CXA.num_proc_him and CTA.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him
	Left Join Base_Nota_Fiscal NF on NF.notA_fiscal=cta.num_nf_him and ref_Acesso=ref_Acesso_nf_him and emissao <='02-28-2006'
Where 
	converT(datetime,dt_ins_him,105) < '01-01-2006' and convert(Datetime,dt_pgto_rcto_him,105) between '01-01-2006' and '02-28-2006'
	and num_lcto <> 'PROVISÓRIO'
	and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')

UNION ALL


select 
	cta.cd_tp_tx,nome_tp_Tx, cta.dc_mim, vlr_pgto_Rcto_mim, isdate(emissao) NF, year(emissao) ano, vlr_pgto_nf_mim 
from 
	caixa_mas_imp_mar CXA
	Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
	Join ctA_Cte_mas_imp_mar CTA on CTA.num_proc_mim=CXA.num_proc_mim and CTA.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim
	Left Join Base_Nota_Fiscal NF on NF.notA_fiscal=cta.num_nf_mim and ref_Acesso=ref_Acesso_nf_mim and emissao <='02-28-2006'
Where 
	converT(datetime,dt_ins_mim,105) < '01-01-2006' and convert(Datetime,dt_pgto_rcto_mim,105) between '01-01-2006' and '02-28-2006'
	and num_lcto <> 'PROVISÓRIO'
	and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')

union all

select
	cta.cd_tp_tx,nome_tp_Tx, cta.dc_hem, vlr_pgto_Rcto_hem, isdate(emissao) NF, year(emissao) ano, vlr_pgto_nf_hem 
from 
	caixa_hou_EXP_mar CXA
	Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
	Join ctA_Cte_hou_EXP_mar CTA on CTA.num_proc_hem=CXA.num_proc_hem and CTA.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hem
	Left Join Base_Nota_Fiscal NF on NF.notA_fiscal=cta.num_nf_hem and ref_Acesso=ref_Acesso_nf_hem and emissao <='02-28-2006'
Where 
	converT(datetime,dt_ins_hem,105) < '01-01-2006' and convert(Datetime,dt_pgto_rcto_hem,105) between '01-01-2006' and '02-28-2006'
	and num_lcto <> 'PROVISÓRIO'
	and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')

UNION ALL


select 
	cta.cd_tp_tx,nome_tp_Tx, cta.dc_mem, vlr_pgto_Rcto_mem, isdate(emissao) NF, year(emissao) ano, vlr_pgto_nf_mem 
from 
	caixa_mas_EXP_mar CXA
	Join Tipo_Taxa TT on TT.cd_tp_tx=cxa.cd_tp_tx
	Join ctA_Cte_mas_EXP_mar CTA on CTA.num_proc_mem=CXA.num_proc_mem and CTA.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem
	Left Join Base_Nota_Fiscal NF on NF.notA_fiscal=cta.num_nf_mem and ref_Acesso=ref_Acesso_nf_mem and emissao <='02-28-2006'
Where 
	converT(datetime,dt_ins_mem,105) < '01-01-2006' and convert(Datetime,dt_pgto_rcto_mem,105) between '01-01-2006' and '02-28-2006'
	and num_lcto <> 'PROVISÓRIO'
	and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')


GO
