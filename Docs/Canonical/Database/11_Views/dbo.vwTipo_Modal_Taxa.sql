SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--vwTipo_Modal_Taxa
--    .AddItem ("A - Air")
--    .AddItem ("M - Ocean")
--    .AddItem ("O - Others")
--    .AddItem ("T - All Modals")
CREATE VIEW [dbo].[vwTipo_Modal_Taxa]
AS
select 'A' [Code], 'Air' [Modal_Type_Name] union all
select 'M' [Code], 'Ocean' [Modal_Type_Name]union all
select 'O' [Code], 'Others' [Modal_Type_Name] union all
select 'T' [Code], 'All Modals' [Modal_Type_Name]

GO
