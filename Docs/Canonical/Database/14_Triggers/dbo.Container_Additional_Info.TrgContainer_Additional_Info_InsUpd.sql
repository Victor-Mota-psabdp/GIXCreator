SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--TRIGGER INCLUIDA, pq nao estava atualizando o report manager qdo atualizava as datas pelo Container_Additional_Info
CREATE TRIGGER [dbo].[TrgContainer_Additional_Info_InsUpd] ON [dbo].[Container_Additional_Info] 
FOR INSERT, UPDATE
AS
	Declare @Processo	varchar(16)
	Select @Processo = num_proc from inserted 

	if Left(@Processo, 5) <> 'EMJOB'
		Begin 
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
			values (@Processo, getdate(), 0,GETDATE()) 

			Insert Into ATL_INT.dbo.Exchange_ODS (ExcProcesso, ExcDataAlt) 
			values (@Processo, getdate()) 

		End


GO
ALTER TABLE [dbo].[Container_Additional_Info] ENABLE TRIGGER [TrgContainer_Additional_Info_InsUpd]
GO
