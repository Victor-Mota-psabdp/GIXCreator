SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pSaldoLcto_Sel    Script Date: 17/10/2002 07:32:52 ******/
CREATE PROCEDURE pSaldoLcto_Sel 
(
@Lcto		VarChar(12),
@TotalLanc	Float =0 OUTPUT
)
 AS
	Set @TotalLanc = IsNull((Select Sum (Vlr_Pgto_Rcto_MEA) From  Caixa_Mas_Exp_Aer Where Num_Lcto = @Lcto and DC_MEA = 'C'), 0)
	
	Set @TotalLanc = @TotalLanc - IsNull((Select Sum(Vlr_Pgto_Rcto_MEA) From Caixa_Mas_Exp_Aer Where Num_Lcto = @Lcto and DC_MEA = 'D'),0)
	Set @TotalLanc = @TotalLanc + IsNull((Select Sum (Vlr_Pgto_Rcto_MEM) From Caixa_Mas_Exp_Mar Where Num_Lcto = @Lcto and DC_MEM = 'C'),0)
	Set @TotalLanc = @TotalLanc - IsNull((Select Sum (Vlr_Pgto_Rcto_MEM) From Caixa_Mas_Exp_Mar Where Num_Lcto = @Lcto and  DC_MEM = 'D'),0)
	Set @TotalLanc = @TotalLanc + IsNull((Select Sum (Vlr_Pgto_Rcto_MIA)  From Caixa_Mas_Imp_Aer Where Num_Lcto = @Lcto and DC_MIA = 'C'),0)
	Set @TotalLanc = @TotalLanc - IsNull((Select Sum (Vlr_Pgto_Rcto_MIA)  From Caixa_Mas_Imp_Aer Where Num_Lcto = @Lcto and DC_MIA = 'D'),0)
	Set @TotalLanc = @TotalLanc + IsNull((Select Sum (Vlr_Pgto_Rcto_MIM) From Caixa_Mas_Imp_Mar Where Num_Lcto = @Lcto and DC_MIM = 'C'),0)
	Set @TotalLanc = @TotalLanc - IsNull((Select Sum (Vlr_Pgto_Rcto_MIM) From Caixa_Mas_Imp_Mar Where Num_Lcto = @Lcto and DC_MIM = 'D'),0)
	Set @TotalLanc = @TotalLanc + IsNull((Select Sum (Vlr_Pgto_Rcto_HEA) From Caixa_Hou_Exp_Aer Where Num_Lcto = @Lcto and DC_HEA = 'C'),0)
	Set @TotalLanc = @TotalLanc - IsNull((Select Sum (Vlr_Pgto_Rcto_HEA) From Caixa_Hou_Exp_Aer Where Num_Lcto = @Lcto and DC_HEA = 'D'),0)
	Set @TotalLanc = @TotalLanc + IsNull((Select Sum (Vlr_Pgto_Rcto_HEM) From Caixa_Hou_Exp_Mar Where Num_Lcto = @Lcto and DC_HEM = 'C'),0)
	Set @TotalLanc = @TotalLanc - IsNull((Select Sum (Vlr_Pgto_Rcto_HEM) From Caixa_Hou_Exp_Mar Where Num_Lcto = @Lcto and DC_HEM = 'D'),0)
	Set @TotalLanc = @TotalLanc + IsNull((Select Sum (Vlr_Pgto_Rcto_HIA) From Caixa_Hou_Imp_Aer Where Num_Lcto = @Lcto and DC_HIA = 'C'),0)
	Set @TotalLanc = @TotalLanc - IsNull((Select Sum (Vlr_Pgto_Rcto_HIA) From Caixa_Hou_Imp_Aer Where Num_Lcto = @Lcto and DC_HIA = 'D'),0) 
	Set @TotalLanc = @TotalLanc + IsNull((Select Sum (Vlr_Pgto_Rcto_HIM) From Caixa_Hou_Imp_Mar Where Num_Lcto = @Lcto and DC_HIM = 'C'),0) 
	Set @TotalLanc = @TotalLanc - IsNull((Select Sum (Vlr_Pgto_Rcto_HIM) From Caixa_Hou_Imp_Mar Where Num_Lcto = @Lcto and DC_HIM = 'D'),0)



GO
