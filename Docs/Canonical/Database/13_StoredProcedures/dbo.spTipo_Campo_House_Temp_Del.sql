SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Campo_House_Temp
CREATE procedure [dbo].[spTipo_Campo_House_Temp_Del]
(
		@ID_Campo		int
)
as
if exists(select ID_Campo from ATL_INT.dbo.Tipo_Campo_House_Temp where ID_Campo= @ID_Campo)
	begin
		update ATL_INT.dbo.Tipo_Campo_House_Temp set ATIVO = 0 where @ID_Campo= @ID_Campo
	end
GO
