SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTipo_Log_Oper_Sel]
AS
	select 
		Cd_Tp_Log_Oper [Code], 
		Nome_Tp_Log_Oper [Log Oper Type Name],
		Status [Enabled],
		T.Cd_Usuario [User Code],
		U.Nome_Usuario [User Name],
		dt_ins [Insert Date]
	from Tipo_Log_Oper T with(nolock)
		join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario

GO
