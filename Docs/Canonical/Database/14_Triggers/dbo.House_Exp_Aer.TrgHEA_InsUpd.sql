SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgHEA_InsUpd] ON [dbo].[House_Exp_Aer] 
FOR INSERT, UPDATE
AS
	Declare @Processo	varchar(16)
	Declare @Num_Proc_Master_Old Varchar(14)
	Declare @Num_Proc_Master Varchar(14)

	Select @Processo = Num_proc_HEA from inserted 
	select @Num_Proc_Master_Old=Num_Proc_MEA from deleted
	Select @Num_Proc_Master = Num_Proc_MEA  from inserted

	if Left(@Processo, 5) <> 'EAJOB'
		Begin 
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,ExcDtEnvio) 
			values (@Processo, getdate(), 0,GETDATE()) 

			Insert Into ATL_INT.dbo.Exchange_ODS (ExcProcesso, ExcDataAlt) 
			values (@Processo, getdate()) 
		End

	--ADDED BY CARLOS EDUARDO - 2021-09-08
	if @Num_Proc_Master <> @Num_Proc_Master_Old
		BEGIN
			if exists(select Num_Proc from dbo.Exchange_JMD_AX_ATL with(nolock) where num_proc = @Processo and envio = 1)
				BEGIN				
					UPDATE dbo.Exchange_JMD_AX_ATL set Envio = 0 where num_proc=@Processo
				END
		END

GO
ALTER TABLE [dbo].[House_Exp_Aer] ENABLE TRIGGER [TrgHEA_InsUpd]
GO
