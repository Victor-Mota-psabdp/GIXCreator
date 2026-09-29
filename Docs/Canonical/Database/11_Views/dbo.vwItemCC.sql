SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View vwItemCC

AS

select det.cd_cta_Ctb, cd_Centro_Custo, dc_item, SUM(vlr_item) Valor_Item from pgto_rcto_div PG
Join pgto_rcto_div_det DET on PG.num_lcto_div=DET.num_lcto_div
where dt_pgto_rcto_div like '%%/01/2006'
GROUP BY 
det.cd_cta_Ctb, cd_Centro_Custo, dc_item

GO
