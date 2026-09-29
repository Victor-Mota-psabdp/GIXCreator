SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[spPOMaster_InsUpd]
			
	@ID_PO_Master int,
	@Numero_PO Varchar(100),
	@Data_PO Datetime,
	@Num_Proc VarChar(14),
	@Id_DC	int,
	@Nome_Arquivo Varchar(30),
	@Usuario	Varchar(40)

AS
BEGIN TRANSACTION

Declare @cd_usuario varchar(10) 
Set @Cd_usuario=(select cd_usuario from usuario where nome_usuario=@usuario)

Declare @ID Int

	if @ID_PO_Master is not null
		BEGIN
			UPDATE
				PO_Master
			SET
				Data_PO = @Data_PO,
				Numero_PO = @Numero_PO,
				Id_DC = @Id_DC,
				Nome_Arquivo=@Nome_Arquivo,
				cd_usuario=@cd_usuario
			WHERE
				id_po_master = @ID_PO_Master and Num_Proc_Master = @Num_Proc
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(id_po_master),0)+1 from po_master where Num_Proc_master=@Num_Proc)
			INSERT INTO
				PO_Master
				(
					Num_Proc_Master,
					ID_PO_Master,
					Numero_PO,
					Data_PO,
					Id_DC,
					Nome_Arquivo,
					Cd_Usuario
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Numero_PO,
					@Data_PO,
					@Id_DC,
					@Nome_Arquivo,
					@Cd_Usuario
				)

		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION
	















GO
