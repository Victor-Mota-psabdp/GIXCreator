SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO















Create Procedure spFluxo_Process (

			@Data varchar(10),
			@Tipo char(1)
			
			)
AS

if @tipo='C'

BEGIN
	select 
		'IA' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hia) Valor, Par_moeda,
		convert(Datetime,dt_ins_hia,105) Data, cta.dc_hia,cd_tp_ativ,CTA.Num_Proc_Hia Processo
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
		desp_org_hia='N'
		and convert(datetime,dt_ins_hia,105)<=convert(datetime,@data,105)	
		and left(cta.num_proc_hia,5) <> 'IAJOB'	
	
	group by 	
		cd_tp_ativ,cta.dc_hia,apelido, par_moeda,cta.cd_tp_moeda,dt_ins_hia,CTA.Num_Proc_Hia		

	UNION ALL

	select 
		'IA' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mia ) Valor,par_moeda,
		convert(datetime,dt_ins_mia,105) Data, cta.dc_mia, cd_tp_ativ, CTA.Num_Proc_MIA Processo
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
		desp_org_mia='N'
		and convert(datetime,dt_ins_mia,105)<=convert(datetime,@Data,105)		

	group by 
		apelido,par_moeda,cta.cd_tp_moeda,dt_ins_mia, cta.dc_mia,cd_tp_ativ,cta.Num_Proc_Mia		

	union all

	select 
		'IM' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_him) Valor, Par_moeda,
		convert(datetime, dt_ins_him,105), cta.dc_him , cd_tp_ativ, CTA.num_proc_him
	from 
		cta_cte_hou_imp_mar cta
		inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_him)
		left join caixa_hou_imp_mar cxa on (cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_him,105) <= convert(datetime,@Data,105))
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@Data
	where 
		cxa.num_proc_him is null and desp_org_him='N'
		and convert(datetime,dt_ins_him,105)<=convert(datetime,@data,105)	
		and left(cta.num_proc_him,5) <> 'IMJOB'
	
	group by 
		apelido, par_moeda,cta.cd_tp_moeda, dt_ins_him, cta.dc_him, cd_tp_ativ,cta.num_proc_him		

	UNION ALL

	select 
		'IM' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mim ) Valor,par_moeda,
		convert(datetime,dt_ins_mim,105)Data, cta.dc_mim, cd_tp_ativ,CTA.num_proc_mim
	from 
		cta_cte_mas_imp_mar cta
		Join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mim)
		left join caixa_mas_imp_mar cxa on (cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_mim,105) <= convert(datetime,@Data,105))
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@Data
	where 
		cxa.num_proc_mim is null and desp_org_mim='N'
		and convert(datetime,dt_ins_mim,105)<=convert(datetime,@Data,105)		

	group by 
		apelido, par_moeda,cta.cd_tp_moeda,
		dt_ins_mim,cta.dc_mim, cd_tp_ativ,cta.num_proc_mim		

	UNION ALL

	select 
		'EA' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hea) Valor, Par_moeda,
		convert(datetime,dt_ins_hea,105) Data, cta.dc_hea, cd_tp_ativ,cta.num_proc_hea
	from 
		cta_cte_hou_exp_aer cta
		Join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hea)
		left join caixa_hou_exp_aer cxa on (cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_hea,105) <= convert(datetime,@Data,105))
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@Data
	where 
		cxa.num_proc_hea is null and desp_dst_hea='N'
		and convert(datetime,dt_ins_hea,105)<=convert(datetime,@Data,105)	
		and left(Cta.num_proc_hea,5) <> 'EAJOB'
	group by 
		apelido, dt_ins_hea,par_moeda,cta.cd_tp_moeda,cta.dc_hea, cd_tp_ativ,cta.num_proc_hea

	UNION ALL

	select 
		'EA' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mea ) Valor,par_moeda,
		convert(datetime,dt_ins_mea,105) Data,cta.dc_mea, cd_tp_ativ,cta.num_proc_mea

	from cta_cte_mas_exp_aer cta
		inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mea)
		left join caixa_mas_exp_aer cxa on 
			(
			cta.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx 
			and cta.dc_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO' and 
			convert(datetime,Dt_Pgto_Rcto_mea,105) <= convert(datetime,@data,105)
		)
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@data

	where  
		cxa.num_proc_mea is null and desp_dst_mea='N'
		and convert(datetime,dt_ins_mea,105)<=convert(datetime,@Data,105)		
	group by 
		apelido, convert(datetime,dt_ins_mea,105),
		par_moeda,cta.cd_tp_moeda,cta.dc_mea, cd_tp_ativ,cta.num_proc_mea		

	union all

	select 
		'EM' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hem) Valor, Par_moeda,
		convert(datetime,dt_ins_hem,105) Data, cta.dc_hem, cd_tp_ativ,cta.num_proc_hem
	from 
		cta_cte_hou_exp_mar cta
		Join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hem)
		left join caixa_hou_exp_mar cxa on 
			(cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and 
			cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_HEM,105) <= convert(datetime,@Data,105))
			left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@data
	where 
		cxa.num_proc_hem is null and desp_dst_hem='N'
		and convert(datetime,dt_ins_hem,105)<=convert(datetime,@Data,105)	
		and left(cta.num_proc_hem,5) <> 'EMJOB'
	group by 
		apelido, dt_ins_hem, par_moeda,cta.cd_tp_moeda, cta.dc_hem, cd_tp_ativ,cta.num_proc_hem	

	UNION ALL

	select 
		'EM' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mem ) Valor,par_moeda,
		convert(datetime,dt_ins_mem,105) Data, cta.dc_mem, cd_tp_ativ,cta.num_proc_mem
	from 
	cta_cte_mas_exp_mar cta
	inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mem)
	left join caixa_mas_exp_mar cxa on 
	(
		cta.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and 	
		cta.dc_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_MEM,105) <= convert(datetime,@Data,105))
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@Data
	where 
	cxa.num_proc_mem is null and desp_dst_mem='N'
	and convert(datetime,dt_ins_mem,105)<=convert(datetime,@data,105)		
	group by apelido, dt_ins_mem,par_moeda,cta.cd_tp_moeda, cta.dc_mem, cd_tp_ativ,cta.num_proc_mem		
