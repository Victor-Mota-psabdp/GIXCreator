SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--26-12-2025 - antonio separar a opção D e colocar para tratar o numero do Item para conseguir 
--salvar o mesmo produto mais de uma vez nos itens da nota fiscal 

CREATE PROCEDURE [dbo].[spATL_Nota_Fiscal_Cliente_Det_Sel]
(  
	@ID_Item		int,
	@ID_NF			bigint,
	@Cd_Cliente		varchar(10),
	@Cd_Pedido		int,
	@Cd_Produto		int,
	@Tipo			CHAR(1)  
)  
AS  
  
  
IF @Tipo = 'A' OR @Tipo = 'B'  
	BEGIN
		SELECT 
			NF.ID_Item,
			NF.ID_NF,
			NF.Cd_Cliente			[Client Code],
			PS.Apelido				[Client Name],
			NF.Cd_Pedido			[Order Code],
			PD.Num_Pedido			[Order Number],
			NF.Cd_Produto			[Product Code],
			PC.cd_Proc_Cliente		[Product ID],
			PC.Produto_Descr		[Product Description],
			NF.NCM,
			NF.Quantidade,
			NF.Vlr_Item,
			NF.Vlr_Total_Item,
			NF.Vlr_Frete,
			NF.Vlr_Seguro,
			NF.Vlr_Siscomex,
			NF.Vlr_Outras_Despesas,
			NF.ALIQ_II,
			NF.VL_BASE_II,
			NF.VL_II,
			NF.ALIQ_IPI,
			NF.VL_BASE_IPI,
			NF.VL_TRIBUTAVEL_IPI,
			NF.VL_IPI,
			NF.VL_ALIQ_PIS,
			NF.VL_BASE_PIS,
			NF.VL_IMPOSTO_PIS,
			NF.VL_ALIQ_COFINS,
			NF.VL_BASE_COFINS,
			NF.VL_IMPOSTO_COFINS,
			NF.ALIQ_ICMS,
			NF.VL_BASE_ICMS,
			NF.VL_ICMS,
			NF.VL_TRIBUTAVEL_ICMS,
			NF.Vlr_Total_NF,
			NF.Peso_Bruto,
			NF.Peso_Liquido,
			NF.SITT,
			NF.UoM,
			NF.Vlr_Desconto,
			NF.ACRESCIMOS,
			NF.CIF,
			NF.FOB,
			NF.FreteCollect
		from Nota_Fiscal_Cliente_Det		NF	With(nolock)		
			Left Outer Join Pedido_Ship		PDS With(nolock)	on NF.Cd_Pedido = PDS.Cd_Pedido
			Left Outer Join Pedido			PD	With(nolock)	on PDS.Cd_Pedido = PD.Cd_Pedido
			Left Outer Join Produto_Cliente PC 	With(nolock)	on NF.Cd_Produto =PC.Cd_prod  and PC.cd_cliente = NF.Cd_Cliente
			Left Outer Join Pessoa			PS	With(nolock)	on NF.Cd_Cliente = PS.cd_pes
		where
			ID_NF= @ID_NF and NF.Cd_Cliente = @Cd_Cliente
	END  
  
