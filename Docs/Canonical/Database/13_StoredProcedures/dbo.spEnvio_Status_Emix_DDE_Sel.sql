SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEnvio_Status_Emix_DDE_Sel] --'ALL'
(
	@ALL VARCHAR(25)
)

AS

select 
	e.valor [DDE],
	Dt_Retorno [Data Retorno],
	Retorno_Erro [Status],
	E.num_proc [JOB],
	ORG.Nome_Local [Origem],
	ST.Status_Descricao [JOB Status]
from E_MIX_XML X with(nolock)
	join E_Mix_Consulta  e with(nolock) on E.ID = x.ID
	left join vwHouse_Exp HOU with(nolock) on X.Num_Proc = HOU.Num_Proc
	left Join Localidade ORG with(nolock) on HOU.Cd_Org = ORG.Cd_Local
	left join Tipo_Status_Processo ST with(nolock) on HOU.ID_Status = ST.ID_Status
	where x.id_consulta_tipo = 20 and  x.Dt_Retorno > GETDATE() - 31 
and 
	x.Retorno_Erro <> ''
order by Dt_Retorno



GO
