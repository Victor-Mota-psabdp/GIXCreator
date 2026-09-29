SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSaidaReportManagerHistCompleto_Rel]

	@Num_Proc	Varchar(16)

as

select 
	convert(varchar(10),hsgdata,103) + ' - ' + hsddescricao Saida 
from 
	hist_Geral with(nolock)
Where 
	hsgprocesso=@num_proc and disp_cliente='S'

order by hsgdata desc


GO
