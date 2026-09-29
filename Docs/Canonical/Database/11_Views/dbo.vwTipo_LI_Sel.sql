SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_LI
CREATE VIEW [dbo].[vwTipo_LI_Sel]
AS
Select ID_Tipo [Code], Nome_Tp_LI [Type of LI] from Tipo_LI	with(nolock)

GO
