SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pCDNoteHEAGrpMoe_Sel
(
@Num_Proc 		VarChar(16),
@Cred_Dev		VarChar(10), 
@CD			Char(1),
@CredNote		VarChar(12)=''
)
 AS
	If @CredNote = ''
        		Begin
			If @CD = 'C' 
				Begin 
					Select 
						CtaBase.cd_tp_moeda, dbo.totext(sum((Case When CtaD.Vlr_Org_HEA Is Null then 0 else CtaD.Vlr_Org_HEA End)
						-(Case When CtaC.Vlr_Org_HEA Is Null then 0 else CtaC.Vlr_Org_HEA End))) as Total 
					From 
						Cta_cte_hou_exp_aer as ctaBase 
						Left Outer Join Cta_cte_hou_exp_aer as CtaC on CtaC.Num_Proc_HEA = CtaBase.Num_Proc_HEA and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HEA = 'C' and CtaC.Num_DCN_HEA is null  and CtaC.Cd_Cred_Dev_HEA = @Cred_Dev And CtaC.Comp_CN_HEA = 'S' AND CtaC.DC_HEA = CtaBase.DC_HEA
						Left Outer Join Cta_cte_hou_exp_aer as CtaD on CtaD.Num_Proc_HEA = CtaBase.Num_Proc_HEA and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HEA = 'D' and CtaD.Num_DCN_HEA is null  and CtaD.Cd_Cred_Dev_HEA = @Cred_Dev And CtaD.Comp_CN_HEA = 'S' AND CtaD.DC_HEA = CtaBase.DC_HEA			
					Where 
						Ctabase.num_proc_HEA =  @Num_Proc and 
						Ctabase.Num_DCN_HEA is null  and
						Ctabase.Cd_Cred_Dev_HEA = @Cred_Dev And 
						Ctabase.Comp_CN_HEA = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 

			If @CD = 'D' 
				Begin 
					Select 
						CtaBase.cd_tp_moeda, dbo.totext(sum((Case When CtaC.Vlr_Org_HEA Is Null then 0 else CtaC.Vlr_Org_HEA End)
						-(Case When CtaD.Vlr_Org_HEA Is Null then 0 else CtaD.Vlr_Org_HEA End))) as Total 
					From 
						Cta_cte_hou_exp_aer as ctaBase 
						Left Outer Join Cta_cte_hou_exp_aer as CtaC on CtaC.Num_Proc_HEA = CtaBase.Num_Proc_HEA and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HEA = 'C' and CtaC.Num_DCN_HEA  is null   and CtaC.Cd_Cred_Dev_HEA = @Cred_Dev And CtaC.Comp_DN_HEA = 'S' AND CtaC.DC_HEA = CtaBase.DC_HEA
						Left Outer Join Cta_cte_hou_exp_aer as CtaD on CtaD.Num_Proc_HEA = CtaBase.Num_Proc_HEA and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HEA = 'D' and CtaD.Num_DCN_HEA  is null  and CtaD.Cd_Cred_Dev_HEA = @Cred_Dev And CtaD.Comp_DN_HEA = 'S' AND CtaD.DC_HEA = CtaBase.DC_HEA			
					Where 
						Ctabase.num_proc_HEA =  @Num_Proc and 
						Ctabase.Num_DCN_HEA is null  and
						Ctabase.Cd_Cred_Dev_HEA = @Cred_Dev And 
						Ctabase.Comp_DN_HEA = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 
		End 
	Else
		Begin 
			If @CD = 'C' 
				Begin 
					Select 
						CtaBase.cd_tp_moeda, dbo.totext(sum((Case When CtaD.Vlr_Org_HEA Is Null then 0 else CtaD.Vlr_Org_HEA End)
						-(Case When CtaC.Vlr_Org_HEA Is Null then 0 else CtaC.Vlr_Org_HEA End))) as Total 
					From 
						Cta_cte_hou_exp_aer as ctaBase 
						Left Outer Join Cta_cte_hou_exp_aer as CtaC on CtaC.Num_Proc_HEA = CtaBase.Num_Proc_HEA and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HEA = 'C' and CtaC.Num_DCN_HEA = @CredNote and CtaC.Cd_Cred_Dev_HEA = @Cred_Dev And CtaC.Comp_CN_HEA = 'S'	 AND CtaC.DC_HEA = CtaBase.DC_HEA		
						Left Outer Join Cta_cte_hou_exp_aer as CtaD on CtaD.Num_Proc_HEA = CtaBase.Num_Proc_HEA and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HEA = 'D' and CtaD.Num_DCN_HEA = @CredNote and CtaD.Cd_Cred_Dev_HEA = @Cred_Dev And CtaD.Comp_CN_HEA = 'S' AND CtaD.DC_HEA = CtaBase.DC_HEA			
					Where 
						Ctabase.num_proc_HEA =  @Num_Proc and 
						Ctabase.Num_DCN_HEA = @CredNote  and
						Ctabase.Cd_Cred_Dev_HEA = @Cred_Dev And 
						Ctabase.Comp_CN_HEA = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 

			If @CD = 'D' 
				Begin 
					Select 
						CtaBase.cd_tp_moeda, dbo.totext(sum((Case When CtaC.Vlr_Org_HEA Is Null then 0 else CtaC.Vlr_Org_HEA End)
						-(Case When CtaD.Vlr_Org_HEA Is Null then 0 else CtaD.Vlr_Org_HEA End))) as Total 
					From 
						Cta_cte_hou_exp_aer as ctaBase 
						Left Outer Join Cta_cte_hou_exp_aer as CtaC on CtaC.Num_Proc_HEA = CtaBase.Num_Proc_HEA and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HEA = 'C' and CtaC.Num_DCN_HEA = @CredNote and CtaC.Cd_Cred_Dev_HEA = @Cred_Dev And CtaC.Comp_DN_HEA = 'S'	 AND CtaC.DC_HEA = CtaBase.DC_HEA		
						Left Outer Join Cta_cte_hou_exp_aer as CtaD on CtaD.Num_Proc_HEA = CtaBase.Num_Proc_HEA and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HEA = 'D' and CtaD.Num_DCN_HEA = @CredNote and  CtaD.Cd_Cred_Dev_HEA = @Cred_Dev And CtaD.Comp_DN_HEA = 'S' AND CtaD.DC_HEA = CtaBase.DC_HEA
					Where 
						Ctabase.num_proc_HEA =  @Num_Proc and 
						Ctabase.Num_DCN_HEA = @CredNote and
						Ctabase.Cd_Cred_Dev_HEA = @Cred_Dev And 
						Ctabase.Comp_DN_HEA = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 

		End 	
	


