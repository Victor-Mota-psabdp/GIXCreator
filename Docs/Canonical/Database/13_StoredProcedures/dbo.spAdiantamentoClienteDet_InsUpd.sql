SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE	procedure [dbo].[spAdiantamentoClienteDet_InsUpd]

	@ID 		int,
	@Taxa 		Varchar(50),
	@Moeda		Varchar(30),
	@Valor		float,
	@Paridade	float,
	@Conta		char(1)
AS
BEGIN TRANSACTION

Declare @Cd_Tp_Tx 	Varchar(3)
Declare @Cd_Tp_Moeda	Varchar(3)

	Set @Cd_Tp_Tx=(select Cd_Tp_Tx from Tipo_Taxa where nome_tp_tx=@Taxa)
	Set @Cd_Tp_Moeda=(select Cd_Tp_Moeda from Tipo_Moeda where nome_tp_moeda=@Moeda)
	
 	if exists (select ID from Adiantamento_Cliente_Det where ID=@ID and Cd_Tp_TX=@Cd_Tp_Tx)
		BEGIN
			UPDATE
				Adiantamento_Cliente_Det
			SET
				Cd_Tp_Moeda	= @Cd_Tp_Moeda,
				Valor = @Valor, Paridade=@Paridade, Conta=@Conta
			WHERE
				ID = @ID and Cd_Tp_Tx = @Cd_Tp_Tx
		END
	ELSE
		BEGIN
			INSERT INTO
				Adiantamento_Cliente_Det
				(
					ID,
					Cd_Tp_Tx,
					Cd_Tp_Moeda,
					Valor,
					Paridade,
					Conta
				)
			VALUES
				(
					@ID,
					@Cd_Tp_Tx,
					@Cd_Tp_Moeda,
					@Valor,
					@Paridade,
					@Conta
				)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION








GO
