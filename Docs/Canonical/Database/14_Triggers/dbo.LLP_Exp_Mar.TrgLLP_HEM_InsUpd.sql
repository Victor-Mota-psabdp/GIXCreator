SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--TRIGGER INCLUIDA, pq nao estava atualizando o report manager qdo atualizava as datas pelo navio x viagem
CREATE TRIGGER [dbo].[TrgLLP_HEM_InsUpd] ON [dbo].[LLP_Exp_Mar] 
FOR INSERT, UPDATE
AS
	Declare @Processo	varchar(16)
	Select @Processo = Num_proc_LEM from inserted 
	if Left(@Processo, 5) <> 'EMJOB'
		Begin 
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
			values (@Processo, getdate(), 0,GETDATE()) 

			Insert Into ATL_INT.dbo.Exchange_ODS (ExcProcesso, ExcDataAlt) 
			values (@Processo, getdate()) 

		End

GO
ALTER TABLE [dbo].[LLP_Exp_Mar] ENABLE TRIGGER [TrgLLP_HEM_InsUpd]
GO
