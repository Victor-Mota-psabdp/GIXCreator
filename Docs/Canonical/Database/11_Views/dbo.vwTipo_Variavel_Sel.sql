SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Variavel_Sel]
AS
select 
	Cd_Tipo AS Code,
	Nome_Tipo AS [Type Name] 
from Tipo_Variavel with(nolock)

GO
