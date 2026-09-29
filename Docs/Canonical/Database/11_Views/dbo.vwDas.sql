SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View vwDas

as
select month(convert(datetime,dt_pgto_rcto_div,105)) Mes,nome_ctA_ctb,nome_centro_custo,sum((dbo.valor(vlr_item,dc_div))) Valor from pgto_rcto_div_det DIV
join cta_ctb CTB on CTB.cd_cta_ctb=DIV.cd_cta_ctb
Join Centro_custo CC on CC.cd_centro_custo=DIV.cd_centro_custo
Join Pgto_rcto_div Pg on PG.num_lcto_div=DIV.num_lcto_div
where convert(datetime,dt_pgto_Rcto_div,105) between '01-01-2006' and '04-30-2006'
group by
month(convert(datetime,dt_pgto_rcto_div,105)),nome_ctA_ctb,nome_centro_custo




GO
