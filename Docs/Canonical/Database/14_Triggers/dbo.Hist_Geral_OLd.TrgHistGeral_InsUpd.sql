SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgHistGeral_InsUpd] ON [dbo].[Hist_Geral_OLd] 
FOR INSERT
AS
	Declare @Processo varchar(16)
	Select @Processo = hsgprocesso from inserted 
	if len(@processo)=16
		Begin 
			Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus,excdtenvio) 
			values (@Processo, getdate(), 0,'01-01-2010') 

		End


GO
ALTER TABLE [dbo].[Hist_Geral_OLd] ENABLE TRIGGER [TrgHistGeral_InsUpd]
GO
