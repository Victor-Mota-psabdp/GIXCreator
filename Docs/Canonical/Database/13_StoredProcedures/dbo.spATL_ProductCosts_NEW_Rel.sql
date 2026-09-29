SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spProductCostsTemp_Aut - 3minutos

CREATE Procedure [dbo].[spATL_ProductCosts_NEW_Rel]--'1','','2016-01-01','2016-01-10'
(
	@Tipo char(1),		--	1=Reais(BRL) / 2=Dolar(USD)
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
)
AS

declare @TAB table
	(
	[BDP Job] char(16),
	[JOB Date] datetime,
	[Consignee] varchar(50),
	[CNPJ] varchar(20),
	[PO Number] varchar(50),
	[Item] varchar(6), --item do Pedido SHIP
	[Cod. Produto] varchar(50),
	[Descrição do Produto] varchar(500),
	[Incoterm] varchar(10),
	[Modal] varchar(30),

	[ATD Date] datetime,
	[ATA Date] datetime,

	[Quantity] float, -- Pedido
	[UOM] varchar(10),
	[Currency] varchar(3),
	[Currency Value] float, -- Paridade do DIA
	
	
	[Currency Pedido] varchar(3),
	[Currency Value Pedido] float,
	[Total Value] float,
	[Total Converted Value] float, 
	
	
	[KG/Unit (FOB) Value] float, --vlt item otal / qty
	[Freight Value] float, --
	[Insurance Value] float, --seguro(nao tem no pedido det
	
	[% II] float,
	[II (Imposto) Value] float, 
	[% IPI] float, 
	[IPI (Imposto) Value] float, 
	
	[% ICMS]float,
	[ICMS (Imposto) Value]float,	
	[% COFINS]float,
	[COFINS (Imposto) Value]float,
	[% PIS]float,
	[PIS (Imposto) Value]float,		
	Cd_Produto int,
	[Base de Calculo] float
	)
			
insert into	@TAB 
	select
		HOU.Num_Proc_HIM, 
		convert(datetime,HOU.Dt_Emis_Him,105),
		CNS.apelido,
		CNS.Num_CPF_CNPJ, 
		P.Num_Pedido,
		PS.item, 
		PC.cd_proc_cliente, 
		PC.Produto_Descr,
		HOU.cd_tp_oper,
		'Sea Import',
		LLP.atd_lim, 
		LLP.ata_lim,
		PS.qty, 
		PD.UOM,
		(case when @Tipo = 1 then 'BRL' else 'USD' end),
		dbo.verparidade(convert(varchar(10),getdate(),103),(case when @Tipo = 1 then 'REL' else 'USD' end),'IMM') Paridade,
		
		
		P.cd_tp_moeda,
		dbo.verparidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM'),
		PD.Vlr_Total_Item,
		(case when @Tipo = 1 then 
			PD.Vlr_Total_Item  * dbo.verparidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM') 
			 else
			PD.Vlr_Total_Item 
			 end),
			 		
		isnull(PD.Vlr_Total_Item,1) / isnull(PD.QTY,1), --[KG/Unit (FOB) Value]
		PD.Vlr_Frete,--[Freight Value]
		0,--[Insurance Value]
		I.ALIQ_II,--[% II]
		0, --(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)) * (I.ALIQ_II / 100),--[II (Imposto) Value]
		I.ALIQ_IPI, --[% IPI]
		(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)),--[IPI (Imposto) Value] + Total II
		I.ALIQ_ICMS, --[% ICMS]
		0, --(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)),-- * (I.ALIQ_ICMS/ 100),--[ICMS (Imposto) Value] + II + IPI / 1 - (I.ALIQ_ICMS/ 100)) * (I.ALIQ_ICMS/ 100) 
		I.VL_ALIQ_COFINS, --[% COFINS]
		0, --(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)), -- * (I.VL_ALIQ_COFINS/ 100),--[COFINS (Imposto) Value]+ II + IPI + ICMS
		I.VL_ALIQ_PIS, --[% PIS]
		0, --(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)), -- * (I.VL_ALIQ_PIS/ 100),--[PIS (Imposto) Value] + II + IPI + ICMS
		PS.Cd_Produto,		
		(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0))	
		
	from
		House_IMP_Mar HOU with(nolock)
		join llp_imp_mar LLP with(nolock) on LLP.num_proc_lim = HOU.num_proc_him
		join pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_him		
		join Pedido_Ship PS with(nolock) on HOU.num_proc_him = PS.num_proc
		join Pedido_Det PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item
		join Pedido P with(nolock) on PD.Cd_Pedido = P.Cd_Pedido
		join ProductCosts_Temp I with(nolock) on I.Cd_Produto = PD.Cd_Produto		
		join Produto_Cliente PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod
		--left join po_him PO with(nolock) on PO.num_proc_him = HOU.num_proc_him and PO.id_dc = 1
	where
		LLP.ata_lim is null 
		and convert(datetime,HOU.Dt_Emis_Him,105) between @DtInicial and @DtFinal
		and PD.QTY > 0
