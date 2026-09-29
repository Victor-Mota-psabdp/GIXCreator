SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Navio_LLP
CREATE PROCEDURE [dbo].[spATLDN_Navio_LLP_Sel]
(
	@Id_Navio Int,
	@Nome_Navio varchar(50),
	@Tipo char(1)
)
	
as



if @Tipo = 'A' or @Tipo = 'B'
	Begin
		SELECT
			Id_Navio				[Code],
			Nome_Navio				[Vessel Name] ,
			Cd_Nacionalidade		[Nacionality],
			LLoyd					[LLoyd],
			a.cd_pais				[Country Code],
			P.Nome_Pais				[Country Name],
			a.cd_armador			[Carrier Code],
			r.Nome_Armador			[Carrier Name]
			--,a.cd_usuario			[User Code],
			--u.Nome_Usuario			[User Name]						
		FROM 
			Navio_LLP A with(nolock)
			left join Pais P on P.Cd_Pais = A.cd_pais
			left join Armador R on R.Cd_Armador = A.cd_armador
			--left join Usuario U on U.Cd_Usuario = A.Cd_Usuario
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			Id_Navio				[Code],
			Nome_Navio				[Vessel Name] ,
			Cd_Nacionalidade		[Nacionality],
			LLoyd					[LLoyd],
			a.cd_pais				[Country Code],
			P.Nome_Pais				[Country Name],
			a.cd_armador			[Carrier Code],
			r.Nome_Armador			[Carrier Name]
			--,a.cd_usuario			[User Code],
			--u.Nome_Usuario			[User Name]						
		FROM 
			Navio_LLP A with(nolock)
			left join Pais P on P.Cd_Pais = A.cd_pais
			left join Armador R on R.Cd_Armador = A.cd_armador
			--left join Usuario U on U.Cd_Usuario = A.Cd_Usuario
		where 
			Id_Navio = @Id_Navio 
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		SELECT
			Id_Navio				[Code],
			Nome_Navio				[Vessel Name] ,
			Cd_Nacionalidade		[Nacionality],
			LLoyd					[LLoyd],
			a.cd_pais				[Country Code],
			P.Nome_Pais				[Country Name],
			a.cd_armador			[Carrier Code],
			r.Nome_Armador			[Carrier Name]
			--,a.cd_usuario			[User Code],
			--u.Nome_Usuario			[User Name]						
		FROM 
			Navio_LLP A with(nolock)
			left join Pais P on P.Cd_Pais = A.cd_pais
			left join Armador R on R.Cd_Armador = A.cd_armador
			--left join Usuario U on U.Cd_Usuario = A.Cd_Usuario
		where 
			Nome_Navio = @Nome_Navio
	End
	
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT
			Id_Navio				[Code],
			Nome_Navio				[Vessel Name] ,
			Cd_Nacionalidade		[Nacionality],
			LLoyd					[LLoyd],
			a.cd_pais				[Country Code],
			P.Nome_Pais				[Country Name],
			a.cd_armador			[Carrier Code],
			r.Nome_Armador			[Carrier Name]
			--,a.cd_usuario			[User Code],
			--u.Nome_Usuario			[User Name]						
		FROM 
			Navio_LLP A with(nolock)
			left join Pais P on P.Cd_Pais = A.cd_pais
			left join Armador R on R.Cd_Armador = A.cd_armador
			--left join Usuario U on U.Cd_Usuario = A.Cd_Usuario
		where
			Nome_Navio = @Nome_Navio and Id_Navio <> @Id_Navio			
	End
GO
