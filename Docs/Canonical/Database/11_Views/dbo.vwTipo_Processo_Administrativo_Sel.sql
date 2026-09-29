SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Processo_Administrativo
CREATE VIEW [dbo].[vwTipo_Processo_Administrativo_Sel]
AS
	select Id_Tp_Proc_Adm AS Code,Nome_Tp_Proc_Adm AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
	from Tipo_Processo_Administrativo DI with(nolock)
	left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario

GO
