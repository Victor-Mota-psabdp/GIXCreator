SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spDANFEBuscaPedido_Sel
		@Num_Proc	Varchar(16)

aS

select num_pedido from pedido_ship PS with(nolock)
join pedido P with(nolock) on P.cd_pedido=PS.cd_pedido
where PS.num_proc=@Num_Proc
GO
