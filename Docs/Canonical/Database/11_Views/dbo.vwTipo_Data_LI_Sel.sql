SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Data_LI
CREATE VIEW [dbo].[vwTipo_Data_LI_Sel]
AS
Select ID_Tp_Data [Code], Nome_Tp_Data [Type Date LI Name] from Tipo_Data_LI	with(nolock)

GO
