SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spFMCEntregaPlanta_Sel]

as
--Stored utilizada para atualziar a entrega na planta


select 
	dbo.fbusca_tarefa_prev(TP.num_proc,13) PEntrega_Planta, 
	isnull([dbo].[fBusca_Data](TP.Num_Proc,'ATA') ,
	[dbo].[fBusca_Data](TP.Num_Proc,'ETA')) ATA, 
	dbo.fbusca_tarefa(TP.num_proc,15) Presenca,
	dbo.fbusca_tarefa(TP.num_proc,20) LI,
	dbo.fbusca_tarefa(TP.num_proc,18) DTA, 
	cast(dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) as datetime) Registro_DI, 
	TP.num_proc,dbo.fbusca_tarefa(TP.num_proc,4) Desembaraco, 
	isnull(campo_dados,2) campo,
	dbo.[fBusca_Tarefa](TP.num_proc,7) Docs,
	dbo.FBusca_Tarefa(TP.num_Proc,56) Exoneracao 
from tarefas_processos TP
LEft Join Campo_Processo CP on TP.num_proc=CP.num_proc and id_campo=32 
where 
	TP.num_proc like 'I%FMC%' and id_task=13 and dt_conclusao is null





GO
