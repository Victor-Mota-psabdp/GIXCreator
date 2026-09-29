SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Compra_Venda_CP
--SELECT * FROM Tipo_Compra_Venda_CP
--spATL_Tipo_Compra_Venda_CP_Sel 'C','','T'
--spATL_Tipo_Compra_Venda_CP_Sel 'K','','F'
--spATL_Tipo_Compra_Venda_CP_Sel 'C','','L'
CREATE procedure [dbo].[spATL_Tipo_Compra_Venda_CP_Sel]
(
	@Cd_CV		char(1),
	@Descricao_CV		varchar(30),
	@Tipo				char(1)
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
			Cd_CV [Code], Descricao_CV [Type Buy Sell Name]
		from Tipo_Compra_Venda_CP T with(nolock)

	End
	
if @Tipo = 'C' OR  @Tipo = 'D'
	Begin
		select 
				Cd_CV [Code], Descricao_CV [Type Buy Sell Name]
		from Tipo_Compra_Venda_CP T with(nolock)
		where
			Cd_CV = @Cd_CV
	End

if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
				Cd_CV [Code], Descricao_CV [Type Buy Sell Name]
		from Tipo_Compra_Venda_CP T with(nolock)
		where
			Descricao_CV = @Descricao_CV
	End
	
if @Tipo = 'T' -- AEREO
	Begin
		select 
				Cd_CV [Code], Descricao_CV [Type Buy Sell Name]
		from 
			Tipo_Compra_Venda_CP T with(nolock)
		where 
			Cd_CV = @Cd_CV	AND 
			Descricao_CV NOT LIKE '%CONTAINER%'
			AND  Descricao_CV NOT LIKE '%TON%'
	End
	
if @Tipo = 'F' -- SEA FCL
	Begin
		select 
				Cd_CV [Code], Descricao_CV [Type Buy Sell Name]
		from Tipo_Compra_Venda_CP T with(nolock)
		where 
			Cd_CV = @Cd_CV AND 
			Descricao_CV NOT LIKE '%KGS%'

	End
	
if @Tipo = 'L' -- SEA FCL
	Begin
		select 
				Cd_CV [Code], Descricao_CV [Type Buy Sell Name]
		from Tipo_Compra_Venda_CP T with(nolock)
		where 
			Cd_CV = @Cd_CV AND 
			Descricao_CV NOT LIKE '%CONTAINER%'
			AND Descricao_CV NOT LIKE '%KGS%'

	End
	
	
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
				Cd_CV [Code], Descricao_CV [Type Buy Sell Name]
		from Tipo_Compra_Venda_CP T with(nolock)
		where
			Descricao_CV = @Descricao_CV
			AND Cd_CV <> @Cd_CV
	End

GO
