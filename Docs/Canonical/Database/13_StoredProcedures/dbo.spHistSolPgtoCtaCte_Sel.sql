SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spHistSolPgtoCtaCte_Sel](
	@HSGID	bigint
)
as

select 
	'Saved' [Status],
	HSGSeq [Item],
	TOC.Nome_Tp_Ocor [Type Of Occurrence],
	HSGDescr[Messagem],
	HSGData [Insert Date],
	US.Nome_Usuario [User Name],
	Disp_Cliente [Avaliable Customer],
	HSGDataPrev [Prev. Date]
from 
	Hist_Sol_Pgto_Cta_Cte HP with(nolock)
join Tipo_Ocorrencia TOC with(nolock) on HP.Cd_Tp_Ocor = TOC.cd_tp_Ocor
join Usuario US with(nolock) on HP.Cd_Usuario = US.Cd_Usuario
where HSGID = @HSGID

GO
