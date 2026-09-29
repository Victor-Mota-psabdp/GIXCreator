SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Usuario_Acesso
CREATE VIEW [dbo].[vwUsuario_Acesso_Sel]
AS
Select
	US.Cd_Usuario	[User Code],
	US.Nome_Usuario	[User Name],
	TE.Cd_Tela		[Screen Code],
	TE.nome_tela	[Screen Name], 	
	leitura [Read], 
	gravacao [Write], 
	exclusao [Delete] 
From 
	usuario_acesso UA	with(nolock) 			
	Left join usuario US with(nolock) on US.cd_usuario=UA.cd_usuario
	Left join tela_atl TE with(nolock)  on TE.cd_tela=UA.cd_tela

GO
