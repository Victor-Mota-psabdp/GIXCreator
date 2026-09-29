SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_E_Mix_Consulta_Tipo_Del]
(
	@ID_Consulta_Tipo int
)
as
	If  exists (select ID_Consulta_Tipo from E_Mix_Consulta_Tipo where ID_Consulta_Tipo=@ID_Consulta_Tipo)
	BEGIN
		delete E_Mix_Consulta_Tipo where ID_Consulta_Tipo=@ID_Consulta_Tipo
	END

GO
