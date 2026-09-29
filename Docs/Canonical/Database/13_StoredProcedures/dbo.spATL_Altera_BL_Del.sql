SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[spATL_Altera_BL_Del]
	@num_proc	varchar(16),
	@cd_usuario	varchar(6)
AS
Begin Transaction
		Begin
			Update
				Altera_Bl
				SET
					    cd_usuario = @cd_usuario,
						status = 0,
						dt_ins = getdate()
			Where
				Num_Proc = @num_proc
		End

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END
Commit Transaction 

GO
