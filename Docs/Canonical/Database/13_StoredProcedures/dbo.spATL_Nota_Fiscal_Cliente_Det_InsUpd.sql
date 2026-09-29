SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Nota_Fiscal_Cliente_Det

CREATE Procedure [dbo].[spATL_Nota_Fiscal_Cliente_Det_InsUpd]
(
	@ID_Item		int,
	@ID_NF			bigint,
	@Cd_Cliente		varchar(10),
	@Cd_Pedido		int,
	@Cd_Produto		int,
	@NCM			varchar(20),
	@Quantidade		float,
	@Vlr_Item		float,
	@Vlr_Total_Item	float,
	@Vlr_Frete		float,
	@Vlr_Seguro		float,
	@Vlr_Siscomex	float,
	@Vlr_Outras_Despesas	float,
	@ALIQ_II		float,
	@VL_BASE_II		float,
	@VL_II			float,
	@ALIQ_IPI		float,
	@VL_BASE_IPI		float,
	@VL_TRIBUTAVEL_IPI	float,
	@VL_IPI				float,
	@VL_ALIQ_PIS	float,
	@VL_BASE_PIS	float,
	@VL_IMPOSTO_PIS	float,
	@VL_ALIQ_COFINS	float,
	@VL_BASE_COFINS	float,
	@VL_IMPOSTO_COFINS	float,
	@ALIQ_ICMS		float,
	@VL_BASE_ICMS	float,
	@VL_ICMS		float,
	@VL_TRIBUTAVEL_ICMS	float,
	@Vlr_Total_NF	float,
	@Peso_Bruto		float,
	@Peso_Liquido	float,
	@SITT			varchar(6),
	@UoM			varchar(10),
	@Vlr_Desconto	decimal,
	@ACRESCIMOS		float,
	@CIF			float,
	@FOB			float,
	@FreteCollect	float
)

AS

	IF EXISTS(SELECT ID_Item FROM Nota_Fiscal_Cliente_Det Where id_item=@id_item and ID_NF = @ID_NF 
			and Cd_Cliente = @Cd_Cliente and cd_produto=@cd_produto)
		Begin		
			Update
				Nota_Fiscal_Cliente_Det
			Set			
				ID_Item=@ID_Item,
				NCM=@NCM,
				Quantidade=@Quantidade,
				Vlr_Item=@Vlr_Item,
				Vlr_Total_Item=@Vlr_Total_Item,
				Vlr_Frete=@Vlr_Frete,
				Vlr_Seguro=@Vlr_Seguro,
				Vlr_Siscomex=@Vlr_Siscomex,
				Vlr_Outras_Despesas=@Vlr_Outras_Despesas,
				ALIQ_II=@ALIQ_II,
				VL_BASE_II=@VL_BASE_II,
				VL_II=@VL_II,
				ALIQ_IPI=@ALIQ_IPI,
				VL_BASE_IPI=@VL_BASE_IPI,
				VL_TRIBUTAVEL_IPI=@VL_TRIBUTAVEL_IPI,
				VL_IPI=@VL_IPI,
				VL_ALIQ_PIS=@VL_ALIQ_PIS,
				VL_BASE_PIS=@VL_BASE_PIS,
				VL_IMPOSTO_PIS=@VL_IMPOSTO_PIS,
				VL_ALIQ_COFINS=@VL_ALIQ_COFINS,
				VL_BASE_COFINS=@VL_BASE_COFINS,
				VL_IMPOSTO_COFINS=@VL_IMPOSTO_COFINS,
				ALIQ_ICMS=@ALIQ_ICMS,
				VL_BASE_ICMS=@VL_BASE_ICMS,
				VL_ICMS=@VL_ICMS,
				VL_TRIBUTAVEL_ICMS=@VL_TRIBUTAVEL_ICMS,
				Vlr_Total_NF=@Vlr_Total_NF,
				Peso_Bruto=@Peso_Bruto,
				Peso_Liquido=@Peso_Liquido,
				SITT=@SITT,
				UoM=@UoM,
				Vlr_Desconto=@Vlr_Desconto,
				ACRESCIMOS=@ACRESCIMOS,
				CIF=@CIF,
				FOB=@FOB,
				FreteCollect=@FreteCollect
			where
				ID_NF = @ID_NF  and Cd_Cliente = @Cd_Cliente 
				and cd_produto=@cd_produto AND Cd_Pedido = @Cd_Pedido					 		
		End	
	ELSE		
		Begin 
			Set @ID_Item =(Select iSNULL(max(ID_ITEM),0)+1 from Nota_Fiscal_Cliente_Det where ID_NF = @ID_NF and Cd_cliente = @Cd_Cliente) 

			Insert Into Nota_Fiscal_Cliente_Det	
			(
				ID_Item,ID_NF,Cd_Cliente,Cd_Pedido,Cd_Produto,NCM,Quantidade,Vlr_Item,Vlr_Total_Item,Vlr_Frete,
				Vlr_Seguro,Vlr_Siscomex,Vlr_Outras_Despesas,ALIQ_II,VL_BASE_II,VL_II,ALIQ_IPI,VL_BASE_IPI,VL_TRIBUTAVEL_IPI,
				VL_IPI,VL_ALIQ_PIS,VL_BASE_PIS,VL_IMPOSTO_PIS,VL_ALIQ_COFINS,VL_BASE_COFINS,VL_IMPOSTO_COFINS,ALIQ_ICMS,VL_BASE_ICMS,
				VL_ICMS,VL_TRIBUTAVEL_ICMS,Vlr_Total_NF,Peso_Bruto,Peso_Liquido,SITT,UoM,Vlr_Desconto,ACRESCIMOS,CIF,
				FOB,FreteCollect
			)					
			Values
			(
				@ID_Item,@ID_NF,@Cd_Cliente,@Cd_Pedido,@Cd_Produto,@NCM,@Quantidade,@Vlr_Item,@Vlr_Total_Item,@Vlr_Frete,
				@Vlr_Seguro,@Vlr_Siscomex,@Vlr_Outras_Despesas,@ALIQ_II,@VL_BASE_II,@VL_II,@ALIQ_IPI,@VL_BASE_IPI,@VL_TRIBUTAVEL_IPI,
				@VL_IPI,@VL_ALIQ_PIS,@VL_BASE_PIS,@VL_IMPOSTO_PIS,@VL_ALIQ_COFINS,@VL_BASE_COFINS,@VL_IMPOSTO_COFINS,@ALIQ_ICMS,@VL_BASE_ICMS,
				@VL_ICMS,@VL_TRIBUTAVEL_ICMS,@Vlr_Total_NF,@Peso_Bruto,@Peso_Liquido,@SITT,@UoM,@Vlr_Desconto,@ACRESCIMOS,@CIF,
				@FOB,@FreteCollect
			)					
	End
		






























GO
