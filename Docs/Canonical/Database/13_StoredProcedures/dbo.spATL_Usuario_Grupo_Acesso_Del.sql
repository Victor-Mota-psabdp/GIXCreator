SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Usuario_Grupo_Acesso
CREATE procedure [dbo].[spATL_Usuario_Grupo_Acesso_Del]
(
	@Cd_Pes_Grupo		VARCHAR(10),
	@Cd_Usuario_Grupo	VARCHAR(6)
)
as
	If  exists (select ID from Usuario_Grupo_Acesso where Cd_Pes_Grupo=@Cd_Pes_Grupo AND Cd_Usuario_Grupo= @Cd_Usuario_Grupo)
		Begin
			UPDATE Usuario_Grupo_Acesso SET ATIVO= 0 where Cd_Pes_Grupo=@Cd_Pes_Grupo AND Cd_Usuario_Grupo= @Cd_Usuario_Grupo
		End

GO
