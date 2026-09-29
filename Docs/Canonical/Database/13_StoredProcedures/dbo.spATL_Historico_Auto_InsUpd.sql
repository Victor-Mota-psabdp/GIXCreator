SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Historico_Auto
--old spHistoricoAuto_InsUpd
CREATE procedure [dbo].[spATL_Historico_Auto_InsUpd]
(	
	@Id_Hist_Auto	int,
	@ID_Task		int,
	@cd_pes_grupo	varchar(10),	
	@Modal			char(2),	
	@Mensagem		varchar(Max),
	@Ativo			char(1),
	@Cd_Tp_Ocor		int,	
	@Disp_Cliente	char(1),
	@Cd_Usuario		varchar(6)
)
as

Begin Transaction

	IF @Id_Hist_Auto is Null and (exists (select * from tipo_tarefas where id_task = @ID_Task and Modal = @Modal 
		and Cd_Pes_Grupo = @Cd_Pes_Grupo and Ativo = 'S') or (@ID_Task < 0))
		BEGIN
			set @Id_Hist_Auto = isnull((select max(ID_Hist_auto) from historico_auto),0) + 1
			insert into	Historico_Auto
			(
				Id_Hist_Auto,id_task,Modal,cd_pes_grupo,Mensagem,Ativo,Cd_Tp_Ocor,Disp_Cliente,Dt_Ins,Cd_Usuario
			)
			values
			(
				@Id_Hist_Auto,@ID_Task,@Modal,@cd_pes_grupo,@Mensagem,@Ativo,@Cd_Tp_Ocor,@Disp_Cliente,GetDate(),@Cd_Usuario
			)
		END
	ELSE
		BEGIN
			if exists(select Id_Hist_Auto from Historico_Auto where Id_Hist_Auto = @Id_Hist_Auto)
			begin
				update
					Historico_Auto
				set
					Mensagem = @Mensagem,
					Ativo = @Ativo,
					Cd_Tp_Ocor=@Cd_Tp_Ocor,
					Disp_Cliente=@Disp_Cliente,				
					Cd_Usuario=@Cd_Usuario
				where
					Id_Hist_Auto = @Id_Hist_Auto
			end
		END
	
	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction

GO
