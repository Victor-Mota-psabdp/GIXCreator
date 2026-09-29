SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create TRIGGER [dbo].[TrgJobSFDCEA_Ins] ON [dbo].[LLP_Exp_Aer] For Insert 

AS 
BEGIN
	
Declare		@Num_Proc	Varchar(16)


Select @Num_Proc=Num_Proc_Lea from inserted

insert Job_SFDC
select @Num_Proc,NULL,GETDATE(),NULL,NULL
	
END


GO
ALTER TABLE [dbo].[LLP_Exp_Aer] ENABLE TRIGGER [TrgJobSFDCEA_Ins]
GO
