SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spAdiantamento_InsUPD] 

	@Num_Proc		varchar(16),
	@Dt_Solic		datetime,
	@ID				int output

AS

BEGIN TRANSACTION

		BEGIN
			Set @ID =(select Isnull(max(ID),0) from Adiantamento_Cliente)+1
			INSERT INTO
				Adiantamento_Cliente
				(
					ID, Num_Proc, Dt_Solicitacao
				)
				VALUES
				(
					@ID, @Num_Proc, @Dt_Solic
				)
		END


	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION


GO
