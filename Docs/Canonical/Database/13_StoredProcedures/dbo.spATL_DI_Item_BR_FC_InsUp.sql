SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_DI_Item_BR_FC_InsUp]

			@Num_Proc			Varchar(16),
			@Item				Int,
			@cd_Produto			Int,
			@PesoLiquido		Decimal(18,2),
			@PesoBruto			Decimal(18,2),
			@Vlr_Item			Decimal(18,6),
			@FOB_USD			Decimal(18,2),
			@FOB_Reais			Decimal(18,2),
			@Frete_USD			Decimal(18,2),
			@Frete_Reais		Decimal(18,2),
			@Seguro_USD			Decimal(18,2),
			@Seguro_Reais		Decimal(18,2),
			@Acrescimos_USD		Decimal(18,2),
			@Acrescimos_Reais	Decimal(18,2),
			@Aliq_IPI			Decimal(18,2),
			@Aliq_II			Decimal(18,2),
			@IPI_Reais          Decimal(18,2),
			@II_Reais           Decimal(18,2),
			@LI_PERIODICIDADE	Int,
			@VALOR_ANTIDUMP		Decimal(18,2),
			@QUANTIDADE			Decimal(18,2),
			@TAXASISCOMEX				Decimal(18,2),
			@VALORFOBMOEDA				Decimal(18,2),
			@VALORFRETEMOEDAPREPAID		Decimal(18,2),
			@VALORFRETEMOEDACOLLECT		Decimal(18,2),
			@VALORFRETEMOEDA			Decimal(18,2),
			@VALORCIFREAIS				Decimal(18,2),
			@VALORIIRECOLHER			Decimal(18,2),
			@VALORIPIRECOLHER			Decimal(18,2),
			@VALORICMS					Decimal(18,2),
			@VALORPISPASEPARECOLHER		Decimal(18,2),
			@VALORCOFINSARECOLHER		Decimal(18,2)

AS

Begin
	  IF not EXISTS(SELECT  Item FROM DI_ITEM_BR 
				    Where item=@item 
					and cd_produto=@cd_produto
					and Num_Proc = @Num_Proc)
		Begin
			Insert DI_ITEM_BR
				(
					Num_Proc,
					Item,
					cd_Produto,
					PesoLiquido,
					PesoBruto,
					Vlr_Item,
					FOB_USD,
					FOB_Reais,
					Frete_USD,
					Frete_Reais,
					Seguro_USD,
					Seguro_Reais,
					Acrescimos_USD,
					Acrescimos_Reais,
					Aliq_IPI,
					IPI_Reais,
					Aliq_II,
					II_Reais,
					LI_PERIODICIDADE,
					VALOR_ANTIDUMP,
					Quantidade,
					Taxa_siscomex,
					FOB_Moeda,
					Frete_Moeda_Prepaid,
					Frete_Moeda_Collect,
					Frete_Moeda,
					Valor_CIF_Reais,
					Valor_II,
					Valor_IPI,
					Valor_ICMS,
					Valor_PIS,
					Valor_Cofins,
					Dt_Ins
				)
			Values

				(
					@Num_Proc,
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
					@VALOR_ANTIDUMP,
					@QUANTIDADE,
					@TAXASISCOMEX,
					@VALORFOBMOEDA,
					@VALORFRETEMOEDAPREPAID,
					@VALORFRETEMOEDACOLLECT,
					@VALORFRETEMOEDA,
					@VALORCIFREAIS,
					@VALORIIRECOLHER,
					@VALORIPIRECOLHER,
					@VALORICMS,
					@VALORPISPASEPARECOLHER,
					@VALORCOFINSARECOLHER,
					GETDATE()					
					
				)
			END
		ELSE
			Begin
				Update 
					DI_ITEM_BR
						SET
							cd_Produto=@cd_Produto,
							PesoLiquido=@PesoLiquido,
							PesoBruto=@PesoBruto,
							Vlr_Item=@Vlr_Item,
							FOB_USD=@FOB_USD,
							FOB_Reais=@FOB_Reais,
							Frete_USD=@Frete_USD,
							Frete_Reais=@Frete_Reais,
							Seguro_USD=@Seguro_USD,
							Seguro_Reais=@Seguro_Reais,
							Acrescimos_USD=@Acrescimos_USD,
							Acrescimos_Reais=@Acrescimos_Reais,
							Aliq_IPI=@Aliq_IPI,
							IPI_Reais =@IPI_Reais,
							Aliq_II=@Aliq_II,
							II_Reais=@II_Reais,
							LI_PERIODICIDADE=@LI_PERIODICIDADE,
							VALOR_ANTIDUMP=@VALOR_ANTIDUMP,
							Quantidade=@QUANTIDADE,
							Taxa_siscomex=@TAXASISCOMEX,
							FOB_Moeda=@VALORFOBMOEDA,
							Frete_Moeda_Prepaid=@VALORFRETEMOEDAPREPAID,
							Frete_Moeda_Collect=@VALORFRETEMOEDACOLLECT,
							Frete_Moeda=@VALORFRETEMOEDA,
							Valor_CIF_Reais=@VALORCIFREAIS,
							Valor_II=@VALORIIRECOLHER,
							Valor_IPI=@VALORIPIRECOLHER,
							Valor_ICMS=@VALORICMS,
							Valor_PIS=@VALORPISPASEPARECOLHER,
							Valor_Cofins=@VALORCOFINSARECOLHER	
								
						Where
							Item=@ITEM 
							and num_Proc=@Num_PRoc
							and  cd_Produto = @cd_Produto
			End

END
GO
