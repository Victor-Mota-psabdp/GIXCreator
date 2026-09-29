SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE              Procedure [dbo].[spRentTT] 
		(
		 @DataInicial char(10),
		 @DataFinal char(10)
		)

--spRentTT '01-01-2009','12-31-2009'
as

Select 
	'IA' Modal, 'HOU' HM ,'CTA_REL' Tipo, Isnull(GRP.Apelido,Upper(pp.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, dc_hia,Sum(cast(dbo.valor(vlr_org_hia,dc_hia) as Decimal(15,2))) Valor, month(@DataFinal) Mes,year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HIA,2) Job ,
	Dt_Ins_hia Dt_Ins,hou.num_proc_hia Processo,cta.cD_tp_tx,CD_CONSIG_HIA Cd_Cliente
From 
	House_Imp_Aer HOU
	Join Pessoa pp on pp.cd_pes=cd_consig_hia
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join Cta_Cte_hou_imp_aer CTA on CTA.num_proc_hia=hou.num_proc_hia
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_hia
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes
Where
	convert(datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda='REL' and desp_org_hia='N' and left(hou.num_proc_hia,5) <> 'IAJOB'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'
Group by
	Nome_tp_tx, Nome_Local, dc_hia,pp.Nome_Raz_Soc,LEFT(JOB_HIA,2) ,
	Dt_Ins_hia,hou.num_proc_hia ,cta.cd_tp_tx,CD_CONSIG_HIA,GRP.Apelido

UNION

Select 
	'IO' Modal, 'HOU' HM ,'CTA_REL' Tipo, Isnull(GRP.Apelido,Upper(pp.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, dc_HIO,Sum(cast(dbo.valor(vlr_org_HIO,dc_HIO) as Decimal(15,2))) Valor, month(@DataFinal) Mes,year(@DataFinal) Ano,@DataFinal DataFinal,NULL Job,
	Dt_Ins_hio Dt_Ins,hou.num_proc_hio Processo,cta.cd_Tp_Tx,cd_consig_hio
From 
	House_Imp_OUT HOU
	Join Pessoa pp on pp.cd_pes=cd_consig_HIO
	Join Localidade DST on DST.cd_local=cd_dst_HIO
	Join Cta_Cte_hou_imp_OUT CTA on CTA.num_proc_HIO=hou.num_proc_HIO
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_hio
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	convert(datetime,dt_ins_HIO,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda='REL' and desp_org_HIO='N' and left(hou.num_proc_HIO,5) <> 'IAJOB'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'
Group by
	Nome_tp_tx, Nome_Local, dc_HIO,pp.Nome_Raz_Soc,Dt_Ins_hio,hou.num_proc_hio, CTA.cd_tp_tx,cd_consig_hio,
	GRP.aPelido



UNION

Select 
	'IA' Modal, 'HOU' HM,'CTA' Tipo, Isnull(GRP.apelido, Upper(pp.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_hia,Sum(cast(dbo.valor(vlr_org_hia*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_hia) as Decimal(15,2))) Valor,  month(@DataFinal) Mes, year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HIa,2) Job ,
	Dt_Ins_hia Dt_Ins, hou.num_proc_hia,cta.cd_tp_Tx,cd_consig_hia
From 
	House_Imp_Aer HOU
	Join Pessoa pp on pp.cd_pes=cd_consig_hia
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join Cta_Cte_hou_imp_aer CTA on CTA.num_proc_hia=hou.num_proc_hia
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_imp_Aer CXa on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' AND month(convert(Datetime,dt_pgto_rcto_hia,105))=month(convert(Datetime,dt_ins_hia,105)) and year(convert(datetime,dt_pgto_rcto_hia,105))=year(convert(datetime,dt_ins_hia,105))
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_ins_hia,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_ins_hia,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_hia
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	convert(datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and desp_org_hia='N'
	and cxa.num_lcto is null and left(hou.num_proc_hia,5) <> 'IAJOB'
	and left(cta.cd_tp_tx,1) <> 'X'
Group by
	Nome_tp_tx, Nome_Local, cta.dc_hia,pp.Nome_Raz_Soc,LEFT(JOB_HIA,2) ,Dt_Ins_hia ,hou.num_proc_hia,cta.cd_Tp_Tx,cd_consig_hia,
	GRP.apelido

UNION

Select 
	'IA' Modal, 'HOU' HM,'CTA' Tipo, Isnull(GRP.Apelido,Upper(pp.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_HIO,Sum(cast(dbo.valor(vlr_org_HIO*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_HIO) as Decimal(15,2))) Valor,  month(@DataFinal) Mes, year(@DataFinal) Ano,@DataFinal DataFinal,NULL  Job ,
	Dt_Ins_hio Dt_Ins, hou.num_proc_hio,cta.cd_tp_tx,cd_consig_hio
From 
	House_Imp_OUT HOU
	Join Pessoa pp on pp.cd_pes=cd_consig_HIO
	Join Localidade DST on DST.cd_local=cd_dst_HIO
	Join Cta_Cte_hou_imp_OUT CTA on CTA.num_proc_HIO=hou.num_proc_HIO
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_imp_OUT CXa on CTA.num_proc_HIO=cxa.num_proc_HIO and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HIO=cxa.dc_HIO and num_lcto <> 'PROVISÓRIO' AND month(convert(Datetime,dt_pgto_rcto_HIO,105))=month(convert(Datetime,dt_ins_HIO,105)) and year(convert(datetime,dt_pgto_rcto_HIO,105))=year(convert(datetime,dt_ins_HIO,105))
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_ins_HIO,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_ins_HIO,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_hio
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	convert(datetime,dt_ins_HIO,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and desp_org_HIO='N'
	and cxa.num_lcto is null and left(hou.num_proc_HIO,5) <> 'IAJOB'
	and left(cta.cd_tp_tx,1) <> 'X'
Group by
	Nome_tp_tx, Nome_Local, cta.dc_HIO,pp.Nome_Raz_Soc,Dt_Ins_hio, hou.num_proc_hio,cta.cd_tp_tx,cd_consig_hio,
	grp.apelido


UNION ALL

Select 
	'IA' Modal, 'HOU', 'CXA' Tipo, Isnull(GRP.apelido,upper(pp.Nome_Raz_Soc)),Nome_tp_tx, 
	Nome_Local, cta.dc_hia,Sum(cast(dbo.valor(vlr_pgto_rcto_hia,cta.dc_hia) as Decimal(15,2))) Valor,  month(@DataFinal) Mes, year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HIA,2) Job,
	Dt_Ins_hia Dt_Ins ,hou.num_proc_hia,cta.cd_tp_tx,cd_consig_hia
From 
	House_Imp_Aer HOU
	Join Pessoa pp on pp.cd_pes=cd_consig_hia
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join Cta_Cte_hou_imp_aer CTA on CTA.num_proc_hia=hou.num_proc_hia
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_imp_Aer CXa on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' and month(convert(datetime,dt_pgto_Rcto_hia,105))=month(convert(datetime,dt_ins_hia,105)) and year(convert(Datetime,dt_pgto_rcto_hia,105))=year(convert(datetime,dt_ins_hia,105))
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_hia
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	convert(datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and desp_org_hia='N' and left(hou.num_proc_hia,5) <> 'IAJOB'
	and left(cta.cd_tp_tx,1) <> 'X'
Group by
	Nome_tp_tx, Nome_Local, cta.dc_hia,pp.Nome_Raz_Soc,LEFT(JOB_HIA,2) ,
	Dt_Ins_hia , hou.num_proc_hia,cta.cd_tp_tx,cd_consig_hia,
	grp.apelido

UNION

Select 
	'IO' Modal, 'HOU', 'CXA' Tipo, isnull(GRP.apelido,PP.Nome_Raz_Soc),Nome_tp_tx, 
	Nome_Local, cta.dc_HIO,Sum(cast(dbo.valor(vlr_pgto_rcto_HIO,cta.dc_HIO) as Decimal(15,2))) Valor,  month(@DataFinal) Mes, year(@DataFinal) Ano,@DataFinal DataFinal,NULL JOB,
	Dt_Ins_hio Dt_Ins, hou.num_proc_hio,cta.cd_tp_Tx,cd_consig_hio
From 
	House_Imp_OUT HOU
	Join Pessoa pp on pp.cd_pes=cd_consig_HIO
	Join Localidade DST on DST.cd_local=cd_dst_HIO
	Join Cta_Cte_hou_imp_OUT CTA on CTA.num_proc_HIO=hou.num_proc_HIO
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_imp_OUT CXa on CTA.num_proc_HIO=cxa.num_proc_HIO and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HIO=cxa.dc_HIO and num_lcto <> 'PROVISÓRIO' and month(convert(datetime,dt_pgto_Rcto_HIO,105))=month(convert(datetime,dt_ins_HIO,105)) and year(convert(Datetime,dt_pgto_rcto_HIO,105))=year(convert(datetime,dt_ins_HIO,105))
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_hio
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	convert(datetime,dt_ins_HIO,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and desp_org_HIO='N' and left(hou.num_proc_HIO,5) <> 'IAJOB'
	and left(cta.cd_tp_tx,1) <> 'X'
Group by
	Nome_tp_tx, Nome_Local, cta.dc_HIO,pp.Nome_Raz_Soc ,Dt_Ins_hio ,cd_consig_hio,hou.num_proc_hio,cta.cd_tp_tx,
	GRP.Apelido


UNION 

Select 
	'IA' Modal, 'MAS' HM ,'CTA_REL' Tipo, isnull(GRP.apelido,Upper(pp.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, dc_Mia,Sum(cast(dbo.valor(vlr_org_Mia,dc_Mia)*isnull(dbo.sppar_Masc(num_proc_hia,rateio_tx),1) as Decimal(15,2))) Valor, month(@DataFinal) Mes , year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HIA,2) Job ,
	Dt_Ins_mia Dt_Ins,hou.num_proc_hia,cta.cd_tp_tx,cd_consig_hia
From 
	House_Imp_Aer HOU
	Join Pessoa pp on pp.cd_pes=cd_CONSIG_hia
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join Cta_Cte_MAS_imp_aer CTA on CTA.num_proc_Mia=hou.num_proc_Mia
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_hia
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	convert(datetime,dt_ins_Mia,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda='REL' and desp_org_Mia='N' and left(hou.num_proc_hia,5)<>'IAJOB'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'
Group by
	Nome_tp_tx, Nome_Local, dc_Mia,pp.Nome_Raz_Soc,LEFT(JOB_HIA,2) ,Dt_Ins_mia ,hou.num_proc_hia,cta.cd_tp_Tx,cd_consig_hia,
	GRP.APELIDO



UNION


Select 
	'IA' Modal, 'MAS' HM,'CTA' Tipo, Isnull(GRP.apelido,Upper(PP.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_Mia,Sum(cast(dbo.valor(vlr_org_mia*IsNull(dbo.sppar_masc(num_proc_hia,rateio_tx),1)*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_mia) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HIA,2) Job,
	Dt_Ins_mia Dt_Ins, hou.num_proc_hia,cta.cd_tp_tx,cd_consig_hia
From 
	House_Imp_Aer HOU
	Join Pessoa pp on pp.cd_pes=cd_CONSIG_hia
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join Cta_Cte_MAS_imp_aer CTA on CTA.num_proc_Mia=hou.num_proc_Mia
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_MAS_imp_Aer CXa on CTA.num_proc_Mia=cxa.num_proc_Mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_Mia=cxa.dc_Mia and num_lcto <> 'PROVISÓRIO' AND month(convert(Datetime,dt_pgto_rcto_Mia,105))=month(convert(Datetime,dt_ins_Mia,105)) and year(convert(datetime,dt_pgto_rcto_Mia,105))=year(convert(datetime,dt_ins_Mia,105))
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_ins_Mia,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMA'
	Left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_ins_Mia,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_hia
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	convert(datetime,dt_ins_Mia,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and desp_org_Mia='N'
	and cxa.num_lcto is null and left(hou.num_proc_hia,5) <> 'IAJOB'
	AND LEFT(CTA.CD_TP_tX,1)<>'X'
Group by
	Nome_tp_tx, Nome_Local, cta.dc_Mia,PP.Nome_Raz_Soc,LEFT(JOB_HIA,2) ,Dt_Ins_mia ,hou.num_proc_hia,cta.cd_tp_Tx,cd_consig_hia,
	GRP.Apelido


UNION 

Select 
	'IA' Modal, 'MAS', 'CXA' Tipo, Isnull(GRP.Apelido,pp.Nome_Raz_Soc) ,Nome_tp_tx, 
	Nome_Local, cta.dc_Mia,Sum(cast(dbo.valor(vlr_pgto_rcto_Mia*Isnull(dbo.spPar_MASC(num_proc_hia, rateio_Tx),1),cta.dc_Mia) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HIA,2) Job,
	Dt_Ins_mia Dt_Ins, hou.num_proc_hia,cta.cd_tp_tx,cd_consig_hia
From 
	House_Imp_Aer HOU
	Join Pessoa pp on pp.cd_pes=cd_CONSIG_hia
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join Cta_Cte_MAS_imp_aer CTA on CTA.num_proc_mia=hou.num_proc_mia
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_MAS_imp_Aer CXa on CTA.num_proc_mia=cxa.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_mia=cxa.dc_mia and num_lcto <> 'PROVISÓRIO' and month(convert(datetime,dt_ins_mia,105))=month(convert(datetime,dt_pgto_Rcto_mia,105)) and Year(convert(datetime,dt_ins_mia,105))=Year(convert(datetime,dt_pgto_Rcto_mia,105))
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_hia
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	convert(datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and desp_org_mia='N' and left(hou.num_proc_hia,5) <> 'IAJOB'
	AND LEFT(CTA.CD_TP_TX,1)<>'X'
Group by
	Nome_tp_tx, Nome_Local, cta.dc_mia,PP.Nome_Raz_Soc,LEFT(JOB_HIA,2) ,Dt_Ins_mia ,hou.num_proc_hia,cta.cd_tp_tx,cd_consig_hia,
	GRP.apelido



--EXPORTACAO AEREA


UNION

Select 
	'EA' Modal, 'HOU' HM ,'CTA_REL' Tipo, Isnull(GRP.apelido,Upper(pp.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, dc_hea,Sum(cast(dbo.valor(vlr_org_hea,dc_hea) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HEA,2) Job,
	Dt_Ins_hea Dt_Ins, hou.num_proc_hea,cta.cd_tp_tx,cd_export_hea
From 
	House_exp_Aer HOU
	Join Pessoa pp on pp.cd_pes=cd_export_hea
	Join Localidade DST on DST.cd_local=cd_org_hea
	Join Cta_Cte_hou_exp_aer CTA on CTA.num_proc_hea=hou.num_proc_hea
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hea
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	convert(datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)	and cta.cd_Tp_moeda='REL' and DESP_DST_hea='N' and left(hou.num_proc_hea,5) <> 'eajob'
	and left(cta.cd_tp_tx,1)<>'X'
Group by
	Nome_tp_tx, Nome_Local, dc_hea,PP.Nome_Raz_Soc,LEFT(JOB_HEA,2) ,Dt_Ins_hea , hou.num_proc_hea,cta.cd_tp_tx,cd_export_hea,
	GRP.Apelido

union

Select 
	'EO' Modal, 'HOU' HM ,'CTA_REL' Tipo, Isnull(GRP.Apelido,Upper(PP.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, dc_HEO,Sum(cast(dbo.valor(vlr_org_HEO,dc_HEO) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal,null Job,
	Dt_Ins_heo Dt_Ins, hou.num_proc_heo,cta.cd_tp_Tx,cd_exporT_heo
From 
	House_exp_OUT HOU
	Join Pessoa pp on pp.cd_pes=cd_export_HEO
	Join Localidade DST on DST.cd_local=cd_org_HEO
	Join Cta_Cte_hou_exp_OUT CTA on CTA.num_proc_HEO=hou.num_proc_HEO
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx

	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_heo
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	convert(datetime,dt_ins_HEO,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)	and cta.cd_Tp_moeda='REL' and DESP_org_HEO='N' and left(hou.num_proc_HEO,5) <> 'eajob'
	and left(cta.cd_tp_tx,1)<>'X'
Group by
	Nome_tp_tx, Nome_Local, dc_HEO,PP.Nome_Raz_Soc,Dt_Ins_heo, hou.num_proc_heo,cta.cd_tp_tx,cd_exporT_heo,
	GRP.Apelido


UNION

Select 
	'EA' Modal, 'HOU' HM,'CTA' Tipo, Isnull(GRP.Apelido,Upper(PP.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_hea,Sum(cast(dbo.valor(vlr_org_hea*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_hea) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HEA,2) JOB,
	Dt_Ins_hea Dt_Ins, hou.num_proc_hea,cta.cd_tp_tx,cd_ExporT_hea
From 
	House_exp_Aer HOU
	Join Pessoa pp on pp.cd_pes=cd_export_hea
	Join Localidade DST on DST.cd_local=cd_org_hea
	Join Cta_Cte_hou_exp_aer CTA on CTA.num_proc_hea=hou.num_proc_hea
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_exp_Aer CXa on CTA.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO' AND month(convert(Datetime,dt_pgto_rcto_hea,105))=month(convert(Datetime,dt_ins_hea,105)) and year(convert(datetime,dt_pgto_rcto_hea,105))=year(convert(datetime,dt_ins_hea,105))
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_ins_hea,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='EXA'
	Left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_ins_hea,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hea
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes
Where
	convert(datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and DESP_DST_hea='N'
	and cxa.num_lcto is null and left(hou.num_proc_hea,5) <> 'EAJOB'
	AND LEFT(CTA.CD_TP_TX,1)<>'X'
Group by
	Nome_tp_tx, Nome_Local, cta.dc_hea,PP.Nome_Raz_Soc,LEFT(JOB_HEA,2),Dt_Ins_hea, hou.num_proc_hea, cta.cd_tp_Tx,cd_export_hea,
	GRP.Apelido

UNION

Select 
	'EO' Modal, 'HOU' HM,'CTA' Tipo, Isnull(GRP.Apelido,Upper(PP.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_HEO,Sum(cast(dbo.valor(vlr_org_HEO*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_HEO) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal, NULL JOB,
	Dt_Ins_heo Dt_Ins, hou.num_proc_heo,cta.cd_tp_tx,cd_export_heo
From 
	House_exp_OUT HOU
	Join Pessoa pp on pp.cd_pes=cd_export_HEO
	Join Localidade DST on DST.cd_local=cd_org_HEO
	Join Cta_Cte_hou_exp_OUT CTA on CTA.num_proc_HEO=hou.num_proc_HEO
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_exp_OUT CXa on CTA.num_proc_HEO=cxa.num_proc_HEO and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HEO=cxa.dc_HEO and num_lcto <> 'PROVISÓRIO' AND month(convert(Datetime,dt_pgto_rcto_HEO,105))=month(convert(Datetime,dt_ins_HEO,105)) and year(convert(datetime,dt_pgto_rcto_HEO,105))=year(convert(datetime,dt_ins_HEO,105))
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_ins_HEO,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='EXA'
	Left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_ins_HEO,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'

	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_heo
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	convert(datetime,dt_ins_HEO,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and DESP_ORG_HEO='N'
	and cxa.num_lcto is null and left(hou.num_proc_HEO,5) <> 'EAJOB'
	AND LEFT(CTA.CD_TP_TX,1)<>'X'
Group by
	Nome_tp_tx, Nome_Local, cta.dc_HEO,PP.Nome_Raz_Soc,Dt_Ins_heo, hou.num_proc_heo,cta.cd_tp_tx,cd_export_heo,
	GRP.apelido


UNION

Select 
	'EA' Modal, 'HOU', 'CXA' Tipo, Isnull(GRP.Apelido,PP.Nome_Raz_Soc),Nome_tp_tx, 
	Nome_Local, cta.dc_hea,Sum(cast(dbo.valor(vlr_pgto_rcto_hea,cta.dc_hea) as Decimal(15,2))) Valor, month(@DataFinal) Mes, year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HEA,2) JOB,
	Dt_Ins_hea Dt_Ins, hou.num_proc_hea,cta.cd_tp_tx,cd_exporT_hea
From 
	House_EXP_Aer HOU
	Join Pessoa pp on pp.cd_pes=cd_EXPort_hea
	Join Localidade DST on DST.cd_local=cd_org_hea
	Join Cta_Cte_hou_EXP_aer CTA on CTA.num_proc_hea=hou.num_proc_hea
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_EXP_Aer CXa on CTA.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO' and month(convert(datetime,dt_pgto_Rcto_hea,105))=month(convert(datetime,dt_ins_hea,105)) and year(convert(Datetime,dt_pgto_rcto_hea,105))=year(convert(datetime,dt_ins_hea,105))
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hea
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	convert(datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and desp_dst_hea='N' and left(hou.num_proc_hea,5) <> 'EAJOB'
	AND LEFT(CTA.CD_TP_TX,1) <>'X'

Group by
	Nome_tp_tx, Nome_Local, cta.dc_hea,PP.Nome_Raz_Soc,LEFT(JOB_HEA,2),Dt_Ins_hea , hou.num_proc_hea,cta.cd_tp_tx,cd_export_hea,
	GRP.Apelido

UNION 

Select 
	'EO' Modal, 'HOU', 'CXA' Tipo, ISnull(GRP.apelido,PP.Nome_Raz_Soc),Nome_tp_tx, 
	Nome_Local, cta.dc_HEO,Sum(cast(dbo.valor(vlr_pgto_rcto_HEO,cta.dc_HEO) as Decimal(15,2))) Valor, month(@DataFinal) Mes, year(@DataFinal) Ano,@DataFinal DataFinal,NULL JOB,
	Dt_Ins_heo Dt_Ins, hou.num_proc_heo,cta.cd_tp_tx,cd_export_heo
From 
	House_EXP_OUT HOU
	Join Pessoa pp on pp.cd_pes=cd_EXPort_HEO
	Join Localidade DST on DST.cd_local=cd_org_HEO
	Join Cta_Cte_hou_EXP_OUT CTA on CTA.num_proc_HEO=hou.num_proc_HEO
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_EXP_OUT CXa on CTA.num_proc_HEO=cxa.num_proc_HEO and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_HEO=cxa.dc_HEO and num_lcto <> 'PROVISÓRIO' and month(convert(datetime,dt_pgto_Rcto_HEO,105))=month(convert(datetime,dt_ins_HEO,105)) and year(convert(Datetime,dt_pgto_rcto_HEO,105))=year(convert(datetime,dt_ins_HEO,105))
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_heo
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes
Where
	convert(datetime,dt_ins_HEO,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and desp_ORG_HEO='N' and left(hou.num_proc_HEO,5) <> 'EAJOB'
	AND LEFT(CTA.CD_TP_TX,1) <>'X'

Group by
	Nome_tp_tx, Nome_Local, cta.dc_HEO,PP.Nome_Raz_Soc,Dt_Ins_heo, hou.num_proc_heo,cta.cd_tp_tx,cd_export_heo,
	GRP.Apelido


UNION

Select 
	'EA' Modal, 'MAS' HM ,'CTA_REL' Tipo, Isnull(GRP.apelido,Upper(PP.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, dc_MEA,Sum(cast(dbo.valor(vlr_org_MEA,dc_MEA)*isnull(dbo.sppar_Masc(num_proc_HEA,rateio_tx),1) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HEA,2),
	Dt_Ins_mea Dt_Ins, hou.num_proc_hea,cta.cd_tp_tx,cd_export_hea
From 
	House_EXP_Aer HOU
	Join Pessoa pp on pp.cd_pes=cd_EXPort_HEA
	Join Localidade DST on DST.cd_local=cd_org_hea
	Join Cta_Cte_MAS_EXP_aer CTA on CTA.num_proc_MEA=hou.num_proc_MEA
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hea
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	convert(datetime,dt_ins_MEA,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda='REL' and DESP_DST_MEA='N' and left(hou.num_proc_HEA,5)<>'EAJOB'
	AND LEFT(CTA.CD_TP_TX,1) <>'X'
Group by
	Nome_tp_tx, Nome_Local, dc_MEA,PP.Nome_Raz_Soc,LEFT(JOB_HEA,2),Dt_Ins_mea , hou.num_proc_hea,cta.cd_tp_tx,cd_export_hea,
	GRP.Apelido


UNION 


Select 
	'EA' Modal, 'MAS' HM,'CTA' Tipo, Isnull(GRP.apelido,Upper(pp.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_mea,Sum(cast(dbo.valor(vlr_org_mea*IsNull(dbo.sppar_masc(num_proc_hea,rateio_tx),1)*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_mea) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HEA,2) JOB,
	Dt_Ins_mea Dt_Ins, hou.num_proc_hea,cta.cd_tp_tx,cd_export_hea
From 
	House_exp_Aer HOU
	Join Pessoa pp on pp.cd_pes=cd_export_hea
	Join Localidade DST on DST.cd_local=cd_org_hea
	Join Cta_Cte_MAS_exp_aer CTA on CTA.num_proc_mea=hou.num_proc_mea
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_MAS_exp_Aer CXa on CTA.num_proc_mea=cxa.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO' AND month(convert(Datetime,dt_pgto_rcto_mea,105))=month(convert(Datetime,dt_ins_mea,105)) and year(convert(datetime,dt_pgto_rcto_mea,105))=year(convert(datetime,dt_ins_mea,105))
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_ins_mea,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='EXA'
	Left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_ins_mea,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hea
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes
Where
	convert(datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and DESP_DST_mea='N'
	and cxa.num_lcto is null and left(hou.num_proc_hea,5) <> 'EAJOB'
	AND LEFT(CTA.CD_TP_TX,1) <>'X'
Group by
	Nome_tp_tx, Nome_Local, cta.dc_mea,PP.Nome_Raz_Soc,LEFT(JOB_HEA,2),Dt_Ins_mea , hou.num_proc_hea,cta.cd_tp_Tx,cd_export_hea,
	GRP.apelido


UNION 

Select 
	'EA' Modal, 'MAS', 'CXA' Tipo, Isnull(GRP.apelido,pp.Nome_Raz_Soc),Nome_tp_tx, 
	Nome_Local, cta.dc_MEA,Sum(cast(dbo.valor(vlr_pgto_rcto_MEA*Isnull(dbo.spPar_MASC(num_proc_HEA, rateio_Tx),1),cta.dc_MEA) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HEA,2),
	Dt_Ins_mea Dt_Ins, hou.num_proc_hea,cta.cd_tp_tx,cd_export_hea
From 
	House_EXP_Aer HOU
	Join Pessoa pp on pp.cd_pes=cd_EXPort_HEA
	Join Localidade DST on DST.cd_local=cd_org_hea
	Join Cta_Cte_MAS_EXP_aer CTA on CTA.num_proc_MEA=hou.num_proc_MEA
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_MAS_EXP_Aer CXa on CTA.num_proc_MEA=cxa.num_proc_MEA and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_MEA=cxa.dc_MEA and num_lcto <> 'PROVISÓRIO' and month(convert(datetime,dt_ins_MEA,105))=month(convert(datetime,dt_pgto_Rcto_MEA,105)) and Year(convert(datetime,dt_ins_MEA,105))=Year(convert(datetime,dt_pgto_Rcto_MEA,105))
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hea
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes
Where
	convert(datetime,dt_ins_MEA,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and DESP_DST_MEA='N' and left(hou.num_proc_HEA,5) <> 'EAJOB'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'	
Group by
	Nome_tp_tx, Nome_Local, cta.dc_MEA,pp.Nome_Raz_Soc,LEFT(JOB_HEA,2),Dt_Ins_mea , hou.num_proc_hea,cta.cd_tp_tx,cd_export_hea,
	GRP.apelido


union

Select 
	'IM' Modal, 'HOU' HM ,'CTA_REL' Tipo, Isnull(GRP.apelido,Upper(PP.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, dc_him,Sum(cast(dbo.valor(vlr_org_him,dc_him) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HIM,2),
	Dt_Ins_him Dt_Ins, hou.num_proc_him,cta.cd_tp_Tx,cd_consig_him
From 
	House_Imp_mar HOU
	Join Pessoa pp on pp.cd_pes=cd_CONSIG_him
	Join Localidade DST on DST.cd_local=cd_dst_him
	Join Cta_Cte_hou_imp_mar CTA on CTA.num_proc_him=hou.num_proc_him
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_him
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	convert(datetime,dt_ins_him,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda='REL' and desp_org_him='N' and left(hou.num_proc_him,5) <> 'imjob'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'
Group by
	Nome_tp_tx, Nome_Local, dc_him,pp.Nome_Raz_Soc,LEFT(JOB_HIM,2),Dt_Ins_him , hou.num_proc_him,cta.cd_tp_tx,cd_consig_him,
	GRP.apelido


UNION

Select 
	'IM' Modal, 'HOU' HM,'CTA' Tipo, Isnull(GRP.apelido,Upper(pp.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_him,Sum(cast(dbo.valor(vlr_org_him*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_him) as Decimal(15,2))) Valor , month(@DataFinal) Mes, year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HIM,2) JOB,
	Dt_Ins_him Dt_Ins, hou.num_proc_him,cta.cd_tp_tx,cd_consig_him
From 
	House_Imp_mar HOU
	Join Pessoa pp on pp.cd_pes=cd_CONSIG_him
	Join Localidade DST on DST.cd_local=cd_dst_him
	Join Cta_Cte_hou_imp_mar CTA on CTA.num_proc_him=hou.num_proc_him
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_imp_mar CXa on CTA.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' AND month(convert(Datetime,dt_pgto_rcto_him,105))=month(convert(Datetime,dt_ins_him,105)) and year(convert(datetime,dt_pgto_rcto_him,105))=year(convert(datetime,dt_ins_him,105))
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_ins_him,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMM'
	Left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_ins_him,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_him
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	convert(datetime,dt_ins_him,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and desp_org_him='N'
	and cxa.num_lcto is null and left(hou.num_proc_him,5) <> 'imjob'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'

Group by	Nome_tp_tx, Nome_Local, cta.dc_him,pp.Nome_Raz_Soc,LEFT(JOB_HIM,2),Dt_Ins_him , hou.num_proc_him,cta.cd_tp_tx,cd_consig_him,
	GRP.apelido

UNION ALL

Select 
	'IM' Modal, 'HOU', 'CXA' Tipo, Isnull(GRP.apelido,PP.Nome_Raz_Soc),Nome_tp_tx, 
	Nome_Local, cta.dc_him,Sum(cast(dbo.valor(vlr_pgto_rcto_him,cta.dc_him) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HIM,2) Job,
	Dt_Ins_him Dt_Ins, hou.num_proc_him,cta.cd_tp_tx,cd_consig_him
From 
	House_Imp_mar HOU
	Join Pessoa pp on pp.cd_pes=cd_CONSIG_him
	Join Localidade DST on DST.cd_local=cd_dst_him
	Join Cta_Cte_hou_imp_mar CTA on CTA.num_proc_him=hou.num_proc_him
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_imp_mar CXa on CTA.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' and month(convert(datetime,dt_pgto_Rcto_him,105))=month(convert(datetime,dt_ins_him,105)) and year(convert(Datetime,dt_pgto_rcto_him,105))=year(convert(datetime,dt_ins_him,105))
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_him
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	convert(datetime,dt_ins_him,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and desp_org_him='N' and left(hou.num_proc_him,5) <> 'imjob'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'
	
Group by
	grp.apelido,Nome_tp_tx, Nome_Local, cta.dc_him,PP.Nome_Raz_Soc,LEFT(JOB_HIM,2),Dt_Ins_him , hou.num_proc_him,cta.cd_tp_Tx,cd_consig_him


UNION 

Select 
	'IM' Modal, 'MAS' HM ,'CTA_REL' Tipo, Isnull(GRP.apelido,Upper(PP.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, dc_mim,Sum(cast(dbo.valor(vlr_org_mim,dc_mim)*isnull(dbo.sppar_Masc(num_proc_him,rateio_tx),1) as Decimal(15,2))) Valor , month(@DataFinal) Mes , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HIM,2),
	Dt_Ins_mim Dt_Ins, hou.num_proc_him,cta.cd_tp_tx,cd_consig_him
From 
	House_Imp_mar HOU
	Join Pessoa pp on pp.cd_pes=cd_CONSIG_him
	Join Localidade DST on DST.cd_local=cd_dst_him
	Join Cta_Cte_MAS_imp_mar CTA on CTA.num_proc_mim=hou.num_proc_mim
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_him
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	convert(datetime,dt_ins_mim,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda='REL' and desp_org_mim='N' and left(hou.num_proc_him,5)<>'imjob'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'
Group by
	GRP.apelido, Nome_tp_tx, Nome_Local, dc_mim,PP.Nome_Raz_Soc,LEFT(JOB_HIM,2),Dt_Ins_mim , hou.num_proc_him,cta.cd_tp_Tx,cd_consig_him


UNION


Select 
	'IM' Modal, 'MAS' HM,'CTA' Tipo, Isnull(GRP.apelido,Upper(pp.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_mim,Sum(cast(dbo.valor(vlr_org_mim*IsNull(dbo.sppar_masc(num_proc_him,rateio_tx),1)*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_mim) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HIM,2),
	Dt_Ins_mim Dt_Ins, hou.num_proc_him,cta.cd_tp_tx,cd_consig_him
From 
	House_Imp_mar HOU
	Join Pessoa pp on pp.cd_pes=cd_consig_him
	Join Localidade DST on DST.cd_local=cd_dst_him
	Join Cta_Cte_MAS_imp_mar CTA on CTA.num_proc_mim=hou.num_proc_mim
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_MAS_imp_mar CXa on CTA.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' AND month(convert(Datetime,dt_pgto_rcto_mim,105))=month(convert(Datetime,dt_ins_mim,105)) and year(convert(datetime,dt_pgto_rcto_mim,105))=year(convert(datetime,dt_ins_mim,105))
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_ins_mim,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='IMM'
	Left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_ins_mim,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_him
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	convert(datetime,dt_ins_mim,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and desp_org_mim='N'
	and cxa.num_lcto is null and left(hou.num_proc_him,5) <> 'imjob'
	and left(cta.cd_tp_tx,1) <> 'X'
Group by
	GRP.apelido,Nome_tp_tx, Nome_Local, cta.dc_mim,PP.Nome_Raz_Soc,LEFT(JOB_HIM,2),Dt_Ins_mim, hou.num_proc_him,cta.cd_tp_tx,cd_consig_him

UNION 

Select 
	'IM' Modal, 'MAS', 'CXA' Tipo, Isnull(GRP.apelido,PP.Nome_Raz_Soc),Nome_tp_tx, 
	Nome_Local, cta.dc_mim,Sum(cast(dbo.valor(vlr_pgto_rcto_mim*Isnull(dbo.spPar_MASC(num_proc_him, rateio_Tx),1),cta.dc_mim) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HIM,2) job,
	Dt_Ins_mim Dt_Ins, hou.num_proc_him,cta.cd_tp_tx,cd_consig_him
From 
	House_Imp_mar HOU
	Join Pessoa pp on pp.cd_pes=cd_consig_him
	Join Localidade DST on DST.cd_local=cd_dst_him
	Join Cta_Cte_MAS_imp_mar CTA on CTA.num_proc_mim=hou.num_proc_mim
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_MAS_imp_mar CXa on CTA.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO' and month(convert(datetime,dt_ins_mim,105))=month(convert(datetime,dt_pgto_Rcto_mim,105)) and Year(convert(datetime,dt_ins_mim,105))=Year(convert(datetime,dt_pgto_Rcto_mim,105))
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_him
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	convert(datetime,dt_ins_mim,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and desp_org_mim='N' and left(hou.num_proc_him,5) <> 'imjob'
	and left(cta.cd_tp_tx,1) <> 'X'

Group by
	GRP.apelido,Nome_tp_tx, Nome_Local, cta.dc_mim,pp.Nome_Raz_Soc,LEFT(JOB_HIM,2),Dt_Ins_mim, hou.num_proc_him,cta.cd_tp_tx,cd_consig_him



--EXPORTAÇÃO MARITIMA

UNION

Select 
	'EM' Modal, 'HOU' HM ,'CTA_REL' Tipo, Isnull(GRP.apelido,Upper(PP.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, dc_hem,Sum(cast(dbo.valor(vlr_org_hem,dc_hem) as Decimal(15,2))) Valor , month(@DataFinal) Mes , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HEM,2),
	Dt_Ins_hem Dt_Ins, hou.num_proc_hem,cta.cd_tp_tx,cd_export_hem
From 
	House_exp_mar HOU
	Join Pessoa pp on pp.cd_pes=cd_export_hem
	Join Localidade DST on DST.cd_local=cd_org_hem
	Join Cta_Cte_hou_exp_mar CTA on CTA.num_proc_hem=hou.num_proc_hem
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hem
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	convert(datetime,dt_ins_hem,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda='REL' and DESP_DST_hem='N' and left(hou.num_proc_hem,5) <> 'EMJOB'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'
Group by
	GRP.apelido,Nome_tp_tx, Nome_Local, dc_hem,PP.Nome_Raz_Soc, LEFT(JOB_HEM,2),Dt_Ins_hem, hou.num_proc_hem,cta.cd_tp_Tx,cd_export_hem

UNION

Select 
	'EM' Modal, 'HOU' HM,'CTA' Tipo, Isnull(GRP.apelido,Upper(PP.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_hem,Sum(cast(dbo.valor(vlr_org_hem*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_hem) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HEM,2),
	Dt_Ins_hem Dt_Ins, hou.num_proc_hem,cta.cd_tp_tx,cd_export_hem
From 
	House_exp_mar HOU
	Join Pessoa pp on pp.cd_pes=cd_export_hem
	Join Localidade DST on DST.cd_local=cd_org_hem
	Join Cta_Cte_hou_exp_mar CTA on CTA.num_proc_hem=hou.num_proc_hem
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_hou_exp_mar CXa on CTA.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO' AND month(convert(Datetime,dt_pgto_rcto_hem,105))=month(convert(Datetime,dt_ins_hem,105)) and year(convert(datetime,dt_pgto_rcto_hem,105))=year(convert(datetime,dt_ins_hem,105))
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_ins_hem,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='EXA'
	Left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_ins_hem,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hem
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	convert(datetime,dt_ins_hem,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and DESP_DST_hem='N'
	and cxa.num_lcto is null and left(hou.num_proc_hem,5) <> 'EMJOB'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'
Group by
	GRP.apelido,Nome_tp_tx, Nome_Local, cta.dc_hem,PP.Nome_Raz_Soc,LEFT(JOB_HEM,2),Dt_Ins_hem, hou.num_proc_hem,cta.cd_tp_tx,cd_export_hem

UNION

Select 
	'EM' Modal, 'HOU', 'CXA' Tipo, Isnull(GRP.apelido,pp.Nome_Raz_Soc),Nome_tp_tx, 
	Nome_Local, cta.dc_hem,Sum(cast(dbo.valor(vlr_pgto_rcto_hem,cta.dc_hem) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HEM,2),
	Dt_Ins_hem Dt_Ins, hou.num_proc_hem,cta.cd_tp_Tx,cd_export_hem
From 
	House_EXP_mar HOU
	Join Pessoa pp on pp.cd_pes=cd_EXPort_hem
	Join Localidade DST on DST.cd_local=cd_org_hem
	Join Cta_Cte_hou_EXP_mar CTA on CTA.num_proc_hem=hou.num_proc_hem
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_hou_EXP_mar CXa on CTA.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO' and month(convert(datetime,dt_pgto_Rcto_hem,105))=month(convert(datetime,dt_ins_hem,105)) and year(convert(Datetime,dt_pgto_rcto_hem,105))=year(convert(datetime,dt_ins_hem,105))
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hem
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	convert(datetime,dt_ins_hem,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and desp_dst_hem='N' and left(hou.num_proc_hem,5) <> 'EMJOB'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'

Group by
	GRP.apelido,Nome_tp_tx, Nome_Local, cta.dc_hem,PP.Nome_Raz_Soc, LEFT(JOB_HEM,2),Dt_Ins_hem, hou.num_proc_hem,cta.cd_tp_tx,cd_export_hem

UNION 

Select 
	'EM' Modal, 'MAS' HM ,'CTA_REL' Tipo, Isnull(GRP.apelido,Upper(PP.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, dc_mem,Sum(cast(dbo.valor(vlr_org_mem,dc_mem)*isnull(dbo.sppar_Masc(num_proc_hem,rateio_tx),1) as Decimal(15,2))) Valor , month(@DataFinal) Mes , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HEM,2),
	Dt_Ins_mem Dt_Ins, hou.num_proc_hem,cta.cd_tp_tx,cd_export_hem
From 
	House_EXP_mar HOU
	Join Pessoa pp on pp.cd_pes=cd_EXPort_hem
	Join Localidade DST on DST.cd_local=cd_org_hem
	Join Cta_Cte_MAS_EXP_mar CTA on CTA.num_proc_mem=hou.num_proc_mem
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx

	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hem
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	convert(datetime,dt_ins_mem,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda='REL' and DESP_DST_mem='N' and left(hou.num_proc_hem,5)<>'EMJOB'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'
Group by
	GRP.apelido,Nome_tp_tx, Nome_Local, dc_mem,PP.Nome_Raz_Soc,LEFT(JOB_HEM,2),Dt_Ins_mem, hou.num_proc_hem,cta.cd_tp_tx,cd_export_hem


UNION 


Select 
	'EM' Modal, 'MAS' HM,'CTA' Tipo, Isnull(GRP.apelido,Upper(PP.Nome_Raz_Soc)) Cliente,Nome_tp_tx, 
	Nome_Local, cta.dc_mem,Sum(cast(dbo.valor(vlr_org_mem*IsNull(dbo.sppar_masc(num_proc_hem,rateio_tx),1)*(isnull(par.par_moeda,isnull(ofc.par_moeda,1))),cta.dc_mem) as Decimal(15,2))) Valor, month(@DataFinal) Mes  , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HEM,2),
	Dt_Ins_mem Dt_Ins, hou.num_proc_hem,cta.cd_tp_Tx,cd_exporT_hem
From 
	House_exp_mar HOU
	Join Pessoa pp on pp.cd_pes=cd_export_hem
	Join Localidade DST on DST.cd_local=cd_org_hem
	Join Cta_Cte_MAS_exp_mar CTA on CTA.num_proc_mem=hou.num_proc_mem
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Caixa_MAS_exp_mar CXa on CTA.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO' AND month(convert(Datetime,dt_pgto_rcto_mem,105))=month(convert(Datetime,dt_ins_mem,105)) and year(convert(datetime,dt_pgto_rcto_mem,105))=year(convert(datetime,dt_ins_mem,105))
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(datetime,dt_ins_mem,105)=convert(datetime,par.dt_par,105) and par.cd_tp_par='EXA'
	Left Join Paridade OFC on CTA.cd_tp_moeda=OFC.cd_tp_moeda and convert(datetime,dt_ins_mem,105)=convert(Datetime,ofc.dt_par,105) and ofc.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hem
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	convert(datetime,dt_ins_mem,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and DESP_DST_mem='N'
	and cxa.num_lcto is null and left(hou.num_proc_hem,5) <> 'EMJOB'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'
Group by
	GRP.apelido,Nome_tp_tx, Nome_Local, cta.dc_mem,PP.Nome_Raz_Soc, LEFT(JOB_HEM,2),Dt_Ins_mem, hou.num_proc_hem,cta.cd_tp_tx,cd_export_hem


UNION 

Select 
	'EM' Modal, 'MAS', 'CXA' Tipo, Isnull(GRP.apelido,PP.Nome_Raz_Soc),Nome_tp_tx, 
	Nome_Local, cta.dc_mem,Sum(cast(dbo.valor(vlr_pgto_rcto_mem*Isnull(dbo.spPar_MASC(num_proc_hem, rateio_Tx),1),cta.dc_mem) as Decimal(15,2))) Valor, month(@DataFinal) Mes , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HEM,2),
	Dt_Ins_mem Dt_Ins, hou.num_proc_hem,cta.cd_tp_Tx,cd_export_hem
From 
	House_EXP_mar HOU
	Join Pessoa pp on pp.cd_pes=cd_EXPort_hem
	Join Localidade DST on DST.cd_local=cd_org_hem
	Join Cta_Cte_MAS_EXP_mar CTA on CTA.num_proc_mem=hou.num_proc_mem
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Caixa_MAS_EXP_mar CXa on CTA.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dC_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO' and month(convert(datetime,dt_ins_mem,105))=month(convert(datetime,dt_pgto_Rcto_mem,105)) and Year(convert(datetime,dt_ins_mem,105))=Year(convert(datetime,dt_pgto_Rcto_mem,105))
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hem
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	convert(datetime,dt_ins_mem,105) between @DataInicial and @DataFinal
	And cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc)
	and cta.cd_Tp_moeda<>'REL' and DESP_DST_mem='N' and left(hou.num_proc_hem,5) <> 'EMJOB'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'	
Group by
	GRP.apelido,Nome_tp_tx, Nome_Local, cta.dc_mem,PP.Nome_Raz_Soc, LEFT(JOB_HEM,2),Dt_Ins_mem, hou.num_proc_hem,cta.cd_tp_tx,cd_export_hem


UNION ALL
--VARIAÇÃO CAMBIAL

Select
	'IA' Modal, 'HOU','VAR' Tipo, Isnull(GRP.apelido,Upper(PP.Nome_Raz_Soc)), Nome_tp_Tx, 
	Nome_Local, cta.dc_hia,sum(dbo.valor(vlr_pgto_rcto_hia,cxa.dc_hia)-IsNull(dbo.valor(VLR_ORG_HIA*ISNULL(PAR.PAR_MOEDA,1),cta.dc_hia),0)) Valor, month(@DataFinal) Mes , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HIA,2),
	Dt_Ins_hia Dt_Ins, hou.num_proc_hia,cta.cd_tp_tx,cd_consig_hia
From
	Caixa_hou_imp_Aer CXA
	Join cta_cte_hou_imp_aer CTA on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
	Join House_imp_aer hou on hou.num_proc_hia=cta.num_proc_hia
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join Pessoa PP on pp.cd_pes=cd_consig_hia
	Join Tipo_Taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
	Left Join Paridade PAR on CTA.cd_Tp_MOEDA=PAR.cd_tp_moeda and convert(datetime,dt_ins_HIA,105)=convert(datetime,dt_par,105) and PAR.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_hia
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	Convert(Datetime,dt_pgto_Rcto_hia,105) between @DataInicial and @DataFinal 
	and Convert(datetime,dt_pgto_rcto_hia, 105) > convert(datetime,dt_ins_hia,105)
	and month(convert(datetime,dt_pgto_rcto_hia,105))<>month(convert(Datetime,dt_ins_hia,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_hia,105))>=2006
	and num_lcto <> 'PROVISÓRIO'
	AND LEFT(CTA.CD_TP_tX,1) <> 'X'
GROUP BY 
	GRP.apelido,Nome_tp_tx, Nome_Local, cta.dc_hia,PP.Nome_Raz_Soc, LEFT(JOB_HIA,2),Dt_Ins_hia, hou.num_proc_hia,cta.cd_tp_tx,cd_consig_hia

UNION ALL

Select
	'EA' Modal, 'HOU','VAR' Tipo, Isnull(GRP.apelido,Upper(PP.Nome_Raz_Soc)), Nome_tp_Tx, 
	Nome_Local, cta.dc_hea,sum(dbo.valor(vlr_pgto_rcto_hea,cxa.dc_hea)-IsNull(dbo.valor(VLR_ORG_HEA*ISNULL(PAR.PAR_MOEDA,1),cta.dc_hea),0)) Valor, month(@DataFinal) Mes , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HEA,2),
	Dt_Ins_hea Dt_Ins, hou.num_proc_hea,cta.cd_tp_tx,cd_export_hea
From
	Caixa_hou_exp_Aer CXA
	Join cta_cte_hou_exp_aer CTA on cta.num_proc_hea=cxa.num_proc_hea and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea
	Join House_exp_aer hou on hou.num_proc_hea=cta.num_proc_hea
	Join Localidade DST on DST.cd_local=cd_dst_hea
	Join Pessoa PP on pp.cd_pes=cd_export_hea
	Join Tipo_Taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
	Left Join Paridade PAR on CTA.cd_Tp_MOEDA=PAR.cd_tp_moeda and convert(datetime,dt_ins_HEA,105)=convert(datetime,dt_par,105) and PAR.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hea
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	Convert(Datetime,dt_pgto_Rcto_hea,105) between @DataInicial and @DataFinal 
	and Convert(datetime,dt_pgto_rcto_hea, 105) > convert(datetime,dt_ins_hea,105)
	and month(convert(datetime,dt_pgto_rcto_hea,105))<>month(convert(Datetime,dt_ins_hea,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_hea,105))>=2006
	and num_lcto <> 'PROVISÓRIO'
	AND LEFT(CTA.CD_TP_tX,1)<>'X'
GROUP BY 
	GRP.apelido,Nome_tp_tx, Nome_Local, cta.dc_hea,PP.Nome_Raz_Soc, LEFT(JOB_HEA,2),Dt_Ins_hea, hou.num_proc_hea,cta.cd_tp_Tx,cd_export_hea

union all

Select
	'IM' Modal, 'HOU','VAR' Tipo, Upper(PP.Nome_Raz_Soc), Nome_tp_Tx, 
	Nome_Local, cta.dc_him,sum(dbo.valor(vlr_pgto_rcto_him,cxa.dc_him)-IsNull(dbo.valor(vlr_org_him*isnull(par.par_moeda,1),cta.dc_him),0)) Valor, month(@DataFinal) Mes , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HIM,2),
	Dt_Ins_him Dt_Ins, hou.num_proc_him,cta.cd_tp_tx,cd_consig_him
From
	Caixa_hou_imp_mar CXA
	Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=cxa.num_proc_him and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him
	Join House_imp_mar hou on hou.num_proc_him=cta.num_proc_him
	Join Localidade DST on DST.cd_local=cd_dst_him
	Join Pessoa PP on pp.cd_pes=cd_CONSIG_him
	Join Tipo_Taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
	Left Join Paridade PAR on CTA.cd_Tp_MOEDA=PAR.cd_tp_moeda and convert(datetime,dt_ins_him,105)=convert(datetime,dt_par,105) and PAR.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_him
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	Convert(Datetime,dt_pgto_Rcto_him,105) between @DataInicial and @DataFinal 
	and Convert(datetime,dt_pgto_rcto_him, 105) > convert(datetime,dt_ins_him,105)
	and month(convert(datetime,dt_pgto_rcto_him,105))<>month(convert(Datetime,dt_ins_him,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_him,105))>=2006
	and num_lcto <> 'PROVISÓRIO'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'
GROUP BY 
	GRP.apelido,Nome_tp_tx, Nome_Local, cta.dc_him,PP.Nome_Raz_Soc, LEFT(JOB_HIM,2),Dt_Ins_him, hou.num_proc_him,cta.cd_tp_tx,cd_consig_him

UNION ALL

Select
	'EM' Modal, 'HOU','VAR' Tipo, Isnull(GRP.apelido,Upper(PP.Nome_Raz_Soc)), Nome_tp_Tx, 
	Nome_Local, cta.dc_hem,sum(dbo.valor(vlr_pgto_rcto_hem,cxa.dc_hem)-IsNull(dbo.valor(vlr_org_hem*isnull(par.par_moeda,1),cta.dc_hem),0)) Valor, month(@DataFinal) Mes , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HEM,2),
	Dt_Ins_hem Dt_Ins, hou.num_proc_hem,cta.cd_tp_tx,cd_export_hem
From
	Caixa_hou_exp_mar CXA
	Join cta_cte_hou_exp_mar CTA on cta.num_proc_hem=cxa.num_proc_hem and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hem
	Join House_exp_mar hou on hou.num_proc_hem=cta.num_proc_hem
	Join Localidade DST on DST.cd_local=cd_org_hem
	Join Pessoa PP on pp.cd_pes=cd_export_hem
	Join Tipo_Taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
	Left Join Paridade PAR on CTA.cd_Tp_MOEDA=PAR.cd_tp_moeda and convert(datetime,dt_ins_Hem,105)=convert(datetime,dt_par,105) and PAR.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hem
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	Convert(Datetime,dt_pgto_Rcto_hem,105) between @DataInicial and @DataFinal 
	and Convert(datetime,dt_pgto_rcto_hem, 105) > convert(datetime,dt_ins_hem,105)
	and month(convert(datetime,dt_pgto_rcto_hem,105))<>month(convert(Datetime,dt_ins_hem,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_hem,105))>=2006
	and num_lcto <> 'PROVISÓRIO'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'
GROUP BY 
	GRP.apelido,Nome_tp_tx, Nome_Local, cta.dc_hem,PP.Nome_Raz_Soc, LEFT(JOB_HEM,2),Dt_Ins_hem, hou.num_proc_hem,cta.cd_tp_tx,cd_export_hem

UNION ALL

Select
	'IA' Modal, 'MAS','VAR' Tipo, Isnull(GRP.apelido,Upper(PP.Nome_Raz_Soc)), Nome_tp_Tx, 
	Nome_Local, cta.dc_Mia,sum(dbo.valor(vlr_pgto_rcto_Mia,cxa.dc_Mia)-IsNull(dbo.valor(VLR_ORG_MIA*Isnull(par.par_moeda,1),cta.dc_Mia),0)*isnull(dbo.sppar_Masc(num_proc_HIA,rateio_tx),1)) Valor, month(@DataFinal) Mes , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HIA,2),
	Dt_Ins_mia Dt_Ins, hou.num_proc_hia,cta.cd_tp_tx,cd_consig_hia
From
	Caixa_MAS_imp_Aer CXA
	Join cta_cte_MAS_imp_aer CTA on cta.num_proc_Mia=cxa.num_proc_Mia and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_Mia=cxa.dc_Mia
	Join House_imp_aer hou on hou.num_proc_Mia=cta.num_proc_Mia
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join Pessoa PP on pp.cd_pes=cd_consig_hia
	Join Tipo_Taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
	Left Join Paridade PAR on CTA.cd_Tp_MOEDA=PAR.cd_tp_moeda and convert(datetime,dt_ins_MIA,105)=convert(datetime,dt_par,105) and PAR.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_hia
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	Convert(Datetime,dt_pgto_Rcto_Mia,105) between @DataInicial and @DataFinal 
	and Convert(datetime,dt_pgto_rcto_Mia, 105) > convert(datetime,dt_ins_Mia,105)
	and month(convert(datetime,dt_pgto_rcto_Mia,105))<>month(convert(Datetime,dt_ins_Mia,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_Mia,105))>=2006
	and num_lcto <> 'PROVISÓRIO'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'
GROUP BY 
	GRP.apelido,Nome_tp_tx, Nome_Local, cta.dc_Mia,PP.Nome_Raz_Soc,LEFT(JOB_HIA,2), Dt_Ins_mia, hou.num_proc_hia,cta.cd_tp_tx,cd_consig_hia

union all

Select
	'IM' Modal, 'MAS','VAR' Tipo, Isnull(GRP.apelido,Upper(PP.Nome_Raz_Soc)), Nome_tp_Tx, 
	Nome_Local, cta.dc_mim,sum(dbo.valor(vlr_pgto_rcto_mim,cxa.dc_mim)-IsNull(dbo.valor(vlr_org_mim*isnull(par.par_moeda,1),cta.dc_mim),0)*isnull(dbo.sppar_Masc(num_proc_him,rateio_tx),1)) Valor, month(@DataFinal) Mes , year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HIM,2),
	Dt_Ins_mim Dt_Ins, hou.num_proc_him,cta.cd_tp_tx,cd_consig_him
From
	Caixa_MAS_imp_mar CXA
	Join cta_cte_MAS_imp_mar CTA on cta.num_proc_mim=cxa.num_proc_mim and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim
	Join House_imp_mar hou on hou.num_proc_mim=cta.num_proc_mim
	Join Localidade DST on DST.cd_local=cd_dst_him
	Join Pessoa PP on pp.cd_pes=cd_CONSIG_him
	Join Tipo_Taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
	Left Join Paridade PAR on CTA.cd_Tp_MOEDA=PAR.cd_tp_moeda and convert(datetime,dt_ins_MIM,105)=convert(datetime,dt_par,105) and PAR.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_consig_him
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	Convert(Datetime,dt_pgto_Rcto_mim,105) between @DataInicial and @DataFinal 
	and Convert(datetime,dt_pgto_rcto_mim, 105) > convert(datetime,dt_ins_mim,105)
	and month(convert(datetime,dt_pgto_rcto_mim,105))<>month(convert(Datetime,dt_ins_mim,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_mim,105))>=2006
	and num_lcto <> 'PROVISÓRIO'
	AND LEFT(CTA.CD_TP_TX,1) <> 'X'

GROUP BY 
	GRP.apelido,Nome_tp_tx, Nome_Local, cta.dc_mim,PP.Nome_Raz_Soc, LEFT(JOB_HIM,2),Dt_Ins_mim, hou.num_proc_him,cta.cd_tp_tx,cd_consig_him

UNION

Select
	'EA' Modal, 'MAS','VAR' Tipo, Isnull(GRP.apelido,Upper(PP.Nome_Raz_Soc)), Nome_tp_Tx, 
	Nome_Local, cta.dc_mea,sum(dbo.valor(vlr_pgto_rcto_mea,cxa.dc_mea)-IsNull(dbo.valor(VLR_ORG_MEA*ISNULL(PAR.PAR_MOEDA,1),cta.dc_mea),0)*isnull(dbo.sppar_Masc(num_proc_hea,rateio_tx),1)) Valor, month(@DataFinal) Mes , year(@DataFinal) Ano,@DataFinal DataFinal, LEFT(JOB_HEA,2),
	Dt_Ins_mea Dt_Ins, hou.num_proc_hea,cta.cd_tp_tx,cd_export_hea
From
	Caixa_MAS_EXP_Aer CXA
	Join cta_cte_MAS_EXP_aer CTA on cta.num_proc_mea=cxa.num_proc_mea and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_mea
	Join House_EXP_aer hou on hou.num_proc_mea=cta.num_proc_mea
	Join Localidade DST on DST.cd_local=cd_org_hea
	Join Pessoa PP on pp.cd_pes=cd_EXPort_hea
	Join Tipo_Taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
	Left Join Paridade PAR on CTA.cd_Tp_MOEDA=PAR.cd_tp_moeda and convert(datetime,dt_ins_MEA,105)=convert(datetime,dt_par,105) and PAR.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hea
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes

Where
	Convert(Datetime,dt_pgto_Rcto_mea,105) between @DataInicial and @DataFinal 
	and Convert(datetime,dt_pgto_rcto_mea, 105) > convert(datetime,dt_ins_mea,105)
	and month(convert(datetime,dt_pgto_rcto_mea,105))<>month(convert(Datetime,dt_ins_mea,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_mea,105))>=2006
	and num_lcto <> 'PROVISÓRIO'
	AND LEFT(CTA.CD_TP_TX,1)<>'X'
GROUP BY 
	GRP.Apelido,Nome_tp_tx, Nome_Local, cta.dc_mea,PP.Nome_Raz_Soc,LEFT(JOB_HEA,2), Dt_Ins_mea, hou.num_proc_hea,cta.cd_tp_Tx,cd_export_hea

union all

Select
	'EM' Modal, 'MAS','VAR' Tipo, Isnull(GRP.Apelido,Upper(PP.Nome_Raz_Soc)), Nome_tp_Tx, 
	Nome_Local, cta.dc_mem,sum(dbo.valor(vlr_pgto_rcto_mem,cxa.dc_mem)-IsNull(dbo.valor(VLR_ORG_MEM*ISNULL(PAR.PAR_MOEDA,1),cta.dc_mem),0)*isnull(dbo.sppar_Masc(num_proc_hem,rateio_tx),1)) Valor, month(@DataFinal) Mes , year(@DataFinal) Ano,@DataFinal DataFinal,LEFT(JOB_HEM,2),
	Dt_Ins_mem Dt_Ins, hou.num_proc_hem,cta.cd_tp_tx,cd_export_hem
From
	Caixa_MAS_EXP_mar CXA
	Join cta_cte_MAS_EXP_mar CTA on cta.num_proc_mem=cxa.num_proc_mem and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem
	Join House_EXP_mar hou on hou.num_proc_mem=cta.num_proc_mem
	Join Localidade DST on DST.cd_local=cd_org_hem
	Join Pessoa PP on pp.cd_pes=cd_EXPort_hem
	Join Tipo_Taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
	Left Join Paridade PAR on CTA.cd_Tp_MOEDA=PAR.cd_tp_moeda and convert(datetime,dt_ins_MEM,105)=convert(datetime,dt_par,105) and PAR.cd_tp_par='OFC'
	Left Join Pessoa_LLP LLP on LLP.cd_pes=cd_export_hem
	Left Join Pessoa GRP on LLP.cd_pes_Grupo=GRP.cd_pes


Where
	Convert(Datetime,dt_pgto_Rcto_mem,105) between @DataInicial and @DataFinal 
	and Convert(datetime,dt_pgto_rcto_mem, 105) > convert(datetime,dt_ins_mem,105)
	and month(convert(datetime,dt_pgto_rcto_mem,105))<>month(convert(Datetime,dt_ins_mem,105))
	and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and year(convert(Datetime,dt_ins_mem,105))>=2006
	and num_lcto <> 'PROVISÓRIO' AND LEFT(CTA.CD_TP_TX,1) <> 'X'
GROUP BY 
	GRP.Apelido,Nome_tp_tx, Nome_Local, cta.dc_mem,pp.Nome_Raz_Soc, LEFT(JOB_HEM,2), Dt_Ins_mem, hou.num_proc_hem,cta.cd_tp_tx,cd_export_hem




GO
