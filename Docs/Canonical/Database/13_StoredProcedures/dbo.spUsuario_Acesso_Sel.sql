SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spUsuario_Acesso_Sel] --'002','csr'

	@cd_Tela varchar(3),
	@cd_usuario varchar(6)

as
	
	Select 
		US.nome_usuario nome_usuario,
		TE.nome_tela nome_tela,	
		leitura, 
		gravacao, 
		exclusao 
	From 
		usuario_acesso UA	with(nolock) 			
		Left join usuario US with(nolock) on US.cd_usuario=UA.cd_usuario
		Left join tela_atl TE with(nolock)  on TE.cd_tela=UA.cd_tela
	Where
		UA.cd_tela = @cd_tela and UA.cd_usuario = @cd_usuario


GO
