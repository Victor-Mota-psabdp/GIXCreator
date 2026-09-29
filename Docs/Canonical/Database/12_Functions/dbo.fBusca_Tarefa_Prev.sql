SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  function [dbo].[fBusca_Tarefa_Prev](
				@Processo varchar(16),
				@Tipo	int

)
RETURNS Datetime

BEGIN
		Declare @Resultado Datetime

		SET @Resultado=(select top 1 Dt_Previsao from tarefas_processos where num_proc=@processo and ID_Task=@tipo order by Dt_Previsao desc)

		RETURN @Resultado

END








GO
