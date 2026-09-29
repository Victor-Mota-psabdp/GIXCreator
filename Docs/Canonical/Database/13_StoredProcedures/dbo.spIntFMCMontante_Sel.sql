SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





create  Procedure [dbo].[spIntFMCMontante_Sel] 
		@Num_PRoc	Varchar(16),
		@ID_Miro	int,
		@Item		Varchar(30),
		@Num_Pedido	Varchar(50)
as	


SELECT 
		dt_envio, dbo.fBusca_TipoDocCliente('N',hou.num_proc_him,10) Nota_Fiscal,
		num_pedido,sum(vlr_item_custo*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_him,ps.item,num_pedido)) Valor,
		di.numero_po_him DI_Number,hou.num_proc_him, convert(float,[dbo].[fBusca_CampoCliente](hou.num_proc_him,31)) paridade,
		Sum(vlr_item_custo*Isnull(Prc_Inss,0)) INSS

FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_mar hou on hou.num_proc_him=cc.num_proc
	Join FMC_Plano_Contas_V2 PC on pc.cd_Tp_tx=cc.cd_tp_tx and miro.id_evento=pc.id_evento
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
	Join Pedido_ship PS on Ps.num_proc=num_proc_him and ps.cd_produto=cc.cd_produto
	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
	Left Join PO_HIM DI on DI.num_proc_him=hou.num_proc_him and DI.id_dc=5
	
where	
	cc.num_proc=@num_proc  and miro.id_miro=@id_miro
	and item=@item and num_pedido=@num_pedido
group by 
	num_pedido,dbo.fBusca_PO_NumPedido(hou.num_proc_him,10) ,
	dbo.fBusca_PO_NumPedido(hou.num_proc_him,5),
	dt_envio,hou.num_proc_him,di.numero_po_him 















GO
