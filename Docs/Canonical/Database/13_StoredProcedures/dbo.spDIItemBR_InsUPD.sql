SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spDIItemBR_InsUPD]

			@Num_Proc			Varchar(16),
			@Item				Int,
			@cd_Produto			Varchar(50),
			@PesoLiquido		Decimal(10,2),
			@PesoBruto			Decimal(10,2),
			@Vlr_Item			Float,
			@FOB_USD			Decimal(10,2),
			@FOB_Reais			Decimal(10,2),
			@Frete_USD			Decimal(10,2),
			@Frete_Reais		Decimal(10,2),
			@Seguro_USD			Decimal(10,2),
			@Seguro_Reais		Decimal(10,2),
			@Acrescimos_USD		Decimal(10,2),
			@Acrescimos_Reais	Decimal(10,2),
			@Aliq_IPI			Decimal(10,2),
			@Aliq_II			Decimal(10,2),
			@LI_PERIODICIDADE	Int,
			@VALOR_ANTIDUMP		Decimal(10,2),
			@QUANTIDADE			Decimal(10,2),
			@TAXASISCOMEX				Decimal(10,2),
			@VALORFOBMOEDA				Decimal(10,2),
			@VALORFRETEMOEDAPREPAID		Decimal(10,2),
			@VALORFRETEMOEDACOLLECT		Decimal(10,2),
			@VALORFRETEMOEDA			Decimal(10,2),
			@VALORCIFREAIS				Decimal(10,2),
			@VALORIIRECOLHER			Decimal(10,2),
			@VALORIPIRECOLHER			Decimal(10,2),
			@VALORICMS					Decimal(10,2),
			@VALORPISPASEPARECOLHER		Decimal(10,2),
			@VALORCOFINSARECOLHER		Decimal(10,2)

AS

Begin
	Declare @Cd_Prod	Int

	Set @Cd_Prod = (select top 1 cd_prod from pedido_ship with(nolock)  Join PRoduto_Cliente PC with(nolock)  on cd_produto=cd_prod where num_proc=@Num_Proc and right('000000000000000000' + cd_proc_cliente,18)=right('000000000000000000' +@cd_produto,18))

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
					Aliq_II,
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
					@cd_Prod,
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
					@Aliq_II,
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
							cd_Produto=@cd_Prod,
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
							Aliq_II=@Aliq_II,
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
