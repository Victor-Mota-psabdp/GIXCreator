SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spFaturaCHBRateio_Sel]  --'IMCSR201208161BRA'
(
	@Fatura varchar(17)
)
As
	select 
		CC.Num_Proc, FCI.FAtura_CC, 
		FCI.CD_tp_tx TAXA_FAT,
		CC.CD_tp_tx TAXA_CUSTO,
		abs(FCI.Vlr_PC) Valor_Item,
		P.Num_Pedido N_Order,
		sum(peso_liquido_tot) Peso_Item,
		sum(PS.QTY) Qty_Tot,
		PDET.Cd_pedido,
		PDET.Cd_produto
	from 
		fatura_CHB_item FCI
		left outer join custo_cliente CC on left(@Fatura,16) = CC.num_proc and FCI.CD_tp_tx = CC.CD_tp_tx
		left outer join Pedido_ship PS on left(@Fatura,16) = PS.num_proc
		left outer join Pedido P on PS.cd_pedido = P.Cd_pedido
		Left Outer Join Pedido_det PDET on (pdet.item=ps.item or ps.item is null)and (pdet.lote=ps.lote or ps.lote is null) and  PS.cd_produto = PDet.cd_produto and PS.cd_pedido = PDet.cd_pedido 
		Join Tipo_Taxa TT on FCI.Cd_Tp_Tx = TT.Cd_Tp_Tx  and TT.Ref_Ctb_Tx <> 'ADT'
	where 
		fatura_cc = @Fatura  and CC.CD_tp_tx is null and PDet.cd_pedido is not  Null and Pdet.Cd_produto is not Null
		and (Vlr_PC > 0 OR FCI.cd_tp_tx in ('CF1','IRR','C01','p01')) --and FCI.CD_tp_tx <> 'XBA'
	group by 
		CC.Num_Proc, FCI.FAtura_CC, FCI.CD_tp_tx, CC.CD_tp_tx, FCI.Vlr_PC, P.Num_Pedido,PDET.Cd_pedido,PDET.Cd_produto
GO
