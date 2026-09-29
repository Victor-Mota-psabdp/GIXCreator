SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Frete
CREATE procedure [dbo].[spATL_Tipo_Frete_Sel]
(
	@Cd_Tp_Frete		varchar(1),
	@Nome_Tp_Frete		varchar(60),
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
			Cd_Tp_Frete [Code], Nome_Tp_Frete [Freight Type Name]
		from Tipo_Frete T with(nolock)

	End
	
if @Tipo = 'C' OR  @Tipo = 'D'
	Begin
		select 
			Cd_Tp_Frete [Code], Nome_Tp_Frete [Freight Type Name]
		from Tipo_Frete T with(nolock)
		where
			Cd_Tp_Frete = @Cd_Tp_Frete
	End

if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Frete [Code], Nome_Tp_Frete [Freight Type Name]
		from Tipo_Frete T with(nolock)
		where
			Nome_Tp_Frete = @Nome_Tp_Frete
	End
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Tp_Frete [Code], Nome_Tp_Frete [Freight Type Name]
		from Tipo_Frete T with(nolock)
		where
			Nome_Tp_Frete = @Nome_Tp_Frete
			AND Cd_Tp_Frete <> @Cd_Tp_Frete
	End

GO
