SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Grupo_Acesso
CREATE VIEW [dbo].[vwATL_Grupo_Acesso_Sel]
AS
	Select 			
			GA.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],
			GA.Cd_Pes_Grupo	[Level Code],
			P.Apelido		[Level Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Grupo_Acesso GA	with(nolock) 			
			Left join tela_atl TE with(nolock)  on TE.cd_tela=GA.Cd_Tela
			left join Pessoa P with(nolock) on P.cd_pes=GA.cd_pes_grupo


GO
