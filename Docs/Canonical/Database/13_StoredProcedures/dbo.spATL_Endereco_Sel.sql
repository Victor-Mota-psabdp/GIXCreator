SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Endereco
CREATE PROCEDURE [dbo].[spATL_Endereco_Sel] 
(
	@Cd_Pes			varchar(10),
	@Cd_Tp_End		varchar(3),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Statuss
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Statuss
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Statuss
*/

if @Tipo = 'A'  OR @Tipo = 'B'
	Begin	
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
				isnull(ED.Pais + '-' + ED.CD_pais,'|') Complete,

			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM			dbo.Endereco		ED	WITH (nolock)
			JOIN		dbo.Pessoa			P	WITH (nolock) ON P.Cd_Pes		= ED.Cd_Pes
			LEFT JOIN	dbo.Tipo_Atividade	TA	WITH (nolock) ON P.Cd_Tp_Ativ	= TA.Cd_Tp_Ativ 
			LEFT JOIN	dbo.Tipo_Grupo		TG	WITH (nolock) ON P.Cd_Tp_Grupo	= TG.Cd_Tp_Grupo 
			LEFT JOIN	dbo.Usuario			US	WITH (nolock) ON P.Cd_Usuario	= US.Cd_Usuario
			JOIN		dbo.Tipo_Endereco	TE	WITH (nolock) ON TE.Cd_Tp_End	= ED.Cd_Tp_End
			LEFT Join	dbo.Pais			PA	WITH (nolock) ON PA.Cd_Pais		= ED.CD_pais
		WHERE 
			ED.Cd_Pes=@cd_pes	

	End
	
if @Tipo = 'C' OR  @Tipo = 'D'
	Begin
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
				isnull(ED.Pais + '-' + ED.CD_pais,'|') Complete,

			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM			dbo.Endereco		ED	WITH (nolock)
			JOIN		dbo.Pessoa			P	WITH (nolock) ON P.Cd_Pes		= ED.Cd_Pes
			LEFT JOIN	dbo.Tipo_Atividade	TA	WITH (nolock) ON P.Cd_Tp_Ativ	= TA.Cd_Tp_Ativ 
			LEFT JOIN	dbo.Tipo_Grupo		TG	WITH (nolock) ON P.Cd_Tp_Grupo	= TG.Cd_Tp_Grupo 
			LEFT JOIN	dbo.Usuario			US	WITH (nolock) ON P.Cd_Usuario	= US.Cd_Usuario
			JOIN		dbo.Tipo_Endereco	TE	WITH (nolock) ON TE.Cd_Tp_End	= ED.Cd_Tp_End
			LEFT Join	dbo.Pais			PA	WITH (nolock) ON PA.Cd_Pais		= ED.CD_pais
		WHERE 
			ED.Cd_Pes=@cd_pes
	End

if @Tipo = 'N' OR @Tipo = 'O'
	Begin
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
				isnull(ED.Pais + '-' + ED.CD_pais,'|') Complete,

			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM			dbo.Endereco		ED	WITH (nolock)
			JOIN		dbo.Pessoa			P	WITH (nolock) ON P.Cd_Pes		= ED.Cd_Pes
			LEFT JOIN	dbo.Tipo_Atividade	TA	WITH (nolock) ON P.Cd_Tp_Ativ	= TA.Cd_Tp_Ativ 
			LEFT JOIN	dbo.Tipo_Grupo		TG	WITH (nolock) ON P.Cd_Tp_Grupo	= TG.Cd_Tp_Grupo 
			LEFT JOIN	dbo.Usuario			US	WITH (nolock) ON P.Cd_Usuario	= US.Cd_Usuario
			JOIN		dbo.Tipo_Endereco	TE	WITH (nolock) ON TE.Cd_Tp_End	= ED.Cd_Tp_End
			LEFT Join	dbo.Pais			PA	WITH (nolock) ON PA.Cd_Pais		= ED.CD_pais
		WHERE 
			ED.Cd_Pes=@cd_pes and 
			ED.Cd_Tp_End = @Cd_Tp_End
	End
	

if @Tipo = 'I' --or @Tipo = 'O'
	Begin
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
				isnull('Street:' + ED.Rua,'|') +
				isnull('Nº:'+ ED.Numero,'|') +
				isnull('-'+ ED.Compl_End + '|','|') +
				isnull('ZIP Code:'+ltrim(ED.CEP) + '|','|') +
				isnull('City:'+ ED.Cidade,'|') +
				isnull('UF:'+ ED.UF,'|')  +
				isnull('Country:'+ PA.Nome_Pais,'|') Complete,
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]			
		FROM			dbo.Endereco		ED	WITH (nolock)
			JOIN		dbo.Pessoa			P	WITH (nolock) ON P.Cd_Pes		= ED.Cd_Pes
			LEFT JOIN	dbo.Tipo_Atividade	TA	WITH (nolock) ON P.Cd_Tp_Ativ	= TA.Cd_Tp_Ativ 
			LEFT JOIN	dbo.Tipo_Grupo		TG	WITH (nolock) ON P.Cd_Tp_Grupo	= TG.Cd_Tp_Grupo 
			LEFT JOIN	dbo.Usuario			US	WITH (nolock) ON P.Cd_Usuario	= US.Cd_Usuario
			JOIN		dbo.Tipo_Endereco	TE	WITH (nolock) ON TE.Cd_Tp_End	= ED.Cd_Tp_End
			LEFT Join	dbo.Pais			PA	WITH (nolock) ON PA.Cd_Pais		= ED.CD_pais
		WHERE 
			ED.Cd_Pes=@cd_pes and 
			ED.Cd_Tp_End = @Cd_Tp_End
	End










GO
