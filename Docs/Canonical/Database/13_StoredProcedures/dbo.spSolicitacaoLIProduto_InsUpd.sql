SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSolicitacaoLIProduto_InsUpd]
		@Num_Proc				Varchar(16),
		@cd_prod_cliente		varchar(50),
		@NCM					VArchar(8),
		@Qty					float,
		@Peso_Bruto				Decimal(10,2),
		@Peso_Liquido			Decimal(10,2),
		@Nome_Tp_moeda			Varchar(30),
		@Preco_Unit				float,
		@Num_Solicitacao		Varchar(13)

AS
Begin Transaction
	Declare @Cd_Produto int
	Declare @ID_NCM	Int
	Declare @Cd_Tp_Moeda varchar(3)

	set @Cd_Produto=(select top 1 cd_produto from pedido_Ship Join Produto_cliente PC on PC.cd_prod=cd_produto where num_proc=@num_proc and cd_proc_cliente=@cd_prod_cliente)
	Set @Id_NCM=(select id_ncm from ncm where ncm=@NCM)
	Set @Cd_Tp_Moeda = (Select Cd_Tp_Moeda from Tipo_Moeda where Nome_Tp_Moeda = @Nome_Tp_moeda)


	if not exists(select * from Solicitacao_LI_Produto where num_solicitacao=@num_solicitacao and cd_produto=@cd_produto)
		Begin
			Insert Solicitacao_LI_Produto
					(
						Num_Solicitacao,Cd_Produto,ID_NCM,Qty,Peso_Bruto,Peso_Liquido,Cd_Tp_Moeda,Preco_Unit
					)
			Values
					(
						@Num_Solicitacao,@Cd_Produto,@ID_NCM,@Qty,@Peso_Bruto,@Peso_Liquido,@Cd_Tp_Moeda,@Preco_Unit
					)
		End
	ELSE
		Begin
			Update Solicitacao_LI_Produto
					Set
						ID_NCM=@ID_NCM,
						Qty=@Qty,
						Peso_Bruto=@Peso_Bruto,
						Peso_Liquido=@Peso_Liquido,
						Cd_Tp_Moeda=@Cd_Tp_Moeda,
						Preco_Unit=@Preco_Unit
			Where
					Num_Solicitacao=@Num_Solicitacao and cd_produto=@cd_produto
		End

	if @@error <> 0
			Begin
				Rollback transaction
				return -1
			End

Commit Transaction

GO
