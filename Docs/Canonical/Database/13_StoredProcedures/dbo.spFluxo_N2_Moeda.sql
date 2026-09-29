SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--spFluxo_N2 '03-05-2012','C'
--spFluxo_N2 '2012-03-05','C' = 8254
--spFluxo_N2 '05/03/2012','C' = 8762

--spFluxo_N2 '31/12/2011','C' = 9218
--spFluxo_N2 '2012-05-03','C' = 22717 rows

--spFluxo_N2 '2012-03-05','C'


--Incluso EO e IO - Carlos Eduardo  - 09-06-2011
--ATEcrNCAO: NAO RETIRAR EM HIPOTESE ALGUMA O FILTRO POR DATA: ANDERS0N -27/3/2012
CREATE     Procedure [dbo].[spFluxo_N2_Moeda] (

			@Data varchar(10),
			@Tipo char(1)
			
			)
AS

if @tipo='C'


	BEGIN

	-------IA
		select 
			'IA' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hia) Valor, Par_moeda,
			convert(Datetime,Dt_Prev_Pgto_hia,105) Data, cta.dc_hia,cd_tp_ativ,Nome_tp_Tx
		from 
			cta_cte_hou_imp_aer cta
			Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
			join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hia)
			left join caixa_hou_imp_aer cxa on 
				(
				cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx 
				and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' and 
				convert(datetime,Dt_Pgto_Rcto_hia,105) <= convert(datetime,@Data,105)
				)
			left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)
		where 
			cxa.num_proc_hia is null and 
			desp_org_hia='N'
			and convert(datetime,dt_ins_hia,105)<=convert(datetime,@data,105)	
			and left(cta.num_proc_hia,5) <> 'IAJOB'	
			

		group by 	
			cd_tp_ativ,cta.dc_hia,apelido, par_moeda,cta.cd_tp_moeda,Dt_Prev_Pgto_hia,
			Nome_Tp_Tx

	UNION ALL

	select 
		'IA' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mia ) Valor,par_moeda,
		convert(datetime,Dt_Prev_Pgto_mia,105) Data, cta.dc_mia, cd_tp_ativ,
		Nome_tp_tx
	from 
		cta_cte_mas_imp_aer cta
		Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
		inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mia)
		left join caixa_mas_imp_aer cxa on 
		(
		cta.num_proc_mia=cxa.num_proc_mia and 
		cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and num_lcto <> 'PROVISÓRIO' 
		and convert(datetime,Dt_Pgto_Rcto_mia,105) <= convert(datetime,@data,105)
		)
	left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)

	where 
	cxa.num_proc_mia is null and 
	desp_org_mia='N'
	and convert(datetime,dt_ins_mia,105)<=convert(datetime,@Data,105)		

	group by 
		apelido,par_moeda,cta.cd_tp_moeda,Dt_Prev_Pgto_mia, cta.dc_mia,cd_tp_ativ,Nome_tp_tx		

	union all

	---------IM
	select 
		'IM' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_him) Valor, Par_moeda,
		convert(datetime, Dt_Prev_Pgto_him,105), cta.dc_him , cd_tp_ativ,
		Nome_tp_tx
	from 
		cta_cte_hou_imp_mar cta
		Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_tp_Tx
		inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_him)
		left join caixa_hou_imp_mar cxa on (cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_him,105) <= convert(datetime,@Data,105))
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)
	where 
		cxa.num_proc_him is null and desp_org_him='N'
		and convert(datetime,dt_ins_him,105)<=convert(datetime,@data,105)	
		and left(cta.num_proc_him,5) <> 'IMJOB'

	group by 
		apelido, par_moeda,cta.cd_tp_moeda, Dt_Prev_Pgto_him, cta.dc_him, cd_tp_ativ,nome_tp_Tx		

	UNION ALL

	select 
		'IM' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mim ) Valor,par_moeda,
		convert(datetime,Dt_Prev_Pgto_mim,105)Data, cta.dc_mim, cd_tp_ativ,nome_tp_tx 
	from 
		cta_cte_mas_imp_mar cta
		Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
		Join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mim)
		left join caixa_mas_imp_mar cxa on (cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_mim,105) <= convert(datetime,@Data,105))
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)
	where 
		cxa.num_proc_mim is null and desp_org_mim='N'
		and convert(datetime,dt_ins_mim,105)<=convert(datetime,@Data,105)		

	group by 
		apelido, par_moeda,cta.cd_tp_moeda,
		Dt_Prev_Pgto_mim,cta.dc_mim, cd_tp_ativ,Nome_tp_tx	

	UNION ALL

	--------EA
	select 
		'EA' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hea) Valor, Par_moeda,
		convert(datetime,Dt_Prev_Pgto_hea,105) Data, cta.dc_hea, cd_tp_ativ,
		Nome_tp_tx
	from 
		cta_cte_hou_exp_aer cta
		Join Tipo_taxa TT on TT.cd_tp_tx=cta.cd_tp_tx
		Join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hea)
		left join caixa_hou_exp_aer cxa on (cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_hea,105) <= convert(datetime,@Data,105))
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)
	where 
		cxa.num_proc_hea is null and desp_dst_hea='N'
		and convert(datetime,dt_ins_hea,105)<=convert(datetime,@Data,105)	
		and left(Cta.num_proc_hea,5) <> 'EAJOB'
	group by 
		apelido, Dt_Prev_Pgto_hea,par_moeda,cta.cd_tp_moeda,cta.dc_hea, cd_tp_ativ,nome_tp_Tx		

	UNION ALL

	select 
		'EA' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mea ) Valor,par_moeda,
		convert(datetime,Dt_Prev_Pgto_mea,105) Data,cta.dc_mea, cd_tp_ativ,nome_tp_Tx

	from cta_cte_mas_exp_aer cta
		Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
		inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mea)
		left join caixa_mas_exp_aer cxa on 
			(
			cta.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx 
			and cta.dc_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO' and 
			convert(datetime,Dt_Pgto_Rcto_mea,105) <= convert(datetime,@data,105)
		)
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)

	where  
		cxa.num_proc_mea is null and desp_dst_mea='N'
		and convert(datetime,dt_ins_mea,105)<=convert(datetime,@Data,105)		
	group by 
		apelido, convert(datetime,Dt_Prev_Pgto_mea,105),
		par_moeda,cta.cd_tp_moeda,cta.dc_mea, cd_tp_ativ,nome_tp_Tx		

	union all

	---------EM
	select 
		'EM' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hem) Valor, Par_moeda,
		convert(datetime,Dt_Prev_Pgto_hem,105) Data, cta.dc_hem, cd_tp_ativ,nome_tp_Tx
	from 
		cta_cte_hou_exp_mar cta
		Join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hem)
		Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx

		left join caixa_hou_exp_mar cxa on 
			(cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and 
			cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_HEM,105) <= convert(datetime,@Data,105))
			left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)
	where 
		cxa.num_proc_hem is null and desp_dst_hem='N'
		and convert(datetime,dt_ins_hem,105)<=convert(datetime,@Data,105)	
		and left(cta.num_proc_hem,5) <> 'EMJOB'
	group by 
		apelido, Dt_Prev_Pgto_hem, par_moeda,cta.cd_tp_moeda, cta.dc_hem, cd_tp_ativ,nome_tp_tx		

	UNION ALL

	select 
		'EM' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mem ) Valor,par_moeda,
		convert(datetime,Dt_Prev_Pgto_mem,105) Data, cta.dc_mem, cd_tp_ativ,nome_tp_tx
	from 
	cta_cte_mas_exp_mar cta
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx

	inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mem)
	left join caixa_mas_exp_mar cxa on 
	(
		cta.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and 	
		cta.dc_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_MEM,105) <= convert(datetime,@Data,105))
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)
	where 
	cxa.num_proc_mem is null and desp_dst_mem='N'
	and convert(datetime,dt_ins_mem,105)<=convert(datetime,@data,105)		
	group by apelido, Dt_Prev_Pgto_mem,par_moeda,cta.cd_tp_moeda, cta.dc_mem, cd_tp_ativ,nome_tp_Tx		

