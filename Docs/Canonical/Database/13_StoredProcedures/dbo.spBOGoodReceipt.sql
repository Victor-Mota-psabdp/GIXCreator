SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spBOGoodReceipt  'IMCSR20080228501',null,'04-15-2008' 

CREATE Procedure [dbo].[spBOGoodReceipt]
		(
			@num_proc	varchar(16),
			@Prevista	datetime,
			@Efetiva	datetime
		)
AS
  BEGIN TRANSACTION

	Declare @Prevista_A Datetime
	Declare @Efetiva_A Datetime
	if not exists(select * from tarefas_processos where num_proc=@num_proc and ID_TASK=13)
		BEGIN
			Insert into
				Tarefas_Processos
					values(@num_proc,13,@Efetiva,@Prevista,null)
		END
	ELSE
		BEGIN
			Set @Prevista_A=(select top 1 Dt_Previsao from tarefas_processos where num_proc=@num_proc and id_task=13)
			if @Prevista <> @Prevista_A
					Begin
						update tarefas_processos
							SET	
							   Dt_Previsao=@Prevista
						Where
							Num_Proc=@num_proc and id_task=13
					End
			if @Efetiva is not null
				BEGIN
					SET @Efetiva_A=(select top 1 Dt_Conclusao from tarefas_processos where num_proc=@num_proc and id_task=13)
						if (@Efetiva > @Efetiva_A) or @Efetiva_A is null 
							Begin
								update tarefas_processos
									SET	
									   Dt_Conclusao=@Efetiva
								Where
									Num_Proc=@num_proc and id_task=13
							End
				END	
	END
COMMIT TRANSACTION




GO
