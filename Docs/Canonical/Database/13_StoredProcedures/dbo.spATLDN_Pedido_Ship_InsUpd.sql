SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help PEDIDO_SHIP
CREATE procedure [dbo].[spATLDN_Pedido_Ship_InsUpd]
(
	@Cd_Pedido	int,
	@Cd_Produto	int,
	@Qty	 	float,
	@Item		Varchar(6),
	@Lote		varchar(30),
	@Num_Proc	varchar(16),	
	@Cd_Usuario varchar(10)
)

AS

BEGIN TRANSACTION

	IF EXISTS(SELECT PS.CD_PEDIDO FROM PEDIDO_SHIP PS with(nolock) Where PS.cd_pedido=@cd_pedido and PS.cd_produto=@cd_produto 
							and Num_Proc=@Num_Proc and Lote = @Lote and Item = @Item)
		BEGIN
			UPDATE
				Pedido_Ship
			SET
				Qty = @Qty, 
				Dt_Ins = Getdate(), 
				Cd_Usuario = @Cd_Usuario
			WHERE
				cd_pedido=@cd_pedido and cd_produto=@cd_produto 
				and Num_Proc=@Num_Proc and Lote = @Lote and Item = @Item
		END
	ELSE
		BEGIN		
			INSERT INTO				
				Pedido_Ship
				(Cd_pedido,Cd_Produto,Qty,Num_Proc,Item,Lote,Dt_Ins,Cd_Usuario)
			VALUES
				(@Cd_Pedido,@Cd_Produto,@Qty,@Num_Proc,@Item,@Lote,Getdate(),@Cd_Usuario)
		END
		
		
	IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

COMMIT TRANSACTION

GO
