SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Nivel_Acesso
CREATE VIEW [dbo].[vwATL_Nivel_Acesso_Sel]
AS
	--Select 
	--	US.Nome_Area [Department Name],
	--	TE.nome_tela [Screen Name],
	--	N.tipo_nivel [Level Name]
	Select 
			NA.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			NA.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],
			NA.Cd_Nivel		[Level Code],
			N.tipo_nivel	[Level Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
	From 
		Nivel_Acesso NA	with(nolock) 			
		Left join Area US with(nolock) on US.Cd_Area=NA.Cd_Area
		Left join tela_atl TE with(nolock)  on TE.cd_tela=NA.cd_tela
		left join nivel N with(nolock) on N.cd_nivel=NA.cd_nivel

GO
