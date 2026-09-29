SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Usuario_Acesso_Sel]--'','','B'
(
	@Cd_usuario	varchar(6),
	@Cd_Tela	varchar(3),
	@Tipo			char(1)
)
as


/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

IF @Tipo = 'A' 
	Begin
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
	End
	
IF @Tipo = 'B'
	Begin
		Select 
			US.Cd_Usuario	[User Code],
			US.Nome_Usuario	[User Name],
			TE.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name], 	
			leitura [Read], 
			gravacao [Write], 
			exclusao [Delete] 
		From 
			Usuario_Acesso UA	with(nolock) 			
			Left join Usuario US with(nolock) on US.cd_usuario=UA.cd_usuario
			Left join Tela_ATL TE with(nolock)  on TE.cd_tela=UA.cd_tela
		Where
			US.Ck_Ativo = 1	
	End
	
IF @Tipo = 'C'
	Begin
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
		Where
			UA.cd_usuario = @cd_usuario			
	End
	
IF @Tipo = 'D'
	Begin		
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
		Where
			UA.cd_usuario = @cd_usuario	
			and US.Ck_Ativo = 1	
	End
	
IF @Tipo = 'N'
	Begin
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
		Where
			UA.cd_tela = @cd_tela
			
	End
	
IF @Tipo = 'O'
	Begin
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
		Where
			UA.cd_tela = @cd_tela
			and US.Ck_Ativo = 1 
	End

IF @Tipo = 'P'
	Begin
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
		Where
			UA.cd_usuario = @cd_usuario	 and 
			UA.cd_tela = @cd_tela
	End
	
--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		Select 
--			US.nome_usuario [User Name],
--			TE.nome_tela [Screen Name],	
--			leitura [Read], 
--			gravacao [Write], 
--			exclusao [Delete] 
--		From 
--			usuario_acesso UA	with(nolock) 			
--			Left join usuario US with(nolock) on US.cd_usuario=UA.cd_usuario
--			Left join tela_atl TE with(nolock)  on TE.cd_tela=UA.cd_tela
--		Where
--			UA.Cd_usuario = @Cd_usuario AND UA.Cd_Tela <> @Cd_Tela
--		Order by 1
--	End

GO
