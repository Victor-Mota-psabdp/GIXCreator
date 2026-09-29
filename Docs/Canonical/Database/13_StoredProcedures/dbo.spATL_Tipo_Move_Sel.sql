SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Move
CREATE procedure [dbo].[spATL_Tipo_Move_Sel]
(
	@Cd_Tp_Move		varchar(2),
	@Nome_Tp_Move	varchar(100),
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

if @Tipo = 'A' 
	Begin
		select 
			Cd_Tp_Move [Code], 
			Nome_Tp_Move [Move Type Name],
			Status [Enabled],
			T.Cd_Usuario [User Code],
			U.Nome_Usuario [User Name],
			dt_ins [Insert Date]
		from Tipo_Move T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	End
	
if  @Tipo = 'B'
	Begin
		select 
			Cd_Tp_Move [Code], 
			Nome_Tp_Move [Move Type Name],
			Status [Enabled],
			T.Cd_Usuario [User Code],
			U.Nome_Usuario [User Name],
			dt_ins [Insert Date]
		from Tipo_Move T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Status = 1
	End

if @Tipo = 'C'
	Begin
		select 
			Cd_Tp_Move [Code], 
			Nome_Tp_Move [Move Type Name],
			Status [Enabled],
			T.Cd_Usuario [User Code],
			U.Nome_Usuario [User Name],
			dt_ins [Insert Date]
		from Tipo_Move T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Cd_Tp_Move = @Cd_Tp_Move and
			Status = 1
	End
if @Tipo = 'D'
	Begin
		select 
			Cd_Tp_Move [Code], 
			Nome_Tp_Move [Move Type Name],
			Status [Enabled],
			T.Cd_Usuario [User Code],
			U.Nome_Usuario [User Name],
			dt_ins [Insert Date]
		from Tipo_Move T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Cd_Tp_Move = @Cd_Tp_Move and
			Status = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			Cd_Tp_Move [Code], 
			Nome_Tp_Move [Move Type Name],
			Status [Enabled],
			T.Cd_Usuario [User Code],
			U.Nome_Usuario [User Name],
			dt_ins [Insert Date]
		from Tipo_Move T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Nome_Tp_Move = @Nome_Tp_Move
	End
	
if @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Move [Code], 
			Nome_Tp_Move [Move Type Name],
			Status [Enabled],
			T.Cd_Usuario [User Code],
			U.Nome_Usuario [User Name],
			dt_ins [Insert Date]
		from Tipo_Move T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Nome_Tp_Move = @Nome_Tp_Move and
			Status = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Move [Code], 
			Nome_Tp_Move [Move Type Name],
			Status [Enabled],
			T.Cd_Usuario [User Code],
			U.Nome_Usuario [User Name],
			dt_ins [Insert Date]
		from Tipo_Move T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Nome_Tp_Move = @Nome_Tp_Move
			AND Cd_Tp_Move <> @Cd_Tp_Move
	End

GO
