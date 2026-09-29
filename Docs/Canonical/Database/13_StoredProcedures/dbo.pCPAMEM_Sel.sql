SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCPAMEM_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pCPAMEM_Sel
(
@Num_proc		VarChar(14)
)
 AS
	Declare @CrdMAWB	Float 
	Declare @DbtMAWB	Float 
	Declare @CrdHAWB	Float 
	Declare @DbtHAWB	Float 
	Declare @Profit 		Float 
	
	
	Set @CrdMAWB = IsNull((Select Sum(Vlr_Org_MEM) From Cta_cte_mas_exp_mar Where Comp_CPA_MEM = 'S' and DC_MEM = 'C' and Num_Proc_MEM = @Num_Proc),0)
	Set @DbtMAWB = IsNull((Select Sum(Vlr_Org_MEM) From Cta_cte_mas_exp_mar Where Comp_CPA_MEM = 'S' and DC_MEM = 'D' and Num_Proc_MEM = @Num_Proc),0)
	Set @CrdHAWB = IsNull((Select Sum(Vlr_Org_HEM) From Cta_cte_hou_exp_mar Where Comp_CPA_HEM = 'S' and DC_HEM = 'C' and Substring(Num_Proc_HEM, 1, 14) = @Num_Proc),0)
	Set @DbtHAWB = IsNull((Select Sum(Vlr_Org_HEM) From Cta_cte_hou_exp_mar Where Comp_CPA_HEM = 'S' and DC_HEM = 'D' and Substring(Num_Proc_HEM, 1, 14) = @Num_Proc),0)
	Set @Profit = IsNull((Select Perc_DL From Master_Exp_Mar as MEM Left outer join Div_lucro as DL on MEM.Nivel_DL = DL.Nivel_DL Where MEM.Num_Proc_MEM = @Num_Proc),0) 
	Select @CrdMAWB as CrdMAWB, @DbtMAWB as DbtMAWB, @CrdHAWB as CrdHAWB, @DbtHAWB as DbtHAWB, @Profit as Profit



GO
