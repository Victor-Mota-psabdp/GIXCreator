SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Status_Processo
create procedure [dbo].[spATL_Tipo_Status_Processo_Del]
(
	@ID_Status as int
)

as

If  exists (select ID_Status from Tipo_Status_Processo where ID_Status=ID_Status)
	Begin
		UPDATE Tipo_Status_Processo SET Ativo = 0 where ID_Status=@ID_Status
	End

GO
