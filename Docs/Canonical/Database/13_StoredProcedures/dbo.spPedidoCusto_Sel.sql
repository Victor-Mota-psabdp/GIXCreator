SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--spPedidoCusto_Sel 'EOARG20080601101'


CREATE  Procedure [dbo].[spPedidoCusto_Sel] --'IMCSR20080302101'
	@Processo VarChar(16)
as	

SELECT 
	P.Num_pedido, PC.Cd_Proc_Cliente, PC.Produto_Descr, TT.Nome_Tp_Tx, CC.Vlr_Item_Custo , CC.Prestacao, Retencao, Ganancias, Tipo, Tipo_Debito, CUIT
FROM 
	Custo_Cliente CC
	Join Pedido P on P.Cd_pedido = CC.Cd_Pedido
	Join Produto_Cliente PC on PC.cd_prod=CC.cd_produto
	Join Tipo_Taxa	TT on TT.Cd_Tp_Tx=CC.Cd_Tp_Tx
	Left Join Custo_Cliente_ARG CCA on CCA.Num_Proc=CC.Num_Proc and CCA.Cd_Pedido=CC.Cd_Pedido and CCA.Cd_Produto=CC.Cd_Produto and CCA.Cd_Tp_tx=CC.Cd_Tp_tx
where 
	CC.Num_Proc=@Processo








GO
