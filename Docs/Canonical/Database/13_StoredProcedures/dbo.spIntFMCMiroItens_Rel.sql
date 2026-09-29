SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE Procedure [dbo].[spIntFMCMiroItens_Rel] --spIntFMCMiroItens_Rel 'IOFMC201110001BR',1,71
		@Num_PRoc	Varchar(16),
		@Tipo		Varchar(1),
		@id_miro	int

as	
SELECT Distinct
		pdd.item ITEM_NF, dbo.fBusca_PO_NumPedido(hou.num_proc_hiM,10) Nota_Fiscal,
		pdd.item Item_Pedido,num_pedido,sum(vlr_item_custo*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_him,ps.item,num_pedido)) Valor,
		conta_debito Debito, Conta_Credito Credito,upper(pdd.uom) UOM,ps.qty,montante,cast(sum(prc_inss*vlr_item_custo*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_him,ps.item,num_pedido)) as Decimal(10,2)) INSS,
		(SELECT top 1 UF FROM endereco with(nolock) WHERE CD_pes=HOU.cd_consig_HIM and cd_tp_end = 'COM') UF
FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_MAR hou on hou.num_proc_hiM=cc.num_proc
--	Join IntFMC_Plano_Contas PC on miro.id_evento=PC.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx and cd_pes=cd_Export_hiM --and conta_credito is not null
	Join FMC_Plano_Contas_V2 PC on miro.id_evento=PC.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx 
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
	Join Pedido_ship PS on Ps.num_proc=num_proc_hiM and PS.cd_produto=CC.cd_produto and ps.cd_pedido=CC.cd_pedido
	Join Pedido_Det PDd on PDd.cd_pedido=PS.cd_pedido and PDd.cd_produto=PS.cd_produto and PS.lote=pdd.lote and ps.item=pdd.item
	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
--	Left Join Nota_Cliente NC on num_proc_hiM=NC.num_proc
--	Left Join Nota_Fiscal_Cliente_Det NDD on NC.id_nf=NDD.id_nf and NC.cd_cliente=Ndd.cd_Cliente and ps.cd_produto=NDD.cd_produto
where	
	cc.num_proc=@num_proc and PC.tipo=@tipo and miro.id_miro=@id_miro
group by 
	num_pedido,conta_debito,conta_credito,dbo.fBusca_PO_NumPedido(hou.num_proc_hiM,10) ,pdd.item,
	pdd.uom,ps.qty,montante, HOU.cd_consig_HIM


union all

SELECT Distinct
		pdd.item ITEM_NF, dbo.fBusca_PO_NumPedido(hou.num_proc_hia,10) Nota_Fiscal,
		pdd.item Item_Pedido,num_pedido,sum(vlr_item_custo*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_hia,ps.item,num_pedido)) Valor,
		conta_debito Debito, Conta_Credito Credito,upper(pdd.uom) UOM,ps.qty,montante,cast(sum(prc_inss*vlr_item_custo*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_hia,ps.item,num_pedido)) as Decimal(10,2)) INSS,
		(SELECT top 1 UF FROM endereco with(nolock) WHERE CD_pes=HOU.cd_consig_HIA and cd_tp_end = 'COM') UF
FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_aer hou on hou.num_proc_hia=cc.num_proc
--	Join IntFMC_Plano_Contas PC on miro.id_evento=PC.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx and cd_pes=cd_Export_hiM --and conta_credito is not null
	Join FMC_Plano_Contas_V2 PC on miro.id_evento=PC.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx 
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
	Join Pedido_ship PS on Ps.num_proc=num_proc_hia and PS.cd_produto=CC.cd_produto and  ps.cd_pedido=CC.cd_pedido

	Join Pedido_Det PDd on PDd.cd_pedido=PS.cd_pedido and PDd.cd_produto=PS.cd_produto and PS.lote=pdd.lote and ps.item=pdd.item
	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
--	Left Join Nota_Cliente NC on num_proc_hiM=NC.num_proc
--	Left Join Nota_Fiscal_Cliente_Det NDD on NC.id_nf=NDD.id_nf and NC.cd_cliente=Ndd.cd_Cliente and ps.cd_produto=NDD.cd_produto
where	
	cc.num_proc=@num_proc and PC.tipo=@tipo and miro.id_miro=@id_miro
group by 
	num_pedido,conta_debito,conta_credito,dbo.fBusca_PO_NumPedido(hou.num_proc_hia,10) ,pdd.item,
	pdd.uom,ps.qty,montante, HOU.cd_consig_HIA



Union All


SELECT Distinct
		pdd.item ITEM_NF, dbo.fBusca_PO_NumPedido(hou.num_proc_hio,10) Nota_Fiscal,
		pdd.item Item_Pedido,num_pedido,sum(vlr_item_custo*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_hio,ps.item,num_pedido)) Valor,
		conta_debito Debito, Conta_Credito Credito,upper(pdd.uom) UOM,ps.qty,montante,cast(sum(prc_inss*vlr_item_custo*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_hio,ps.item,num_pedido)) as Decimal(10,2)) INSS,
		(SELECT top 1 UF FROM endereco with(nolock) WHERE CD_pes=HOU.cd_consig_hio and cd_tp_end = 'COM') UF
FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_out hou on hou.num_proc_hio=cc.num_proc
--	Join IntFMC_Plano_Contas PC on miro.id_evento=PC.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx and cd_pes=cd_Export_hiM --and conta_credito is not null
	Join FMC_Plano_Contas_V2 PC on miro.id_evento=PC.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx 
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
	Join Pedido_ship PS on Ps.num_proc=num_proc_hio and PS.cd_produto=CC.cd_produto and ps.cd_pedido=CC.cd_pedido

	Join Pedido_Det PDd on PDd.cd_pedido=PS.cd_pedido and PDd.cd_produto=PS.cd_produto and PS.lote=pdd.lote and ps.item=pdd.item
	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
--	Left Join Nota_Cliente NC on num_proc_hiM=NC.num_proc
--	Left Join Nota_Fiscal_Cliente_Det NDD on NC.id_nf=NDD.id_nf and NC.cd_cliente=Ndd.cd_Cliente and ps.cd_produto=NDD.cd_produto
where	
	cc.num_proc=@num_proc and PC.tipo=@tipo and miro.id_miro=@id_miro
group by 
	num_pedido,conta_debito,conta_credito,dbo.fBusca_PO_NumPedido(hou.num_proc_hio,10) ,pdd.item,
	pdd.uom,ps.qty,montante, HOU.cd_consig_hio


--order by  num_pedido,pdd.item,credito

order by credito











GO
