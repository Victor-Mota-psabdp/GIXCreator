SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_Aging_Report_Rel]'2012-11-01','2012-11-06'
CREATE Procedure [dbo].[spATL_Aging_Report_Rel]--'2012-01-01','2012-10-30'
	@Dt_Inicial	datetime,
	@Dt_Final	datetime

as
	declare @TAB table
	(
	[CUST NAME]				varchar(60),	
	[INVOICE #]				varchar(20),
	[INV DATE]				datetime,
	[CUST REFERENCE]		varchar(300),
	[ORIG AMT]				float,
	[$ Totals]				float,
	[STATUS]				varchar(100),
	[NOTES]					varchar(2000)
	)

Begin
	insert into
			@TAB

	select 
		P.Nome_Raz_Soc		[CUST NAME],
		FA.FatCod			[INVOICE #],
		FA.FatdtVenc		[INV DATE],
		dbo.fBusca_Docs_PO_Modal(FAT.num_proc,1) [CUST REFERENCE],
	--	''					[CUST REFERENCE],
	--	sum(dbo.valor(abs(FAT.vlr_org),fat.dc))	[ORIG AMT],
	--	sum(dbo.valor(abs(FAT.vlr_org),fat.dc))	[$ Totals],
		sum([dbo].[FConverterMoeda](Cd_Tp_Moeda,'REL') * dbo.valor(abs(FAT.vlr_org),fat.dc)) [ORIG AMT],
		sum([dbo].[FConverterMoeda](Cd_Tp_Moeda,'REL') * dbo.valor(abs(FAT.vlr_org),fat.dc)) [$ Totals],
		''					[STATUS],
		FA.fatObs			[NOTES] 
	from fatura	FA with(nolock)
		join pessoa P with(nolock) on P.cd_pes = FA.cd_pes
		join item_fat	FAT with(nolock) on fa.Fatcod = FAT.FatCod
		left join vwCXAS	CA with(nolock) on CA.num_proc_hia = FAT.num_proc and CA.cd_tp_tx = FAT.cd_tp_tx and CA.dc_hia = FAT.dc
	Where 
	--	FA.fatcod = 'IOCSR201203055BRA'
		FA.FatdtVenc between @Dt_Inicial and @Dt_Final
		and	
		num_lcto is null 
		and fatstatus = '1'
	group by 
		P.Nome_Raz_Soc,
		FA.FatCod,
		FA.FatdtVenc,	
	--	FAT.vlr_org,
		FA.fatObs,
		FAT.num_proc
End

select * from @tab where [ORIG AMT] > 0 order by 3




GO
