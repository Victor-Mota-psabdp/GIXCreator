SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Range_CP_Sel]
AS
	select 
		Cd_Range [Code], Range_Descricao [Range Type Name],Modal [Modal]
	from Tipo_Range_CP T with(nolock)

GO
