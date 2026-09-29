SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Data
CREATE VIEW [dbo].[vwTipo_Data_Sel]
AS
Select ID_Tp_Data [Code], Nome_Tp_Data [Type Date Name] from Tipo_Data	with(nolock)





GO
