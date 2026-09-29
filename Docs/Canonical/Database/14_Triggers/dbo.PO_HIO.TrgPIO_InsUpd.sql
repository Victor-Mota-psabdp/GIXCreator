SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgPIO_InsUpd] ON [dbo].[PO_HIO] 
FOR INSERT
AS
	Declare @Processo varchar(16)
	Select @Processo = Num_Proc_HIO from inserted 
	if len(@processo)=16
		Begin 
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
			values (@Processo, getdate(), 0,GETDATE()) 

			Insert Into ATL_INT.dbo.Exchange_ODS (ExcProcesso, ExcDataAlt) 
			values (@Processo, getdate()) 

		End




GO
ALTER TABLE [dbo].[PO_HIO] ENABLE TRIGGER [TrgPIO_InsUpd]
GO
