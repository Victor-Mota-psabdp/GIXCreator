SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pPgtoRctoDivDet_Del
(
@Num_Lcto_Div		varchar(12),
@Cd_Cta_Ctb			varchar(13),
@Cd_Centro_Custo		varchar(5),
@DC_Item			char(1)
)
 AS
	Declare @Dt_Pgto 	VarChar(10) 
	Declare @PerCont	VarChar(7)

	Set @PerCont = (Select pkcmes From param_aekcontabil) 
	Set @Dt_Pgto = (Select dt_pgto_rcto_div  From Pgto_Rcto_Div Where Num_Lcto_Div = @Num_Lcto_Div)

--	If convert(Datetime, @Dt_Pgto, 105) < dbo.fLastDayMonth(@PerCont) 
--		Return - 77 
	


	Delete 
		Pgto_Rcto_Div_Det
	Where 
		Num_Lcto_Div = @Num_Lcto_Div and 
		Cd_Centro_Custo = @Cd_Centro_Custo and 
		Cd_Cta_Ctb = @Cd_Cta_Ctb and 
		DC_Item = @DC_Item
	Return @@RowCount
GO
