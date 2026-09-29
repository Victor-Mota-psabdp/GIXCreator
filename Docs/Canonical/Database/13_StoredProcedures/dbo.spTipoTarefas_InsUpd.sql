SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help tipo_tarefas
--select * from tipo_tarefas where nome_task like '%%'

CREATE procedure [dbo].[spTipoTarefas_InsUpd]
(
	@txtTipoTarefaID int,
	@cmbTipoTarefaNome varchar(30),
	@cmbTipoTarefaModal varchar(2),
	@chkTipoTarefaInativo char(1),
	@nudTipoTarefaDias float,
	@cmbTipoTarefaTipoData varchar(20),
	@txtTipoTarefaSmartPrev varchar(50)=null,
	@txtTipoTarefaSmartConclusao varchar(50)=null,
	@cmbTipoTarefaGrupo varchar(20),
	@Cd_Usuario	varchar(20),
	@txtTipoTarefaDescr varchar(50)=null
)
AS
	declare @cd_pes_grupo varchar(10)
	set @cd_pes_grupo = (select top 1 cd_pes from pessoa where apelido = @cmbTipoTarefaGrupo and desat_pes = 'N')

	if @chkTipoTarefaInativo = '1'
		set @chkTipoTarefaInativo = 'N'
	else
		set @chkTipoTarefaInativo = 'S'
		
	--Incluido por Rafinha - 2016-06-30
	if @txtTipoTarefaSmartPrev = ''
		set @txtTipoTarefaSmartPrev = NULL
		
	if @txtTipoTarefaSmartConclusao = ''
		set @txtTipoTarefaSmartConclusao = NULL
	--FIM Rafinha
		
	--Cria tabela temporaria e inseri todos modais se 'AL' ou apenas 1 modal
	declare @tabModal table (Modal varchar(2))
	if @cmbTipoTarefaModal <> 'AL'
		insert @tabModal
			select @cmbTipoTarefaModal
	else
		insert @tabModal
			select distinct modal from tipo_tarefas
	-------------------------------------------------------------------------
	Declare @Modal varchar(2)
	Declare cTemp cursor for select Modal from @tabModal
	open cTemp
		Fetch Next From cTemp Into @Modal
			While @@FETCH_STATUS = 0
				Begin
					If NOT exists (select * from tipo_tarefas where id_task = @txtTipoTarefaID and modal = @Modal and cd_pes_grupo = @cd_pes_grupo)
						begin
							insert into tipo_tarefas
							(
								id_task, Nome_Task, Modal, Ativo, Dias, Tipo_Data,
								Smart_Previsao, Smart_Conclusao, Cd_Pes_Grupo,
								Dt_Criacao, Cd_Usuario, Descr_Tarefa
							)
							Values
							(
								@txtTipoTarefaID, @cmbTipoTarefaNome, @Modal, @chkTipoTarefaInativo, @nudTipoTarefaDias, @cmbTipoTarefaTipoData,
								@txtTipoTarefaSmartPrev, @txtTipoTarefaSmartConclusao, @Cd_Pes_Grupo,
								getdate(), @Cd_Usuario, @txtTipoTarefaDescr
							)
						end
					Else
						begin
							Update tipo_tarefas
							set
								id_task = @txtTipoTarefaID,
								Nome_Task = @cmbTipoTarefaNome,
								Modal = @Modal,
								Ativo = @chkTipoTarefaInativo,
								Dias = @nudTipoTarefaDias,
								Tipo_Data = @cmbTipoTarefaTipoData,
								Smart_Previsao = @txtTipoTarefaSmartPrev,
								Smart_Conclusao = @txtTipoTarefaSmartConclusao,
								Cd_Pes_Grupo = @Cd_Pes_Grupo,
								Dt_Criacao = getdate(),
								Cd_Usuario = @Cd_Usuario,
								Descr_Tarefa = @txtTipoTarefaDescr
							where
								id_task = @txtTipoTarefaID and modal = @Modal and cd_pes_grupo = @cd_pes_grupo
						end
					Fetch Next From cTemp Into @Modal
				end
	close cTemp
	deallocate cTemp


GO
