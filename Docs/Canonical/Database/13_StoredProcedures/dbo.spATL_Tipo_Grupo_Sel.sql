SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Grupo
CREATE procedure [dbo].[spATL_Tipo_Grupo_Sel]
(
	@Cd_Tp_Grupo			VARCHAR(3),
	@Nome_Tp_Grupo			varchar(30),	
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

if @Tipo = 'A'   OR @Tipo = 'B'
	Begin
		select 
			Cd_Tp_Grupo [Code], Nome_Tp_Grupo [Group Type Name]
		from 
			Tipo_Grupo T with(nolock)
	End
	
	
if @Tipo = 'C' OR @Tipo = 'D'
	Begin
		select 
			Cd_Tp_Grupo [Code], Nome_Tp_Grupo [Group Type Name]
		from 
			Tipo_Grupo T with(nolock)
		where
			Cd_Tp_Grupo = @Cd_Tp_Grupo
			
	End
	
if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Grupo [Code], Nome_Tp_Grupo [Group Type Name]
		from 
			Tipo_Grupo T with(nolock)
		where
			Nome_Tp_Grupo = @Nome_Tp_Grupo
	End	
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Grupo [Code], Nome_Tp_Grupo [Group Type Name]
		from 
			Tipo_Grupo T with(nolock)
		where
			Nome_Tp_Grupo = @Nome_Tp_Grupo
			AND Cd_Tp_Grupo <> @Cd_Tp_Grupo
	End

GO
