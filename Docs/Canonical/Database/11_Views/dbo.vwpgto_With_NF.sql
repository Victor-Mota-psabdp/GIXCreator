SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW vwpgto_With_NF

as


select left(cxa.num_lcto,1) Tipo, cxa.dc_hia, sum(vlr_pgto_rcto_hia) Valor, right(dt_ins_hia,4)  Ano,left(Num_rcb_hia,2) RA  from caixa_hou_imp_aer CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_hou_imp_aer CTA on CXA.num_proC_hia=CTa.num_proc_hia and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_hia=CTa.dc_hia
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_hia,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125')	
Group by right(dt_ins_hia,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_hia,left(Num_rcb_hia,2)  


union all


select left(cxa.num_lcto,1) Tipo, cxa.dc_hea, sum(vlr_pgto_rcto_hea) Valor, right(dt_ins_hea,4)  Ano,left(num_rcb_hea,2)   from caixa_hou_exp_aer CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_hou_exp_aer CTA on CXA.num_proC_hea=CTa.num_proc_hea and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_hea=CTa.dc_hea
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_hea,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125')	
Group by right(dt_ins_hea,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_hea, left(num_rcb_hea,2)

union all

select left(cxa.num_lcto,1) Tipo, cxa.dc_him, sum(vlr_pgto_rcto_him) Valor, right(dt_ins_him,4)  Ano,left(num_rcb_him,2) RA  from caixa_hou_imp_mar CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_hou_imp_mar CTA on CXA.num_proC_him=CTa.num_proc_him and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_him=CTa.dc_him
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_him,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125')	
Group by right(dt_ins_him,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_him, left(num_rcb_him,2)


union


select left(cxa.num_lcto,1) Tipo, cxa.dc_hem, sum(vlr_pgto_rcto_hem) Valor, right(dt_ins_hem,4)  Ano,left(num_rcb_hem,2) Ra  from caixa_hou_exp_mar CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_hou_exp_mar CTA on CXA.num_proC_hem=CTa.num_proc_hem and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_hem=CTa.dc_hem
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_hem,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125')	
Group by right(dt_ins_hem,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_hem, left(num_rcb_hem,2)


UNION





select left(cxa.num_lcto,1) Tipo, cxa.dc_mia, sum(vlr_pgto_rcto_mia) Valor, right(dt_ins_mia,4)  Ano,left(Num_rcb_mia,2) RA  from caixa_MAS_imp_aer CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_MAS_imp_aer CTA on CXA.num_proC_mia=CTa.num_proc_mia and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_mia=CTa.dc_mia
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_mia,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125')	
Group by right(dt_ins_mia,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_mia,left(Num_rcb_mia,2)  


union all


select left(cxa.num_lcto,1) Tipo, cxa.dc_mea, sum(vlr_pgto_rcto_mea) Valor, right(dt_ins_mea,4)  Ano,left(num_rcb_mea,2)   from caixa_MAS_exp_aer CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_MAS_exp_aer CTA on CXA.num_proC_mea=CTa.num_proc_mea and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_mea=CTa.dc_mea
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_mea,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125')	
Group by right(dt_ins_mea,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_mea, left(num_rcb_mea,2)

union all

select left(cxa.num_lcto,1) Tipo, cxa.dc_mim, sum(vlr_pgto_rcto_mim) Valor, right(dt_ins_mim,4)  Ano,left(num_rcb_mim,2) RA  from caixa_MAS_imp_mar CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_MAS_imp_mar CTA on CXA.num_proC_mim=CTa.num_proc_mim and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_mim=CTa.dc_mim
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_mim,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125')	
Group by right(dt_ins_mim,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_mim, left(num_rcb_mim,2)


union


select left(cxa.num_lcto,1) Tipo, cxa.dc_mem, sum(vlr_pgto_rcto_mem) Valor, right(dt_ins_mem,4)  Ano,left(num_rcb_mem,2) Ra  from caixa_MAS_exp_mar CXA
join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
Join CtA_ctE_MAS_exp_mar CTA on CXA.num_proC_mem=CTa.num_proc_mem and cxa.cd_tp_Tx=cta.cd_tp_tx and Cxa.dc_mem=CTa.dc_mem
Where Cxa.Num_lcto <> 'Provisório' and convert(datetime,dt_pgto_rcto_mem,105) between '01-01-2006' and '01-31-2006'
and cxa.cd_tp_tx not in ('135','142','ADT','143','149','125')	
Group by right(dt_ins_mem,4)  ,
left(cxa.num_lcto,1) ,cxa.dc_mem, left(num_rcb_mem,2)


GO
