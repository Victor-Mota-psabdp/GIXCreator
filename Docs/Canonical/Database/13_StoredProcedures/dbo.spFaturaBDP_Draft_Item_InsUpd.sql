SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFaturaBDP_Draft_Item_InsUpd]
	@FatCod		Varchar(19),
	@Num_Proc	Varchar(16),
	@Tipo_Taxa	varchar(50),
	@DC			char(1),
	@Tipo_Moeda	varchar(50),
	@Vlr_Org	decimal(9,2),
	@Vlr_RS		decimal(9,2),
	@Paridade	float

as

	Declare @cd_tp_tx		varchar(3)
	Declare @cd_tp_moeda	varchar(3)

	set @cd_tp_tx = (select cd_tp_tx from tipo_taxa where nome_tp_tx = @Tipo_taxa)
--	set @cd_tp_moeda = (select cd_tp_moeda from tipo_moeda where nome_tp_moeda = @Tipo_Moeda)

BEGIN TRANSACTION
	if not exists(select * from Item_Fat_Draft where FatCod=@FatCod and cd_tp_tx=@cd_Tp_tx and @DC = DC)
		BEGIN
			INSERT INTO
				Item_Fat_Draft
					(FatCod,Num_Proc, cd_tp_tx, DC, Cd_tp_moeda, Vlr_Org, Vlr_RS, Paridade)
			VALUES
				(@FatCod, @Num_Proc, @cd_tp_tx, @DC, @Tipo_Moeda, abs(@Vlr_Org), abs(@Vlr_RS), @Paridade)
		END
	ELSE
		BEGIN
			UPDATE 
				Item_Fat_Draft
			SET
				Vlr_Org=abs(@VLR_ORG),
				Vlr_RS=abs(@VLR_RS),
				Paridade = @Paridade
			WHERE
				FatCod=@FatCod and cd_tp_tx=@cd_Tp_tx and DC=@DC
		
		END
	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -2
		END
COMMIT TRANSACTION






GO
