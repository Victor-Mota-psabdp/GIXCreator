SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spLASaldo_Sel] --'DA2010050144','D'

	@Num_lcto as varchar(16),
	@Tipo as char(1)

as
if @Tipo = 'S'
	Begin
		
		select sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia))+dbo.valor(vlr_doc,dc)*-1 Saldo from vwcxas CXA
		Join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto
		where CXA.num_lcto=@num_lcto
		group by vlr_doc,dc
	End
ELSE
	Begin
		select dbo.valor(vlr_doc_div,dc_div)+ sum(dbo.valor(vlr_item,dc_item))* -1 Saldo from Pgto_Rcto_div PR
		join pgto_rcto_div_det PD on PD.num_lcto_div=PR.num_lcto_div
		where PR.num_lcto_div=@num_lcto
		group by  vlr_doc_div, dc_div
	End



GO
