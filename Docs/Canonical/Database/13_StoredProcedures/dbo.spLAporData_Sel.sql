SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spLAporData_Sel] --'2011-11-01','2011-11-30'	

	@DtInicial datetime,
	@DtFinal datetime

as
	SELECT
		convert(datetime,Dt_Pgto_Rcto,103)	Data,
		dc							DC,
		num_lcto					[LA/DA],
		vlr_doc						Valor,
		(case when concil = 'S' then 'SIM' else 'NÃO' end) Conciliado,
		P.Apelido					Debitor
	FROM 
		pgto_rcto PR		
		left join Pessoa P on P.cd_pes = PR.cd_pes	
	WHERE 
		convert(datetime,Dt_Pgto_Rcto,103) between @DtInicial and @DtFinal	

	UNION ALL

	SELECT
		convert(datetime,Dt_Pgto_Rcto_div,103)	Data,
		dc_div						dc,
		num_lcto_div				num_lcto,
		vlr_doc_div					valor,
		(case when concil_div = 'S' then 'SIM' else 'NÃO' end) Conciliado,
		P.Apelido					Debitor
	FROM
		pgto_rcto_div PRD
		left join Pessoa P on P.cd_pes = PRD.cd_pes
	WHERE
		convert(datetime,Dt_Pgto_Rcto_div,103) between @DtInicial and @DtFinal
	ORDER BY
		Data



GO
