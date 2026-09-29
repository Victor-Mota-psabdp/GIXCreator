SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_Solicitacao_LI_Produto_InsUpd] 'SLI2020090123','GMN P0635500','29152400','USD',
--'23078.761','23078.761','23078.761','0.7616'

--select * from Solicitacao_LI where num_solicitacao = 'SLI2020090123'
--select * from Pedido_Ship where num_proc = 'IMSLA202008003BR'
--select * from Produto_cliente where cd_prod = '137374'
--SELECT top 1 PS.cd_produto FROM Solicitacao_LI LI
--		join Pedido_Ship PS	with(nolock) on LI.Num_Proc = PS.num_proc
--		Join Produto_cliente PC on PC.cd_prod=PS.cd_produto					
--		where
--			LI.Num_Solicitacao = 'SLI2020090123' and PC.cd_Proc_Cliente='GMN P0635500'
--			and pc.cd_cliente = LI.cd_grupo
						
--P000000450
CREATE Procedure [dbo].[spATL_Solicitacao_LI_Produto_InsUpd]
(
	@Num_Solicitacao		Varchar(13),
	@cd_prod_cliente		varchar(50),
	@NCM					VArchar(8),	
	@Cd_Tp_Moeda			varchar(3),
	@Qty					float,
	@Peso_Bruto				Decimal(10,2),
	@Peso_Liquido			Decimal(10,2),	
	@Preco_Unit				float
)
		

AS
Begin Transaction
	Declare @Cd_Produto int
	Declare @ID_NCM	Int

	--set @Cd_Produto=(select top 1 cd_produto from pedido_Ship 
	--	Join Produto_cliente PC on PC.cd_prod=cd_produto 
	--	where num_proc=@num_proc and cd_proc_cliente=@cd_prod_cliente)
	Set @Id_NCM=(select id_ncm from ncm where ncm=@NCM)
		
	set @Cd_Produto=(SELECT top 1 PS.cd_produto FROM Solicitacao_LI LI
					join Pedido_Ship PS	with(nolock) on LI.Num_Proc = PS.num_proc
					Join Produto_cliente PC on PC.cd_prod=PS.cd_produto					
					where
						LI.Num_Solicitacao = @Num_Solicitacao and PC.cd_Proc_Cliente=@cd_prod_cliente)


	if not exists(select Num_Solicitacao from Solicitacao_LI_Produto where Num_Solicitacao=@num_solicitacao and cd_produto=@cd_produto)
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
			Update 
				Solicitacao_LI_Produto
			Set
				ID_NCM=@ID_NCM,
				Qty=@Qty,
				Peso_Bruto=@Peso_Bruto,
				Peso_Liquido=@Peso_Liquido,
				Cd_Tp_Moeda=@Cd_Tp_Moeda,
				Preco_Unit=@Preco_Unit
			Where
				Num_Solicitacao=@Num_Solicitacao 
				and cd_produto=@cd_produto
		End

	if @@error <> 0
			Begin
				Rollback transaction
				return -1
			End

Commit Transaction

GO
