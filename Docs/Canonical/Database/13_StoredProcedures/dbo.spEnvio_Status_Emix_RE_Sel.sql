SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEnvio_Status_Emix_RE_Sel]--'ALL'
(
	@ALL VARCHAR(25)
)

AS

select 
	e.valor [RE],
	Dt_Retorno [Data Retorno],
	Retorno_Erro [Status],
	E.num_proc [JOB],
	ORG.Nome_Local [Origem],
	ST.Status_Descricao [JOB Status]
from E_MIX_XML X with(nolock)
	join E_Mix_Consulta e with(nolock) on E.ID = x.ID
	left join vwHouse_Exp HOU with(nolock) on X.Num_Proc = HOU.Num_Proc
	left Join Localidade ORG with(nolock) on HOU.Cd_Org = ORG.Cd_Local
	left join Tipo_Status_Processo ST with(nolock) on HOU.ID_Status = ST.ID_Status
	where x.id_consulta_tipo = 18 and  x.Dt_Retorno > '2017-11-21'
and 
	x.Retorno_Erro <> ''
	
union all
	select distinct
		E.Numero_PO [RE],
		X.Dt_Envio [Data Retorno],
		X.Mensagem_Erro [Status],
		X.num_proc [JOB],
		ORG.Nome_Local [Origem],
		ST.Status_Descricao [JOB Status]
from E_MIX_XML_ERRO X with(nolock)
	left join vwPO E with(nolock) on e.Num_Proc = X.Num_Proc and E.ID_DC = '4'
	left join vwHouse_Exp HOU with(nolock) on X.Num_Proc = HOU.Num_Proc
	left Join Localidade ORG with(nolock) on HOU.Cd_Org = ORG.Cd_Local
	left join Tipo_Status_Processo ST with(nolock) on HOU.ID_Status = ST.ID_Status
	left join E_Mix_XML M with(nolock) on M.Num_Proc = X.Num_proc and M.id_consulta_tipo = X.id_consulta_tipo
	where 
		X.id_consulta_tipo = 18
		and M.ID is null
		
order by Dt_Retorno



GO
