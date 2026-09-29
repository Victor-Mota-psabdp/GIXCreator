SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Pais_Sel](
	@Cd_Pais char(2),
	@Nome_Pais varchar(50),
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

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			P.Cd_Pais						[Code],  
			P.Nome_Pais						[Country Name], 
			P.FORM_A						[FORM_A],							
			P.Nome_Pais_PT					[Country Name PT],
			P.HTS							[HTS],				
			P.Paraiso_Fiscal				[Paraiso_Fiscal], 
			P.Proibido						[Prohibited], 
			P.Bloqueado						[Blocked],
			P.Cd_Pais_IBGE					[IBGE],
			P.Cd_M49						[M49],
			P.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			P.Ativo							[Enabled]


		from Pais P with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario= P.Cd_Usuario

		order by P.Cd_Pais
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select
			P.Cd_Pais						[Code],  
			P.Nome_Pais						[Country Name], 
			P.FORM_A						[FORM_A],							
			P.Nome_Pais_PT					[Country Name PT],
			P.HTS							[HTS],				
			P.Paraiso_Fiscal				[Paraiso_Fiscal], 
			P.Proibido						[Prohibited], 
			P.Bloqueado						[Blocked],
			P.Cd_Pais_IBGE					[IBGE],
			P.Cd_M49						[M49],
			P.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			P.Ativo							[Enabled]

		from Pais P with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario= P.Cd_Usuario

		where P.Cd_Pais = @Cd_Pais 	
		
		order by P.Cd_Pais
	End

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select
			P.Cd_Pais						[Code],  
			P.Nome_Pais						[Country Name], 
			P.FORM_A						[FORM_A],							
			P.Nome_Pais_PT					[Country Name PT],
			P.HTS							[HTS],				
			P.Paraiso_Fiscal				[Paraiso_Fiscal], 
			P.Proibido						[Prohibited], 
			P.Bloqueado						[Blocked],
			P.Cd_Pais_IBGE					[IBGE],
			P.Cd_M49						[M49],
			P.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			P.Ativo							[Enabled]

		from Pais P with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario= P.Cd_Usuario

		where 
			(P.Nome_Pais = @Nome_Pais or P.Nome_Pais_PT = @Nome_Pais)

		order by P.Cd_Pais
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select
			P.Cd_Pais						[Code],  
			P.Nome_Pais						[Country Name], 
			P.FORM_A						[FORM_A],							
			P.Nome_Pais_PT					[Country Name PT],
			P.HTS							[HTS],				
			P.Paraiso_Fiscal				[Paraiso_Fiscal], 
			P.Proibido						[Prohibited], 
			P.Bloqueado						[Blocked],
			P.Cd_Pais_IBGE					[IBGE],
			P.Cd_M49						[M49],
			P.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			P.Ativo							[Enabled]

		from Pais P with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario= P.Cd_Usuario

		where 
			P.Nome_Pais = @Nome_Pais
			AND P.Cd_Pais <> @Cd_Pais

		order by P.Cd_Pais
	End
/*
--sp_help Pais
ALTER procedure [dbo].[spATL_Pais_Sel](
	@Cd_Pais char(2),
	@Nome_Pais varchar(50),
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

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select Cd_Pais [Code], Nome_Pais [Nome Pais], FORM_A,
		Nome_Pais_PT [Nome Pais PT],--Paraiso_Fiscal,
		HTS 
		from Pais with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select Cd_Pais [Code], Nome_Pais [Nome Pais], FORM_A,
		Nome_Pais_PT [Nome Pais PT],--Paraiso_Fiscal,
		HTS 
		from Pais with(nolock)
		where Cd_Pais = @Cd_Pais
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select Cd_Pais [Code], Nome_Pais [Nome Pais], FORM_A,
		Nome_Pais_PT [Nome Pais PT],--Paraiso_Fiscal,
		HTS 
		from Pais with(nolock)
		where Nome_Pais = @Nome_Pais
	End
*/

GO
