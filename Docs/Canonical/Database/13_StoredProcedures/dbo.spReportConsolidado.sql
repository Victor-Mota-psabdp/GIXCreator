SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spReportConsolidado] --'01-01-2009','01-01-2010','%','%','%','IOCSR20080200701'
	
			@DataInicial	Char(10),
			@DataFinal		Char(10),
			@Modal			Varchar(2),
			@Localidade		Varchar(30),
			@Cliente		Varchar(50),
			@Num_Proc		Varchar(16)

as

Select 
	HOU.NUM_PROC_HIA Processo,'IA' Modal, 'HOU' HM ,'CTA_REL' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_hia,dbo.valor(vlr_org_hia,cta.dc_hia) Valor, month(convert(datetime,hou.dt_emis_hia,105)) Mes,year(convert(datetime,hou.dt_emis_hia,105)) Ano,LEFT(JOB_HIA,2) Job ,
	ISNull(cxa.num_proc_hia,'N')  Caixa,dbo.fBusca_Tarefa(cta.num_proc_hia,40) Prestacao_Contas
From 
	House_Imp_Aer HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_hia
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hia
	Join Cta_Cte_hou_imp_aer CTA with(nolock) on CTA.num_proc_hia=hou.num_proc_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_Hou_Imp_aer CXA with(nolock) on CTA.num_proc_hia=CXA.NUM_PROC_HIA AND CTA.CD_TP_TX=CXA.CD_TP_TX AND CTA.DC_HIA=CXA.DC_HIA
Where
	 cta.cd_Tp_moeda='REL' and desp_org_hia='N' and left(hou.num_proc_hia,5) <> 'IAJOB'
	 and convert(datetime,dt_emis_hia,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_hia,2) like @modal
	 and nome_local like @localidade
	 and Apelido like @Cliente and Cta.num_proc_hia like @num_proc

union

Select 
	HOU.NUM_PROC_HIA Processo,'IA' Modal, 'HOU' HM ,'CTA_OUTROS' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, CTA.dc_hia,dbo.valor(vlr_org_hia*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_hia) , month(convert(datetime,hou.dt_emis_hia,105)) Mes,year(convert(datetime,hou.dt_emis_hia,105)) Ano,LEFT(JOB_HIA,2) Job ,
	'N' Caixa,dbo.fBusca_Tarefa(cta.num_proc_hia,40) Prestacao_Contas

From 
	House_Imp_Aer HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_hia
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hia
	Join Cta_Cte_hou_imp_aer CTA with(nolock) on CTA.num_proc_hia=hou.num_proc_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_imp_Aer CXa with(nolock) on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_hia,105))=month(convert(Datetime,dt_emis_hia,105)) and year(convert(datetime,dt_pgto_rcto_hia,105))=year(convert(datetime,dt_emis_hia,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_hia,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_hia,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_hia='N'
	and cxa.num_lcto is null and left(hou.num_proc_hia,5) <> 'IAJOB'
	and convert(datetime,dt_emis_hia,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_hia,2) like @modal
	 and nome_local like @localidade
	 and Apelido like @Cliente and hou.num_proc_hia like @num_proc

union

Select 
	HOU.NUM_PROC_HIA Processo,'IA' Modal, 'HOU' HM ,'CAIXA' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_hia,dbo.valor(Vlr_Pgto_Rcto_hia,cta.dc_hia) Valor, month(convert(datetime,hou.dt_emis_hia,105)) Mes,year(convert(datetime,hou.dt_emis_hia,105)) Ano,LEFT(JOB_HIA,2) Job,
	'S' Caixa ,dbo.fBusca_Tarefa(cta.num_proc_hia,40) Prestacao_Contas

From 
	House_Imp_Aer HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_hia
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hia
	Join Cta_Cte_hou_imp_aer CTA with(nolock) on CTA.num_proc_hia=hou.num_proc_hia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_imp_Aer CXa with(nolock) on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_pgto_Rcto_hia,105))=month(convert(datetime,dt_emis_hia,105)) and year(convert(Datetime,dt_pgto_rcto_hia,105))=year(convert(datetime,dt_emis_hia,105))
Where
	convert(datetime,dt_emis_hia,105) between @DataInicial and @DataFinal
	 and cta.cd_Tp_moeda<>'REL' and desp_org_hia='N' and left(hou.num_proc_hia,5) <> 'IAJOB'
	 and left(hou.num_proc_hia,2) like @modal
	 and nome_local like @localidade
	 and Apelido like @Cliente and hou.num_proc_hia like @num_proc


Union

--(cast(dbo.valor(vlr_org_Mia,dc_Mia)*isnull(dbo.sppar_Masc(num_proc_hia,rateio_tx),1) as Decimal(15,2))) Valor
Select 
	HOU.NUM_PROC_HIA Processo,'IA' Modal, 'HOU' HM ,'REL' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_mia,(cast(dbo.valor(vlr_org_Mia,cta.dc_Mia)*isnull(dbo.sppar_Masc(num_proc_hia,rateio_tx),1) as Decimal(15,2))) Valor, month(convert(datetime,hou.dt_emis_hia,105)) Mes,year(convert(datetime,hou.dt_emis_hia,105)) Ano,LEFT(JOB_HIA,2) Job ,
	Isnull(cxa.num_proc_mia,'N') Caixa,dbo.fBusca_Tarefa(hou.num_proc_hia,40) Prestacao_Contas

From 
	House_Imp_Aer HOU
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_CONSIG_hia
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hia
	Join Cta_Cte_MAS_imp_aer CTA with(nolock) on CTA.num_proc_Mia=hou.num_proc_Mia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_mas_imp_aer CXA with(nolock) on CTA.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_mia=cxa.dc_mia
