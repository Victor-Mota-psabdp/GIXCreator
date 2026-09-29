SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spHistoricoAuto_Sel]
(
	@Grupo	varchar(20),
	@Task	varchar(30),
	@Modal	char(2)
)
as
	declare @cd_pes_grupo varchar(10)
	declare @ID_Task int

	set @cd_pes_grupo	= (select cd_pes from pessoa with(nolock) where apelido = @Grupo)

	IF @Task = 'ETD' or @Task = 'ATD' or @Task = 'ETA' or @Task = 'ATA'
		Begin
			set @ID_Task = 
			(Case 
				when @Task = 'ETD' then -1
				when @Task = 'ATD' then -2
				when @Task = 'ETA' then -3
				when @Task = 'ATA' then -4
			End)
		End
	ELSE
		Begin
			set @ID_Task = (select top 1 id_task from tipo_tarefas with(nolock) where nome_task = @Task)
		End

	select
		ID_Hist_auto, Mensagem, Ativo
	from
		historico_auto with(nolock)
	where
		cd_pes_grupo = @cd_pes_grupo and Id_Task = @ID_Task and modal = @Modal


GO
