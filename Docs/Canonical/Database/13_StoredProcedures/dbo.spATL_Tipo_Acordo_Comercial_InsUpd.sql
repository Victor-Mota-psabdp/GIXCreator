SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Acordo_Comercial
CREATE PROCEDURE [dbo].[spATL_Tipo_Acordo_Comercial_InsUpd]
(
	@ID_TP_AC		BIGINT,
	@NOME_TP_AC		VARCHAR(MAX),
	@Ativo			BIT,
	@Cd_Usuario		VARCHAR(6),
	@dt_ins			DATETIME
)

AS

Begin Transaction

	If  exists (select ID_TP_AC from Tipo_Acordo_Comercial where ID_TP_AC=@ID_TP_AC)
		Begin
			Update
				Tipo_Acordo_Comercial
			Set
				NOME_TP_AC=@NOME_TP_AC,
				Ativo = @Ativo,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = GETDATE()				
			Where
				ID_TP_AC=@ID_TP_AC
		End
	Else
		Begin
			Insert Tipo_Acordo_Comercial
				(NOME_TP_AC,Ativo,Cd_Usuario,dt_ins)
			Values
				(@NOME_TP_AC,@Ativo,@Cd_Usuario,GETDATE())
		End

Commit Transaction

GO
