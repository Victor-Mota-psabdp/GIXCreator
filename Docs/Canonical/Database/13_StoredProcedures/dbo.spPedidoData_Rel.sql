SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE Procedure [dbo].[spPedidoData_Rel]

as

select * from data_pedidos DP with(nolock)
Join Tipo_Referencia TR on TR.id_ref=DP.id_ref


GO
