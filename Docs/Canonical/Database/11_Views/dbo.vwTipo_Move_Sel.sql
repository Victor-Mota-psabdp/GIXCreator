SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Move_Sel]
AS
	select 
		Cd_Tp_Move [Code], 
		Nome_Tp_Move [Move Type Name],
		Status [Enabled],
		T.Cd_Usuario [User Code],
		U.Nome_Usuario [User Name],
		dt_ins [Insert Date]
	from Tipo_Move T with(nolock)
		join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario

GO
