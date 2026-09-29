SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_PO_HEM_InsUpd] 
(			
	@ID_PO_HEM int,
	@Numero_PO_HEM Varchar(80),
	@Data_PO_HEM Datetime,
	@Num_Proc_HEM VarChar(16),
	@Id_DC	int,
	@Cd_Usuario	varchar(10)
)

AS

BEGIN TRANSACTION	

	Declare @ID Int
	set @ID_PO_HEM = (select ID_PO_HEM from PO_HEM With(nolock) where ID_DC=@ID_DC 
						and Num_Proc_HEM=@Num_Proc_HEM and Numero_PO_HEM=@Numero_PO_HEM)

	if @ID_PO_HEM is not null
		BEGIN
			UPDATE
				PO_HEM
			SET
				Data_PO_HEM = @Data_PO_HEM,
				Numero_PO_HEM = @Numero_PO_HEM,
				ID_DC = @Id_DC,
				cd_usuario = @Cd_Usuario,
				dt_ins = getdate()
			WHERE
				id_po_HEM = @ID_PO_HEM and Num_Proc_HEM = @Num_Proc_HEM
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(id_po_HEM),0)+1 from po_HEM where Num_Proc_HEM=@Num_Proc_HEM )
			INSERT INTO
				PO_HEM
				(
					Num_Proc_HEM,ID_PO_HEM,Numero_PO_HEM,Data_PO_HEM,Id_DC,cd_usuario,dt_ins
				)
			VALUES
				(
					@Num_Proc_HEM,@ID,@Numero_PO_HEM,@Data_PO_HEM,@Id_DC,@Cd_Usuario, getdate()
				)

		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION

GO
