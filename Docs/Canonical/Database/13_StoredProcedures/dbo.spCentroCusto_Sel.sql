SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spCentroCusto_Sel '%','São Paulo%'


CREATE PROCEDURE [dbo].[spCentroCusto_Sel] 
(
@Nome_Centro_Custo		VarChar(30),
@Nome_site				varchar(30)
)

AS	

	select 
		CC.Nome_centro_custo, S.nome_site, CCS.particip, CC.cd_conta_c 
	from  centro_custo_site CCS
		join site S on S.cd_site = CCS.site
		join centro_custo CC on CC.cd_centro_custo = CCS.cd_centro_custo
	where CC.Nome_centro_custo like @Nome_Centro_Custo and nome_site like @Nome_site 
	
order by Nome_centro_custo

GO
