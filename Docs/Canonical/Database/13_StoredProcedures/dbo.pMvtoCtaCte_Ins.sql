SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.pMvtoCtaCte_Ins    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE [dbo].[pMvtoCtaCte_Ins] 
(
@Site				Char(1), 
@Cd_Banco			Varchar(3),
@Cd_Agencia			Varchar(5), 
@Num_Cta_Cte			Varchar(20), 
@DC_Mov			Char(1), 
@Dt_Pgto_Rcto_Mov		Varchar(10),
--@Cd_Tp_Doc			Varchar(3),
--@Num_Doc_Mov		Varchar(10),
@Historico			VarChar(300), 
@Vlr_Doc_Mov			Float, 
@Concil_Mov			Char(1), 
@Dt_Ctb_Mvto			Varchar(10)=Null, 
@Cd_Banco_Transf		Varchar(3)='',
@Cd_Agencia_Transf		Varchar(5)='', 
@Num_Cta_Cte_Transf		Varchar(20)='',
@Num_Lcto_Mov		VarChar(12) = '' OUTPUT
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
	Begin Transaction 
	Print @PerAtual
	Print @PerAnterior
	Set @Num_Lcto = @Prefix + Right('0000' + Cast((IsNull((Select Max(Right(Num_Lcto_Mov,4 )) From Mvto_Cta_Cte Where Left(Num_Lcto_Mov, 8) = @Prefix), 0) +1) as VarChar(4)),4)
	Set @Num_Lcto_Trf = @Prefix + Right('0000' + Cast((IsNull((Select Max(Right(Num_Lcto_Mov,4 )) From Mvto_Cta_Cte Where Left(Num_Lcto_Mov, 8) = @Prefix), 0) +2) as VarChar(4)),4)
	-- INSERE MOVIMENTO NA TABELA MVTO_CTA_CTE 
	Insert into 
		Mvto_Cta_Cte
--		(Num_Lcto_Mov, Cd_Banco, Cd_Agencia, Num_Cta_Cte, DC_Mov, Dt_Pgto_Rcto_Mov, Cd_Tp_Doc, Num_Doc_Mov, Vlr_Doc_Mov,
--         	 	Concil_Mov, Dt_Ctb_Mvto )
		(Num_Lcto_Mov, Cd_Banco, Cd_Agencia, Num_Cta_Cte, DC_Mov, Dt_Pgto_Rcto_Mov, Vlr_Doc_Mov,
         	 	Concil_Mov, Dt_Ctb_Mvto, Historico )
	Values
--		(@Num_Lcto, @Cd_Banco, @Cd_Agencia, @Num_Cta_Cte, @DC_Mov, @Dt_Pgto_Rcto_Mov, @Cd_Tp_Doc, @Num_Doc_Mov, @Vlr_Doc_Mov,
--		@Concil_Mov, @Dt_Ctb_Mvto) 
		(@Num_Lcto, @Cd_Banco, @Cd_Agencia, @Num_Cta_Cte, @DC_Mov, @Dt_Pgto_Rcto_Mov, @Vlr_Doc_Mov,
		@Concil_Mov, @Dt_Ctb_Mvto, @Historico) 
	If @@Error <> 0 
		Begin 
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
					RollBack Transaction 
					Return - 2
				End  
		End 
	Else
		Set @SaldoAnterior =(Select Vlr_Saldo From Saldo_Cta_Cte Where Cd_Banco = @Cd_Banco and Cd_Agencia = @Cd_Agencia  and  Num_Cta_Cte = @Num_Cta_Cte  and  Data_Ref = @PerAnterior)
		
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
			RollBack Transaction
			Return -3 
		End 
	-- VERIFICA SE MOVIMENTO É DE TRANSFERÊNCIA E 
	-- * FAZ O LANCAMENTO INVERSO 
	-- * INSERE CONCILIAÇÃO 
	
--	If @Cd_Banco_Transf <> '' 		
--		Begin 
--			If @DC_Mov = 'D'
--				Set @DC_Mov_Transf = 'C'
--			Else 
--				Set @DC_Mov_Transf = 'D'
--			Insert into 
--				Mvto_Cta_Cte
--				(Num_Lcto_Mov, Cd_Banco, Cd_Agencia, Num_Cta_Cte, DC_Mov, Dt_Pgto_Rcto_Mov, Cd_Tp_Doc, Num_Doc_Mov, Vlr_Doc_Mov,
--				 Concil_Mov,  Dt_Ctb_Mvto )
--			Values
--				(@Num_Lcto_Trf, @Cd_Banco_Transf, @Cd_Agencia_Transf, @Num_Cta_Cte_Transf, @DC_Mov_Transf, @Dt_Pgto_Rcto_Mov, @Cd_Tp_Doc, @Num_Doc_Mov, @Vlr_Doc_Mov,
--				 @Concil_Mov, @Dt_Ctb_Mvto)
--			If @@Error <> 0 
--				Begin 
--					RollBack Transaction
--					Return - 4 
--				End 
--			-- FAZ A VERIFICAÇÃO DA EXISTENCIA DE SALDO DO PERIODO ANTERIOR 
--			If Not Exists(Select * From Saldo_Cta_Cte Where Cd_Banco = @Cd_Banco_Transf and Cd_Agencia = @Cd_Agencia_Transf  and  Num_Cta_Cte = @Num_Cta_Cte_Transf  and  Data_Ref = @PerAnterior)
--				Begin  
--					Insert Into 
--						Saldo_Cta_Cte(Cd_Banco, Cd_Agencia, Num_Cta_Cte, Data_Ref, Vlr_Saldo)
----					Values
--						(@Cd_Banco_Transf, @Cd_Agencia_Transf, @Num_Cta_Cte_Transf, @PerAnterior, 0)
--					Set @SaldoAnterior = 0 
--					If @@Error <> 0 
--						Begin 
--							RollBack Transaction 
--							Return - 5
--						End  
--				End 
--			Else
--				Set @SaldoAnterior = (Select Vlr_Saldo From Saldo_Cta_Cte Where Cd_Banco = @Cd_Banco_Transf and Cd_Agencia = @Cd_Agencia_Transf  and  Num_Cta_Cte = @Num_Cta_Cte_Transf  and  Data_Ref = @PerAnterior)
--			-- FAZ A TRANSFORMAÇÃO DO VALOR DO LANCAMENTO
--			If @DC_Mov_Transf = 'C' 
--				Set @ValorLcto = @Vlr_Doc_Mov
--			Else
--				Set @ValorLcto = - @Vlr_Doc_Mov
--	
--			-- FAZ A ATUALIZAÇÃO DO SALDO ATUAL 
--		
--			If Not Exists(Select * From Saldo_Cta_Cte Where Cd_Banco = @Cd_Banco_Transf and Cd_Agencia = @Cd_Agencia_Transf  and  Num_Cta_Cte = @Num_Cta_Cte_Transf  and  Data_Ref = @PerAtual)
--				Insert Into 
--					Saldo_Cta_Cte(Cd_Banco, Cd_Agencia, Num_Cta_Cte, Data_Ref, Vlr_Saldo)
--				Values
--					(@Cd_Banco_Transf, @Cd_Agencia_Transf, @Num_Cta_Cte_Transf, @PerAnterior, @SaldoAnterior + @ValorLcto)
--			Else
--				Update 
--					Saldo_Cta_Cte
--				Set 
--					Vlr_Saldo = (Select Vlr_Saldo From Saldo_Cta_Cte Where Cd_Banco = @Cd_Banco_Transf and Cd_Agencia  = @Cd_Agencia_Transf  and  Num_Cta_Cte = @Num_Cta_Cte_Transf  and  Data_Ref = @PerAtual) + @ValorLcto
--				Where 
--					Cd_Banco = @Cd_Banco_Transf and 
--					Cd_Agencia = @Cd_Agencia_Transf  and  
--					Num_Cta_Cte = @Num_Cta_Cte_Transf  and  
--					Data_Ref = @PerAtual
--			If @@Error <> 0 
--				Begin 
--					RollBack Transaction
--					Return - 6
--				End 
--			-- INSERE CONCILIAÇÃO
--			Exec pRecCtaCte_Ins @Num_Lcto, @Num_Lcto_Trf
--			If @@Error <> 0 
--				Begin 
--					RollBack Transaction
--					Return - 7
--				End 
--		End
	Commit Transaction 
	Set  @Num_Lcto_Mov = @Num_Lcto
	Return 1

GO
