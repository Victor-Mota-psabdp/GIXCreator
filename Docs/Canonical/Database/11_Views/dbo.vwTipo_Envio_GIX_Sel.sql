SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Envio_GIX
CREATE VIEW [dbo].[vwTipo_Envio_GIX_Sel]
AS
	select 
			Cd_Tp_EnvioGix [Code], Nome_Tp_EnvioGix [Gix Send Type Name]
		from 
			Tipo_Envio_GIX T with(nolock)

GO
