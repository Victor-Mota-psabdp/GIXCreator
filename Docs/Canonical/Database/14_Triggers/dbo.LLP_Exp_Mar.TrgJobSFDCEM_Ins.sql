SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create TRIGGER [dbo].[TrgJobSFDCEM_Ins] ON [dbo].[LLP_Exp_Mar] For Insert 

AS 
BEGIN
	
Declare		@Num_Proc	Varchar(16)


Select @Num_Proc=Num_Proc_Lem from inserted

insert Job_SFDC
select @Num_Proc,NULL,GETDATE(),NULL,NULL
	
END


GO
ALTER TABLE [dbo].[LLP_Exp_Mar] ENABLE TRIGGER [TrgJobSFDCEM_Ins]
GO
