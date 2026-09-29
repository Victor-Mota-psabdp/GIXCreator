SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwUsuario_Grupo_Acesso_Sel]
AS

select 
			ID						[Code],
			T.Cd_Usuario_Grupo		[User Group Code],
			U.Nome_Usuario			[User Group Name],
			T.cd_pes_grupo			[Group Code],
			P.Apelido				[Group Name],
			Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			dt_ins					[Insert Date]
		from Usuario_Grupo_Acesso T with(nolock)
			join Usuario UG with(nolock) on UG.Cd_Usuario=T.Cd_Usuario_Grupo
			join Pessoa P with(nolock) on P.Cd_Pes = T.cd_pes_grupo
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario

GO
