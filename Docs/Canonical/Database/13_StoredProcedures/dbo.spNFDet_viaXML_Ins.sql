SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	Procedure spNFDet_viaXML_Ins

	@ID_NF			int,
	@CNPJ			Varchar(15),
	@GMID			Varchar(30),
	@NCM			varchar(20),
	@Quantidade		float,
	@Vlr_Item		float,
	@Vlr_Total_Item		float,
	@Vlr_Frete		float,
	@Vlr_Seguro		float,
	@Vlr_Outras_Despesas	float,
	@ALIQ_II		float,
	@Vlr_II			float,
	@AlIQ_IPI		float,
	@Vlr_BASE_IPI		float,
	@Vlr_IPI		float,
	@Vlr_ALIQ_PIS		float,
	@Vlr_BASE_PIS		float,
	@Vlr_IMPOSTO_PIS	float,
	@Vlr_ALIQ_COFINS	float,
	@Vlr_BASE_COFINS	float,
	@Vlr_IMPOSTO_COFINS	float,
	@ALIQ_ICMS		float,
	@Vlr_BASE_ICMS		float,
	@Vlr_ICMS		float,
	@Vlr_Total_NF		float,
	@Peso_Bruto		float,
	@Peso_Liquido		float,
	@SITT			int,
	@Num_Proc		varchar(16)
AS
Begin Transaction

	Declare	@Cd_Cliente	Varchar(10)
	Declare @Cd_Pedido	int
	Declare	@Cd_Produto	int
	Declare @ID_Item	int

	Set @Cd_Cliente =(Select Cd_Pes from Pessoa where num_CPF_CNPJ like @CNPJ)
	Set @Cd_Pedido = (select top 1 Cd_Pedido from Pedido_Ship where Num_Proc=@Num_Proc)
	Set @Cd_Produto =(select Cd_Prod from produto_cliente where cd_proc_Cliente=@GMID)
	Set @ID_Item = 	 (Select iSNULL(max(ID_ITEM),0)+1 from Nota_Fiscal_Cliente_Det where ID_NF = @ID_NF and Cd_cliente = @Cd_Cliente)

	Begin 
		Insert Into 
			Nota_Fiscal_Cliente_Det
				(
				ID_Item,
				ID_NF,
				Cd_Cliente,
				Cd_Produto,
				Cd_Pedido,
				NCM,	
				Quantidade,
				Vlr_Item,
				Vlr_Total_Item,
				Vlr_Frete,
				Vlr_Seguro,
				Vlr_Outras_Despesas,
				ALIQ_II,
				VL_II,
				ALIQ_IPI,
				VL_BASE_IPI,
				VL_IPI,
				VL_ALIQ_PIS,
				VL_BASE_PIS,
				VL_IMPOSTO_PIS,
				VL_ALIQ_COFINS,
				VL_BASE_COFINS,
				VL_IMPOSTO_COFINS,
				ALIQ_ICMS,
				VL_BASE_ICMS,
				VL_ICMS,
				Vlr_Total_NF,
				Peso_Bruto,
				Peso_Liquido,
				SITT
				)
			Values
				(
				@ID_Item,
				@ID_NF,
				@Cd_Cliente,
				@Cd_Produto,
				@Cd_Pedido,
				@NCM,	
				@Quantidade,
				@Vlr_Item,
				@Vlr_Total_Item,
				@Vlr_Frete,
				@Vlr_Seguro,
				@Vlr_Outras_Despesas,
				@ALIQ_II,
				@VLr_II,
				@ALIQ_IPI,
				@VLr_BASE_IPI,
				@VLr_IPI,
				@VLr_ALIQ_PIS,
				@VLr_BASE_PIS,
				@VLr_IMPOSTO_PIS,
				@VLr_ALIQ_COFINS,
				@VLr_BASE_COFINS,
				@VLr_IMPOSTO_COFINS,
				@ALIQ_ICMS,
				@VLr_BASE_ICMS,
				@VLr_ICMS,
				@Vlr_Total_NF,
				@Peso_Bruto,
				@Peso_Liquido,
				@SITT
				)
	End

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

Commit Transaction 


GO
