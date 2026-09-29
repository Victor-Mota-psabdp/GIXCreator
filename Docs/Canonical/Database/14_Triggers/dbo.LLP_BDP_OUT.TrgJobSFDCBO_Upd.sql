SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgJobSFDCBO_Upd] ON [dbo].[LLP_BDP_OUT] For Update 

AS 
BEGIN
	
Declare		@Num_Proc	Varchar(16)
Select @Num_Proc=Num_Proc_LBO from inserted

Declare		@ID_Status  int
Select @ID_Status=ID_Status from inserted

Declare @ID_Status_del as int
Select @ID_Status_del  = ID_Status from deleted

Declare @SFDCID as Datetime
Select @ID_Status_del  = ID_Status from deleted


--if @Num_Proc is not null
--	Begin 
--		IF LEFT(@Num_Proc,2) <> 'BO'
--			BEGIN
--				if @ID_Status <> @ID_Status_del
--					Begin					
--						update Job_SFDC set Dt_Envio = NULL, Dt_Upd =NULL
--						where Num_Proc = @Num_Proc
						
--						insert Log_Job_SFDC
--						select @Num_Proc,GETDATE(),@ID_Status,@ID_Status_del
--					End
--			END
--	End	
END


GO
ALTER TABLE [dbo].[LLP_BDP_OUT] DISABLE TRIGGER [TrgJobSFDCBO_Upd]
GO
