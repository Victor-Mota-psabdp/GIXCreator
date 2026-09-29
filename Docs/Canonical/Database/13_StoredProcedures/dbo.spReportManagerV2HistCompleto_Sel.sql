SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spReportManagerV2HistCompleto_Sel 'EMVIT201608024BR'
CREATE Procedure [dbo].[spReportManagerV2HistCompleto_Sel]

	@Num_Proc	Varchar(16)

as

select 
	top 10 row_number() over (order by hsgprocesso)Seq, replace(convert(varchar(10),hsgdata,103) + ' - ' + replace(left(hsddescricao,1985),'''',''),';','; ') Saida 
from 
	hist_Geral with(nolock)
Where 
	hsgprocesso=@num_proc and disp_cliente='S'

order by hsgdata desc


GO
