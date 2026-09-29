SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_JSON_FComex_Di_Item_BR_Line_Sel]

	@Id_Processo [bigint],
	@item  [bigint],
	@Tipo [varchar](1) NULL
	   	  
AS
/*
  -  A todos os processos 
  -  C Processo unico  
*/

if @Tipo ='A'
			Begin
				Select	
				    [Id_Processo],
					[Item],
					[cd_Produto],
					[PesoLiquido],
					[PesoBruto],
					[Vlr_Item],
					[FOB_USD],
					[FOB_Reais],
					[Frete_USD],
					[Frete_Reais],
					[Seguro_USD],
					[Seguro_Reais],
					[Acrescimos_USD],
					[Acrescimos_Reais],
					[Aliq_IPI],
					[IPI_Reais],
					[Aliq_II],
					[II_Reais],
					[LI_PERIODICIDADE],
					[Valor_Antidump],
					[Quantidade],
					[Taxa_siscomex],
					[FOB_Moeda],
					[Frete_Moeda_Prepaid],
					[Frete_Moeda_Collect],
					[Frete_Moeda],
					[Valor_CIF_Reais],
					[Valor_II],
					[Valor_IPI],
					[Valor_ICMS],
					[Valor_PIS],
					[Valor_Cofins]
				from ATL_INT.dbo.JSON_FComex_Di_Item_BR_Line
				order by Id_Processo, Item asc
			End
if @Tipo ='C'
			Begin
				Select
				    [Id_Processo],
					[Item],
					[cd_Produto],
					[PesoLiquido],
					[PesoBruto],
					[Vlr_Item],
					[FOB_USD],
					[FOB_Reais],
					[Frete_USD],
					[Frete_Reais],
					[Seguro_USD],
					[Seguro_Reais],
					[Acrescimos_USD],
					[Acrescimos_Reais],
					[Aliq_IPI],
					[IPI_Reais],
					[Aliq_II],
					[II_Reais],
					[LI_PERIODICIDADE],
					[Valor_Antidump],
					[Quantidade],
					[Taxa_siscomex],
					[FOB_Moeda],
					[Frete_Moeda_Prepaid],
					[Frete_Moeda_Collect],
					[Frete_Moeda],
					[Valor_CIF_Reais],
					[Valor_II],
					[Valor_IPI],
					[Valor_ICMS],
					[Valor_PIS],
					[Valor_Cofins]
				from ATL_INT.dbo.JSON_FComex_Di_Item_BR_Line
				Where
					Id_Processo = @Id_Processo
			End

GO
