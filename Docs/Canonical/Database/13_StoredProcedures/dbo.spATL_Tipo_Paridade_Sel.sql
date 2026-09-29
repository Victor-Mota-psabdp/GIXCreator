SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[spATL_Tipo_Paridade_Sel]'','','A'
--sp_help Tipo_Paridade
CREATE procedure [dbo].[spATL_Tipo_Paridade_Sel]
(
	@Cd_Tp_Par		varchar(3),
	@Nome_Tp_Par	varchar(50),
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
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A' 
	Begin
		select 
			Cd_Tp_Par	[Code],			
			Nome_Tp_Par	[Exchange Rates Type Name],
			Parametro	[Parameter],
			Padrao		[Standard],
			[Status]	[Enabled] 
		from 
			Tipo_Paridade with(nolock)
	End
	
if  @Tipo = 'B'
	Begin
		select 
			Cd_Tp_Par	[Code],			
			Nome_Tp_Par [Exchange Rates Type Name],
			Parametro	[Parameter],
			Padrao		[Standard],
			[Status]	[Enabled]
		from 
			Tipo_Paridade with(nolock)
		where 
			[Status] = 1
	End

if @Tipo = 'C' 
	Begin
		select 
			Cd_Tp_Par	[Code],			
			Nome_Tp_Par [Exchange Rates Type Name],
			Parametro	[Parameter],
			Padrao		[Standard],
			[Status]	[Enabled]
		from 
			Tipo_Paridade with(nolock)
		where 
			Cd_Tp_Par = @Cd_Tp_Par
	End
if @Tipo = 'D'
	Begin
		select 
			Cd_Tp_Par	[Code],			
			Nome_Tp_Par [Exchange Rates Type Name],
			Parametro	[Parameter],
			Padrao		[Standard],
			[Status]	[Enabled]
		from 
			Tipo_Paridade with(nolock)
		where 
			Cd_Tp_Par = @Cd_Tp_Par AND [Status] = 1
	End
if @Tipo = 'N' 
	Begin
		select 
			Cd_Tp_Par	[Code],			
			Nome_Tp_Par [Exchange Rates Type Name],
			Parametro	[Parameter],
			Padrao		[Standard],
			[Status]	[Enabled]
		from 
			Tipo_Paridade with(nolock)
		where 
			Nome_Tp_Par = @Nome_Tp_Par
	End
if  @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Par	[Code],			
			Nome_Tp_Par [Exchange Rates Type Name],
			Parametro	[Parameter],
			Padrao		[Standard],
			[Status]	[Enabled]
		from 
			Tipo_Paridade with(nolock)
		where 
			Nome_Tp_Par = @Nome_Tp_Par AND [Status] = 1
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Par	[Code],			
			Nome_Tp_Par [Exchange Rates Type Name],
			Parametro	[Parameter],
			Padrao		[Standard],
			[Status]	[Enabled]
		from 
			Tipo_Paridade with(nolock)
		where 
			Nome_Tp_Par = @Nome_Tp_Par
			 and Cd_Tp_Par <> @Cd_Tp_Par		
	End

GO
