SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE	procedure spCustoSIA_InsUpd

	@Num_Proc_SIA	VarChar(16),
	@Item 		Varchar(5),
	@Taxa 		Varchar(30),
	@MoedaCompra 	Varchar(30),
	@VlrCompra 	Decimal(10,2),
	@MoedaVenda	Varchar(30),
	@VlrVenda 	Decimal(10,2)

AS
BEGIN TRANSACTION

Declare @Cd_Tp_Tx 	Varchar(3)
Declare @Cd_Tp_Moeda_C	Varchar(3)
Declare @Cd_Tp_Moeda_V	Varchar(3)

	Set @Cd_Tp_Tx=(select Cd_Tp_Tx from Tipo_Taxa where nome_tp_tx=@Taxa)
	Set @Cd_Tp_Moeda_C=(select Cd_Tp_Moeda from Tipo_Moeda where nome_tp_moeda=@MoedaCompra)
	Set @Cd_Tp_Moeda_V=(select Cd_Tp_Moeda from Tipo_Moeda where nome_tp_moeda=@MoedaVenda)

	
	if exists (select num_proc_sia, item, cd_tp_tx from Custo_SIA where num_proc_sia = @Num_Proc_SIA and item=@Item and cd_tp_tx=@Cd_Tp_Tx)
		BEGIN
			UPDATE
				Custo_SIA
			SET
				Cd_Tp_Moeda_C	= @Cd_Tp_Moeda_C,
				Vlr_C_SIA	= @VlrCompra,
				Cd_Tp_Moeda_V	= @Cd_Tp_Moeda_V,
				Vlr_V_SIA	= @VlrVenda
			WHERE
				Num_Proc_SIA = @Num_Proc_SIA and Item = @Item and Cd_Tp_Tx = @Cd_Tp_Tx
		END
	ELSE
		BEGIN
			INSERT INTO
				Custo_SIA
				(
					Num_Proc_SIA,
					Item,
					Cd_Tp_Tx,
					Cd_Tp_Moeda_C,
					Vlr_C_SIA,
					Cd_Tp_Moeda_V,
					Vlr_V_SIA
				)
			VALUES
				(
					@Num_Proc_SIA,
					@Item,
					@Cd_Tp_Tx,
					@Cd_Tp_Moeda_C,
					@VlrCompra,
					@Cd_Tp_Moeda_V,
					@VlrVenda
				)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION




GO
