SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTotalizaCtaMIM_Sel 
(
@NumProc	VarChar(14) 
)
 AS
	Declare @RecTotal 	Float 
	Declare @PgtTotal	Float
	Declare @RecOper 	Float 
	Declare @ProfTotal	Float 
	
	Set @RecTotal = IsNull((Select Sum(Vlr_Pgto_Rcto_HIM) From House_Imp_Mar as HIM 
				Join Caixa_Hou_Imp_Mar as Cxa on HIM.Num_Proc_HIM = Cxa.Num_Proc_HIM
				Where HIM.Num_Proc_MIM= @NumProc and DC_HIM = 'C' ),0)

	Set @RecTotal = @RecTotal + IsNull((Select Sum(Cte.Vlr_Org_HIM) From Cta_Cte_Hou_Imp_Mar Cte Left Join Caixa_Hou_Imp_Mar Cxa on Cxa.Num_Proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HIM, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_HIM Is Null and Cte.Desp_Org_HIM = 'N' and Cte.DC_HIM = 'C'),0)

	Set @RecTotal = @RecTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_HIM)  as Decimal(12,2)) From Cta_Cte_Hou_Imp_Mar Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'IMA'  Left Join Caixa_Hou_Imp_Mar Cxa on Cxa.Num_Proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HIM, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_HIM Is Null and Cte.Desp_Org_HIM = 'N' and Cte.DC_HIM = 'C'),0)


	Set @RecTotal = @RecTotal + IsNull((Select Sum(Vlr_Pgto_Rcto_MIM) From Master_Imp_Mar as MIM 
				Join Caixa_Mas_Imp_Mar as Cxa on MIM.Num_Proc_MIM = Cxa.Num_Proc_MIM
				Where MIM.Num_Proc_MIM= @NumProc and DC_MIM = 'C'),0)


	Set @RecTotal = @RecTotal + IsNull((Select Sum(Cte.Vlr_Org_MIM) From Cta_Cte_Mas_Imp_Mar Cte Left Join Caixa_Mas_Imp_Mar Cxa on Cxa.Num_Proc_MIM = Cte.Num_Proc_MIM and Cxa.DC_MIM = Cte.DC_MIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MIM, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_MIM Is Null and Cte.Desp_Org_MIM = 'N' and Cte.DC_MIM = 'C'),0)

	Set @RecTotal = @RecTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_MIM)  as Decimal(12,2)) From Cta_Cte_Mas_Imp_Mar Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'IMA'  Left Join Caixa_Mas_Imp_Mar Cxa on Cxa.Num_Proc_MIM = Cte.Num_Proc_MIM and Cxa.DC_MIM = Cte.DC_MIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MIM, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_MIM Is Null and Cte.Desp_Org_MIM = 'N' and Cte.DC_MIM = 'C'),0)





	Set @PgtTotal = IsNull((Select Sum(Vlr_Pgto_Rcto_HIM) From House_Imp_Mar as HIM 
				Join Caixa_Hou_Imp_Mar as Cxa on HIM.Num_Proc_HIM = Cxa.Num_Proc_HIM
				Where HIM.Num_Proc_MIM= @NumProc and DC_HIM = 'D' ),0)

	Set @PgtTotal = @PgtTotal + IsNull((Select Sum(Cte.Vlr_Org_HIM) From Cta_Cte_Hou_Imp_Mar Cte Left Join Caixa_Hou_Imp_Mar Cxa on Cxa.Num_Proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HIM, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_HIM Is Null and Cte.Desp_Org_HIM = 'N' and Cte.DC_HIM = 'D'),0)

	Set @PgtTotal = @PgtTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_HIM)  as Decimal(12,2)) From Cta_Cte_Hou_Imp_Mar Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC'  Left Join Caixa_Hou_Imp_Mar Cxa on Cxa.Num_Proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HIM, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_HIM Is Null and Cte.Desp_Org_HIM = 'N' and Cte.DC_HIM = 'D'),0)


	Set @PgtTotal = @PgtTotal + IsNull((Select Sum(Vlr_Pgto_Rcto_MIM) From Master_Imp_Mar as MIM 
				Join Caixa_Mas_Imp_Mar as Cxa on MIM.Num_Proc_MIM = Cxa.Num_Proc_MIM
				Where MIM.Num_Proc_MIM= @NumProc and DC_MIM = 'D'),0)


	Set @PgtTotal = @PgtTotal + IsNull((Select Sum(Cte.Vlr_Org_MIM) From Cta_Cte_Mas_Imp_Mar Cte Left Join Caixa_Mas_Imp_Mar Cxa on Cxa.Num_Proc_MIM = Cte.Num_Proc_MIM and Cxa.DC_MIM = Cte.DC_MIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MIM, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_MIM Is Null and Cte.Desp_Org_MIM = 'N' and Cte.DC_MIM = 'D'),0)

	Set @PgtTotal = @PgtTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_MIM)  as Decimal(12,2)) From Cta_Cte_Mas_Imp_Mar Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC'  Left Join Caixa_Mas_Imp_Mar Cxa on Cxa.Num_Proc_MIM = Cte.Num_Proc_MIM and Cxa.DC_MIM = Cte.DC_MIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MIM, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_MIM Is Null and Cte.Desp_Org_MIM = 'N' and Cte.DC_MIM = 'D'),0)




	Set @RecOper = @RecTotal - @PgtTotal 
	
	Set @ProfTotal = IsNull((Select Sum(Vlr_Frete_Efet_HIM) From House_Imp_Mar Where Num_Proc_MIM = @NumProc),0)
	Set @ProfTotal = @ProfTotal - IsNull((Select Vlr_Frete_MIM From Master_Imp_Mar Where Num_Proc_MIM = @NumProc),0)
	Select @NumProc as Num_Proc_MIM, @RecTotal as RecTotal, @PgtTotal as PgtTotal, @RecOper as RecOper, @ProfTotal as ProfTotal
GO
