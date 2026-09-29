SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Armador
CREATE procedure [dbo].[spATL_Tipo_Operador_Portuario_Del]
(
	@ID_OP			Int
)
as

	If  exists (select ID_OP from Tipo_Operador_Portuario where ID_OP=@ID_OP)
		Begin
			UPDATE Tipo_Operador_Portuario SET Ativo = 0 where ID_OP=@ID_OP
		End

GO
