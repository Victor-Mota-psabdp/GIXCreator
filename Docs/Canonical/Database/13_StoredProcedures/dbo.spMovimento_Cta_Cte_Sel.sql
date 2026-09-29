SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spMovimento_Cta_Cte_Sel] --'%Itau-Conta Garantida%','2011-06-01','2011-06-30'
	
	(
	@Banco		varchar(22),
	@DtInicial	varchar(10),
	@DtFinal	varchar(10)
	)
as

	select 
		num_lcto_mov Lancamento, Dt_Pgto_Rcto_Mov Data, Historico, DC_Mov, Vlr_Doc_Mov, Concil_mov 
	from 
		mvto_cta_cte MCC
		left join Cta_Cte CCT	on CCT.Num_Cta_Cte = MCC.Num_Cta_Cte
	where 
		CCT.Titular like @Banco and convert(datetime,dt_Pgto_Rcto_mov,103) between @DtInicial and @DtFinal
	order by convert(datetime,dt_Pgto_Rcto_mov,103)



GO
