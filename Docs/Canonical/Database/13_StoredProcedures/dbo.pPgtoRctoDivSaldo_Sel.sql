SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.pPgtoRctoDivSaldo_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPgtoRctoDivSaldo_Sel 
(
@NumLcto		VarChar(12),
@Saldo 		Float = 0  OUTPUT
)
 AS
	Set @Saldo = IsNull((Select Sum (Vlr_Item) From Pgto_Rcto_Div_Det Where Num_Lcto_Div = @NumLcto and DC_Item = 'C'), 0) 
	Set @Saldo = @Saldo - IsNull((Select Sum (Vlr_Item) From Pgto_Rcto_Div_Det Where Num_Lcto_Div = @NumLcto and DC_Item = 'D'), 0)




GO
