SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Servico_CP_Sel]
AS
select 
	Cd_Tipo_Servico [Code], Descr_Servico [Type of Service Name]
from Tipo_Servico_CP T with(nolock)

GO
