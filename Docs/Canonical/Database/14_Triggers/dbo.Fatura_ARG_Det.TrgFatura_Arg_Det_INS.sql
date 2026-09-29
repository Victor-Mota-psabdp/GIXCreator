SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--78 - Emissão de NF de Serviços
--este esquema de @Cliente = @ClienteFatura, eh um ticket q esta aguardando testes do eduardo
--Ticket#100-68941

CREATE TRIGGER [dbo].[TrgFatura_Arg_Det_INS] ON [dbo].[Fatura_ARG_Det] 
FOR INSERT
AS

	Declare @Processo	varchar(16)
	Declare @Dt_Conclusao	Datetime
	Declare @ID_Fat int
	Declare @Cliente as varchar(10)
	Declare @ClienteFatura as varchar(10)
	
	Select @Processo = Num_Proc from inserted
	Select @ID_Fat = ID_Fat from inserted
	/*
	IF LEFT(@Processo,1) ='E'
		Begin
			set @Cliente = (select Cd_Export from vwHouse_Exp with(nolock) where Num_Proc = @Processo)
		End
	IF LEFT(@Processo,1)  ='B'
		Begin
			set @Cliente = (select cd_cliente_hbo from House_BDP_OUT with(nolock) where Num_Proc_HBO = @Processo)
		End
	IF LEFT(@Processo,1)  ='I'
		Begin
			set @Cliente = (select Cd_Consig from vwHouse_Imp with(nolock) where Num_Proc = @Processo)
		End
		
		Begin
			set @ClienteFatura = (select Cd_Pes from Fatura_ARG with(nolock) where ID_Fat =@ID_Fat)
		End
		
	set @Dt_Conclusao = (select Dt_conclusao from Tarefas_Processos with(nolock) where Num_Proc = @Processo and ID_Task = 78)
	--ticket: 100-36453, alterado por solicitação do eduardo bonfim

	if @Dt_Conclusao is null AND @Cliente = @ClienteFatura
		Begin 
			UPDATE 
				TAREFAS_PROCESSOS
			SET
				Dt_Conclusao=GETDATE(),
				cd_usuario = 'ATL'					
			WHERE
				Num_Proc=@Processo and id_task=78
		End
*/
	--if @cd_tp_tx in ('srv','BRO')
	--	Begin 
	--		if exists(select ID_TP from Tarefas_Processos where Num_Proc = @Processo and ID_Task = 78)
	--			Begin 
	--				UPDATE 
	--					TAREFAS_PROCESSOS
	--				SET
	--					Dt_Conclusao=GETDATE(),
	--					cd_usuario = 'ATL'					
	--				WHERE
	--					Num_Proc=@Processo and id_task=78
	--			End
	--	End




----78 - Emissão de NF de Serviços
--ALTER TRIGGER [dbo].[TrgFatura_Arg_Det_INS] ON [dbo].[Fatura_ARG_Det] 
--FOR INSERT
--AS

--	Declare @Processo	varchar(16)
--	--Declare @cd_tp_tx	varchar(6)	
--	Declare @Dt_Conclusao	Datetime
	
--	Select @Processo = Num_Proc from inserted
--	--Select @cd_tp_tx = cd_tp_tx from inserted
	
--	set @Dt_Conclusao = (select Dt_conclusao from Tarefas_Processos where Num_Proc = @Processo and ID_Task = 78)
--	--ticket: 100-36453, alterado por solicitação do eduardo bonfim
--	if @Dt_Conclusao is null
--		Begin 
--			UPDATE 
--				TAREFAS_PROCESSOS
--			SET
--				Dt_Conclusao=GETDATE(),
--				cd_usuario = 'ATL'					
--			WHERE
--				Num_Proc=@Processo and id_task=78
--		End

--	--if @cd_tp_tx in ('srv','BRO')
--	--	Begin 
--	--		if exists(select ID_TP from Tarefas_Processos where Num_Proc = @Processo and ID_Task = 78)
--	--			Begin 
--	--				UPDATE 
--	--					TAREFAS_PROCESSOS
--	--				SET
--	--					Dt_Conclusao=GETDATE(),
--	--					cd_usuario = 'ATL'					
--	--				WHERE
--	--					Num_Proc=@Processo and id_task=78
--	--			End
--	--	End
GO
ALTER TABLE [dbo].[Fatura_ARG_Det] ENABLE TRIGGER [TrgFatura_Arg_Det_INS]
GO
