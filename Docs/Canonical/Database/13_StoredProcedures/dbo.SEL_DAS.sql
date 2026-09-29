SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from pgto_rcto
--select * from pgto_rcto_div
--select * from pgto_rcto_div_det
--
--[SEL_DAS]'01-07-2013','31-07-2013','%','%'
CREATE     PROCEDURE  [dbo].[SEL_DAS]
				@datainicial	varchar(10),
				@datafinal	varchar(10),
				@nomeconta	varchar(40),
				@Nome		varchar (40)
AS
select 
	nome_cta_ctb,pgto_rcto_div_det.cd_cta_ctb, compl_hist,dc_item, dt_vcto_div, num_cta_cte, 
	nome_centro_custo, pgto_rcto_div_det.cd_centro_custo, 
	cast ( pgto_rcto_div_det.vlr_item as money) as ValorItem, 
	convert(datetime, dt_vcto_div, 105) as data, pgto_rcto_div.num_lcto_div,
	 DC_DIV, pessoa.apelido,cast(vlr_doc_div as money) as ValorDoc,
	cta_ctb.cd_ctA_ctb ,dt_emissao,num_nf
from pgto_rcto_div
join pessoa on pgto_rcto_div.cd_pes=pessoa.cd_pes 
join pgto_rcto_div_det on pgto_rcto_div_det.num_lcto_div=pgto_rcto_div.num_lcto_div
join Centro_custo on Centro_custo.cd_centro_custo=pgto_rcto_div_det.cd_centro_custo
join cta_ctb on cta_ctb.cd_cta_ctb=pgto_rcto_div_det.cd_cta_ctb
where convert(datetime, dt_vcto_div, 105) >= convert(datetime,@datainicial,105)  and  convert(datetime, dt_vcto_div, 105) <=convert(datetime,@dataFinal,105) and
nome_cta_ctb like @nomeconta and pessoa.apelido like @Nome 
ORDER BY convert(datetime, dt_vcto_div,105)






GO
