SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_Localidade_Sel '','','B'
CREATE procedure [dbo].[spATL_Localidade_Sel]
(
	@Cd_Local varchar(3),
	@Nome_Local varchar(30),
	@Tipo char(1)
)

as
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A'
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0'
	End

if @Tipo = 'B'
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' and Desat_loc = 'N'
	End

if @Tipo = 'C'
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' and	Cd_Local = @Cd_Local
	End

if @Tipo = 'D'
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' and	Cd_Local = @Cd_Local and Desat_loc = 'N'
	End

if @Tipo = 'N'
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' and	Cd_Local = @Cd_Local
	End

if @Tipo = 'O'
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' and Nome_Local = @Nome_Local and Desat_loc = 'N'
	End
	
if @Tipo = 'Z' 
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' and Nome_Local = @Nome_Local AND Cd_Local <> @Cd_Local
	End
	

	
if @Tipo = 'I' --IATA
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' 
			and LC.IATACODE= @Cd_Local and Desat_loc = 'N'
	End

if @Tipo = 'S' --scac
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' 
			and	LC.SCAC = @Cd_Local 
			and Desat_loc = 'N'
				
	End
	
if @Tipo = 'R' --truck or rail
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' 
			and (LC.SCAC = @Cd_Local or RIGHT(LC.BITRI,3) =@Cd_Local )
			and Desat_loc = 'N'
				
	End
	
if @Tipo = 'T' --truck or rail
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' 
			and (LC.SCAC = @Cd_Local or RIGHT(LC.BITRI,3) =@Cd_Local )
			and Desat_loc = 'N'
	End

	if @Tipo = 'P' --Proibido //Leandro 23-09
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' and	Nome_Local = @Nome_Local and Desat_loc = 'N' and P.Proibido = 1
	End

	if @Tipo = 'Y' --Proibido //Leandro 23-09
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' and	Nome_Local = @Nome_Local and Desat_loc = 'N' and P.Bloqueado = 1
	End

/*
--spATL_Localidade_Sel '','','B'
ALTER procedure [dbo].[spATL_Localidade_Sel]
(
	@Cd_Local varchar(3),
	@Nome_Local varchar(30),
	@Tipo char(1)
)

as
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A'
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0'
	End

if @Tipo = 'B'
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' and Desat_loc = 'N'
	End

if @Tipo = 'C'
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' and	Cd_Local = @Cd_Local
	End

if @Tipo = 'D'
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' and	Cd_Local = @Cd_Local and Desat_loc = 'N'
	End

if @Tipo = 'N'
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' and	Cd_Local = @Cd_Local
	End

if @Tipo = 'O'
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' and Nome_Local = @Nome_Local and Desat_loc = 'N'
	End
	
if @Tipo = 'Z' 
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' and Nome_Local = @Nome_Local AND Cd_Local <> @Cd_Local
	End
	

	
if @Tipo = 'I' --IATA
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' 
			and LC.IATACODE= @Cd_Local and Desat_loc = 'N'
	End

if @Tipo = 'S' --scac
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' 
			and	LC.SCAC = @Cd_Local 
			and Desat_loc = 'N'
				
	End
	
if @Tipo = 'R' --truck or rail
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' 
			and (LC.SCAC = @Cd_Local or RIGHT(LC.BITRI,3) =@Cd_Local )
			and Desat_loc = 'N'
				
	End
	
if @Tipo = 'T' --truck or rail
	Begin
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
		LEFT OUTER JOIN dbo.Regiao AS RG WITH (nolock) ON LC.Cd_Regiao = RG.Cd_Regiao
		LEFT OUTER JOIN dbo.Pais AS P WITH (nolock) ON LC.Cd_Pais = P.Cd_Pais
		where 
			Cd_Local <>'0' 
			and (LC.SCAC = @Cd_Local or RIGHT(LC.BITRI,3) =@Cd_Local )
			and Desat_loc = 'N'
	End



--spATL_Localidade_Sel '','','T'
ALTER procedure [dbo].[spATL_Localidade_Sel]
(
	@Cd_Local varchar(3),
	@Nome_Local varchar(30),
	@Tipo char(1)
)

as
/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A'
	Begin
		select Cd_Local ,Nome_Local  from Localidade with(nolock)
	End

if @Tipo = 'B'
	Begin
		select Cd_Local ,Nome_Local  from Localidade with(nolock) where Desat_loc = 'N'
	End

if @Tipo = 'C'
	Begin
		select Cd_Local ,Nome_Local  from Localidade with(nolock)
		where Cd_Local = @Cd_Local
	End

if @Tipo = 'D'
	Begin
		select Cd_Local ,Nome_Local  from Localidade with(nolock) 
		where  Cd_Local = @Cd_Local and Desat_loc = 'N'
	End

if @Tipo = 'N'
	Begin
		select Cd_Local ,Nome_Local  from Localidade with(nolock)
		where Cd_Local = @Cd_Local
	End

if @Tipo = 'O'
	Begin
		select Cd_Local ,Nome_Local  from Localidade with(nolock) 
		where  Nome_Local = @Nome_Local and Desat_loc = 'N'
	End
if @Tipo = 'Z' 
	Begin
		select Cd_Local ,Nome_Local  from Localidade  with(nolock)
		where Nome_Local = @Nome_Local AND Cd_Local <> @Cd_Local
	End
	
if @Tipo = 'T'
	Begin
		select 
				Cd_Local [Code],
				Nome_Local [Place Name],
				Cidade_Local [City] ,
				Pais_Local [Country],
				RG.Nome_Regiao [Region],
				BITRI [BI/TRI],
				IATACODE [IATA Code],
				SCAC [SCAC],
				Cast(Case when Aerop = 'S' then 1 else 0 End AS BIT)  [Airport],
				Cast(Case when Porto = 'S' then 1 else 0 End AS BIT)  [Port],
				Cast(Case when Gate = 'S' then 1 else 0 End AS BIT)  [Gateway],
				Cast(Case when Desat_loc = 'S' then 0 else 1 End AS BIT)  [Enable],
				dt_criacao [Created Date]
		from 
				Localidade LC with(nolock) 
		left join Regiao RG with(nolock) on LC.Cd_Regiao= RG.Cd_Regiao
		where Cd_Local = @Cd_Local or @Cd_Local = ''
	End
	
	
*/
GO
