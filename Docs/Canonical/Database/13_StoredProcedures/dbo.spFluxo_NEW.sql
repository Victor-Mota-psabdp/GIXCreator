SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








CREATE      Procedure spFluxo_NEW 

			@Data varchar(10)


AS

select 
	'IA' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hia) Valor, Par_moeda,
	month(convert(datetime,dt_ins_hia,105)) Mes, year(convert(datetime,dt_ins_hia,105)) Ano 
from 
	cta_cte_hou_imp_aer cta

	inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hia)
	left join caixa_hou_imp_aer cxa on 
		(
			cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx 
			and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' and 
			convert(datetime,Dt_Pgto_Rcto_hia,105) <= convert(datetime,@Data,105)
		)
	left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@Data

where 
	cxa.num_proc_hia is null and 
	cta.dC_hia='C' and desp_org_hia='N'
	and convert(datetime,dt_ins_hia,105)<=convert(datetime,@data,105)	
	and left(cta.num_proc_hia,5) <> 'IAJOB'	
	
group by 	apelido, month(convert(datetime,dt_ins_hia,105)),
		year(convert(datetime,dt_ins_hia,105))  
		,par_moeda,cta.cd_tp_moeda		

UNION ALL

select 
	'IA' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mia ) Valor,par_moeda,
	month(convert(datetime,dt_ins_mia,105)) Mes, year(convert(datetime,dt_ins_mia,105)) Ano 

from 
	cta_cte_mas_imp_aer cta

	inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mia)
	
	left join caixa_mas_imp_aer cxa on 
	(
		cta.num_proc_mia=cxa.num_proc_mia and 
		cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and num_lcto <> 'PROVISÓRIO' 
		and convert(datetime,Dt_Pgto_Rcto_mia,105) <= convert(datetime,@data,105)
	)
	left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@data

where 
	 cxa.num_proc_mia is null and 
	cta.dC_mia='C' and desp_org_mia='N'
	and convert(datetime,dt_ins_mia,105)<=convert(datetime,@Data,105)		
group by apelido, month(convert(datetime,dt_ins_mia,105)),year(convert(datetime,dt_ins_mia,105))  
	,par_moeda,cta.cd_tp_moeda		

union all

select 
	'IM' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_him) Valor, Par_moeda,month(convert(datetime,dt_ins_him,105)) Mes, year(convert(datetime,dt_ins_him,105)) Ano 

from 
	cta_cte_hou_imp_mar cta
	inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_him)
	left join caixa_hou_imp_mar cxa on (cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_him,105) <= convert(datetime,@Data,105))
	left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@Data
where 
	cxa.num_proc_him is null and cta.dC_him='C' and desp_org_him='N'
	and convert(datetime,dt_ins_him,105)<=convert(datetime,@data,105)	
	and left(cta.num_proc_him,5) <> 'IMJOB'
	
group by apelido, month(convert(datetime,dt_ins_him,105)),year(convert(datetime,dt_ins_him,105))  
		,par_moeda,cta.cd_tp_moeda		

UNION ALL

select 'IM' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mim ) Valor,par_moeda,month(convert(datetime,dt_ins_mim,105)) Mes, year(convert(datetime,dt_ins_mim,105)) Ano from cta_cte_mas_imp_mar cta
inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mim)
left join caixa_mas_imp_mar cxa on (cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_mim,105) <= convert(datetime,@Data,105))
left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@Data
where cxa.num_proc_mim is null and cta.dC_mim='C' and desp_org_mim='N'
and convert(datetime,dt_ins_mim,105)<=convert(datetime,@Data,105)		
group by apelido, month(convert(datetime,dt_ins_mim,105)),year(convert(datetime,dt_ins_mim,105))  
	,par_moeda,cta.cd_tp_moeda		

UNION ALL

select 'EA' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hea) Valor, Par_moeda,month(convert(datetime,dt_ins_hea,105)) Mes, year(convert(datetime,dt_ins_hea,105)) Ano from cta_cte_hou_exp_aer cta
inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hea)
left join caixa_hou_exp_aer cxa on (cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_hea,105) <= convert(datetime,@Data,105))
left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@Data
where cxa.num_proc_hea is null and cta.dC_hea='C' and desp_dst_hea='N'
and convert(datetime,dt_ins_hea,105)<=convert(datetime,@Data,105)	
and left(Cta.num_proc_hea,5) <> 'EAJOB'
group by apelido, month(convert(datetime,dt_ins_hea,105)),year(convert(datetime,dt_ins_hea,105))  
		,par_moeda,cta.cd_tp_moeda		

UNION ALL

select 'EA' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mea ) Valor,par_moeda,month(convert(datetime,dt_ins_mea,105)) Mes, year(convert(datetime,dt_ins_mea,105)) Ano from cta_cte_mas_exp_aer cta
inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mea)
left join caixa_mas_exp_aer cxa on 

(
cta.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx 
and cta.dc_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO' and 
convert(datetime,Dt_Pgto_Rcto_mea,105) <= convert(datetime,@data,105)
)

left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@data
where  cxa.num_proc_mea is null and cta.dC_mea='C' and desp_dst_mea='N'
and convert(datetime,dt_ins_mea,105)<=convert(datetime,@Data,105)		
group by apelido, month(convert(datetime,dt_ins_mea,105)),year(convert(datetime,dt_ins_mea,105))  
	,par_moeda,cta.cd_tp_moeda		

union all

select 'EM' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hem) Valor, Par_moeda,month(convert(datetime,dt_ins_hem,105)) Mes, year(convert(datetime,dt_ins_hem,105)) Ano from cta_cte_hou_exp_mar cta
inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hem)
left join caixa_hou_exp_mar cxa on 
(cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and 
cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_HEM,105) <= convert(datetime,@Data,105))
left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@data
where cxa.num_proc_hem is null and cta.dC_hem='C' and desp_dst_hem='N'
and convert(datetime,dt_ins_hem,105)<=convert(datetime,@Data,105)	
and left(cta.num_proc_hem,5) <> 'EMJOB'
group by apelido, month(convert(datetime,dt_ins_hem,105)),year(convert(datetime,dt_ins_hem,105))  
		,par_moeda,cta.cd_tp_moeda		

UNION ALL

select 'EM' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mem ) Valor,par_moeda,month(convert(datetime,dt_ins_mem,105)) Mes, year(convert(datetime,dt_ins_mem,105)) Ano from cta_cte_mas_exp_mar cta
inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mem)
left join caixa_mas_exp_mar cxa on 
	(
		cta.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and 	
	cta.dc_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_MEM,105) <= convert(datetime,@Data,105))
left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@Data
where 
	cxa.num_proc_mem is null and cta.dC_mem='C' and desp_dst_mem='N'
	and convert(datetime,dt_ins_mem,105)<=convert(datetime,@data,105)		
group by apelido, month(convert(datetime,dt_ins_mem,105)),year(convert(datetime,dt_ins_mem,105))  
	,par_moeda,cta.cd_tp_moeda		









GO
