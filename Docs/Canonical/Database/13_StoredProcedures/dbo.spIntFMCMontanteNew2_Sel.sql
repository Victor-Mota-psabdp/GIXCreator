SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





















CREATE Procedure [dbo].[spIntFMCMontanteNew2_Sel] --'IMFMC201202004BR',700,'','0044228574','00010'
		@Num_PRoc	Varchar(16),
		@ID_Miro	int,
		@conta		Varchar(30),
		@Num_Pedido	Varchar(50),
		@item		varchar(30)
as	


Begin

Declare @FreteDI Float

Set @FreteDI=0
Set @FreteDi = Isnull(
	(
		select sum(Isnull(vlr_item_custo,0)*[dbo].[spBuscaPorcentagem_Pedido](@num_proc,@item,@Num_Pedido)) from custo_cliente CC 
		Join Pedido_Ship PS on PS.cd_pedido=CC.cd_pedido and CC.num_proc=PS.num_proc and CC.cd_produto=ps.cd_produto
		Join Pedido PD on PD.cd_pedido=PS.cd_pedido
		Where CC.num_proc=@Num_Proc and ITem=@ITem and Num_Pedido=@Num_Pedido
		and cd_Tp_Tx in ('YDI','XDU')
	),0)


SELECT 
		dt_envio, dbo.fBusca_TipoDocCliente('N',hou.num_proc_him,10) Nota_Fiscal,
		num_pedido,sum(vlr_item_custo*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_him,ps.item,num_pedido)) Valor,
		di.numero_po_him DI_Number,hou.num_proc_him, convert(float,[dbo].[fBusca_CampoCliente](hou.num_proc_him,31)) paridade,
		Sum(vlr_item_custo*Isnull(Prc_Inss,0)*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_him,ps.item,num_pedido)) INSS,
		@FreteDI FreteDI

FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_mar hou on hou.num_proc_him=cc.num_proc
	Join FMC_Plano_Contas_V2 PC on pc.cd_Tp_tx=cc.cd_tp_tx and miro.id_evento=pc.id_evento
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
	Join Pedido_ship PS on Ps.num_proc=num_proc_him and ps.cd_produto=cc.cd_produto and ps.cd_pedido=CC.cd_pedido
	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
	Left Join PO_HIM DI on DI.num_proc_him=hou.num_proc_him and DI.id_dc=5
	
where	
	cc.num_proc=@num_proc  and miro.id_miro=@id_miro
	and  num_pedido=@num_pedido 
	--and (conta_credito=@conta or conta_debito=@conta or pc.cd_tp_tx='XDU')
	and ps.item=@item 
	and montante='S' and conta_credito is not null
group by 
	num_pedido,dbo.fBusca_PO_NumPedido(hou.num_proc_him,10) ,
	dbo.fBusca_PO_NumPedido(hou.num_proc_him,5),
	dt_envio,hou.num_proc_him,di.numero_po_him 


UNION 

SELECT 
		dt_envio, dbo.fBusca_TipoDocCliente('N',hou.num_proc_hia,10) Nota_Fiscal,
		num_pedido,sum(vlr_item_custo*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_hia,ps.item,num_pedido)) Valor,
		di.numero_po_hia DI_Number,hou.num_proc_hia, convert(float,[dbo].[fBusca_CampoCliente](hou.num_proc_hia,31)) paridade,
		Sum(vlr_item_custo*Isnull(Prc_Inss,0)*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_hia,ps.item,num_pedido)) INSS,
		@FreteDI FreteDI

FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_aer hou on hou.num_proc_hia=cc.num_proc
	Join FMC_Plano_Contas_V2 PC on pc.cd_Tp_tx=cc.cd_tp_tx and miro.id_evento=pc.id_evento
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
	Join Pedido_ship PS on Ps.num_proc=num_proc_hia and ps.cd_produto=cc.cd_produto and PS.cd_pedido=cc.cd_pedido
	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
	Left Join PO_hia DI on DI.num_proc_hia=hou.num_proc_hia and DI.id_dc=5
	
where	
	cc.num_proc=@num_proc  and miro.id_miro=@id_miro
	and  num_pedido=@num_pedido 
	--and (conta_credito=@conta or conta_debito=@conta or pc.cd_tp_tx='XDU')
	and ps.item=@item 
	and montante='S' and conta_credito is not null
group by 
	num_pedido,dbo.fBusca_PO_NumPedido(hou.num_proc_hia,10) ,
	dbo.fBusca_PO_NumPedido(hou.num_proc_hia,5),
	dt_envio,hou.num_proc_hia,di.numero_po_hia 

Union 



SELECT 
		dt_envio, dbo.fBusca_TipoDocCliente('N',hou.num_proc_hio,10) Nota_Fiscal,
		num_pedido,sum(vlr_item_custo*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_hio,ps.item,num_pedido)) Valor,
		di.numero_po_hio DI_Number,hou.num_proc_hio, convert(float,[dbo].[fBusca_CampoCliente](hou.num_proc_hio,31)) paridade,
		Sum(vlr_item_custo*Isnull(Prc_Inss,0)*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_hio,ps.item,num_pedido)) INSS,
		@FreteDI FreteDI

FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_out hou on hou.num_proc_hio=cc.num_proc
	Join FMC_Plano_Contas_V2 PC on pc.cd_Tp_tx=cc.cd_tp_tx and miro.id_evento=pc.id_evento
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
	Join Pedido_ship PS on Ps.num_proc=num_proc_hio and ps.cd_produto=cc.cd_produto and ps.cd_pedido=CC.cd_pedido
	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
	Left Join PO_hio DI on DI.num_proc_hio=hou.num_proc_hio and DI.id_dc=5
	
where	
	cc.num_proc=@num_proc  and miro.id_miro=@id_miro
	and  num_pedido=@num_pedido 
	--and (conta_credito=@conta or conta_debito=@conta or pc.cd_tp_tx='XDU')
	and ps.item=@item 
	and montante='S' and conta_credito is not null
group by 
	num_pedido,dbo.fBusca_PO_NumPedido(hou.num_proc_hio,10) ,
	dbo.fBusca_PO_NumPedido(hou.num_proc_hio,5),
	dt_envio,hou.num_proc_hio,di.numero_po_hio 

end





















GO
