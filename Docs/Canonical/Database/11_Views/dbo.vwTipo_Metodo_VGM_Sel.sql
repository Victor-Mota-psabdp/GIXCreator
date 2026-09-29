SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Metodo_VGM
CREATE VIEW [dbo].[vwTipo_Metodo_VGM_Sel]
AS
Select ID_Metodo_VGM [Code], Nome_Metodo_VGM [VGM Method Name] from Tipo_Metodo_VGM	with(nolock)

GO
