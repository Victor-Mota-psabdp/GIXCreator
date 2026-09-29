SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spHBO_BuscaPorcentagem_Sel]
(
	@Num_proc varchar(16)
)
As
 select distinct cd_pedido,cd_produto,
 [dbo].[fBuscaPorcentagem_PedidoProdutoCusto](num_proc,cd_pedido,cd_produto) Porcentagem ,
 'S'
 from 
 pedido_ship  with(nolock)
 where num_proc=@Num_proc
GO