IF @Tipo = 'C' 
	BEGIN  
		SELECT 
			NF.ID_Item,
			NF.ID_NF,
			NF.Cd_Cliente			[Client Code],
			PS.Apelido				[Client Name],
			NF.Cd_Pedido			[Order Code],
			PD.Num_Pedido			[Order Number],
			NF.Cd_Produto			[Product Code],
			PC.cd_Proc_Cliente		[Product ID],
			PC.Produto_Descr		[Product Description],
			NF.NCM,
			NF.Quantidade,
			NF.Vlr_Item,
			NF.Vlr_Total_Item,
			NF.Vlr_Frete,
			NF.Vlr_Seguro,
			NF.Vlr_Siscomex,
			NF.Vlr_Outras_Despesas,
			NF.ALIQ_II,
			NF.VL_BASE_II,
			NF.VL_II,
			NF.ALIQ_IPI,
			NF.VL_BASE_IPI,
			NF.VL_TRIBUTAVEL_IPI,
			NF.VL_IPI,
			NF.VL_ALIQ_PIS,
			NF.VL_BASE_PIS,
			NF.VL_IMPOSTO_PIS,
			NF.VL_ALIQ_COFINS,
			NF.VL_BASE_COFINS,
			NF.VL_IMPOSTO_COFINS,
			NF.ALIQ_ICMS,
			NF.VL_BASE_ICMS,
			NF.VL_ICMS,
			NF.VL_TRIBUTAVEL_ICMS,
			NF.Vlr_Total_NF,
			NF.Peso_Bruto,
			NF.Peso_Liquido,
			NF.SITT,
			NF.UoM,
			NF.Vlr_Desconto,
			NF.ACRESCIMOS,
			NF.CIF,
			NF.FOB,
			NF.FreteCollect
		from Nota_Fiscal_Cliente_Det		NF	With(nolock)		
			--Left Outer Join Pedido_Ship		PDS With(nolock)	on NF.Cd_Pedido = PDS.Cd_Pedido			--
			Join Pessoa			PS	With(nolock)	on NF.Cd_Cliente = PS.cd_pes
			Join Pessoa_LLP		PL	With(nolock)	on NF.Cd_Cliente = PL.cd_pes
			Join Produto_Cliente PC With(nolock)	on NF.Cd_Produto =PC.Cd_prod  and PC.cd_cliente = PL.cd_pes_grupo
			Join Pedido			PD	With(nolock)	on NF.Cd_Pedido = PD.Cd_Pedido			
		where
			ID_NF= @ID_NF
			and NF.Cd_Cliente = @Cd_Cliente
			and NF.Cd_Pedido=@Cd_Pedido
			and NF.Cd_Produto=@Cd_Produto 

   END 

IF @Tipo = 'D'  
	BEGIN  
		SELECT 
			NF.ID_Item,
			NF.ID_NF,
			NF.Cd_Cliente			[Client Code],
			PS.Apelido				[Client Name],
			NF.Cd_Pedido			[Order Code],
			PD.Num_Pedido			[Order Number],
			NF.Cd_Produto			[Product Code],
			PC.cd_Proc_Cliente		[Product ID],
			PC.Produto_Descr		[Product Description],
			NF.NCM,
			NF.Quantidade,
			NF.Vlr_Item,
			NF.Vlr_Total_Item,
			NF.Vlr_Frete,
			NF.Vlr_Seguro,
			NF.Vlr_Siscomex,
			NF.Vlr_Outras_Despesas,
			NF.ALIQ_II,
			NF.VL_BASE_II,
			NF.VL_II,
			NF.ALIQ_IPI,
			NF.VL_BASE_IPI,
			NF.VL_TRIBUTAVEL_IPI,
			NF.VL_IPI,
			NF.VL_ALIQ_PIS,
			NF.VL_BASE_PIS,
			NF.VL_IMPOSTO_PIS,
			NF.VL_ALIQ_COFINS,
			NF.VL_BASE_COFINS,
			NF.VL_IMPOSTO_COFINS,
			NF.ALIQ_ICMS,
			NF.VL_BASE_ICMS,
			NF.VL_ICMS,
			NF.VL_TRIBUTAVEL_ICMS,
			NF.Vlr_Total_NF,
			NF.Peso_Bruto,
			NF.Peso_Liquido,
			NF.SITT,
			NF.UoM,
			NF.Vlr_Desconto,
			NF.ACRESCIMOS,
			NF.CIF,
			NF.FOB,
			NF.FreteCollect
		from Nota_Fiscal_Cliente_Det		NF	With(nolock)		
			--Left Outer Join Pedido_Ship		PDS With(nolock)	on NF.Cd_Pedido = PDS.Cd_Pedido			--
			Join Pessoa			PS	With(nolock)	on NF.Cd_Cliente = PS.cd_pes
			Join Pessoa_LLP		PL	With(nolock)	on NF.Cd_Cliente = PL.cd_pes
			Join Produto_Cliente PC With(nolock)	on NF.Cd_Produto =PC.Cd_prod  and PC.cd_cliente = PL.cd_pes_grupo
			Join Pedido			PD	With(nolock)	on NF.Cd_Pedido = PD.Cd_Pedido			
		where
			ID_NF= @ID_NF
			and NF.ID_Item = @ID_Item
			and NF.Cd_Cliente = @Cd_Cliente
			and NF.Cd_Pedido=@Cd_Pedido
			and NF.Cd_Produto=@Cd_Produto 
	END  

