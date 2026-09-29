SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Frete_Sel]
AS
select 
	Cd_Tp_Frete [Code], Nome_Tp_Frete [Freight Type Name]
from 
	Tipo_Frete T with(nolock)

GO
