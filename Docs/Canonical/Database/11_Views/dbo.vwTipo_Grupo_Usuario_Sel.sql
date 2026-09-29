SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Grupo_Usuario_Sel]
AS
select 
	ID_Tp_GR_Usuario [Code], Nome_Tp_GR_Usuario [User Group Type Name]
from Tipo_Grupo_Usuario T with(nolock)

GO
