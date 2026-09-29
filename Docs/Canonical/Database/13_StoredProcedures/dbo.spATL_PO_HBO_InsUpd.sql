SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_PO_HBO_InsUpd] 
(			
	@ID_PO_HBO int,
	@Numero_PO_HBO Varchar(80),
	@Data_PO_HBO Datetime,
	@Num_Proc_HBO VarChar(16),
	@Id_DC	int,
	@Cd_Usuario	varchar(10)
)

AS

BEGIN TRANSACTION	

	Declare @ID Int
	set @ID_PO_HBO = (select ID_PO_HBO from PO_HBO With(nolock) where ID_DC=@ID_DC 
						and Num_Proc_HBO=@Num_Proc_HBO and Numero_PO_HBO=@Numero_PO_HBO)

	if @ID_PO_HBO is not null
		BEGIN
			UPDATE
				PO_HBO
			SET
				Data_PO_HBO = @Data_PO_HBO,
				Numero_PO_HBO = @Numero_PO_HBO,
				ID_DC = @Id_DC,
				cd_usuario = @Cd_Usuario,
				dt_ins = getdate()
			WHERE
				id_PO_HBO = @ID_PO_HBO and Num_Proc_HBO = @Num_Proc_HBO
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(id_PO_HBO),0)+1 from PO_HBO where Num_Proc_HBO=@Num_Proc_HBO )
			INSERT INTO
				PO_HBO
				(
					Num_Proc_HBO,ID_PO_HBO,Numero_PO_HBO,Data_PO_HBO,Id_DC,cd_usuario,dt_ins
				)
			VALUES
				(
					@Num_Proc_HBO,@ID,@Numero_PO_HBO,@Data_PO_HBO,@Id_DC,@Cd_Usuario, getdate()
				)

		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION
	













GO