Union ALL
	--------------IO
	select 
		'IO' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hio) Valor, Par_moeda,
		convert(Datetime,Dt_Prev_Pgto_hio,105) Data, cta.dc_hio,cd_tp_ativ,
		Nome_tp_Tx
	from 
		cta_cte_hou_imp_out cta
		Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
		join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hio)
		left join caixa_hou_imp_out cxa on 
			(
			cta.num_proc_hio=cxa.num_proc_hio and cta.cd_tp_tx=cxa.cd_tp_tx 
			and cta.dc_hio=cxa.dc_hio and num_lcto <> 'PROVISÓRIO' and 
			convert(datetime,Dt_Pgto_Rcto_hio,105) <= convert(datetime,@Data,105)
			)
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)
	where 
		cxa.num_proc_hio is null and 
		desp_org_hio='N'
		and convert(datetime,dt_ins_hio,105)<=convert(datetime,@data,105)	
		and left(cta.num_proc_hio,5) <> 'IAJOB'	

	group by 	
		cd_tp_ativ,cta.dc_hio,apelido, par_moeda,cta.cd_tp_moeda,Dt_Prev_Pgto_hio,
		Nome_Tp_Tx

UNION ALL
	-----------EO
	select 
		'EO' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_heo) Valor, Par_moeda,
		convert(Datetime,Dt_Prev_Pgto_heo,105) Data, cta.dc_heo,cd_tp_ativ,
		Nome_tp_Tx
	from 
		cta_cte_hou_exp_out cta
		Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
		join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_heo)
		left join caixa_hou_exp_out cxa on 
			(
			cta.num_proc_heo=cxa.num_proc_heo and cta.cd_tp_tx=cxa.cd_tp_tx 
			and cta.dc_heo=cxa.dc_heo and num_lcto <> 'PROVISÓRIO' and 
			convert(datetime,Dt_Pgto_Rcto_heo,105) <= convert(datetime,@Data,105)
			)
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)
	where 
		cxa.num_proc_heo is null and 
		desp_org_heo='N'
		and convert(datetime,dt_ins_heo,105)<=convert(datetime,@data,105)	
		and left(cta.num_proc_heo,5) <> 'IAJOB'	

	group by 	
		cd_tp_ativ,cta.dc_heo,apelido, par_moeda,cta.cd_tp_moeda,Dt_Prev_Pgto_heo,
		Nome_Tp_Tx

	END


