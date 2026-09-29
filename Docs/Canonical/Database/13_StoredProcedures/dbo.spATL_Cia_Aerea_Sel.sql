SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Cia_Aerea
CREATE PROCEDURE [dbo].[spATL_Cia_Aerea_Sel]
	@Cd_Cia_Aer varchar(3),
	@Nome_Cia_Aer varchar(30),
	@Tipo char(1)
	
as



if @Tipo = 'A' or @Tipo = 'B'
	Begin
		SELECT
			Cd_Cia_Aer		[Code],
			Nome_Cia_Aer	[Air Company Name],
			SCAC			[SCAC],
			IATA_CODE		[IATA_CODE],
			dt_criacao		[Created Date]
			,Prefix			[Prefix]
			,EfreightDescartes [EfreightDescartes]
		FROM 
			Cia_Aerea A with(nolock)
		WHERE
			Cd_Cia_Aer <> '0'
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			Cd_Cia_Aer		[Code],
			Nome_Cia_Aer	[Air Company Name] ,
			SCAC			[SCAC],
			IATA_CODE		[IATA_CODE],
			dt_criacao		[Created Date]
			,Prefix			[Prefix]
				,EfreightDescartes [EfreightDescartes]
		FROM 
			Cia_Aerea A with(nolock)
		where 
			Cd_Cia_Aer = @Cd_Cia_Aer AND Cd_Cia_Aer <> '0'
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		SELECT
			Cd_Cia_Aer		[Code],
			Nome_Cia_Aer	[Air Company Name] ,
			SCAC			[SCAC],
			IATA_CODE		[IATA_CODE],
			dt_criacao		[Created Date]
			,Prefix			[Prefix]
				,EfreightDescartes [EfreightDescartes]
		FROM 
			Cia_Aerea A with(nolock)
		where 
			Nome_Cia_Aer = @Nome_Cia_Aer
			AND Cd_Cia_Aer <> '0'
	End
	
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT
			Cd_Cia_Aer		[Code],
			Nome_Cia_Aer	[Air Company Name] ,
			SCAC			[SCAC],
			IATA_CODE		[IATA_CODE],
			dt_criacao		[Created Date]
			,Prefix			[Prefix]
				,EfreightDescartes [EfreightDescartes]
		FROM 
			Cia_Aerea A with(nolock)
		where
			Nome_Cia_Aer = @Nome_Cia_Aer and Cd_Cia_Aer <> @Cd_Cia_Aer			
	End

GO
