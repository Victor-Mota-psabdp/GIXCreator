SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Alerta_Email_Doc_Automatico_Campos
CREATE procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_Campos_Del]
(
	@ID BIGINT
)
as
	If  exists (select ID from Alerta_Email_Doc_Automatico_Campos where ID=@ID)
		Begin
			UPDATE Alerta_Email_Doc_Automatico_Campos SET ATIVO= 0 where ID= @ID
	END

GO
