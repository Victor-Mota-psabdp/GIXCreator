SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_LI
CREATE VIEW [dbo].[vwTipo_LI_Product_CHB_Sel]
AS
	Select ID_Tipo [Code], LEFT(Nome_Tp_LI,3) [Type of LI] from Tipo_LI
	where 
	ID_Tipo IN (2,3)


GO
