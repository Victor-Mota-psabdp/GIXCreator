SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pPgtoRec_Ins]
(
@Site				Char(1),
@DC				char(1),
@Dt_Pgto_Rcto			varchar(10), 
@Cd_Banco			varchar(3),
@Cd_Agencia			varchar(5),
@Num_Cta_Cte			varchar(20),
@Forma_Pgto_Rcto		varchar(10),
@Num_Doc			varchar(10),
@Vlr_Doc			Float, 
@Cd_Pes			Varchar(10),
@Dt_Vcto			varchar(10),
@Concil			char(1),
@Cta_Cte_Cliente			VarChar(50)='', 
@Ck_Doctos			char(1), 
@Num_Lcto			VarChar(12) = '' OUTPUT	
)
 AS
	Declare @Prefix 		VarChar(12)
	Declare @PerCont	VarChar(7)
	
	Set @Prefix = 'L' + @Site 
	Set @Prefix = @Prefix + Cast(year(GetDate()) as VarChar(4)) 
	Set @Prefix = @Prefix + right('0' + Cast(month(GetDate()) as VarChar(2)),2) 
	Begin Transaction
	--Set @Dt_Pgto_Rcto = convert(varchar(10), getdate(), 103)
	Set @Num_Lcto = @Prefix + Right('0000' + Cast((IsNull((Select Max(Right(Num_Lcto,4 )) From Pgto_Rcto Where Left(Num_Lcto, 8) = @Prefix), 0) +1) as VarChar(4)),4)



	Set @PerCont = (Select pkcmes From param_aekcontabil) 

	If convert(Datetime, @Dt_Pgto_Rcto, 105) < dbo.fFirstDayMonth(@PerCont) 
		Begin 
			Rollback Transaction 
			Return -77 
		End 

	Insert into 
		Pgto_Rcto
		(Num_Lcto, Cd_Banco, Cd_Agencia, Num_Cta_Cte, DC, Dt_Pgto_Rcto, Forma_Pgto_Rcto, Num_Doc, Vlr_Doc, Cd_Pes, Dt_Vcto, Concil, Cta_Cte_Cliente, Ck_Doctos )
	Values 
		(@Num_Lcto, @Cd_Banco, @Cd_Agencia, @Num_Cta_Cte, @DC, @Dt_Pgto_Rcto, @Forma_Pgto_Rcto, @Num_Doc, @Vlr_Doc, @Cd_Pes, @Dt_Vcto, @Concil, @Cta_Cte_Cliente, @Ck_Doctos)
	If @@Error = 0 
		Begin
			Commit Transaction 
			Return 1 
		End
	Else
		Begin 
			RollBack  Transaction 
			Return -1 
		End

GO
