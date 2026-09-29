SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO















CREATE                 view VWCta_Cte_CONT

AS


select 
	Cta.Num_proc_HEA, cta.cd_tp_tx,dt_ins_HEA, nome_Tp_tx, cta.dc_hea,cta.cd_tp_moeda, 
	vlr_org_HEA, Tx_Refer_MEA
from 
	ctA_cte_hou_EXP_aer CTA
	Left Join Caixa_hou_EXP_aer CXA on CTA.num_proc_HEA=CXA.num_proc_HEA and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_HEA=cxa.dc_HEA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_HEA,105) between '01-01-2006' and '11-30-2006' 
	Join master_EXP_aer MAS on MAS.num_proc_MEA=left(cta.num_proc_HEA,14)
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
	Left Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_hea and ref_acesso=ref_Acesso_nf_hea and emissao <= '11-30-2006'
	lEFT jOIN pgto_Rcto PG on CXA.num_lcto=PG.num_lcto 
Where
	convert(datetime,dt_ins_HEA,105) between '01-01-2006' and '11-30-2006'
	and Desp_DST_HEA='N' --and Emissao is null
	-- and cxa.num_proC_HEA is null  and Desp_DST_HEA='N' and emissao is null
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)	
	and pg.num_lcto is null

UNION ALL


select 
	Cta.Num_proc_MEA, cta.cd_tp_tx,dt_ins_MEA, nome_Tp_tx,cta.dc_mea, cta.cd_tp_moeda, 
	vlr_org_MEA, Tx_Refer_MEA 
from 
	ctA_cte_MAS_EXP_AER CTA
	Left Join Caixa_MAS_EXP_aer CXA on CTA.num_proc_MEA=CXA.num_proc_MEA and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_MEA=cxa.dc_MEA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_MEA,105) between '01-01-2006' and '11-30-2006'
	Join master_EXP_aer MAS on MAS.num_proc_MEA=cta.num_proc_MEA
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
	Left Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_mea and ref_acesso=ref_Acesso_nf_mea and emissao <= '11-30-2006'
	lEFT jOIN pgto_Rcto PG on CXA.num_lcto=PG.num_lcto 
Where
	convert(datetime,dt_ins_MEA,105) between '01-01-2006' and '11-30-2006'
	and Desp_DST_MEA='N' --and Emissao is null
	--and cxa.num_proC_MEA is null and  Desp_DST_MEA='N' and Emissao is null
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)	
	and pg.num_lcto is null
	
UNION ALL

select 
	Cta.Num_proc_hia, cta.cd_tp_tx,dt_ins_hia, nome_Tp_tx, cta.dc_hia,cta.cd_tp_moeda, 
	vlr_org_hia, par_moeda 
from 
	ctA_cte_hou_imp_aer CTA
	Left Join Caixa_hou_imp_aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hia,105) <='11-30-2006'
	Join master_imp_aer MAS on MAS.num_proc_mia=left(cta.num_proc_hia,14)
	Left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMA' and dt_par=dt_ins_hia
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
	Left Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_hia and ref_acesso=ref_Acesso_nf_hia and emissao <='11-30-2006'
	lEFT jOIN pgto_Rcto PG on CXA.num_lcto=PG.num_lcto 
Where
	convert(datetime,dt_ins_hia,105) between '01-01-2006' and '11-30-2006'
	and cxa.num_proC_hia is null and Desp_Org_HIA='N' --and Emissao is null
	--and Desp_Org_HIA='N' and emissao is null
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)	
	and pg.num_lcto is null

union all

select 
	Cta.Num_proc_him, cta.cd_tp_tx,dt_ins_him, nome_Tp_tx, cta.dc_him, cta.cd_tp_moeda, 
	vlr_org_him, par_moeda 
from 
	ctA_cte_hou_imp_mar CTA
	Left Join Caixa_hou_imp_mar CXA on CTA.num_proc_him=CXA.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_him,105) between '01-01-2006' and '11-30-2006'
	Join master_imp_mar MAS on MAS.num_proc_mim=left(cta.num_proc_him,14)
	Left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMM' and dt_par=dt_ins_him
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
	Left Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_him and ref_acesso=ref_Acesso_nf_him and emissao <= '11-30-2006'
	lEFT jOIN pgto_Rcto PG on CXA.num_lcto=PG.num_lcto 
Where
	convert(datetime,dt_ins_him,105) between '01-01-2006' and '11-30-2006'
	and Desp_Org_him='N' --and Emissao is null
	--and Desp_Org_him='N' and emissao is null
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)	
	and pg.num_lcto is null 

UNION ALL

