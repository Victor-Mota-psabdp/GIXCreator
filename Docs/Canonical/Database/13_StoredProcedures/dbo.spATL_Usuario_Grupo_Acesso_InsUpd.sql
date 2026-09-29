SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Usuario_Grupo_Acesso
create PROCEDURE [dbo].[spATL_Usuario_Grupo_Acesso_InsUpd]
(
	@ID					BIGINT,
	@Cd_Pes_Grupo		VARCHAR(10),
	@Cd_Usuario_Grupo	VARCHAR(6),
	@Ativo				BIT,
	@Cd_Usuario			VARCHAR(6),
	@dt_ins				DATETIME
)
AS

Begin Transaction

	If  exists (select ID from Usuario_Grupo_Acesso where Cd_Pes_Grupo=@Cd_Pes_Grupo AND Cd_Usuario_Grupo= @Cd_Usuario_Grupo)
		Begin
			Update
				Usuario_Grupo_Acesso
			Set				
				Ativo = @Ativo,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = GETDATE()				
			Where
				Cd_Pes_Grupo=@Cd_Pes_Grupo AND Cd_Usuario_Grupo= @Cd_Usuario_Grupo
		End
	Else
		Begin
			Insert Usuario_Grupo_Acesso
				(Cd_Pes_Grupo,Cd_Usuario_Grupo,Ativo,Cd_Usuario,dt_ins)
			Values
				(@Cd_Pes_Grupo,@Cd_Usuario_Grupo,@Ativo,@Cd_Usuario,GETDATE())
		End

Commit Transaction

GO
