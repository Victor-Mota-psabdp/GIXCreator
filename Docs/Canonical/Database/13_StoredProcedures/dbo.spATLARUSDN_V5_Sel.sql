SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[spATLARUSDN_V5_Teste_Sel] 'GRUPO ALL','','2020-11-24','2020-11-24'

--[dbo].[spATLARUSDN_V5_Teste_Sel] 'GRUPO DOW','','2020-08-13','2020-08-13'
CREATE  Procedure [dbo].[spATLARUSDN_V5_Sel]
	@Group			varchar(50),
	@Customer_Name varchar(50),	
	@DataInicial	Datetime,
	@DataFinal		Datetime
	
	
as

if @Customer_Name = '' or @Customer_Name = ' ALL'
	set @Customer_Name = '%'
	
--if @Group = '' or @Group = 'GRUPO ALL'
--	set @Group = '%'

Declare @Fatura Table
		(
			Fatcod		varchar(17),
			Num_proc	varchar(16),
			Cd_tp_Tx	Varchar(3),
			DC			Varchar(1),
			cd_pes		varchar(10),
			fatdtemissao datetime,
			fatdtvenc	datetime,
			vlr_org		Decimal (10,2),
			vlr_rs		Decimal (10,2),	
			paridade	float,
			cd_tp_moeda	Varchar(3)	
			,IDFAT		VARCHAR(8)
		)
	Begin 		
		Insert @Fatura	
			/*
			Select i.fatcod,(case when len(i.fatcod)= 15 then left(i.fatcod,14) else left(i.fatcod,16) end) ,	
			cd_tp_Tx,dc,cd_pes,fatdtemissao,fatdtvenc,vlr_org,vlr_rs,paridade,cd_tp_moeda from item_fat I with(nolock)				
				inner hash Join  Fatura F with(nolock) on F.fatcod=i.fatcod 
			where
				--i.fatcod = 'EMSEL201304001BRA' and 
				--fatdtEmissao >='2013-01-01' and fatstatus =1
				fatdtEmissao between '215-01-01' and @DataFinal and fatstatus =1
				 --fatdtEmissao between  '2013-01-01' and @DataFinal and fatstatus =1
				print 1
			*/
			select 
			fat.FatCod
			,fat.Num_Proc
			,fat.Cd_Tp_Tx
			,fat.DC
			,fat.Cd_Pes_Fat
			,fat.fatdtemissao
			,fat.fatdtvenc
			,fat.vlr_org
			,fat.vlr_rs
			,fat.paridade
			,fat.cd_tp_moeda 
			,NF.NUMERO_FAT AS IDFAT
			from vwFaturasValidas fat (nolock)
			left join NF_Fatura_Item NFI
				on FAT.num_proc=NFI.Num_Proc 
				and FAT.cd_tp_Tx=NFI.cd_tp_tx 
				and FAT.dc=NFI.DC 
			LEFT JOIN NF_FATURA NF ON 
				NFI.ID  = NF.ID

			where convert(date,fatdtEmissao) between @DataInicial and @DataFinal
			--AND FAT.NUM_PROC = 'IMATL202011133BR'

				
	End	

Declare @TaxasEmAberto Table
(
	Nome_Raz_Soc Varchar(100),
	Endereco Varchar(500),
	Fatura	Varchar(17),
	Apelido	Varchar(50),
	CNPJ varchar(50),
	Num_proc	Varchar(16),
	Vencimento Datetime,
	Taxa		Varchar(60),
	DC			Char(1),
	Moeda		Varchar(3),
	Vlr_Org		Decimal (10,2),
	Vlr_Org_RS	Decimal(10,2),
	Range_Fluxo	Varchar(40),
	Cd_PEs		Varchar(10),
	Dt_Emis		Datetime,
	cd_ax		varchar(5),
	paridade	float,
	cd_tp_tx	Varchar(3),
	AX_DOC		bigint,
	Nota_Fiscal	varchar(25),
	RPS			varchar(25),
	IC			bigint 
	,IDFAT		VARCHAR(8)
)

