SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Moeda
CREATE procedure [dbo].[spATL_Tipo_Moeda_Sel](
	@Cd_Tp_Moeda	varChar(3),
	@Nome_Tp_Moeda	varChar(30),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O, /// Busca pelo Nome - Ativos
Y, /// Busca pelo codiogo nacional da moeda 
*/

if @Tipo = 'A' 
	Begin
		select 
			Cd_Tp_Moeda [Code],
			Nome_Tp_Moeda [Type of Currency],
			Nome_Tp_Moeda [Currency Type Name],
			Cod_Nac_Moeda [National Code],
			Cod_Int_Moeda [International Code],
			Cd_Moeda_Ofc [Official Code], 
			Cd_Loc_Ofc [Cd_Loc_Ofc],
			ativo [Enabled]
		from 
			Tipo_Moeda with(nolock)
	End

if @Tipo = 'B'
	Begin
		select 
			Cd_Tp_Moeda [Code],
			Nome_Tp_Moeda [Type of Currency],
			Nome_Tp_Moeda [Currency Type Name],
			Cod_Nac_Moeda [National Code],
			Cod_Int_Moeda [International Code],
			Cd_Moeda_Ofc [Official Code], 
			Cd_Loc_Ofc [Cd_Loc_Ofc],
			ativo [Enabled]
		from 
			Tipo_Moeda with(nolock)
		where
			ativo =1
	End

if @Tipo = 'C' 
	Begin
		select 
			Cd_Tp_Moeda [Code],
			Nome_Tp_Moeda [Type of Currency],
			Nome_Tp_Moeda [Currency Type Name],
			Cod_Nac_Moeda [National Code],
			Cod_Int_Moeda [International Code],
			Cd_Moeda_Ofc [Official Code], 
			Cd_Loc_Ofc [Cd_Loc_Ofc],
			ativo [Enabled]
		from 
			Tipo_Moeda with(nolock)
		where 
			Cd_Tp_Moeda = @Cd_Tp_Moeda
	End
	
if  @Tipo = 'D'
	Begin
		select 
			Cd_Tp_Moeda [Code],
			Nome_Tp_Moeda [Type of Currency],
			Nome_Tp_Moeda [Currency Type Name],
			Cod_Nac_Moeda [National Code],
			Cod_Int_Moeda [International Code],
			Cd_Moeda_Ofc [Official Code], 
			Cd_Loc_Ofc [Cd_Loc_Ofc],
			ativo [Enabled]
		from 
			Tipo_Moeda with(nolock)
		where 
			Cd_Tp_Moeda = @Cd_Tp_Moeda
			and ativo =1
	End
	
if @Tipo = 'N' 
	Begin
		select 
			Cd_Tp_Moeda [Code],
			Nome_Tp_Moeda [Type of Currency],
			Nome_Tp_Moeda [Currency Type Name],
			Cod_Nac_Moeda [National Code],
			Cod_Int_Moeda [International Code],
			Cd_Moeda_Ofc [Official Code], 
			Cd_Loc_Ofc [Cd_Loc_Ofc],
			ativo [Enabled]
		from 
			Tipo_Moeda with(nolock)
		where 
			Nome_Tp_Moeda = @Nome_Tp_Moeda
	End
	
if @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Moeda [Code],
			Nome_Tp_Moeda [Type of Currency],
			Nome_Tp_Moeda [Currency Type Name],
			Cod_Nac_Moeda [National Code],
			Cod_Int_Moeda [International Code],
			Cd_Moeda_Ofc [Official Code], 
			Cd_Loc_Ofc [Cd_Loc_Ofc],
			ativo [Enabled]
		from 
			Tipo_Moeda with(nolock)
		where 
			Nome_Tp_Moeda = @Nome_Tp_Moeda
			and ativo =1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Moeda [Code],
			Nome_Tp_Moeda [Type of Currency],
			Nome_Tp_Moeda [Currency Type Name],
			Cod_Nac_Moeda [National Code],
			Cod_Int_Moeda [International Code],
			Cd_Moeda_Ofc [Official Code], 
			Cd_Loc_Ofc [Cd_Loc_Ofc],
			ativo [Enabled]
		from 
			Tipo_Moeda with(nolock)
		where 
			Nome_Tp_Moeda = @Nome_Tp_Moeda AND Cd_Tp_Moeda <> @Cd_Tp_Moeda
	End

if @Tipo = 'Y' 
	Begin
		select 
			Cd_Tp_Moeda [Code],
			Nome_Tp_Moeda [Type of Currency],
			Nome_Tp_Moeda [Currency Type Name],
			Cod_Nac_Moeda [National Code],
			Cod_Int_Moeda [International Code],
			Cd_Moeda_Ofc [Official Code], 
			Cd_Loc_Ofc [Cd_Loc_Ofc],
			ativo [Enabled]
		from 
			Tipo_Moeda with(nolock)
		where 
			left(Cod_Nac_Moeda,3) = @Cd_Tp_Moeda
	End

GO
