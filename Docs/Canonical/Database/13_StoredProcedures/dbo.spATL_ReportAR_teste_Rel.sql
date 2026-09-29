SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--incluida o cd_ax
--alterada a paridade pra pegar a taxa do dia (due date)
--06-12 incluido nome taxa
--Erbson 23-06-2015 - Incluido o AX DOC
CREATE Procedure [dbo].[spATL_ReportAR_teste_Rel]--[dbo].[spATL_ReportAR_teste_Rel] '05-01-2026','06-02-2026'
--@StartDate	varchar(20)
--	,@EndDate  varchar(20)

	@StartDate	Datetime
	,@EndDate  Datetime

AS
--
--Declare @Data	Datetime
--set @Data = '2013-06-30'

 Declare @Table Table
	(
	
		[BDP Ref.] Varchar(16),
		[Num_Proc] varchar(20),
		[House BL] Varchar(25),
		[Master BL] Varchar(25),
		[Vendor Code] Varchar(10),
		[Vendor Name] Varchar(60),
		[CNPJ] Varchar(16),
		[Issued Dt] Datetime,
		[Due Dt]	Datetime,
		Currency	Varchar(3),
		Value		Decimal(10,2),
		[BRL Value]	Decimal(10,2),
		[N. Days]	Int,
		[Range]		Varchar(50),
		[CD_AX]		varchar(5),
		[NF]		varchar(30),
		[Name TX]	varchar(50),
		[DN Number] varchar(30),
		[AX DOC/Invoice Number]	bigint		,
		[IntercompanyInvoice/Debit Note] Varchar(40),
		[IntercompanyInvoice/Credit Note] Varchar(40)
	)


		Declare @Fatura Table
		(
			FatCod      varchar (17),
			Num_proc	varchar(16),
			Cd_tp_Tx	Varchar(3),			
			DC			Varchar(1)
			--ID_FAT		varchar(8)

		)
	Begin 		
		Insert @Fatura		
				Select F.FatCod,
				(case when len(i.fatcod)= 15 then left(i.fatcod,14) else	left(i.fatcod,16) end),
				I.Cd_Tp_Tx,i.DC from item_fat I	 with(nolock)		
				Join Fatura F with(nolock) on F.fatcod=i.fatcod
				
				--left join NF_Fatura_Item NFI with(nolock) on (case when len(i.fatcod)= 15 then left(i.fatcod,14) else	left(i.fatcod,16) end) = NFI.Num_Proc and I.cd_tp_Tx=NFI.cd_tp_tx and I.DC=NFI.DC 
				--LEFT JOIN NF_FATURA NF ON NFI.ID  = NF.ID
						
				where convert(datetime,fatdtEmissao,105)>= DATEADD(DAY, -10, @StartDate) and fatstatus =1
	End	
	
----		Declare @Nota_Oracle table
----		(
----			Num_proc	varchar(16),			
----			AX_DOC		bigint,
----			DC			Varchar(1),
----			Cd_tp_Tx	Varchar(3)

----		)
----		begin
----			Insert @Nota_Oracle
----			select 
----			I.Num_Proc_HIA,
----			ADI.id_ax,
----			ADI.DC,
----			ADI.cd_tp_tx_ATL
	
----			from vwCXAS i with(nolock)
----			--Join Fatura F with(nolock) on F.fatcod=i.fatcod
----			--Left join NF_Fatura_Item NFI with(nolock) on VAJ.Num_Proc = NFI.Num_Proc
----			--Left join NF_Fatura NF with(nolock) on NFI.ID  = NF.ID
----			--left join Ax_Doc_ITem ADI with(nolock) on  VAJ.Num_Proc = ADI.num_proc --and NFI.Cd_Tp_Tx = ADI.cd_tp_Tx_ATL 
----			--left join AX_Doc AD with(nolock) on ADI.ID_AX = AD.ID_AX 
----			left join Ax_Doc_ITem ADI with(nolock) on  I.Num_Proc_HIA = ADI.num_proc and I.Cd_Tp_Tx = ADI.cd_tp_Tx_ATL 
----				left join AX_Doc AD with(nolock) on ADI.ID_AX = AD.ID_AX 
----			--Left hash Join vwAXDocs AD with(nolock) on NFI.Num_Proc = AD.num_proc and NFI.DC = AD.dc and NFI.Cd_Tp_Tx = AD.cd_tp_tx_Atl
----		--	left join AX_Doc_item AD with(nolock) on  NFI.Num_Proc = ad.num_proc -- and NFI.Cd_Tp_Tx = AD.Cd_Tp_TX and NFI.DC = AD.DC
------		where NFI.Num_Proc = 'IAATL202510015BR' and AD.dt_canc_ax is null and ADI.id_ax is not null
----			where convert(datetime,AD.Dt_Ins,105)>= DATEADD(DAY, -10, @StartDate) and AD.dt_canc_ax is null and ADI.id_ax is not null
	
