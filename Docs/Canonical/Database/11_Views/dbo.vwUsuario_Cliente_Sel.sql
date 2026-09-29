SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Usuario_Cliente
CREATE VIEW [dbo].[vwUsuario_Cliente_Sel]
AS
	SELECT
		A.Cd_Usuario	[Code],
		A.Nome_Usuario	[User Name] ,
		A.Email			[Email],
		A.Ativo			[Enabled],
		A.Plasticos		[Plastics],
		A.dt_ins		[Created Date],
		A.Cd_Cliente	[Group Code],
		U.Apelido		[Group Name]
	FROM Usuario_Cliente A with(nolock)
		LEFT JOIN Pessoa U on U.Cd_Pes = A.Cd_Cliente

GO
