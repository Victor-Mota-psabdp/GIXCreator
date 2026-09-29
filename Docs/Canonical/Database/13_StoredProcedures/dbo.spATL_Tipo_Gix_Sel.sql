SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Gix
CREATE procedure [dbo].[spATL_Tipo_Gix_Sel]
(
	@Cd_Tp_Gix		VARCHAR(2),
	@Nome_Tp_Gix	varchar(50),
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
			Cd_Tp_Gix [Code], Nome_Tp_Gix [GIX Type Name], Regra [Stored Rules]
		from 
			Tipo_Gix T with(nolock)
	End
	
	
if @Tipo = 'C' OR @Tipo = 'D'
	Begin
		select 
			Cd_Tp_Gix [Code], Nome_Tp_Gix [GIX Type Name], Regra [Stored Rules]
		from 
			Tipo_Gix T with(nolock)
		where
			Cd_Tp_Gix = @Cd_Tp_Gix
			
	End
	
if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Gix [Code], Nome_Tp_Gix [GIX Type Name], Regra [Stored Rules]
		from 
			Tipo_Gix T with(nolock)
		where
			Nome_Tp_Gix = @Nome_Tp_Gix
	End	
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Gix [Code], Nome_Tp_Gix [GIX Type Name], Regra [Stored Rules]
		from 
			Tipo_Gix T with(nolock)
		where
			Nome_Tp_Gix = @Nome_Tp_Gix
			AND Cd_Tp_Gix <> @Cd_Tp_Gix
	End

GO