UNION ALL
	select
		HOU.Num_Proc_HIa, 
		convert(datetime,HOU.Dt_Emis_HIA,105),
		CNS.apelido,
		CNS.Num_CPF_CNPJ, 
		P.Num_Pedido,
		PS.item, 
		PC.cd_proc_cliente, 
		PC.Produto_Descr,
		HOU.cd_tp_oper,
		'Air Import',
		LLP.atd_lia, 
		LLP.ATA_LIA,
		PS.qty, 
		PD.UOM,
		(case when @Tipo = 1 then 'BRL' else 'USD' end),
		dbo.verparidade(convert(varchar(10),getdate(),103),(case when @Tipo = 1 then 'REL' else 'USD' end),'IMM') Paridade,
		--PD.Vlr_Total_Item,	 --[Valor da Mercadoria Value]
		
		P.cd_tp_moeda,
		dbo.verparidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM'),
		PD.Vlr_Total_Item,
		(case when @Tipo = 1 then 
			PD.Vlr_Total_Item * dbo.verparidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM') 
			 else
			PD.Vlr_Total_Item 
			 end),
		
		isnull(PD.Vlr_Total_Item,1) / isnull(PD.QTY,1), --[KG/Unit (FOB) Value]
		PD.Vlr_Frete,--[Freight Value]
		0,--[Insurance Value]
		I.ALIQ_II,--[% II]
		(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)) * (I.ALIQ_II / 100),--[II (Imposto) Value]
		I.ALIQ_IPI, --[% IPI]
		(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)),--[IPI (Imposto) Value] + Total II
		I.ALIQ_ICMS, --[% ICMS]
		0, --(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)),-- * (I.ALIQ_ICMS/ 100),--[ICMS (Imposto) Value] + II + IPI / 1 - (I.ALIQ_ICMS/ 100)) * (I.ALIQ_ICMS/ 100) 
		I.VL_ALIQ_COFINS, --[% COFINS]
		0, --(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)), -- * (I.VL_ALIQ_COFINS/ 100),--[COFINS (Imposto) Value]+ II + IPI + ICMS
		I.VL_ALIQ_PIS, --[% PIS]
		0, --(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)), -- * (I.VL_ALIQ_PIS/ 100),--[PIS (Imposto) Value] + II + IPI + ICMS
		PS.Cd_Produto,		
		(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0))
	from
		House_Imp_Aer HOU with(nolock)
		join LLP_Imp_Aer LLP with(nolock) on LLP.num_proc_lia = HOU.num_proc_hia
		join pessoa CNS with(nolock) on CNS.cd_pes = HOU.Cd_Consig_HIA	
		join Pedido_Ship PS with(nolock) on HOU.Num_Proc_HIA = PS.num_proc
		join Pedido_Det PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item
		join Pedido P with(nolock) on PD.Cd_Pedido = P.Cd_Pedido
		join ProductCosts_Temp I with(nolock) on I.Cd_Produto = PD.Cd_Produto		
		join Produto_Cliente PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod
		--left join po_him PO with(nolock) on PO.num_proc_him = HOU.num_proc_him and PO.id_dc = 1
	where
		LLP.ata_lia is null 
		and convert(datetime,HOU.Dt_Emis_HIA,105) between @DtInicial and @DtFinal
		and PD.QTY > 0
