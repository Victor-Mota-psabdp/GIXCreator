SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  view vwSaldos
as
select cta.num_proc_hia,cta.cd_Tp_tx,nome_Tp_Tx,cta.cd_tp_moeda,vlr_contab,isnull(emissao,'01-12-2005') EMI ,vlr_pgto_nf_hia from ctA_ctE_hou_imp_aer CTA
Left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMA' and dt_par=dt_ins_hia
Left Join Caixa_hou_imp_Aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_Tp_Tx=CXA.cd_Tp_tx and CTA.dc_hia=CXA.dc_hia and convert(Datetime,dt_pgto_rcto_hia,105)<='01-31-2006' and cxa.num_lcto <> 'Provisório'
Left Join base_nota_fiscal NF on NF.nota_fiscal=cta.num_nf_hia and ref_Acesso=ref_acesso_nf_hia and emissao <='01-31-2006'
Join Tipo_Taxa TT on TT.cd_Tp_TX=CTa.cd_Tp_TX
Left Join Pgto_rcto PG on CXa.num_lcto=PG.num_lcto and num_ctA_Cte <> '007'
Where converT(datetime,dt_ins_hia, 105) between '01-01-2006' and '01-31-2006'
and Desp_Org_HIA='N'
and pg.num_lcto is null
and cta.cd_tp_Tx not in ('143','149','ADT')
and cta.dc_hia='C'


UNION ALL


select cta.num_proc_hea,cta.cd_Tp_tx,nome_Tp_Tx,cta.cd_tp_moeda,vlr_contab,isnull(emissao,'01-12-2005') EMI ,vlr_pgto_nf_hea from ctA_ctE_hou_exp_aer CTA
Left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMA' and dt_par=dt_ins_hea
Left Join Caixa_hou_exp_Aer CXA on CTA.num_proc_hea=CXA.num_proc_hea and CTA.cd_Tp_Tx=CXA.cd_Tp_tx and CTA.dc_hea=CXA.dc_hea and convert(Datetime,dt_pgto_rcto_hea,105)<='01-31-2006' and cxa.num_lcto <> 'Provisório'
Left Join base_nota_fiscal NF on NF.nota_fiscal=cta.num_nf_hea and ref_Acesso=ref_acesso_nf_hea and emissao <='01-31-2006'
Join Tipo_Taxa TT on TT.cd_Tp_TX=CTa.cd_Tp_TX
Left Join Pgto_rcto PG on CXa.num_lcto=PG.num_lcto and num_ctA_Cte <> '007'
Where converT(datetime,dt_ins_hea, 105) between '01-01-2006' and '01-31-2006'
and Desp_DST_hea='N'
and pg.num_lcto is null
and cta.cd_tp_Tx not in ('143','149','ADT')
and cta.dc_hea='C'

union all


select cta.num_proc_him,cta.cd_Tp_tx,nome_Tp_Tx,cta.cd_tp_moeda,vlr_contab,isnull(emissao,'01-12-2005') EMI ,vlr_pgto_nf_HIM from ctA_ctE_hou_imp_MAR CTA
Left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMA' and dt_par=dt_ins_HIM
Left Join Caixa_hou_imp_MAR CXA on CTA.num_proc_HIM=CXA.num_proc_HIM and CTA.cd_Tp_Tx=CXA.cd_Tp_tx and CTA.dc_HIM=CXA.dc_HIM and convert(Datetime,dt_pgto_rcto_HIM,105)<='01-31-2006' and cxa.num_lcto <> 'Provisório'
Left Join base_nota_fiscal NF on NF.nota_fiscal=cta.num_nf_HIM and ref_Acesso=ref_acesso_nf_HIM and emissao <='01-31-2006'
Join Tipo_Taxa TT on TT.cd_Tp_TX=CTa.cd_Tp_TX
Left Join Pgto_rcto PG on CXa.num_lcto=PG.num_lcto and num_ctA_Cte <> '007'
Where converT(datetime,dt_ins_HIM, 105) between '01-01-2006' and '01-31-2006'
and Desp_Org_HIM='N'
and pg.num_lcto is null
and cta.cd_tp_Tx not in ('143','149','ADT')
and cta.dc_HIM='C'


UNION ALL


select cta.num_proc_hem,cta.cd_Tp_tx,nome_Tp_Tx,cta.cd_tp_moeda,vlr_contab,isnull(emissao,'01-12-2005') EMI ,vlr_pgto_nf_HEM from ctA_ctE_hou_exp_MAR CTA
Left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMA' and dt_par=dt_ins_HEM
Left Join Caixa_hou_exp_MAR CXA on CTA.num_proc_HEM=CXA.num_proc_HEM and CTA.cd_Tp_Tx=CXA.cd_Tp_tx and CTA.dc_HEM=CXA.dc_HEM and convert(Datetime,dt_pgto_rcto_HEM,105)<='01-31-2006' and cxa.num_lcto <> 'Provisório'
Left Join base_nota_fiscal NF on NF.nota_fiscal=cta.num_nf_HEM and ref_Acesso=ref_acesso_nf_HEM and emissao <='01-31-2006'
Join Tipo_Taxa TT on TT.cd_Tp_TX=CTa.cd_Tp_TX
Left Join Pgto_rcto PG on CXa.num_lcto=PG.num_lcto and num_ctA_Cte <> '007'
Where converT(datetime,dt_ins_HEM, 105) between '01-01-2006' and '01-31-2006'
and Desp_DST_HEM='N'
and pg.num_lcto is null
and cta.cd_tp_Tx not in ('143','149','ADT')
and cta.dc_HEM='C'