IF @tipo='S'

	BEGIN

	---------IA
		select 
			'IA' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hia) Valor, Par_moeda,
			convert(Datetime,Dt_Prev_Pgto_hia,105) Data, cta.dc_hia,cd_tp_ativ
		from 
			cta_cte_hou_imp_aer cta

			inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hia)
			left join caixa_hou_imp_aer cxa on 
				(
				cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx 
				and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' and 
				convert(datetime,Dt_Pgto_Rcto_hia,105) <= convert(datetime,@Data,105)
				)
			left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)

		where 
			cxa.num_proc_hia is null and 
			desp_org_hia='N'
			and convert(datetime,dt_ins_hia,105)<=convert(datetime,@data,105)	
			and left(cta.num_proc_hia,5) <> 'IAJOB'	
			AND (cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) and cta.cd_tp_tx not in ('DS1','DS2','DS3','DS4') and  left(cta.cd_tp_tx,1) <>'£')	
			and left(cta.cd_tp_tx,1) <> 'X'
		group by 	
			cd_tp_ativ,cta.dc_hia,apelido, par_moeda,cta.cd_tp_moeda,Dt_Prev_Pgto_hia		

		UNION ALL

		select 
			'IA' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mia ) Valor,par_moeda,
			convert(datetime,Dt_Prev_Pgto_mia,105) Data, cta.dc_mia, cd_tp_ativ
		from 
			cta_cte_mas_imp_aer cta
			inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mia)
			left join caixa_mas_imp_aer cxa on 
			(
			cta.num_proc_mia=cxa.num_proc_mia and 
			cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and num_lcto <> 'PROVISÓRIO' 
			and convert(datetime,Dt_Pgto_Rcto_mia,105) <= convert(datetime,@data,105)
			)
		left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)

		where 
			cxa.num_proc_mia is null and 
			desp_org_mia='N'
			and convert(datetime,dt_ins_mia,105)<=convert(datetime,@Data,105)		
			AND (cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) and cta.cd_tp_tx not in ('DS1','DS2','DS3','DS4') and  left(cta.cd_tp_tx,1) <>'£')	
			and left(cta.cd_tp_tx,1) <> 'X'
		group by 
			apelido,par_moeda,cta.cd_tp_moeda,Dt_Prev_Pgto_mia, cta.dc_mia,cd_tp_ativ		

		union all

	-------------IM
		select 
			'IM' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_him) Valor, Par_moeda,
			convert(datetime, Dt_Prev_Pgto_him,105), cta.dc_him , cd_tp_ativ
		from 
			cta_cte_hou_imp_mar cta
			inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_him)
			left join caixa_hou_imp_mar cxa on (cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_him,105) <= convert(datetime,@Data,105))
			left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)
		where 
			cxa.num_proc_him is null and desp_org_him='N'
			and convert(datetime,dt_ins_him,105)<=convert(datetime,@data,105)	
			and left(cta.num_proc_him,5) <> 'IMJOB'
			AND (cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) and cta.cd_tp_tx not in ('DS1','DS2','DS3','DS4') and  left(cta.cd_tp_tx,1) <>'£')	
			and left(cta.cd_tp_tx,1) <> 'X'

		group by 
			apelido, par_moeda,cta.cd_tp_moeda, Dt_Prev_Pgto_him, cta.dc_him, cd_tp_ativ		

		UNION ALL

		select 
			'IM' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mim ) Valor,par_moeda,
			convert(datetime,Dt_Prev_Pgto_mim,105)Data, cta.dc_mim, cd_tp_ativ 
		from 
			cta_cte_mas_imp_mar cta
			Join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mim)
			left join caixa_mas_imp_mar cxa on (cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_mim,105) <= convert(datetime,@Data,105))
			left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)
		where 
			cxa.num_proc_mim is null and desp_org_mim='N'
			and convert(datetime,dt_ins_mim,105)<=convert(datetime,@Data,105)		
			AND cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
			and left(cta.cd_tp_tx,1) <> 'X'
		group by 
			apelido, par_moeda,cta.cd_tp_moeda,
			Dt_Prev_Pgto_mim,cta.dc_mim, cd_tp_ativ		

		UNION ALL

	---------EA
		select 
			'EA' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hea) Valor, Par_moeda,
			convert(datetime,Dt_Prev_Pgto_hea,105) Data, cta.dc_hea, cd_tp_ativ
		from 
			cta_cte_hou_exp_aer cta
			Join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hea)
			left join caixa_hou_exp_aer cxa on (cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_hea,105) <= convert(datetime,@Data,105))
			left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)
		where 
			cxa.num_proc_hea is null and desp_dst_hea='N'
			and convert(datetime,dt_ins_hea,105)<=convert(datetime,@Data,105)	
			and left(Cta.num_proc_hea,5) <> 'EAJOB'
			AND cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
			and left(cta.cd_tp_tx,1) <> 'X'
		group by 
			apelido, Dt_Prev_Pgto_hea,par_moeda,cta.cd_tp_moeda,cta.dc_hea, cd_tp_ativ		

		UNION ALL

		select 
			'EA' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mea ) Valor,par_moeda,
			convert(datetime,Dt_Prev_Pgto_mea,105) Data,cta.dc_mea, cd_tp_ativ

		from cta_cte_mas_exp_aer cta
			inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mea)
			left join caixa_mas_exp_aer cxa on 
				(
				cta.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx 
				and cta.dc_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO' and 
				convert(datetime,Dt_Pgto_Rcto_mea,105) <= convert(datetime,@data,105)
			)
			left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)

		where  
			cxa.num_proc_mea is null and desp_dst_mea='N'
			and convert(datetime,dt_ins_mea,105)<=convert(datetime,@Data,105)		
			AND (cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) and cta.cd_tp_tx not in ('DS1','DS2','DS3','DS4') and  left(cta.cd_tp_tx,1) <>'£')	
			and left(cta.cd_tp_tx,1) <> 'X'

		group by 
			apelido, convert(datetime,Dt_Prev_Pgto_mea,105),
			par_moeda,cta.cd_tp_moeda,cta.dc_mea, cd_tp_ativ		

		union all
	----------EM
		select 
			'EM' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hem) Valor, Par_moeda,
			convert(datetime,Dt_Prev_Pgto_hem,105) Data, cta.dc_hem, cd_tp_ativ
		from 
			cta_cte_hou_exp_mar cta
			Join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hem)
			left join caixa_hou_exp_mar cxa on 
				(cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and 
				cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_HEM,105) <= convert(datetime,@Data,105))
				left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)

		where 
			cxa.num_proc_hem is null and desp_dst_hem='N'
			and convert(datetime,dt_ins_hem,105)<=convert(datetime,@Data,105)	
			and left(cta.num_proc_hem,5) <> 'EMJOB'
			AND cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
			and left(cta.cd_tp_tx,1) <> 'X'

		group by 
			apelido, Dt_Prev_Pgto_hem, par_moeda,cta.cd_tp_moeda, cta.dc_hem, cd_tp_ativ		

		UNION ALL

		select 
			'EM' Modal, apelido,cta.cd_tp_moeda,sum(vlr_org_mem ) Valor,par_moeda,
			convert(datetime,Dt_Prev_Pgto_mem,105) Data, cta.dc_mem, cd_tp_ativ
		from 
		cta_cte_mas_exp_mar cta
		inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mem)
		left join caixa_mas_exp_mar cxa on 
		(
			cta.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and 	
			cta.dc_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_MEM,105) <= convert(datetime,@Data,105))
			left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)
		where 
		cxa.num_proc_mem is null and desp_dst_mem='N'
		and convert(datetime,dt_ins_mem,105)<=convert(datetime,@data,105)		
		AND cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
			and left(cta.cd_tp_tx,1) <> 'X'
		group by apelido, Dt_Prev_Pgto_mem,par_moeda,cta.cd_tp_moeda, cta.dc_mem, cd_tp_ativ

	
	Union All

	------------IO		
		select 
			'IO' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_hio) Valor, Par_moeda,
			convert(Datetime,Dt_Prev_Pgto_hio,105) Data, cta.dc_hio,cd_tp_ativ
		from 
			cta_cte_hou_imp_out cta

			inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hio)
			left join caixa_hou_imp_out cxa on 
				(
				cta.num_proc_hio=cxa.num_proc_hio and cta.cd_tp_tx=cxa.cd_tp_tx 
				and cta.dc_hio=cxa.dc_hio and num_lcto <> 'PROVISÓRIO' and 
				convert(datetime,Dt_Pgto_Rcto_hio,105) <= convert(datetime,@Data,105)
				)
			left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)

		where 
			cxa.num_proc_hio is null and 
			desp_org_hio='N'
			and convert(datetime,dt_ins_hio,105)<=convert(datetime,@data,105)	
			and left(cta.num_proc_hio,5) <> 'IOJOB'	
			AND (cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) and cta.cd_tp_tx not in ('DS1','DS2','DS3','DS4') and  left(cta.cd_tp_tx,1) <>'£')	
			and left(cta.cd_tp_tx,1) <> 'X'
		group by 	
			cd_tp_ativ,cta.dc_hio,apelido, par_moeda,cta.cd_tp_moeda,Dt_Prev_Pgto_hio	
	
	Union ALL
	------------EO
		select 
			'EO' Modal,apelido,cta.cd_tp_moeda,sum(vlr_org_heo) Valor, Par_moeda,
			convert(Datetime,Dt_Prev_Pgto_heo,105) Data, cta.dc_heo,cd_tp_ativ
		from 
			cta_cte_hou_exp_out cta

			inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_heo)
			left join caixa_hou_exp_out cxa on 
				(
				cta.num_proc_heo=cxa.num_proc_heo and cta.cd_tp_tx=cxa.cd_tp_tx 
				and cta.dc_heo=cxa.dc_heo and num_lcto <> 'PROVISÓRIO' and 
				convert(datetime,dt_pgto_rcto_heo,105) <= convert(datetime,@Data,105)
				)
			left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and convert(datetime,dt_par,105)=convert(datetime,@Data,105)

		where 
			cxa.num_proc_heo is null and 
			desp_org_heo='N'
			and convert(datetime,dt_ins_heo,105)<=convert(datetime,@data,105)	
			and left(cta.num_proc_heo,5) <> 'EOJOB'	
			AND (cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc) and cta.cd_tp_tx not in ('DS1','DS2','DS3','DS4') and  left(cta.cd_tp_tx,1) <>'£')	
			and left(cta.cd_tp_tx,1) <> 'X'
		group by 	
			cd_tp_ativ,cta.dc_heo,apelido, par_moeda,cta.cd_tp_moeda,Dt_Prev_Pgto_heo
	END























GO
