SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    VIEW VWcl2005
AS
select cxa.num_rcb_hea,cxa.num_lcto,CTA.NUM_PROC_hea, NOME_TP_TX, isnull(pg.num_lcto, 'CF') CC, VLR_PGTO_RCTO_hea, EMISSAO, VLR_PGTO_NF_hea from ctA_ctE_hou_exp_aer CTA
lEFT Join Base_notA_fiscal NF on NF.notA_fiscal=cta.num_nf_hea and ref_Acesso=ref_Acesso_nf_hea and emissao <='01-31-2006'
Left Join Caixa_hou_exp_AEr CXA on cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_Tp_tx and cta.dc_hea=cxa.dc_hea and cxa.num_lcto <> 'PROVISÓRIO'
jOIN tIPO_TAXA tt ON TT.CD_TP_TX=CTA.CD_TP_TX
LEFT Join Pgto_rcto PG on PG.num_lcto=cxa.num_lcto and num_ctA_cte <> '007'
where convert(datetime,dt_pgto_rcto_hea,105) between '01-01-2006' and '01-31-2006'
and convert(Datetime,dt_ins_hea,105) <='12-31-2005'
AND CTA.DC_hea='D'
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	

UNION ALL

select cxa.num_rcb_hia,cxa.num_lcto,CTA.NUM_PROC_hia, NOME_TP_TX, isnull(pg.num_lcto, 'CF') CC, VLR_PGTO_RCTO_hia, EMISSAO, VLR_PGTO_NF_hia from ctA_ctE_hou_imp_aer CTA
lEFT Join Base_notA_fiscal NF on NF.notA_fiscal=cta.num_nf_hia and ref_Acesso=ref_Acesso_nf_hia and emissao <='01-31-2006'
Left Join Caixa_hou_imp_AEr CXA on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_Tp_tx and cta.dc_hia=cxa.dc_hia and cxa.num_lcto <> 'PROVISÓRIO'
jOIN tIPO_TAXA tt ON TT.CD_TP_TX=CTA.CD_TP_TX
LEFT Join Pgto_rcto PG on PG.num_lcto=cxa.num_lcto and num_ctA_cte <> '007'
where convert(datetime,dt_pgto_rcto_hia,105) between '01-01-2006' and '01-31-2006'
and convert(Datetime,dt_ins_hia,105) <='12-31-2005'
AND CTA.DC_hia='D'
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
union all


select cxa.num_rcb_hem,cxa.num_lcto,CTA.NUM_PROC_HEM, NOME_TP_TX, isnull(pg.num_lcto, 'CF') CC, VLR_PGTO_RCTO_HEM, EMISSAO, VLR_PGTO_NF_HEM from ctA_ctE_hou_exp_MAR CTA
lEFT Join Base_notA_fiscal NF on NF.notA_fiscal=cta.num_nf_HEM and ref_Acesso=ref_Acesso_nf_HEM and emissao <='01-31-2006'
Left Join Caixa_hou_exp_MAR CXA on cta.num_proc_HEM=cxa.num_proc_HEM and cta.cd_tp_tx=cxa.cd_Tp_tx and cta.dc_HEM=cxa.dc_HEM and cxa.num_lcto <> 'PROVISÓRIO'
jOIN tIPO_TAXA tt ON TT.CD_TP_TX=CTA.CD_TP_TX
LEFT Join Pgto_rcto PG on PG.num_lcto=cxa.num_lcto and num_ctA_cte <> '007'
where convert(datetime,dt_pgto_rcto_HEM,105) between '01-01-2006' and '01-31-2006'
and convert(Datetime,dt_ins_HEM,105) <='12-31-2005'
AND CTA.DC_HEM='D'
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	

UNION ALL

select cxa.num_rcb_him,cxa.num_lcto, CTA.NUM_PROC_HIM, NOME_TP_TX, isnull(pg.num_lcto, 'CF') CC, VLR_PGTO_RCTO_HIM, EMISSAO, VLR_PGTO_NF_HIM from ctA_ctE_hou_imp_MAR CTA
lEFT Join Base_notA_fiscal NF on NF.notA_fiscal=cta.num_nf_HIM and ref_Acesso=ref_Acesso_nf_HIM and emissao <='01-31-2006'
Left Join Caixa_hou_imp_MAR CXA on cta.num_proc_HIM=cxa.num_proc_HIM and cta.cd_tp_tx=cxa.cd_Tp_tx and cta.dc_HIM=cxa.dc_HIM and cxa.num_lcto <> 'PROVISÓRIO'
jOIN tIPO_TAXA tt ON TT.CD_TP_TX=CTA.CD_TP_TX
LEFT Join Pgto_rcto PG on PG.num_lcto=cxa.num_lcto and num_ctA_cte <> '007'
where convert(datetime,dt_pgto_rcto_HIM,105) between '01-01-2006' and '01-31-2006'
and convert(Datetime,dt_ins_HIM,105) <='12-31-2005'
AND CTA.DC_HIM='D'
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	

