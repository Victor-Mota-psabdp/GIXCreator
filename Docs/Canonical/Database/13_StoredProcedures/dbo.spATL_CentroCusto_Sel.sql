SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spATL_CentroCusto_Sel]--'ALL','ALL' 
(
@Nome_Centro_Custo		VarChar(30),
@Nome_site				varchar(30)
)

AS
	if @Nome_Centro_Custo = ''
		set @Nome_Centro_Custo = '%'
	if @Nome_site = ''
		set @Nome_site = '%'	

	select 
		CC.Nome_centro_custo	[Centro Custo],
		S.nome_site				[Cidade], 
		CCS.particip			[Participação]
	from  centro_custo_site CCS
		join site S on S.cd_site = CCS.site
		join centro_custo CC on CC.cd_centro_custo = CCS.cd_centro_custo
	where 
		CC.Nome_centro_custo like @Nome_Centro_Custo 
		and nome_site like @Nome_site 
	
order by Nome_centro_custo

GO
