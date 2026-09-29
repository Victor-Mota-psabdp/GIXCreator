SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[spSalesPerfomanceNet1_Sel]-- '%','01-01-2012','01-01-2012'
	
	@DataInicial	Varchar(10),
	@DataFinal		Varchar(10),
@Vendedor		Varchar(40)
as
--Set @DataInicial='12-01-2012'
--Set @DataFinal='12-17-2012'
--Set @Vendedor='Franco Locati'

Select 
	Num_PRoc,GRP.apelido Grupo,PP.apelido,nome_tp_tx,Nome_usuario Vendedor,cta.dc_hia,cast(vlr_org_hia*isnull(Par_Moeda,1) as Decimal(10,2)) Valor
From 
	Job_Imp_Mar With(Nolock)
	Join Usuario US (Nolock) on US.cd_usuario=cd_vendedor
	Join vwcliente C (Nolock) on C.num_proc=num_proc_him
	Join vwcta_cte cta (Nolock) on cta.num_proc_hia=c.num_proc
	Join Tipo_Taxa TT (Nolock) on tt.cd_tp_Tx=cta.cd_tp_Tx
	Join Pessoa_LLP P (Nolock) on P.cd_pes=cd_cliente
	Join Pessoa PP (Nolock) on pp.cd_pes=cd_cliente
	Join Pessoa GRP (Nolock) on grp.cd_pes=cd_pes_grupo

	Left Join Paridade PAR (Nolock) on CTA.Cd_TP_Moeda=PAR.Cd_TP_Moeda and PAR.Cd_TP_PAR='OFC' and Convert(Datetime,dt_par,105)=data
Where
	left(TT.cd_Tp_Tx,1) <> 'X' 
	and nome_tp_Tx not like '%Demurrage%'
	and Data between @DataInicial and @DataFinal
	and (Nome_Usuario=@vendedor or @Vendedor='')
	And Desp_org_hia='N'
Union All


Select 
	Num_PRoc,GRP.apelido Grupo,PP.apelido,nome_tp_tx,Nome_usuario Vendedor,cta.dc_hia,cast(vlr_org_hia*isnull(Par_Moeda,1) as Decimal(10,2))*dbo.spPar_Mas(Num_Proc)
From 
	Job_Imp_Mar With(Nolock)
	Join Usuario US (Nolock) on US.cd_usuario=cd_vendedor
	Join vwcliente C (Nolock) on C.num_proc=num_proc_him
	Join vwcta_cte cta (Nolock) on cta.num_proc_hia=master 
	Join Tipo_Taxa TT (Nolock) on tt.cd_tp_Tx=cta.cd_tp_Tx
	Join Pessoa_LLP P (Nolock) on P.cd_pes=cd_cliente
	Join Pessoa PP (Nolock) on pp.cd_pes=cd_cliente
	Join Pessoa GRP (Nolock) on grp.cd_pes=cd_pes_grupo
	Left Join Paridade PAR (Nolock) on CTA.Cd_TP_Moeda=PAR.Cd_TP_Moeda and PAR.Cd_TP_PAR='OFC' and Convert(Datetime,dt_par,105)=data
Where
	left(TT.cd_Tp_Tx,1) <> 'X' 
	and nome_tp_Tx not like '%Demurrage%'
	and Data between @DataInicial and @DataFinal
	and (Nome_Usuario=@vendedor or @Vendedor='')
	and master <> 'JOB'
	And Desp_org_hia='N'
	
	
Union All


Select 
	Num_PRoc,GRP.apelido Grupo,PP.apelido,nome_tp_tx,Nome_usuario Vendedor,cta.dc_hia,cast(vlr_org_hia*isnull(Par_Moeda,1) as Decimal(10,2)) Valor
