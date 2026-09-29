SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_De_Para
CREATE PROCEDURE [dbo].[spATL_Tipo_De_Para_InsUpd]
(
	@Cd_Tipo		int,
	@NOME_Tipo		varchar(100),
	@Ativo			BIT,
	@Cd_Usuario		VARCHAR(10),
	@dt_ins			DATETIME
)

AS

Begin Transaction

	If  exists (select Cd_Tipo from Tipo_De_Para where Cd_Tipo=@Cd_Tipo)
		Begin
			Update
				Tipo_De_Para
			Set
				NOME_Tipo=@NOME_Tipo,
				Ativo = @Ativo,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = GETDATE()				
			Where
				Cd_Tipo=@Cd_Tipo
		End
	Else
		Begin
			Insert Tipo_De_Para
				(NOME_Tipo,Ativo,Cd_Usuario,dt_ins)
			Values
				(@NOME_Tipo,@Ativo,@Cd_Usuario,GETDATE())
		End

Commit Transaction

GO
