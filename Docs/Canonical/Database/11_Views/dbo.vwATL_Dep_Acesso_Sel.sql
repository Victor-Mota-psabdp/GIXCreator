SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Dep_Acesso
CREATE VIEW [dbo].[vwATL_Dep_Acesso_Sel]
AS
	Select 
			US.Cd_Area		[Department Code],
			US.Nome_Area	[Department Name],
			TE.Cd_Tela		[Screen Code],
			TE.nome_tela	[Screen Name],	
			leitura			[Read], 
			gravacao		[Write], 
			exclusao		[Delete] 
		From 
			Dep_Acesso UA	with(nolock) 			
			Left join Area US with(nolock) on US.Cd_Area=UA.Cd_Area
			Left join tela_atl TE with(nolock)  on TE.cd_tela=UA.cd_tela


GO
