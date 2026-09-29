SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Carga
CREATE procedure [dbo].[spATL_Tipo_Carga_Sel]--'CSR','Faturamento','z'
(
	@Cd_Tp_Carga INT,
	@Nome_Tp_Carga varchar(30),
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
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A' 
	Begin
		select 
			Cd_Tp_Carga  [Code],
			Nome_Tp_Carga	[Type of Cargo], 
			Nome_Tp_Carga	[Cargo Type Name],
			Ativo_TP		[Enabled] 
		from 
			Tipo_Carga with(nolock)
	End
	
if  @Tipo = 'B'
	Begin
		select 
			Cd_Tp_Carga  [Code],
			Nome_Tp_Carga	[Type of Cargo], 
			Nome_Tp_Carga	[Cargo Type Name],
			Ativo_TP		[Enabled] 
		from 
			Tipo_Carga with(nolock)
		where 
			Ativo_TP ='S'
	End

if @Tipo = 'C' 
	Begin
		select 
			Cd_Tp_Carga  [Code],
			Nome_Tp_Carga	[Type of Cargo], 
			Nome_Tp_Carga	[Cargo Type Name],
			Ativo_TP		[Enabled] 
		from 
			Tipo_Carga with(nolock)
		where 
			Cd_Tp_Carga = @Cd_Tp_Carga
	End
if @Tipo = 'D'
	Begin
		select 
			Cd_Tp_Carga  [Code],
			Nome_Tp_Carga	[Type of Cargo], 
			Nome_Tp_Carga	[Cargo Type Name],
			Ativo_TP		[Enabled] 
		from 
			Tipo_Carga with(nolock)
		where 
			Cd_Tp_Carga = @Cd_Tp_Carga AND Ativo_TP ='S'
	End
if @Tipo = 'N' 
	Begin
		select 
			Cd_Tp_Carga  [Code],
			Nome_Tp_Carga	[Type of Cargo], 
			Nome_Tp_Carga	[Cargo Type Name],
			Ativo_TP		[Enabled] 
		from 
			Tipo_Carga with(nolock)
		where 
			Nome_Tp_Carga = @Nome_Tp_Carga
	End
if  @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Carga  [Code],
			Nome_Tp_Carga	[Type of Cargo], 
			Nome_Tp_Carga	[Cargo Type Name],
			Ativo_TP		[Enabled] 
		from 
			Tipo_Carga with(nolock)
		where 
			Nome_Tp_Carga = @Nome_Tp_Carga AND Ativo_TP ='S'
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Carga  [Code],
			Nome_Tp_Carga	[Type of Cargo], 
			Nome_Tp_Carga	[Cargo Type Name],
			Ativo_TP		[Enabled] 
		from 
			Tipo_Carga with(nolock)
		where 
			Nome_Tp_Carga = @Nome_Tp_Carga
			 and Cd_Tp_Carga <> @Cd_Tp_Carga		
	End

GO
