SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--sp_help Tipo_De_Para
CREATE VIEW [dbo].[vwTipo_De_Para_Sel]
AS
		select 
			Cd_Tipo			[Code],
			NOME_Tipo		[Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_De_Para T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario




GO
