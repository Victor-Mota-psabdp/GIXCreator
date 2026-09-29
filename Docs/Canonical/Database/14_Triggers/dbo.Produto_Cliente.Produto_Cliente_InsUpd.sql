SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create TRIGGER [dbo].[Produto_Cliente_InsUpd] ON [dbo].[Produto_Cliente] 
FOR INSERT, UPDATE
AS
	Declare @Cd_Prod	int
	Select @Cd_Prod = cd_prod from inserted 
		Begin 
			update Produto_Cliente set Produto_Descr = dbo.RemoveNonAlphaCharacters(Produto_Descr) where cd_prod = @Cd_Prod
		End
GO
ALTER TABLE [dbo].[Produto_Cliente] ENABLE TRIGGER [Produto_Cliente_InsUpd]
GO
