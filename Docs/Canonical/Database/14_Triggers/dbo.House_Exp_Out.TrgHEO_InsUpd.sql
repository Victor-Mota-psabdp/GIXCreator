SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgHEO_InsUpd] ON [dbo].[House_Exp_Out] 
FOR INSERT, UPDATE
AS
	Declare @Processo	varchar(16)
	Select @Processo = Num_proc_HEO from inserted 
	if Left(@Processo, 5) <> 'EOJOB'
		Begin 
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
			values (@Processo, getdate(), 0,GETDATE()) 

			Insert Into ATL_INT.dbo.Exchange_ODS (ExcProcesso, ExcDataAlt) 
			values (@Processo, getdate()) 

		End

GO
ALTER TABLE [dbo].[House_Exp_Out] ENABLE TRIGGER [TrgHEO_InsUpd]
GO
