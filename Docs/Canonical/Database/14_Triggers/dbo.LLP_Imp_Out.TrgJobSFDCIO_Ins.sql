SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create TRIGGER [dbo].[TrgJobSFDCIO_Ins] ON [dbo].[LLP_Imp_Out] For Insert 

AS 
BEGIN
	
Declare		@Num_Proc	Varchar(16)


Select @Num_Proc=Num_Proc_Lio from inserted

insert Job_SFDC
select @Num_Proc,NULL,GETDATE(),NULL,NULL
	
END


GO
ALTER TABLE [dbo].[LLP_Imp_Out] ENABLE TRIGGER [TrgJobSFDCIO_Ins]
GO
