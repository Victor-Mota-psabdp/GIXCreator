SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Idioma
CREATE procedure [dbo].[spATL_Idioma_Del](
	@Cd_Idioma varchar(3)
)
as
	--if exists(select Cd_Idioma from Idioma where Cd_Idioma= @Cd_Idioma)
	--BEGIN
	--	delete Idioma where Cd_Idioma= @Cd_Idioma
	--END
GO
