SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATLDN_Pedido_Ship_Del]

	@Cd_Pedido	int,
	@Cd_Produto	int,
	@Item		Varchar(6),
	@Lote		varchar(30),
	@Num_Proc	varchar(16),	
	@Cd_Usuario varchar(10)
AS

BEGIN TRANSACTION
	
	IF EXISTS(SELECT PS.CD_PEDIDO FROM PEDIDO_SHIP PS with(nolock) Where PS.cd_pedido=@cd_pedido and PS.cd_produto=@cd_produto 
							and Num_Proc=@Num_Proc and Lote = @Lote and Item = @Item)
		BEGIN
			DELETE Pedido_Ship where Lote = @Lote and Item = @Item and Num_proc = @Num_Proc and Cd_Pedido= @Cd_Pedido and cd_produto = @Cd_Produto
		END
			   
	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION
GO