Insert @TaxasEmAberto (Nome_Raz_Soc,Endereco,Fatura,Apelido,CNPJ,Num_proc,vencimento,taxa,dc,moeda,Vlr_Org,Vlr_Org_RS,
			cd_pes,dt_emis,cd_ax,paridade,cd_tp_tx,AX_DOC,Nota_Fiscal,RPS,IC,IDFAT)
			
Select 
	PP.Nome_Raz_Soc,
	Rua +' ' + isnull(numero,'') + ' - ' + isnull(Cidade,'Nao Informada') + ' - ' + isnull(UF,'')  + 'CEP:' + isnull(CEP,''),
	FAT.fatcod,
	--isnull(GRP.apelido,PP.Apelido),
	GRP.apelido,
	PP.Num_CPF_CNPJ,
	CTA.num_proc_hia,
	FAT.fatdtvenc,
	Nome_TP_TX Taxa,
	--cta.dc_hia,
	FAT.DC,
	--cta.cd_Tp_moeda Moeda,
	FAT.cd_tp_moeda ,
	--Vlr_ORg_HIA,
	abs(FAT.Vlr_ORG),
	--0,
	abs(FAT.vlr_RS),
	FAT.Cd_Pes, 
	FAT.fatdtemissao,
	AX.cd_ax,
	FAT.Paridade,
	FAT.Cd_tp_Tx,
	AD.id_Ax,
	BA.RPS_NFE,
	CTA.Num_NF_HIA,
	CTA.IC
	,FAT.IDFAT
