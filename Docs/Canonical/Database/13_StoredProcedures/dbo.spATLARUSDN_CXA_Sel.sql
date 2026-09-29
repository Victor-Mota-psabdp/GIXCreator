SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from vwcxas where num_proc_hia = 'IOOXT201304003BR'
---Alterado por Erbson 29/06/2015 - Add Campo ID_AX
CREATE  Procedure [dbo].[spATLARUSDN_CXA_Sel]--[dbo].[spATLARUSDN_CXA_Sel] '2013-08-01','2013-08-30'
	@DataInicial	Datetime,
	@DataFinal		Datetime
as

Declare @FaturaDET Table
	(
	
		FaturaEnc Varchar(17)
	)

Declare @Fatura Table
		(
			Fatcod		varchar(20),
			Num_proc	varchar(20),
			Cd_tp_Tx	Varchar(3),
			DC			Varchar(1),
			cd_pes		varchar(10),
			fatdtemissao datetime,
			fatdtvenc	datetime,
			cd_tp_moeda varchar(6),
			Vlr_ORg_fat decimal(18,2)	,
			Cod_Int_Moeda Varchar(4)		
		)
		
	Begin 		
		Insert @Fatura		
			Select i.fatcod,(case when len(i.fatcod)= 15 then left(i.fatcod,14) else left(i.fatcod,16) end) ,	
			cd_tp_Tx,dc,cd_pes,fatdtemissao,fatdtvenc,I.cd_tp_moeda,vlr_org,cod_int_Moeda from item_fat I with(nolock)				
				Join Fatura F with(nolock) on F.fatcod=i.fatcod 
				join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=i.cd_tp_moeda
			where
				fatdtEmissao >='2010-01-01' and fatstatus =1
	End	
	
	insert  @FaturaDET
	select fatcod from @Fatura  where fatdtemissao >='08-01-2013' group by fatcod having count(distinct(cd_tp_Moeda))>1
	
	Update
		@Fatura
	Set
		Fatcod=FatCod+'.'+Cod_Int_Moeda
	From
		@fatura F 
		Join @FaturaDET FC on FC.faturaenc=fatcod
	
	--select fatcod from @Fatura  where fatdtemissao >='08-01-2013' group by fatcod having count(distinct(cd_tp_Moeda))>1
	--Update
	--	@Fatura
	--Set
	--	Fatcod=FatCod+DC
	----   Join Tipo_Moeda M on m.cd_tp_moeda=F.cd_tp_Moeda
	--Where
	--	Fatcod in (select fatcod from @Fatura  group by fatcod having count(distinct(DC))>1)
		
Declare @TaxasEmAberto Table
(
	Nome_Raz_Soc Varchar(100),
--	Endereco Varchar(500),
	Fatura	Varchar(20),
	Apelido	Varchar(50),
	Num_proc	Varchar(16),
	Vencimento  Datetime,
	Taxa		Varchar(60),
	DC			Char(1),
	Moeda		Varchar(3),
	Vlr_Org		Decimal (10,2),
	Vlr_Org_RS	Decimal(10,2),
--	Range_Fluxo	Varchar(40),
	Cd_PEs		Varchar(10),
	Dt_Pagamento varchar(10),
	cd_ax		varchar(5),
	num_lcto	varchar(20),
	Dt_Emis		Datetime,
	vlr_t		Decimal(10,2),
	AX_DOC bigint
)

Insert @TaxasEmAberto (Nome_Raz_Soc,Fatura,Apelido,Num_proc,vencimento,taxa,dc,moeda,vlr_org,vlr_org_rs,cd_pes,Dt_Pagamento,cd_ax,num_lcto,dt_emis,AX_DOC)

