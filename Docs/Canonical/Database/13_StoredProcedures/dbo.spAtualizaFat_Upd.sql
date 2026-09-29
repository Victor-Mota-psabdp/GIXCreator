SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAtualizaFat_Upd]
	@Fatura_CC	Varchar(17),
	@item		Varchar(15),
	@nome_taxa	varchar(50),
	@Imprime	Char(1)

as

BEGIN TRANSACTION
	Declare @cd_tp_tx varchar(3)
	SEt @cd_tp_Tx=(select cd_tp_tx from tipo_taxa where nome_tp_tx=@nome_Taxa)
			UPDATE 
				FATURA_CHB_ITEM
			SET
				Imprime=@Imprime
			WHERE
				fatura_cc=@fatura_cc and Item=@item and cd_tp_tx=@cd_Tp_tx
	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -2
		END
COMMIT TRANSACTION


GO
