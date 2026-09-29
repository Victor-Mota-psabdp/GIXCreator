SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.pPgtoRecSaldo_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE  PROCEDURE pPgtoRecSaldo_Sel 
(
@NumLcto		Varchar(14),
@ValorTotal 		Float = 0  OUTPUT
)
 AS
	Set @ValorTotal =  IsNull((Select Sum (Vlr_Pgto_Rcto_MEA)  From Caixa_Mas_Exp_Aer Where  Num_Lcto =  @NumLcto and  DC_MEA = 'C'  and Num_Rcb_MEA <> 'RATEIO'),0)
	Set @ValorTotal =  @ValorTotal - IsNull((Select Sum (Vlr_Pgto_Rcto_MEA)  From Caixa_Mas_Exp_Aer Where  Num_Lcto =  @NumLcto and  DC_MEA = 'D'  and Num_Rcb_MEA <> 'RATEIO'),0)
	Set @ValorTotal =   @ValorTotal + IsNull((Select Sum (Vlr_Pgto_Rcto_MEM)  From Caixa_Mas_Exp_Mar Where  Num_Lcto =  @NumLcto and  DC_MEM = 'C'  and Num_Rcb_MEM <> 'RATEIO'),0)
	Set @ValorTotal =  @ValorTotal - IsNull((Select Sum (Vlr_Pgto_Rcto_MEM)  From Caixa_Mas_Exp_Mar Where  Num_Lcto =  @NumLcto and  DC_MEM = 'D'  and Num_Rcb_MEM <> 'RATEIO'),0)
	Set @ValorTotal =   @ValorTotal + IsNull((Select Sum (Vlr_Pgto_Rcto_MIA)  From Caixa_Mas_Imp_Aer Where  Num_Lcto =  @NumLcto and  DC_MIA = 'C'  and Num_Rcb_MIA <> 'RATEIO'),0)
	Set @ValorTotal =  @ValorTotal - IsNull((Select Sum (Vlr_Pgto_Rcto_MIA)  From Caixa_Mas_Imp_Aer Where  Num_Lcto =  @NumLcto and  DC_MIA = 'D'  and Num_Rcb_MIA <> 'RATEIO'),0)
	
	Set @ValorTotal =   @ValorTotal + IsNull((Select Sum (Vlr_Pgto_Rcto_MIM)  From Caixa_Mas_Imp_Mar Where  Num_Lcto =  @NumLcto and  DC_MIM = 'C'  and Num_Rcb_MIM <> 'RATEIO'),0)
	Set @ValorTotal =  @ValorTotal - IsNull((Select Sum (Vlr_Pgto_Rcto_MIM)  From Caixa_Mas_Imp_Mar Where  Num_Lcto =  @NumLcto and  DC_MIM = 'D'  and Num_Rcb_MIM <> 'RATEIO'),0)
	Set @ValorTotal =  @ValorTotal + IsNull((Select Sum (Vlr_Pgto_Rcto_HEA)  From Caixa_Hou_Exp_Aer Where  Num_Lcto =  @NumLcto and  DC_HEA = 'C'  and Num_Rcb_HEA <> 'RATEIO'),0)
	Set @ValorTotal =  @ValorTotal - IsNull((Select Sum (Vlr_Pgto_Rcto_HEA)  From Caixa_Hou_Exp_Aer Where  Num_Lcto =  @NumLcto and  DC_HEA = 'D'  and Num_Rcb_HEA <> 'RATEIO'),0)
	Set @ValorTotal =   @ValorTotal + IsNull((Select Sum (Vlr_Pgto_Rcto_HEM)  From Caixa_Hou_Exp_Mar Where  Num_Lcto =  @NumLcto and  DC_HEM = 'C'  and Num_Rcb_HEM <> 'RATEIO'),0)
	Set @ValorTotal =  @ValorTotal - IsNull((Select Sum (Vlr_Pgto_Rcto_HEM)  From Caixa_Hou_Exp_Mar Where  Num_Lcto =  @NumLcto and  DC_HEM = 'D'  and Num_Rcb_HEM <> 'RATEIO'),0)
	Set @ValorTotal =   @ValorTotal + IsNull((Select Sum (Vlr_Pgto_Rcto_HIA)  From Caixa_Hou_Imp_Aer Where  Num_Lcto =  @NumLcto and  DC_HIA = 'C'  and Num_Rcb_HIA <> 'RATEIO'),0)
	Set @ValorTotal =  @ValorTotal - IsNull((Select Sum (Vlr_Pgto_Rcto_HIA)  From Caixa_Hou_Imp_Aer Where  Num_Lcto =  @NumLcto and  DC_HIA = 'D'  and Num_Rcb_HIA <> 'RATEIO'),0)
	
	Set @ValorTotal =   @ValorTotal + IsNull((Select Sum (Vlr_Pgto_Rcto_HIM)  From Caixa_Hou_Imp_Mar Where  Num_Lcto =  @NumLcto and  DC_HIM = 'C'  and Num_Rcb_HIM <> 'RATEIO'),0)
	Set @ValorTotal =  @ValorTotal - IsNull((Select Sum (Vlr_Pgto_Rcto_HIM)  From Caixa_Hou_Imp_Mar Where  Num_Lcto =  @NumLcto and  DC_HIM = 'D'  and Num_Rcb_HIM <> 'RATEIO'),0)

	Set @ValorTotal =   @ValorTotal + IsNull((Select Sum (Vlr_Pgto_Rcto_HIO)  From Caixa_Hou_Imp_Out Where  Num_Lcto =  @NumLcto and  DC_HIO = 'C'  and Num_Rcb_HIO <> 'RATEIO'),0)
	Set @ValorTotal =  @ValorTotal - IsNull((Select Sum (Vlr_Pgto_Rcto_HIO)  From Caixa_Hou_Imp_Out Where  Num_Lcto =  @NumLcto and  DC_HIO = 'D'  and Num_Rcb_HIO <> 'RATEIO'),0)

	Set @ValorTotal =   @ValorTotal + IsNull((Select Sum (Vlr_Pgto_Rcto_HEO)  From Caixa_Hou_Exp_Out Where  Num_Lcto =  @NumLcto and  DC_HEO = 'C'  and Num_Rcb_HEO <> 'RATEIO'),0)
	Set @ValorTotal =  @ValorTotal - IsNull((Select Sum (Vlr_Pgto_Rcto_HEO)  From Caixa_Hou_Exp_Out Where  Num_Lcto =  @NumLcto and  DC_HEO = 'D'  and Num_Rcb_HEO <> 'RATEIO'),0)
	Print @ValorTotal




GO
