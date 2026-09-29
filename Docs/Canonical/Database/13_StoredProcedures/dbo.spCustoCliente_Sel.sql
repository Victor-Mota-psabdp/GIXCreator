SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spCustoCliente_Sel]
		
		@Cd_Pedido Int
as


Select 
		cd_proc_cliente,
		produto_descr,
		nome_tp_tx,
		 Sum(Vlr_Item_Custo) Valor from custo_cliente CC
		Join Produto_Cliente PC on PC.cd_prod=CC.cd_produto
		Join Tipo_Taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
Where 
		cd_pedido=@cd_pedido
group by 

	cd_proc_cliente,
	produto_descr,
	nome_tp_tx




GO
