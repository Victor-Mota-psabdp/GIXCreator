SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spLAreport_Rel] ---'%','11-01-2011','11-20-2011','C'
	@DtInicial datetime,
	@DtFinal datetime
as
	select 
		convert(Datetime,dt_pgto_Rcto,103) [Data],Apelido [Credor/Devedor],DC,convert(float,Sum(Vlr_Doc)) Valor,Nome_Tp_Ativ Tipo_Atividade,
		case DC 
			when 'D' then 'Pagamentos'
			When 'C' then 'Recebimentos'
		End
		Tipo
	from 
		pgto_rcto PG
		Join Pessoa PP on pp.cd_pes=PG.cd_pes
		Join Tipo_Atividade TA on TA.cd_tp_ativ=PP.cd_tp_ativ
	Where
		convert(datetime,dt_pgto_rcto,103) between @DtInicial and @DtFinal
	Group by
		Dt_Pgto_Rcto,Apelido,dc,nome_tp_ativ
	Order by 
		dc

GO
