SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help tipo_tarefas
--select Standard,Opcional,Smart_GenericDates,* from tipo_tarefas
CREATE procedure [dbo].[spATL_Tipo_Tarefas_InsUpd]
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
	@Smart_GenericDates varchar(50)
)
AS

	--if @chkTipoTarefaInativo = '1'
	--	set @chkTipoTarefaInativo = 'N'
	--else
	--	set @chkTipoTarefaInativo = 'S'
		
	----Incluido por Rafinha - 2016-06-30
	--if @txtTipoTarefaSmartPrev = ''
	--	set @txtTipoTarefaSmartPrev = NULL
		
	--if @txtTipoTarefaSmartConclusao = ''
	--	set @txtTipoTarefaSmartConclusao = NULL
	----FIM Rafinha
		
	--Cria tabela temporaria e inseri todos modais se 'AL' ou apenas 1 modal
	declare @tabModal table (Modal varchar(2))
	if @CD_TP_MODAL <> 'AL'
		insert @tabModal
			select @CD_TP_MODAL
	else
		insert @tabModal
			--select distinct modal from tipo_tarefas
			select CD_TP_MODAL from Tipo_Modal_Imp_Exp where CD_TP_MODAL <> 'AL'
	-------------------------------------------------------------------------
	Declare @Modal varchar(2)
	Declare cTemp cursor for select Modal from @tabModal
	open cTemp
		Fetch Next From cTemp Into @Modal
			While @@FETCH_STATUS = 0
				Begin
					If NOT exists (select * from tipo_tarefas where id_task = @ID_Task and modal = @Modal
							and cd_pes_grupo = @cd_pes_grupo)
						begin
							insert into tipo_tarefas
							(
								id_task, Nome_Task, Modal, Ativo, Dias, Tipo_Data,
								Smart_Previsao, Smart_Conclusao, Cd_Pes_Grupo,
								Dt_Criacao, Cd_Usuario, Descr_Tarefa,
								Standard,Opcional,Smart_GenericDates
							)
							Values
							(
								@ID_Task, @Nome_Task, @Modal, @Ativo, @Dias, @Tipo_Data,
								@Smart_Previsao, @Smart_Conclusao, @Cd_Pes_Grupo,
								getdate(), @Cd_Usuario, @Descr_Tarefa,
								@Standard,@Opcional,@Smart_GenericDates
							)
						end
					Else
						begin
							Update tipo_tarefas
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
								Standard=@Standard,Opcional=@Opcional,Smart_GenericDates=@Smart_GenericDates
							where
								id_task = @ID_Task and modal = @Modal and cd_pes_grupo = @cd_pes_grupo
						end
					Fetch Next From cTemp Into @Modal
				end
	close cTemp
	deallocate cTemp

GO
