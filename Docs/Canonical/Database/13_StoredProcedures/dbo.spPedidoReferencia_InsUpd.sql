SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure spPedidoReferencia_InsUpd
	
		@ID_Ref int,
		@ID_Descr varchar(20),
		@Codigo	Varchar(20),
		@Descr_Cliente Varchar(50)
as

Begin
	if @ID_Ref is null
		BEGIN
			Set @ID_REF=Isnull((select max(id_ref) from pedido_referencia),1)
			Insert into
				Pedido_Referencia
					(
					ID_Ref,ID_Descr,Codigo,Descr_Cliente
					)
			Values
					(
					@ID_Ref,@ID_Descr,@Codigo,@Descr_Cliente
					)

		End
	ELSE
		UPDATE
			PEDIDO_REFERENCIA
		SET
			ID_Descr=@ID_Descr,
			Codigo=@Codigo,
			Descr_Cliente=@Descr_Cliente
		WHERE
			 ID_REF=@ID_REF
END


GO
