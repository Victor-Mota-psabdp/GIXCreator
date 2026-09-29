SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create TRIGGER [dbo].[Produto_CHB_InsUpd] ON [dbo].[Produto_CHB] 
FOR INSERT, UPDATE
AS
	Declare @Cd_Prod	int
	Select @Cd_Prod = cd_prod from inserted 
		Begin 
			update Produto_CHB set Descricao_Longa = dbo.RemoveNonAlphaCharacters(Descricao_Longa) where cd_prod = @Cd_Prod
		End
GO
ALTER TABLE [dbo].[Produto_CHB] ENABLE TRIGGER [Produto_CHB_InsUpd]
GO
