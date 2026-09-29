SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[spNetRevenue_Sel] --'IOCSR20080200701'
	
			@Num_Proc		Varchar(16)

as

Declare @Resultado Table
		(
			
			Valor	 Decimal(10,2)
		)	

		SET NOCOUNT on;
/*
Insert @Resultado

Select  
		sum(dbo.valor(vlr_org_hia,cta.dc_hia)) Valor
From 
	House_Imp_Aer HOU with(nolock)
	Join Cta_Cte_hou_imp_aer CTA with(nolock) on CTA.num_proc_hia=hou.num_proc_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_Hou_Imp_aer CXA with(nolock) on CTA.num_proc_hia=CXA.NUM_PROC_HIA AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_HIA=CXA.DC_HIA
Where
	 cta.cd_Tp_moeda='REL' and desp_org_hia='N' and left(hou.num_proc_hia,5) <> 'IAJOB'
	and Cta.num_proc_hia =@Num_Proc

union All

Select 
	sum(dbo.valor(vlr_org_hia*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_hia) )

From 
	House_Imp_Aer HOU with(nolock)
	Join Cta_Cte_hou_imp_aer CTA with(nolock) on CTA.num_proc_hia=hou.num_proc_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_imp_Aer CXa with(nolock) on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_hia,105))=month(convert(Datetime,dt_emis_hia,105)) and year(convert(datetime,dt_pgto_rcto_hia,105))=year(convert(datetime,dt_emis_hia,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_hia,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_hia,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_hia='N'
	and cxa.num_lcto is null and left(hou.num_proc_hia,5) <> 'IAJOB'
	and hou.num_proc_hia =@Num_Proc

union All

Select 
	sum(dbo.valor(Vlr_Pgto_Rcto_hia,cta.dc_hia)) Valor
From 
	House_Imp_Aer HOU with(nolock)
	Join Cta_Cte_hou_imp_aer CTA with(nolock) on CTA.num_proc_hia=hou.num_proc_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_imp_Aer CXa with(nolock) on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_pgto_Rcto_hia,105))=month(convert(datetime,dt_emis_hia,105)) and year(convert(Datetime,dt_pgto_rcto_hia,105))=year(convert(datetime,dt_emis_hia,105))
Where
	 cta.cd_Tp_moeda<>'REL' and desp_org_hia='N' and left(hou.num_proc_hia,5) <> 'IAJOB'
	 and hou.num_proc_hia =@Num_Proc


Union All

Select 
	sum((cast(dbo.valor(vlr_org_Mia,cta.dc_Mia)*isnull(dbo.sppar_Masc(num_proc_hia,rateio_tx),1) as Decimal(15,2)))) Valor

From 
	House_Imp_Aer HOU
	Join Cta_Cte_MAS_imp_aer CTA on CTA.num_proc_Mia=hou.num_proc_Mia
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_mas_imp_aer CXA on CTA.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_mia=cxa.dc_mia
Where
	cta.cd_Tp_moeda='REL' and desp_org_Mia='N' and left(hou.num_proc_hia,5)<>'IAJOB'
	and hou.num_proc_hia =@Num_Proc

Union All

Select 
	sum((cast(dbo.valor(vlr_org_Mia,cta.dc_Mia)*isnull(dbo.sppar_Masc(num_proc_hia,rateio_tx),1) as Decimal(15,2)))) Valor
From 
	House_Imp_Aer HOU with(nolock)
	Join Cta_Cte_MAS_imp_aer CTA with(nolock) on CTA.num_proc_Mia=hou.num_proc_Mia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_MAS_imp_Aer CXa with(nolock) on CTA.num_proc_Mia=cxa.num_proc_Mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_Mia=cxa.dc_Mia and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_Mia,105))=month(convert(Datetime,dt_emis_hia,105)) and year(convert(datetime,dt_pgto_rcto_Mia,105))=year(convert(datetime,dt_emis_hia,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_hia,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_hia,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_Mia='N'
	and cxa.num_lcto is null and left(hou.num_proc_hia,5) <> 'IAJOB'
	and hou.num_proc_hia =@Num_Proc


UNION ALL


Select 
	sum((cast(dbo.valor(vlr_pgto_rcto_Mia,cta.dc_Mia)*isnull(dbo.sppar_Masc(num_proc_hia,rateio_tx),1) as Decimal(15,2)))) Valor

From 
	House_Imp_Aer HOU with(nolock)
	Join Cta_Cte_MAS_imp_aer CTA with(nolock) on CTA.num_proc_mia=hou.num_proc_mia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_MAS_imp_Aer CXa with(nolock) on CTA.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_mia=cxa.dc_mia and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_emis_hia,105))=month(convert(datetime,dt_pgto_Rcto_mia,105)) and Year(convert(datetime,dt_emis_hia,105))=Year(convert(datetime,dt_pgto_Rcto_mia,105))
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_mia='N' and left(hou.num_proc_hia,5) <> 'IAJOB'
	and hou.num_proc_hia =@Num_Proc

union All

Select 
	sum(dbo.valor(vlr_org_HIM,cta.dc_HIM)) Valor

From 
	House_Imp_MAR HOU with(nolock)
	Join Cta_Cte_hou_imp_MAR CTA with(nolock) on CTA.num_proc_HIM=hou.num_proc_HIM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_imp_mar cxa with(nolock) on cta.num_proc_him=cxa.num_proc_him and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him
Where
	 cta.cd_Tp_moeda='REL' and desp_org_HIM='N' and left(hou.num_proc_HIM,5) <> 'IMJOB'
	 and hou.num_proc_him =@Num_Proc

union All


Select 
	sum(dbo.valor(vlr_org_HIM*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_HIM) )

From 
	House_Imp_MAR HOU with(nolock)
	Join Cta_Cte_hou_imp_MAR CTA with(nolock) on CTA.num_proc_HIM=hou.num_proc_HIM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_imp_MAR CXa with(nolock) on CTA.num_proc_HIM=cxa.num_proc_HIM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HIM=cxa.dc_HIM and num_lcto <> 'PROVISÓRIO' 
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_HIM,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_HIM,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_HIM='N'
	and cxa.num_lcto is null and left(hou.num_proc_HIM,5) <> 'IMJOB'
	and hou.num_proc_him =@Num_Proc



union All


Select 
	sum(dbo.valor(Vlr_Pgto_Rcto_HIM,cta.dc_HIM)) Valor
  
From 
	House_Imp_MAR HOU with(nolock)
	Join Cta_Cte_hou_imp_MAR CTA with(nolock) on CTA.num_proc_HIM=hou.num_proc_HIM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_imp_MAR CXa with(nolock) on CTA.num_proc_HIM=cxa.num_proc_HIM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HIM=cxa.dc_HIM and num_lcto <> 'PROVISÓRIO' 
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_HIM='N' and left(hou.num_proc_HIM,5) <> 'IMJOB'
	and hou.num_proc_him =@Num_Proc


	
Union All

--(cast(dbo.valor(vlr_org_mim,dc_mim)*isnull(dbo.sppar_Masc(num_proc_HIM,rateio_tx),1) as Decimal(15,2))) Valor
Select 
	sum(cast(dbo.valor(vlr_org_mim,cta.dc_mim)*isnull(dbo.sppar_Masc(num_proc_HIM,rateio_tx),1) as Decimal(15,2))) Valor
From 
	House_Imp_MAR HOU with(nolock)
	Join Cta_Cte_MAS_imp_MAR CTA with(nolock) on CTA.num_proc_mim=hou.num_proc_mim
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_mas_imp_mar cXA with(nolock) on cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim
Where
	cta.cd_Tp_moeda='REL' and desp_org_mim='N' and left(hou.num_proc_HIM,5)<>'IMJOB'
	and hou.num_proc_him =@Num_Proc



Union All

Select 
	sum(cast(dbo.valor(vlr_org_mim,cta.dc_mim)*isnull(dbo.sppar_Masc(num_proc_HIM,rateio_tx),1) as Decimal(15,2))) Valor
From 
	House_Imp_MAR HOU With(nolock)
	Join Cta_Cte_MAS_imp_MAR CTA with(nolock) on CTA.num_proc_mim=hou.num_proc_mim
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_MAS_imp_MAR CXa with(nolock) on CTA.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_mim,105))=month(convert(Datetime,dt_emis_him,105)) and year(convert(datetime,dt_pgto_rcto_mim,105))=year(convert(datetime,dt_emis_him,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_him,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_him,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'

Where
	cta.cd_Tp_moeda<>'REL' and desp_org_mim='N'
	and cxa.num_lcto is null and left(hou.num_proc_HIM,5) <> 'IMJOB'
	and hou.num_proc_him =@Num_Proc


UNION All


Select 
	sum(cast(dbo.valor(vlr_pgto_rcto_mim,cta.dc_mim)*isnull(dbo.sppar_Masc(num_proc_HIM,rateio_tx),1) as Decimal(15,2))) Valor

From 
	House_Imp_MAR HOU with(nolock)
	Join Cta_Cte_MAS_imp_MAR CTA with(nolock) on CTA.num_proc_mim=hou.num_proc_mim
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_MAS_imp_MAR CXa with(nolock) on CTA.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_emis_him,105))=month(convert(datetime,dt_pgto_Rcto_mim,105)) and Year(convert(datetime,dt_emis_him,105))=Year(convert(datetime,dt_pgto_Rcto_mim,105))
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_mim='N' and left(hou.num_proc_HIM,5) <> 'IMJOB'
	and hou.num_proc_him =@Num_Proc

union All

Select 
	sum(dbo.valor(vlr_org_HEA,cta.dc_HEA)) Valor
From 
	House_EXP_Aer HOU with(nolock)
	Join Cta_Cte_hou_EXP_aer CTA with(nolock) on CTA.num_proc_HEA=hou.num_proc_HEA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	LEft Join Caixa_hou_exp_aer CXA with(nolock) on CTA.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea
Where
	 cta.cd_Tp_moeda='REL' and desp_dst_HEA='N' and left(hou.num_proc_HEA,5) <> 'EAJOB'
	and hou.num_proc_hea =@Num_Proc


union All


Select 
	sum(dbo.valor(vlr_org_HEA*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_HEA)) 
From 
	House_EXP_Aer HOU with(nolock)
	Join Cta_Cte_hou_EXP_aer CTA with(nolock) on CTA.num_proc_HEA=hou.num_proc_HEA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_EXP_Aer CXa with(nolock) on CTA.num_proc_HEA=cxa.num_proc_HEA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HEA=cxa.dc_HEA and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_HEA,105))=month(convert(Datetime,dt_emis_HEA,105)) and year(convert(datetime,dt_pgto_rcto_HEA,105))=year(convert(datetime,dt_emis_HEA,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_HEA,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_HEA,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_dst_HEA='N'
	and cxa.num_lcto is null and left(hou.num_proc_HEA,5) <> 'EAJOB'
	and hou.num_proc_hea =@Num_Proc

union All


Select 
	sum(dbo.valor(Vlr_Pgto_Rcto_HEA,cta.dc_HEA)) Valor
From 
	House_EXP_Aer HOU with(nolock)
	Join Cta_Cte_hou_EXP_aer CTA with(nolock) on CTA.num_proc_HEA=hou.num_proc_HEA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_EXP_Aer CXa with(nolock) on CTA.num_proc_HEA=cxa.num_proc_HEA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HEA=cxa.dc_HEA and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_pgto_Rcto_HEA,105))=month(convert(datetime,dt_emis_HEA,105)) and year(convert(Datetime,dt_pgto_rcto_HEA,105))=year(convert(datetime,dt_emis_HEA,105))
Where
	 cta.cd_Tp_moeda<>'REL' and desp_dst_HEA='N' and left(hou.num_proc_HEA,5) <> 'EAJOB'
	and hou.num_proc_hea =@Num_Proc



Union All

--(cast(dbo.valor(vlr_org_MEA,dc_MEA)*isnull(dbo.sppar_Masc(num_proc_HEA,rateio_tx),1) as Decimal(15,2))) Valor
Select 
	sum(cast(dbo.valor(vlr_org_MEA,cta.dc_MEA)*isnull(dbo.sppar_Masc(num_proc_HEA,rateio_tx),1) as Decimal(15,2))) Valor
From 
	House_EXP_Aer HOU with(nolock)
	Join Cta_Cte_MAS_EXP_aer CTA with(nolock) on CTA.num_proc_MEA=hou.num_proc_MEA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	LEft Join Caixa_mas_Exp_aer CXA with(nolock) on cta.num_proc_mea=CXA.num_proc_mea and cta.dc_mea=cxa.dc_mea and cta.cd_tp_tx=cxa.cd_tp_Tx
Where
	cta.cd_Tp_moeda='REL' and desp_dst_MEA='N' and left(hou.num_proc_HEA,5)<>'EAJOB'
	and hou.num_proc_hea =@Num_Proc

Union All

Select 
	sum(cast(dbo.valor(vlr_org_MEA,cta.dc_MEA)*isnull(dbo.sppar_Masc(num_proc_HEA,rateio_tx),1) as Decimal(15,2))) Valor
From 
	House_EXP_Aer HOU with(nolock)
	Join Cta_Cte_MAS_EXP_aer CTA with(nolock) on CTA.num_proc_MEA=hou.num_proc_MEA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_MAS_EXP_Aer CXa with(nolock) on CTA.num_proc_MEA=cxa.num_proc_MEA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_MEA=cxa.dc_MEA and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_MEA,105))=month(convert(Datetime,dt_emis_HEA,105)) and year(convert(datetime,dt_pgto_rcto_MEA,105))=year(convert(datetime,dt_emis_HEA,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_HEA,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_HEA,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_dst_MEA='N'
	and cxa.num_lcto is null and left(hou.num_proc_HEA,5) <> 'EAJOB'
	and hou.num_proc_hea =@Num_Proc

UNION ALL


Select 
	sum(cast(dbo.valor(vlr_pgto_rcto_mea,cta.dc_MEA)*isnull(dbo.sppar_Masc(num_proc_HEA,rateio_tx),1) as Decimal(15,2))) Valor
From 
	House_EXP_Aer HOU with(nolock)
	Join Cta_Cte_MAS_EXP_aer CTA with(nolock) on CTA.num_proc_MEA=hou.num_proc_MEA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_MAS_EXP_Aer CXa with(nolock) on CTA.num_proc_MEA=cxa.num_proc_MEA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_MEA=cxa.dc_MEA and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_emis_HEA,105))=month(convert(datetime,dt_pgto_Rcto_MEA,105)) and Year(convert(datetime,dt_emis_HEA,105))=Year(convert(datetime,dt_pgto_Rcto_MEA,105))
Where
	cta.cd_Tp_moeda<>'REL' and desp_dst_MEA='N' and left(hou.num_proc_HEA,5) <> 'EAJOB'
	and hou.num_proc_hea =@Num_Proc


union All


Select 
	sum(dbo.valor(vlr_org_HEM,cta.dc_HEM)) Valor
  
From 
	House_EXP_MAR HOU with(nolock) 
	Join Cta_Cte_hou_EXP_MAR CTA with(nolock) on CTA.num_proc_HEM=hou.num_proc_HEM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_exp_mar CXA on CTA.num_proc_hem=CXa.num_proc_hem and cta.cd_Tp_tx=cxa.cd_Tp_Tx and cta.dc_hem=cxa.dc_hem
Where
	 cta.cd_Tp_moeda='REL' and desp_dst_HEM='N' and left(hou.num_proc_HEM,5) <> 'EMJOB'
	 and hou.num_proc_hem =@Num_Proc


union All


Select 
	sum(dbo.valor(vlr_org_HEM*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_HEM)) 
 
From 
	House_EXP_MAR HOU with(nolock)
	Join Cta_Cte_hou_EXP_MAR CTA with(nolock) on CTA.num_proc_HEM=hou.num_proc_HEM
	Join Tipo_Taxa TT  with(nolock)on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_EXP_MAR CXa with(nolock) on CTA.num_proc_HEM=cxa.num_proc_HEM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HEM=cxa.dc_HEM and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_HEM,105))=month(convert(Datetime,dt_emis_HEM,105)) and year(convert(datetime,dt_pgto_rcto_HEM,105))=year(convert(datetime,dt_emis_HEM,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_HEM,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock)  on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_HEM,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_dst_HEM='N'
	and cxa.num_lcto is null and left(hou.num_proc_HEM,5) <> 'EMJOB'
	and hou.num_proc_hem =@Num_Proc

union All


Select 
	sum(dbo.valor(Vlr_Pgto_Rcto_HEM,cta.dc_HEM)) Valor
 
From 
	House_EXP_MAR HOU with(nolock)
	Join Cta_Cte_hou_EXP_MAR CTA with(nolock) on CTA.num_proc_HEM=hou.num_proc_HEM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_EXP_MAR CXa with(nolock) on CTA.num_proc_HEM=cxa.num_proc_HEM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HEM=cxa.dc_HEM and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_pgto_Rcto_HEM,105))=month(convert(datetime,dt_emis_HEM,105)) and year(convert(Datetime,dt_pgto_rcto_HEM,105))=year(convert(datetime,dt_emis_HEM,105))
Where
	cta.cd_Tp_moeda<>'REL' and desp_dst_HEM='N' and left(hou.num_proc_HEM,5) <> 'EMJOB'
	and hou.num_proc_hem =@Num_Proc

Union

--(cast(dbo.valor(vlr_org_MEM,dc_MEM)*isnull(dbo.sppar_Masc(num_proc_HEM,rateio_tx),1) as Decimal(15,2))) Valor
Select 
	sum((cast(dbo.valor(vlr_org_MEM,cta.dc_MEM)*isnull(dbo.sppar_Masc(num_proc_HEM,rateio_tx),1) as Decimal(15,2)))) Valor
From 
	House_EXP_MAR HOU with(nolock)
	Join Cta_Cte_MAS_EXP_MAR CTA with(nolock) on CTA.num_proc_MEM=hou.num_proc_MEM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	LEft Join Caixa_mas_exp_mar CXA with(nolock) on CTA.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem
Where
	cta.cd_Tp_moeda='REL' and desp_dst_MEM='N' and left(hou.num_proc_HEM,5)<>'EMJOB'
	and hou.num_proc_hem =@Num_Proc

Union All

Select 
	sum(cast(dbo.valor(vlr_org_MEM,cta.dc_MEM)*isnull(dbo.sppar_Masc(num_proc_HEM,rateio_tx),1) as Decimal(15,2))) Valor
  
From  
	House_EXP_MAR HOU with(nolock)
	Join Localidade DST with(nolock) on DST.cd_local=CD_ORG_HEM
	Join Cta_Cte_MAS_EXP_MAR CTA with(nolock) on CTA.num_proc_MEM=hou.num_proc_MEM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_MAS_EXP_MAR CXa with(nolock) on CTA.num_proc_MEM=cxa.num_proc_MEM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_MEM=cxa.dc_MEM and num_lcto <> 'PROVISÓRIO'-- AND month(convert(Datetime,dt_pgto_rcto_MEM,105))=month(convert(Datetime,dt_emis_HEM,105)) and year(convert(datetime,dt_pgto_rcto_MEM,105))=year(convert(datetime,dt_emis_HEM,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_HEM,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_HEM,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_dst_MEM='N'
	and cxa.num_lcto is null and left(hou.num_proc_HEM,5) <> 'EMJOB'
	and hou.num_proc_hem =@Num_Proc

UNION All


Select 
	sum(cast(dbo.valor(vlr_pgto_rcto_MEM,cta.dc_MEM)*isnull(dbo.sppar_Masc(num_proc_HEM,rateio_tx),1) as Decimal(15,2))) Valor
 
From 
	House_EXP_MAR HOU with(nolock)
	Join Cta_Cte_MAS_EXP_MAR CTA with(nolock) on CTA.num_proc_MEM=hou.num_proc_MEM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_MAS_EXP_MAR CXa with(nolock) on CTA.num_proc_MEM=cxa.num_proc_MEM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_MEM=cxa.dc_MEM and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_emis_HEM,105))=month(convert(datetime,dt_pgto_Rcto_MEM,105)) and Year(convert(datetime,dt_emis_HEM,105))=Year(convert(datetime,dt_pgto_Rcto_MEM,105))
Where
	cta.cd_Tp_moeda<>'REL' and desp_dst_MEM='N' and left(hou.num_proc_HEM,5) <> 'EMJOB'
	and hou.num_proc_hem =@Num_Proc


UNION All


Select 
	sum(dbo.valor(vlr_org_HIO,cta.dc_HIO)) Valor

From 
	House_Imp_OUT HOU with(nolock)
	Join Cta_Cte_hou_imp_OUT CTA with(nolock) on CTA.num_proc_HIO=hou.num_proc_HIO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_imp_out cxa with(nolock) on cta.num_proc_hio=cxa.num_proc_hio and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hio=cxa.dc_hio
Where
	 cta.cd_Tp_moeda='REL' and desp_org_HIO='N' and left(hou.num_proc_HIO,5) <> 'IOJOB'
	and hou.num_proc_hio =@Num_Proc


union All


Select 
	sum(dbo.valor(vlr_org_HIO*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_HIO)) 
From 
	House_Imp_OUT HOU with(nolock)
	Join Cta_Cte_hou_imp_OUT CTA with(nolock) on CTA.num_proc_HIO=hou.num_proc_HIO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_imp_OUT CXa with(nolock) on CTA.num_proc_HIO=cxa.num_proc_HIO and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HIO=cxa.dc_HIO and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_HIO,105))=month(convert(Datetime,dt_emis_HIO,105)) and year(convert(datetime,dt_pgto_rcto_HIO,105))=year(convert(datetime,dt_emis_HIO,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_HIO,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_HIO,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_HIO='N'
	and cxa.num_lcto is null and left(hou.num_proc_HIO,5) <> 'IOJOB'	 
	and hou.num_proc_hio =@Num_Proc

union All


Select 
	sum(dbo.valor(Vlr_Pgto_Rcto_HIO,cta.dc_HIO)) Valor
From 
	House_Imp_OUT HOU with(nolock)
	Join Cta_Cte_hou_imp_OUT CTA with(nolock) on CTA.num_proc_HIO=hou.num_proc_HIO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_imp_OUT CXa with(nolock) on CTA.num_proc_HIO=cxa.num_proc_HIO and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HIO=cxa.dc_HIO and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_pgto_Rcto_HIO,105))=month(convert(datetime,dt_emis_HIO,105)) and year(convert(Datetime,dt_pgto_rcto_HIO,105))=year(convert(datetime,dt_emis_HIO,105))
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_HIO='N' and left(hou.num_proc_HIO,5) <> 'IOJOB'
	and hou.num_proc_hio =@Num_Proc



union All


Select 
	sum(dbo.valor(vlr_org_HEO,cta.dc_HEO)) Valor
From 
	House_EXP_OUT HOU with(nolock)
	Join Cta_Cte_hou_EXP_OUT CTA with(nolock) on CTA.num_proc_HEO=hou.num_proc_HEO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_exp_out CXA with(nolock) on CTA.num_proc_heo=cxa.num_proc_heo and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_heo=cxa.dc_heo
Where
	 cta.cd_Tp_moeda='REL' and desp_org_HEO='N' and left(hou.num_proc_HEO,5) <> 'EOJOB'

	 and hou.num_proc_heo =@Num_Proc



union All


Select 
	sum(dbo.valor(vlr_org_HEO*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_HEO) )
From 
	House_EXP_OUT HOU with(nolock)
	Join Cta_Cte_hou_EXP_OUT CTA with(nolock) on CTA.num_proc_HEO=hou.num_proc_HEO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_EXP_OUT CXa with(nolock) on CTA.num_proc_HEO=cxa.num_proc_HEO and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HEO=cxa.dc_HEO and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_HEO,105))=month(convert(Datetime,dt_emis_HEO,105)) and year(convert(datetime,dt_pgto_rcto_HEO,105))=year(convert(datetime,dt_emis_HEO,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_HEO,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_HEO,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_HEO='N'
	and cxa.num_lcto is null and left(hou.num_proc_HEO,5) <> 'EOJOB'
	and hou.num_proc_heo =@Num_Proc



union All


Select 
	sum(dbo.valor(Vlr_Pgto_Rcto_HEO,cta.dc_HEO)) Valor
From 
	House_EXP_OUT HOU with(nolock)
	Join Cta_Cte_hou_EXP_OUT CTA with(nolock) on CTA.num_proc_HEO=hou.num_proc_HEO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_EXP_OUT CXa with(nolock) on CTA.num_proc_HEO=cxa.num_proc_HEO and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HEO=cxa.dc_HEO and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_pgto_Rcto_HEO,105))=month(convert(datetime,dt_emis_HEO,105)) and year(convert(Datetime,dt_pgto_rcto_HEO,105))=year(convert(datetime,dt_emis_HEO,105))
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_HEO='N' and left(hou.num_proc_HEO,5) <> 'EOJOB'
	and hou.num_proc_heo =@Num_Proc


UNION All


Select 
	sum(dbo.valor(vlr_org_MIM,cta.dc_mim)) Valor

From 
	Master_Imp_MAR HOU with(nolock)
	Join Cta_Cte_MAS_imp_MAR CTA with(nolock) on CTA.num_proc_MIM=hou.num_proc_MIM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_mas_imp_mar cxa with(nolock) on cta.num_proc_MIM=cxa.num_proc_MIM and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim
Where
	 cta.cd_Tp_moeda='REL' and desp_org_MIM='N' and left(hou.num_proc_MIM,5) <> 'IMJOB'
	 and hou.num_proc_MIM =@Num_Proc


union All


Select 
	sum(dbo.valor(vlr_org_MIM*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_mim)) 
From 
	Master_Imp_MAR HOU with(nolock)
	Join Cta_Cte_MAS_imp_MAR CTA with(nolock) on CTA.num_proc_MIM=hou.num_proc_MIM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_mas_imp_mar CXa with(nolock) on CTA.num_proc_MIM=cxa.num_proc_MIM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' 
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_MIM,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_MIM,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_MIM='N'
	and cxa.num_lcto is null and left(hou.num_proc_MIM,5) <> 'IMJOB'
	and hou.num_proc_MIM =@Num_Proc



union ALL


Select 
	sum(dbo.valor(Vlr_Pgto_Rcto_MIM,cta.dc_mim)) Valor
From 
	Master_Imp_MAR HOU with(nolock)
	Join Cta_Cte_MAS_imp_MAR CTA with(nolock) on CTA.num_proc_MIM=hou.num_proc_MIM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_mas_imp_mar CXa with(nolock) on CTA.num_proc_MIM=cxa.num_proc_MIM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' 
Where
	
	 cta.cd_Tp_moeda<>'REL' and desp_org_MIM='N' and left(hou.num_proc_MIM,5) <> 'IMJOB'
	and hou.num_proc_MIM =@Num_Proc

UNION All

Select 
	sum(dbo.valor(vlr_org_MIA,cta.dc_MIA)) Valor
From 
	Master_Imp_AER HOU with(nolock)
	Join Cta_Cte_MAS_imp_AER CTA with(nolock) on CTA.num_proc_MIA=hou.num_proc_MIA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_mas_imp_AER cxa with(nolock) on cta.num_proc_MIA=cxa.num_proc_MIA and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_MIA=cxa.dc_MIA
Where
	 cta.cd_Tp_moeda='REL' and desp_org_MIA='N' and left(hou.num_proc_MIA,5) <> 'IMJOB'
	
		and hou.num_proc_MIA =@Num_Proc


union All


Select 
	sum(dbo.valor(vlr_org_MIA*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_MIA)) 
From 
	Master_Imp_AER HOU with(nolock)
	Join Cta_Cte_MAS_imp_AER CTA with(nolock) on CTA.num_proc_MIA=hou.num_proc_MIA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_mas_imp_AER CXa with(nolock) on CTA.num_proc_MIA=cxa.num_proc_MIA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_MIA=cxa.dc_MIA and num_lcto <> 'PROVISÓRIO' 
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_MIA,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_MIA,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_MIA='N'
	and cxa.num_lcto is null and left(hou.num_proc_MIA,5) <> 'IMJOB'
	and hou.num_proc_MIA =@Num_Proc



union All


Select 
	sum(dbo.valor(Vlr_Pgto_Rcto_MIA,cta.dc_MIA)) Valor
From 
	Master_Imp_AER HOU with(nolock)
	Join Cta_Cte_MAS_imp_AER CTA with(nolock) on CTA.num_proc_MIA=hou.num_proc_MIA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_mas_imp_AER CXa with(nolock) on CTA.num_proc_MIA=cxa.num_proc_MIA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_MIA=cxa.dc_MIA and num_lcto <> 'PROVISÓRIO' 
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_MIA='N' and left(hou.num_proc_MIA,5) <> 'IMJOB'
	and hou.num_proc_MIA =@Num_Proc

Select sum(isnull(valor,0)) Valor from @resultado

*/
Select 0 Valor


GO
