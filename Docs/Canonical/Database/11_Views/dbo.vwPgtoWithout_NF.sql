SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View vwPgtoWithout_NF

as
select left(cxa.num_lcto,1) Tipo, cxa.dc_hia, sum(vlr_pgto_rcto_hia) Valor, right(dt_ins_hia,4)  Ano,left(Num_rcb_hia,2) RA,isnull(nf.nota_fiscal,'Sem')  NF from caixa_hou_imp_aer CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_hou_imp_aer CTA on CXA.num_proC_hia=CTa.num_proc_hia and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_hia=CTa.dc_hia
Left Join Base_Nota_fiscal NF on NF.notA_fiscal=cta.num_Nf_hia and ref_acesso=ref_Acesso_nf_hia and emissao between '01-01-2006' and '01-31-2006'
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_hia,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125') and (cta.num_nf_hia is null or (emissao is not null and cta.num_nf_hia is not null or convert(datetime,dt_ins_hia,105 ) >='01-01-2006'))
Group by right(dt_ins_hia,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_hia,left(Num_rcb_hia,2) , nf.nota_fiscal 


union all


select left(cxa.num_lcto,1) Tipo, cxa.dc_hea, sum(vlr_pgto_rcto_hea) Valor, right(dt_ins_hea,4)  Ano,left(Num_rcb_hea,2) RA,isnull(nf.nota_fiscal,'Sem')  NF from caixa_hou_exp_aer CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_hou_exp_aer CTA on CXA.num_proC_hea=CTa.num_proc_hea and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_hea=CTa.dc_hea
Left Join Base_Nota_fiscal NF on NF.notA_fiscal=cta.num_Nf_hea and ref_acesso=ref_Acesso_nf_hea and emissao between '01-01-2006' and '01-31-2006'
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_hea,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125') and (cta.num_nf_hea is null or (emissao is not null and cta.num_nf_hea is not null or convert(datetime,dt_ins_hea,105 ) >='01-01-2006'))
Group by right(dt_ins_hea,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_hea,left(Num_rcb_hea,2) , nf.nota_fiscal 


union all


select left(cxa.num_lcto,1) Tipo, cxa.dc_him, sum(vlr_pgto_rcto_him) Valor, right(dt_ins_him,4)  Ano,left(Num_rcb_him,2) RA,isnull(nf.nota_fiscal,'Sem')  NF from caixa_hou_imp_mar CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_hou_imp_mar CTA on CXA.num_proC_him=CTa.num_proc_him and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_him=CTa.dc_him
Left Join Base_Nota_fiscal NF on NF.notA_fiscal=cta.num_Nf_him and ref_acesso=ref_Acesso_nf_him and emissao between '01-01-2006' and '01-31-2006'
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_him,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125') and (cta.num_nf_him is null or (emissao is not null and cta.num_nf_him is not null or convert(datetime,dt_ins_him,105 ) >='01-01-2006'))
Group by right(dt_ins_him,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_him,left(Num_rcb_him,2) , nf.nota_fiscal 


union all


select left(cxa.num_lcto,1) Tipo, cxa.dc_hem, sum(vlr_pgto_rcto_hem) Valor, right(dt_ins_hem,4)  Ano,left(Num_rcb_hem,2) RA,isnull(nf.nota_fiscal,'Sem')  NF from caixa_hou_exp_mar CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_hou_exp_mar CTA on CXA.num_proC_hem=CTa.num_proc_hem and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_hem=CTa.dc_hem
Left Join Base_Nota_fiscal NF on NF.notA_fiscal=cta.num_Nf_hem and ref_acesso=ref_Acesso_nf_hem and emissao between '01-01-2006' and '01-31-2006'
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_hem,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125') and (cta.num_nf_hem is null or (emissao is not null and cta.num_nf_hem is not null or convert(datetime,dt_ins_hem,105 ) >='01-01-2006'))
Group by right(dt_ins_hem,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_hem,left(Num_rcb_hem,2) , nf.nota_fiscal 



UNION ALL


select left(cxa.num_lcto,1) Tipo, cxa.dc_mia, sum(vlr_pgto_rcto_mia) Valor, right(dt_ins_mia,4)  Ano,left(Num_rcb_mia,2) RA,isnull(nf.nota_fiscal,'Sem')  NF from caixa_mas_imp_aer CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_mas_imp_aer CTA on CXA.num_proC_mia=CTa.num_proc_mia and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_mia=CTa.dc_mia
Left Join Base_Nota_fiscal NF on NF.notA_fiscal=cta.num_Nf_mia and ref_acesso=ref_Acesso_nf_mia and emissao between '01-01-2006' and '01-31-2006'
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_mia,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125') and (cta.num_nf_mia is null or (emissao is not null and cta.num_nf_mia is not null or convert(datetime,dt_ins_mia,105 ) >='01-01-2006'))
Group by right(dt_ins_mia,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_mia,left(Num_rcb_mia,2) , nf.nota_fiscal 


union all


select left(cxa.num_lcto,1) Tipo, cxa.dc_mea, sum(vlr_pgto_rcto_mea) Valor, right(dt_ins_mea,4)  Ano,left(Num_rcb_mea,2) RA,isnull(nf.nota_fiscal,'Sem')  NF from caixa_mas_exp_aer CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_mas_exp_aer CTA on CXA.num_proC_mea=CTa.num_proc_mea and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_mea=CTa.dc_mea
Left Join Base_Nota_fiscal NF on NF.notA_fiscal=cta.num_Nf_mea and ref_acesso=ref_Acesso_nf_mea and emissao between '01-01-2006' and '01-31-2006'
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_mea,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125') and (cta.num_nf_mea is null or (emissao is not null and cta.num_nf_mea is not null or convert(datetime,dt_ins_mea,105 ) >='01-01-2006'))
Group by right(dt_ins_mea,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_mea,left(Num_rcb_mea,2) , nf.nota_fiscal 


union all


select left(cxa.num_lcto,1) Tipo, cxa.dc_mim, sum(vlr_pgto_rcto_mim) Valor, right(dt_ins_mim,4)  Ano,left(Num_rcb_mim,2) RA,isnull(nf.nota_fiscal,'Sem')  NF from caixa_mas_imp_mar CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_mas_imp_mar CTA on CXA.num_proC_mim=CTa.num_proc_mim and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_mim=CTa.dc_mim
Left Join Base_Nota_fiscal NF on NF.notA_fiscal=cta.num_Nf_mim and ref_acesso=ref_Acesso_nf_mim and emissao between '01-01-2006' and '01-31-2006'
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_mim,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125') and (cta.num_nf_mim is null or (emissao is not null and cta.num_nf_mim is not null or convert(datetime,dt_ins_mim,105 ) >='01-01-2006'))
Group by right(dt_ins_mim,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_mim,left(Num_rcb_mim,2) , nf.nota_fiscal 


union all


select left(cxa.num_lcto,1) Tipo, cxa.dc_mem, sum(vlr_pgto_rcto_mem) Valor, right(dt_ins_mem,4)  Ano,left(Num_rcb_mem,2) RA,isnull(nf.nota_fiscal,'Sem')  NF from caixa_mas_exp_mar CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_mas_exp_mar CTA on CXA.num_proC_mem=CTa.num_proc_mem and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_mem=CTa.dc_mem
Left Join Base_Nota_fiscal NF on NF.notA_fiscal=cta.num_Nf_mem and ref_acesso=ref_Acesso_nf_mem and emissao between '01-01-2006' and '01-31-2006'
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_mem,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125') and (cta.num_nf_mem is null or (emissao is not null and cta.num_nf_mem is not null or convert(datetime,dt_ins_mem,105 ) >='01-01-2006'))
Group by right(dt_ins_mem,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_mem,left(Num_rcb_mem,2) , nf.nota_fiscal 


GO
