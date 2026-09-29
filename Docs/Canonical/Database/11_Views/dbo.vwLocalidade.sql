SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwLocalidade]
AS
SELECT 
			LC.Cd_Local			[Code],
			LC.Nome_Local		[Place Name],
			LC.Cidade_Local		[City], 
			LC.Cd_Pais			[Country Code],
			P.Nome_Pais			[Country Name],
			LC.Pais_Local		[Country],
			lc.Cd_Regiao		[Region Code],
			RG.Nome_Regiao		[Region Name], 
			LC.BITRI			[BI/TRI Code], 
			LC.IATACODE			[IATA Code], 
			LC.SCAC				[SCAC Code], 
			CAST(CASE WHEN Aerop = 'S' THEN 1 ELSE 0 END AS BIT) [Airport], 
			CAST(CASE WHEN Porto = 'S' THEN 1 ELSE 0 END AS BIT) [Port], 
			CAST(CASE WHEN Gate = 'S' THEN 1 ELSE 0 END AS BIT) [Gateway], 
			CAST(CASE WHEN Desat_loc = 'S' THEN 0 ELSE 1 END AS BIT) [Enable], 
			LC.dt_criacao[Created Date]
		FROM dbo.Localidade AS LC WITH (nolock) 
		LEFT OUTER JOIN dbo.regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0'

GO
