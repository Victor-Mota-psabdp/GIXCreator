SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create TRIGGER [dbo].[TrgJobSFDCIA_Upd] ON [dbo].[LLP_Imp_Aer] For Update 

AS 
BEGIN
	
Declare		@Num_Proc	Varchar(16)
Select @Num_Proc=Num_Proc_Lia from inserted

Declare		@ID_Status  int
Select @ID_Status=ID_Status from inserted

Declare @ID_Status_del as int
Select @ID_Status_del  = ID_Status from deleted

Declare @SFDCID as Datetime
Select @ID_Status_del  = ID_Status from deleted


if @Num_Proc is not null
	Begin 
		if @ID_Status <> @ID_Status_del
			Begin
			
				update Job_SFDC set Dt_Envio = NULL, Dt_Upd =NULL
				where Num_Proc = @Num_Proc
				
				insert Log_Job_SFDC
				select @Num_Proc,GETDATE(),@ID_Status,@ID_Status_del
			End
	End	
END


GO
ALTER TABLE [dbo].[LLP_Imp_Aer] ENABLE TRIGGER [TrgJobSFDCIA_Upd]
GO
