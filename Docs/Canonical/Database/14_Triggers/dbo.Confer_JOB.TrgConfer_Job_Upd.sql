SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgConfer_Job_Upd] ON [dbo].[Confer_JOB] For Update 

AS 
BEGIN

--SP_HELP Confer_Job
	
	Declare @Num_PRoc		Varchar(16)
	Declare @Status			Varchar(50)
	Declare @StatusNovo		Varchar(50)

-- Coletando campos antigos
	select @Num_proc=Num_proc,@Status=[Status] from deleted
-- Coletando campos Novos
	select @StatusNovo=[Status] from inserted

	if @Status <> @StatusNovo 
		Begin
			insert Log_Confer_Job 
				(Dt_Alter,Tp_Oper,Num_Proc,Status)
			values
				(GETDATE(),'A',@Num_Proc,@Status)
		End			
END


GO
ALTER TABLE [dbo].[Confer_JOB] ENABLE TRIGGER [TrgConfer_Job_Upd]
GO
