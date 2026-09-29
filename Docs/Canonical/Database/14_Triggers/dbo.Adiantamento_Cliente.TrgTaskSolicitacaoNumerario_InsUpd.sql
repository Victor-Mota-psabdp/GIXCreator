SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgTaskSolicitacaoNumerario_InsUpd] ON [dbo].[Adiantamento_Cliente] 
FOR INSERT, UPDATE
AS
	Declare @Processo	varchar(16)
	Declare @Dt_Conclusao	datetime
	Declare @ID_Task	int
	Declare @Cd_Usuario	Varchar(15)

	Select @Processo = Num_Proc from inserted 
	Select @Dt_Conclusao = Dt_Solicitacao from inserted 
	Set @Id_task=(select top 1 Id_task from tipo_tarefas where nome_task='Solicitação de Numerário' and modal=left(@Processo,2))
	Set @Cd_Usuario=(select Cd_Usuario from Usuario where Nome_usuario = 'ATL System')

	UPDATE 
		TAREFAS_PROCESSOS
	SET
		Dt_Conclusao=@Dt_Conclusao,
		Cd_Usuario=@cd_usuario
	WHERE
		Num_Proc=@Processo and id_task=@ID_Task
GO
ALTER TABLE [dbo].[Adiantamento_Cliente] ENABLE TRIGGER [TrgTaskSolicitacaoNumerario_InsUpd]
GO
