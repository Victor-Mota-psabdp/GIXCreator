SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTotalizaCtaMEM_Sel 
(
@NumProc	VarChar(14) 
)
 AS
	Declare @RecTotal 	Float 
	Declare @PgtTotal	Float
	Declare @RecOper 	Float 
	Declare @ProfTotal	Float 
	
	Set @RecTotal = IsNull((Select Sum(Vlr_Pgto_Rcto_HEM) From House_Exp_Mar as HEM 
				Join Caixa_Hou_Exp_Mar as Cxa on HEM.Num_Proc_HEM = Cxa.Num_Proc_HEM
				Where HEM.Num_Proc_MEM= @NumProc and DC_HEM = 'C' ),0)

	Set @RecTotal = @RecTotal + IsNull((Select Sum(Cte.Vlr_Org_HEM) From Cta_Cte_Hou_Exp_Mar Cte Left Join Caixa_Hou_Exp_Mar Cxa on Cxa.Num_Proc_HEM = Cte.Num_Proc_HEM and Cxa.DC_HEM = Cte.DC_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HEM, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_HEM Is Null and Cte.Desp_Dst_HEM = 'N' and Cte.DC_HEM = 'C'),0)

	Set @RecTotal = @RecTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_HEM)  as Decimal(12,2)) From Cta_Cte_Hou_Exp_Mar Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'EXM'  Left Join Caixa_Hou_Exp_Mar Cxa on Cxa.Num_Proc_HEM = Cte.Num_Proc_HEM and Cxa.DC_HEM = Cte.DC_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HEM, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_HEM Is Null and Cte.Desp_Dst_HEM = 'N' and Cte.DC_HEM = 'C'),0)


	Set @RecTotal = @RecTotal + IsNull((Select Sum(Vlr_Pgto_Rcto_MEM) From Master_Exp_Mar as MEM 
				Join Caixa_Mas_Exp_Mar as Cxa on MEM.Num_Proc_MEM = Cxa.Num_Proc_MEM
				Where MEM.Num_Proc_MEM= @NumProc and DC_MEM = 'C'),0)


	Set @RecTotal = @RecTotal + IsNull((Select Sum(Cte.Vlr_Org_MEM) From Cta_Cte_Mas_Exp_Mar Cte Left Join Caixa_Mas_Exp_Mar Cxa on Cxa.Num_Proc_MEM = Cte.Num_Proc_MEM and Cxa.DC_MEM = Cte.DC_MEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MEM, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_MEM Is Null and Cte.Desp_Dst_MEM = 'N' and Cte.DC_MEM = 'C'),0)

	Set @RecTotal = @RecTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_MEM)  as Decimal(12,2)) From Cta_Cte_Mas_Exp_Mar Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'EXM'  Left Join Caixa_Mas_Exp_Mar Cxa on Cxa.Num_Proc_MEM = Cte.Num_Proc_MEM and Cxa.DC_MEM = Cte.DC_MEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MEM, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_MEM Is Null and Cte.Desp_Dst_MEM = 'N' and Cte.DC_MEM = 'C'),0)





	Set @PgtTotal = IsNull((Select Sum(Vlr_Pgto_Rcto_HEM) From House_Exp_Mar as HEM 
				Join Caixa_Hou_Exp_Mar as Cxa on HEM.Num_Proc_HEM = Cxa.Num_Proc_HEM
				Where HEM.Num_Proc_MEM= @NumProc and DC_HEM = 'D' ),0)

	Set @PgtTotal = @PgtTotal + IsNull((Select Sum(Cte.Vlr_Org_HEM) From Cta_Cte_Hou_Exp_Mar Cte Left Join Caixa_Hou_Exp_Mar Cxa on Cxa.Num_Proc_HEM = Cte.Num_Proc_HEM and Cxa.DC_HEM = Cte.DC_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HEM, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_HEM Is Null and Cte.Desp_Dst_HEM = 'N' and Cte.DC_HEM = 'D'),0)

	Set @PgtTotal = @PgtTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_HEM)  as Decimal(12,2)) From Cta_Cte_Hou_Exp_Mar Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC'  Left Join Caixa_Hou_Exp_Mar Cxa on Cxa.Num_Proc_HEM = Cte.Num_Proc_HEM and Cxa.DC_HEM = Cte.DC_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_HEM, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_HEM Is Null and Cte.Desp_Dst_HEM = 'N' and Cte.DC_HEM = 'D'),0)


	Set @PgtTotal = @PgtTotal + IsNull((Select Sum(Vlr_Pgto_Rcto_MEM) From Master_Exp_Mar as MEM 
				Join Caixa_Mas_Exp_Mar as Cxa on MEM.Num_Proc_MEM = Cxa.Num_Proc_MEM
				Where MEM.Num_Proc_MEM= @NumProc and DC_MEM = 'D'),0)


	Set @PgtTotal = @PgtTotal + IsNull((Select Sum(Cte.Vlr_Org_MEM) From Cta_Cte_Mas_Exp_Mar Cte Left Join Caixa_Mas_Exp_Mar Cxa on Cxa.Num_Proc_MEM = Cte.Num_Proc_MEM and Cxa.DC_MEM = Cte.DC_MEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MEM, 14) = @NumProc and Cte.Cd_Tp_Moeda = 'REL'  and Cxa.Num_Proc_MEM Is Null and Cte.Desp_Dst_MEM = 'N' and Cte.DC_MEM = 'D'),0)

	Set @PgtTotal = @PgtTotal + IsNull((Select Cast(Sum(Par.Par_Moeda * Cte.Vlr_Org_MEM)  as Decimal(12,2)) From Cta_Cte_Mas_Exp_Mar Cte Join Paridade Par on Par.Dt_Par = dbo.StrHoje(GetDate()) and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC'  Left Join Caixa_Mas_Exp_Mar Cxa on Cxa.Num_Proc_MEM = Cte.Num_Proc_MEM and Cxa.DC_MEM = Cte.DC_MEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where Left(Cte.Num_Proc_MEM, 14) = @NumProc and Cte.Cd_Tp_Moeda <> 'REL'  and Cxa.Num_Proc_MEM Is Null and Cte.Desp_Dst_MEM = 'N' and Cte.DC_MEM = 'D'),0)




	Set @RecOper = @RecTotal - @PgtTotal 
	
	Set @ProfTotal = IsNull((Select Sum(Vlr_Frete_Tot_HEM) From House_Exp_Mar Where Num_Proc_MEM = @NumProc),0)
	Set @ProfTotal = @ProfTotal - IsNull((Select Vlr_Frete_MEM From Master_Exp_Mar Where Num_Proc_MEM = @NumProc),0)
	Select @NumProc as Num_Proc_MEM, @RecTotal as RecTotal, @PgtTotal as PgtTotal, @RecOper as RecOper, @ProfTotal as ProfTotal
GO
