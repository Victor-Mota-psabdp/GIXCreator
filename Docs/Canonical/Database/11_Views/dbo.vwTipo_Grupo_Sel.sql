SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Grupo
CREATE VIEW [dbo].[vwTipo_Grupo_Sel]
AS
select 
	Cd_Tp_Grupo [Code], Nome_Tp_Grupo [Group Type Name]
from 
	Tipo_Grupo T with(nolock)

GO
