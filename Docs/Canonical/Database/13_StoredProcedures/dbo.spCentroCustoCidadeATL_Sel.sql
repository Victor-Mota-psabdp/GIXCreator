SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spCentroCustoCidadeATL_Sel] 

as

select distinct
	S.nome_site		
from  centro_custo_site CCS
	join site S on S.cd_site = CCS.site
GO