Select 
	PP.Nome_Raz_Soc,
	fat.fatcod,
	isnull(GRP.apelido,PP.Apelido),
	CXA.num_proc_hia,
	fatdtvenc,
	Nome_TP_TX Taxa,
	cxa.dc_hia,
	FAT.cd_Tp_moeda Moeda, 
	Vlr_ORg_fat,--Vlr_ref_HIA, - 19/09/2013 - Anderson
	vlr_pgto_rcto_hia,
	FAT.Cd_Pes, 
	DT_PGTO_RCTO_HIA,
	AX.cd_ax,
	(case when num_lcto = 'REMESSA' then
			num_rcb_hia
	else
		num_lcto end) num_lcto,
	fatdtemissao,
	AD.id_Ax
From vwcxas CXA	with(nolock)
	Join @Fatura FAt on cxa.num_proc_hia=Fat.num_proc and cxa.cd_Tp_tx=fat.cd_tp_tx and cxa.dc_hia=fat.dc
--	Join vwcta_cte cta with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_Tp_Tx and cta.dc_hia=cxa.dc_hia 
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=cxa.cd_tp_tx and cd_ax <> '000.1'
	Left Join Pessoa_LLP PLLP With(Nolock)  on PLLP.cd_pes=FAT.cd_pes
	Left Join Pessoa GRP with(nolock) on GRP.cd_pes=cd_pes_Grupo and GRP.cd_pes <> 'GRATL'
	Join PEssoa PP with(nolock) on PP.cd_pes=FAT.cd_pes
--	Left Join Endereco ED with(nolock) on PP.cd_pes=ed.cD_pes and cd_tp_end='COM'
	Left Join Pessoa_ATL_AX AX with(nolock) on (PP.cd_tp_ativ <> 'AGT' and AX.Cd_Pes = PP.Cd_Pes or PP.cd_tp_Ativ='AGT' and left(ax.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes) and AX.Tipo='C'
	Left Join vwAXDocs AD with(nolock) on CXA.Num_Proc_HIA = AD.num_proc and CXA.Cd_Tp_Tx = AD.cd_tp_tx_Atl and CXA.DC_HIA = AD.dc 
where
	--cxa.num_proc_hia = 'emfmc201305001br'
--	cxa.num_Lcto is null
--	desp_org_hia='N'
	convert(datetime,dt_Pgto_Rcto_hia,105) between @DataInicial and @DataFinal
--	and vlr_org_hia >0
	
Update @TaxasEmAberto
	--SEt vlr_org_rs=Vlr_ORg* [dbo].[FConverterMoeda](Moeda,'REL')
	SEt vlr_t= Vlr_ORg * [dbo].[VerParidade](convert(varchar(10),Dt_Emis,103),Moeda,'OFC')
	
--	Update @TaxasEmAberto set Fatura=Fatura + '.' + Cod_Int_Moeda from @TaxasEmAberto
--Join Tipo_Moeda on Cd_TP_Moeda=Moeda
--where Fatura in (
--					Select fatura from @TaxasEmAberto 
--					group by fatura 
--					having count(distinct(Moeda))>1
--					)
--and Dt_Emis >='08-01-2013'

	

	

update @TaxasEmAberto set moeda='BRL'
where moeda='REL'

select 
	num_proc									[BDP Ref.],
	dbo.fBusca_TipoDocCliente('N',num_proc,1)	[Customer Reference],
	Cd_Pes										[Customer Code],
	cd_ax										[AX Code],
	Nome_Raz_Soc								[Customer Name],
	Fatura+dc										[DN Number],
	num_lcto									[LA],
	Dt_Pagamento								[Payment Dt],
--	Vencimento									[Due Dt],
	Moeda										[Currency],
	sum(dbo.valor(abs(Vlr_Org),dc))								[Value],
	sum(dbo.valor(abs(vlr_t),dc))									[BRL Value],
	sum(dbo.valor(abs(Vlr_Org_RS)	,dc))								[Payment Value],
	AX_DOC [AX DOC]
from 
	@TaxasEmAberto
/*
Where 
	dc='C' 
RETIRADO POR ANDERSON EM 16/09/2013
*/
Group by num_proc,moeda,
--range_fluxo,
cd_pes,nome_raz_soc,num_lcto,Dt_Pagamento,cd_ax,Fatura,dc,AX_DOC
GO
