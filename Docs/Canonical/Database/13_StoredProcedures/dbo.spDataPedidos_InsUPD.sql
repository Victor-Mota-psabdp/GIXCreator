SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


Create Procedure spDataPedidos_InsUPD
		
		@Cd_Pedido	int,
		@Referencia_Descr Varchar(50),
		@Data	Datetime

as

Begin Transaction
	Declare @ID_REF int
	SEt @ID_REF=(select ID_ref from tipo_referencia where referencia_descr=@Referencia_Descr)
	if not exists(select cd_pedido from data_pedidos where cd_pedido=@cd_pedido and id_ref=@id_ref)
		BEGIN
			INSERT INTO 
				DATA_PEDIDOS
					(CD_PEDIDO,ID_REF,DATA)
				VALUES
					(@CD_PEDIDO,@ID_REF,@DATA)
		END
	ELSE
		BEGIN
			UPDATE
				DATA_PEDIDOS
					SET
						data=@data
				where
					cd_pedido=@cd_pedido and id_ref=@id_ref
		end
	if @@error <> 0
		BEGIN
			Rollback Transaction
			return -1
		end

Commit Transaction

	




GO
