SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pRateioPgtosDiversos_Ins 
(
@Num_Lcto		VarChar(14), 
@Valor_Lcto		Decimal(12,2) ,
@CtaCtb		VarChar(13), 
@CDForma		Char(1), 
@CompHist		VarChar(2000),
@DC			Char(1) 
)
AS
	Declare @Total 		Decimal(8,2) 
	Declare @Total_Parcial	Decimal(8,2) 
	Declare @Centro	Varchar(5) 
	Declare @Parte 		Decimal(8,2) 
	Declare @ContParte 		Decimal(8,2) 
	Declare @Parcela	Decimal(10,2) 
	Declare @Parcelas	Decimal(10,2) 
	Declare @Site		Char(1) 

	
	
	Set @ContParte = 0 
	Set @Parcelas = 0
	If @CDForma = '0'
		Set @Total = IsNull((Select sum(particip) total from Centro_Custo_Site), 0) 
	else
		Set @Total = IsNull((Select sum(particip) total from Centro_Custo_Site Where Site = @CDforma),0) 

	Print @Total

	if @Total = 0 
		return -1 

	else
		Begin 
			Begin Transaction 
			Delete from pgto_rcto_div_det Where Num_Lcto_Div = @Num_Lcto and Dc_Item = 'D'
			If @@Error <> 0 
				Begin 
					Rollback Transaction 
					Return -2 
				End 			


			If @CDForma = '0'			
				Begin 
					Declare CurRateio Cursor For 
					Select cd_centro_custo, Sum(particip)  particip from Centro_Custo_Site group by cd_centro_custo
				End 
			Else
				Begin 
					Declare CurRateio Cursor For 
					Select cd_centro_custo, particip  from Centro_Custo_Site Where Site = @CDForma 
				End 

			Open CurRateio 
			Fetch Next From CurRateio into @Centro, @parte 

			While @@Fetch_Status = 0 
				Begin 
					Print @Centro
					Print @parte
					Set @ContParte = @ContParte + @Parte  
					If @ContParte = @Total 
						Begin 
							Set @Parcela = @Valor_Lcto - @Parcelas 
						End  
					Else
						Begin 
							Set @Parcela = (@Parte / @total) * @Valor_Lcto
						End 
					
					
					Insert Into pgto_rcto_div_det values (@Num_Lcto, @CtaCtb, @Centro, @Dc, @Parcela, 614, @CompHist,  null, null )
					If @@Error <> 0 
						Begin 
							Close CurRateio 
							Deallocate CurRateio 
							Rollback Transaction 
							Return -3
						End 			
		

					Set @Parcelas	 = @Parcelas + @Parcela 
					Print @Parcelas
					Fetch Next From CurRateio into @Centro, @parte 
				End 
			Close CurRateio 
			Deallocate CurRateio
	
			Commit Transaction 
			Return 1
		End
GO