END

IF @tipo='S'

BEGIN
	select 
		'IA' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hia) Valor, Par_moeda,
		convert(Datetime,dt_ins_hia,105) Data, cta.dc_hia,cd_tp_ativ,cta.num_proc_hia Processo
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
		desp_org_hia='N'
		and convert(datetime,dt_ins_hia,105)<=convert(datetime,@data,105)	
		and left(cta.num_proc_hia,5) <> 'IAJOB'	
		AND (cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) and cta.cd_tp_tx not in ('DS1','DS2','DS3','DS4') and  left(cta.cd_tp_tx,1) <>'£')	

	group by 	
		cd_tp_ativ,cta.dc_hia,apelido, par_moeda,cta.cd_tp_moeda,dt_ins_hia,cta.num_proc_hia		

	UNION ALL

	select 
		'IA' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mia ) Valor,par_moeda,
		convert(datetime,dt_ins_mia,105) Data, cta.dc_mia, cd_tp_ativ,cta.num_proc_mia
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
		desp_org_mia='N'
		and convert(datetime,dt_ins_mia,105)<=convert(datetime,@Data,105)		
		AND (cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) and cta.cd_tp_tx not in ('DS1','DS2','DS3','DS4') and  left(cta.cd_tp_tx,1) <>'£')	

	group by 
		apelido,par_moeda,cta.cd_tp_moeda,dt_ins_mia, cta.dc_mia,cd_tp_ativ,cta.num_proc_mia		

	union all

	select 
		'IM' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_him) Valor, Par_moeda,
		convert(datetime, dt_ins_him,105), cta.dc_him , cd_tp_ativ,cta.num_proc_him
	from 
		cta_cte_hou_imp_mar cta
		inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_him)
		left join caixa_hou_imp_mar cxa on (cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_him,105) <= convert(datetime,@Data,105))
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@Data
	where 
		cxa.num_proc_him is null and desp_org_him='N'
		and convert(datetime,dt_ins_him,105)<=convert(datetime,@data,105)	
		and left(cta.num_proc_him,5) <> 'IMJOB'
		AND (cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) and cta.cd_tp_tx not in ('DS1','DS2','DS3','DS4') and  left(cta.cd_tp_tx,1) <>'£')	
	group by 
		apelido, par_moeda,cta.cd_tp_moeda, dt_ins_him, cta.dc_him, cd_tp_ativ,cta.num_proc_him		

	UNION ALL

	select 
		'IM' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mim ) Valor,par_moeda,
		convert(datetime,dt_ins_mim,105)Data, cta.dc_mim, cd_tp_ativ,cta.num_proc_mim
	from 
		cta_cte_mas_imp_mar cta
		Join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mim)
		left join caixa_mas_imp_mar cxa on (cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_mim,105) <= convert(datetime,@Data,105))
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@Data
	where 
		cxa.num_proc_mim is null and desp_org_mim='N'
		and convert(datetime,dt_ins_mim,105)<=convert(datetime,@Data,105)		
		AND cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	group by 
		apelido, par_moeda,cta.cd_tp_moeda,
		dt_ins_mim,cta.dc_mim, cd_tp_ativ,cta.num_proc_mim		

	UNION ALL

	select 
		'EA' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hea) Valor, Par_moeda,
		convert(datetime,dt_ins_hea,105) Data, cta.dc_hea, cd_tp_ativ,cta.num_proc_hea
	from 
		cta_cte_hou_exp_aer cta
		Join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hea)
		left join caixa_hou_exp_aer cxa on (cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_hea,105) <= convert(datetime,@Data,105))
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@Data
	where 
		cxa.num_proc_hea is null and desp_dst_hea='N'
		and convert(datetime,dt_ins_hea,105)<=convert(datetime,@Data,105)	
		and left(Cta.num_proc_hea,5) <> 'EAJOB'
		AND cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	group by 
		apelido, dt_ins_hea,par_moeda,cta.cd_tp_moeda,cta.dc_hea, cd_tp_ativ,cta.num_proc_hea		

	UNION ALL

	select 
		'EA' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mea ) Valor,par_moeda,
		convert(datetime,dt_ins_mea,105) Data,cta.dc_mea, cd_tp_ativ,cta.num_proc_mea

	from cta_cte_mas_exp_aer cta
		inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mea)
		left join caixa_mas_exp_aer cxa on 
			(
			cta.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx 
			and cta.dc_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO' and 
			convert(datetime,Dt_Pgto_Rcto_mea,105) <= convert(datetime,@data,105)
		)
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@data

	where  
		cxa.num_proc_mea is null and desp_dst_mea='N'
		and convert(datetime,dt_ins_mea,105)<=convert(datetime,@Data,105)		
		AND (cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) and cta.cd_tp_tx not in ('DS1','DS2','DS3','DS4') and  left(cta.cd_tp_tx,1) <>'£')	
	group by 
		apelido, convert(datetime,dt_ins_mea,105),
		par_moeda,cta.cd_tp_moeda,cta.dc_mea, cd_tp_ativ,cta.num_proc_mea		

	union all

	select 
		'EM' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hem) Valor, Par_moeda,
		convert(datetime,dt_ins_hem,105) Data, cta.dc_hem, cd_tp_ativ,cta.num_proc_hem
	from 
		cta_cte_hou_exp_mar cta
		Join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hem)
		left join caixa_hou_exp_mar cxa on 
			(cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and 
			cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_HEM,105) <= convert(datetime,@Data,105))
			left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@data
	where 
		cxa.num_proc_hem is null and desp_dst_hem='N'
		and convert(datetime,dt_ins_hem,105)<=convert(datetime,@Data,105)	
		and left(cta.num_proc_hem,5) <> 'EMJOB'
		AND cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	group by 
		apelido, dt_ins_hem, par_moeda,cta.cd_tp_moeda, cta.dc_hem, cd_tp_ativ,cta.num_proc_hem		

	UNION ALL

	select 
		'EM' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mem ) Valor,par_moeda,
		convert(datetime,dt_ins_mem,105) Data, cta.dc_mem, cd_tp_ativ,cta.num_proc_mem
	from 
	cta_cte_mas_exp_mar cta
	inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mem)
	left join caixa_mas_exp_mar cxa on 
	(
		cta.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and 	
		cta.dc_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_MEM,105) <= convert(datetime,@Data,105))
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@Data
	where 
	cxa.num_proc_mem is null and desp_dst_mem='N'
	and convert(datetime,dt_ins_mem,105)<=convert(datetime,@data,105)		
	AND cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	group by apelido, dt_ins_mem,par_moeda,cta.cd_tp_moeda, cta.dc_mem, cd_tp_ativ,cta.num_proc_mem		
END














GO
