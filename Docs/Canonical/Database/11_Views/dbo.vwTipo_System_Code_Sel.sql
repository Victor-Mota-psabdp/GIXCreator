SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_System_Code_Sel]
AS
	select 
			T.ID_System_Code		[Code],
			T.Name_System_Code	[System Code Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]
		from ATL_INT.dbo.Tipo_System_Code T with(nolock)
			join ATLANTIS.dbo.Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	

GO
