SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.pPgtoRctoDiv_Del    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPgtoRctoDiv_Del
(
@Num_Lcto_Div			Varchar(12)
)
 AS
	Declare @Dt_Pgto 	VarChar(10) 
	Declare @PerCont	VarChar(7)

	Set @PerCont = (Select pkcmes From param_aekcontabil) 
	Set @Dt_Pgto = (Select dt_pgto_rcto_div  From Pgto_Rcto_Div Where Num_Lcto_Div = @Num_Lcto_Div)

	--If convert(Datetime, @Dt_Pgto, 105) < dbo.fLastDayMonth(@PerCont) 
	--	Return -77 
	--Else
	--	Begin 
			Delete 
				Pgto_Rcto_Div
			Where 
				Num_Lcto_Div = @Num_Lcto_Div
			Return @@RowCount
	--	End
GO
