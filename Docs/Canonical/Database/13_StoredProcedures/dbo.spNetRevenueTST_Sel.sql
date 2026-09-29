SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spNetRevenueTST_Sel] --'01-01-2009','01-01-2010','%','%','%','IOCSR20080200701'
as

Select  top 10
		HOU.Num_proc,sum(dbo.valor(vlr_org_hia,cta.dc_hia)) Valor
From 
	dbo.vwCliente HOU with(nolock)
	Join dbo.vwcta_Cte CTA with(nolock) on CTA.num_proc_hia=hou.num_proc
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	JOIN dbo.vwALL_JOBs AL with(nolock) on HOU.num_proc = AL.num_proc
	--Left Join dbo.vwCXAS CXA with(nolock) on CTA.num_proc_hia=CXA.NUM_PROC_HIA AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_HIA=CXA.DC_HIA
Where
	 cta.cd_Tp_moeda='REL' and desp_org_hia='N' and HOU.master = 'JOB' and Isnull(ID_STatus,0)<=4 
group by HOU.Num_proc

union ALL

Select  top 10
	HOU.Num_proc,sum(dbo.valor(vlr_org_hia*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_hia) )

From 
	vwCliente HOU with(nolock)
	Join vwcta_Cte CTA with(nolock) on CTA.num_proc_hia=hou.num_proc
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join vwCXAS CXa with(nolock) on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_hia,105))=month(convert(Datetime,dt_emis_hia,105)) and year(convert(datetime,dt_pgto_rcto_hia,105))=year(convert(datetime,dt_emis_hia,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,Dt_Ins_hia,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,Dt_Ins_hia,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
	JOIN dbo.vwALL_JOBs AL with(nolock) on HOU.num_proc = AL.num_proc
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_hia='N'
	and cxa.num_lcto is null and HOU.master = 'JOB' and Isnull(ID_STatus,0)<=4 
group by HOU.Num_proc

union all
Select top 10
	HOU.Num_proc,sum(dbo.valor(Vlr_Pgto_Rcto_hia,cta.dc_hia)) Valor
From 
	vwCliente HOU with(nolock)
	Join vwcta_Cte CTA with(nolock) on CTA.num_proc_hia=hou.num_proc
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join vwCXAS CXa with(nolock) on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_pgto_Rcto_hia,105))=month(convert(datetime,dt_emis_hia,105)) and year(convert(Datetime,dt_pgto_rcto_hia,105))=year(convert(datetime,dt_emis_hia,105))
	JOIN dbo.vwALL_JOBs AL with(nolock) on HOU.num_proc = AL.num_proc
Where
	 cta.cd_Tp_moeda<>'REL' and desp_org_hia='N' and HOU.master = 'JOB' and Isnull(ID_STatus,0)<=4 
group by HOU.Num_proc

Union All

Select top 10
	HOU.Num_proc,sum((cast(dbo.valor(vlr_org_hia,cta.dc_hia)*isnull(dbo.sppar_Masc(CTA.num_proc_hia,rateio_tx),1) as Decimal(15,2)))) Valor

From 
	vwCliente HOU with(nolock)
	Join vwcta_Cte CTA with(nolock) on CTA.num_proc_hia=HOU.master
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join vwCXAS CXA with(nolock) on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia
	JOIN dbo.vwALL_JOBs AL with(nolock) on HOU.num_proc = AL.num_proc
Where
	cta.cd_Tp_moeda='REL' and desp_org_hia='N' and HOU.master <> 'JOB' and Isnull(ID_STatus,0)<=4 
group by HOU.Num_proc	
Union All

Select top 10
	HOU.Num_proc,sum((cast(dbo.valor(vlr_org_hia,cta.dc_hia)*isnull(dbo.sppar_Masc(CTA.num_proc_hia,rateio_tx),1) as Decimal(15,2)))) Valor
From 
	vwCliente HOU with(nolock)
	Join vwcta_Cte CTA with(nolock)  on CTA.num_proc_hia=HOU.master
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join vwCXAS CXa with(nolock) on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_hia,105))=month(convert(Datetime,dt_emis_hia,105)) and year(convert(datetime,dt_pgto_rcto_hia,105))=year(convert(datetime,dt_emis_hia,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_ins_hia,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_ins_hia,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
	JOIN dbo.vwALL_JOBs AL with(nolock) on HOU.num_proc = AL.num_proc
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_hia='N'
	and cxa.num_lcto is null and HOU.master <> 'JOB' and Isnull(ID_STatus,0)<=4 
group by HOU.Num_proc

UNION ALL


Select top 10
	HOU.Num_proc,sum((cast(dbo.valor(vlr_pgto_rcto_hia,cta.dc_hia)*isnull(dbo.sppar_Masc(CTA.num_proc_hia,rateio_tx),1) as Decimal(15,2)))) Valor

From 
	vwCliente HOU with(nolock)
	Join vwcta_Cte CTA with(nolock) on CTA.num_proc_hia=HOU.master
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join vwCXAS CXa with(nolock) on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_emis_hia,105))=month(convert(datetime,dt_pgto_Rcto_hia,105)) and Year(convert(datetime,dt_emis_hia,105))=Year(convert(datetime,dt_pgto_Rcto_hia,105))
	JOIN dbo.vwALL_JOBs AL with(nolock) on HOU.num_proc = AL.num_proc
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_hia='N'  and HOU.master <> 'JOB' and Isnull(ID_STatus,0)<=4 
group by HOU.Num_proc




GO
