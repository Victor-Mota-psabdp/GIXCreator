SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pImpMvtoCtaCte_Ins 
(
@StrMachine			VarChar(30), 
@StrTitular			VarChar(30), 
@Site				Char(1), 
@Confirmacao			Bit=0, 
@Duplicados			Bit=0 OUTPUT
)
 AS
	Declare @Prefix 		VarChar(12)
	Declare @Num_Lcto		VarChar(12)
	Declare @Num_Lcto_Trf		VarChar(12)
	Declare @DC_Mov_Transf	Char(1)
	Declare @PerAnterior		Varchar(7) 
	Declare @PerAtual		VaRchar(7)
	Declare @SaldoAnterior		Float 
	Declare @ValorLcto		Float 
	Declare @Num_Lcto_Mov	VarChar(12) 

	Declare @Cd_Banco			Varchar(3)
	Declare @Cd_Agencia			Varchar(5)
	Declare @Num_Cta_Cte			Varchar(20)
	Declare @DC_Mov			Char(1)
	Declare @Dt_Pgto_Rcto_Mov		DateTime
	Declare @Vlr_Doc_Mov			Float
	Declare @Concil_Mov			Char(1)
	Declare @Historico			Varchar(300)

	Begin Transaction 
	Set @Cd_Banco = (Select Cd_Banco From Cta_Cte Where Titular = @StrTitular) 
	Set @Cd_Agencia = (Select Cd_Agencia From Cta_Cte Where Titular = @StrTitular) 
	Set @Num_Cta_Cte = (Select Num_Cta_Cte From Cta_Cte Where Titular = @StrTitular) 
	Set @Concil_Mov = 'N'


	Declare CurTMP Cursor For 
		Select Dt_Lcto, Historico_Lcto, Vlr_Lcto From Tmp_Imp_Bco Where StrMachine = @StrMachine 

	Open CurTMP 
	
	Fetch Next From CurTMP into @Dt_Pgto_Rcto_Mov, @Historico, 	@Vlr_Doc_Mov

	While @@Fetch_Status = 0 
		Begin 
			Set @Prefix = 'M' + @Site 
			Set @Prefix = @Prefix + Cast(year(GetDate()) as VarChar(4)) 
			Set @Prefix = @Prefix + right('0' + Cast(month(GetDate()) as VarChar(2)),2) 
			Set @PerAtual = Right('0' + Cast(month(GetDate()) as VarChar(2)),2) 
			Set @PerAtual = @PerAtual + '/' + Cast(year(GetDate()) as VarChar(4)) 
			
			If Month(GetDate()) = 1 
				Begin 
					Set @PerAnterior = '12/' + Cast((year(GetDate()))- 1 as VarChar(4)) 
				End 
			Else
				Begin 
					Set @PerAnterior = Right('0' + Cast(  ((month(GetDate()))-1) as VarChar(2)),2) 
					Set @PerAnterior = @PerAnterior + '/' + Cast(year(GetDate()) as VarChar(4)) 		
				End 

			Set @Num_Lcto = @Prefix + Right('0000' + Cast((IsNull((Select Max(Right(Num_Lcto_Mov,4 )) From Mvto_Cta_Cte Where Left(Num_Lcto_Mov, 8) = @Prefix), 0) +1) as VarChar(4)),4)
			If @Vlr_Doc_Mov < 0 
				Begin 
					Set @Vlr_Doc_Mov = @Vlr_Doc_Mov * (-1) 
					Set @DC_Mov = 'D' 
				End 
			Else 
				Set @DC_Mov = 'C' 

			-- INSERE MOVIMENTO NA TABELA MVTO_CTA_CTE 
