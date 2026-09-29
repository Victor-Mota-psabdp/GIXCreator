SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spTipo_Pedido_Sel]

as
		select cd_tp_pedido + ' - ' + nome_tp_pedido 
			from [dbo].[Tipo_Pedido]
	
	

GO
