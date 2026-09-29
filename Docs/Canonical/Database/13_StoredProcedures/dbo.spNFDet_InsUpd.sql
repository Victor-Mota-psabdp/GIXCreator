SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE         	 Procedure [dbo].[spNFDet_InsUpd] 

			@ID_NF			int,
			@Cliente		varchar(50),
			@Pedido			Varchar(30),
			@Produto		Varchar(10),
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
			@Acrescimos			float,
			@Num_Proc		varchar(16)

AS
Begin Transaction

	Declare	@Cd_Cliente	Varchar(10)
	Declare @Cd_Pedido	int
	Declare	@Cd_Produto	int
	Declare @ID_Item	int

	Set @Cd_Cliente = (Select Cd_Pes from Pessoa where apelido = @Cliente)
	Set @Cd_Pedido = (
			select top 1 PD.Cd_Pedido from Pedido PD
			Join Pedido_Ship PS on PS.cd_pedido=PD.cd_pedido	
			
			where Num_Pedido=@Pedido and num_proc=@num_proc
			)
	Set @Cd_Produto = (select top 1 Cd_Prod from produto_cliente where cd_proc_Cliente=@Produto)-- and cd_cliente=@cd_cliente) 

/**
	 '1','Dow Brasil','987654321','B100190','A','TESTE',1,1,1,1,11,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
			Print @Cd_CLiente
			Print @Cd_Pedido
			Print @Cd_Produto
			Print @ID_Item

**/

	IF EXISTS(SELECT ID_Item FROM Nota_Fiscal_Cliente_Det 
		Where ID_NF = @ID_NF  and Cd_Cliente = @Cd_Cliente and cd_produto=@cd_produto and @Cd_Pedido = Cd_Pedido)
		Begin					

				Update
					Nota_Fiscal_Cliente_Det
				Set
			
					NCM 			= @NCM,	
					Quantidade 		= @Quantidade,
					Vlr_Item 		= @Vlr_Item,
					Vlr_Total_Item 		= @Vlr_Total_Item,
					Vlr_Frete 		= @Vlr_Frete,
					Vlr_Seguro 		= @Vlr_Seguro,
					Vlr_Outras_Despesas 	= @Vlr_Outras_Despesas,
					ALIQ_II			= @ALIQ_II,
					VL_II 			= @VLr_II,
					ALIQ_IPI 		= @ALIQ_IPI,
					VL_BASE_IPI 		= @VLr_BASE_IPI,
					VL_TRIBUTAVEL_IPI 	= @VLr_TRIBUTAVEL_IPI,
					VL_IPI 			= @VLr_IPI,
					VL_ALIQ_PIS 		= @VLr_ALIQ_PIS,
					VL_BASE_PIS 		= @VLr_BASE_PIS,
					VL_IMPOSTO_PIS 		= @VLr_IMPOSTO_PIS,
					VL_ALIQ_COFINS 		= @VLr_ALIQ_COFINS,
					VL_BASE_COFINS 		= @VLr_BASE_COFINS,
					VL_IMPOSTO_COFINS 	= @VLr_IMPOSTO_COFINS,
					ALIQ_ICMS 		= @ALIQ_ICMS,
					VL_BASE_ICMS 		= @VLr_BASE_ICMS,
					VL_ICMS 		= @VLr_ICMS,
					VL_TRIBUTAVEL_ICMS 	= @VLr_TRIBUTAVEL_ICMS,
					Vlr_Total_NF 		= @Vlr_Total_NF,
					Cd_Produto 		= @Cd_Produto,
					Peso_Bruto 		= @Peso_Bruto,
					Peso_Liquido 		= @Peso_Liquido,
					Acrescimos			=@Acrescimos
				where
					 ID_NF = @ID_NF  and Cd_Cliente = @Cd_Cliente and cd_produto=@cd_produto AND Cd_Pedido = @Cd_Pedido
		end	

		ELSE		
			Begin 

				Set @ID_Item =(Select iSNULL(max(ID_ITEM),0)+1 from Nota_Fiscal_Cliente_Det where ID_NF = @ID_NF and Cd_cliente = @Cd_Cliente)   


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
							Acrescimos

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
							@Acrescimos
						)
					
		End
		

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1

		END

Commit Transaction 

















GO
