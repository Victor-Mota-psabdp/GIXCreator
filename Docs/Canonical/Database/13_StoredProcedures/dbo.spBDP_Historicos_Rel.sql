SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spBDP_Historicos_Rel] --'IMROB20090809401'
(
@JOB varchar(16)
)

as

select
	HSGProcesso JOB,
	dbo.fBusca_Docs_PO_Modal(HSGProcesso,1) PO,
	left(convert(char, HSGData, 103),10) + ' - ' + HSDDescricao Historico
from
	hist_geral
where
	hsgprocesso = @JOB
	and (cd_origem='U' or cd_tp_ocor=55)
order by
	HSGData



GO
