SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwATL_Pessoa_ATL_AX_Sel]
AS
	Select 
		LLP.Cd_Pes				[Company Code],
		P.Apelido				[Company Name (Short name)],
		P.Nome_Raz_Soc			[Complete Name],

		LLP.cd_ax				[AX Code],
		LLP.CNPJ				[CNPJ],
		LLP.Sales_Tax_Group		[Sales_Tax_Group],
		LLP.Tipo				[Type],
	
		ED.Cd_Tp_End			[Address Type Code],
		TE.Nome_Tp_End			[Address Type Name],
		ED.Rua					[Address],
		ED.Numero				[Number],
		ED.Compl_End			[Complement],
		ED.CEP					[ZIP],
		ED.Bairro				[Neighbourhood],
		ED.UF					[ST],
		ED.Cidade				[City], 
		ED.Pais					[Country],
		ED.CD_pais				[Country Code],
		PA.Nome_Pais			[Country Name],
		ED.scac					[SCAC],
		ED.Cod_IBGE				[IBGE Code]
	from
		Pessoa_ATL_AX LLP with(nolock)
		JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
		join Endereco ED with(nolock) on ed.cd_pes=LLP.cd_pes and cd_tp_end='COM' 
		Join Tipo_Endereco TE with(nolock) on TE.Cd_Tp_End=ED.Cd_Tp_End
		LEFT Join Pais PA with(nolock) on PA.Cd_Pais = ED.CD_pais
--WHERE     
--	(P.Desat_Pes = 'N')



GO
