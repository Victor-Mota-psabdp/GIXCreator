SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from nota_cliente where num_proc like 'IMSUN%'
--select * from Nota_Fiscal_Cliente_Det where id_nf = '5446' and cd_cliente = 'P000004794'

CREATE Procedure [dbo].[spATL_SunChemicalModel_Rel]--'Grupo Sun Chemical','2012-04-01','2012-04-30'

	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
as
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Grupo)

	set @grupo = (select grupo from grupo with(nolock) where cd_pes_grupo = @cd_pes_grupo)

select
	P.num_pedido														[Purchasing Document Number],
	PL.cd_vendor														[Vendor's account number],
	PES.Apelido															[Name],
	PL.cd_Planta														[Plant],
	P.dt_pedido															[Purchasing Document Date],	
	PC.cd_proc_cliente													[Material Number],
	(PC.cd_proc_cliente + '-' + PC.produto_descr)						[Short Text],
	PS.Qty																[Purchase Order Quantity],
	PD.UOM																[Order Unit],
	PD.vlr_total_item													[Net Order Value In PO Currency],
	P.cd_tp_moeda														[Currency Key],
	P.DL_Chegada														[Item Delivery Date],
	'?'																	[Confirmation Category],
	T39.dt_conclusao													[Delivery Date Of Vendor Confirmation],
	'?'																	[Tracking Number],
	(case when T39.dt_conclusao is not null then 'X' else '' end)		[Delivery Completed" Indicator],
	(case when LIM.ID_STATUS = 9 then 'CANCELADO'
		when LIM.eta_lim > getdate() then 'AG.EMBARQUE'
		when LIM.ata_lim IS NULL then 'EM Transito' 
		when T13.dt_conclusao is not null then 'ENTREGUE' end)				[STATUS],
--	[STATUS: CANCELADO OU ENTREGUE OU TRANSITO OU AG.EMBARQUE],

	PS.num_proc															[BROKER REFERENCE],
	DET.FOB																[VALOR R$],

	sum((DET.vl_base_II - DET.vlr_frete - DET.vlr_seguro - DET.acrescimos)) 
		* [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)			[Despesas R$],

	DET.ncm																			[NCM],

	max(Aliq_II)																	[II %],
	max(Aliq_IPI)																	[IPI %],
	max(Aliq_ICMS)																	[ICMS %],

	sum(Vl_II) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)				[II R$],
	sum(Vl_IPI) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)				[IPI R$],
	sum(Vl_Imposto_PIS) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)		[PIS R$],
	sum(Vl_Imposto_Cofins) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)	[COFINS R$],
	sum(Vl_ICMS) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)			[ICMS R$],

	left(datename(month,T13.dt_conclusao),3)+ '/' + datename(year,T13.dt_conclusao)		[Mês Desembaraço],
	
	dbo.[fBusca_CaixaTaxaVlr](Ps.num_proc,'%adiantamento%','C')							[Deposito despachante],
	sum(Vl_ICMS) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)	[ICMS],
	
	--II + Ipi+ PIS + cofins + tx siscomex 	[Debito em conta] - ESTE AQUI E O VALOR DO CAIXA?
	sum(Vl_II) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)
		+ sum(Vl_IPI) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)
			+ sum(Vl_Imposto_PIS) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)
				+ sum(Vl_Imposto_Cofins) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido)
					+ sum(Vlr_Siscomex) * [dbo].[spBuscaPorcentagem_Pedido](ps.num_proc,ps.item,num_pedido) [Debito em conta]
from
	pedido_ship PS
	Join Produto_Cliente		PC			with(nolock) on PC.cd_prod=Ps.cd_produto
	Join Pedido_DET				PD			with(nolock) on PS.cd_produto=PD.cd_produto and PS.cd_pedido=PD.cd_pedido and PS.item = PD.Item
	Join Pedido					P			with(nolock) on P.cd_pedido=PS.cd_pedido
	join nota_cliente			NC			with(nolock) on NC.num_proc = ps.num_proc
	join Nota_Fiscal_Cliente_Det DET		with(nolock) on NC.id_nf = DET.id_nf and NC.cd_cliente = DET.cd_cliente
	left join tarefas_processos T13			with(nolock) on T13.num_proc = Ps.num_proc and T13.id_task = 13
	left join tarefas_processos T39			with(nolock) on T39.num_proc = Ps.num_proc and T39.id_task = 39
	join llp_imp_mar			LIM			with(nolock) on LIM.num_proc_lim = Ps.num_proc
	join House_imp_mar			HOU			with(nolock) on HOU.num_proc_him = PS.num_proc
	join pessoa					PES			with(nolock) on	Pes.cd_pes = Hou.cd_export_him
	left join pessoa_llp		PL			with(nolock) on PL.cd_pes = Hou.cd_export_him
where
	LIM.etd_lim between @DtInicial and @DtFinal
	and right(left(PS.num_proc,5),3) = @grupo
	
	
group by
	P.num_pedido,PL.cd_vendor,PES.Apelido,PL.cd_Planta,	P.dt_pedido,PC.cd_proc_cliente,
	PC.cd_proc_cliente,PC.produto_descr,
	PS.Qty,
	PD.UOM,
	PD.vlr_total_item,
	P.cd_tp_moeda,
	P.DL_Chegada,
	PS.num_proc	,
	DET.ncm	,
	ps.num_proc,ps.item,num_pedido,
	PS.CD_Pedido, PS.Cd_Produto	,	
	T13.dt_conclusao,
	DET.FOB,
	DET.vl_base_II,DET.vlr_frete,DET.vlr_seguro,DET.acrescimos,
	LIM.ID_STATUS,LIM.eta_lim,LIM.ata_lim,
	T39.dt_conclusao


GO
