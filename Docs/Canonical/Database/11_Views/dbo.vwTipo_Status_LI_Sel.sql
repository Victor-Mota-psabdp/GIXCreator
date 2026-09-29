SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Status_LI
CREATE VIEW [dbo].[vwTipo_Status_LI_Sel]
AS
select ID_Status_LI [Code], Status_LI_Descricao [Status LI Description] from Tipo_Status_LI

GO
