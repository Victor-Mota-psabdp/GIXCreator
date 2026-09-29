SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW VWla

AS


select cxa.num_lcto, sum(dbo.valor(vlr_pgto_rcto_hia,cxa.dc_hia)) PG,num_rcb_hia  from caixa_hou_imp_Aer CXA
Join Cta_cte_hou_imp_Aer CTA on CTa.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cxa.dc_hia=cta.dc_hia
Left Join Pgto_rcto PG on PG.num_lcto=Cxa.num_lcto
Where convert(datetime,dt_pgto_Rcto_hia,105) between '01-01-2006' and '01-31-2006' and cxa.num_lcto <> 'PROVISÓRIO' and
cta.cd_tp_tx not in ('135','142','ADT','143','149','125')and Num_Cta_Cte <> '007' 
Group by cxa.num_lcto,num_rcb_hia


UNION ALL


select cxa.num_lcto, sum(dbo.valor(vlr_pgto_rcto_hea,cxa.dc_hea)) PG,num_rcb_hea  from caixa_hou_exp_Aer CXA
Join Cta_cte_hou_exp_Aer CTA on CTa.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_Tx=cxa.cd_tp_tx and cxa.dc_hea=cta.dc_hea
Left Join Pgto_rcto PG on PG.num_lcto=Cxa.num_lcto
Where convert(datetime,dt_pgto_Rcto_hea,105) between '01-01-2006' and '01-31-2006' and cxa.num_lcto <> 'PROVISÓRIO' and
cta.cd_tp_tx not in ('135','142','ADT','143','149','125')and Num_Cta_Cte <> '007' 
Group by cxa.num_lcto,num_rcb_hea

UNION ALL


select cxa.num_lcto, sum(dbo.valor(vlr_pgto_rcto_HIM,cxa.dc_HIM)) PG,num_rcb_HIM  from caixa_hou_imp_MAR CXA
Join Cta_cte_hou_imp_MAR CTA on CTa.num_proc_HIM=cxa.num_proc_HIM and cta.cd_tp_Tx=cxa.cd_tp_tx and cxa.dc_HIM=cta.dc_HIM
Left Join Pgto_rcto PG on PG.num_lcto=Cxa.num_lcto
Where convert(datetime,dt_pgto_Rcto_HIM,105) between '01-01-2006' and '01-31-2006' and cxa.num_lcto <> 'PROVISÓRIO' and
cta.cd_tp_tx not in ('135','142','ADT','143','149','125')and Num_Cta_Cte <> '007' 
Group by cxa.num_lcto,num_rcb_HIM


UNION ALL


select cxa.num_lcto, sum(dbo.valor(vlr_pgto_rcto_HEM,cxa.dc_HEM)) PG,num_rcb_HEM  from caixa_hou_exp_MAR CXA
Join Cta_cte_hou_exp_MAR CTA on CTa.num_proc_HEM=cxa.num_proc_HEM and cta.cd_tp_Tx=cxa.cd_tp_tx and cxa.dc_HEM=cta.dc_HEM
Left Join Pgto_rcto PG on PG.num_lcto=Cxa.num_lcto
Where convert(datetime,dt_pgto_Rcto_HEM,105) between '01-01-2006' and '01-31-2006' and cxa.num_lcto <> 'PROVISÓRIO' and
cta.cd_tp_tx not in ('135','142','ADT','143','149','125')and Num_Cta_Cte <> '007' 
Group by cxa.num_lcto,num_rcb_HEM

UNION ALL


select cxa.num_lcto, sum(dbo.valor(vlr_pgto_rcto_mia,cxa.dc_mia)) PG,num_rcb_mia  from caixa_mas_imp_Aer CXA
Join Cta_cte_mas_imp_Aer CTA on CTa.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_Tx=cxa.cd_tp_tx and cxa.dc_mia=cta.dc_mia
Left Join Pgto_rcto PG on PG.num_lcto=Cxa.num_lcto
Where convert(datetime,dt_pgto_Rcto_mia,105) between '01-01-2006' and '01-31-2006' and cxa.num_lcto <> 'PROVISÓRIO' and
cta.cd_tp_tx not in ('135','142','ADT','143','149','125')and Num_Cta_Cte <> '007' 
Group by cxa.num_lcto,num_rcb_mia


UNION ALL


select cxa.num_lcto, sum(dbo.valor(vlr_pgto_rcto_mea,cxa.dc_mea)) PG,num_rcb_mea  from caixa_mas_exp_Aer CXA
Join Cta_cte_mas_exp_Aer CTA on CTa.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_Tx=cxa.cd_tp_tx and cxa.dc_mea=cta.dc_mea
Left Join Pgto_rcto PG on PG.num_lcto=Cxa.num_lcto
Where convert(datetime,dt_pgto_Rcto_mea,105) between '01-01-2006' and '01-31-2006' and cxa.num_lcto <> 'PROVISÓRIO' and
cta.cd_tp_tx not in ('135','142','ADT','143','149','125')and Num_Cta_Cte <> '007' 
Group by cxa.num_lcto,num_rcb_mea

UNION ALL


select cxa.num_lcto, sum(dbo.valor(vlr_pgto_rcto_mim,cxa.dc_mim)) PG,num_rcb_mim  from caixa_mas_imp_MAR CXA
Join Cta_cte_mas_imp_MAR CTA on CTa.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_Tx=cxa.cd_tp_tx and cxa.dc_mim=cta.dc_mim
Left Join Pgto_rcto PG on PG.num_lcto=Cxa.num_lcto
Where convert(datetime,dt_pgto_Rcto_mim,105) between '01-01-2006' and '01-31-2006' and cxa.num_lcto <> 'PROVISÓRIO' and
cta.cd_tp_tx not in ('135','142','ADT','143','149','125')and Num_Cta_Cte <> '007' 
Group by cxa.num_lcto,num_rcb_mim


UNION ALL


select cxa.num_lcto, sum(dbo.valor(vlr_pgto_rcto_mem,cxa.dc_mem)) PG,num_rcb_mem  from caixa_mas_exp_MAR CXA
Join Cta_cte_mas_exp_MAR CTA on CTa.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_Tx=cxa.cd_tp_tx and cxa.dc_mem=cta.dc_mem
Left Join Pgto_rcto PG on PG.num_lcto=Cxa.num_lcto
Where convert(datetime,dt_pgto_Rcto_mem,105) between '01-01-2006' and '01-31-2006' and cxa.num_lcto <> 'PROVISÓRIO' and
cta.cd_tp_tx not in ('135','142','ADT','143','149','125')and Num_Cta_Cte <> '007' 
Group by cxa.num_lcto,num_rcb_mem






GO
