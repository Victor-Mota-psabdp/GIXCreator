SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help BDP_Produto
CREATE procedure [dbo].[spATLDN_BDP_Produto_Sel]--'1','','B'
(
	@ID_PD					INT,
	@Nome_BDP_Produto		varchar(50),
	@Tipo					CHAR(1)
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

if @Tipo = 'A' --OR @Tipo = 'B'
	Begin
		select 
			ID_PD [Code], Nome_BDP_Produto [BDP Product Name]			
		from 
			BDP_Produto T with(nolock)
	End
	
if @Tipo = 'C' OR  @Tipo = 'D' OR @Tipo = 'B'
	Begin
		select 
			ID_PD [Code], Nome_BDP_Produto [BDP Product Name]			
		from 
			BDP_Produto T with(nolock)
		where
			ID_PD = @ID_PD
	End

if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
			ID_PD [Code], Nome_BDP_Produto [BDP Product Name]			
		from 
			BDP_Produto T with(nolock)
		where
			Nome_BDP_Produto = @Nome_BDP_Produto
	End
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			ID_PD [Code], Nome_BDP_Produto [BDP Product Name]			
		from 
			BDP_Produto T with(nolock)
		where
			Nome_BDP_Produto = @Nome_BDP_Produto
			AND ID_PD <> @ID_PD
	End


GO
