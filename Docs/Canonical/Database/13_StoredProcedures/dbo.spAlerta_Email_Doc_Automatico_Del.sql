SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAlerta_Email_Doc_Automatico_Del]
(
	@ID_Alerta	BigInt
)

AS

Begin Transaction

If Exists(Select ID_Alerta from Alerta_Email_Doc_Automatico where ID_Alerta = @ID_Alerta)
	Begin
		Delete Alerta_Email_Doc_Automatico where ID_Alerta = @ID_Alerta
	End

			
Commit Transaction
GO
