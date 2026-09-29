SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spContabilLogErro_Rel --'07-01-2009','07-31-2009'
			@DataInicial	Datetime,
			@DataFinal		Datetime

AS

Select pg.num_lcto from pgto_rcto PG
LEft Join vwCxas CXA on CXA.num_lcto=PG.num_lcto
Where
	convert(datetime,dt_pgto_rcto,105) between @DataInicial and @DataFinal
Group by
	pg.Num_Lcto,dc,vlr_doc
Having
	dbo.valor(vlr_doc,dc) <> sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia))

union


Select pg.num_lcto_div from pgto_rcto_div PG
Join Pgto_Rcto_Div_det PD on PD.num_lcto_div=PG.num_lcto_div
Where
	convert(datetime,dt_pgto_rcto_div,105) between @DataInicial and @DataFinal
Group by
	pg.Num_Lcto_div,dc_div,vlr_doc_div
Having
	dbo.valor(vlr_doc_Div,dc_div) <> sum(dbo.valor(vlr_item,dc_item))


GO