select 
	Cta.Num_proc_Mia, cta.cd_tp_tx,dt_ins_Mia, nome_Tp_tx, cta.dc_mia ,cta.cd_tp_moeda, 
	vlr_org_Mia, par_moeda 
from 
	ctA_cte_MAS_imp_AER CTA
	Left Join Caixa_MAS_imp_aer CXA on CTA.num_proc_Mia=CXA.num_proc_Mia and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_Mia=cxa.dc_Mia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_Mia,105) between '01-01-2006' and '11-30-2006'
	Join master_imp_aer MAS on MAS.num_proc_mia=cta.num_proc_Mia
	Left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMA' and dt_par=dt_ins_Mia
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
	Left Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_mia and ref_acesso=ref_Acesso_nf_mia and emissao <= '11-30-2006'
	lEFT jOIN pgto_Rcto PG on CXA.num_lcto=PG.num_lcto 
Where
	convert(datetime,dt_ins_Mia,105) between '01-01-2006' and '11-30-2006'
	and Desp_Org_MIA='N' --and Emissao is null
	--and Desp_Org_MIA='N' and Emissao is null
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)	
	and pg.num_lcto is null

union all

select 
	Cta.Num_proc_MIM, cta.cd_tp_tx,dt_ins_MIM, nome_Tp_tx, cta.dc_mim, cta.cd_tp_moeda, 
	vlr_org_MIM, par_moeda 
from 
	ctA_cte_MAS_imp_MAR CTA
	Left Join Caixa_MAS_imp_MAR CXA on CTA.num_proc_MIM=CXA.num_proc_MIM and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_MIM=cxa.dc_MIM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_MIM,105) between '01-01-2006' and '11-30-2006'
	Join master_imp_MAR MAS on MAS.num_proc_MIM=cta.num_proc_MIM
	Left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMM' and dt_par=dt_ins_MIM
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
	Left Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_mim and ref_acesso=ref_Acesso_nf_mim and emissao <= '11-30-2006'
	lEFT jOIN pgto_Rcto PG on CXA.num_lcto=PG.num_lcto 
Where
	convert(datetime,dt_ins_MIM,105) between '01-01-2006' and '11-30-2006'
	and Desp_Org_MIM='N' --and Emissao is null
	--and Desp_Org_MIM='N' and Emissao is null
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)	
	and pg.num_lcto is null

UNION ALL

select 
	Cta.Num_proc_MEM, cta.cd_tp_tx,dt_ins_MEM, nome_Tp_tx, cta.dc_mem, cta.cd_tp_moeda, 
	vlr_org_MEM, par_moeda 
from 
	ctA_cte_MAS_EXP_MAR CTA
	Left Join Caixa_MAS_EXP_MAR CXA on CTA.num_proc_MEM=CXA.num_proc_MEM and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_MEM=cxa.dc_MEM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_MEM,105) between '01-01-2006' and '11-30-2006'
	Join master_EXP_MAR MAS on MAS.num_proc_MEM=cta.num_proc_MEM
	Left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and dt_par=dt_ins_MEM
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
	Left Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_mem and ref_acesso=ref_Acesso_nf_mem and emissao <= '11-30-2006'
	lEFT jOIN pgto_Rcto PG on CXA.num_lcto=PG.num_lcto and num_ctA_cte <> '005'
Where
	convert(datetime,dt_ins_MEM,105) between '01-01-2006' and '11-30-2006'
	and Desp_dst_MEM='N' --and Emissao is null
	--and Desp_dst_MEM='N' and Emissao is null
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)	
	and pg.num_lcto is null 

UNION ALL

select 
	Cta.Num_proc_hem, cta.cd_tp_tx,dt_ins_hem, nome_Tp_tx, cta.dc_hem, cta.cd_tp_moeda, 
	vlr_org_hem, Par_moeda
from 
	ctA_cte_hou_EXP_mar CTA
	Left Join Caixa_hou_EXP_mar CXA on CTA.num_proc_hem=CXA.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hem,105) between '01-01-2006' and '11-30-2006'
	Join master_EXP_mar MAS on MAS.num_proc_mem=left(cta.num_proc_hem,14)
	Left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and dt_par=dt_ins_hem
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
	Left Join Base_Nota_Fiscal NF on NF.Nota_Fiscal=cta.num_nf_hem and ref_acesso=ref_Acesso_nf_hem and emissao <= '11-30-2006'
	lEFT jOIN pgto_Rcto PG on CXA.num_lcto=PG.num_lcto and num_CtA_cte <> '005'
Where
	convert(datetime,dt_ins_hem,105) between '01-01-2006' and '11-30-2006'
	and Desp_DST_hem='N' --and Emissao is null
	--and Desp_DST_hem='N' and Emissao is null
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)	
	and pg.num_lcto is null












GO
