SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view vwDA_Cont

as
select num_lcto_div,cd_cta_Ctb,dt_pgto_rcto_div,dc_div, vlr_doc_div from pgto_rcto_div DIV
join ctA_cte CTA on DIV.num_ctA_Cte=CTA.num_cta_cte
where dt_pgto_Rcto_div like '%%/01/2006'


GO