IF @Tipo = 'E'   
	BEGIN
		SELECT 
			NF.ID_Item,
			NF.ID_NF,
			NF.Cd_Cliente			[Client Code],
			PS.Apelido				[Client Name],
			NF.Cd_Pedido			[Order Code],
			''          			[Order Number],
			NF.Cd_Produto			[Product Code],
			''		                [Product ID],
			''	                	[Product Description],
			NF.NCM,
			NF.Quantidade,
			NF.Vlr_Item,
			NF.Vlr_Total_Item,
			NF.Vlr_Frete,
			NF.Vlr_Seguro,
			NF.Vlr_Siscomex,
			NF.Vlr_Outras_Despesas,
			NF.ALIQ_II,
			NF.VL_BASE_II,
			NF.VL_II,
			NF.ALIQ_IPI,
			NF.VL_BASE_IPI,
			NF.VL_TRIBUTAVEL_IPI,
			NF.VL_IPI,
			NF.VL_ALIQ_PIS,
			NF.VL_BASE_PIS,
			NF.VL_IMPOSTO_PIS,
			NF.VL_ALIQ_COFINS,
			NF.VL_BASE_COFINS,
			NF.VL_IMPOSTO_COFINS,
			NF.ALIQ_ICMS,
			NF.VL_BASE_ICMS,
			NF.VL_ICMS,
			NF.VL_TRIBUTAVEL_ICMS,
			NF.Vlr_Total_NF,
			NF.Peso_Bruto,
			NF.Peso_Liquido,
			NF.SITT,
			NF.UoM,
			NF.Vlr_Desconto,
			NF.ACRESCIMOS,
			NF.CIF,
			NF.FOB,
			NF.FreteCollect
		from Nota_Fiscal_Cliente_Det		NF	With(nolock)		
			 Join Pessoa PS	With(nolock) on NF.Cd_Cliente = PS.cd_pes
		where
			ID_NF= @ID_NF and NF.Cd_Cliente = @Cd_Cliente
	END  

-- incluir o item na procura para trazer vazio caso ele exista, caso o codigo do produto
-- ja tiver sido lancado uma vez. Ex.:- item 1 = produto001,  item 2= produto001
	  
IF @Tipo = 'F'  
	BEGIN
		SELECT 
			NF.ID_Item,
			NF.ID_NF,
			NF.Cd_Cliente			[Client Code],
			PS.Apelido				[Client Name],
			NF.Cd_Pedido			[Order Code],
			PD.Num_Pedido			[Order Number],
			NF.Cd_Produto			[Product Code],
			PC.cd_Proc_Cliente		[Product ID],
			PC.Produto_Descr		[Product Description],
			NF.NCM,
			NF.Quantidade,
			NF.Vlr_Item,
			NF.Vlr_Total_Item,
			NF.Vlr_Frete,
			NF.Vlr_Seguro,
			NF.Vlr_Siscomex,
			NF.Vlr_Outras_Despesas,
			NF.ALIQ_II,
			NF.VL_BASE_II,
			NF.VL_II,
			NF.ALIQ_IPI,
			NF.VL_BASE_IPI,
			NF.VL_TRIBUTAVEL_IPI,
			NF.VL_IPI,
			NF.VL_ALIQ_PIS,
			NF.VL_BASE_PIS,
			NF.VL_IMPOSTO_PIS,
			NF.VL_ALIQ_COFINS,
			NF.VL_BASE_COFINS,
			NF.VL_IMPOSTO_COFINS,
			NF.ALIQ_ICMS,
			NF.VL_BASE_ICMS,
			NF.VL_ICMS,
			NF.VL_TRIBUTAVEL_ICMS,
			NF.Vlr_Total_NF,
			NF.Peso_Bruto,
			NF.Peso_Liquido,
			NF.SITT,
			NF.UoM,
			NF.Vlr_Desconto,
			NF.ACRESCIMOS,
			NF.CIF,
			NF.FOB,
			NF.FreteCollect
		from Nota_Fiscal_Cliente_Det		NF	With(nolock)		
			Left Outer Join Pedido_Ship		PDS With(nolock)	on NF.Cd_Pedido = PDS.Cd_Pedido
			Left Outer Join Pedido			PD	With(nolock)	on PDS.Cd_Pedido = PD.Cd_Pedido
			Left Outer Join Produto_Cliente PC 	With(nolock)	on NF.Cd_Produto =PC.Cd_prod  and PC.cd_cliente = NF.Cd_Cliente
			Left Outer Join Pessoa			PS	With(nolock)	on NF.Cd_Cliente = PS.cd_pes
		where
			ID_NF= @ID_NF
			and NF.Cd_Cliente = @Cd_Cliente
			and nf.ID_Item = @ID_Item
	END

GO
