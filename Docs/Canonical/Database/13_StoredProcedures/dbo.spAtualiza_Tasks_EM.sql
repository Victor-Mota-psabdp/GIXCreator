SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure  [dbo].[spAtualiza_Tasks_EM]

as

BEGIN TRANSACTION

	Declare @Num_Proc varchar(16)
	Declare @Id_Task int
	Declare @Dt_Conclusao datetime
	Declare @Cd_Usuario varchar(10)

	Declare Cur_P cursor for 

		select distinct
			H.Num_proc_HEM, T.id_Task, T.Dt_Conclusao, T.cd_usuario 
		from 
			tarefas_master T
			join house_exp_mar H on H.Num_proc_MEM = T.Num_Proc
			Join tarefas_processos TP on TP.Num_Proc = H.Num_proc_HEM and TP.id_Task = T.id_Task
		where 
			T.Dt_Conclusao is not null
			and TP.Dt_Conclusao is null
		order by 1,2

	open Cur_P

		Fetch Next From Cur_P Into @Num_Proc, @Id_Task, @Dt_Conclusao, @Cd_Usuario

		While @@FETCH_STATUS = 0

			Begin
				UPDATE 
					TAREFAS_PROCESSOS
				SET
					Dt_Conclusao=@Dt_Conclusao,
					Cd_Usuario=@cd_usuario
				WHERE
					Num_Proc=@NUM_Proc and id_task=@ID_Task

				Fetch Next From Cur_P Into @Num_Proc, @Id_Task, @Dt_Conclusao, @Cd_Usuario

			end

	close Cur_P

	deallocate Cur_P 

	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END

COMMIT TRANSACTION	















GO
