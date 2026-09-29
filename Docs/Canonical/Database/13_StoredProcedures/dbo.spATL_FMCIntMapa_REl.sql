SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATL_FMCIntMapa_REl] --[dbo].[spATL_FMCIntMapa_REl] ''
		@Grupo	Varchar(20)
as

select 
	Num_Proc,dt_conclusao [Migo - Date],[dbo].[fBusca_TipoDocCliente]('N',num_proc,1) [PO Number] ,[dbo].[fBusca_TipoDocCliente]('N',num_proc,5) [Numero DI],
	F.dt_envio [Miro Fatura - Date], S.dt_envio [Miro Seguro - Date],T.dt_envio [Miro Impostos - Date],
	P.dt_envio [Miro Complementar - Date],P.dt_retorno [Aprovação Miro Complementar - Date],
	F.Mensagem_retorno [Retorno SAP],F.OBS [Observação TI]
from 
	tarefas_processos		With(nolock)
	Left Join FMC_MIRO F	with(nolock) on F.fatura_pc=num_proc and F.id_evento='I'
	Left Join FMC_MIRO S	with(nolock) on S.fatura_pc=num_proc and S.id_evento='S'
	Left Join FMC_MIRO T	with(nolock) on T.fatura_pc=num_proc and T.id_evento='T'
	Left Join FMC_MIRO P	with(nolock) on P.fatura_pc=num_proc and P.id_evento='F'

where 
	id_task=13 and month(dt_conclusao)=month(getdate()) and year(dt_conclusao)=year(getdate()) and
	num_proc like 'I%FMC%'
OPTION(HASH JOIN)


GO