Where
	convert(datetime,dt_emis_hia,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda='REL' and desp_org_Mia='N' and left(hou.num_proc_hia,5)<>'IAJOB'
	 and left(hou.num_proc_hia,2) like @modal
	 and nome_local like @localidade
	 and Apelido like @Cliente and hou.num_proc_hia like @num_proc

Union

Select 
	HOU.NUM_PROC_HIA Processo,'IA' Modal, 'MAS' HM ,'OUTRAS_MOEDAS' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_mia,(cast(dbo.valor(vlr_org_Mia,cta.dc_Mia)*isnull(dbo.sppar_Masc(num_proc_hia,rateio_tx),1) as Decimal(15,2))) Valor, month(convert(datetime,hou.dt_emis_hia,105)) Mes,year(convert(datetime,hou.dt_emis_hia,105)) Ano,LEFT(JOB_HIA,2) Job,
	'N' Caixa ,dbo.fBusca_Tarefa(hou.num_proc_hia,40) Prestacao_Contas
From 
	House_Imp_Aer HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_CONSIG_hia
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hia
	Join Cta_Cte_MAS_imp_aer CTA with(nolock) on CTA.num_proc_Mia=hou.num_proc_Mia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_MAS_imp_Aer CXa with(nolock) on CTA.num_proc_Mia=cxa.num_proc_Mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_Mia=cxa.dc_Mia and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_Mia,105))=month(convert(Datetime,dt_emis_hia,105)) and year(convert(datetime,dt_pgto_rcto_Mia,105))=year(convert(datetime,dt_emis_hia,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_hia,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_hia,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	convert(datetime,dt_emis_hia,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_org_Mia='N'
	and cxa.num_lcto is null and left(hou.num_proc_hia,5) <> 'IAJOB'
	 and left(hou.num_proc_hia,2) like @modal
	 and nome_local like @localidade
	 and Apelido like @Cliente and hou.num_proc_hia like @num_proc


UNION


Select 
	HOU.NUM_PROC_HIA Processo,'IA' Modal, 'MAS' HM ,'CAIXA' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_mia,(cast(dbo.valor(vlr_pgto_rcto_Mia,cta.dc_Mia)*isnull(dbo.sppar_Masc(num_proc_hia,rateio_tx),1) as Decimal(15,2))) Valor, month(convert(datetime,hou.dt_emis_hia,105)) Mes,year(convert(datetime,hou.dt_emis_hia,105)) Ano,LEFT(JOB_HIA,2) Job,
	'S' Caixa ,dbo.fBusca_Tarefa(hou.num_proc_hia,40) Prestacao_Contas

From 
	House_Imp_Aer HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_CONSIG_hia
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hia
	Join Cta_Cte_MAS_imp_aer CTA with(nolock) on CTA.num_proc_mia=hou.num_proc_mia
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_MAS_imp_Aer CXa with(nolock) on CTA.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_mia=cxa.dc_mia and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_emis_hia,105))=month(convert(datetime,dt_pgto_Rcto_mia,105)) and Year(convert(datetime,dt_emis_hia,105))=Year(convert(datetime,dt_pgto_Rcto_mia,105))
Where
	convert(datetime,dt_emis_hia,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_org_mia='N' and left(hou.num_proc_hia,5) <> 'IAJOB'
	 and left(hou.num_proc_hia,2) like @modal
	 and nome_local like @localidade
	 and Apelido like @Cliente and hou.num_proc_hia like @num_proc

union

Select 
	HOU.NUM_PROC_HIM Processo,'IM' Modal, 'HOU' HM ,'CTA_REL' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_HIM,dbo.valor(vlr_org_HIM,cta.dc_HIM) Valor, month(convert(datetime,hou.dt_emis_HIM,105)) Mes,year(convert(datetime,hou.dt_emis_HIM,105)) Ano,LEFT(JOB_HIM,2) Job ,
	Isnull(cxa.dc_him,'N') CXA,dbo.fBusca_Tarefa(hou.num_proc_him,40) Prestacao_Contas

From 
	House_Imp_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_HIM
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_HIM
	Join Cta_Cte_hou_imp_MAR CTA with(nolock) on CTA.num_proc_HIM=hou.num_proc_HIM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_imp_mar cxa with(nolock) on cta.num_proc_him=cxa.num_proc_him and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him
Where
	 cta.cd_Tp_moeda='REL' and desp_org_HIM='N' and left(hou.num_proc_HIM,5) <> 'IMJOB'
	 and convert(datetime,dt_emis_HIM,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_him,2) like @modal
	 and nome_local like @localidade
	 and Apelido like @Cliente and hou.num_proc_him like @num_proc


union


Select 
	HOU.NUM_PROC_HIM Processo,'IM' Modal, 'HOU' HM ,'CTA_OUTROS' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, CTA.dc_HIM,dbo.valor(vlr_org_HIM*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_HIM) , month(convert(datetime,hou.dt_emis_HIM,105)) Mes,year(convert(datetime,hou.dt_emis_HIM,105)) Ano,LEFT(JOB_HIM,2) Job ,
	'N' Caixa ,dbo.fBusca_Tarefa(hou.num_proc_him,40) Prestacao_Contas

From 
	House_Imp_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_HIM
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_HIM
	Join Cta_Cte_hou_imp_MAR CTA with(nolock) on CTA.num_proc_HIM=hou.num_proc_HIM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_imp_MAR CXa with(nolock) on CTA.num_proc_HIM=cxa.num_proc_HIM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HIM=cxa.dc_HIM and num_lcto <> 'PROVISÓRIO' 
	Left Join Paridade PAR with(nolock)on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_HIM,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_HIM,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_HIM='N'
	and cxa.num_lcto is null and left(hou.num_proc_HIM,5) <> 'IMJOB'
	and convert(datetime,dt_emis_HIM,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_him,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_him like @num_proc



union


Select 
	HOU.NUM_PROC_HIM Processo,'IM' Modal, 'HOU' HM ,'CAIXA' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_HIM,dbo.valor(Vlr_Pgto_Rcto_HIM,cta.dc_HIM) Valor, month(convert(datetime,hou.dt_emis_HIM,105)) Mes,year(convert(datetime,hou.dt_emis_HIM,105)) Ano,LEFT(JOB_HIM,2) Job,
	'S' Caixa,dbo.fBusca_Tarefa(hou.num_proc_him,40) Prestacao_Contas
  
From 
	House_Imp_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_HIM
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_HIM
	Join Cta_Cte_hou_imp_MAR CTA with(nolock)on CTA.num_proc_HIM=hou.num_proc_HIM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_imp_MAR CXa with(nolock) on CTA.num_proc_HIM=cxa.num_proc_HIM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HIM=cxa.dc_HIM and num_lcto <> 'PROVISÓRIO' 
Where
	convert(datetime,dt_emis_HIM,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_org_HIM='N' and left(hou.num_proc_HIM,5) <> 'IMJOB'
	 and left(hou.num_proc_him,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_him like @num_proc


	
Union

--(cast(dbo.valor(vlr_org_mim,dc_mim)*isnull(dbo.sppar_Masc(num_proc_HIM,rateio_tx),1) as Decimal(15,2))) Valor
Select 
	HOU.NUM_PROC_HIM Processo,'IM' Modal, 'HOU' HM ,'REL' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_mim,(cast(dbo.valor(vlr_org_mim,cta.dc_mim)*isnull(dbo.sppar_Masc(num_proc_HIM,rateio_tx),1) as Decimal(15,2))) Valor, month(convert(datetime,hou.dt_emis_HIM,105)) Mes,year(convert(datetime,hou.dt_emis_HIM,105)) Ano,LEFT(JOB_HIM,2) Job,
	Isnull(cxa.num_proc_mim,'N') Caixa,dbo.fBusca_Tarefa(hou.num_proc_him,40) Prestacao_Contas

From 
	House_Imp_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_CONSIG_HIM
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_HIM
	Join Cta_Cte_MAS_imp_MAR CTA with(nolock) on CTA.num_proc_mim=hou.num_proc_mim
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_mas_imp_mar cXA with(nolock) on cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim
Where
	convert(datetime,dt_emis_him,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda='REL' and desp_org_mim='N' and left(hou.num_proc_HIM,5)<>'IMJOB'
	 and left(hou.num_proc_him,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_him like @num_proc



Union

Select 
	HOU.NUM_PROC_HIM Processo,'IM' Modal, 'MAS' HM ,'OUTRAS_MOEDAS' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_mim,(cast(dbo.valor(vlr_org_mim,cta.dc_mim)*isnull(dbo.sppar_Masc(num_proc_HIM,rateio_tx),1) as Decimal(15,2))) Valor, month(convert(datetime,hou.dt_emis_HIM,105)) Mes,year(convert(datetime,hou.dt_emis_HIM,105)) Ano,LEFT(JOB_HIM,2) Job ,
	'N' Caixa,dbo.fBusca_Tarefa(hou.num_proc_him,40) Prestacao_Contas
 
From 
	House_Imp_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_CONSIG_HIM
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_HIM
	Join Cta_Cte_MAS_imp_MAR CTA with(nolock)on CTA.num_proc_mim=hou.num_proc_mim
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_MAS_imp_MAR CXa with(nolock) on CTA.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_mim,105))=month(convert(Datetime,dt_emis_him,105)) and year(convert(datetime,dt_pgto_rcto_mim,105))=year(convert(datetime,dt_emis_him,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_him,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_him,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'

Where
	convert(datetime,dt_emis_him,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_org_mim='N'
	and cxa.num_lcto is null and left(hou.num_proc_HIM,5) <> 'IMJOB'
	 and left(hou.num_proc_him,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_him like @num_proc

UNION

Select 
	HOU.NUM_PROC_HIM Processo,'IM' Modal, 'MAS' HM ,'CAIXA' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_mim,(cast(dbo.valor(vlr_pgto_rcto_mim,cta.dc_mim)*isnull(dbo.sppar_Masc(num_proc_HIM,rateio_tx),1) as Decimal(15,2))) Valor, month(convert(datetime,hou.dt_emis_HIM,105)) Mes,year(convert(datetime,hou.dt_emis_HIM,105)) Ano,LEFT(JOB_HIM,2) Job,
	'N' Caixa ,dbo.fBusca_Tarefa(hou.num_proc_him,40) Prestacao_Contas

From 
	House_Imp_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_CONSIG_HIM
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_HIM
	Join Cta_Cte_MAS_imp_MAR CTA with(nolock) on CTA.num_proc_mim=hou.num_proc_mim
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_MAS_imp_MAR CXa with(nolock) on CTA.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_emis_him,105))=month(convert(datetime,dt_pgto_Rcto_mim,105)) and Year(convert(datetime,dt_emis_him,105))=Year(convert(datetime,dt_pgto_Rcto_mim,105))
Where
	convert(datetime,dt_emis_him,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_org_mim='N' and left(hou.num_proc_HIM,5) <> 'IMJOB'
	 and left(hou.num_proc_him,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_him like @num_proc

union

Select 
	HOU.NUM_PROC_HEA Processo,'EA' Modal, 'HOU' HM ,'CTA_REL' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_HEA,dbo.valor(vlr_org_HEA,cta.dc_HEA) Valor, month(convert(datetime,hou.dt_emis_HEA,105)) Mes,year(convert(datetime,hou.dt_emis_HEA,105)) Ano,LEFT(JOB_HEA,2) Job,
	Isnull(cxa.num_proc_hea,'N') Caixa,dbo.fBusca_Tarefa(hou.num_proc_hea,40) Prestacao_Contas
  
From 
	House_EXP_Aer HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_hea
	Join Localidade DST with(nolock) on DST.cd_local=CD_ORG_HEA
	Join Cta_Cte_hou_EXP_aer CTA with(nolock) on CTA.num_proc_HEA=hou.num_proc_HEA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	LEft Join Caixa_hou_exp_aer CXA with(nolock) on CTA.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea
Where
	 cta.cd_Tp_moeda='REL' and desp_dst_HEA='N' and left(hou.num_proc_HEA,5) <> 'EAJOB'
	 and convert(datetime,dt_emis_HEA,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_hea,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hea like @num_proc

union

Select 
	HOU.NUM_PROC_HEA Processo,'EA' Modal, 'HOU' HM ,'CTA_OUTROS' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, CTA.dc_HEA,dbo.valor(vlr_org_HEA*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_HEA) , month(convert(datetime,hou.dt_emis_HEA,105)) Mes,year(convert(datetime,hou.dt_emis_HEA,105)) Ano,LEFT(JOB_HEA,2) Job,
	'N' Caixa,dbo.fBusca_Tarefa(hou.num_proc_hea,40) Prestacao_Contas
  
From 
	House_EXP_Aer HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_hea
	Join Localidade DST with(nolock) on DST.cd_local=CD_ORG_HEA
	Join Cta_Cte_hou_EXP_aer CTA with(nolock) on CTA.num_proc_HEA=hou.num_proc_HEA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_EXP_Aer CXa with(nolock) on CTA.num_proc_HEA=cxa.num_proc_HEA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HEA=cxa.dc_HEA and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_HEA,105))=month(convert(Datetime,dt_emis_HEA,105)) and year(convert(datetime,dt_pgto_rcto_HEA,105))=year(convert(datetime,dt_emis_HEA,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_HEA,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_HEA,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_dst_HEA='N'
	and cxa.num_lcto is null and left(hou.num_proc_HEA,5) <> 'EAJOB'
	and convert(datetime,dt_emis_HEA,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_hea,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hea like @num_proc

union


Select 
	HOU.NUM_PROC_HEA Processo,'EA' Modal, 'HOU' HM ,'CAIXA' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_HEA,dbo.valor(Vlr_Pgto_Rcto_HEA,cta.dc_HEA) Valor, month(convert(datetime,hou.dt_emis_HEA,105)) Mes,year(convert(datetime,hou.dt_emis_HEA,105)) Ano,LEFT(JOB_HEA,2) Job ,
	'S' Caixa,dbo.fBusca_Tarefa(hou.num_proc_hea,40) Prestacao_Contas
 
From 
	House_EXP_Aer HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_hea
	Join Localidade DST with(nolock) on DST.cd_local=CD_ORG_HEA
	Join Cta_Cte_hou_EXP_aer CTA with(nolock) on CTA.num_proc_HEA=hou.num_proc_HEA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_EXP_Aer CXa with(nolock) on CTA.num_proc_HEA=cxa.num_proc_HEA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HEA=cxa.dc_HEA and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_pgto_Rcto_HEA,105))=month(convert(datetime,dt_emis_HEA,105)) and year(convert(Datetime,dt_pgto_rcto_HEA,105))=year(convert(datetime,dt_emis_HEA,105))
Where
	convert(datetime,dt_emis_HEA,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_dst_HEA='N' and left(hou.num_proc_HEA,5) <> 'EAJOB'
	 and left(hou.num_proc_hea,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hea like @num_proc



Union

--(cast(dbo.valor(vlr_org_MEA,dc_MEA)*isnull(dbo.sppar_Masc(num_proc_HEA,rateio_tx),1) as Decimal(15,2))) Valor
Select 
	HOU.NUM_PROC_HEA Processo,'EA' Modal, 'HOU' HM ,'REL' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_MEA,(cast(dbo.valor(vlr_org_MEA,cta.dc_MEA)*isnull(dbo.sppar_Masc(num_proc_HEA,rateio_tx),1) as Decimal(15,2))) Valor, month(convert(datetime,hou.dt_emis_HEA,105)) Mes,year(convert(datetime,hou.dt_emis_HEA,105)) Ano,LEFT(JOB_HEA,2) Job,
	Isnull(cxa.num_proc_mea,'N') Caixa ,dbo.fBusca_Tarefa(hou.num_proc_hea,40) Prestacao_Contas
 
From  
	House_EXP_Aer HOU with(nolock) 
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_hea
	Join Localidade DST with(nolock) on DST.cd_local=CD_ORG_HEA
	Join Cta_Cte_MAS_EXP_aer CTA with(nolock) on CTA.num_proc_MEA=hou.num_proc_MEA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	LEft Join Caixa_mas_Exp_aer CXA with(nolock) on cta.num_proc_mea=CXA.num_proc_mea and cta.dc_mea=cxa.dc_mea and cta.cd_tp_tx=cxa.cd_tp_Tx
Where
	convert(datetime,dt_emis_HEA,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda='REL' and desp_dst_MEA='N' and left(hou.num_proc_HEA,5)<>'EAJOB'
	 and left(hou.num_proc_hea,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hea like @num_proc

Union

Select 
	HOU.NUM_PROC_HEA Processo,'EA' Modal, 'MAS' HM ,'OUTRAS_MOEDAS' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_MEA,(cast(dbo.valor(vlr_org_MEA,cta.dc_MEA)*isnull(dbo.sppar_Masc(num_proc_HEA,rateio_tx),1) as Decimal(15,2))) Valor, month(convert(datetime,hou.dt_emis_HEA,105)) Mes,year(convert(datetime,hou.dt_emis_HEA,105)) Ano,LEFT(JOB_HEA,2) Job ,
	'N' Caixa,dbo.fBusca_Tarefa(hou.num_proc_hea,40) Prestacao_Contas

From 
	House_EXP_Aer HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_hea
	Join Localidade DST with(nolock) on DST.cd_local=CD_ORG_HEA
	Join Cta_Cte_MAS_EXP_aer CTA with(nolock) on CTA.num_proc_MEA=hou.num_proc_MEA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_MAS_EXP_Aer CXa with(nolock) on CTA.num_proc_MEA=cxa.num_proc_MEA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_MEA=cxa.dc_MEA and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_MEA,105))=month(convert(Datetime,dt_emis_HEA,105)) and year(convert(datetime,dt_pgto_rcto_MEA,105))=year(convert(datetime,dt_emis_HEA,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_HEA,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_HEA,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	convert(datetime,dt_emis_HEA,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_dst_MEA='N'
	and cxa.num_lcto is null and left(hou.num_proc_HEA,5) <> 'EAJOB'
	 and left(hou.num_proc_hea,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hea like @num_proc

UNION


Select 
	HOU.NUM_PROC_HEA Processo,'EA' Modal, 'MAS' HM ,'CAIXA' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_MEA,(cast(dbo.valor(vlr_pgto_rcto_mea,cta.dc_MEA)*isnull(dbo.sppar_Masc(num_proc_HEA,rateio_tx),1) as Decimal(15,2))) Valor, month(convert(datetime,hou.dt_emis_HEA,105)) Mes,year(convert(datetime,hou.dt_emis_HEA,105)) Ano,LEFT(JOB_HEA,2) Job ,
	'S' Caixa, dbo.fBusca_Tarefa(hou.num_proc_hea,40) Prestacao_Contas
 
From 
	House_EXP_Aer HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_hea
	Join Localidade DST with(nolock) on DST.cd_local=CD_ORG_HEA
	Join Cta_Cte_MAS_EXP_aer CTA with(nolock) on CTA.num_proc_MEA=hou.num_proc_MEA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_MAS_EXP_Aer CXa with(nolock) on CTA.num_proc_MEA=cxa.num_proc_MEA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_MEA=cxa.dc_MEA and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_emis_HEA,105))=month(convert(datetime,dt_pgto_Rcto_MEA,105)) and Year(convert(datetime,dt_emis_HEA,105))=Year(convert(datetime,dt_pgto_Rcto_MEA,105))
Where
	convert(datetime,dt_emis_HEA,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_dst_MEA='N' and left(hou.num_proc_HEA,5) <> 'EAJOB'
	 and left(hou.num_proc_hea,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hea like @num_proc


union


Select 
	HOU.NUM_PROC_HEM Processo,'EM' Modal, 'HOU' HM ,'CTA_REL' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_HEM,dbo.valor(vlr_org_HEM,cta.dc_HEM) Valor, month(convert(datetime,hou.dt_emis_HEM,105)) Mes,year(convert(datetime,hou.dt_emis_HEM,105)) Ano,LEFT(JOB_HEM,2) Job,
	Isnull(cxa.num_proc_hem,'N') Caixa,dbo.fBusca_Tarefa(hou.num_proc_hem,40) Prestacao_Contas
  
From 
	House_EXP_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_hem
	Join Localidade DST with(nolock) on DST.cd_local=CD_ORG_HEM
	Join Cta_Cte_hou_EXP_MAR CTA with(nolock) on CTA.num_proc_HEM=hou.num_proc_HEM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_exp_mar CXA with(nolock) on CTA.num_proc_hem=CXa.num_proc_hem and cta.cd_Tp_tx=cxa.cd_Tp_Tx and cta.dc_hem=cxa.dc_hem
Where
	 cta.cd_Tp_moeda='REL' and desp_dst_HEM='N' and left(hou.num_proc_HEM,5) <> 'EMJOB'
	 and convert(datetime,dt_emis_HEM,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_hem,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hem like @num_proc


union


Select 
	HOU.NUM_PROC_HEM Processo,'EM' Modal, 'HOU' HM ,'CTA_OUTROS' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, CTA.dc_HEM,dbo.valor(vlr_org_HEM*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_HEM) , month(convert(datetime,hou.dt_emis_HEM,105)) Mes,year(convert(datetime,hou.dt_emis_HEM,105)) Ano,LEFT(JOB_HEM,2) Job ,
	'N' Caixa, dbo.fBusca_Tarefa(hou.num_proc_hem,40) Prestacao_Contas
 
From 
	House_EXP_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_hem
	Join Localidade DST with(nolock) on DST.cd_local=CD_ORG_HEM
	Join Cta_Cte_hou_EXP_MAR CTA with(nolock) on CTA.num_proc_HEM=hou.num_proc_HEM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_EXP_MAR CXa with(nolock)on CTA.num_proc_HEM=cxa.num_proc_HEM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HEM=cxa.dc_HEM and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_HEM,105))=month(convert(Datetime,dt_emis_HEM,105)) and year(convert(datetime,dt_pgto_rcto_HEM,105))=year(convert(datetime,dt_emis_HEM,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_HEM,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_HEM,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_dst_HEM='N'
	and cxa.num_lcto is null and left(hou.num_proc_HEM,5) <> 'EMJOB'
	and convert(datetime,dt_emis_HEM,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_hem,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hem like @num_proc

union


Select 
	HOU.NUM_PROC_HEM Processo,'EM' Modal, 'HOU' HM ,'CAIXA' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_HEM,dbo.valor(Vlr_Pgto_Rcto_HEM,cta.dc_HEM) Valor, month(convert(datetime,hou.dt_emis_HEM,105)) Mes,year(convert(datetime,hou.dt_emis_HEM,105)) Ano,LEFT(JOB_HEM,2) Job ,
	'S' Caixa, dbo.fBusca_Tarefa(hou.num_proc_hem,40) Prestacao_Contas
 
From 
	House_EXP_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_hem
	Join Localidade DST with(nolock) on DST.cd_local=CD_ORG_HEM
	Join Cta_Cte_hou_EXP_MAR CTA with(nolock) on CTA.num_proc_HEM=hou.num_proc_HEM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_EXP_MAR CXa with(nolock) on CTA.num_proc_HEM=cxa.num_proc_HEM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HEM=cxa.dc_HEM and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_pgto_Rcto_HEM,105))=month(convert(datetime,dt_emis_HEM,105)) and year(convert(Datetime,dt_pgto_rcto_HEM,105))=year(convert(datetime,dt_emis_HEM,105))
Where
	convert(datetime,dt_emis_HEM,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_dst_HEM='N' and left(hou.num_proc_HEM,5) <> 'EMJOB'
	 and left(hou.num_proc_hem,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hem like @num_proc

Union

--(cast(dbo.valor(vlr_org_MEM,dc_MEM)*isnull(dbo.sppar_Masc(num_proc_HEM,rateio_tx),1) as Decimal(15,2))) Valor
Select 
	HOU.NUM_PROC_HEM Processo,'EM' Modal, 'HOU' HM ,'REL' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_MEM,(cast(dbo.valor(vlr_org_MEM,cta.dc_MEM)*isnull(dbo.sppar_Masc(num_proc_HEM,rateio_tx),1) as Decimal(15,2))) Valor, month(convert(datetime,hou.dt_emis_HEM,105)) Mes,year(convert(datetime,hou.dt_emis_HEM,105)) Ano,LEFT(JOB_HEM,2) Job,
	Isnull(cxa.num_proc_mem, 'N') Caixa, dbo.fBusca_Tarefa(hou.num_proc_hem,40) Prestacao_Contas
From 
	House_EXP_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_hem
	Join Localidade DST with(nolock) on DST.cd_local=CD_ORG_HEM
	Join Cta_Cte_MAS_EXP_MAR CTA with(nolock) on CTA.num_proc_MEM=hou.num_proc_MEM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	LEft Join Caixa_mas_exp_mar CXA with(nolock) on CTA.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem
Where
	convert(datetime,dt_emis_HEM,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda='REL' and desp_dst_MEM='N' and left(hou.num_proc_HEM,5)<>'EMJOB'
	 and left(hou.num_proc_hem,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hem like @num_proc

Union

Select 
	HOU.NUM_PROC_HEM Processo,'EM' Modal, 'MAS' HM ,'OUTRAS_MOEDAS' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_MEM,(cast(dbo.valor(vlr_org_MEM,cta.dc_MEM)*isnull(dbo.sppar_Masc(num_proc_HEM,rateio_tx),1) as Decimal(15,2))) Valor, month(convert(datetime,hou.dt_emis_HEM,105)) Mes,year(convert(datetime,hou.dt_emis_HEM,105)) Ano,LEFT(JOB_HEM,2) Job,
	'N' Caixa,dbo.fBusca_Tarefa(hou.num_proc_hem,40) Prestacao_Contas
  
From 
	House_EXP_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_hem
	Join Localidade DST with(nolock) on DST.cd_local=CD_ORG_HEM
	Join Cta_Cte_MAS_EXP_MAR CTA with(nolock) on CTA.num_proc_MEM=hou.num_proc_MEM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_MAS_EXP_MAR CXa with(nolock) on CTA.num_proc_MEM=cxa.num_proc_MEM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_MEM=cxa.dc_MEM and num_lcto <> 'PROVISÓRIO'-- AND month(convert(Datetime,dt_pgto_rcto_MEM,105))=month(convert(Datetime,dt_emis_HEM,105)) and year(convert(datetime,dt_pgto_rcto_MEM,105))=year(convert(datetime,dt_emis_HEM,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_HEM,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_HEM,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	convert(datetime,dt_emis_HEM,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_dst_MEM='N'
	and cxa.num_lcto is null and left(hou.num_proc_HEM,5) <> 'EMJOB'
	 and left(hou.num_proc_hem,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hem like @num_proc

UNION


Select 
	HOU.NUM_PROC_HEM Processo,'EM' Modal, 'MAS' HM ,'CAIXA' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_MEM,(cast(dbo.valor(vlr_pgto_rcto_MEM,cta.dc_MEM)*isnull(dbo.sppar_Masc(num_proc_HEM,rateio_tx),1) as Decimal(15,2))) Valor, month(convert(datetime,hou.dt_emis_HEM,105)) Mes,year(convert(datetime,hou.dt_emis_HEM,105)) Ano,LEFT(JOB_HEM,2) Job ,
	'S' Caixa, dbo.fBusca_Tarefa(hou.num_proc_hem,40) Prestacao_Contas
 
From 
	House_EXP_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_hem
	Join Localidade DST with(nolock) on DST.cd_local=CD_ORG_HEM
	Join Cta_Cte_MAS_EXP_MAR CTA with(nolock) on CTA.num_proc_MEM=hou.num_proc_MEM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_MAS_EXP_MAR CXa with(nolock) on CTA.num_proc_MEM=cxa.num_proc_MEM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_MEM=cxa.dc_MEM and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_emis_HEM,105))=month(convert(datetime,dt_pgto_Rcto_MEM,105)) and Year(convert(datetime,dt_emis_HEM,105))=Year(convert(datetime,dt_pgto_Rcto_MEM,105))
Where
	convert(datetime,dt_emis_HEM,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_dst_MEM='N' and left(hou.num_proc_HEM,5) <> 'EMJOB'
	 and left(hou.num_proc_hem,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hem like @num_proc


UNION


Select 
	HOU.NUM_PROC_HIO Processo,'IO' Modal, 'HOU' HM ,'CTA_REL' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_HIO,dbo.valor(vlr_org_HIO,cta.dc_HIO) Valor, month(convert(datetime,hou.dt_emis_HIO,105)) Mes,year(convert(datetime,hou.dt_emis_HIO,105)) Ano,'' joB,
	isnull(cxa.num_proc_hio,'N') Caixa,dbo.fBusca_Tarefa(hou.num_proc_hio,40) Prestacao_Contas

From 
	House_Imp_OUT HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_HIO
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_HIO
	Join Cta_Cte_hou_imp_OUT CTA with(nolock) on CTA.num_proc_HIO=hou.num_proc_HIO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_imp_out cxa with(nolock) on cta.num_proc_hio=cxa.num_proc_hio and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hio=cxa.dc_hio
Where
	 cta.cd_Tp_moeda='REL' and desp_org_HIO='N' and left(hou.num_proc_HIO,5) <> 'IOJOB'
	 and convert(datetime,dt_emis_HIO,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_hio,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hio like @num_proc


union


Select 
	HOU.NUM_PROC_HIO Processo,'IO' Modal, 'HOU' HM ,'CTA_OUTROS' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, CTA.dc_HIO,dbo.valor(vlr_org_HIO*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_HIO) , month(convert(datetime,hou.dt_emis_HIO,105)) Mes,year(convert(datetime,hou.dt_emis_HIO,105)) Ano,'' Job,
	'N' Caixa,dbo.fBusca_Tarefa(hou.num_proc_hio,40)   
From 
	House_Imp_OUT HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_HIO
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_HIO
	Join Cta_Cte_hou_imp_OUT CTA with(nolock) on CTA.num_proc_HIO=hou.num_proc_HIO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_imp_OUT CXa with(nolock) on CTA.num_proc_HIO=cxa.num_proc_HIO and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HIO=cxa.dc_HIO and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_HIO,105))=month(convert(Datetime,dt_emis_HIO,105)) and year(convert(datetime,dt_pgto_rcto_HIO,105))=year(convert(datetime,dt_emis_HIO,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_HIO,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_HIO,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_HIO='N'
	and cxa.num_lcto is null and left(hou.num_proc_HIO,5) <> 'IOJOB'
	and convert(datetime,dt_emis_HIO,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_hio,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hio like @num_proc

union


Select 
	HOU.NUM_PROC_HIO Processo,'IO' Modal, 'HOU' HM ,'CAIXA' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_HIO,dbo.valor(Vlr_Pgto_Rcto_HIO,cta.dc_HIO) Valor, month(convert(datetime,hou.dt_emis_HIO,105)) Mes,year(convert(datetime,hou.dt_emis_HIO,105)) Ano,'' Job,
	'S' Caixa,dbo.fBusca_Tarefa(hou.num_proc_hio,40)   
From 
	House_Imp_OUT HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_HIO
	Join Localidade DST with(nolock) on DST.cd_local=cd_DST_HIO
	Join Cta_Cte_hou_imp_OUT CTA with(nolock) on CTA.num_proc_HIO=hou.num_proc_HIO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_imp_OUT CXa with(nolock) on CTA.num_proc_HIO=cxa.num_proc_HIO and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HIO=cxa.dc_HIO and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_pgto_Rcto_HIO,105))=month(convert(datetime,dt_emis_HIO,105)) and year(convert(Datetime,dt_pgto_rcto_HIO,105))=year(convert(datetime,dt_emis_HIO,105))
Where
	convert(datetime,dt_emis_HIO,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_org_HIO='N' and left(hou.num_proc_HIO,5) <> 'IOJOB'
	 and left(hou.num_proc_hio,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hio like @num_proc



union


Select 
	HOU.NUM_PROC_HEO Processo,'EO' Modal, 'HOU' HM ,'CTA_REL' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_HEO,dbo.valor(vlr_org_HEO,cta.dc_HEO) Valor, month(convert(datetime,hou.dt_emis_HEO,105)) Mes,year(convert(datetime,hou.dt_emis_HEO,105)) Ano,'' Job,
	Isnull(cxa.num_proc_heo,'N') Caixa,dbo.fBusca_Tarefa(hou.num_proc_heo,40)   
From 
	House_EXP_OUT HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_heo
	Join Localidade DST with(nolock) on DST.cd_local=cd_ORG_HEO
	Join Cta_Cte_hou_EXP_OUT CTA with(nolock) on CTA.num_proc_HEO=hou.num_proc_HEO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_exp_out CXA with(nolock) on CTA.num_proc_heo=cxa.num_proc_heo and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_heo=cxa.dc_heo
Where
	 cta.cd_Tp_moeda='REL' and desp_org_HEO='N' and left(hou.num_proc_HEO,5) <> 'EOJOB'
	 and convert(datetime,dt_emis_HEO,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_heo,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_heo like @num_proc



union


Select 
	HOU.NUM_PROC_HEO Processo,'EO' Modal, 'HOU' HM ,'CTA_OUTROS' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, CTA.dc_HEO,dbo.valor(vlr_org_HEO*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_HEO) , month(convert(datetime,hou.dt_emis_HEO,105)) Mes,year(convert(datetime,hou.dt_emis_HEO,105)) Ano,'' Job ,
	'N' Caixa,dbo.fBusca_Tarefa(hou.num_proc_heo,40)  
From 
	House_EXP_OUT HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_heo
	Join Localidade DST with(nolock) on DST.cd_local=cd_org_HEO
	Join Cta_Cte_hou_EXP_OUT CTA with(nolock) on CTA.num_proc_HEO=hou.num_proc_HEO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_EXP_OUT CXa with(nolock) on CTA.num_proc_HEO=cxa.num_proc_HEO and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HEO=cxa.dc_HEO and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_HEO,105))=month(convert(Datetime,dt_emis_HEO,105)) and year(convert(datetime,dt_pgto_rcto_HEO,105))=year(convert(datetime,dt_emis_HEO,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_HEO,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_HEO,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_HEO='N'
	and cxa.num_lcto is null and left(hou.num_proc_HEO,5) <> 'EOJOB'
	and convert(datetime,dt_emis_HEO,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_heo,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_heo like @num_proc



union


Select 
	HOU.NUM_PROC_HEO Processo,'EO' Modal, 'HOU' HM ,'CAIXA' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_HEO,dbo.valor(Vlr_Pgto_Rcto_HEO,cta.dc_HEO) Valor, month(convert(datetime,hou.dt_emis_HEO,105)) Mes,year(convert(datetime,hou.dt_emis_HEO,105)) Ano,'' Job,
	'S' Caixa,dbo.fBusca_Tarefa(hou.num_proc_heo,40)   
From 
	House_EXP_OUT HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_export_heo
	Join Localidade DST with(nolock) on DST.cd_local=cd_org_HEO
	Join Cta_Cte_hou_EXP_OUT CTA with(nolock) on CTA.num_proc_HEO=hou.num_proc_HEO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_EXP_OUT CXa with(nolock) on CTA.num_proc_HEO=cxa.num_proc_HEO and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HEO=cxa.dc_HEO and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_pgto_Rcto_HEO,105))=month(convert(datetime,dt_emis_HEO,105)) and year(convert(Datetime,dt_pgto_rcto_HEO,105))=year(convert(datetime,dt_emis_HEO,105))
Where
	convert(datetime,dt_emis_HEO,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_org_HEO='N' and left(hou.num_proc_HEO,5) <> 'EOJOB'
	 and left(hou.num_proc_heo,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_heo like @num_proc


UNION 


Select 
	HOU.num_proc_MIM Processo,'IM' Modal, 'HOU' HM ,'CTA_REL' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_mim,dbo.valor(vlr_org_MIM,cta.dc_mim) Valor, month(convert(datetime,hou.dt_emis_MIM,105)) Mes,year(convert(datetime,hou.dt_emis_MIM,105)) Ano,LEFT(HOU.Num_Proc_mim,2) Job ,
	Isnull(cxa.dc_mim,'N') CXA,dbo.fBusca_Tarefa(hou.num_proc_MIM,40) Prestacao_Contas

From 
	Master_Imp_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_MIM
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_MIM
	Join Cta_Cte_MAS_imp_MAR CTA with(nolock) on CTA.num_proc_MIM=hou.num_proc_MIM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_mas_imp_mar cxa with(nolock) on cta.num_proc_MIM=cxa.num_proc_MIM and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim
Where
	 cta.cd_Tp_moeda='REL' and desp_org_MIM='N' and left(hou.num_proc_MIM,5) <> 'IMJOB'
	 and convert(datetime,dt_emis_MIM,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_MIM,2) like @modal
	 and nome_local like @localidade
	 and Apelido like @Cliente and hou.num_proc_MIM like @num_proc


union


Select 
	HOU.num_proc_MIM Processo,'IM' Modal, 'HOU' HM ,'CTA_OUTROS' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, CTA.dc_mim,dbo.valor(vlr_org_MIM*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_mim) , month(convert(datetime,hou.dt_emis_MIM,105)) Mes,year(convert(datetime,hou.dt_emis_MIM,105)) Ano,LEFT(HOU.Num_Proc_mim,2) Job ,
	'N' Caixa ,dbo.fBusca_Tarefa(hou.num_proc_MIM,40) Prestacao_Contas

From 
	Master_Imp_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_MIM
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_MIM
	Join Cta_Cte_MAS_imp_MAR CTA with(nolock) on CTA.num_proc_MIM=hou.num_proc_MIM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_mas_imp_mar CXa with(nolock) on CTA.num_proc_MIM=cxa.num_proc_MIM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' 
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_MIM,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_MIM,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_MIM='N'
	and cxa.num_lcto is null and left(hou.num_proc_MIM,5) <> 'IMJOB'
	and convert(datetime,dt_emis_MIM,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_MIM,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_MIM like @num_proc

union

Select 
	HOU.num_proc_MIM Processo,'IM' Modal, 'HOU' HM ,'CAIXA' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_mim,dbo.valor(Vlr_Pgto_Rcto_MIM,cta.dc_mim) Valor, month(convert(datetime,hou.dt_emis_MIM,105)) Mes,year(convert(datetime,hou.dt_emis_MIM,105)) Ano,LEFT(HOU.Num_Proc_mim,2) Job,
	'S' Caixa,dbo.fBusca_Tarefa(hou.num_proc_MIM,40) Prestacao_Contas
  
From 
	Master_Imp_MAR HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_MIM
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_MIM
	Join Cta_Cte_MAS_imp_MAR CTA with(nolock) on CTA.num_proc_MIM=hou.num_proc_MIM
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_mas_imp_mar CXa with(nolock) on CTA.num_proc_MIM=cxa.num_proc_MIM and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' 
Where
	convert(datetime,dt_emis_MIM,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_org_MIM='N' and left(hou.num_proc_MIM,5) <> 'IMJOB'
	 and left(hou.num_proc_MIM,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_MIM like @num_proc

UNION 

Select 
	HOU.num_proc_MIA Processo,'IM' Modal, 'HOU' HM ,'CTA_REL' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_MIA,dbo.valor(vlr_org_MIA,cta.dc_MIA) Valor, month(convert(datetime,hou.dt_emis_MIA,105)) Mes,year(convert(datetime,hou.dt_emis_MIA,105)) Ano,LEFT(HOU.Num_Proc_MIA,2) Job ,
	Isnull(cxa.dc_MIA,'N') CXA,dbo.fBusca_Tarefa(hou.num_proc_MIA,40) Prestacao_Contas

From 
	Master_Imp_AER HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_MIA
	Join Localidade DST with(nolock)on DST.cd_local=cd_dst_MIA
	Join Cta_Cte_MAS_imp_AER CTA with(nolock) on CTA.num_proc_MIA=hou.num_proc_MIA
	Join Tipo_Taxa TT with(nolock)on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_mas_imp_AER cxa with(nolock)on cta.num_proc_MIA=cxa.num_proc_MIA and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_MIA=cxa.dc_MIA
Where
	 cta.cd_Tp_moeda='REL' and desp_org_MIA='N' and left(hou.num_proc_MIA,5) <> 'IMJOB'
	 and convert(datetime,dt_emis_MIA,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_MIA,2) like @modal
	 and nome_local like @localidade
	 and Apelido like @Cliente and hou.num_proc_MIA like @num_proc


union


Select 
	HOU.num_proc_MIA Processo,'IM' Modal, 'HOU' HM ,'CTA_OUTROS' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, CTA.dc_MIA,dbo.valor(vlr_org_MIA*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_MIA) , month(convert(datetime,hou.dt_emis_MIA,105)) Mes,year(convert(datetime,hou.dt_emis_MIA,105)) Ano,LEFT(HOU.Num_Proc_MIA,2) Job ,
	'N' Caixa ,dbo.fBusca_Tarefa(hou.num_proc_MIA,40) Prestacao_Contas

From 
	Master_Imp_AER HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_MIA
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_MIA
	Join Cta_Cte_MAS_imp_AER CTA with(nolock) on CTA.num_proc_MIA=hou.num_proc_MIA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_mas_imp_AER CXa with(nolock) on CTA.num_proc_MIA=cxa.num_proc_MIA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_MIA=cxa.dc_MIA and num_lcto <> 'PROVISÓRIO' 
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_emis_MIA,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_emis_MIA,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and desp_org_MIA='N'
	and cxa.num_lcto is null and left(hou.num_proc_MIA,5) <> 'IMJOB'
	and convert(datetime,dt_emis_MIA,105) between @DataInicial and @DataFinal
	 and left(hou.num_proc_MIA,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_MIA like @num_proc



union


Select 
	HOU.num_proc_MIA Processo,'IM' Modal, 'HOU' HM ,'CAIXA' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_MIA,dbo.valor(Vlr_Pgto_Rcto_MIA,cta.dc_MIA) Valor, month(convert(datetime,hou.dt_emis_MIA,105)) Mes,year(convert(datetime,hou.dt_emis_MIA,105)) Ano,LEFT(HOU.Num_Proc_MIA,2) Job,
	'S' Caixa,dbo.fBusca_Tarefa(hou.num_proc_MIA,40) Prestacao_Contas
  
From 
	Master_Imp_AER HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_consig_MIA
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_MIA
	Join Cta_Cte_MAS_imp_AER CTA with(nolock)on CTA.num_proc_MIA=hou.num_proc_MIA
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_mas_imp_AER CXa with(nolock) on CTA.num_proc_MIA=cxa.num_proc_MIA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_MIA=cxa.dc_MIA and num_lcto <> 'PROVISÓRIO' 
Where
	convert(datetime,dt_emis_MIA,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and desp_org_MIA='N' and left(hou.num_proc_MIA,5) <> 'IMJOB'
	 and left(hou.num_proc_MIA,2) like @modal
	 and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_MIA like @num_proc


	
-----------------BO

UNION


Select 
	HOU.NUM_PROC_HBO Processo,'BO' Modal, 'HOU' HM ,'CTA_REL' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	NULL Nome_Local, cta.DC_HBO,dbo.valor(Vlr_Org_HBO,cta.DC_HBO) Valor, month(convert(datetime,hou.dt_emis_HbO,105)) Mes,
	year(convert(datetime,hou.dt_emis_HbO,105)) Ano,'' joB,
	isnull(cxa.Num_Proc_HIA,'N') Caixa,dbo.fBusca_Tarefa(hou.num_proc_hbo,40) Prestacao_Contas

From 
	House_BDP_OUT HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_cliente_hbo
	--Join Localidade DST with(nolock) on DST.cd_local=cd_dst_HIO
	Join Cta_Cte_HOU_BDP_OUT CTA with(nolock) on CTA.Num_Proc_HBO=hou.Num_Proc_HBO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join vwCXAS cxa with(nolock) on cta.num_proc_hbo=cxa.Num_Proc_HIA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.DC_HBO=cxa.DC_HIA
Where
	 cta.cd_Tp_moeda='REL' and Desp_Org_HBO='N' and left(hou.Num_Proc_HBO,5) <> 'BOJOB'
	 and convert(datetime,Dt_Emis_HBO,105) between @DataInicial and @DataFinal
	 and left(hou.Num_Proc_HBO,2) like @modal
	 --and nome_local like @localidade
	and Apelido like @Cliente and hou.num_proc_hbo like @num_proc


union


Select 
	HOU.Num_Proc_HBO Processo,'BO' Modal, 'HOU' HM ,'CTA_OUTROS' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	NULL Nome_Local, CTA.DC_HBO,dbo.valor(Vlr_Org_HBO*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.DC_HBO) , 
	month(convert(datetime,hou.Dt_Emis_HBO,105)) Mes,year(convert(datetime,hou.Dt_Emis_HBO,105)) Ano,'' Job,
	'N' Caixa,dbo.fBusca_Tarefa(hou.Num_Proc_HBO,40)   
From 
	House_BDP_OUT HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_cliente_hbo
	--Join Localidade DST with(nolock) on DST.cd_local=cd_dst_HIO
	Join Cta_Cte_HOU_BDP_OUT CTA with(nolock) on CTA.Num_Proc_HBO=hou.Num_Proc_HBO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join vwCXAS CXa with(nolock) on CTA.Num_Proc_HBO=cxa.Num_Proc_HIA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.DC_HBO=cxa.DC_HIA and num_lcto <> 'PROVISÓRIO' --AND month(convert(Datetime,dt_pgto_rcto_HIO,105))=month(convert(Datetime,dt_emis_HIO,105)) and year(convert(datetime,dt_pgto_rcto_HIO,105))=year(convert(datetime,dt_emis_HIO,105))
	Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,Dt_Emis_HBO,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC with(nolock) on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,Dt_Emis_HBO,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
Where
	cta.cd_Tp_moeda<>'REL' and Desp_Org_HBO='N'
	and cxa.num_lcto is null and left(hou.Num_Proc_HBO,5) <> 'BOJOB'
	and convert(datetime,Dt_Emis_HBO,105) between @DataInicial and @DataFinal
	and left(hou.Num_Proc_HBO,2) like @modal
	 --and nome_local like @localidade
	and Apelido like @Cliente and hou.Num_Proc_HBO like @num_proc

union


Select 
	HOU.Num_Proc_HBO Processo,'BO' Modal, 'HOU' HM ,'CAIXA' Tipo, Upper(Apelido) Cliente,Nome_tp_tx, 
	NULL Nome_Local, cta.DC_HBO,dbo.valor(Vlr_Pgto_Rcto_HIA,cta.DC_HBO) Valor, month(convert(datetime,hou.Dt_Emis_HBO,105)) Mes,
	year(convert(datetime,hou.dt_emis_HBO,105)) Ano,'' Job,
	'S' Caixa,dbo.fBusca_Tarefa(hou.Num_Proc_HBO,40)   
From 
	House_BDP_OUT HOU with(nolock)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_cliente_hbo
	--Join Localidade DST with(nolock) on DST.cd_local=cd_DST_HIO
	Join Cta_Cte_HOU_BDP_OUT CTA with(nolock) on CTA.Num_Proc_HBO=hou.Num_Proc_HBO
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
	Join vwCXAS CXa with(nolock) on CTA.Num_Proc_HBO=cxa.Num_Proc_HIA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.DC_HBO=cxa.DC_HIA and num_lcto <> 'PROVISÓRIO' --and month(convert(datetime,dt_pgto_Rcto_HIO,105))=month(convert(datetime,dt_emis_HIO,105)) and year(convert(Datetime,dt_pgto_rcto_HIO,105))=year(convert(datetime,dt_emis_HIO,105))
Where
	convert(datetime,Dt_Emis_HBO,105) between @DataInicial and @DataFinal
	and cta.cd_Tp_moeda<>'REL' and Desp_Org_HBO='N' and left(hou.Num_Proc_HBO,5) <> 'BOJOB'
	 and left(hou.Num_Proc_HBO,2) like @modal
	 --and nome_local like @localidade
	and Apelido like @Cliente and hou.Num_Proc_HBO like @num_proc


















GO
