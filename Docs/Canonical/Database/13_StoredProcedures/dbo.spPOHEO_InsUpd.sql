SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE          procedure [dbo].[spPOHEO_InsUpd]
			
	@ID_PO_HEO int,
	@Numero_PO_HEO Varchar(80),
	@Data_PO_HEO Datetime,
	@Num_Proc_HEO VarChar(16),
	@Id_DC	int

AS

BEGIN TRANSACTION

	--Pegar o usuario q inseriu a inf.
	declare @Host varchar(20) --SYSNAME --
	declare @session_id int


	declare @cd_usuario varchar(20)
	set @cd_usuario = (select top 1 cd_usuario from tmpLOG with(nolock) where job=@num_proc_heo and host = @Host and session_id = @session_id)

	Declare @ID Int
	set @ID_PO_HEO = (select ID_PO_HEO from PO_HEO where ID_DC=@ID_DC and Num_Proc_HEO=@Num_Proc_HEO and Numero_PO_HEO=@Numero_PO_HEO)

	if @ID_PO_HEO is not null
		BEGIN
			UPDATE
				PO_HEO
			SET
				Data_PO_HEO = @Data_PO_HEO,
				Numero_PO_HEO = @Numero_PO_HEO,
				Id_DC = @Id_DC,
				cd_usuario = @cd_usuario,
				dt_ins = getdate()
			WHERE
				id_po_HEO = @ID_PO_HEO and Num_Proc_HEO = @Num_Proc_HEO
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(id_po_HEO),0)+1 from po_HEO where Num_Proc_HEO=@Num_Proc_HEO )
			INSERT INTO
				PO_HEO
				(
					Num_Proc_HEO,
					ID_PO_HEO,	
					Numero_PO_HEO,
					Data_PO_HEO,
					Id_DC,
					cd_usuario,
					dt_ins
				)
			VALUES
				(
					@Num_Proc_HEO,
					@ID,
					@Numero_PO_HEO,
					@Data_PO_HEO,
					@Id_DC,
					@cd_usuario,
					getdate()
				)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION
	

















GO
