SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Tarefas_Master
--select Standard,Opcional,Tipo_Consol,* from Tipo_Tarefas_Master
CREATE procedure [dbo].[spATL_Tipo_Tarefas_Master_InsUpd]
(
	@ID_Task			int,
	@Nome_Task			varchar(30),
	@CD_TP_MODAL		varchar(2),
	@Ativo				char(1),
	@Dias				float,
	@Tipo_Data			varchar(20),
	@Smart_Previsao		varchar(50),
	@Smart_Conclusao	varchar(50),
	@Cd_Pes_Grupo		varchar(10),
	@Standard			char(1),
	@Opcional			char(1),
	@Dt_Criacao			DateTime,
	@Cd_Usuario			varchar(6),
	@Descr_Tarefa		varchar(50),
	@Tipo_Consol		char(1)
)
AS
		
	--Cria tabela temporaria e inseri todos modais se 'AL' ou apenas 1 modal
	declare @tabModal table (Modal varchar(2))
	if @CD_TP_MODAL <> 'AL'
		insert @tabModal
			select @CD_TP_MODAL
	else
		insert @tabModal
			select distinct modal from Tipo_Tarefas_Master
			--select CD_TP_MODAL from Tipo_Modal_Imp_Exp where CD_TP_MODAL <> 'AL'
	-------------------------------------------------------------------------
	Declare @Modal varchar(2)
	Declare cTemp cursor for select Modal from @tabModal
	open cTemp
		Fetch Next From cTemp Into @Modal
			While @@FETCH_STATUS = 0
				Begin
					If NOT exists (select * from Tipo_Tarefas_Master where id_task = @ID_Task and modal = @Modal
							and cd_pes_grupo = @cd_pes_grupo)
						begin
							insert into Tipo_Tarefas_Master
							(
								id_task, Nome_Task, Modal, Ativo, Dias, Tipo_Data,
								Smart_Previsao, Smart_Conclusao, Cd_Pes_Grupo,
								Dt_Criacao, Cd_Usuario, Descr_Tarefa,
								Standard,Opcional,Tipo_Consol
							)
							Values
							(
								@ID_Task, @Nome_Task, @Modal, @Ativo, @Dias, @Tipo_Data,
								@Smart_Previsao, @Smart_Conclusao, @Cd_Pes_Grupo,
								getdate(), @Cd_Usuario, @Descr_Tarefa,
								@Standard,@Opcional,@Tipo_Consol
							)
						end
					Else
						begin
							Update Tipo_Tarefas_Master
							set
								id_task = @ID_Task,
								Nome_Task = @Nome_Task,
								Modal = @Modal,
								Ativo = @Ativo,
								Dias = @Dias,
								Tipo_Data = @Tipo_Data,
								Smart_Previsao = @Smart_Previsao,
								Smart_Conclusao = @Smart_Conclusao,
								Cd_Pes_Grupo = @Cd_Pes_Grupo,
								Dt_Criacao = getdate(),
								Cd_Usuario = @Cd_Usuario,
								Descr_Tarefa = @Descr_Tarefa,
								Standard=@Standard,Opcional=@Opcional,Tipo_Consol=@Tipo_Consol
							where
								id_task = @ID_Task and modal = @Modal and cd_pes_grupo = @cd_pes_grupo
						end
					Fetch Next From cTemp Into @Modal
				end
	close cTemp
	deallocate cTemp

GO
