SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Operador_Portuario
CREATE VIEW [dbo].[vwATL_Tipo_Operador_Portuario_Sel]
AS
	SELECT
			T.ID_OP			[Code],
			T.Descricao_OP	[Port Operator Name] ,
			T.Ativo			[Enabled],
			T.Dt_Criacao	[Created Date],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name]
		FROM 
			Tipo_Operador_Portuario T with(nolock)
			left JOIN Usuario U with(nolock) on U.Cd_Usuario = T.Cd_Usuario


GO
