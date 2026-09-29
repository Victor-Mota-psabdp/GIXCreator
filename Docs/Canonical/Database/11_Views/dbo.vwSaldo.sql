SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  view vwSaldo 


as

select dc_hia,sum(vlr_org_hia*(isnull(par_moeda,1))) Valor from cta_Cte_hou_imp_Aer CTA

Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and cd_Tp_par='OFC' and dt_par='31/01/2006' 
where desp_org_hia='N' 
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
and convert(Datetime,dt_ins_hia, 105) between '01-01-2006' and '01-31-2006' 
group by dc_hia

UNION ALL


select dc_hea,sum(vlr_org_hea*(isnull(par_moeda,1))) Valor from cta_Cte_hou_exp_Aer CTA

Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and cd_Tp_par='OFC' and dt_par='31/01/2006' 
where desp_DST_hea='N' 
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
and convert(Datetime,dt_ins_hea, 105) between '01-01-2006' and '01-31-2006' 
group by dc_hea



union all



select dc_HIM,sum(vlr_org_HIM*(isnull(par_moeda,1))) Valor from cta_Cte_hou_imp_MAR CTA

Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and cd_Tp_par='OFC' and dt_par='31/01/2006' 
where desp_org_HIM='N' 
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
and convert(Datetime,dt_ins_HIM, 105) between '01-01-2006' and '01-31-2006' 
group by dc_HIM

UNION ALL


select dc_HEM,sum(vlr_org_HEM*(isnull(par_moeda,1))) Valor from cta_Cte_hou_exp_MAR CTA

Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and cd_Tp_par='OFC' and dt_par='31/01/2006' 
where desp_DST_HEM='N' 
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
and convert(Datetime,dt_ins_HEM, 105) between '01-01-2006' and '01-31-2006' 
group by dc_HEM


UNION ALL


select dc_mia,sum(vlr_org_mia*(isnull(par_moeda,1))) Valor from cta_Cte_mas_imp_Aer CTA

Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and cd_Tp_par='OFC' and dt_par='31/01/2006' 
where desp_org_mia='N' 
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
and convert(Datetime,dt_ins_mia, 105) between '01-01-2006' and '01-31-2006' 
group by dc_mia

UNION ALL


select dc_mea,sum(vlr_org_mea*(isnull(par_moeda,1))) Valor from cta_Cte_mas_exp_Aer CTA

Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and cd_Tp_par='OFC' and dt_par='31/01/2006' 
where desp_DST_mea='N' 
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
and convert(Datetime,dt_ins_mea, 105) between '01-01-2006' and '01-31-2006' 
group by dc_mea



union all



select dc_mim,sum(vlr_org_mim*(isnull(par_moeda,1))) Valor from cta_Cte_mas_imp_MAR CTA

Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and cd_Tp_par='OFC' and dt_par='31/01/2006' 
where desp_org_mim='N' 
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
and convert(Datetime,dt_ins_mim, 105) between '01-01-2006' and '01-31-2006' 
group by dc_mim

UNION ALL


select dc_mem,sum(vlr_org_mem*(isnull(par_moeda,1))) Valor from cta_Cte_mas_exp_MAR CTA

Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and cd_Tp_par='OFC' and dt_par='31/01/2006' 
where desp_DST_mem='N' 
and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
and convert(Datetime,dt_ins_mem, 105) between '01-01-2006' and '01-31-2006' 
group by dc_mem



GO
