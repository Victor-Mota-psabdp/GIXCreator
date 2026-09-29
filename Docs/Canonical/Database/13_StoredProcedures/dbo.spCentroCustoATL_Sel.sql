SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spCentroCustoATL_Sel] 

as

select distinct
	CC.Nome_centro_custo		
from  centro_custo_site CCS
	join site S on S.cd_site = CCS.site
	join centro_custo CC on CC.cd_centro_custo = CCS.cd_centro_custo
GO
