SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spFat_rel 

		@DataInicial Varchar(10),
		@DataFinal Varchar(10)
as

Select 
	FatDtVenc,Apelido, cta.num_proc_hia Processo,cta.cd_Tp_moeda, SUM(vlr_org_hia) Valor,job_hia 
From 
	Cta_Cte_Hou_Imp_Aer CTA
	Left Join Caixa_Hou_Imp_Aer CXA on Cta.num_proc_hia=cxa.num_proc_hia and cta.cd_Tp_tx=CXA.cd_Tp_Tx and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO'  and convert(datetime,dt_pgto_Rcto_hia,105) <=@DataFinal
	Join House_imp_Aer Hou on hou.num_proc_hia=cta.num_proc_hia
	Join Pessoa PP on pp.cd_pes=cd_import_hia
	left Join job_imp_Aer JOB on hou.job_hia=job.num_proc_hia
	lEFT Join ITEM_FAT ITF ON cta.num_proc_hia=itf.num_Proc and cta.cd_tp_tx=itf.cd_tp_tx and cta.dc_hia=itf.dc 
	left join fatura fat on itf.fatcod=fat.fatcod
where 
	num_lcto is null and desp_org_hia='N' and comp_rp_hia='S'
	and cta.dc_hia='C' and fatdtvenc between @datainicial and @datafinal

GROUP BY
	FatDtVenc,Apelido, cta.num_proc_hia,cta.cd_Tp_moeda,job_hia


UNION

Select 
	FatDtVenc,Apelido, cta.num_proc_him Processo,cta.cd_Tp_moeda, Sum(vlr_org_him) Valor,job_him 
From 
	Cta_Cte_Hou_Imp_mar CTA
	Left Join Caixa_Hou_Imp_mar CXA on Cta.num_proc_him=cxa.num_proc_him and cta.cd_Tp_tx=CXA.cd_Tp_Tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO'  and convert(datetime,dt_pgto_Rcto_him,105) <=@DataFinal
	Join House_imp_mar Hou on hou.num_proc_him=cta.num_proc_him
	Join Pessoa PP on pp.cd_pes=cd_import_him
	left Join job_imp_mar JOB on hou.job_him=job.num_proc_him
	lEFT Join ITEM_FAT ITF ON cta.num_proc_him=itf.num_Proc and cta.cd_tp_tx=itf.cd_tp_tx and cta.dc_him=itf.dc 
	left join fatura fat on itf.fatcod=fat.fatcod
where 
	num_lcto is null and desp_org_him='N' and comp_rp_him='S'
	and cta.dc_him='C' and fatdtvenc between @datainicial and @datafinal
Group by
	FatDtVenc,Apelido, cta.num_proc_him ,cta.cd_Tp_moeda,job_him

UNION

Select 
	FatDtVenc,Apelido, cta.num_proc_hea Processo,cta.cd_Tp_moeda, Sum(vlr_org_hea) Valor, job_hea 
From 
	Cta_Cte_Hou_exp_Aer CTA
	Left Join Caixa_Hou_exp_Aer CXA on Cta.num_proc_hea=cxa.num_proc_hea and cta.cd_Tp_tx=CXA.cd_Tp_Tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO'  and convert(datetime,dt_pgto_Rcto_hea,105) <=@DataFinal
	Join House_exp_Aer Hou on hou.num_proc_hea=cta.num_proc_hea
	Join Pessoa PP on pp.cd_pes=cd_export_hea
	left Join job_exp_Aer JOB on hou.job_hea=job.num_proc_hea
	lEFT Join ITEM_FAT ITF ON cta.num_proc_hea=itf.num_Proc and cta.cd_tp_tx=itf.cd_tp_tx and cta.dc_hea=itf.dc 
	left join fatura fat on itf.fatcod=fat.fatcod
where 
	num_lcto is null and desp_dst_hea='N' and comp_rp_hea='S'
	and cta.dc_hea='C' and fatdtvenc between @datainicial and @datafinal
Group by 
	FatDtVenc,Apelido, cta.num_proc_hea ,cta.cd_Tp_moeda,job_hea

UNION

Select 
	FatDtVenc,Apelido, cta.num_proc_hem Processo,cta.cd_Tp_moeda, Sum(vlr_org_hem) Valor, job_hem 
From 
	Cta_Cte_Hou_exp_mar CTA
	Left Join Caixa_Hou_exp_mar CXA on Cta.num_proc_hem=cxa.num_proc_hem and cta.cd_Tp_tx=CXA.cd_Tp_Tx and cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO'  and convert(datetime,dt_pgto_Rcto_hem,105) <=@DataFinal
	Join House_exp_mar Hou on hou.num_proc_hem=cta.num_proc_hem
	Join Pessoa PP on pp.cd_pes=cd_export_hem
	left Join job_exp_mar JOB on hou.job_hem=job.num_proc_hem
	lEFT Join ITEM_FAT ITF ON cta.num_proc_hem=itf.num_Proc and cta.cd_tp_tx=itf.cd_tp_tx and cta.dc_hem=itf.dc 
	left join fatura fat on itf.fatcod=fat.fatcod
where 
	num_lcto is null and desp_dst_hem='N' and comp_rp_hem='S'
	and cta.dc_hem='C' and fatdtvenc between @datainicial and @datafinal
GROUP BY
	FatDtVenc,Apelido, cta.num_proc_hem ,cta.cd_Tp_moeda,job_hem 

GO
