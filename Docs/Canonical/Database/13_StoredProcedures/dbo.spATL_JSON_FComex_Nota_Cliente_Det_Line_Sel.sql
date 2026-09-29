SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_JSON_FComex_Nota_Cliente_Det_Line_Sel]

	@Id_Processo [bigint],
	@Id_Item [bigint],
	@Tipo [varchar](1) NULL
	   	  
AS
/*
02-01-2026 / 10-04-2026 - antonio 
- A todos (colocar a nota fiscal junto na ordem)
--B Pegar unico -  Processo + item 
- C unico pro processo 
*/
if @tipo ='A'
		   begin 
				Select	
                    [Id_Processo],
					[Nota_Fiscal],
					[Id_Item],
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
				From  ATL_INT.dbo.JSON_FComex_Nota_Cliente_Det_Line
				Order by Id_Processo , Nota_Fiscal, Id_Item	
			End
if @tipo ='B'
		   begin 
				Select	
                    [Id_Processo],
					[Nota_Fiscal],
					[Id_Item],
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
				From  ATL_INT.dbo.JSON_FComex_Nota_Cliente_Det_Line
				Where 
					Id_Processo = @Id_Processo 	
				And Id_Item = @Id_Item
		End
if @tipo ='C'
		   begin 
				Select	
                    [Id_Processo],
					[Nota_Fiscal],
					[Id_Item],
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
				From  ATL_INT.dbo.JSON_FComex_Nota_Cliente_Det_Line
				Where 
					Id_Processo = @Id_Processo 	
		End

GO
