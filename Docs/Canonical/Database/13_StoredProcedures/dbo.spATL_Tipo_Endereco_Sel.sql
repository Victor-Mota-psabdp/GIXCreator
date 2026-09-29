SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Endereco
--cadu 02/11/2022 - 15:55h
CREATE procedure [dbo].[spATL_Tipo_Endereco_Sel]
(
	@Cd_Tp_End		varchar(3),
	@Nome_Tp_End	varchar(30),
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
			Cd_Tp_End [Code], Nome_Tp_End [Address Type Name]
		from 
			Tipo_Endereco T with(nolock)

	End
	
if @Tipo = 'C' OR  @Tipo = 'D'
	Begin
		select 
			Cd_Tp_End [Code], Nome_Tp_End [Address Type Name]
		from 
			Tipo_Endereco T with(nolock)
		where
			Cd_Tp_End = @Cd_Tp_End
	End

if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
			Cd_Tp_End [Code], Nome_Tp_End [Address Type Name]
		from 
			Tipo_Endereco T with(nolock)
		where
			Nome_Tp_End = @Nome_Tp_End
	End
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Tp_End [Code], Nome_Tp_End [Address Type Name]
		from 
			Tipo_Endereco T with(nolock)
		where
			Nome_Tp_End = @Nome_Tp_End
			AND Cd_Tp_End <> @Cd_Tp_End
	End

----sp_help Tipo_Endereco
--ALTER procedure [dbo].[spATL_Tipo_Endereco_Sel]
--(
--	@Cd_Tp_End		varchar(3),
--	@Nome_Tp_End	varchar(30),
--	@Tipo char(1)
--)
--as

--/*
--A, /// Todos os registros - Existentes
--B, /// Todos os registros - Statuss
--C, /// Busca pelo Codigo - Existentes
--D, /// Busca pelo Codigo - Statuss
--N, /// Busca pelo Nome - Existentes
--O /// Busca pelo Nome - Statuss
--*/

--if @Tipo = 'A'  OR @Tipo = 'B'
--	Begin
--		select 
--			Cd_Tp_End [Code], Nome_Tp_End [Adress Type Name]
--		from 
--			Tipo_Endereco T with(nolock)

--	End
	
--if @Tipo = 'C' OR  @Tipo = 'D'
--	Begin
--		select 
--			Cd_Tp_End [Code], Nome_Tp_End [Adress Type Name]
--		from 
--			Tipo_Endereco T with(nolock)
--		where
--			Cd_Tp_End = @Cd_Tp_End
--	End

--if @Tipo = 'N' OR @Tipo = 'O'
--	Begin
--		select 
--			Cd_Tp_End [Code], Nome_Tp_End [Adress Type Name]
--		from 
--			Tipo_Endereco T with(nolock)
--		where
--			Nome_Tp_End = @Nome_Tp_End
--	End
	

--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		select 
--			Cd_Tp_End [Code], Nome_Tp_End [Adress Type Name]
--		from 
--			Tipo_Endereco T with(nolock)
--		where
--			Nome_Tp_End = @Nome_Tp_End
--			AND Cd_Tp_End <> @Cd_Tp_End
--	End

GO
