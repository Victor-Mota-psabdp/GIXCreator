SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE	procedure spReferenciaXML_IA_InsUpd
			
	@Numero_PO_HIA Varchar(30),
	@Data_PO_HIA Datetime,
	@Num_Proc_HIA VarChar(16),
	@Id_DC	int
AS
BEGIN TRANSACTION

	Declare @ID_PO_HIA int

	Set @ID_PO_HIA = (select Id_PO_HIA from PO_HIA where Num_Proc_HIA=@Num_Proc_HIA and Id_DC = @Id_DC)
	
	IF @ID_PO_HIA is not null

		BEGIN
			UPDATE
				PO_HIA
			SET
				Data_PO_HIA = @Data_PO_HIA,
				Numero_PO_HIA = @Numero_PO_HIA
			WHERE
				id_po_HIA = @ID_PO_HIA and Num_Proc_HIA = @Num_Proc_HIA and Id_DC = @Id_DC
		END
	ELSE
		BEGIN
			SET @ID_PO_HIA=(select Isnull(max(id_po_HIA),0)+1 from po_HIA where Num_Proc_HIA=@Num_Proc_HIA )
			INSERT INTO
				PO_HIA
				(
					Num_Proc_HIA,
					ID_PO_HIA,	
					Numero_PO_HIA,
					Data_PO_HIA,
					Id_DC
				)
			VALUES
				(
					@Num_Proc_HIA,
					@ID_PO_HIA,
					@Numero_PO_HIA,
					@Data_PO_HIA,
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
