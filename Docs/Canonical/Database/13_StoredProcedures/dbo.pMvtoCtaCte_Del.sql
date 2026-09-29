SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMvtoCtaCte_Del    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMvtoCtaCte_Del
(
@Num_Lcto_Mov		VarChar(12)
)
 AS
	Declare @DC_Mov_Transf	Char(1)
	Declare @PerAnterior		Varchar(7) 
	Declare @PerAtual		VaRchar(7)
	Declare @SaldoAnterior		Float 
	Declare @ValorLcto		Float 
	Declare @Cd_Banco		Varchar(3)
	Declare @Cd_Agencia		Varchar(5) 
	Declare @Num_Cta_Cte		Varchar(20) 
	Declare @DC_Mov		Char(1)
	Declare @Vlr_Doc_Mov		Float	
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
	Set  @ValorLcto	= (Select Vlr_Doc_Mov From Mvto_Cta_Cte Where Num_Lcto_Mov = @Num_Lcto_Mov)
	Set  @Cd_Banco = (Select Cd_Banco From Mvto_Cta_Cte Where Num_Lcto_Mov = @Num_Lcto_Mov)
	Set  @Cd_Agencia = (Select Cd_Agencia From Mvto_Cta_Cte Where Num_Lcto_Mov = @Num_Lcto_Mov)
	Set  @Num_Cta_Cte = (Select Num_Cta_Cte From Mvto_Cta_Cte Where Num_Lcto_Mov = @Num_Lcto_Mov)
	Set  @DC_Mov = (Select DC_Mov From Mvto_Cta_Cte Where Num_Lcto_Mov = @Num_Lcto_Mov)
	Set  @Vlr_Doc_Mov = (Select Vlr_Doc_Mov From Mvto_Cta_Cte Where Num_Lcto_Mov = @Num_Lcto_Mov)
	-- EXCLUI MOVIMENTO DA CONTA CORRENTE 
	Delete From
		Mvto_Cta_Cte
	Where
		Num_Lcto_Mov = @Num_Lcto_Mov
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
		Set @SaldoAnterior = (Select Vlr_Saldo From Saldo_Cta_Cte Where Cd_Banco = @Cd_Banco and Cd_Agencia = @Cd_Agencia  and  Num_Cta_Cte = Num_Cta_Cte  and  Data_Ref = @PerAnterior)
		
	
	-- FAZ A ATUALIZAÇÃO DO SALDO ATUAL 
	If Not Exists(Select * From Saldo_Cta_Cte Where Cd_Banco = @Cd_Banco and Cd_Agencia = @Cd_Agencia  and  Num_Cta_Cte = @Num_Cta_Cte  and  Data_Ref = @PerAtual)
		Insert Into 
			Saldo_Cta_Cte(Cd_Banco, Cd_Agencia, Num_Cta_Cte, Data_Ref, Vlr_Saldo)
		Values
			(@Cd_Banco, @Cd_Agencia, @Num_Cta_Cte, @PerAnterior, @SaldoAnterior + @ValorLcto)
	Else
		Update 
			Saldo_Cta_Cte
		Set 
			Vlr_Saldo = (Select Vlr_Saldo From Saldo_Cta_Cte Where Cd_Banco = @Cd_Banco and Cd_Agencia = @Cd_Agencia  and  Num_Cta_Cte = @Num_Cta_Cte  and  Data_Ref = @PerAtual) - @Vlr_Doc_Mov
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
	Commit Transaction 
	Return 1



GO
