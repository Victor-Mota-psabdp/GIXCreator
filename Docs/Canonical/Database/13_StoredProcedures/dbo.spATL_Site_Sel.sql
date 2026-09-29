SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Site_Sel]
@cd_site  varchar(1),
@nome_site varchar(30),
@Tipo char(1)
as

if @Tipo = 'A'
	Begin
		if @cd_site  <> '' or @cd_site  is not NULL
			Begin
				select cd_site , nome_site from dbo.Site
				where cd_site  = @cd_site  
			End
		else
			Begin
				select cd_site, nome_site from dbo.SIte
				where nome_site = @nome_site
			End
	End
else if @Tipo = 'B' 
	Begin
		if @cd_site <> '' or @cd_site is not NULL
			Begin
				select cd_site, nome_site from dbo.Site
				where cd_site = @cd_site 
			End
		else
			Begin
				select cd_site, nome_site from dbo.Site
				where nome_site = @nome_site
			End	
	End


GO
