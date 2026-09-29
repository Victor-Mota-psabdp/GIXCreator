SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Endereco
CREATE VIEW [dbo].[vwEndereco_Sel]
AS
	select
		ED.Cd_Pes		[Company Code],
		P.Apelido		[Company Name (Short name)],
		P.Nome_Raz_Soc	[Complete Name],
		ED.Cd_Tp_End	[Address Type Code],
		TE.Nome_Tp_End	[Address Type Name],
		ED.Rua			[Address],
		ED.Numero		[Number],
		ED.Compl_End	[Complement],
		ED.CEP			[ZIP],
		ED.Bairro		[Neighbourhood],
		ED.UF			[ST],
		ED.Cidade		[City], 
		ED.Pais			[Country],
		ED.CD_pais		[Country Code],
		PA.Nome_Pais	[Country Name],
		ED.scac			[SCAC],
		ED.Cod_IBGE		[IBGE Code],
		P.Nome_Raz_Soc + '|' +
			isnull(P.Num_CPF_CNPJ + '|','|') +
			isnull('Street:' + ED.Rua,'|') + isnull('Nº:'+ ED.Numero,',|') +
			isnull('-' + ED.compl_end + '  |','|') +
			isnull('CEP: '+ltrim(ED.Cep) + '|','|') +
			isnull(ED.Cidade,'|') +
			isnull(ED.Pais + '-' + ED.CD_pais,'|') Completo
	FROM
		endereco ED with(nolock)
		join Pessoa P with(nolock) on P.Cd_Pes = ED.Cd_Pes
		Join Tipo_Endereco TE with(nolock) on TE.Cd_Tp_End=ED.Cd_Tp_End
		LEFT Join Pais PA with(nolock) on PA.Cd_Pais = ED.CD_pais

GO
