SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spBOGoodIssue 'EMARG20080907201','2008-09-29','2008-09-26'

--spBOGoodReceipt 'IACSR20080100501','02-08-2008',null  


CREATE  Procedure [dbo].[spBOGoodIssue]
		(
			@num_proc	varchar(16),
			@Prevista	datetime,
			@Efetiva	datetime
		)
AS

Declare @Dt_Prevista Datetime
Declare @Dt_Conclusao DateTime
SET LOCK_TIMEOUT 4000
  BEGIN TRANSACTION
	if not exists(select * from tarefas_processos where num_proc=@num_proc and ID_TASK=10)
		BEGIN
			Insert into
				Tarefas_Processos
					values(@num_proc,10,@Efetiva,@Prevista,null)
		END
	ELSE
		BEGIN
			if @efetiva is null
			Set @Dt_Prevista=(select Dt_Previsao from tarefas_processos where num_proc=@num_proc and ID_TASK=10)
				if @prevista <> @Dt_Prevista
				Begin
					update tarefas_processos
						SET	
						   Dt_Previsao=@Prevista
					Where
						Num_Proc=@num_proc and id_task=10
				End
			else
				Set @Dt_Conclusao=(select Dt_Conclusao from tarefas_processos where num_proc=@num_proc and ID_TASK=10)
				
				If @efetiva <> isnull(@Dt_Conclusao,getdate())
					Begin
						update tarefas_processos
							SET	
							   Dt_Conclusao=@Efetiva
						Where
							Num_Proc=@num_proc and id_task=10
					End
		END
COMMIT TRANSACTION







GO