From
	@Fatura FAt
	Join vwCliente CL with(nolock) on cL.num_proc=fat.num_proc
	inner hash  Join Tipo_Taxa			TT with(nolock) on TT.cd_tp_Tx=FAT.cd_tp_tx and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1') 
	inner hash Join PEssoa				PP with(nolock) on PP.cd_pes=FAT.cd_pes	
	--ALTERADO POR ANDERSON 12/12/2013 - NAO é NECESSARIO MAIS, FoI REvisado para nao precisar... Left Join Pessoa_ATL_AX AX on (PP.cd_tp_ativ <> 'AGT' and AX.Cd_Pes = PP.Cd_Pes or PP.cd_tp_Ativ='AGT' and left(ax.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes) and AX.Tipo='C'
	Left hash Join Pessoa_ATL_AX AX on AX.Cd_Pes = PP.Cd_Pes and AX.Tipo='C'
	Left hash Join Endereco		ED with(nolock) on PP.cd_pes=ed.cD_pes and cd_tp_end='COM'	
	Left hash Join Pessoa_LLP	PLLP With(Nolock)  on PLLP.cd_pes=FAT.cd_pes
	Left hash Join Pessoa		GRP with(nolock) on GRP.cd_pes=cd_pes_Grupo --and GRP.cd_pes <> 'GRATL'
	inner hash Join vwcta_cte cta with(nolock) on cta.num_proc_hia=Fat.num_proc and fat.cd_tp_tx=cta.cd_Tp_tx and fat.dc=cta.dc_hia
	Left hash Join vwcxas CXA with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_Tp_Tx and cta.dc_hia=cxa.dc_hia and convert(datetime,dt_pgto_Rcto_hia,105)<=convert(datetime,@DataFinal,105)
	Left hash Join vwAXDocs AD with(nolock) on Cta.Num_Proc_HIA = AD.num_proc and Cta.Cd_Tp_Tx = AD.cd_tp_tx_Atl and Cta.DC_HIA = AD.dc 
	left hash join Base_Nota_Fiscal BA  with(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIA and BA.Ref_Acesso = CTA.Ref_Acesso_NF_HIA		
where
	cxa.num_Lcto is null
	and desp_org_hia='N'
	and convert(date,fatdtemissao) between @DataInicial and @DataFinal
	and vlr_org_hia >0
	and PP.Nome_Raz_Soc like @Customer_Name	
	and (GRP.Apelido = @Group or @Group = 'GRUPO ALL') 
	
	
union all

Select 
	PP.Nome_Raz_Soc,
	Rua +' ' + isnull(numero,'') + ' - ' + isnull(Cidade,'Nao Informada') + ' - ' + isnull(UF,'')  + 'CEP:' + isnull(CEP,''),
	FAT.fatcod,
	--isnull(GRP.apelido,PP.Apelido),
	GRP.apelido,
	PP.Num_CPF_CNPJ,
	CL.num_proc,
	FAT.fatdtvenc,
	Nome_TP_TX Taxa,
	--cta.dc_hia,
	FAT.DC,
	--cta.cd_Tp_moeda Moeda,
	FAT.cd_tp_moeda ,
	--Vlr_ORg_HIA,
	--abs(FAT.Vlr_ORG),
	cast(abs(FAT.Vlr_ORG) * [dbo].[spRateio_Mas](CL.num_proc) as Decimal(10,2)),
	--0,
	--abs(FAT.vlr_RS),
	cast(abs(FAT.vlr_RS) * [dbo].[spRateio_Mas](CL.num_proc) as Decimal(10,2)),
	FAT.Cd_Pes, 
	FAT.fatdtemissao,
	AX.cd_ax,
	FAT.Paridade,
	FAT.Cd_tp_Tx,
	AD.id_Ax,
	BA.RPS_NFE,
	CTA.Num_NF_HIA,
	CTA.IC	
	,FAT.IDFAT 
From
	@Fatura FAt
	Join vwCliente CL with(nolock) on cL.Master=fat.num_proc
	inner hash  Join Tipo_Taxa			TT with(nolock) on TT.cd_tp_Tx=FAT.cd_tp_tx and (TT.cd_ax_Resultado <> '000.1' or Cd_AX_Repasse <> '000.1') 
	inner hash Join PEssoa				PP with(nolock) on PP.cd_pes=FAT.cd_pes	
	--ALTERADO POR ANDERSON 12/12/2013 - NAO é NECESSARIO MAIS, FoI REvisado para nao precisar... Left Join Pessoa_ATL_AX AX on (PP.cd_tp_ativ <> 'AGT' and AX.Cd_Pes = PP.Cd_Pes or PP.cd_tp_Ativ='AGT' and left(ax.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes) and AX.Tipo='C'
	Left hash Join Pessoa_ATL_AX AX on AX.Cd_Pes = PP.Cd_Pes and AX.Tipo='C'
	Left hash Join Endereco		ED with(nolock) on PP.cd_pes=ed.cD_pes and cd_tp_end='COM'	
	Left hash Join Pessoa_LLP	PLLP With(Nolock)  on PLLP.cd_pes=FAT.cd_pes
	Left hash Join Pessoa		GRP with(nolock) on GRP.cd_pes=cd_pes_Grupo --and GRP.cd_pes <> 'GRATL'
	inner hash Join vwcta_cte cta with(nolock) on cta.num_proc_hia=Fat.num_proc and fat.cd_tp_tx=cta.cd_Tp_tx and fat.dc=cta.dc_hia
	Left hash Join vwcxas CXA with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_Tp_Tx and cta.dc_hia=cxa.dc_hia and convert(datetime,dt_pgto_Rcto_hia,105)<=convert(datetime,@DataFinal,105)
	Left hash Join vwAXDocs AD with(nolock) on Cta.Num_Proc_HIA = AD.num_proc and Cta.Cd_Tp_Tx = AD.cd_tp_tx_Atl and Cta.DC_HIA = AD.dc 
	left hash join Base_Nota_Fiscal BA  with(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIA and BA.Ref_Acesso = CTA.Ref_Acesso_NF_HIA		
where
	cxa.num_Lcto is null
	and desp_org_hia='N'
	and convert(date,fatdtemissao) between @DataInicial and @DataFinal
	and vlr_org_hia >0
	and PP.Nome_Raz_Soc like @Customer_Name	
	and (GRP.Apelido = @Group or @Group = 'GRUPO ALL') 
	and GRP.apelido like @Group
	print 2
	
--Update @TaxasEmAberto
--	--SEt vlr_org_rs=Vlr_ORg* [dbo].[FConverterMoeda](Moeda,'REL')
--	SEt vlr_org_rs= Vlr_Org * paridade
	--where paridade is not null

Update @TaxasEmAberto
	Set Range_Fluxo=
		(
			Case
				When Getdate()-vencimento <= 30 Then '30 Days'
				When Getdate()-vencimento <=60 then '60 Days'
				When getdate()-vencimento <=90 then '90 Days'
				When getdate() - vencimento <=120 then '120 Days'
				else 'More than 120 Days'
			End
		)	

update @TaxasEmAberto set moeda='BRL'
where moeda='REL'

select 
	T.num_proc [BDP Ref.],
	dbo.fBusca_TipoDocCliente('N',T.num_proc,1) [Customer Reference],
	T.Cd_Pes [Customer Code],
	T.CNPJ [CNPJ],
	T.cd_ax		[AX Code],
	T.Nome_Raz_Soc [Customer Name],
	--Fatura [DN Number],
	T.Fatura + '.' + T.cd_tp_tx + '.' + T.dc [DN Number],
	T.IDFAT [Invoice Number], -- Kaique
	--B.cd_boleto		[Boleto Number],
	T.Dt_Emis	[Invoice Dt],
	T.Vencimento [Due Dt],
	T.Moeda	[Currency],
	T.Taxa [Charge Name],
	sum(dbo.valor(T.Vlr_Org,T.dc)) [Value],
	sum(isnull(dbo.valor(T.Vlr_Org_RS,T.dc),dbo.FConverterMoeda(T.Moeda,'REL')*dbo.valor(T.Vlr_Org_RS,T.dc))) [BRL Value],
--	sum(isnull(Vlr_Org_RS,[dbo].[VerParidade](Dt_Emis,Moeda,'OFC') * Vlr_Org)) [BRL Value],
	--sum(isnull(dbo.valor(Vlr_Org_RS,dc),[dbo].[VerParidade](Dt_Emis,Moeda,'OFC') * Vlr_Org)) [BRL Value],
	T.Range_Fluxo [Range],
	T.AX_DOC [AX DOC],
	T.Nota_Fiscal [NFe Number],
	T.RPS			[RPS Number],
	dbo.fBusca_TipoDocCliente('N',T.num_proc,9) [Customer PO],
	dbo.fBusca_TipoDocCliente('N',T.num_proc,3) [Sales Order],
	dbo.fBusca_TipoDocCliente('N',T.num_proc,25) [URN],
	T.Apelido [Group name],
	[dbo].[fBusca_HistoricoDescr](T.num_proc,95,GETDATE()) [Comments filed for Ar follow up purposes],
	T.IC IC_Number
	,B.cd_boleto		[Boleto Number]
from 
	@TaxasEmAberto T
	left join Boleto B on B.FatCod = CONVERT(VARCHAR(17),T.IDFAT)
	
	
Group by T.num_proc,T.moeda,T.range_fluxo,T.cd_pes,T.nome_raz_soc,T.dt_emis,T.vencimento,T.taxa,T.cd_ax,
T.Fatura,T.dc,T.cd_tp_tx,T.AX_DOC,T.Nota_Fiscal,T.Apelido,T.RPS,T.IC,T.CNPJ
,B.cd_boleto, T.IDFAT

	--SELECT * FROM @TaxasEmAberto
--option (Hash join)


GO
