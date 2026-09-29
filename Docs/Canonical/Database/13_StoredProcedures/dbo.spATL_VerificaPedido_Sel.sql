SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[spATL_VerificaPedido_Sel] --'EMCSR20080206301', '42125758'
	
	@JOB varchar(16),
	@NumPedido varchar(30)

as

	select 
		PD.Num_Pedido 
	from 
		Pedido_Ship PS with(nolock)
	join Pedido PD with(nolock) on PS.Cd_Pedido = PD.Cd_Pedido
	where PS.Num_proc = @JOB and PD.Num_Pedido = @NumPedido
	OPTION(HASH JOIN)
GO
