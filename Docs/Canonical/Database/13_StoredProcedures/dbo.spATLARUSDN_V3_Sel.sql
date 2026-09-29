SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[spATLARUSDN_V3_Sel] '','','2015-01-01','2015-01-05'
CREATE  Procedure [dbo].[spATLARUSDN_V3_Sel]
	@Group			varchar(50),
	@Customer_Name varchar(50),	
	@DataInicial	Datetime,
	@DataFinal		Datetime
	
	
as

if @Customer_Name = '' or @Customer_Name = ' ALL'
	set @Customer_Name = '%'
	
if @Group = '' or @Group = 'GRUPO ALL'
	set @Group = '%'

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
			select FatCod,Num_Proc,Cd_Tp_Tx,DC,Cd_Pes_Fat,fatdtemissao,fatdtvenc,vlr_org,vlr_rs,paridade,cd_tp_moeda from vwFaturasValidas with(nolock)
				where fatdtEmissao between @DataInicial and @DataFinal

				
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
)

Insert @TaxasEmAberto (Nome_Raz_Soc,Endereco,Fatura,Apelido,CNPJ,Num_proc,vencimento,taxa,dc,moeda,Vlr_Org,Vlr_Org_RS,
			cd_pes,dt_emis,cd_ax,paridade,cd_tp_tx,AX_DOC,Nota_Fiscal,RPS,IC)
			
Select 
	PP.Nome_Raz_Soc,
	Rua +' ' + isnull(numero,'') + ' - ' + isnull(Cidade,'Nao Informada') + ' - ' + isnull(UF,'')  + 'CEP:' + isnull(CEP,''),
	FAT.fatcod,
	isnull(GRP.apelido,PP.Apelido),
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
From
	@Fatura FAt
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
	and fatdtemissao between @DataInicial and @DataFinal
	and vlr_org_hia >0
	and PP.Nome_Raz_Soc like @Customer_Name	
	and GRP.apelido like @Group
	--print 2
	
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
	num_proc [BDP Ref.],
	dbo.fBusca_TipoDocCliente('N',num_proc,1) [Customer Reference],
	Cd_Pes [Customer Code],
	CNPJ [CNPJ],
	cd_ax		[AX Code],
	Nome_Raz_Soc [Customer Name],
	--Fatura [DN Number],
	Fatura + '.' + cd_tp_tx + '.' + dc [DN Number],
	Dt_Emis	[Invoice Dt],
	Vencimento [Due Dt],
	Moeda	[Currency],
	Taxa [Charge Name],
	sum(dbo.valor(Vlr_Org,dc)) [Value],
	sum(isnull(dbo.valor(Vlr_Org_RS,dc),dbo.FConverterMoeda(Moeda,'REL')*dbo.valor(Vlr_Org_RS,dc))) [BRL Value],
--	sum(isnull(Vlr_Org_RS,[dbo].[VerParidade](Dt_Emis,Moeda,'OFC') * Vlr_Org)) [BRL Value],
	--sum(isnull(dbo.valor(Vlr_Org_RS,dc),[dbo].[VerParidade](Dt_Emis,Moeda,'OFC') * Vlr_Org)) [BRL Value],
	Range_Fluxo [Range],
	AX_DOC [AX DOC],
	Nota_Fiscal [NFe Number],
	RPS			[RPS Number],
	dbo.fBusca_TipoDocCliente('N',num_proc,9) [Customer PO],
	dbo.fBusca_TipoDocCliente('N',num_proc,3) [Sales Order],
	Apelido [Group name],
	[dbo].[fBusca_HistoricoDescr](num_proc,95,GETDATE()) [Comments filed for Ar follow up purposes],
	IC IC_Number
from 
	@TaxasEmAberto
Group by num_proc,moeda,range_fluxo,cd_pes,nome_raz_soc,dt_emis,vencimento,taxa,cd_ax,Fatura,dc,cd_tp_tx,
AX_DOC,Nota_Fiscal,Apelido,RPS,IC,CNPJ
--option (Hash join)


GO
