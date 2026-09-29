SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Embalagem
--[spATL_Tipo_Embalagem_Sel]'BAL','','A'
CREATE procedure [dbo].[spATL_Tipo_Embalagem_Sel]--'BAL','','A'
(
	@Cd_Tp_Embal		VarChar(3), 
	@Nome_Tp_Embal		VarChar(30),
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

if @Tipo = 'A' 
	Begin
		select 
			T.Cd_Tp_Embal		[Code],
			T.Nome_Tp_Embal		[Package Name],
			T.Cd_Embal_Ofc		[Official Code],
			A.Nome_Embalagem	[Official Package Name],
			T.ISO_CODE			[ISO_CODE],
			Cd_Smart			[Code Smart],
			Convert(bit,(Case when T.Ativo = 'S' then 1 else 0 End)) [Enabled],
			--T.Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.Data				[Insert Date]			
			--Nome_Tp_Embal		[Nome Embalagem],
			--T.Cd_Embal_Ofc		[Code Official],			
			--Ativo,
			--Data,
			--T.Cd_Usuario, 
			--U.Nome_Usuario			
		from Tipo_Embalagem T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			left join Aux_Embalagem A  with(nolock) on A.Cd_Embal_Ofc=T.Cd_Embal_Ofc
		where
			Cd_Tp_Embal  <>'0'
		order by 2
	End
	
if  @Tipo = 'B'
	Begin
		select 
			T.Cd_Tp_Embal		[Code],
			T.Nome_Tp_Embal		[Package Name],
			T.Cd_Embal_Ofc		[Official Code],
			A.Nome_Embalagem	[Official Package Name],
			T.ISO_CODE			[ISO_CODE],
			Cd_Smart			[Code Smart],			
			Convert(bit,(Case when T.Ativo = 'S' then 1 else 0 End)) [Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.Data				[Insert Date]			
			--Nome_Tp_Embal		[Nome Embalagem],
			--T.Cd_Embal_Ofc		[Code Official],			
			--Ativo,
			--Data,
			--T.Cd_Usuario, 
			--U.Nome_Usuario			
		from Tipo_Embalagem T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			left join Aux_Embalagem A  with(nolock) on A.Cd_Embal_Ofc=T.Cd_Embal_Ofc
		where
			ativo = 'S' 
			and Cd_Tp_Embal  <> '0'
			order by 2
	End

if @Tipo = 'C'
	Begin
		select 
			T.Cd_Tp_Embal		[Code],
			T.Nome_Tp_Embal		[Package Name],
			T.Cd_Embal_Ofc		[Official Code],
			A.Nome_Embalagem	[Official Package Name],
			T.ISO_CODE			[ISO_CODE],
			Cd_Smart			[Code Smart],			
		Convert(bit,(Case when T.Ativo = 'S' then 1 else 0 End)) [Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.Data				[Insert Date]			
			--Nome_Tp_Embal		[Nome Embalagem],
			--T.Cd_Embal_Ofc		[Code Official],			
			--Ativo,
			--Data,
			--T.Cd_Usuario, 
			--U.Nome_Usuario			
		from Tipo_Embalagem T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			left join Aux_Embalagem A  with(nolock) on A.Cd_Embal_Ofc=T.Cd_Embal_Ofc
		where
			Cd_Tp_Embal = @Cd_Tp_Embal and
			ativo = 'S' and Cd_Tp_Embal  <> '0'
			order by 2
	End
if @Tipo = 'D'
	Begin
		select 
			T.Cd_Tp_Embal		[Code],
			T.Nome_Tp_Embal		[Package Name],
			T.Cd_Embal_Ofc		[Official Code],
			A.Nome_Embalagem	[Official Package Name],
			T.ISO_CODE			[ISO_CODE],
			Cd_Smart			[Code Smart],			
			Convert(bit,(Case when T.Ativo = 'S' then 1 else 0 End)) [Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.Data				[Insert Date]			
			--Nome_Tp_Embal		[Nome Embalagem],
			--T.Cd_Embal_Ofc		[Code Official],			
			--Ativo,
			--Data,
			--T.Cd_Usuario, 
			--U.Nome_Usuario			
		from Tipo_Embalagem T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			left join Aux_Embalagem A  with(nolock) on A.Cd_Embal_Ofc=T.Cd_Embal_Ofc
		where
			Cd_Tp_Embal = @Cd_Tp_Embal and
			ativo = 'S' and Cd_Tp_Embal  <> '0'
			order by 2
	End
	
if @Tipo = 'N'
	Begin
		select 
			T.Cd_Tp_Embal		[Code],
			T.Nome_Tp_Embal		[Package Name],
			T.Cd_Embal_Ofc		[Official Code],
			A.Nome_Embalagem	[Official Package Name],
			T.ISO_CODE			[ISO_CODE],
			Cd_Smart			[Code Smart],			
			Convert(bit,(Case when T.Ativo = 'S' then 1 else 0 End)) [Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.Data				[Insert Date]			
			--Nome_Tp_Embal		[Nome Embalagem],
			--T.Cd_Embal_Ofc		[Code Official],			
			--Ativo,
			--Data,
			--T.Cd_Usuario, 
			--U.Nome_Usuario			
		from Tipo_Embalagem T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			left join Aux_Embalagem A  with(nolock) on A.Cd_Embal_Ofc=T.Cd_Embal_Ofc
		where
			Nome_Tp_Embal = @Nome_Tp_Embal
			and Cd_Tp_Embal  <> '0'
			order by 2
	End
	
if @Tipo = 'O'
	Begin
		select 
			T.Cd_Tp_Embal		[Code],
			T.Nome_Tp_Embal		[Package Name],
			T.Cd_Embal_Ofc		[Official Code],
			A.Nome_Embalagem	[Official Package Name],
			T.ISO_CODE			[ISO_CODE],
			Cd_Smart			[Code Smart],			
			Convert(bit,(Case when T.Ativo = 'S' then 1 else 0 End)) [Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.Data				[Insert Date]			
			--Nome_Tp_Embal		[Nome Embalagem],
			--T.Cd_Embal_Ofc		[Code Official],			
			--Ativo,
			--Data,
			--T.Cd_Usuario, 
			--U.Nome_Usuario			
		from Tipo_Embalagem T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			left join Aux_Embalagem A  with(nolock) on A.Cd_Embal_Ofc=T.Cd_Embal_Ofc
		where
			Nome_Tp_Embal = @Nome_Tp_Embal and
			ativo = 'S'
			and Cd_Tp_Embal  <> '0'
			order by 2
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			T.Cd_Tp_Embal		[Code],
			T.Nome_Tp_Embal		[Package Name],
			T.Cd_Embal_Ofc		[Official Code],
			A.Nome_Embalagem	[Official Package Name],
			T.ISO_CODE			[ISO_CODE],
			Cd_Smart			[Code Smart],			
			Convert(bit,(Case when T.Ativo = 'S' then 1 else 0 End)) [Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			T.Data				[Insert Date]			
			--Nome_Tp_Embal		[Nome Embalagem],
			--T.Cd_Embal_Ofc		[Code Official],			
			--Ativo,
			--Data,
			--T.Cd_Usuario, 
			--U.Nome_Usuario			
		from Tipo_Embalagem T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			left join Aux_Embalagem A  with(nolock) on A.Cd_Embal_Ofc=T.Cd_Embal_Ofc
		where
			Nome_Tp_Embal = @Nome_Tp_Embal
			AND Cd_Tp_Embal <> isnull(@Cd_Tp_Embal,0)
	End

GO
