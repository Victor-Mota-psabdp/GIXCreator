SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Alerta_Email_Doc_Automatico_Campos
CREATE PROCEDURE [dbo].[spATL_Alerta_Email_Doc_Automatico_Campos_InsUpd]
(
	@ID				BIGINT,
	@Nome_Campo		varchar(50),
	@Ativo			BIT,
	@Cd_Usuario		VARCHAR(6),
	@dt_ins			DATETIME
)

AS

Begin Transaction

	If  exists (select ID from Alerta_Email_Doc_Automatico_Campos where ID=@ID)
		Begin
			Update
				Alerta_Email_Doc_Automatico_Campos
			Set
				Nome_Campo=@Nome_Campo,
				Ativo = @Ativo,
				Cd_Usuario=@Cd_Usuario
				--,dt_ins = GETDATE()				
			Where
				ID=@ID
		End
	Else
		Begin
			Insert Alerta_Email_Doc_Automatico_Campos
				(Nome_Campo,Ativo,Cd_Usuario)
			Values
				(@Nome_Campo,@Ativo,@Cd_Usuario)
		End

Commit Transaction

GO
