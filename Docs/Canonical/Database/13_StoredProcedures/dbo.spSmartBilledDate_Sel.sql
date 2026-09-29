SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spSmartBilledDate_Sel
	@Num_Proc Varchar(16)
AS

select dt_conclusao data from tarefas_processos with(nolock) where id_Task=40 and num_proc=@num_proc

GO
