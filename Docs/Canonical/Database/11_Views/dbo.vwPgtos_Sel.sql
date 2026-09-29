SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwPgtos_Sel]

AS
/*

View utilizada na reconciliacao bancaria

*/


select Num_Lcto_Div Num_LCto_REc,dbo.valor(vlr_doc_DIV,dc_div) Valor from pgto_Rcto_div

Union All

select Num_Lcto Number,dbo.valor(vlr_doc,dc) from pgto_Rcto where left(num_lcto,1)='L'

Union All

select num_ref_ra,Vlr_Tot_RA*-1 from remessa_Aer

Union all


select num_ref_rM,Vlr_Tot_RM*-1 from remessa_mar

GO
