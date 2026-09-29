SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spTask_Solas_InsUpd]--'EMCSR201607012BR'

		@Num_Proc	Varchar(16)		

as

BEGIN TRANSACTION
	
	Declare @ID_Task		int
	Declare @Cd_Usuario		Varchar(15)		
	declare	@Dt_Conclusao	Datetime
	Declare @Nome_Task		VarChar(30)
	--Declare @Usuario		VarChar(50)
	
	set @Dt_Conclusao = (select max(Convert(datetime, DocsRcvdDate,103)) from Solas_xml_recebido where ForwarderReferenceNumber = @Num_Proc)
	set @Nome_Task = 'Recebimento do Armador VGM'
	Set @Id_task=(select top 1 id_task from Tipo_Tarefas where Nome_Task = @Nome_Task and Modal = left(@Num_Proc,2))
	Set @Cd_Usuario='ATL'


IF not exists (select top 1 * from tarefas_processos where num_proc = @Num_Proc and id_task = @Id_task)
	Begin
		insert into tarefas_processos (num_proc,id_task,dt_conclusao,dt_previsao,cd_usuario)
		values (@Num_Proc, @Id_task,@Dt_Conclusao, GETDATE(),@Cd_Usuario)
	End
ELSE
	BEGIN	
		UPDATE 
			TAREFAS_PROCESSOS
		SET			
			Dt_Conclusao=@Dt_Conclusao,
			cd_usuario = @Cd_Usuario
		WHERE
			Num_Proc=@NUM_Proc 
			and id_task=@ID_Task
	END

	

COMMIT TRANSACTION	






GO
