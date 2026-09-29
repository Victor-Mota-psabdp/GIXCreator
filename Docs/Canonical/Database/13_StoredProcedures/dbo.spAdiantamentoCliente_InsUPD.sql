SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	Procedure [dbo].[spAdiantamentoCliente_InsUPD] --927,'EAPOW20090100101',null,'2009-02-10'

	@ID					int output,
	@Num_Proc			varchar(16),
	@POC				Varchar(15),
	@Dt_Solic			datetime

AS


BEGIN TRANSACTION

	set @ID=(select ID from adiantamento_cliente where Num_Proc=@Num_Proc and POC is null)

	if @ID IS NULL
		BEGIN
			Set @ID =((select Isnull(max(ID),0) from Adiantamento_Cliente)+1)
			INSERT INTO
				Adiantamento_Cliente
				(
					ID, Num_Proc, POC, Dt_Solicitacao
				)
				VALUES
				(
					@ID, @Num_Proc, @POC, @Dt_Solic
				)
		END
	else
		BEGIN
			UPDATE
				Adiantamento_Cliente
			SET
				Dt_Solicitacao=@Dt_Solic, POC=@POC
			WHERE
				ID=@ID and Num_Proc=@Num_Proc
		END

	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION


GO