UNION ALL

select cxa.num_rcb_mea,cxa.num_lcto,CTA.NUM_PROC_mea, NOME_TP_TX, isnull(pg.num_lcto, 'CF') CC, VLR_PGTO_RCTO_mea, EMISSAO, VLR_PGTO_NF_mea from ctA_ctE_mas_exp_aer CTA
lEFT Join Base_notA_fiscal NF on NF.notA_fiscal=cta.num_nf_mea and ref_Acesso=ref_Acesso_nf_mea and emissao <='01-31-2006'
Left Join Caixa_mas_exp_AEr CXA on cta.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_tx=cxa.cd_Tp_tx and cta.dc_mea=cxa.dc_mea and cxa.num_lcto <> 'PROVISÓRIO'
jOIN tIPO_TAXA tt ON TT.CD_TP_TX=CTA.CD_TP_TX
LEFT Join Pgto_rcto PG on PG.num_lcto=cxa.num_lcto and num_ctA_cte <> '007'
where convert(datetime,dt_pgto_rcto_mea,105) between '01-01-2006' and '01-31-2006'
and convert(Datetime,dt_ins_mea,105) <='12-31-2005'
AND CTA.DC_mea='D'
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	

UNION ALL

select cxa.num_rcb_mia,cxa.num_lcto,CTA.NUM_PROC_mia, NOME_TP_TX, isnull(pg.num_lcto, 'CF') CC, VLR_PGTO_RCTO_mia, EMISSAO, VLR_PGTO_NF_mia from ctA_ctE_mas_imp_aer CTA
lEFT Join Base_notA_fiscal NF on NF.notA_fiscal=cta.num_nf_mia and ref_Acesso=ref_Acesso_nf_mia and emissao <='01-31-2006'
Left Join Caixa_mas_imp_AEr CXA on cta.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_tx=cxa.cd_Tp_tx and cta.dc_mia=cxa.dc_mia and cxa.num_lcto <> 'PROVISÓRIO'
jOIN tIPO_TAXA tt ON TT.CD_TP_TX=CTA.CD_TP_TX
LEFT Join Pgto_rcto PG on PG.num_lcto=cxa.num_lcto and num_ctA_cte <> '007'
where convert(datetime,dt_pgto_rcto_mia,105) between '01-01-2006' and '01-31-2006'
and convert(Datetime,dt_ins_mia,105) <='12-31-2005'
AND CTA.DC_mia='D'
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	

union all


select cxa.num_rcb_mem,cxa.num_lcto,CTA.NUM_PROC_mem, NOME_TP_TX, isnull(pg.num_lcto, 'CF') CC, VLR_PGTO_RCTO_mem, EMISSAO, VLR_PGTO_NF_mem from ctA_ctE_mas_exp_MAR CTA
lEFT Join Base_notA_fiscal NF on NF.notA_fiscal=cta.num_nf_mem and ref_Acesso=ref_Acesso_nf_mem and emissao <='01-31-2006'
Left Join Caixa_mas_exp_MAR CXA on cta.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_Tp_tx and cta.dc_mem=cxa.dc_mem and cxa.num_lcto <> 'PROVISÓRIO'
jOIN tIPO_TAXA tt ON TT.CD_TP_TX=CTA.CD_TP_TX
LEFT Join Pgto_rcto PG on PG.num_lcto=cxa.num_lcto and num_ctA_cte <> '007'
where convert(datetime,dt_pgto_rcto_mem,105) between '01-01-2006' and '01-31-2006'
and convert(Datetime,dt_ins_mem,105) <='12-31-2005'
AND CTA.DC_mem='D'
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	

UNION ALL

select cxa.num_rcb_mim,cxa.num_lcto,CTA.NUM_PROC_mim, NOME_TP_TX, isnull(pg.num_lcto, 'CF') CC, VLR_PGTO_RCTO_mim, EMISSAO, VLR_PGTO_NF_mim from ctA_ctE_mas_imp_MAR CTA
lEFT Join Base_notA_fiscal NF on NF.notA_fiscal=cta.num_nf_mim and ref_Acesso=ref_Acesso_nf_mim and emissao <='01-31-2006'
Left Join Caixa_mas_imp_MAR CXA on cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_Tp_tx and cta.dc_mim=cxa.dc_mim and cxa.num_lcto <> 'PROVISÓRIO'
jOIN tIPO_TAXA tt ON TT.CD_TP_TX=CTA.CD_TP_TX
LEFT Join Pgto_rcto PG on PG.num_lcto=cxa.num_lcto and num_ctA_cte <> '007'
where convert(datetime,dt_pgto_rcto_mim,105) between '01-01-2006' and '01-31-2006'
and convert(Datetime,dt_ins_mim,105) <='12-31-2005'
AND CTA.DC_mim='D'
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	




GO
