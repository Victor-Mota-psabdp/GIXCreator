SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create TRIGGER [dbo].[TrgJobSFDCIA_Ins] ON [dbo].[LLP_Imp_Aer] For Insert 

AS 
BEGIN
	
Declare		@Num_Proc	Varchar(16)


Select @Num_Proc=Num_Proc_Lia from inserted

insert Job_SFDC
select @Num_Proc,NULL,GETDATE(),NULL,NULL
	
END


GO
ALTER TABLE [dbo].[LLP_Imp_Aer] ENABLE TRIGGER [TrgJobSFDCIA_Ins]
GO
