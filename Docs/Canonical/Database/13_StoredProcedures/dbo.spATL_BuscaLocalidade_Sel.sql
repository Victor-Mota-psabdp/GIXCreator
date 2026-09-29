SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_BuscaLocalidade_Sel] --'0',''
	@Cd_Local varchar(3),
	@Nome_Local varchar(30)
as

IF @Nome_Local is not NULL and @Nome_Local <> ''
	Begin
		SELECT Nome_Local FROM Localidade with(nolock) where Nome_Local = @Nome_Local and Desat_loc  = 'N'
	End
Else
	Begin
		SELECT Nome_Local FROM Localidade with(nolock) where Cd_Local = @Cd_Local and Desat_loc  = 'N'		
	End






GO
