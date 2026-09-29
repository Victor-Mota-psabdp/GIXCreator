SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Grupo
CREATE VIEW [dbo].[vwATLDN_Grupo_Sel]
AS
	Select
			G.Cd_Pes_Grupo		[Code],
			P.Apelido			[Group Name], 
			G.Grupo				[Group],
			Unit				[Unit],
			Smart_IMP			[Smart IMP],
			Smart_EXP			[Smart EXP],			
			Admin				[Administrator],			
			AX_GRUPO			[AX Group],
			U.Nome_Usuario		[Group Responsible]		 
		From 
			Grupo G	with(nolock) 			
			join Pessoa P with(nolock) on P.Cd_Pes=G.Cd_Pes_Grupo
			left join Usuario U  with(nolock) on U.Cd_Usuario=G.Responsavel







GO
