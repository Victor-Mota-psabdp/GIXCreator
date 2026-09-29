SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Solicitacao_LI where Num_Proc = 'IMIFB201909021BR'
--select * from E_MIX_XML where Num_Proc = 'IMIFB201909021BR' and Envio_Erro <> ''
--select * from E_MIX_consulta where Num_Proc = 'IMIFB201909021BR' and  valor = '149/2988183-0'
CREATE Procedure [dbo].[spEnvio_Status_Emix_Import_Sel]--''
(
	@ALL VARCHAR(25)
)

AS

select 
	e.valor [DI],
	Dt_Retorno [Data Retorno],
	Retorno_Erro [Status],
	Envio_erro [Erro],
	E.num_proc [JOB],
	'8	Extrato DI' [Tipo],
	DST.Nome_Local [Origem],
	ST.Status_Descricao [JOB Status]
	
from E_MIX_XML X with(nolock)
	join E_Mix_Consulta e with(nolock) on E.ID = x.ID
	left join vwHouse_Imp HOU with(nolock) on X.Num_Proc = HOU.Num_Proc
	left Join Localidade DST with(nolock) on HOU.Cd_Dst = DST.Cd_Local
	left join Tipo_Status_Processo ST with(nolock) on HOU.ID_Status = ST.ID_Status
	where 
		x.id_consulta_tipo in (8)
		 and  x.Dt_Retorno > GETDATE() - 90 
	and 
	x.Retorno_Erro <> ''
	and x.Retorno_Erro <> 'Finalizado'
	and Dt_Envio > GETDATE() - 365

union all

select 
	e.valor [DI],
	Dt_Retorno [Data Retorno],
	Retorno_Erro [Status],
	Envio_erro [Erro],
	E.num_proc [JOB],
	'9	Extrato CI' [Tipo],
	DST.Nome_Local [Origem],
	ST.Status_Descricao [JOB Status]
from E_MIX_XML X with(nolock)
	join E_Mix_Consulta e with(nolock) on E.ID = x.ID
	left join vwHouse_Imp HOU with(nolock) on X.Num_Proc = HOU.Num_Proc
	left Join Localidade DST with(nolock) on HOU.Cd_Dst = DST.Cd_Local
	left join Tipo_Status_Processo ST with(nolock) on HOU.ID_Status = ST.ID_Status
	where x.id_consulta_tipo in (9) and  x.Dt_Retorno > GETDATE() - 90 
and 
	x.Retorno_Erro <> ''
	and x.Retorno_Erro <> 'Finalizado'
	and Dt_Envio > GETDATE() - 365

union all

select 
	e.valor [DI],
	Dt_Retorno [Data Retorno],
	Retorno_Erro [Status],
	Envio_erro [Erro],
	E.num_proc [JOB],
	'10	Parametrização' [Tipo],
	DST.Nome_Local [Origem],
	ST.Status_Descricao [JOB Status]
from E_MIX_XML X with(nolock)
	join E_Mix_Consulta e with(nolock) on E.ID = x.ID
	left join vwHouse_Imp HOU with(nolock) on X.Num_Proc = HOU.Num_Proc
	left Join Localidade DST with(nolock) on HOU.Cd_Dst = DST.Cd_Local
	left join Tipo_Status_Processo ST with(nolock) on HOU.ID_Status = ST.ID_Status
	where x.id_consulta_tipo in (10) and  x.Dt_Retorno > GETDATE() - 90 
and 
	x.Retorno_Erro <> ''
	and x.Retorno_Erro <> 'Finalizado'
	and Dt_Envio > GETDATE() - 365
	
union all

select 
	e.valor [DI],
	Dt_Retorno [Data Retorno],
	Retorno_Erro [Status],
	Envio_erro [Erro],
	E.num_proc [JOB],
	'11	Status LI' [Tipo],
	DST.Nome_Local [Origem],
	ST.Status_Descricao [JOB Status]
from E_MIX_XML X with(nolock)
	join E_Mix_Consulta e with(nolock) on E.ID = x.ID
	left join vwHouse_Imp HOU with(nolock) on X.Num_Proc = HOU.Num_Proc
	left Join Localidade DST with(nolock) on HOU.Cd_Dst = DST.Cd_Local
	left join Tipo_Status_Processo ST with(nolock) on HOU.ID_Status = ST.ID_Status
	where x.id_consulta_tipo in (11) and  x.Dt_Retorno > GETDATE() - 90 
and 
	x.Retorno_Erro <> ''
	and x.Retorno_Erro <> 'Finalizado'
	and Dt_Envio > GETDATE() - 365

union all

select distinct
	e.valor [DI],
	Dt_Retorno [Data Retorno],
	Retorno_Erro [Status],
	Envio_erro [Erro],
	E.num_proc [JOB],
	'12	Extrato LI' [Tipo],
	DST.Nome_Local [Origem],
	ST.Status_Descricao [JOB Status]
from E_MIX_XML X with(nolock)
	join E_Mix_Consulta e with(nolock) on E.ID = x.ID
	left join vwHouse_Imp HOU with(nolock) on X.Num_Proc = HOU.Num_Proc
	left Join Localidade DST with(nolock) on HOU.Cd_Dst = DST.Cd_Local
	left join Tipo_Status_Processo ST with(nolock) on HOU.ID_Status = ST.ID_Status
	where x.id_consulta_tipo in (12) and  x.Dt_Retorno > GETDATE() - 90 
and 
	x.Retorno_Erro <> ''
	and x.Retorno_Erro <> 'Finalizado'
	and Dt_Envio > GETDATE() - 365
order by [Data Retorno],[DI]



GO
