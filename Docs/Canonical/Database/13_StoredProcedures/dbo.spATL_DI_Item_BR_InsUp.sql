SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_DI_Item_BR_InsUp]

			@Num_Proc			Varchar(16),
			@Item				Int,
			@cd_Produto			Int,
			@PesoLiquido		float,
			@PesoBruto			float,
			@Vlr_Item			Float,
			@FOB_USD			float,
			@FOB_Reais			float,
			@Frete_USD			float,
			@Frete_Reais		float,
			@Seguro_USD			float,
			@Seguro_Reais		float,
			@Acrescimos_USD		float,
			@Acrescimos_Reais	float,
			@Aliq_IPI			float,
			@Aliq_II			float,
			@IPI_Reais          float,
			@II_Reais           float,
			@LI_PERIODICIDADE	Int,
			@VALOR_ANTIDUMP		float,
			@QUANTIDADE			float,
			@TAXASISCOMEX				float,
			@VALORFOBMOEDA				float,
			@VALORFRETEMOEDAPREPAID		float,
			@VALORFRETEMOEDACOLLECT		float,
			@VALORFRETEMOEDA			float,
			@VALORCIFREAIS				float,
			@VALORIIRECOLHER			float,
			@VALORIPIRECOLHER			float,
			@VALORICMS					float,
			@VALORPISPASEPARECOLHER		float,
			@VALORCOFINSARECOLHER		float

AS

Begin
	if not exists(select * from DI_ITEM_BR with(nolock)  where num_proc=@Num_Proc and item=@Item)
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
							Item=@ITEM and num_Proc=@Num_PRoc

			End

END

GO
