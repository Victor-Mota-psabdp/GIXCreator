SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spNF2SAP_Rel]
	@Num_Proc varchar(16),
	@nNF varchar(20)
as
	select TOP 1
		left(nDI,2) + '/' + substring(nDI,3,7) + '-' + right(nDI,1) [Número da DI],
		T.vPIS [Valor Total do PIS],
		T.vCofins [Valor Total do COFINS],
		T.vII [Valor total Imp. Importação],
		T.vFrete [Valor Total do FRETE],
		T.vSeg [Valor Total do SEGURO]
	from 
		ATL_BR.dbo.Danfe_Base D with(nolock)
		join ATL_BR.dbo.Danfe_Item_Prod_DI DI with(nolock) on DI.Id_Danfe = D.Id_Danfe
		join ATL_BR.dbo.Danfe_Totais T with(nolock) on T.Id_Danfe = D.Id_Danfe
	where 
		num_proc = @Num_Proc and nNF = @nNF


/*
select * from dbo.Danfe_Item_Impostos where id_danfe = 10168
select * from dbo.Danfe_Totais where vFRETE > 0
select * from dbo.Danfe_base where id_danfe = 6821

spNF2SAP_Rel 'IMFMC20091201801','924'

*/
GO
