SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Atualizado pra pegar o fonecedor como Null ou ''

CREATE    procedure [dbo].[spCustomer_Profile_Taxas_InsUpd]
	
	@ID_CP				int,
	@Tp_Tx				varchar(50),
	@Fornecedor			varchar(50),
	@Nome_DC			varchar(50),
	@Tp_compra			varchar(30),
	@Tp_moeda_compra	varchar(30),
	@Range_Compra		varchar(30),
	@Vlr_Compra			float,
	@Vlr_Min_Compra		float,	
	@Tipo_Venda			varchar(30),
	@Tp_Moeda_Venda		varchar(30),
	@Range_Venda		varchar(30),
	@Vlr_Venda			float,
	@Vlr_Min_Venda		float,
	@Campo_Obs_Taxas	varchar(500),
	@IVA				char(1),
	@Vlr_Max_Compra		float,
	@Vlr_Max_Venda		float

AS

Begin Transaction

	Declare @cd_tp_tx			varchar(3)
	Declare @cd_fornecedor		varchar(10)
	Declare @Cd_tipo_compra		varchar(1)
	Declare @cd_tp_moeda_compra varchar(3)
	Declare @cd_range_compra	varchar(1)	
	Declare @cd_tipo_venda		varchar(1)
	Declare @cd_tp_moeda_venda	varchar(3)
	Declare @cd_range_venda		varchar(1)
	Declare @id_dc				int


	set @cd_tp_tx = (select cd_tp_tx from tipo_taxa where nome_tp_tx = @tp_tx)
	set @cd_fornecedor = (select cd_pes from pessoa where apelido = @fornecedor and Desat_pes='N')
	if @cd_fornecedor = '' or @cd_fornecedor is null
		Begin
			set @cd_fornecedor = Null
		End
	if @Tp_Compra is not null 
		Begin
			set @cd_tipo_compra = (select cd_cv from tipo_compra_venda_cp where descricao_cv = @tp_compra)
		end
	else
		Begin
			set @cd_tipo_compra = 'J'
		End

	set @cd_tp_moeda_compra = (select cd_tp_moeda from tipo_moeda where nome_tp_moeda= @tp_moeda_compra)
	set @cd_range_compra = (select cd_range from tipo_Range_cp where range_descricao = @range_compra)
	if @tipo_venda is not null
		Begin	
			set @cd_tipo_venda = (select cd_cv from tipo_compra_venda_cp where descricao_cv = @tipo_venda)
		End
	else
		Begin
			set @cd_Tipo_venda = 'J'
		End

	set @cd_tp_moeda_venda = (select cd_tp_moeda from tipo_moeda where nome_tp_moeda = @tp_moeda_venda)
	set @cd_range_venda = (select cd_range from tipo_Range_cp where range_descricao = @range_venda)
	set @id_dc = (select id_dc from tipo_doc_cliente where nome_dc = @Nome_Dc)
	
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
