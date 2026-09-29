SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_PO_HEA_InsUpd] 
(			
	@ID_PO_HEA int,
	@Numero_PO_HEA Varchar(80),
	@Data_PO_HEA Datetime,
	@Num_Proc_HEA VarChar(16),
	@Id_DC	int,
	@Cd_Usuario	varchar(10)
)

AS

BEGIN TRANSACTION	

	Declare @ID Int
	set @ID_PO_HEA = (select ID_PO_HEA from PO_HEA With(nolock) where ID_DC=@ID_DC 
						and Num_Proc_HEA=@Num_Proc_HEA and Numero_PO_HEA=@Numero_PO_HEA)

	if @ID_PO_HEA is not null
		BEGIN
			UPDATE
				PO_HEA
			SET
				Data_PO_HEA = @Data_PO_HEA,
				Numero_PO_HEA = @Numero_PO_HEA,
				ID_DC = @Id_DC,
				cd_usuario = @Cd_Usuario,
				dt_ins = getdate()
			WHERE
				id_po_HEA = @ID_PO_HEA and Num_Proc_HEA = @Num_Proc_HEA
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(id_po_HEA),0)+1 from po_HEA where Num_Proc_HEA=@Num_Proc_HEA )
			INSERT INTO
				PO_HEA
				(
					Num_Proc_HEA,ID_PO_HEA,Numero_PO_HEA,Data_PO_HEA,Id_DC,cd_usuario,dt_ins
				)
			VALUES
				(
					@Num_Proc_HEA,@ID,@Numero_PO_HEA,@Data_PO_HEA,@Id_DC,@Cd_Usuario, getdate()
				)

		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION

GO
