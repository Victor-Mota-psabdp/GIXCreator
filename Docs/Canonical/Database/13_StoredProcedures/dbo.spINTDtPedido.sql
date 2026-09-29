SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spINTDtPedido]
		@Num_Proc	VarChar(16)

as


select top 1 Dt_pedido from pedido_ship PS with(nolock)
Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido
where num_proc=@num_proc
group by Dt_pedido 



GO