------			from Item_Fat i with(nolock)
------			Join Fatura F with(nolock) on F.fatcod=i.fatcod
------			--Left join NF_Fatura_Item NFI with(nolock) on VAJ.Num_Proc = NFI.Num_Proc
------			--Left join NF_Fatura NF with(nolock) on NFI.ID  = NF.ID
------			--left join Ax_Doc_ITem ADI with(nolock) on  VAJ.Num_Proc = ADI.num_proc --and NFI.Cd_Tp_Tx = ADI.cd_tp_Tx_ATL 
------			--left join AX_Doc AD with(nolock) on ADI.ID_AX = AD.ID_AX 
------			left join Ax_Doc_ITem ADI with(nolock) on  I.Num_Proc = ADI.num_proc and I.Cd_Tp_Tx = ADI.cd_tp_Tx_ATL 
------				left join AX_Doc AD with(nolock) on ADI.ID_AX = AD.ID_AX 
------			--Left hash Join vwAXDocs AD with(nolock) on NFI.Num_Proc = AD.num_proc and NFI.DC = AD.dc and NFI.Cd_Tp_Tx = AD.cd_tp_tx_Atl
------		--	left join AX_Doc_item AD with(nolock) on  NFI.Num_Proc = ad.num_proc -- and NFI.Cd_Tp_Tx = AD.Cd_Tp_TX and NFI.DC = AD.DC
--------		where NFI.Num_Proc = 'IAATL202510015BR' and AD.dt_canc_ax is null and ADI.id_ax is not null
------			where convert(datetime,F.FatDtEmissao,105)>= DATEADD(DAY, -10, @StartDate) and AD.dt_canc_ax is null and ADI.id_ax is not null


 
--		end


insert @table

select distinct
	Cta.num_proc_hia [BDP Ref.],
	--noc.Num_proc	[Num_Proc],

	pp.Apelido,
	AJ.HAWB			[House BL],
	AJ.MAWB			[Master BL],
	PP.cd_pes [Vendor Code],
	pp.Nome_Raz_Soc [Vendor Name],
	PP.Num_CPF_CNPJ [CNPJ],
	convert(Datetime,dt_ins_hia,105) [Issued Dt],
	convert(datetime,dt_prev_pgto_hia,105) [Due Dt] ,
	cta.Cd_Tp_Moeda [Currency],
	dbo.valor(Vlr_org_hia,cta.dc_hia) [Value],
--	0,
	dbo.valor(Vlr_org_hia,cta.dc_hia) * [dbo].[VerParidade](dt_prev_pgto_hia,cta.Cd_Tp_Moeda,'OFC') [BRL Value],
	cast(getdate()-convert(datetime,dt_prev_pgto_hia,105) as int),
	Null,
	AXF.cd_ax,
	Num_NF_Hia,
	TTI.Nome_Tp_Tx,
	I.FatCod + '.' + I.cd_tp_tx + '.' + I.DC [DN Number],
	ADP.ID_AX [AX_DOC],
	convert(varchar(50),dbo.fBusca_TipoDocCliente('N',Cta.num_proc_hia,181)) [IntercompanyInvoice/Debit Note],
	convert(varchar(50),dbo.fBusca_TipoDocCliente('N',Cta.num_proc_hia,180))[IntercompanyInvoice/Credit Note]
from 
	vwcta_cte cta with(nolock)
	--Left Join vwcxas CXA with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia and convert(Datetime,dt_pgto_Rcto_hia,105) <=@EndDate
	join tipo_taxa TT with(nolock) on TT.cd_tp_tx = CTA.cd_tp_tx
	Left Join @Fatura FAt  on fat.num_proc=cta.num_proc_hia and FAt.cd_tp_tx=cta.cd_tp_Tx and fat.dc=cta.dc_hia
	Left Join vwcliente C with(nolock) on c.num_proc=cta.num_proc_hia
	Join Pessoa PP with(nolock) on pp.cd_pes=cd_cred_dev_hia --and PP.cd_tp_Ativ='AGT' 
	Left Join Pessoa_LLP P with(nolock) on P.cd_pes=pp.cd_pes 
	--Left Join Pessoa_ATL_AX AX with(nolock) on PP.cd_tp_ativ <> 'AGT' and AX.Cd_Pes = PP.Cd_Pes 
	Left Join Pessoa_ATL_AX AXF with(nolock) on  left(AXF.cd_pes,len(AXF.cd_pes)-1)=PP.cd_pes and AXF.Tipo='C'	
