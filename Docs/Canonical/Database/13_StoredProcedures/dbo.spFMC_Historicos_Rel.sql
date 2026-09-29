SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spFMC_Historicos_Rel]

as

select
	HSGProcesso JOB,
	dbo.fBusca_Docs_PO_Modal(HSGProcesso,1) PO,
	left(convert(char, HSGData, 103),10) + ' - ' + HSDDescricao Historico
from
	hist_geral 
where
	hsgprocesso like '%FMC%'
	and cd_origem='U'
order by
	JOB, HSGData



GO
