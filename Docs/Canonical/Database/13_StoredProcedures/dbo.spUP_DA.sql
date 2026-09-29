SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure spUP_DA

			@novo	varchar(50),
			@antigo	varchar(50)
		
AS


update pgto_rcto_div_det set cd_cta_ctb=@novo
where num_lcto_div in (select distinct(dt.num_lcto_div) from pgto_rcto_div_det dt
inner join pgto_rcto_div pg on pg.num_lcto_div=dt.num_lcto_div
where dt_pgto_rcto_div like '%%/01/2005' and cd_cta_ctb=@antigo
)
and cd_cta_ctb=@Antigo




GO
