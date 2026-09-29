SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spSmartBITRI_Sel]
	@CD_Local VArchar(3)
	
AS

--if upper(@Cd_local) in ('MVD','MVE')
--	Begin
--		select BITRI+cd_local as Codigo,SCAC,BITRI cd_pais  from localidade with(nolock) where cd_local=@Cd_Local
	
--	End	
--else
	
	Begin
		select cd_pais+cd_local as Codigo,SCAC,cd_pais  from localidade with(nolock) where cd_local=@Cd_Local
	End


GO
