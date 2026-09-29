SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spProdutoPedido_Sel '21294673', 'ROHM AND HAAS'
--spProdutoPedido_Sel 'AMOSTRA',  'TAMINCO MAU - 3982C'

CREATE Procedure [dbo].[spProdutoPedido_Sel]
	@NumPedido	varchar (30),
	@Cliente	varchar	(50)

As

Select 
	PC1.Cd_Proc_cliente ,PC2.Produto_Descr
From 
	Pedido P with(nolock)
left join Pedido_Det PD with(nolock) on P.Cd_Pedido =PD.Cd_Pedido
left join Produto_Cliente PC1 with(nolock) on PD.Cd_Produto = PC1.Cd_Prod
left join Pedido_Det PD2 with(nolock) on P.Cd_Pedido =PD2.Cd_Pedido
inner join Pessoa_LLP PL with(nolock) on PL.Cd_Pes = (select cd_Pes from pessoa where apelido = @Cliente) and pl.cd_pes = cd_buyer
left join Produto_Cliente PC2 with(nolock) on PD2.Cd_Produto = PC2.Cd_Prod and PL.cd_pes_grupo = PC2.Cd_cliente
Where 
	Num_Pedido = @NumPedido 
Group by 
	PC1.Cd_Proc_cliente, PC2.Produto_Descr
	
	--select * from Pessoa_LLP select * from Produto_cliente
GO
