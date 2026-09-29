SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Idioma
CREATE VIEW [dbo].[vwIdioma_Sel]
AS
	select Cd_Idioma AS Code,Nome_Idioma AS [Language Name] from Idioma with(nolock)
GO