UNION ALL
	select
		HOU.Num_Proc_HIO, 
		convert(datetime,HOU.Dt_Emis_HIO,105),
		CNS.apelido,
		CNS.Num_CPF_CNPJ, 
		P.Num_Pedido,
		PS.item, 
		PC.cd_proc_cliente, 
		PC.Produto_Descr,
		HOU.cd_tp_oper,
		'Others Import',
		LLP.ATD_Lio, 
		LLP.ATA_Lio,
		PS.qty, 
		PD.UOM,
		(case when @Tipo = 1 then 'BRL' else 'USD' end),
		dbo.verparidade(convert(varchar(10),getdate(),103),(case when @Tipo = 1 then 'REL' else 'USD' end),'IMM') Paridade,
		--PD.Vlr_Total_Item,	 --[Valor da Mercadoria Value]
		
		P.cd_tp_moeda,
		dbo.verparidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM'),
		PD.Vlr_Total_Item,
		(case when @Tipo = 1 then 
			PD.Vlr_Total_Item * dbo.verparidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM') 
			 else
			PD.Vlr_Total_Item 
			 end),
		
		isnull(PD.Vlr_Total_Item,1) / isnull(PD.QTY,1), --[KG/Unit (FOB) Value]
		PD.Vlr_Frete,--[Freight Value]
		0,--[Insurance Value]
		I.ALIQ_II,--[% II]
		(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)) * (I.ALIQ_II / 100),--[II (Imposto) Value]
		I.ALIQ_IPI, --[% IPI]
		(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)),--[IPI (Imposto) Value] + Total II
		I.ALIQ_ICMS, --[% ICMS]
		0, --(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)),-- * (I.ALIQ_ICMS/ 100),--[ICMS (Imposto) Value] + II + IPI / 1 - (I.ALIQ_ICMS/ 100)) * (I.ALIQ_ICMS/ 100) 
		I.VL_ALIQ_COFINS, --[% COFINS]
		0, --(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)), -- * (I.VL_ALIQ_COFINS/ 100),--[COFINS (Imposto) Value]+ II + IPI + ICMS
		I.VL_ALIQ_PIS, --[% PIS]
		0, --(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0)), -- * (I.VL_ALIQ_PIS/ 100),--[PIS (Imposto) Value] + II + IPI + ICMS
		PS.Cd_Produto,		
		(PD.Vlr_Total_Item + isnull(PD.Vlr_Frete,0))
	from
		House_Imp_Out HOU with(nolock)
		join LLP_Imp_Out LLP with(nolock) on LLP.Num_Proc_Lio = HOU.Num_Proc_HIO
		join pessoa CNS with(nolock) on CNS.cd_pes = HOU.Cd_Consig_HIO	
		join Pedido_Ship PS with(nolock) on HOU.Num_Proc_HIO = PS.num_proc
		join Pedido_Det PD with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item
		join Pedido P with(nolock) on PD.Cd_Pedido = P.Cd_Pedido
		join ProductCosts_Temp I with(nolock) on I.Cd_Produto = PD.Cd_Produto		
		join Produto_Cliente PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod
		--left join po_him PO with(nolock) on PO.num_proc_him = HOU.num_proc_him and PO.id_dc = 1
	where
		LLP.ata_lio is null 
		and convert(datetime,HOU.Dt_Emis_HIO,105) between @DtInicial and @DtFinal
		and PD.QTY > 0
		
	
	Begin		
		Update T
		set
			[II (Imposto) Value] = ([Total Converted Value]) * ([% II] / 100)	
		from 
			@TAB T			
	End
	
	
	Begin		
		Update T
		set
			--[IPI (Imposto) Value] = ([IPI (Imposto) Value] + [II (Imposto) Value]) * ([% IPI] / 100)
			[IPI (Imposto) Value] = ([Total Converted Value]  + [II (Imposto) Value]) * ([% IPI] / 100)
				
		from 
			@TAB T			
	End
	
	Begin		
		Update T
		set	
			--[Base do ICMS] = ([Base do ICMS] + [IPI (Imposto) Value] + [II (Imposto) Value]) / (1 - ([% ICMS] / 100))
			[Base de Calculo]  = [Total Converted Value]  + [IPI (Imposto) Value] + [II (Imposto) Value]
		from 
			@TAB T			
	End
	
	Begin		
		Update T
		set	
			[ICMS (Imposto) Value] = ([Base de Calculo] / (1 - ([% ICMS] / 100))) *  ([% ICMS] / 100),
			[COFINS (Imposto) Value] = ([Base de Calculo] / (1 - ([% COFINS] / 100))) *  ([% COFINS] / 100), 
			[PIS (Imposto) Value] = ([Base de Calculo] / (1 - ([% PIS] / 100))) *  ([% PIS] / 100)
		from 
			@TAB T			
	End
		
select 
	[BDP Job],[JOB Date],[Consignee],[CNPJ],[PO Number],[Item],[Cod. Produto],[Descrição do Produto],
	[Incoterm],[Modal],[ATD Date],[ATA Date],[Quantity],[UOM],
	[Currency],
	[Currency Value],
	[Currency Pedido],
	[Currency Value Pedido],
	[Total Value],
	[Total Converted Value] [Total Price],
	[KG/Unit (FOB) Value],
	([Freight Value])	[Freight Value],
	([Insurance Value])	[Insurance Value],	
	[% II],
	([II (Imposto) Value]) [II (Imposto) Value],
	[% IPI], 
	([IPI (Imposto) Value]) [IPI (Imposto) Value],
	[% ICMS],
	([ICMS (Imposto) Value]) [ICMS (Imposto) Value],	
	[% COFINS],	
	([COFINS (Imposto) Value]) [COFINS (Imposto) Value],
	[% PIS],
	([PIS (Imposto) Value]) [PIS (Imposto) Value]
	--,Cd_Produto,[Base de Calculo] 
from @TAB
GO
