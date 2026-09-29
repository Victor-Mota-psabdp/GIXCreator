SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Navio_LLP
CREATE VIEW [dbo].[vwATL_Navio_LLP_Sel]
AS
	SELECT
			Id_Navio				[Code],
			Nome_Navio				[Vessel Name] ,
			Cd_Nacionalidade		[Nacionality],
			LLoyd					[LLoyd],
			a.cd_pais				[Country Code],
			P.Nome_Pais				[Country Name],
			a.cd_armador			[Carrier Code],
			r.Nome_Armador			[Carrier Name]
			--a.cd_usuario			[User Code],
			--u.Nome_Usuario			[User Name]						
		FROM 
			Navio_LLP A with(nolock)
			left join Pais P on P.Cd_Pais = A.cd_pais
			left join Armador R on R.Cd_Armador = A.cd_armador
			--left join Usuario U on U.Cd_Usuario = A.Cd_Usuario




GO
