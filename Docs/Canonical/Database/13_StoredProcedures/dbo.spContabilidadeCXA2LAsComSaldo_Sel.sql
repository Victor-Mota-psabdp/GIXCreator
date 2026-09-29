SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spContabilidadeCXA2LAsComSaldo_Sel] --'09-01-2009','09-30-2009'

	@DataInicial	Datetime,
	@DataFinal		Datetime

AS

select pg.num_lcto,dt_pgto_Rcto,vlr_doc,nome_raz_soc from Pgto_rcto PG  
left Join vwcxas CXA on PG.num_lcto=CXA.num_lcto
Join Pessoa PP on PP.cd_pes=PG.cd_pes
where
	convert(datetime,dt_pgto_rcto,105) between @DataInicial and @DataFinal
Group by
	pg.num_lcto,vlr_doc,dc,cxa.Num_Lcto,dt_pgto_Rcto,nome_raz_soc
having 
	sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia)) <> dbo.valor(vlr_doc,dc)
	or cxa.num_lcto is null



UNION

SELECT pg.num_lcto_div,dt_pgto_rcto_div,vlr_doc_div,Nome_raz_soc FROM PGTO_RCTO_DIV PG
Left jOIN Pgto_rcto_div_det PD on pg.num_lcto_div=pd.num_lcto_div
Join Pessoa PP on PP.cd_pes=PG.cd_pes

Where
	convert(datetime,dt_pgto_rcto_div,105) between @DataInicial and @DataFinal
Group by
	pg.num_lcto_div,dt_pgto_rcto_div, vlr_doc_div,pd.num_lcto_div,dc_div,nome_raz_soc
having
	sum(dbo.valor(vlr_item,dc_item)) <> dbo.valor(vlr_doc_div,dc_div)
	or pd.num_lcto_div is null

GO
