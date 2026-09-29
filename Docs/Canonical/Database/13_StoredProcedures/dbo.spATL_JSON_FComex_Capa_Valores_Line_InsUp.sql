SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--11-04-2026 - antonio -  incluir  a paginação para segregar a procura por itens 
-- procurar depois somente o que tem que incluir sem varrer os todos os jobs 
CREATE procedure [dbo].[spATL_JSON_FComex_Capa_Valores_Line_InsUp]

    @Id_Processo [bigint],
	@Fob_Usd [varchar](200) NULL,
	@Cif_Usd [varchar](200) NULL,
	@Frete_Usd [varchar](200) NULL,
	@Fob_Reais [varchar](200) NULL,
	@Acrescimos_Reais [varchar](200) NULL,
	@Seguro_Reais [varchar](200) NULL,
	@Frete_Reais [varchar](200) NULL,
	@Moeda_Frete [varchar](200) NULL,
	@Moeda_CFR [varchar](200) NULL,
	@Cif_Reais [varchar](200) NULL,
	@ItemsTotalPages [int],
	@ItemsTotalQty [int],
	@ItemsTotalIncluded [int]
AS
BEGIN
BEGIN TRANSACTION;
--Exceção(try/CATCH)
--Transação
--sp_help JSON_FComex_CapaValores_Line

	BEGIN TRY
		IF exists(select @Id_Processo from ATL_INT.dbo.JSON_FComex_Capa_Valores_Line 
		          where Id_Processo = @Id_Processo)
			Begin
				Update
					ATL_INT.dbo.JSON_FComex_Capa_Valores_Line
                Set
					[Fob_Usd] = @Fob_Usd,
					[Cif_Usd] = @Cif_Usd,
					[Frete_Usd] = @Frete_Usd,
					[Fob_Reais] = @Fob_Reais,
					[Acrescimos_Reais] = @Acrescimos_Reais,
					[Seguro_Reais] = @Seguro_Reais,
					[Frete_Reais] = @Frete_Reais,
					[Moeda_Frete] = @Moeda_Frete,
					[Moeda_CFR] = @Moeda_CFR,
					[Cif_Reais] = @Cif_Reais,
					[ItemsTotalPages] =	@ItemsTotalPages,
					[ItemsTotalQty] = @ItemsTotalQty,
					[ItemsTotalIncluded] = @ItemsTotalIncluded
				Where
					Id_Processo = @Id_Processo 	
			End
		Else
			BEGIN
				Insert ATL_INT.dbo.JSON_FComex_Capa_Valores_Line
				(
                    [Id_Processo], 
					[Fob_Usd],
					[Cif_Usd],
					[Frete_Usd],
					[Fob_Reais],
					[Acrescimos_Reais],
					[Seguro_Reais],
					[Frete_Reais],
					[Moeda_Frete],
					[Moeda_CFR],
					[Cif_Reais],
					[ItemsTotalPages], 
					[ItemsTotalQty],
					[ItemsTotalIncluded]
				)
				Values
				(
				     @Id_Processo,
					 @Fob_Usd,
					 @Cif_Usd,
					 @Frete_Usd,
					 @Fob_Reais,
					 @Acrescimos_Reais,
					 @Seguro_Reais,
					 @Frete_Reais,
					 @Moeda_Frete,
					 @Moeda_CFR,
					 @Cif_Reais,
					 @ItemsTotalPages,
					 @ItemsTotalQty,
					 @ItemsTotalIncluded
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
