SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwIntegrationExcel_Add_Ref_Type_Sel]
AS
SELECT '1' AS Code,'Terminal' AS [Tipo],'Terminal' as [Tabela Relacionada]
union all
SELECT '2' AS Code,'Inland Trucker' AS [Carga],'Pessoa' as [Tabela Relacionada]




GO
