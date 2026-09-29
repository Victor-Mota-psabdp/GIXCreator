SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[spATL_Tipo_Courier_Sel]'','','A'
--sp_help Tipo_Courier
CREATE procedure [dbo].[spATL_Tipo_Courier_Sel]
(
	@ID_Tp_Courier		Int,
	@Nome_Tp_Courier	varchar(50),
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
			ID_Tp_Courier  [Code],			
			Nome_Tp_Courier	[Courier Type Name],
			[Status]		[Enabled] 
		from 
			Tipo_Courier with(nolock)
	End
	
if  @Tipo = 'B'
	Begin
		select 
			ID_Tp_Courier  [Code],			
			Nome_Tp_Courier	[Courier Type Name],
			[Status]		[Enabled] 
		from 
			Tipo_Courier with(nolock)
		where 
			[Status] = 1
	End

if @Tipo = 'C' 
	Begin
		select 
			ID_Tp_Courier  [Code],			
			Nome_Tp_Courier	[Courier Type Name],
			[Status]		[Enabled] 
		from 
			Tipo_Courier with(nolock)
		where 
			ID_Tp_Courier = @ID_Tp_Courier
	End
if @Tipo = 'D'
	Begin
		select 
			ID_Tp_Courier  [Code],			
			Nome_Tp_Courier	[Courier Type Name],
			[Status]		[Enabled] 
		from 
			Tipo_Courier with(nolock)
		where 
			ID_Tp_Courier = @ID_Tp_Courier AND [Status] = 1
	End
if @Tipo = 'N' 
	Begin
		select 
			ID_Tp_Courier  [Code],			
			Nome_Tp_Courier	[Courier Type Name],
			[Status]		[Enabled] 
		from 
			Tipo_Courier with(nolock)
		where 
			Nome_Tp_Courier = @Nome_Tp_Courier
	End
if  @Tipo = 'O'
	Begin
		select 
			ID_Tp_Courier  [Code],
			
			Nome_Tp_Courier	[Courier Type Name],
			[Status]		[Enabled] 
		from 
			Tipo_Courier with(nolock)
		where 
			Nome_Tp_Courier = @Nome_Tp_Courier AND [Status] = 1
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select 
			ID_Tp_Courier  [Code],			
			Nome_Tp_Courier	[Courier Type Name],
			[Status]		[Enabled] 
		from 
			Tipo_Courier with(nolock)
		where 
			Nome_Tp_Courier = @Nome_Tp_Courier
			 and ID_Tp_Courier <> @ID_Tp_Courier		
	End

GO
