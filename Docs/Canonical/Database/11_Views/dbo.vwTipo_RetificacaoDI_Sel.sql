SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_RetificacaoDI
CREATE VIEW [dbo].[vwTipo_RetificacaoDI_Sel]
AS
	select ID_TP_RET AS Code,NOME_TP_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
	from Tipo_RetificacaoDI DI with(nolock)
	left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario

GO
