SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[TrgGrupoSFDC_InsUpd] ON [dbo].[Grupo] 
FOR INSERT,Update
AS
	Declare		@Grupo	Varchar(3)


	
	Select @Grupo=Grupo from inserted
	
			insert exchange_Grupo
			select @Grupo,GETDATE(),NULL from inserted
			if not exists(select Grupo from Grupo_SFDC where Grupo = @Grupo)
				Begin
					insert Grupo_SFDC
					select @Grupo,NULL,NULL from inserted
				End
		

GO
ALTER TABLE [dbo].[Grupo] ENABLE TRIGGER [TrgGrupoSFDC_InsUpd]
GO
