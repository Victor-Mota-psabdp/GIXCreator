SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Customer_Profile_Taxas
CREATE procedure [dbo].[spATL_Customer_Profile_Taxas_InsUpd]
	
	@ID_CP				int,
	@Cd_Tp_Tx			varchar(3),
	@Cd_Fornecedor		varchar(10),
	@Cd_Tipo_Compra		varchar(1),
	@Vlr_Compra			float,
	@Vlr_Min_Compra		float,	
	@Vlr_Max_Compra		float,
	@Cd_Tp_Moeda_Compra varchar(3),
	@Cd_Range_Compra	varchar(1),
	
	@Cd_Tipo_Venda		varchar(1),
	@Vlr_Venda			float,
	@Vlr_Min_Venda		float,
	@Vlr_Max_Venda		float,
	@Cd_Tp_Moeda_Venda	varchar(3),
	@Cd_Range_Venda		varchar(1),		
	@Campo_Obs_Taxas	varchar(500),
	@IVA				char(1),
	@Id_DC				int


AS

Begin Transaction

	if @cd_fornecedor = '' or @cd_Fornecedor is null
		Begin
			set @cd_fornecedor = ''
		End
	if @cd_tipo_compra is  null
		Begin
			set @cd_tipo_compra = 'J'
		End

	if @cd_tipo_venda is  null		
		Begin
			set @cd_Tipo_venda = 'J'
		End

	
	IF  exists(
		SELECT
			ID_CP, cd_tp_tx
		FROM
			Customer_Profile_taxas
		WHERE
			ID_CP = @ID_CP and (cd_fornecedor = @cd_fornecedor or cd_fornecedor is null) and Cd_tp_tx = @Cd_tp_tx and cd_tipo_compra = @Cd_Tipo_Compra and cd_tipo_venda = @cd_tipo_venda		
		)

	BEGIN
		UPDATE
			Customer_profile_taxas
		SET
			cd_fornecedor = @cd_fornecedor,
			cd_tipo_compra = @cd_tipo_compra,
			cd_tp_moeda_compra = @cd_tp_moeda_compra,
			cd_range_compra = @cd_range_compra,
			vlr_compra = @vlr_compra,
			vlr_min_compra = @vlr_min_compra,
			cd_tipo_venda = @cd_tipo_venda,
			cd_tp_moeda_venda = @cd_tp_moeda_venda,
			cd_range_venda = @cd_range_venda,
			vlr_venda = @vlr_venda,	
			vlr_min_venda = @vlr_min_venda,
			campo_obs_taxas = @campo_obs_taxas,
			IVA = @IVA,
			id_dc = @id_dc,
			Vlr_Max_Compra = @Vlr_Max_Compra,
			Vlr_Max_Venda = @Vlr_Max_Venda			
		WHERE
			ID_CP = @ID_CP and (cd_fornecedor = @cd_fornecedor or cd_fornecedor is null) and Cd_tp_tx = @Cd_tp_tx and cd_tipo_compra = @cd_tipo_compra and cd_tipo_venda = @cd_tipo_Venda
						
	END
	ELSE
		INSERT
			Customer_Profile_taxas(
				ID_CP, cd_tp_tx, cd_fornecedor, cd_tipo_compra, cd_tp_moeda_compra, cd_range_compra, vlr_compra, vlr_min_compra, cd_tipo_venda, cd_tp_moeda_venda, cd_range_venda, vlr_venda, vlr_min_venda,campo_obs_taxas, IVA, ID_DC, Vlr_Max_Compra, Vlr_Max_Venda
				)
		Values
			(
				@ID_CP, @cd_tp_tx, @cd_fornecedor, @cd_tipo_compra, @cd_tp_moeda_compra, @cd_range_compra, @vlr_compra, @vlr_min_compra, @cd_tipo_venda, @cd_tp_moeda_venda, @cd_range_venda, @vlr_venda, @vlr_min_venda, @campo_obs_taxas, @IVA,@ID_DC, @Vlr_Max_Compra, @Vlr_Max_Venda
			)

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1

	END

Commit Transaction

GO
