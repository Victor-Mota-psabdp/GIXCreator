SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPessoa_LLP_Sel]
AS
	Select 
			LLP.Cd_Pes				[Code],
			P.Apelido				[Company Name],
			P.Nome_Raz_Soc			[Complete Name],
			LLP.Cd_Planta			[Plant Code],
			LLP.Planta_Nome			[Plant Name],
			LLP.Cd_Pes_Grupo		[Group Code],
			LLP.Cd_Vendor			[Vendor Code],						
			LLP.RGLNumber			[RGLNumber],
			LLP.InvoiceGRP			[InvoiceGRP],
			G.Grupo					[Group Internal Code],
			PG.Apelido				[Group Name]
		from
			Pessoa_LLP LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			JOIN Grupo G ON G.Cd_Pes_Grupo = LLP.Cd_Pes_Grupo
			LEFT JOIN Pessoa PG on PG.Cd_Pes = G.Cd_Pes_Grupo
		where 
			P.Desat_Pes = 'N'



GO
