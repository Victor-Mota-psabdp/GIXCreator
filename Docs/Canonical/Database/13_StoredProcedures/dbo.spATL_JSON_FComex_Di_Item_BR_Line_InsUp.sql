SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_JSON_FComex_Di_Item_BR_Line_InsUp]

	@Id_Processo [bigint],
	@Item [bigint],
	@cd_Produto [varchar](200) NULL,
	@PesoLiquido [varchar](200) NULL,
	@PesoBruto [varchar](200) NULL,
	@Vlr_Item [varchar](200) NULL,
	@FOB_USD [varchar](200) NULL,
	@FOB_Reais [varchar](200) NULL,
	@Frete_USD [varchar](200) NULL,
	@Frete_Reais [varchar](200) NULL,
	@Seguro_USD [varchar](200) NULL,
	@Seguro_Reais [varchar](200) NULL,
	@Acrescimos_USD [varchar](200) NULL,
	@Acrescimos_Reais [varchar](200) NULL,
	@Aliq_IPI [varchar](200) NULL,
	@IPI_Reais [varchar](200) NULL,
	@Aliq_II [varchar](200) NULL,
	@II_Reais [varchar](200) NULL,
	@LI_PERIODICIDADE [varchar](200) NULL,
	@Valor_Antidump [varchar](200) NULL,
	@Quantidade [varchar](200) NULL,
	@Taxa_siscomex [varchar](200) NULL,
	@FOB_Moeda [varchar](200) NULL,
	@Frete_Moeda_Prepaid [varchar](200) NULL,
	@Frete_Moeda_Collect [varchar](200) NULL,
	@Frete_Moeda [varchar](200) NULL,
	@Valor_CIF_Reais [varchar](200) NULL,
	@Valor_II [varchar](200) NULL,
	@Valor_IPI [varchar](200) NULL,
	@Valor_ICMS [varchar](200) NULL,
	@Valor_PIS [varchar](200) NULL,
	@Valor_Cofins [varchar](200) NULL
	   	  
AS
BEGIN
BEGIN TRANSACTION;
--Exceção(try/CATCH)
--Transação
--sp_help JSON_FComex_Di_Item_BR_Line

	BEGIN TRY
		IF exists(select @Id_Processo from ATL_INT.dbo.JSON_FComex_Di_Item_BR_Line 
		          where Id_Processo = @Id_Processo and Item =@item)
			Begin
				Update
					ATL_INT.dbo.JSON_FComex_Di_Item_BR_Line
				Set					
					[cd_Produto] = @cd_Produto,
					[PesoLiquido] =@PesoLiquido,
					[PesoBruto] =@PesoBruto,
					[Vlr_Item] =@Vlr_Item,
					[FOB_USD] = @FOB_USD,
					[FOB_Reais] =@FOB_Reais,
					[Frete_USD] =@Frete_USD,
					[Frete_Reais] =@Frete_Reais,
					[Seguro_USD] =@Seguro_USD,
					[Seguro_Reais] =@Seguro_Reais,
					[Acrescimos_USD] =@Acrescimos_USD,
					[Acrescimos_Reais] =@Acrescimos_Reais,
					[Aliq_IPI] = @Aliq_IPI,
					[IPI_Reais] =@IPI_Reais,
					[Aliq_II] =@Aliq_II,
					[II_Reais] =@II_Reais,
					[LI_PERIODICIDADE] =@LI_PERIODICIDADE,
					[Valor_Antidump] = @Valor_Antidump,
					[Quantidade] =@Quantidade,
					[Taxa_siscomex] =@Taxa_siscomex,
					[FOB_Moeda] =@FOB_Moeda,
					[Frete_Moeda_Prepaid] = @Frete_Moeda_Prepaid,
					[Frete_Moeda_Collect] =@Frete_Moeda_Collect,
					[Frete_Moeda] =@Frete_Moeda,
					[Valor_CIF_Reais] =@Valor_CIF_Reais,
					[Valor_II] =@Valor_II,
					[Valor_IPI] =@Valor_IPI,
					[Valor_ICMS] =@Valor_ICMS,
					[Valor_PIS] =@Valor_PIS,
					[Valor_Cofins] =@Valor_Cofins
				Where
					Id_Processo = @Id_Processo 
				and Item =@Item
			End
		Else
			BEGIN
				Insert ATL_INT.dbo.JSON_FComex_Di_Item_BR_Line
				(
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
				)
				Values
				(
					@Id_Processo,
					@Item,
					@cd_Produto,
					@PesoLiquido,
					@PesoBruto,
					@Vlr_Item,
					@FOB_USD,
					@FOB_Reais,
					@Frete_USD,
					@Frete_Reais,
					@Seguro_USD,
					@Seguro_Reais,
					@Acrescimos_USD,
					@Acrescimos_Reais,
					@Aliq_IPI,
					@IPI_Reais,
					@Aliq_II,
					@II_Reais,
					@LI_PERIODICIDADE,
					@Valor_Antidump,
					@Quantidade,
					@Taxa_siscomex,
					@FOB_Moeda,
					@Frete_Moeda_Prepaid,
					@Frete_Moeda_Collect,
					@Frete_Moeda,
					@Valor_CIF_Reais,
					@Valor_II,
					@Valor_IPI,
					@Valor_ICMS,
					@Valor_PIS,
					@Valor_Cofins
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
