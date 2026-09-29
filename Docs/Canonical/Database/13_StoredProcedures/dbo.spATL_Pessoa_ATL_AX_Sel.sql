SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Pessoa_ATL_AX
CREATE procedure [dbo].[spATL_Pessoa_ATL_AX_Sel]
(
	@Cd_Pes			VarChar(10),
	@cd_ax			Int,
	@Type			char(1),
	@Tipo			char(1)
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
				,NULL					[Complete]
		from
			Pessoa_ATL_AX LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			join Endereco ED with(nolock) on ed.cd_pes=LLP.cd_pes and cd_tp_end='COM' 
			Join Tipo_Endereco TE with(nolock) on TE.Cd_Tp_End=ED.Cd_Tp_End
			LEFT Join Pais PA with(nolock) on PA.Cd_Pais = ED.CD_pais
		Where
			LLP.Cd_Pes = @Cd_Pes and llp.Tipo = @Type 
	ENd
if @Tipo = 'B'
	Begin
		Select 
			LLP.Cd_Pes				[Company Code],
			P.Apelido				[Company Name (Short name)],
			P.Apelido				[Company Name],
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
				,NULL					[Complete]
		from
			Pessoa_ATL_AX LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			join Endereco ED with(nolock) on ed.cd_pes=LLP.cd_pes and cd_tp_end='COM' 
			Join Tipo_Endereco TE with(nolock) on TE.Cd_Tp_End=ED.Cd_Tp_End
			LEFT Join Pais PA with(nolock) on PA.Cd_Pais = ED.CD_pais
		where 
			LLP.Cd_Pes = @Cd_Pes and llp.Tipo = @Type
			and	P.Desat_Pes = 'N'
	End

if @Tipo = 'C' 
	Begin
		Select 
			LLP.Cd_Pes				[Company Code],
			P.Apelido				[Company Name (Short name)],
			P.Apelido				[Company Name],
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
				,NULL					[Complete]
		from
			Pessoa_ATL_AX LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			join Endereco ED with(nolock) on ed.cd_pes=LLP.cd_pes and cd_tp_end='COM' 
			Join Tipo_Endereco TE with(nolock) on TE.Cd_Tp_End=ED.Cd_Tp_End
			LEFT Join Pais PA with(nolock) on PA.Cd_Pais = ED.CD_pais
		where 
			LLP.Cd_Pes = @Cd_Pes and llp.Tipo = @Type						
	End	
if @Tipo = 'D'
	Begin
		Select 
			LLP.Cd_Pes				[Company Code],
			P.Apelido				[Company Name (Short name)],
			P.Apelido				[Company Name],
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
				,NULL					[Complete]
		from
			Pessoa_ATL_AX LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			join Endereco ED with(nolock) on ed.cd_pes=LLP.cd_pes and cd_tp_end='COM' 
			Join Tipo_Endereco TE with(nolock) on TE.Cd_Tp_End=ED.Cd_Tp_End
			LEFT Join Pais PA with(nolock) on PA.Cd_Pais = ED.CD_pais
		where 
			LLP.Cd_Pes = @Cd_Pes and llp.Tipo = @Type	
			and P.Desat_Pes = 'N'
	End	
	
if @Tipo = 'N' 
	Begin
		Select 
			LLP.Cd_Pes				[Company Code],
			P.Apelido				[Company Name (Short name)],
			P.Apelido				[Company Name],
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
				,NULL					[Complete]
		from
			Pessoa_ATL_AX LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			join Endereco ED with(nolock) on ed.cd_pes=LLP.cd_pes and cd_tp_end='COM' 
			Join Tipo_Endereco TE with(nolock) on TE.Cd_Tp_End=ED.Cd_Tp_End
			LEFT Join Pais PA with(nolock) on PA.Cd_Pais = ED.CD_pais
		where 
			LLP.Cd_Pes = @Cd_Pes and llp.cd_ax = @cd_ax
			and llp.Tipo = @Type
		
	End	
if @Tipo = 'O' 
	Begin
		Select 
			LLP.Cd_Pes				[Company Code],
			P.Apelido				[Company Name (Short name)],
			P.Apelido				[Company Name],
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
				,NULL					[Complete]
		from
			Pessoa_ATL_AX LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			join Endereco ED with(nolock) on ed.cd_pes=LLP.cd_pes and cd_tp_end='COM' 
			Join Tipo_Endereco TE with(nolock) on TE.Cd_Tp_End=ED.Cd_Tp_End
			LEFT Join Pais PA with(nolock) on PA.Cd_Pais = ED.CD_pais
		where 
			LLP.Cd_Pes = @Cd_Pes and llp.cd_ax = @cd_ax
			and llp.Tipo = @Type and
			P.Desat_Pes = 'N'
	End
	
	

	

GO
