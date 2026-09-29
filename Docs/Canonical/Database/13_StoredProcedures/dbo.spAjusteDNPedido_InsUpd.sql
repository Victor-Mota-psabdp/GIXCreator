SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure spAjusteDNPedido_InsUpd

	@Num_Pedido_INV Varchar(20),
	@Item			Varchar(4),
	@Lote			Varchar(15),
	@Valor			Decimal(18,2),
	@Qty			float,
	@Uom_Qty		Varchar(3),
	@Peso_Bruto		Decimal(18,2),
	@Peso_Liquido	Decimal(18,2),
	@Uom_Peso		Varchar(3)

AS


if not exists(select * from tmp_ajustedn_pedido where num_pedido_inv=@num_pedido_inv and lote=@lote and item=@item)
	BEGIN
		Insert 
			Tmp_AjusteDN_Pedido
				(
				Num_Pedido_INV,
				Item,
				Lote,
				Valor,
				Qty,
				Uom_Qty,
				Peso_Bruto,
				Peso_Liquido,
				Uom_Peso
				)
		Values
			(
				@Num_Pedido_INV,
				@Item,
				@Lote,
				@Valor,
				@Qty,
				@Uom_Qty,
				@Peso_Bruto,
				@Peso_Liquido,
				@Uom_Peso
			)
	END
ELSE
	BEGIN
		UPDATE 
			TMP_AJUSTEDN_PEDIDO
				SET
					VALOR=@VALOR,
					QTY=@QTY,
					UOM_QTY=@UOM_QTY,
					PESO_BRUTO=@PESO_BRUTO,
					PESO_LIQUIDO=@PESO_LIQUIDO,
					UOM_PESO=@UOM_PESO
		WHERE
				NUM_PEDIDO_INV=@NUM_PEDIDO_INV AND
				LOTE=@LOTE AND
				ITEM=@ITEM
	END

GO
