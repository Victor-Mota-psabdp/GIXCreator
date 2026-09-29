SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spPrestCC_REL_Produto_Rel]

	@job varchar(16)
as

select
	PC.produto_descr [Produto]	
from
	pedido_ship PS with(nolock)
	Join Produto_Cliente PC	with(nolock) on PC.cd_prod=Ps.cd_produto	
where
	PS.num_proc = @job




GO
