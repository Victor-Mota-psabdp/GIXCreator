SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE function [dbo].[fBusca_Tarefa]
(
	@Processo varchar(16),	
	@Tipo	int
)

RETURNS Datetime

BEGIN

	Declare @Resultado Datetime
	
	If Len(@Processo) = 14
		Begin
			SET @Resultado=(select top 1 Dt_Conclusao from tarefas_master WITH (NOLOCK) where num_proc=@processo and ID_Task=@tipo and dt_conclusao is not null ) --order by Dt_Conclusao desc)
		End
	Else
		Begin
			SET @Resultado=(select top 1 Dt_Conclusao from tarefas_processos WITH (NOLOCK) where num_proc=@processo and ID_Task=@tipo and dt_conclusao is not null) --order by Dt_Conclusao desc)
		End		

	RETURN @Resultado

END









GO
