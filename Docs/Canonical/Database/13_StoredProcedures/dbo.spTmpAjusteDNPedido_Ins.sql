SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spTmpAjusteDNPedido_Ins]

	@Num_Pedido_INV	Varchar(20),
	@Item		Varchar(4),
	@Lote		Varchar(15),
	@Valor		float,
	@Qty		float,
	@Uom_Qty	varchar(3),
	@Peso_Bruto	float,
	@Peso_Liquido float,
	@Uom_Peso	Varchar(3),
	@Cd_Prod_Cliente	Varchar(50)
as

BEGIN
Begin Transaction
	INSERT
			TMP_AjusteDN_Pedido
			(
				Num_Pedido_INV,
				Item,
				Lote,
				Valor,
				Qty,
				Uom_Qty,
				Peso_Bruto,
				Peso_Liquido,
				Uom_Peso,
				Cd_Prod_Cliente
				)
		VALUES
			(
				@Num_Pedido_INV,
				@Item,
				@Lote,
				@Valor,
				@Qty,
				@Uom_Qty,
				@Peso_Bruto,
				@Peso_Liquido,
				@Uom_Peso,
				@Cd_Prod_Cliente
				)
	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION
end

GO
