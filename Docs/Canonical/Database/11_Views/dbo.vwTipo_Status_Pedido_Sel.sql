SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Status_Pedido_Sel]
AS
	SELECT Cd_Tp_Status_Pedido AS Code,Nome_Tp_Status_Pedido AS [Status Type Name]
		from Tipo_Status_Pedido with(nolock)

GO
