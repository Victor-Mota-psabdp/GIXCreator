SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spTask_Del]
	(
		@Num_proc varchar(16)
	)
AS

	if exists(select top 1 num_proc from Tarefas_Processos where Num_Proc = @Num_proc)
		BEGIN
			delete 
				tarefas_processos 
			where dt_conclusao is null 
				and num_proc = @Num_proc
		END



GO
