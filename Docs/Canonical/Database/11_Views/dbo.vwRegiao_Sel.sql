SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwRegiao_Sel]
AS
select 
	Cd_Regiao [Code], Nome_Regiao [Region Name]
from Regiao T with(nolock)

GO
