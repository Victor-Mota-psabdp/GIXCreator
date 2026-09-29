SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgHIO_InsUpd] ON [dbo].[House_Imp_Out] 
FOR INSERT, UPDATE
AS
	Declare @Processo	varchar(16)
	Select @Processo = Num_proc_HIO from inserted 
	if Left(@Processo, 5) <> 'IOJOB'
		Begin 
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
			values (@Processo, getdate(), 0,GETDATE()) 

			Insert Into ATL_INT.dbo.Exchange_ODS (ExcProcesso, ExcDataAlt) 
			values (@Processo, getdate()) 

		End

GO
ALTER TABLE [dbo].[House_Imp_Out] ENABLE TRIGGER [TrgHIO_InsUpd]
GO