--	left join AX_Doc_item AD with(nolock) on  cta.Num_Proc_HIA = ad.num_proc --and cta.Cd_Tp_Tx = AD.Cd_Tp_TX and cta.DC_HIA = AD.DC
	left join vwAll_JOBs AJ with(nolock) on AJ.Num_proc = CTA.Num_Proc_hia
	left join vwAx_Doc_Pessoa ADP on cta.Num_Proc_HIA = ADP.Num_Proc_HEM and cta.Cd_Tp_Tx = ADP.Cd_Tp_Tx and cta.DC_HIA = ADP.DC_HEM and PP.Cd_Pes = ADP.Cd_Cred_Dev_HEM
	join  tipo_taxa TTI with(nolock) on TTI.cd_tp_tx = ADP.cd_tp_tx
	left join item_fat I with(nolock) on ADP.Num_Proc_HEM = I.Num_Proc and ADP.Cd_Tp_Tx = I.Cd_Tp_Tx and ADP.DC_HEM = I.DC

	--Left join @Nota_Oracle NOC on cta.Num_Proc_HIA = NOC.Num_proc --and cta.cd_tp_tx = NOC.cd_tp_tx-- and  cta.dc_hia=NOC.dc 
	--left join NF_Fatura_Item NFI with(nolock) on cta.Num_Proc_HIA=NFI.Num_Proc and cta.cd_tp_Tx=NFI.cd_tp_tx and cta.DC_HIA=NFI.DC 
	--LEFT JOIN NF_FATURA NF ON NFI.ID  = NF.ID	
	--left join NF_Fatura_Item NFI with(nolock) on AJ.Num_Proc=NFI.Num_Proc and FAt.cd_tp_Tx=NFI.cd_tp_tx and FAt.dc=NFI.DC
	--LEFT JOIN NF_FATURA NF ON NFI.ID  = NF.ID
	--Left Join vwAXDocs AD with(nolock) on Cta.Num_Proc_HIA = AD.num_proc and Cta.Cd_Tp_Tx = AD.cd_tp_tx_Atl and Cta.DC_HIA = AD.dc 
	
where 
	(cd_pes_grupo is null or cd_tp_Ativ='GRL')
--	and cxa.num_lcto is null
	and desp_org_hia='N'
	--and PP.Apelido like '%C'
	--and cta.dc_hia = 'D' 
	--and left(cta.cd_tp_tx,1)<>'X'-- retirado 06-12 cadu
--	and cd_Cred_dev_hia <> cd_cliente
	--and convert(datetime,dt_ins_hia,105) >='01-01-2020'
	--and convert(datetime,dt_ins_hia,105) between @StartDate and @EndDate
	and convert(datetime,dt_ins_hia,105) >= @StartDate
	AND convert(datetime,dt_ins_hia,105) <  @EndDate
	--and convert(datetime,dt_ins_hia,105) >= '2026-05-01'
	--AND convert(datetime,dt_ins_hia,105) < '2026-05-06'
	and vlr_org_hia >0
	--and Fat.num_proc is null

update @Table

set [Range]=
		(
			Case
			    When [N. Days] < 0 then 'Not Due'
			    When [N. Days] <= 30 then '0-30 Days'
				When [N. Days] <= 60 then '31-60 Days'
			    When [N. Days] <= 90 then '61-90 Days'
			    When [N. Days] <= 120 then '91-120 Days'
			    else 'More than 120 Days'
			End
 
		)		
		--(
					--Case
					--	When  [N. Days]<= 30 then '30Days'
					--	When  [N. Days]<= 60 then '60Days'
					--	When  [N. Days]<= 90 then '90Days'
					--	When  [N. Days]<= 120 then '120Days'
					--	else 'More than 120 days'
					--ENd
					--)	
						

--insert @paridade
--select distinct currency, 0,[Dt Prev] from @table
--
--Update @paridade
----		Set Paridade=dbo.FConverterMoeda(Moeda,'REL') 
--		Set Paridade = [dbo].[VerParidade](Dt_Pgto,Moeda,'OFC')


--Update @table
--		set	[BRL Value]=Paridade*value		
--From @table
--Join @Paridade P on P.moeda=currency
--
--Update @table
--		set [Paridade_Dia] = Paridade
--From @table
--Join @Paridade P on P.moeda=currency

Update @Table
	set Currency='BRL'
where
	Currency='REL'

select * from @table
GO