--
--    If @CredNote = ''
--        Begin
--            If @CD = 'C'
--                Select
--                    Cd_Tp_Moeda, - sum(Vlr_Org_HEA) as Total
--                From
--                    cta_cte_hou_exp_aer
--                Where
--                    Num_Proc_HEA = @Num_Proc and
--                    Num_DCN_HEA is null  and
--                    Cd_Cred_Dev_HEA = @Cred_Dev And
--                    Comp_CN_HEA = 'S' And
--                    Dc_HEA  = 'C'
--                Group By
--                    Cd_Tp_Moeda
--
--                Union
--
--                Select
--                    Cd_Tp_Moeda,  sum(Vlr_Org_HEA) as Total
--                From
--                    cta_cte_hou_exp_aer
--                Where
--                    Num_Proc_HEA = @Num_Proc and
--                    Num_DCN_HEA is null  and
--                    Cd_Cred_Dev_HEA = @Cred_Dev And
--                    Comp_CN_HEA = 'S' And
--                    Dc_HEA  = 'D'
--                Group By
--                    Cd_Tp_Moeda
--
--
--            If @CD = 'D'
--                Select
--                    Cd_Tp_Moeda, sum(Vlr_Org_HEA)  as Total
--                From
--                    cta_cte_hou_exp_aer
--                Where
--                    Num_Proc_HEA = @Num_Proc and
--                    Num_DCN_HEA is null  and
--                    Cd_Cred_Dev_HEA = @Cred_Dev And
--                    Comp_DN_HEA = 'S' And
--                    Dc_HEA  = 'C'
--                Group By
--                    Cd_Tp_Moeda
--
--                Union
--
--                Select
--                    Cd_Tp_Moeda, - Sum(Vlr_Org_HEA)  as Total
--                From
--                    cta_cte_hou_exp_aer
--                Where
--                    Num_Proc_HEA = @Num_Proc and
--                    Num_DCN_HEA is null  and
--                    Cd_Cred_Dev_HEA = @Cred_Dev And
--                    Comp_DN_HEA = 'S' And
--                    Dc_HEA  = 'D'
--                Group By
--                    Cd_Tp_Moeda
--        End
--    Else
--        Begin
--            If @CD = 'C'
--                Select
--                    Cd_Tp_Moeda, - sum(Vlr_Org_HEA) as Total
--                From
--                    cta_cte_hou_exp_aer
--                Where
--                    Num_Proc_HEA = @Num_Proc and
--                    Num_DCN_HEA = @CredNote and
--                    Cd_Cred_Dev_HEA = @Cred_Dev And
--                    Comp_CN_HEA = 'S' And
--                    Dc_HEA  = 'C'
--                Group By
--                    Cd_Tp_Moeda
--
--                Union
--
--                Select
--                    Cd_Tp_Moeda,  sum(Vlr_Org_HEA) as Total
--                From
--                    cta_cte_hou_exp_aer
--                Where
--                    Num_Proc_HEA = @Num_Proc And
--                    Num_DCN_HEA = @CredNote And
--                    Cd_Cred_Dev_HEA = @Cred_Dev And
--                    Comp_CN_HEA = 'S' And
--                    Dc_HEA  = 'D'
--                Group By
--                    Cd_Tp_Moeda
--
--
--            If @CD = 'D'
--                Select
--                    Cd_Tp_Moeda, sum(Vlr_Org_HEA)  as Total
--                From
--                    cta_cte_hou_exp_aer
--                Where
--                    Num_Proc_HEA = @Num_Proc and
--                    Num_DCN_HEA = @CredNote And
--                    Cd_Cred_Dev_HEA = @Cred_Dev And
--                    Comp_DN_HEA = 'S' And
--                    Dc_HEA  = 'C'
--                Group By
--                    Cd_Tp_Moeda
--
--                Union
--
--                Select
--                    Cd_Tp_Moeda, - Sum(Vlr_Org_HEA)  as Total
--                From
--                    cta_cte_hou_exp_aer
--                Where
--                    Num_Proc_HEA = @Num_Proc and
--                    Num_DCN_HEA = @CredNote And
--                    Cd_Cred_Dev_HEA = @Cred_Dev And
--                    Comp_DN_HEA = 'S' And
--                    Dc_HEA  = 'D'
--                Group By
--                    Cd_Tp_Moeda
--        End
GO
