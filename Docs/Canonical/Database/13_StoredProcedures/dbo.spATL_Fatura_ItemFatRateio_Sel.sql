SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Fatura where FatCod like 'BOCSR201604007BR%'
--select * from Item_Fat where FatCod = 'EACSR201510021BRA'
--select * from House_BDP_OUT
--select * from LLP_BDP_OUT Where Id_TP_Servico = 9
--select * from JOB_HBO

CREATE procedure [dbo].[spATL_Fatura_ItemFatRateio_Sel]--'BOCSR201607002BRB'
(
	@Fatura varchar(17)
)
As

	select 
		--CC.Num_Proc,
		J.Num_Proc,
		FCI.FatCod FAtura_CC, 
		FCI.CD_tp_tx TAXA_FAT,
		CC.CD_tp_tx TAXA_CUSTO,
		abs(FCI.Vlr_Org) Valor_Item,
		P.Num_Pedido N_Order,
		sum(peso_liquido_tot) Peso_Item,
		sum(PS.QTY) Qty_Tot,
		PDET.Cd_pedido,
		PDET.Cd_produto,
		dbo.fBuscaPorcentagem_PedidoProdutoCusto(J.Num_Proc,PDET.cd_pedido,PDET.cd_produto)* abs(FCI.Vlr_Org) ValorCusto
	from 
		Item_Fat FCI
		join JOB_HBO J on J.Num_Proc_HBO = FCI.Num_Proc
		left outer join custo_cliente CC on J.Num_Proc = CC.num_proc and FCI.CD_tp_tx = CC.CD_tp_tx
		left outer join Pedido_ship PS on J.Num_Proc = PS.num_proc
		left outer join Pedido P on PS.cd_pedido = P.Cd_pedido
		Left Outer Join Pedido_det PDET on (pdet.item=ps.item or ps.item is null)and (pdet.lote=ps.lote or ps.lote is null) and  PS.cd_produto = PDet.cd_produto and PS.cd_pedido = PDet.cd_pedido 
		Join Tipo_Taxa TT on FCI.Cd_Tp_Tx = TT.Cd_Tp_Tx  and TT.Ref_Ctb_Tx <> 'ADT'
	where 
		FatCod = @Fatura
		and CC.CD_tp_tx is null 
		and PDet.cd_pedido is not Null 
		and Pdet.Cd_produto is not Null
		and (Vlr_Org > 0 OR FCI.cd_tp_tx in ('CF1','IRR','C01','p01'))
		and FCI.DC = 'D'
	group by 
		J.Num_Proc,FCI.FatCod, FCI.CD_tp_tx, 
		CC.CD_tp_tx, FCI.Vlr_Org, P.Num_Pedido,
		PDET.Cd_pedido,PDET.Cd_produto
		
	--select 
	--	--CC.Num_Proc,
	--	J.Num_Proc,
	--	FCI.FatCod FAtura_CC, 
	--	FCI.CD_tp_tx TAXA_FAT,
	--	CC.CD_tp_tx TAXA_CUSTO,
	--	abs(FCI.Vlr_Org) Valor_Item,
	--	P.Num_Pedido N_Order,
	--	sum(peso_liquido_tot) Peso_Item,
	--	sum(PS.QTY) Qty_Tot,
	--	PDET.Cd_pedido,
	--	PDET.Cd_produto,
	--	dbo.fBuscaPorcentagem_PedidoProdutoCusto(J.Num_Proc,PDET.cd_pedido,PDET.cd_produto)* abs(FCI.Vlr_Org) ValorCusto
	--from 
	--	Item_Fat FCI
	--	join JOB_HBO J on J.Num_Proc_HBO = FCI.Num_Proc
	--	left outer join custo_cliente CC on J.Num_Proc = CC.num_proc and FCI.CD_tp_tx = CC.CD_tp_tx
	--	left outer join Pedido_ship PS on J.Num_Proc = PS.num_proc
	--	left outer join Pedido P on PS.cd_pedido = P.Cd_pedido
	--	Left Outer Join Pedido_det PDET on (pdet.item=ps.item or ps.item is null)and (pdet.lote=ps.lote or ps.lote is null) and  PS.cd_produto = PDet.cd_produto and PS.cd_pedido = PDet.cd_pedido 
	--	Join Tipo_Taxa TT on FCI.Cd_Tp_Tx = TT.Cd_Tp_Tx  and TT.Ref_Ctb_Tx <> 'ADT'
	--where 
	--	FatCod = @Fatura
	--	and CC.CD_tp_tx is null 
	--	and PDet.cd_pedido is not Null 
	--	and Pdet.Cd_produto is not Null
	--	and (Vlr_Org > 0 OR FCI.cd_tp_tx in ('CF1','IRR','C01','p01'))
	--group by 
	--	J.Num_Proc,FCI.FatCod, FCI.CD_tp_tx, 
	--	CC.CD_tp_tx, FCI.Vlr_Org, P.Num_Pedido,
	--	PDET.Cd_pedido,PDET.Cd_produto
		

GO
