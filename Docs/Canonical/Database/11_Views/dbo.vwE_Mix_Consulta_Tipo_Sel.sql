SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwE_Mix_Consulta_Tipo_Sel]
AS

select ID_Consulta_Tipo AS Code,Nome_Consulta_Tipo AS [Type Name] from E_Mix_Consulta_Tipo with(nolock)
	

GO
