SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgPO_HEA_InsUpd] ON [dbo].[PO_HEA] 
FOR INSERT, UPDATE
AS
	Declare @Processo	varchar(16)
	Select @Processo = Num_proc_HEA from inserted 
	if Left(@Processo, 5) <> 'EAJOB'
		Begin 
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
			values (@Processo, getdate(), 0,GETDATE()) 

			Insert Into ATL_INT.dbo.Exchange_ODS (ExcProcesso, ExcDataAlt) 
			values (@Processo, getdate()) 

		End

GO
ALTER TABLE [dbo].[PO_HEA] ENABLE TRIGGER [TrgPO_HEA_InsUpd]
GO
