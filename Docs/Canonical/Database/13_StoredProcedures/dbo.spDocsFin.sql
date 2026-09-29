SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure spDocsFin

		@datainicial varchar(10),
		@datafinal varchar(10),
		@DC		Char(1)

AS

select 
	num_lcto as Lancamento,cd_banco,Num_cta_Cte,dc,vlr_doc,apelido,
	dt_vcto 

from 
	pgto_rcto as la

	inner join pessoa as pp on (pp.cd_pes=la.cd_pes)
	
where 
	ck_doctos='N' and 
	convert(datetime,dt_vcto,105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal, 105)
	and dc like @DC
union

select num_lcto_div as Lancamento, cd_banco, num_cta_cte, dc_div, vlr_doc_div, apelido,
	dt_vcto_div

from 
	pgto_rcto_div as DA

	inner join pessoa as pp on (pp.cd_pes=DA.cd_pes)

where 
	ck_doctos=0 and
	convert(datetime,dt_vcto_div,105) between convert(datetime, @datainicial,105) and convert(datetime, @datafinal, 105)
	and dc_div like @DC



GO
