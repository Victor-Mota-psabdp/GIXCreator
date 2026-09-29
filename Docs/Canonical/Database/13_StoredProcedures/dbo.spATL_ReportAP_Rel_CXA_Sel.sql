SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--13-09-13-Siberio solicitou pra retirar a regra de Fatura, de só epgar casos q nao tinham fatura
--incluir o numero da remessa
--06-12 incluido nome taxa
--Erbson 24-06-2015 - Incluido o AX DOC
--[spATL_ReportAP_Rel_CXA_Sel]'2014-08-01','2014-08-10'
CREATE Procedure [dbo].[spATL_ReportAP_Rel_CXA_Sel]
	@DataInicial	Datetime,
	@DataFinal		Datetime
AS

Declare @Table Table
	(
	
		[BDP Ref.] Varchar(16),
		[Vendor Code] Varchar(10),
		[Vendor Name] Varchar(60),
		[Issued Dt] Datetime,
		[Due Dt]	Datetime,
		[Currency]	Varchar(3),
		[Value]		Decimal(10,2),
		[BRL Value]	Decimal(10,2),
		[Payment Value] Decimal(10,2),
		[LA]		varchar(30),
		[Payment Dt] varchar(10),
--		[N. Days]	Int,
--		[Range]		Varchar(50),
		[AX Code]	varchar(5),
		[NF]		varchar(30),
		[DN Number]	varchar(17),
		[Name TX]	varchar(50),
		[AX DOC]	bigint			
	)

Declare @Fatura Table
		(
			Fatcod		varchar(17),
			Num_proc	varchar(16),
			Cd_tp_Tx	Varchar(3),
			DC			Varchar(1)
		)
	Begin 		
		Insert @Fatura		
			Select i.fatcod,(case when len(i.fatcod)= 15 then left(i.fatcod,14) else	left(i.fatcod,16) end),	
			cd_tp_Tx,dc from item_fat I with(nolock)				
				Join Fatura F with(nolock) on F.fatcod=i.fatcod 
			where
				fatdtEmissao >='01-01-2013' and fatstatus =1
	End		


insert @table

select 
	Cta.num_proc_hia [BDP Ref.],
	PP.cd_pes [Vendor Code],
	nome_Raz_soc [Vendor Name],
	convert(Datetime,dt_ins_hia,105) [Issued Dt],
	convert(datetime,dt_prev_pgto_hia,105) [Due Dt] ,
	cd_tp_moeda [Currency],
	--dbo.valor(Vlr_org_hia,cta.dc_hia) [Value],
	dbo.valor(cxa.Vlr_ref_HIA,cxa.dc_hia)[Value],
	--dbo.valor(Vlr_org_hia,cta.dc_hia) * [dbo].[VerParidade](dt_prev_pgto_hia,cd_tp_moeda,'OFC') [BRL Value],
	dbo.valor(cxa.Vlr_ref_HIA,cxa.dc_hia) * [dbo].[VerParidade](convert(varchar(10),dt_prev_pgto_hia,103),cd_tp_moeda,'OFC')  [BRL Value],	
	dbo.valor(cxa.vlr_pgto_rcto_hia,cxa.dc_hia)	[Payment Value],
	(case when num_lcto = 'REMESSA' then
			num_rcb_hia
	else
		num_lcto end)[LA],
	CXA.DT_PGTO_RCTO_HIA [Payment Dt],
--	cast(getdate()-convert(datetime,dt_prev_pgto_hia,105) as int),
--	Null,
	AX.cd_ax,
	Num_NF_Hia,
	FAT.fatcod,
	TT.nome_tp_tx,
	AD.id_Ax [AX_DOC]	
from 
	vwcta_cte cta with(nolock)
	Join vwcxas CXA with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia --and convert(Datetime,dt_pgto_Rcto_hia,105) <=@Data
	join tipo_taxa TT with(nolock) on TT.cd_tp_tx = CTA.cd_tp_tx
	Left Join @Fatura FAt  on fat.num_proc=cta.num_proc_hia and FAt.cd_tp_tx=cta.cd_tp_Tx and fat.dc=cta.dc_hia
	Left Join vwcliente C with(nolock) on c.num_proc=cta.num_proc_hia
	Join Pessoa PP with(nolock) on pp.cd_pes=cd_cred_dev_hia
	Left Join Pessoa_LLP P with(nolock) on P.cd_pes=pp.cd_pes 
	Left Join Pessoa_ATL_AX AX with(nolock) on (
	PP.cd_tp_ativ <> 'AGT' and 
	AX.Cd_Pes = PP.Cd_Pes 
	or 	PP.cd_tp_Ativ='AGT' and left(ax.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes
	) and AX.Tipo='F'	
	Left Join vwAXDocs AD with(nolock) on Cta.Num_Proc_HIA = AD.num_proc and Cta.Cd_Tp_Tx = AD.cd_tp_tx_Atl and Cta.DC_HIA = AD.dc 
where 
	(cd_pes_grupo is null or cd_tp_Ativ='AGT') and 
	cxa.num_lcto is not null
	and desp_org_hia='N'
	and cta.dc_hia = 'D' 
	--and left(cta.cd_tp_tx,1)<>'X' --- 16/9/13 - siberio --17/09/13 - recolocado por Anderson -- retirado 06-12 cadu
	and cd_Cred_dev_hia <> cd_cliente   
	and convert(datetime,dt_Pgto_Rcto_hia,105) between @DataInicial and @DataFinal
	and vlr_org_hia >0
--	and Fat.num_proc is null


--Update @Table
--		set [Range]=
--				(
--					Case
--						When  [N. Days]<= 30 then '30Days'
--						When  [N. Days]<= 60 then '60Days'
--						When  [N. Days]<= 90 then '90Days'
--						When  [N. Days]<= 120 then '120Days'
--						else 'More than 120 days'
--					ENd
--					)						


Update @Table
	set Currency='BRL'
where
	Currency='REL'

select 
	[BDP Ref.],
	[Vendor Code],
	[Vendor Name],
	[AX Code],
	[DN Number],
	[LA],
	[Payment Dt],
--	Vencimento									[Due Dt],
	[Currency],
	[Value],
	[BRL Value],
	[Payment Value],
	[Name TX],
	[AX DOC]
from
	@table

GO
