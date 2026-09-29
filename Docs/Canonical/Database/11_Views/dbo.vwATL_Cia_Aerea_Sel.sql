SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Cia_Aerea
CREATE VIEW [dbo].[vwATL_Cia_Aerea_Sel]
AS
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
	WHERE
		Cd_Cia_Aer <> '0'

GO
