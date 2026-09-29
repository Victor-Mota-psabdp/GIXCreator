SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help BDP_Produto
CREATE procedure [dbo].[spATL_BDP_Produto_Sel]--'1','','B'
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

if @Tipo = 'A'  --OR @Tipo = 'B'
	Begin
		if @ID_PD = '' or @ID_PD is null
			select 
				ID_PD [Code], Nome_BDP_Produto [BDP Product Name],
				ID_PD,Nome_BDP_Produto,t.Nome_BDP_Produto AS Description
			from BDP_Produto T with(nolock)
		else
			select 
				ID_PD [Code], Nome_BDP_Produto [BDP Product Name],
				ID_PD,Nome_BDP_Produto,t.Nome_BDP_Produto AS Description
			from BDP_Produto T with(nolock)
			where
				ID_PD = @ID_PD

	End
	
if @Tipo = 'C' OR  @Tipo = 'D' OR @Tipo = 'B'
	Begin
		select 
			ID_PD [Code], Nome_BDP_Produto [BDP Product Name],
			ID_PD,Nome_BDP_Produto,t.Nome_BDP_Produto AS Description
		from BDP_Produto T with(nolock)
		where
			ID_PD = @ID_PD
	End

if @Tipo = 'N' OR @Tipo = 'O'
	Begin
		select 
		ID_PD [Code], Nome_BDP_Produto [BDP Product Name],
			ID_PD,Nome_BDP_Produto,t.Nome_BDP_Produto AS Description
		from BDP_Produto T with(nolock)
		where
			Nome_BDP_Produto = @Nome_BDP_Produto
	End
	

if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			ID_PD [Code], Nome_BDP_Produto [BDP Product Name],
			ID_PD,Nome_BDP_Produto,t.Nome_BDP_Produto AS Description
		from BDP_Produto T with(nolock)
		where
			Nome_BDP_Produto = @Nome_BDP_Produto
			AND ID_PD <> @ID_PD
	End

/*
ALTER procedure [dbo].[spATL_BDP_Produto_Sel]--'4','','C'
(
	@ID_PD as int,
	@Nome_BDP_Produto as Varchar(30),
	@Tipo as char
)
as
if @Tipo = 'A'
Begin
	if @ID_PD = '' or @ID_PD is null
		Begin
			select ID_PD,Nome_BDP_Produto from BDP_Produto
			where Nome_BDP_Produto = @Nome_BDP_Produto 
		End
	else
		Begin
			select ID_PD,Nome_BDP_Produto from BDP_Produto
			where  ID_PD = @ID_PD 
		End
End
If @Tipo = 'B'
	Begin
		if @ID_PD = '' or @ID_PD is null
			Begin
				select ID_PD,Nome_BDP_Produto from BDP_Produto
				where Nome_BDP_Produto = @Nome_BDP_Produto 
			End
		else
			Begin
				select ID_PD,Nome_BDP_Produto from BDP_Produto
				where  ID_PD = @ID_PD 
			End
	End
If @Tipo = 'C'
	Begin	
		select 
			ID_PD,Nome_BDP_Produto 
		from 
			BDP_Produto
		where 
			ID_PD = @ID_PD
	End
*/
GO
