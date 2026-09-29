SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgJobSFDCBO_Ins] ON [dbo].[LLP_BDP_OUT] For Insert 

AS 
BEGIN
	
Declare		@Num_Proc	Varchar(16)


Select @Num_Proc=Num_Proc_LBO from inserted

insert Job_SFDC
select @Num_Proc,NULL,GETDATE(),NULL,NULL
	
END


GO
ALTER TABLE [dbo].[LLP_BDP_OUT] DISABLE TRIGGER [TrgJobSFDCBO_Ins]
GO
