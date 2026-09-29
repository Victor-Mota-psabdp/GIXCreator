SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTotalizaCtaMEA_Sel 
(
@NumProc	VarChar(14) 
)
 AS
	Declare @RecTotal 	Float 
	Declare @PgtTotal	Float
	Declare @RecOper 	Float 
	Declare @ProfTotal	Float 
	
	Set @RecTotal = IsNull((Select Sum(Vlr_Pgto_Rcto_HEA) From House_Exp_Aer as HEA 
				Join Caixa_Hou_Exp_Aer as Cxa on HEA.Num_Proc_HEA = Cxa.Num_Proc_HEA
				Where HEA.Num_Proc_MEA= @NumProc and DC_HEA = 'C' ),0)

	Set @RecTotal = @RecTotal + IsNull((Select Sum(Cte.Vlr_Org_HEA) From Cta_Cte_Hou_Exp_Aer Cte Left Join Caixa_Hou_Exp_Aer Cxa on Cxa.Num_Proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HEA, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_HEA Is Null and Cte.Desp_Dst_HEA = 'N' and Cte.DC_HEA = 'C'),0)

	Set @RecTotal = @RecTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_HEA)  as Decimal(12,2)) From Cta_Cte_Hou_Exp_Aer Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'EXA'  Left Join Caixa_Hou_Exp_Aer Cxa on Cxa.Num_Proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HEA, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_HEA Is Null and Cte.Desp_Dst_HEA = 'N' and Cte.DC_HEA = 'C'),0)


	Set @RecTotal = @RecTotal + IsNull((Select Sum(Vlr_Pgto_Rcto_MEA) From Master_Exp_Aer as MEA 
				Join Caixa_Mas_Exp_Aer as Cxa on MEA.Num_Proc_MEA = Cxa.Num_Proc_MEA
				Where MEA.Num_Proc_MEA= @NumProc and DC_MEA = 'C'),0)


	Set @RecTotal = @RecTotal + IsNull((Select Sum(Cte.Vlr_Org_MEA) From Cta_Cte_Mas_Exp_Aer Cte Left Join Caixa_Mas_Exp_Aer Cxa on Cxa.Num_Proc_MEA = Cte.Num_Proc_MEA and Cxa.DC_MEA = Cte.DC_MEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MEA, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_MEA Is Null and Cte.Desp_Dst_MEA = 'N' and Cte.DC_MEA = 'C'),0)

	Set @RecTotal = @RecTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_MEA)  as Decimal(12,2)) From Cta_Cte_Mas_Exp_Aer Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'EXA'  Left Join Caixa_Mas_Exp_Aer Cxa on Cxa.Num_Proc_MEA = Cte.Num_Proc_MEA and Cxa.DC_MEA = Cte.DC_MEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MEA, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_MEA Is Null and Cte.Desp_Dst_MEA = 'N' and Cte.DC_MEA = 'C'),0)





	Set @PgtTotal = IsNull((Select Sum(Vlr_Pgto_Rcto_HEA) From House_Exp_Aer as HEA 
				Join Caixa_Hou_Exp_Aer as Cxa on HEA.Num_Proc_HEA = Cxa.Num_Proc_HEA
				Where HEA.Num_Proc_MEA= @NumProc and DC_HEA = 'D' ),0)

	Set @PgtTotal = @PgtTotal + IsNull((Select Sum(Cte.Vlr_Org_HEA) From Cta_Cte_Hou_Exp_Aer Cte Left Join Caixa_Hou_Exp_Aer Cxa on Cxa.Num_Proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HEA, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_HEA Is Null and Cte.Desp_Dst_HEA = 'N' and Cte.DC_HEA = 'D'),0)

	Set @PgtTotal = @PgtTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_HEA)  as Decimal(12,2)) From Cta_Cte_Hou_Exp_Aer Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC'  Left Join Caixa_Hou_Exp_Aer Cxa on Cxa.Num_Proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HEA, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_HEA Is Null and Cte.Desp_Dst_HEA = 'N' and Cte.DC_HEA = 'D'),0)


	Set @PgtTotal = @PgtTotal + IsNull((Select Sum(Vlr_Pgto_Rcto_MEA) From Master_Exp_Aer as MEA 
				Join Caixa_Mas_Exp_Aer as Cxa on MEA.Num_Proc_MEA = Cxa.Num_Proc_MEA
				Where MEA.Num_Proc_MEA= @NumProc and DC_MEA = 'D'),0)


	Set @PgtTotal = @PgtTotal + IsNull((Select Sum(Cte.Vlr_Org_MEA) From Cta_Cte_Mas_Exp_Aer Cte Left Join Caixa_Mas_Exp_Aer Cxa on Cxa.Num_Proc_MEA = Cte.Num_Proc_MEA and Cxa.DC_MEA = Cte.DC_MEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MEA, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_MEA Is Null and Cte.Desp_Dst_MEA = 'N' and Cte.DC_MEA = 'D'),0)

	Set @PgtTotal = @PgtTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_MEA)  as Decimal(12,2)) From Cta_Cte_Mas_Exp_Aer Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC'  Left Join Caixa_Mas_Exp_Aer Cxa on Cxa.Num_Proc_MEA = Cte.Num_Proc_MEA and Cxa.DC_MEA = Cte.DC_MEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MEA, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_MEA Is Null and Cte.Desp_Dst_MEA = 'N' and Cte.DC_MEA = 'D'),0)




	Set @RecOper = @RecTotal - @PgtTotal 
	
	Set @ProfTotal = IsNull((Select Sum(Vlr_Frete_Tot_HEA) From House_Exp_Aer Where Num_Proc_MEA = @NumProc),0)
	Set @ProfTotal = @ProfTotal - IsNull((Select Vlr_Frete_MEA From Master_Exp_Aer Where Num_Proc_MEA = @NumProc),0)
	Select @NumProc as Num_Proc_MEA, @RecTotal as RecTotal, @PgtTotal as PgtTotal, @RecOper as RecOper, @ProfTotal as ProfTotal
GO
