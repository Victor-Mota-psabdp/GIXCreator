SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE	procedure spReferenciaXML_IO_InsUpd
			
	@Numero_PO_HIO Varchar(30),
	@Data_PO_HIO Datetime,
	@Num_Proc_HIO VarChar(16),
	@Id_DC	int
AS
BEGIN TRANSACTION

	Declare @ID_PO_HIO int

	Set @ID_PO_HIO = (select Id_PO_HIO from PO_HIO where Num_Proc_HIO=@Num_Proc_HIO and Id_DC = @Id_DC)
	
	IF @ID_PO_HIO is not null

		BEGIN
			UPDATE
				PO_HIO
			SET
				Data_PO_HIO = @Data_PO_HIO,
				Numero_PO_HIO = @Numero_PO_HIO
			WHERE
				id_po_HIO = @ID_PO_HIO and Num_Proc_HIO = @Num_Proc_HIO and Id_DC = @Id_DC
		END
	ELSE
		BEGIN
			SET @ID_PO_HIO=(select Isnull(max(id_po_HIO),0)+1 from po_HIO where Num_Proc_HIO=@Num_Proc_HIO )
			INSERT INTO
				PO_HIO
				(
					Num_Proc_HIO,
					ID_PO_HIO,	
					Numero_PO_HIO,
					Data_PO_HIO,
					Id_DC
				)
			VALUES
				(
					@Num_Proc_HIO,
					@ID_PO_HIO,
					@Numero_PO_HIO,
					@Data_PO_HIO,
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
