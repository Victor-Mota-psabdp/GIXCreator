SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Usuario_Retificacao
CREATE VIEW [dbo].[vwTipo_Usuario_Retificacao_Sel]
AS
	select ID_TP_USUARIO_RET AS Code,Nome_TP_USUARIO_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
		Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Usuario_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario

GO
