SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 02-01-2026 - antonio amarrar o numro da nota fiscal no item 
CREATE procedure [dbo].[spATL_JSON_FComex_Nota_Cliente_Det_Line_InsUp]

	@Id_Processo [bigint],
	@Nota_Fiscal [varchar](200) NULL,
	@Id_Item [bigint],
	@Cd_Cliente [varchar](200) NULL,
	@Cd_Pedido [varchar](200) NULL,
	@Cd_Produto [varchar](200) NULL,
	@NCM [varchar](200) NULL,
	@Quantidade [varchar](200) NULL,
	@Vlr_Item [varchar](200) NULL,
	@Vlr_Total_Item [varchar](200) NULL,
	@Vlr_Frete [varchar](200) NULL,
	@Vlr_Seguro [varchar](200) NULL,
	@Vlr_Siscomex [varchar](200) NULL,
	@Vlr_Outras_Despesas [varchar](200) NULL,
	@ALIQ_II [varchar](200) NULL,
	@VL_BASE_II [varchar](200) NULL,
	@VL_II [varchar](200) NULL,
	@ALIQ_IPI [varchar](200) NULL,
	@VL_BASE_IPI [varchar](200) NULL,
	@VL_TRIBUTAVEL_IPI [varchar](200) NULL,
	@VL_IPI [varchar](200) NULL,
	@VL_ALIQ_PIS [varchar](200) NULL,
	@VL_BASE_PIS [varchar](200) NULL,
	@VL_IMPOSTO_PIS [varchar](200) NULL,
	@VL_ALIQ_COFINS [varchar](200) NULL,
	@VL_BASE_COFINS [varchar](200) NULL,
	@VL_IMPOSTO_COFINS [varchar](200) NULL,
	@ALIQ_ICMS [varchar](200) NULL,
	@VL_BASE_ICMS [varchar](200) NULL,
	@VL_ICMS [varchar](200) NULL,
	@VL_TRIBUTAVEL_ICMS [varchar](200) NULL,
	@Vlr_Total_NF [varchar](200) NULL,
	@Peso_Bruto [varchar](200) NULL,
	@Peso_Liquido [varchar](200) NULL,
	@SITT [varchar](200) NULL,
	@UoM [varchar](200) NULL,
	@Vlr_Desconto [varchar](200) NULL,
	@ACRESCIMOS [varchar](200) NULL,
	@CIF [varchar](200) NULL,
	@FOB [varchar](200) NULL,
	@FreteCollect [varchar](200) NULL
	   	  
