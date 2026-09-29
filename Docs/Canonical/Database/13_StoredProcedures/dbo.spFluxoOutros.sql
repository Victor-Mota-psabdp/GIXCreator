SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE  Procedure spFluxoOutros 
			
			@DataFinal	varchar(10),
			@DataParidade	varchar(10)

AS

select 
	'IA' Modal,apelido,cta.dc_hia DC,cta.cd_tp_moeda,sum(vlr_org_hia) Valor, Par_moeda,
	(convert(datetime,dt_ins_hia,105)) Dia
from 
	cta_cte_hou_imp_aer cta

	inner join pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hia)
	left join caixa_hou_imp_aer cxa on 
		(
			cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx 
			and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' and 
			convert(datetime,Dt_Pgto_Rcto_hia,105) <= convert(datetime,@dataFinal,105)
		)
	left join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' and dt_par=@DataParidade

where 
	cxa.num_proc_hia is null and 
	desp_org_hia='N' and convert(datetime,dt_ins_hia,105)<=convert(datetime,@DataFinal,105)	
	and left(cta.num_proc_hia,5) <> 'IAJOB'	
	
group by
	apelido, (convert(datetime,dt_ins_hia,105))  
	,par_moeda,cta.cd_tp_moeda,cta.dc_hia		

UNION ALL

--IMPORTAÇÃO AÉREA MASTER
SELECT
	'IA' Modal, apelido,cta.dc_mia DC,cta.cd_tp_moeda,sum(vlr_org_mia ) Valor,par_moeda,
	(convert(datetime,dt_ins_mia,105)) Dia 
FROM
	cta_cte_mas_imp_aer cta
	JOIN pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mia)
	LEFT OUTER JOIN caixa_mas_imp_aer cxa on 
		(
			cta.num_proc_mia=cxa.num_proc_mia and 
			cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and num_lcto <> 'PROVISÓRIO' 
			and convert(datetime,Dt_Pgto_Rcto_mia,105) <= convert(datetime,@DataFinal,105)
		)
	LEFT OUTER JOIN	paridade PAR on 
		(
			CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' 
			and dt_par=@DataParidade
		)
WHERE
	cxa.num_proc_mia is null and 
	desp_org_mia='N' and convert(datetime,dt_ins_mia,105)<=convert(datetime,@DataFinal,105)		
GROUP BY
	apelido,(convert(datetime,dt_ins_mia,105))  
	,par_moeda,cta.cd_tp_moeda,cta.dc_mia		

union all
--IMPORTAÇÃO MARITIMA HOUSE

SELECT
	'IM' Modal,apelido,cta.dc_him DC,cta.cd_tp_moeda,sum(vlr_org_him) Valor, 
	Par_moeda, (convert(datetime,dt_ins_him,105)) Dia 
FROM
	cta_cte_hou_imp_mar cta
	JOIN pessoa pp on (pp.cd_pes=cta.cd_cred_dev_him)
	LEFT OUTER JOIN caixa_hou_imp_mar cxa on 
		(
			cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx 
			and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' 
			and convert(datetime,Dt_Pgto_Rcto_him,105) <= convert(datetime,@DataFinal,105)
		)
	LEFT OUTER JOIN paridade PAR on 
		(
			CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' 
			and dt_par=@dataparidade
		)
WHERE
	cxa.num_proc_him is null and cta.dC_him='D' and desp_org_him='N'
	and convert(datetime,dt_ins_him,105)<=convert(datetime,@DataFinal,105)	
	and left(cta.num_proc_him,5) <> 'IMJOB'
GROUP BY
	apelido,(convert(datetime,dt_ins_him,105))  
	,par_moeda,cta.cd_tp_moeda,cta.dc_him		

UNION ALL

--IMPORTAÇÃO MARITIMA MASTER

SELECT
	 'IM' Modal, apelido,cta.dc_mim DC,cta.cd_tp_moeda,sum(vlr_org_mim ) Valor,
	par_moeda,(convert(datetime,dt_ins_mim,105)) Dia  
FROM
	cta_cte_mas_imp_mar cta
	JOIN pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mim)
	LEFT OUTER JOIN caixa_mas_imp_mar cxa on 
		(
			cta.num_proc_mim=cxa.num_proc_mim and 
			Cta.cd_tp_tx=cxa.cd_tp_tx and 
			cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' 
			and convert(datetime,Dt_Pgto_Rcto_mim,105) <= convert(datetime,@DataFinal,105)
		)
	LEFT OUTER JOIN paridade PAR on
		(		
 			CTA.cd_tp_moeda=PAR.cd_tp_moeda  and 
			PAR.cd_tp_par='OFC' and dt_par=@DataParidade
		)
WHERE
	cxa.num_proc_mim is null and desp_org_mim='N' 
	and convert(datetime,dt_ins_mim,105)<=convert(datetime,@DataFinal,105)		

GROUP BY
	apelido, (convert(datetime,dt_ins_mim,105)),
	par_moeda,cta.cd_tp_moeda,cta.dc_mim		


UNION ALL

