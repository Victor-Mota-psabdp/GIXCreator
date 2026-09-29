SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Usuario_Acesso_Del]--'','','B'
(
	@Cd_usuario	varchar(6),
	--@Nome_Usuario	varchar(30),
	@Cd_Tela varchar(3)
	--@Nome_Tela		varchar(50)
)
as

	BEGIN
		delete Usuario_Acesso where Cd_Tela= @Cd_Tela AND Cd_usuario = @Cd_usuario
	End

GO
