SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Status_Retificacao
CREATE VIEW [dbo].[vwTipo_Status_Retificacao_Sel]
AS
select ID_Status AS Code,Status_Descricao AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
		Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Status_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario

GO
