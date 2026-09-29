SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.pPgtoRctoDiv_Ins    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPgtoRctoDiv_Ins
(
@Cd_Banco				Varchar(3),
@Cd_Agencia				Varchar(5), 
@Num_Cta_Cte				Varchar(20),
@DC_Div				Char(1), 
@Dt_Pgto_Rcto_Div			Varchar(10),
@Forma_Pgto_Rcto_Div			Varchar(10),
@Num_Doc_Div			Varchar(10),
@Vlr_Doc_Div				Float,
@Cd_Pes				Varchar(10), 
@Dt_Vcto_Div				Varchar(10),
@Concil_Div				Char(1),
@Site					Char(1), 
@Cta_Cte_Cliente_Div			VarChar(50)=Null,
@Num_Lcto_Div			Varchar(12)='' OUTPUT,
@Ck_Doctos				Char(1)
)
 AS
	Declare @Prefix 		VarChar(12)
	Declare @PerAtual		VaRchar(7)
	Declare @PerAnterior		VaRchar(7)

	Declare @PerCont	VarChar(7)

	Set @Prefix = 'D' + @Site 
	Set @Prefix = @Prefix + Cast(year(GetDate()) as VarChar(4)) 
	Set @Prefix = @Prefix + right('0' + Cast(month(GetDate()) as VarChar(2)),2) 
	Set @PerAtual = Right('0' + Cast(month(GetDate()) as VarChar(2)),2) 
	Set @PerAtual = @PerAtual + '/' + Cast(year(GetDate()) as VarChar(4)) 
	Set @PerCont = (Select pkcmes From param_aekcontabil) 	

	If convert(Datetime, @Dt_Pgto_Rcto_Div, 105) < dbo.fFirstDayMonth(@PerCont) 
		Return -77 

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
	Set @Num_Lcto_Div  = @Prefix + Right('0000' + Cast((IsNull((Select Max(Right(Num_Lcto_Div,4 )) From Pgto_Rcto_Div Where Left(Num_Lcto_Div, 8) = @Prefix), 0) +1) as VarChar(4)),4)
	Insert Into 
		Pgto_Rcto_Div
		(Num_Lcto_Div, Cd_Banco, Cd_Agencia, Num_Cta_Cte, DC_Div, Dt_Pgto_Rcto_Div, Forma_Pgto_Rcto_Div, Num_Doc_Div,
		 Vlr_Doc_Div, Cd_Pes, Dt_Vcto_Div, Concil_Div, Cta_Cte_Cliente_Div, Ck_Doctos) 
	Values 
		(@Num_Lcto_Div, @Cd_Banco, @Cd_Agencia, @Num_Cta_Cte, @DC_Div, @Dt_Pgto_Rcto_Div, @Forma_Pgto_Rcto_Div,
		 @Num_Doc_Div, @Vlr_Doc_Div, @Cd_Pes, @Dt_Vcto_Div, @Concil_Div, @Cta_Cte_Cliente_Div, @Ck_Doctos) 
	
	If @@RowCount = 0 
		Begin 
			RollBack Transaction 
			Return - 1	
		End 
	Else
		Begin 
			Commit Transaction 
			Return 1 
		End
GO
