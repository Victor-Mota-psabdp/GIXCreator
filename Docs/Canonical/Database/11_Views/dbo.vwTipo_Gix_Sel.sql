SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Gix
CREATE VIEW [dbo].[vwTipo_Gix_Sel]
AS
	select 
		Cd_Tp_Gix [Code], Nome_Tp_Gix [GIX Type Name], Regra [Stored Rules]
	from 
		Tipo_Gix T with(nolock)

GO