UNION ALL

select cta.num_proc_mia, cta.cd_Tp_tx,nome_Tp_Tx,cta.cd_tp_moeda,vlr_contab,isnull(emissao,'01-12-2005') EMI ,vlr_pgto_nf_mia from ctA_ctE_mas_imp_aer CTA
Left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMA' and dt_par=dt_ins_mia
Left Join Caixa_mas_imp_Aer CXA on CTA.num_proc_mia=CXA.num_proc_mia and CTA.cd_Tp_Tx=CXA.cd_Tp_tx and CTA.dc_mia=CXA.dc_mia and convert(Datetime,dt_pgto_rcto_mia,105)<='01-31-2006' and cxa.num_lcto <> 'Provisório'
Left Join base_nota_fiscal NF on NF.nota_fiscal=cta.num_nf_mia and ref_Acesso=ref_acesso_nf_mia and emissao <='01-31-2006'
Join Tipo_Taxa TT on TT.cd_Tp_TX=CTa.cd_Tp_TX
Left Join Pgto_rcto PG on CXa.num_lcto=PG.num_lcto and num_ctA_Cte <> '007'
Where converT(datetime,dt_ins_mia, 105) between '01-01-2006' and '01-31-2006'
and Desp_Org_mia='N'
and pg.num_lcto is null
and cta.cd_tp_Tx not in ('143','149','ADT')
and cta.dc_mia='C'


UNION ALL


select cta.num_proc_mea,cta.cd_Tp_tx,nome_Tp_Tx,cta.cd_tp_moeda,vlr_contab,isnull(emissao,'01-12-2005') EMI ,vlr_pgto_nf_mea from ctA_ctE_mas_exp_aer CTA
Left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMA' and dt_par=dt_ins_mea
Left Join Caixa_mas_exp_Aer CXA on CTA.num_proc_mea=CXA.num_proc_mea and CTA.cd_Tp_Tx=CXA.cd_Tp_tx and CTA.dc_mea=CXA.dc_mea and convert(Datetime,dt_pgto_rcto_mea,105)<='01-31-2006' and cxa.num_lcto <> 'Provisório'
Left Join base_nota_fiscal NF on NF.nota_fiscal=cta.num_nf_mea and ref_Acesso=ref_acesso_nf_mea and emissao <='01-31-2006'
Join Tipo_Taxa TT on TT.cd_Tp_TX=CTa.cd_Tp_TX
Left Join Pgto_rcto PG on CXa.num_lcto=PG.num_lcto and num_ctA_Cte <> '007'
Where converT(datetime,dt_ins_mea, 105) between '01-01-2006' and '01-31-2006'
and Desp_DST_mea='N'
and pg.num_lcto is null
and cta.cd_tp_Tx not in ('143','149','ADT')
and cta.dc_mea='C'

union all


select cta.num_proc_mim, cta.cd_Tp_tx,nome_Tp_Tx,cta.cd_tp_moeda,vlr_contab,isnull(emissao,'01-12-2005') EMI ,vlr_pgto_nf_mim from ctA_ctE_mas_imp_MAR CTA
Left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMA' and dt_par=dt_ins_mim
Left Join Caixa_mas_imp_MAR CXA on CTA.num_proc_mim=CXA.num_proc_mim and CTA.cd_Tp_Tx=CXA.cd_Tp_tx and CTA.dc_mim=CXA.dc_mim and convert(Datetime,dt_pgto_rcto_mim,105)<='01-31-2006' and cxa.num_lcto <> 'Provisório'
Left Join base_nota_fiscal NF on NF.nota_fiscal=cta.num_nf_mim and ref_Acesso=ref_acesso_nf_mim and emissao <='01-31-2006'
Join Tipo_Taxa TT on TT.cd_Tp_TX=CTa.cd_Tp_TX
Left Join Pgto_rcto PG on CXa.num_lcto=PG.num_lcto and num_ctA_Cte <> '007'
Where converT(datetime,dt_ins_mim, 105) between '01-01-2006' and '01-31-2006'
and Desp_Org_mim='N'
and pg.num_lcto is null
and cta.cd_tp_Tx not in ('143','149','ADT')
and cta.dc_mim='C'


UNION ALL


select cta.num_proc_mem, cta.cd_Tp_tx,nome_Tp_Tx,cta.cd_tp_moeda,vlr_contab,isnull(emissao,'01-12-2005') EMI ,vlr_pgto_nf_mem from ctA_ctE_mas_exp_MAR CTA
Left Join Paridade PAR on cta.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='IMA' and dt_par=dt_ins_mem
Left Join Caixa_mas_exp_MAR CXA on CTA.num_proc_mem=CXA.num_proc_mem and CTA.cd_Tp_Tx=CXA.cd_Tp_tx and CTA.dc_mem=CXA.dc_mem and convert(Datetime,dt_pgto_rcto_mem,105)<='01-31-2006' and cxa.num_lcto <> 'Provisório'
Left Join base_nota_fiscal NF on NF.nota_fiscal=cta.num_nf_mem and ref_Acesso=ref_acesso_nf_mem and emissao <='01-31-2006'
Join Tipo_Taxa TT on TT.cd_Tp_TX=CTa.cd_Tp_TX
Left Join Pgto_rcto PG on CXa.num_lcto=PG.num_lcto and num_ctA_Cte <> '007'
Where converT(datetime,dt_ins_mem, 105) between '01-01-2006' and '01-31-2006'
and Desp_DST_mem='N'
and pg.num_lcto is null
and cta.cd_tp_Tx not in ('143','149','ADT')
and cta.dc_mem='C'



GO