From 
	Job_Imp_aer With(Nolock)
	Join Usuario US (Nolock) on US.cd_usuario=cd_vendedor
	Join vwcliente C (Nolock) on C.num_proc=num_proc_hia
	Join vwcta_cte cta (Nolock) on cta.num_proc_hia=c.num_proc
	Join Tipo_Taxa TT (Nolock) on tt.cd_tp_Tx=cta.cd_tp_Tx
	Join Pessoa_LLP P (Nolock) on P.cd_pes=cd_cliente
	Join Pessoa PP (Nolock) on pp.cd_pes=cd_cliente
	Join Pessoa GRP (Nolock) on grp.cd_pes=cd_pes_grupo

	Left Join Paridade PAR (Nolock) on CTA.Cd_TP_Moeda=PAR.Cd_TP_Moeda and PAR.Cd_TP_PAR='OFC' and Convert(Datetime,dt_par,105)=data
Where
	left(TT.cd_Tp_Tx,1) <> 'X' 
	and nome_tp_Tx not like '%Demurrage%'
	and Data between @DataInicial and @DataFinal
	and (Nome_Usuario=@vendedor or @Vendedor='')
	And Desp_org_hia='N'
Union All


Select 
	Num_PRoc,GRP.apelido Grupo,PP.apelido,nome_tp_tx,Nome_usuario Vendedor,cta.dc_hia,cast(vlr_org_hia*isnull(Par_Moeda,1) as Decimal(10,2))*dbo.spPar_Mas(Num_Proc)
From 
	Job_Imp_aer With(Nolock)
	Join Usuario US (Nolock) on US.cd_usuario=cd_vendedor
	Join vwcliente C (Nolock) on C.num_proc=num_proc_hia
	Join vwcta_cte cta (Nolock) on cta.num_proc_hia=master 
	Join Tipo_Taxa TT (Nolock) on tt.cd_tp_Tx=cta.cd_tp_Tx
	Join Pessoa_LLP P (Nolock) on P.cd_pes=cd_cliente
	Join Pessoa PP (Nolock) on pp.cd_pes=cd_cliente
	Join Pessoa GRP (Nolock) on grp.cd_pes=cd_pes_grupo
	Left Join Paridade PAR (Nolock) on CTA.Cd_TP_Moeda=PAR.Cd_TP_Moeda and PAR.Cd_TP_PAR='OFC' and Convert(Datetime,dt_par,105)=data
Where
	left(TT.cd_Tp_Tx,1) <> 'X' 
	and nome_tp_Tx not like '%Demurrage%'
	and Data between @DataInicial and @DataFinal
	and (Nome_Usuario=@vendedor or @Vendedor='')
	and master <> 'JOB'
	And Desp_org_hia='N'

Union All

Select 
	Num_PRoc,GRP.apelido Grupo,PP.apelido,nome_tp_tx,Nome_usuario Vendedor,cta.dc_hia,cast(vlr_org_hia*isnull(Par_Moeda,1) as Decimal(10,2)) Valor
From 
	Job_exp_Mar With(Nolock)
	Join Usuario US (Nolock) on US.cd_usuario=cd_vendedor
	Join vwcliente C (Nolock) on C.num_proc=num_proc_hem
	Join vwcta_cte cta (Nolock) on cta.num_proc_hia=c.num_proc
	Join Tipo_Taxa TT (Nolock) on tt.cd_tp_Tx=cta.cd_tp_Tx
	Join Pessoa_LLP P (Nolock) on P.cd_pes=cd_cliente
	Join Pessoa PP (Nolock) on pp.cd_pes=cd_cliente
	Join Pessoa GRP (Nolock) on grp.cd_pes=cd_pes_grupo

	Left Join Paridade PAR (Nolock) on CTA.Cd_TP_Moeda=PAR.Cd_TP_Moeda and PAR.Cd_TP_PAR='OFC' and Convert(Datetime,dt_par,105)=data
Where
	left(TT.cd_Tp_Tx,1) <> 'X' 
	and nome_tp_Tx not like '%Demurrage%'
	and Data between @DataInicial and @DataFinal
	and (Nome_Usuario=@vendedor or @Vendedor='')
	And Desp_org_hia='N'
Union All


Select 
	Num_PRoc,GRP.apelido Grupo,PP.apelido,nome_tp_tx,Nome_usuario Vendedor,cta.dc_hia,cast(vlr_org_hia*isnull(Par_Moeda,1) as Decimal(10,2))*dbo.spPar_Mas(Num_Proc)
