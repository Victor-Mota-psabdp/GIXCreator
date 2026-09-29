SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[spFaturaCHBItem_InsUpd]
	@Fatura_CC	Varchar(17),
	@Item		Varchar(15),
	@Cd_tp_tx	varchar(3),
	@DC			varchar(1),
	@Vlr_PC		float,
	@Tp_Pgto	char(1),	
	@Imprime	Char(1)

as

BEGIN TRANSACTION
	if not exists(select * from fatura_chb_item where fatura_cc=@fatura_cc and Item=@item and cd_tp_tx=@cd_Tp_tx and dc = @DC)
		BEGIN
			INSERT INTO
				Fatura_CHB_ITEM
					(Fatura_CC,Item,Cd_tp_tx,Vlr_PC,Tp_Pgto,Imprime,dc)
			VALUES
				(@Fatura_CC,@Item,@Cd_tp_tx,@Vlr_PC,@Tp_Pgto,@Imprime,@DC)
		END
	ELSE
		BEGIN
			UPDATE 
				FATURA_CHB_ITEM
			SET
				Vlr_PC=@VLR_PC,
				Tp_Pgto=@TP_PGTO
			WHERE
				fatura_cc=@fatura_cc and Item=@item and cd_tp_tx=@cd_Tp_tx and dc= @DC
		
		END
	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -2
		END
COMMIT TRANSACTION



GO