--EXPORTAÇÃO AEREA HOUSE

SELECT
	'EA' Modal,apelido,cta.dc_hea DC,cta.cd_tp_moeda,sum(vlr_org_hea) Valor, 
	Par_moeda,(convert(datetime,dt_ins_hea,105)) Dia 
FROM 
	cta_cte_hou_exp_aer cta
	JOIN pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hea)
	LEFT OUTER JOIN caixa_hou_exp_aer cxa on 
		(
			cta.num_proc_hea=cxa.num_proc_hea and 
			cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea 
			and num_lcto <> 'PROVISÓRIO' 
			and convert(datetime,Dt_Pgto_Rcto_hea,105) <= convert(datetime,@DataFinal,105)
		)
	LEFT OUTER JOIN paridade PAR on 
		(
			CTA.cd_tp_moeda=PAR.cd_tp_moeda and 
			PAR.cd_tp_par='OFC' and dt_par=@DataParidade
		)
WHERE 
	cxa.num_proc_hea is null and  desp_dst_hea='N'
	and convert(datetime,dt_ins_hea,105)<=convert(datetime,@DataFinal,105)	
	and left(Cta.num_proc_hea,5) <> 'EAJOB'
GROUP BY
	apelido, (convert(datetime,dt_ins_hea,105))  
	,par_moeda,cta.cd_tp_moeda,cta.dc_hea		

UNION ALL

--EXPORTAÇÃO AÉREA MASTER

SELECT
	'EA' Modal, apelido,cta.dc_mea DC,cta.cd_tp_moeda,sum(vlr_org_mea ) Valor,par_moeda,
	(convert(datetime,dt_ins_mea,105)) Dia 
FROM 
	cta_cte_mas_exp_aer cta
	JOIN pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mea)
	LEFT OUTER JOIN caixa_mas_exp_aer cxa on 
		(
			cta.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx 
			and cta.dc_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO' and 
			convert(datetime,Dt_Pgto_Rcto_mea,105) <= convert(datetime,@DataFinal,105)
		)
	LEFT OUTER JOIN paridade PAR on 
		(
			CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC'
			and dt_par=@DataParidade
		)
WHERE 
	cxa.num_proc_mea is null 
	 and desp_dst_mea='N' and 
	convert(datetime,dt_ins_mea,105)<=convert(datetime,@DataFinal,105)		
GROUP BY
	apelido, (convert(datetime,dt_ins_mea,105)),  
	par_moeda,cta.cd_tp_moeda,cta.dc_mea		

UNION ALL

--EXPORTAÇÃO MARITIMA HOUSE
SELECT
	'EM' Modal,apelido,cta.dc_hem,cta.cd_tp_moeda,sum(vlr_org_hem) Valor, 
	Par_moeda,(convert(datetime,dt_ins_hem,105)) Dia 
FROM
	cta_cte_hou_exp_mar cta
	JOIN pessoa pp on (pp.cd_pes=cta.cd_cred_dev_hem)
	LEFT OUTER JOIN caixa_hou_exp_mar cxa on 
		(
			cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and 
			cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO' and 
			convert(datetime,Dt_Pgto_Rcto_HEM,105) <= convert(datetime,@DataFinal,105)
		)
	LEFT OUTER JOIN paridade PAR on 
		(
			CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' 
			and dt_par=@DataParidade
		)
WHERE 
	cxa.num_proc_hem is null and desp_dst_hem='N'
	and convert(datetime,dt_ins_hem,105)<=convert(datetime,@DataFinal,105)	
	and left(cta.num_proc_hem,5) <> 'EMJOB'
GROUP BY
	apelido, (convert(datetime,dt_ins_hem,105))  
	,par_moeda,cta.cd_tp_moeda,cta.dc_hem		

UNION ALL

--EXPORTAÇÃO MARITIMA MASTER

SELECT
	'EM' Modal, apelido,cta.dc_mem DC,cta.cd_tp_moeda,sum(vlr_org_mem ) Valor, par_moeda,
	 (convert(datetime,dt_ins_mem,105)) Dia 
FROM
	cta_cte_mas_exp_mar cta
	JOIN pessoa pp on (pp.cd_pes=cta.cd_cred_dev_mem)
	LEFT OUTER JOIN caixa_mas_exp_mar cxa on 
		(
			cta.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and 	
			cta.dc_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO' and 
			convert(datetime,Dt_Pgto_Rcto_MEM,105) <= convert(datetime,@DataFinal,105)
		)
	LEFT OUTER JOIN paridade PAR on 
		(
			CTA.cd_tp_moeda=PAR.cd_tp_moeda  and PAR.cd_tp_par='OFC' 
			and dt_par=@DataParidade
		)
WHERE 
	cxa.num_proc_mem is null and  desp_dst_mem='N'
	and convert(datetime,dt_ins_mem,105)<=convert(datetime,@DataFinal,105)		
GROUP BY
	 apelido, (convert(datetime,dt_ins_mem,105))  
	,par_moeda,cta.cd_tp_moeda,cta.dc_mem		





GO