AS
BEGIN
BEGIN TRANSACTION;
--Exceção(try/CATCH)
--Transação
--sp_help JSON_FComex_Nota_Cliente_Det_Line

	BEGIN TRY
		IF exists(select @Id_Processo from ATL_INT.dbo.JSON_FComex_Nota_Cliente_Det_Line 
		          where Id_Processo = @Id_Processo 
				  and   Nota_Fiscal = @Nota_Fiscal
				  and   Id_item = @Id_item)
			Begin
				Update
					ATL_INT.dbo.JSON_FComex_Nota_Cliente_Det_Line
				Set	
					[Cd_Cliente] =@Cd_Cliente,
					[Cd_Pedido] =@Cd_Pedido,
					[Cd_Produto] = @Cd_Produto,
					[NCM] =@NCM,
					[Quantidade] =@Quantidade,
					[Vlr_Item] =@Vlr_Item,
					[Vlr_Total_Item] =@Vlr_Total_Item,
					[Vlr_Frete] =@Vlr_Frete,
					[Vlr_Seguro] =@Vlr_Seguro,
					[Vlr_Siscomex] =@Vlr_Siscomex,
					[Vlr_Outras_Despesas] = @Vlr_Outras_Despesas,
					[ALIQ_II] = @ALIQ_II,
					[VL_BASE_II] =@VL_BASE_II,
					[VL_II] = @VL_II,
					[ALIQ_IPI] =@ALIQ_IPI,
					[VL_BASE_IPI] =@VL_BASE_IPI,
					[VL_TRIBUTAVEL_IPI] = @VL_TRIBUTAVEL_IPI,
					[VL_IPI]=@VL_IPI,
					[VL_ALIQ_PIS] =@VL_ALIQ_PIS,
					[VL_BASE_PIS] =@VL_BASE_PIS,
					[VL_IMPOSTO_PIS] =@VL_IMPOSTO_PIS,
					[VL_ALIQ_COFINS] =@VL_ALIQ_COFINS,
					[VL_BASE_COFINS] =@VL_BASE_COFINS,
					[VL_IMPOSTO_COFINS] =@VL_IMPOSTO_COFINS,
					[ALIQ_ICMS] = @ALIQ_ICMS,
					[VL_BASE_ICMS] =@VL_BASE_ICMS,
					[VL_ICMS] =@VL_ICMS,
					[VL_TRIBUTAVEL_ICMS] =@VL_TRIBUTAVEL_ICMS,
					[Vlr_Total_NF] =@Vlr_Total_NF,
					[Peso_Bruto] =@Peso_Bruto,
					[Peso_Liquido] =@Peso_Liquido,
					[SITT] =@SITT,
					[UoM] =@UoM,
					[Vlr_Desconto] =@Vlr_Desconto,
					[ACRESCIMOS] =@ACRESCIMOS,
					[CIF] =@CIF,
					[FOB] =@FOB,
					[FreteCollect] =@FreteCollect
				Where
					Id_Processo = @Id_Processo 
				and Nota_Fiscal = @Nota_Fiscal					
                and Id_Item = @id_Item 
			End
		Else
			BEGIN
				Insert ATL_INT.dbo.JSON_FComex_Nota_Cliente_Det_Line
				(
                    [Id_Processo],
					[Nota_Fiscal],
					[Id_item],
					[Cd_Cliente],
					[Cd_Pedido],
					[Cd_Produto],
					[NCM],
					[Quantidade],
					[Vlr_Item],
					[Vlr_Total_Item],
					[Vlr_Frete],
					[Vlr_Seguro],
					[Vlr_Siscomex],
					[Vlr_Outras_Despesas],
					[ALIQ_II],
					[VL_BASE_II],
					[VL_II],
					[ALIQ_IPI],
					[VL_BASE_IPI],
					[VL_TRIBUTAVEL_IPI],
					[VL_IPI],
					[VL_ALIQ_PIS],
					[VL_BASE_PIS],
					[VL_IMPOSTO_PIS],
					[VL_ALIQ_COFINS],
					[VL_BASE_COFINS],
					[VL_IMPOSTO_COFINS],
					[ALIQ_ICMS],
					[VL_BASE_ICMS],
					[VL_ICMS],
					[VL_TRIBUTAVEL_ICMS],
					[Vlr_Total_NF],
					[Peso_Bruto],
					[Peso_Liquido],
					[SITT],
					[UoM],
					[Vlr_Desconto],
					[ACRESCIMOS],
					[CIF],
					[FOB],
					[FreteCollect]
				)
				Values
				(
				    @Id_Processo,
					@Nota_Fiscal,
					@Id_Item,
					@Cd_Cliente,
					@Cd_Pedido,
					@Cd_Produto,
					@NCM,
					@Quantidade,
					@Vlr_Item,
					@Vlr_Total_Item,
					@Vlr_Frete,
					@Vlr_Seguro,
					@Vlr_Siscomex,
					@Vlr_Outras_Despesas,
					@ALIQ_II,
					@VL_BASE_II,
					@VL_II,
					@ALIQ_IPI,
					@VL_BASE_IPI,
					@VL_TRIBUTAVEL_IPI,
					@VL_IPI,
					@VL_ALIQ_PIS,
					@VL_BASE_PIS,
					@VL_IMPOSTO_PIS,
					@VL_ALIQ_COFINS,
					@VL_BASE_COFINS,
					@VL_IMPOSTO_COFINS,
					@ALIQ_ICMS,
					@VL_BASE_ICMS,
					@VL_ICMS,
					@VL_TRIBUTAVEL_ICMS,
					@Vlr_Total_NF,
					@Peso_Bruto,
					@Peso_Liquido,
					@SITT,
					@UoM,
					@Vlr_Desconto,
					@ACRESCIMOS,
					@CIF,
					@FOB,
					@FreteCollect
				)
			END	
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;
	END CATCH	
END
GO
