SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgHistGeralN_Upd] ON [dbo].[Hist_Geral] 
FOR Update
AS
	--Declare @Processo varchar(16)
	--Select @Processo = hsgprocesso from inserted 
	
	
	Declare @Processo varchar(16)

	Select @Processo = hsgprocesso from inserted 
	
	if len(@processo)=16
		Begin 
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,excdtenvio) 
			values (@Processo, getdate(), 1,'01-01-2018') 

		End
GO
ALTER TABLE [dbo].[Hist_Geral] ENABLE TRIGGER [TrgHistGeralN_Upd]
GO
