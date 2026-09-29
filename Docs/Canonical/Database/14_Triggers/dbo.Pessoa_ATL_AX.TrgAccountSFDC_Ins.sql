SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[TrgAccountSFDC_Ins] ON [dbo].[Pessoa_ATL_AX] For INSERT, UPDATE 

AS 
BEGIN
	
Declare		@Cd_Pes	Varchar(10)
Declare		@Cd_AX	Varchar(10)
Declare		@Tipo	Varchar(10)


Select @Cd_Pes=Cd_Pes from inserted
Select @Cd_AX=Cd_AX from inserted
Select @Tipo=Tipo from inserted

if @Cd_Pes is not NULL
Begin 
	if not exists (select * from Account_SFDC where Cd_Pes = @Cd_Pes and Cd_AX = @Cd_AX and Tipo = @Tipo)
		Begin
			insert Account_SFDC
			select @Cd_Pes,@Cd_AX,@Tipo,NULL,GETDATE(),NULL,NULL
		End
End
	
END


GO
ALTER TABLE [dbo].[Pessoa_ATL_AX] ENABLE TRIGGER [TrgAccountSFDC_Ins]
GO
