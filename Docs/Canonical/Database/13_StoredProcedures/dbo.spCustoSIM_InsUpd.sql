SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE    procedure spCustoSIM_InsUpd
			
	@Num_Proc_SIM	VarChar(16),
	@Item_Cont 	int,
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

	
	if exists (select num_proc_sim, item_cont, cd_tp_tx from Custo_SIM where num_proc_sim = @Num_Proc_SIM and item_cont=@Item_Cont and cd_tp_tx=@Cd_Tp_Tx)
		BEGIN
			UPDATE
				Custo_SIM
			SET
				Cd_Tp_Moeda_C	= @Cd_Tp_Moeda_C,
				Vlr_C_SIM	= @VlrCompra,
				Cd_Tp_Moeda_V	= @Cd_Tp_Moeda_V,
				Vlr_V_SIM	= @VlrVenda
			WHERE
				Num_Proc_SIM = @Num_Proc_SIM and Item_Cont = @Item_Cont and Cd_Tp_Tx = @Cd_Tp_Tx
		END
	ELSE
		BEGIN
			INSERT INTO
				Custo_SIM
				(
					Num_Proc_SIM,
					Item_Cont,
					Cd_Tp_Tx,
					Cd_Tp_Moeda_C,
					Vlr_C_SIM,
					Cd_Tp_Moeda_V,
					Vlr_V_SIM
				)
			VALUES
				(
					@Num_Proc_SIM,
					@Item_Cont,
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
