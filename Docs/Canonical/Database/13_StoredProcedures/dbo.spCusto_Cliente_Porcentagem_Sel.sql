SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCusto_Cliente_Porcentagem_Sel]--'EASLA21510001BR'
(
	@JOB VarChar(16)
)
AS	
select distinct	
	--PS.cd_pedido,PS.cd_produto,
	P.num_pedido cmbOrdCusto,
	PC.cd_proc_cliente cmbProdCusto,
	PC.produto_descr lblProdDescCusto,
	--[dbo].[fBuscaPorcentagem_CdProduto] (PS.num_proc,PS.cd_produto) Porcentagem
	[dbo].[fBuscaPorcentagem_PedidoProdutoCusto](PS.num_proc,PS.cd_pedido,PS.cd_produto) Porcentagem 
from pedido_ship PS  
	Join Pedido P on PS.Cd_Pedido = P.Cd_Pedido 
	Join Produto_Cliente PC on PS.cd_produto=PC.cd_prod 	
Where 
	PS.num_proc = @JOB

 

GO
