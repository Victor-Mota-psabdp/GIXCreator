SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTotalizaCtaMIA_Sel 
(
@NumProc	VarChar(14) 
)
 AS
	Declare @RecTotal 	Float 
	Declare @PgtTotal	Float
	Declare @RecOper 	Float 
	Declare @ProfTotal	Float 
	
	Set @RecTotal = IsNull((Select Sum(Vlr_Pgto_Rcto_HIA) From House_Imp_Aer as HIA 
				Join Caixa_Hou_Imp_Aer as Cxa on HIA.Num_Proc_HIA = Cxa.Num_Proc_HIA
				Where HIA.Num_Proc_MIA= @NumProc and DC_HIA = 'C' ),0)

	Set @RecTotal = @RecTotal + IsNull((Select Sum(Cte.Vlr_Org_HIA) From Cta_Cte_Hou_Imp_Aer Cte Left Join Caixa_Hou_Imp_Aer Cxa on Cxa.Num_Proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HIA, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_HIA Is Null and Cte.Desp_Org_HIA = 'N' and Cte.DC_HIA = 'C'),0)

	Set @RecTotal = @RecTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_HIA)  as Decimal(12,2)) From Cta_Cte_Hou_Imp_Aer Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'IMA'  Left Join Caixa_Hou_Imp_Aer Cxa on Cxa.Num_Proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HIA, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_HIA Is Null and Cte.Desp_Org_HIA = 'N' and Cte.DC_HIA = 'C'),0)


	Set @RecTotal = @RecTotal + IsNull((Select Sum(Vlr_Pgto_Rcto_MIA) From Master_Imp_Aer as MIA 
				Join Caixa_Mas_Imp_Aer as Cxa on MIA.Num_Proc_MIA = Cxa.Num_Proc_MIA
				Where MIA.Num_Proc_MIA= @NumProc and DC_MIA = 'C'),0)


	Set @RecTotal = @RecTotal + IsNull((Select Sum(Cte.Vlr_Org_MIA) From Cta_Cte_Mas_Imp_Aer Cte Left Join Caixa_Mas_Imp_Aer Cxa on Cxa.Num_Proc_MIA = Cte.Num_Proc_MIA and Cxa.DC_MIA = Cte.DC_MIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MIA, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_MIA Is Null and Cte.Desp_Org_MIA = 'N' and Cte.DC_MIA = 'C'),0)

	Set @RecTotal = @RecTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_MIA)  as Decimal(12,2)) From Cta_Cte_Mas_Imp_Aer Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'IMA'  Left Join Caixa_Mas_Imp_Aer Cxa on Cxa.Num_Proc_MIA = Cte.Num_Proc_MIA and Cxa.DC_MIA = Cte.DC_MIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MIA, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_MIA Is Null and Cte.Desp_Org_MIA = 'N' and Cte.DC_MIA = 'C'),0)





	Set @PgtTotal = IsNull((Select Sum(Vlr_Pgto_Rcto_HIA) From House_Imp_Aer as HIA 
				Join Caixa_Hou_Imp_Aer as Cxa on HIA.Num_Proc_HIA = Cxa.Num_Proc_HIA
				Where HIA.Num_Proc_MIA= @NumProc and DC_HIA = 'D' ),0)

	Set @PgtTotal = @PgtTotal + IsNull((Select Sum(Cte.Vlr_Org_HIA) From Cta_Cte_Hou_Imp_Aer Cte Left Join Caixa_Hou_Imp_Aer Cxa on Cxa.Num_Proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HIA, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_HIA Is Null and Cte.Desp_Org_HIA = 'N' and Cte.DC_HIA = 'D'),0)

	Set @PgtTotal = @PgtTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_HIA)  as Decimal(12,2)) From Cta_Cte_Hou_Imp_Aer Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC'  Left Join Caixa_Hou_Imp_Aer Cxa on Cxa.Num_Proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HIA, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_HIA Is Null and Cte.Desp_Org_HIA = 'N' and Cte.DC_HIA = 'D'),0)


	Set @PgtTotal = @PgtTotal + IsNull((Select Sum(Vlr_Pgto_Rcto_MIA) From Master_Imp_Aer as MIA 
				Join Caixa_Mas_Imp_Aer as Cxa on MIA.Num_Proc_MIA = Cxa.Num_Proc_MIA
				Where MIA.Num_Proc_MIA= @NumProc and DC_MIA = 'D'),0)


	Set @PgtTotal = @PgtTotal + IsNull((Select Sum(Cte.Vlr_Org_MIA) From Cta_Cte_Mas_Imp_Aer Cte Left Join Caixa_Mas_Imp_Aer Cxa on Cxa.Num_Proc_MIA = Cte.Num_Proc_MIA and Cxa.DC_MIA = Cte.DC_MIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MIA, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_MIA Is Null and Cte.Desp_Org_MIA = 'N' and Cte.DC_MIA = 'D'),0)

	Set @PgtTotal = @PgtTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_MIA)  as Decimal(12,2)) From Cta_Cte_Mas_Imp_Aer Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC'  Left Join Caixa_Mas_Imp_Aer Cxa on Cxa.Num_Proc_MIA = Cte.Num_Proc_MIA and Cxa.DC_MIA = Cte.DC_MIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MIA, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_MIA Is Null and Cte.Desp_Org_MIA = 'N' and Cte.DC_MIA = 'D'),0)




	Set @RecOper = @RecTotal - @PgtTotal 
	
	Set @ProfTotal = IsNull((Select Sum(Vlr_Frete_Efet_HIA) From House_Imp_Aer Where Num_Proc_MIA = @NumProc),0)
	Set @ProfTotal = @ProfTotal - IsNull((Select Vlr_Frete_MIA From Master_Imp_Aer Where Num_Proc_MIA = @NumProc),0)
	Select @NumProc as Num_Proc_MIA, @RecTotal as RecTotal, @PgtTotal as PgtTotal, @RecOper as RecOper, @ProfTotal as ProfTotal
GO
