SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATL_ConferenciaJOB_Atualiza_Upd]	
	@Num_Proc	varchar(16),	
	@tipo		varchar(25),
	@justificativa	varchar(max),
	@cd_usuario varchar(6)
	
AS
/* 
========================================================================================================================= 
HISTORY CHANGE (From most recent to less recent)

. Date (YYYY/MM/DD):	2020/11/11 
. Ticket:				100-236919 - GSS - Billing authorization screen enhancement
. Business:				Eliene Alves Barbosa Oliveira (eliene.oliveira@bdpint.com) 
. Dept:					Transportation 
. Quality:				Rosangela Santos (rosangela.santos@bdpint.com)
. Developer:			Alessandra Suzuki Mariano (alessandra.mariano@bdpint.com)
. Developer review:		
========================================================================================================================= 
EXECUTION EXAMPLES  

exec spATL_ConferenciaJOB_Atualiza_Upd 'IAATL201911003BR','Transportation2','ASM','bla bla'

exec spATL_ConferenciaJOB_Atualiza_Upd

exec spATL_ConferenciaJOB_Atualiza_Upd

exec spATL_ConferenciaJOB_Atualiza_Upd
========================================================================================================================= 
*/ 

BEGIN TRANSACTION

Declare @ID_Task as Int
set @ID_Task = 0

Declare @ID_Task2 as Int
set @ID_Task2 = 0

	IF exists(select ID from Confer_Job where Num_Proc = @Num_Proc)
		BEGIN
		
			if @tipo = 'CSR'				
				BEGIN
					update 
						Confer_Job
					set 
						Cd_Usuario_CSR = @cd_usuario, 
						dt_aproval_csr = GETDATE(),
						Justificativa_csr = @justificativa
					where 
						Num_Proc = @Num_Proc
						
					--196 - Billing Authorization CSR
					--207 - Billing Authorization CSR						
					set @ID_Task = 207
					
				END					
			
			if @tipo = 'CHB'				
				BEGIN
					update 	
						Confer_Job
					set 
						Cd_Usuario_CHB = @cd_usuario, 
						dt_aproval_CHB = GETDATE(),
						Justificativa_chb = @justificativa
					where 
						Num_Proc = @Num_Proc
					
					--195 - Billing Authorization CHB
					--206 - Billing Authorization CHB
					set @ID_Task = 206
					
					--#Ticket 100-98138
					set @ID_Task = 206
					IF not exists (select Num_Proc from tarefas_processos  with(nolock) where num_proc = @Num_Proc and id_task = '26')
						BEGIN
							insert into tarefas_processos (num_proc,id_task,dt_conclusao,dt_previsao,cd_usuario)
							values (@Num_Proc, '26',GETDATE(), GETDATE() -2,@Cd_Usuario)
						END
					ELSE
						BEGIN
							if exists (Select id_task from TAREFAS_PROCESSOS  with(nolock) where Num_Proc=@NUM_Proc and id_task='26' and dt_conclusao is null)
								Begin
									UPDATE 
										TAREFAS_PROCESSOS
									SET
										Dt_Conclusao=GETDATE(),
										Cd_Usuario=@cd_usuario
									WHERE
										Num_Proc=@NUM_Proc 
										and id_task='26'
								End
						END
					
					
				END					
					
			if @tipo = 'Transportation'
				BEGIN
					update 	
						Confer_Job
					set 
						Cd_Usuario_transp = @cd_usuario,
						dt_aproval_transp = GETDATE(),
						Justificativa_transp = @justificativa
					where 
						Num_Proc = @Num_Proc
						
					--197 - Billing Authorization Transportation
					--208 - Billing Authorization Transpor
					set @ID_Task = 208
				END

			--Alessandra 11/11/2020 - Ticket 100-236919
			if @tipo = 'Transportation2'
				BEGIN
					--Se a justificativa 1 estiver em branco, considero as informações da justificativa 2
					if exists (select Num_Proc from Confer_Job (nolock) where Num_Proc = @Num_Proc and Cd_Usuario_transp is null)
						begin
							update 	
								Confer_Job
							set 
								Cd_Usuario_transp = @cd_usuario,
								dt_aproval_transp = GETDATE(),
								Justificativa_transp = @justificativa,

								Cd_Usuario_transp2 = @cd_usuario,
								dt_aproval_transp2 = GETDATE(),
								Justificativa_transp2 = @justificativa
							where 
								Num_Proc = @Num_Proc

							set @ID_Task2 = 208
						end
					else
						begin
							update 	
								Confer_Job
							set 
								Cd_Usuario_transp2 = @cd_usuario,
								dt_aproval_transp2 = GETDATE(),
								Justificativa_transp2 = @justificativa
							where 
								Num_Proc = @Num_Proc
						end
						
					set @ID_Task = 261
					
				END
				
			--Inserir o task
			if @ID_Task > 0
			BEGIN
				IF not exists (select Num_Proc from tarefas_processos where num_proc = @Num_Proc and id_task = @ID_Task)
					BEGIN
						insert into tarefas_processos (num_proc,id_task,dt_conclusao,dt_previsao,cd_usuario)
						values (@Num_Proc, @ID_Task,GETDATE(), GETDATE() -2,@Cd_Usuario)
					END
				ELSE
					BEGIN
						UPDATE 
							TAREFAS_PROCESSOS
						SET
							Dt_Conclusao=GETDATE(),
							Cd_Usuario=@cd_usuario
						WHERE
							Num_Proc=@NUM_Proc 
							and id_task=@ID_Task
					END
			END
			

			if @ID_Task2 > 0
			BEGIN
				IF not exists (select Num_Proc from tarefas_processos where num_proc = @Num_Proc and id_task = @ID_Task2)
					BEGIN
						insert into tarefas_processos (num_proc,id_task,dt_conclusao,dt_previsao,cd_usuario)
						values (@Num_Proc, @ID_Task2,GETDATE(), GETDATE() -2,@Cd_Usuario)
					END
				ELSE
					BEGIN
						UPDATE 
							TAREFAS_PROCESSOS
						SET
							Dt_Conclusao=GETDATE(),
							Cd_Usuario=@cd_usuario
						WHERE
							Num_Proc=@NUM_Proc 
							and id_task=@ID_Task2
					END
			END









		END


	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION

GO
