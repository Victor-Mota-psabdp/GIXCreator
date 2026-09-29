SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSolicitacaoLI_Task_InsUpd]

		@Num_Proc		Varchar(16),
		@Nome_Tp_LI		VarChar(30),
		@Dt_Conclusao	Datetime,
		@Usuario		VarChar(50),
		@Grupo			varChar(10)

as

BEGIN TRANSACTION
		
	Declare @ID_Task	int
	Declare @Cd_Usuario	Varchar(15)
	Set @Cd_Usuario=(select Cd_Usuario from Usuario where Nome_usuario = @Usuario)
	Declare @ID_Tipo int
	set @ID_Tipo = (select ID_Tipo from Tipo_LI where Nome_Tp_LI = @Nome_Tp_LI)

--	--1	PRE-Autorização de Embarque,2	PRE-Embarque,3	POS-Embarque , 6	PRE/POS
--	*Task -> "Solicitação de LI": To be completed in accordance with SLI "DT. Solicitação" 
--(Tipo de L.I. - POS-Embarque/PRE-Autorização de Embarque/PRE-Embarque/PRE/POS) with JOB linked.
--OBS:
--1) The date of completion of TASK can not be overlapped.
--2) In case of several SLIs (Tipo de L.I. - POS-Embarque/PRE-Autorização de Embarque/PRE-Embarque/PRE/POS) for the same JOB,
--consider the date of the first SLI.
	if @ID_Tipo in (1,2,3,6)
		BEGIN
			--Task : 46	Solicitação de LI
			if not exists(select Num_Proc from Tarefas_Processos where Num_Proc = @Num_Proc
				and ID_Task = 46 and Dt_Conclusao is not null)
					BEGIN
						UPDATE 
							TAREFAS_PROCESSOS
						SET
							Dt_Conclusao=@Dt_Conclusao,
							Cd_Usuario=@cd_usuario
						WHERE
							Num_Proc=@NUM_Proc and id_task=46
					END
		END
		
	--4	SUB
	if @ID_Tipo = 4
		--116	Solicitação de L.I. SUB
--		*Task -> "Solicitação de L.I. SUB": To be completed in accordance with SLIs "DT. Solicitação" - (Tipo de L.I. - SUB) 
		--with linked JOB.
		--NOTE: The completion date of TASK may be overwritten according to SLI requests ((Tipo de L.I. - SUB)).
		BEGIN
			IF not exists (select Num_Proc from tarefas_processos where num_proc = @Num_Proc and id_task = 116)
				Begin
					insert into tarefas_processos (num_proc,id_task,dt_conclusao,dt_previsao,cd_usuario)
					values (@Num_Proc, 116,@Dt_Conclusao, GETDATE() -10,@Cd_Usuario)
				End
			ELSE
				BEGIN
					UPDATE 
							TAREFAS_PROCESSOS
						SET
							Dt_Conclusao=@Dt_Conclusao,
							Cd_Usuario=@cd_usuario
						WHERE
							Num_Proc=@NUM_Proc and id_task=116
					END
		END 
	
	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END

COMMIT TRANSACTION	






GO
