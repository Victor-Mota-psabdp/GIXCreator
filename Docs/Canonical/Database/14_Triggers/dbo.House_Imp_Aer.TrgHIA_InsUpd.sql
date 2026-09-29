SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgHIA_InsUpd] ON [dbo].[House_Imp_Aer] 
FOR INSERT, UPDATE
AS
	Declare @Processo	varchar(16)
	Declare @Num_Proc_Master_Old Varchar(14)
	Declare @Num_Proc_Master Varchar(14)

	Select @Processo = Num_proc_HIA from inserted	
	select @Num_Proc_Master_Old=Num_Proc_MIA from deleted
	Select @Num_Proc_Master = Num_Proc_MIA  from inserted

	if Left(@Processo, 5) <> 'IAJOB' AND Left(@Processo, 5) <> 'IAREM'
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
ALTER TABLE [dbo].[House_Imp_Aer] ENABLE TRIGGER [TrgHIA_InsUpd]
GO
