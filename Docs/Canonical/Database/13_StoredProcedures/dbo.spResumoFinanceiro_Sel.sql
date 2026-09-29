SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure spResumoFinanceiro_Sel
		@DataInicial Datetime,
		@DataFinal	Datetime

AS

select 'Administrative' Tipo,sum(dbo.valor(vlr_doc_div,dc_div)) Valor from pgto_rcto_div

Where
	convert(Datetime,dt_pgto_Rcto_div,105) between @DataInicial and @DataFinal


Union all

select 'Operational - Receive' Tipo,sum(dbo.valor(vlr_doc,dc)) from pgto_rcto

Where
	convert(Datetime,dt_pgto_Rcto,105) between @DataInicial and @DataFinal
	and dc='C'

union all


select 'Operational - Payments' Tipo,sum(dbo.valor(vlr_doc,dc)) from pgto_rcto

Where
	convert(Datetime,dt_pgto_Rcto,105) between @DataInicial and @DataFinal
	and dc='D'

GO
