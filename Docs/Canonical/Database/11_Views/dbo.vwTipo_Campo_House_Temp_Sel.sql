SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from ATL_INT.dbo.Tipo_Campo_House_Temp
--sp_help Tipo_Campo_House_Temp
CREATE VIEW [dbo].[vwTipo_Campo_House_Temp_Sel]
AS
		select 
			TT.ID_Campo [Code],TT.Descr_Campo [Field Description],TT.Ativo [Enabled],TT.Cd_Usuario [User Code],
			US.Nome_Usuario [User Name], TT.dt_ins [Insert Date]
		from 
			ATL_INT.dbo.Tipo_Campo_House_Temp TT with(nolock)
			left join Usuario US on US.Cd_Usuario = TT.Cd_Usuario		




GO
