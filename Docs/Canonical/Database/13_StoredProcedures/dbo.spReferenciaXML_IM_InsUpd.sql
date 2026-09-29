SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE	procedure spReferenciaXML_IM_InsUpd
			
	@Numero_PO_him Varchar(30),
	@Data_PO_him Datetime,
	@Num_Proc_him VarChar(16),
	@Id_DC	int
AS
BEGIN TRANSACTION

	Declare @ID_PO_him int

	Set @ID_PO_him = (select Id_PO_HIM from PO_HIM where Num_Proc_HIM=@Num_Proc_HIM and Id_DC = @Id_DC)
	
	IF @ID_PO_HIM is not null

		BEGIN
			UPDATE
				PO_him
			SET
				Data_PO_him = @Data_PO_him,
				Numero_PO_him = @Numero_PO_him
			WHERE
				id_po_him = @ID_PO_him and Num_Proc_him = @Num_Proc_him and Id_DC = @Id_DC
		END
	ELSE
		BEGIN
			SET @ID_PO_HIM=(select Isnull(max(id_po_him),0)+1 from po_him where Num_Proc_him=@Num_Proc_him )
			INSERT INTO
				PO_him
				(
					Num_Proc_him,
					ID_PO_him,	
					Numero_PO_him,
					Data_PO_him,
					Id_DC
				)
			VALUES
				(
					@Num_Proc_him,
					@ID_PO_HIM,
					@Numero_PO_him,
					@Data_PO_him,
					@Id_DC
				)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION
	











GO
