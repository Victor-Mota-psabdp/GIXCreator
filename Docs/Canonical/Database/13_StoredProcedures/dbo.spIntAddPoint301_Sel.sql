SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spIntAddPoint301_Sel
	@Num_Proc	varchar(16)
	
as

select campo_dados Numero from campo_ordem CO with(nolock)
Join Pedido_Ship PS with(nolock) on PS.cd_pedido=CO.cd_pedido
Where num_proc=@num_proc and id_campo=900
GO