--			If Not Exists(Select Num_Lcto_Mov From Mvto_Cta_Cte Where Cd_Banco = @Cd_Banco and Cd_Agencia = @Cd_Agencia and Num_Cta_Cte = @Num_Cta_Cte and DC_Mov = @DC_Mov and Vlr_Doc_Mov = @Vlr_Doc_Mov and Historico = @Historico) or @Confirmacao = 1
--				Begin 
					Insert into 
						Mvto_Cta_Cte
						(Num_Lcto_Mov, Cd_Banco, Cd_Agencia, Num_Cta_Cte, DC_Mov, Dt_Pgto_Rcto_Mov, Vlr_Doc_Mov,
				         	 	Concil_Mov, Historico)
					Values
						(@Num_Lcto, @Cd_Banco, @Cd_Agencia, @Num_Cta_Cte, @DC_Mov, dbo.StrHoje(@Dt_Pgto_Rcto_Mov), @Vlr_Doc_Mov,
						@Concil_Mov, @Historico) 
					If @@Error <> 0 
						Begin 
							Deallocate curtmp
							RollBack Transaction 
							Return - 1	
						End 
					-- FAZ A VERIFICAÇÃO DA EXISTENCIA DE SALDO DO PERIODO ANTERIOR 
					If Not Exists(Select * From Saldo_Cta_Cte Where Cd_Banco = @Cd_Banco and Cd_Agencia = @Cd_Agencia  and  Num_Cta_Cte = @Num_Cta_Cte  and  Data_Ref = @PerAnterior)
						Begin  
							Insert Into 
								Saldo_Cta_Cte(Cd_Banco, Cd_Agencia, Num_Cta_Cte, Data_Ref, Vlr_Saldo)
							Values
								(@Cd_Banco, @Cd_Agencia, @Num_Cta_Cte, @PerAnterior, 0)
							Set @SaldoAnterior = 0 
							If @@Error <> 0 
								Begin 
									Deallocate curtmp
									RollBack Transaction 
									Return - 2
								End  
						End 
					Else
						Set @SaldoAnterior = (Select Vlr_Saldo From Saldo_Cta_Cte Where Cd_Banco = @Cd_Banco and Cd_Agencia = @Cd_Agencia  and  Num_Cta_Cte = @Num_Cta_Cte  and  Data_Ref = @PerAnterior)
				
					-- FAZ A TRANSFORMAÇÃO DO VALOR DO LANCAMENTO
					If @DC_Mov = "C" 
						Set @ValorLcto = @Vlr_Doc_Mov
					Else
						Set @ValorLcto = - @Vlr_Doc_Mov
					
					-- FAZ A ATUALIZAÇÃO DO SALDO ATUAL 

					If Not Exists(Select * From Saldo_Cta_Cte Where Cd_Banco = @Cd_Banco and Cd_Agencia = @Cd_Agencia  and  Num_Cta_Cte = @Num_Cta_Cte  and  Data_Ref = @PerAtual)
						Insert Into 
							Saldo_Cta_Cte(Cd_Banco, Cd_Agencia, Num_Cta_Cte, Data_Ref, Vlr_Saldo)
						Values
							(@Cd_Banco, @Cd_Agencia, @Num_Cta_Cte, @PerAtual, @SaldoAnterior + @ValorLcto)
					Else
						Update 
							Saldo_Cta_Cte
						Set 
							Vlr_Saldo = (Select Vlr_Saldo From Saldo_Cta_Cte Where Cd_Banco = @Cd_Banco and Cd_Agencia = @Cd_Agencia  and  Num_Cta_Cte = @Num_Cta_Cte  and  Data_Ref = @PerAtual) + @ValorLcto
						Where 
							Cd_Banco = @Cd_Banco and 
							Cd_Agencia = @Cd_Agencia  and  
							Num_Cta_Cte = @Num_Cta_Cte  and  
							Data_Ref = @PerAtual
					If @@Error <> 0 
						Begin 
							Deallocate curtmp
							RollBack Transaction
							Return -3 
						End 
--				End 
--			Else
--				Begin 
--					Set @Duplicados = 1 
--					Update 
------						Tmp_imp_bco
--					Set 
--						Duplic_Lcto = 1 
--					Where 
--						Dt_Lcto = @Dt_Pgto_Rcto_Mov and
--						Historico_Lcto = @Historico and 
--						Vlr_Lcto = @Vlr_Doc_Mov and 
--						StrMachine = @StrMachine
--					If @@Error <> 0 
--						Begin 
--							Deallocate curtmp
--							RollBack Transaction
--							Return -4
--						End 
--
--				End 
			Fetch Next From CurTMP into @Dt_Pgto_Rcto_Mov, @Historico, 	@Vlr_Doc_Mov
		End
		Delete Tmp_Imp_Bco Where Duplic_Lcto = 0  or Confirm_Duplic = 1
		If @@Error <> 0 
			Begin
				Deallocate curtmp 
				RollBack Transaction
				Return -5
			End 
		Deallocate curtmp
		Commit Transaction 
		Return 1
GO
