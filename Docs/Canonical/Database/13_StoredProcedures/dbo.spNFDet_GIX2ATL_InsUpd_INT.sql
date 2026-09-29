SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spNFDet_GIX2ATL_InsUpd_INT] 

			@ID_NF			int,
			@Cliente		varchar(50),
			@Pedido			Varchar(30),
			@Produto		Varchar(150),
			@Modal			char(1),
			@NCM			varchar (20),
			@Quantidade		float,
			@Vlr_Item		float,
			@Vlr_Total_Item		float,
			@Vlr_Frete		float,
			@Vlr_Seguro		float,
			@Vlr_Outras_Despesas	float,
			@ALIQ_II		float,
			@VLr_II			float,
			@ALIQ_IPI		float,
			@VLr_BASE_IPI		float,
			@VLr_TRIBUTAVEL_IPI	float,
			@VLr_IPI			float,
			@VLr_ALIQ_PIS		float,
			@VLr_BASE_PIS		float,
			@VLr_IMPOSTO_PIS		float,
			@VLr_ALIQ_COFINS		float,
			@VLr_BASE_COFINS		float,
			@VLr_IMPOSTO_COFINS	float,
			@ALIQ_ICMS		float,
			@VLr_BASE_ICMS		float,
			@VLr_ICMS		float,
			@VLr_TRIBUTAVEL_ICMS	float,
			@Vlr_Total_NF		float,
			@Peso_Bruto		float,
			@Peso_Liquido		float,
			@SITT			Varchar(3),
			@Vlr_Siscomex	float,
			@VL_BASE_II		float,
			@Num_Proc		varchar(16),
			@id_item			int,
			@ACRESCIMOS		float,
			@CIF			float,
			@FOB			float,
			@FreteCollect	float,
			@Vlr_Desconto	float

AS
--Begin Transaction

	Declare	@Cd_Cliente	Varchar(10)
	Declare @Cd_Pedido	int
	Declare	@Cd_Produto	int
	Declare @Cd_Pes_Grupo varchar(10) -- Necessario p/ buscar o cd_prod correto na tab produto_cliente

	Set @Cd_Cliente = (Select Cd_Pes from Pessoa with(nolock) where apelido = @Cliente)
	Set @Cd_Pedido = isnull((
			select top 1 PD.Cd_Pedido from Pedido PD with(nolock)
			Join Pedido_Ship PS with(nolock) on PS.cd_pedido=PD.cd_pedido
			where Num_Pedido=@Pedido and num_proc=@num_proc
			),0)
--Claudio: Alteração em 23-09-2010 para buscar o cd_prod correto
	set @Cd_Pes_Grupo = (select top 1 cd_pes_grupo from pessoa_LLP with(nolock) where cd_pes=@Cd_cliente)
	
	Set @Cd_produto = (select top 1 cd_prod from produto_cliente with(nolock) Join Pedido_Ship PS with(nolock) on PS.cd_produto=cd_prod where num_proc=@num_proc and  right('000000000000000000'+cd_proc_cliente,18) =  right('000000000000000000'+@Produto,18))
	
	if @cd_produto is null
		Begin
			Set @Cd_Produto = (select top 1 Cd_Prod from produto_cliente with(nolock) where right(cd_proc_Cliente,len(@produto))=@Produto and cd_cliente=@Cd_Pes_Grupo)
		End

	if @Cd_Produto is null
		Begin
			Set @Cd_Produto = (select top 1 Cd_Prod from produto_cliente with(nolock) where   right('000000000000000000'+cd_proc_Cliente,18) =  right('000000000000000000'+@Produto,18) and cd_cliente=@Cd_Pes_Grupo) 
		End

	IF EXISTS(SELECT ID_Item FROM Nota_Fiscal_Cliente_Det 
		Where id_item=@id_item and ID_NF = @ID_NF  and Cd_Cliente = @Cd_Cliente and cd_produto=@cd_produto)
		Begin
			Update
					Nota_Fiscal_Cliente_Det
				Set
			
					NCM 				= @NCM,	
					Quantidade 			= @Quantidade,
					Vlr_Item 			= @Vlr_Item,
					Vlr_Total_Item 		= @Vlr_Total_Item,
					Vlr_Frete 			= @Vlr_Frete,
					Vlr_Seguro 			= @Vlr_Seguro,
					Vlr_Outras_Despesas = @Vlr_Outras_Despesas,
					ALIQ_II				= @ALIQ_II,
					VL_II 				= @VLr_II,
					ALIQ_IPI 			= @ALIQ_IPI,
					VL_BASE_IPI 		= @VLr_BASE_IPI,
					VL_TRIBUTAVEL_IPI 	= @VLr_TRIBUTAVEL_IPI,
					VL_IPI 				= @VLr_IPI,
					VL_ALIQ_PIS 		= @VLr_ALIQ_PIS,
					VL_BASE_PIS 		= @VLr_BASE_PIS,
					VL_IMPOSTO_PIS 		= @VLr_IMPOSTO_PIS,
					VL_ALIQ_COFINS 		= @VLr_ALIQ_COFINS,
					VL_BASE_COFINS 		= @VLr_BASE_COFINS,
					VL_IMPOSTO_COFINS 	= @VLr_IMPOSTO_COFINS,
					ALIQ_ICMS 			= @ALIQ_ICMS,
					VL_BASE_ICMS 		= @VLr_BASE_ICMS,
					VL_ICMS 			= @VLr_ICMS,
					VL_TRIBUTAVEL_ICMS 	= @VLr_TRIBUTAVEL_ICMS,
					Vlr_Total_NF 		= @Vlr_Total_NF,
					Cd_Produto 			= @Cd_Produto,
					Peso_Bruto 			= @Peso_Bruto,
					Peso_Liquido 		= @Peso_Liquido,
					SITT				= @SITT,
					Vlr_Siscomex		= @Vlr_Siscomex	,
					VL_BASE_II			= @VL_BASE_II,
					ACRESCIMOS			= @ACRESCIMOS,
					CIF					= @CIF,
					FOB					= @FOB,
					FreteCollect		= @FreteCollect,
					Vlr_Desconto		= @Vlr_Desconto
				where
					 ID_NF = @ID_NF  and Cd_Cliente = @Cd_Cliente and cd_produto=@cd_produto AND Cd_Pedido = @Cd_Pedido				 		
		End
	ELSE
		if @Cd_Produto is not null	
			Begin
				Insert Into 	
				Nota_Fiscal_Cliente_Det	(
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
							VL_TRIBUTAVEL_IPI,
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
							VL_TRIBUTAVEL_ICMS,
							Vlr_Total_NF,
							Peso_Bruto,
							Peso_Liquido,
							SITT,
							Vlr_Siscomex,
							VL_BASE_II,
							ACRESCIMOS,
							CIF,
							FOB,
							FreteCollect,
							Vlr_Desconto

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
							@VLr_TRIBUTAVEL_IPI,
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
							@VLr_TRIBUTAVEL_ICMS,
							@Vlr_Total_NF,
							@Peso_Bruto,
							@Peso_Liquido,
							@SITT,
							@Vlr_Siscomex,
							@VL_BASE_II,
							@ACRESCIMOS,
							@CIF,
							@FOB,
							@FreteCollect,
							@Vlr_Desconto

						)					
			End
		

--		IF @@Error <> 0
--			BEGIN
--				ROLLBACK TRANSACTION
--				RETURN -1

--		END

--Commit Transaction 

GO
