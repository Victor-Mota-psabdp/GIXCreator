SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Historico_Auto where Id_Hist_Auto = 88
--24/08/2015 -Incluido ativo na stored - cadu
CREATE procedure [dbo].[spHistoricoAuto_InsUpd]
(
	@Grupo	varchar(20),
	@Task	varchar(30),
	@Modal	char(2),
	@Id_Hist_Auto int,
	@Mensagem varchar(Max),
	@Ativo char(1)
)
as

Begin Transaction

	declare @cd_pes_grupo varchar(10)
	declare @ID_Task int

	set @cd_pes_grupo	= (select cd_pes from pessoa where apelido = @Grupo)

	IF @Task = 'ETD' or @Task = 'ATD' or @Task = 'ETA' or @Task = 'ATA'
		Begin
			--Print 'Verdadeiro para ATD,ETD,ETA,ATA'
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
			--Print 'Falso para ATD,ETD,ETA,ATA'
			set @ID_Task = (select top 1 id_task from tipo_tarefas where nome_task = @Task and Ativo = 'S')
		End

	IF @Id_Hist_Auto is Null and (exists (select * from tipo_tarefas where id_task = @ID_Task and Modal = @Modal and Cd_Pes_Grupo = @Cd_Pes_Grupo and Ativo = 'S') or (@ID_Task < 0))
		Begin
			--Print 'Verdadeiro para insert'	
			set @Id_Hist_Auto = isnull((select max(ID_Hist_auto) from historico_auto),0) + 1
			insert into
				Historico_Auto(Id_Hist_Auto,id_task,Modal,cd_pes_grupo,Mensagem,Ativo)
			values
				(@Id_Hist_Auto,@ID_Task,@Modal,@cd_pes_grupo,@Mensagem,@Ativo)
		End
	Else
		Begin
			update
				Historico_Auto
			set
				Id_Hist_Auto = @Id_Hist_Auto,
				ID_Task = @ID_Task,
				Modal = @Modal,
				cd_pes_grupo = @cd_pes_grupo,
				Mensagem = @Mensagem,
				Ativo = @Ativo
			where
				Id_Hist_Auto = @Id_Hist_Auto
		End

	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction

GO