From 
	Job_exp_Mar With(Nolock)
	Join Usuario US (Nolock) on US.cd_usuario=cd_vendedor
	Join vwcliente C (Nolock) on C.num_proc=num_proc_hem
	Join vwcta_cte cta (Nolock) on cta.num_proc_hia=master 
	Join Tipo_Taxa TT (Nolock) on tt.cd_tp_Tx=cta.cd_tp_Tx
	Join Pessoa_LLP P (Nolock) on P.cd_pes=cd_cliente
	Join Pessoa PP (Nolock) on pp.cd_pes=cd_cliente
	Join Pessoa GRP (Nolock) on grp.cd_pes=cd_pes_grupo
	Left Join Paridade PAR (Nolock) on CTA.Cd_TP_Moeda=PAR.Cd_TP_Moeda and PAR.Cd_TP_PAR='OFC' and Convert(Datetime,dt_par,105)=data
Where
	left(TT.cd_Tp_Tx,1) <> 'X' 
	and nome_tp_Tx not like '%Demurrage%'
	and Data between @DataInicial and @DataFinal
	and (Nome_Usuario=@vendedor or @Vendedor='')
	and master <> 'JOB'
	And Desp_org_hia='N'

Union all

Select 
	Num_PRoc,GRP.apelido Grupo,PP.apelido,nome_tp_tx,Nome_usuario Vendedor,cta.dc_hia,cast(vlr_org_hia*isnull(Par_Moeda,1) as Decimal(10,2)) Valor
From 
	Job_exp_aer With(Nolock)
	Join Usuario US (Nolock) on US.cd_usuario=cd_vendedor
	Join vwcliente C (Nolock) on C.num_proc=num_proc_hea
	Join vwcta_cte cta (Nolock) on cta.num_proc_hia=c.num_proc
	Join Tipo_Taxa TT (Nolock) on tt.cd_tp_Tx=cta.cd_tp_Tx
	Join Pessoa_LLP P (Nolock) on P.cd_pes=cd_cliente
	Join Pessoa PP (Nolock) on pp.cd_pes=cd_cliente
	Join Pessoa GRP (Nolock) on grp.cd_pes=cd_pes_grupo

	Left Join Paridade PAR (Nolock) on CTA.Cd_TP_Moeda=PAR.Cd_TP_Moeda and PAR.Cd_TP_PAR='OFC' and Convert(Datetime,dt_par,105)=data
Where
	left(TT.cd_Tp_Tx,1) <> 'X' 
	and nome_tp_Tx not like '%Demurrage%'
	and Data between @DataInicial and @DataFinal
	and (Nome_Usuario=@vendedor or @Vendedor='')
	And Desp_org_hia='N'
Union All


Select 
	Num_PRoc,GRP.apelido Grupo,PP.apelido,nome_tp_tx,Nome_usuario Vendedor,cta.dc_hia,cast(vlr_org_hia*isnull(Par_Moeda,1) as Decimal(10,2))*dbo.spPar_Mas(Num_Proc)
From 
	Job_exp_aer With(Nolock)
	Join Usuario US (Nolock) on US.cd_usuario=cd_vendedor
	Join vwcliente C (Nolock) on C.num_proc=num_proc_hea
	Join vwcta_cte cta (Nolock) on cta.num_proc_hia=master 
	Join Tipo_Taxa TT (Nolock) on tt.cd_tp_Tx=cta.cd_tp_Tx
	Join Pessoa_LLP P (Nolock) on P.cd_pes=cd_cliente
	Join Pessoa PP (Nolock) on pp.cd_pes=cd_cliente
	Join Pessoa GRP (Nolock) on grp.cd_pes=cd_pes_grupo
	Left Join Paridade PAR (Nolock) on CTA.Cd_TP_Moeda=PAR.Cd_TP_Moeda and PAR.Cd_TP_PAR='OFC' and Convert(Datetime,dt_par,105)=data
Where
	left(TT.cd_Tp_Tx,1) <> 'X' 
	and nome_tp_Tx not like '%Demurrage%'
	and Data between @DataInicial and @DataFinal
	and (Nome_Usuario=@vendedor or @Vendedor='')
	and master <> 'JOB'
	And Desp_org_hia='N'
GO
