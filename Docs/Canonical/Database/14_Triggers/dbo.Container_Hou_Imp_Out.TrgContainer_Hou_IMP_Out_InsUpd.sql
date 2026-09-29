SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--TRIGGER INCLUIDA, pq nao estava atualizando o report manager qdo atualizava as datas pelo navio x viagem
create TRIGGER [dbo].[TrgContainer_Hou_IMP_Out_InsUpd] ON [dbo].[Container_Hou_Imp_Out] 
FOR INSERT, UPDATE
AS
	Declare @Processo	varchar(16)
	Select @Processo = Num_Proc_HIO from inserted 
	if Left(@Processo, 5) <> 'EMJOB'
		Begin 
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
			values (@Processo, getdate(), 0,GETDATE()) 

			Insert Into ATL_INT.dbo.Exchange_ODS (ExcProcesso, ExcDataAlt) 
			values (@Processo, getdate()) 

		End

GO
ALTER TABLE [dbo].[Container_Hou_Imp_Out] ENABLE TRIGGER [TrgContainer_Hou_IMP_Out_InsUpd]
GO
