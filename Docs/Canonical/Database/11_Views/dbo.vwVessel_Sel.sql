SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwVessel_Sel] 

AS
	Select DISTINCT		
		NV.Nome_Navio			[01_Vessel Name],
		PA.Nome_Pais 			[02_Country],
		NV.Lloyd	 			[03_Lloyd]		
	From
		Navio			NV
		left Join Pais		PA	on PA.Cd_pais = NV.cd_pais	

	--Select DISTINCT		
	--	NV.Nome_Navio			[01_Vessel Name],
	--	PA.Nome_Pais 			[02_Country],
	--	NV.Lloyd	 			[03_Lloyd]		
	--From
	--	Navio			NV
	--	left Join Pais		PA	on PA.Cd_pais = NV.cd_pais		












GO
