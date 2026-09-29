SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE   PROCEDURE pCDNoteHIAGrpMoe_Sel
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
						CtaBase.cd_tp_moeda, sum((Case When CtaD.Vlr_Org_HIA Is Null then 0 else CtaD.Vlr_Org_HIA End)
						-(Case When CtaC.Vlr_Org_HIA Is Null then 0 else CtaC.Vlr_Org_HIA End)) as Total 
					From 
						Cta_cte_hou_imp_aer as ctaBase 
						Left Outer Join Cta_cte_hou_imp_aer as CtaC on CtaC.Num_Proc_HIA = CtaBase.Num_Proc_HIA and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HIA = 'C' and CtaC.Num_DCN_HIA is null  and CtaC.Cd_Cred_Dev_HIA = @Cred_Dev And CtaC.Comp_CN_HIA = 'S' AND CtaC.DC_HIA = CtaBase.DC_HIA
						Left Outer Join Cta_cte_hou_imp_aer as CtaD on CtaD.Num_Proc_HIA = CtaBase.Num_Proc_HIA and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HIA = 'D' and CtaD.Num_DCN_HIA is null  and CtaD.Cd_Cred_Dev_HIA = @Cred_Dev And CtaD.Comp_CN_HIA = 'S' and  CtaD.DC_HIA = CtaBase.DC_HIA			
					Where 
						Ctabase.num_proc_HIA =  @Num_Proc and 
						Ctabase.Num_DCN_HIA is null  and
						Ctabase.Cd_Cred_Dev_HIA = @Cred_Dev And 
						Ctabase.Comp_CN_HIA = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 

			If @CD = 'D' 
				Begin 
					Select 
						CtaBase.cd_tp_moeda, sum((Case When CtaC.Vlr_Org_HIA Is Null then 0 else CtaC.Vlr_Org_HIA End)
						-(Case When CtaD.Vlr_Org_HIA Is Null then 0 else CtaD.Vlr_Org_HIA End)) as Total 
					From 
						Cta_cte_hou_imp_aer as ctaBase 
						Left Outer Join Cta_cte_hou_imp_aer as CtaC on CtaC.Num_Proc_HIA = CtaBase.Num_Proc_HIA and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HIA = 'C' and CtaC.Num_DCN_HIA  is null   and CtaC.Cd_Cred_Dev_HIA = @Cred_Dev And CtaC.Comp_DN_HIA = 'S' AND CtaC.DC_HIA = CtaBase.DC_HIA			
						Left Outer Join Cta_cte_hou_imp_aer as CtaD on CtaD.Num_Proc_HIA = CtaBase.Num_Proc_HIA and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HIA = 'D' and CtaD.Num_DCN_HIA  is null  and CtaD.Cd_Cred_Dev_HIA = @Cred_Dev And CtaD.Comp_DN_HIA = 'S' AND CtaD.DC_HIA = CtaBase.DC_HIA			
					Where 
						Ctabase.num_proc_HIA =  @Num_Proc and 
						Ctabase.Num_DCN_HIA is null  and
						Ctabase.Cd_Cred_Dev_HIA = @Cred_Dev And 
						Ctabase.Comp_DN_HIA = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 
		End 
	Else
		Begin 
			If @CD = 'C' 
				Begin 
					Select 
						CtaBase.cd_tp_moeda, sum((Case When CtaD.Vlr_Org_HIA Is Null then 0 else CtaD.Vlr_Org_HIA End)
						-(Case When CtaC.Vlr_Org_HIA Is Null then 0 else CtaC.Vlr_Org_HIA End)) as Total 
					From 
						Cta_cte_hou_imp_aer as ctaBase 
						Left Outer Join Cta_cte_hou_imp_aer as CtaC on CtaC.Num_Proc_HIA = CtaBase.Num_Proc_HIA and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HIA = 'C' and CtaC.Num_DCN_HIA = @CredNote and CtaC.Cd_Cred_Dev_HIA = @Cred_Dev And CtaC.Comp_CN_HIA = 'S'  AND CtaC.DC_HIA = CtaBase.DC_HIA			 
						Left Outer Join Cta_cte_hou_imp_aer as CtaD on CtaD.Num_Proc_HIA = CtaBase.Num_Proc_HIA and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HIA = 'D' and CtaD.Num_DCN_HIA = @CredNote and CtaD.Cd_Cred_Dev_HIA = @Cred_Dev And CtaD.Comp_CN_HIA = 'S' AND CtaD.DC_HIA = CtaBase.DC_HIA			
					Where 
						Ctabase.num_proc_HIA =  @Num_Proc and 
						Ctabase.Num_DCN_HIA = @CredNote  and
						Ctabase.Cd_Cred_Dev_HIA = @Cred_Dev And 
						Ctabase.Comp_CN_HIA = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 

			If @CD = 'D' 
				Begin 
					Select 
						CtaBase.cd_tp_moeda, sum((Case When CtaC.Vlr_Org_HIA Is Null then 0 else CtaC.Vlr_Org_HIA End)
						-(Case When CtaD.Vlr_Org_HIA Is Null then 0 else CtaD.Vlr_Org_HIA End)) as Total 
					From 
						Cta_cte_hou_imp_aer as ctaBase 
						Left Outer Join Cta_cte_hou_imp_aer as CtaC on CtaC.Num_Proc_HIA = CtaBase.Num_Proc_HIA and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HIA = 'C' and CtaC.Num_DCN_HIA = @CredNote and CtaC.Cd_Cred_Dev_HIA = @Cred_Dev And CtaC.Comp_DN_HIA = 'S' AND CtaC.DC_HIA = CtaBase.DC_HIA			
						Left Outer Join Cta_cte_hou_imp_aer as CtaD on CtaD.Num_Proc_HIA = CtaBase.Num_Proc_HIA and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HIA = 'D' and CtaD.Num_DCN_HIA = @CredNote and  CtaD.Cd_Cred_Dev_HIA = @Cred_Dev And CtaD.Comp_DN_HIA = 'S' AND CtaD.DC_HIA = CtaBase.DC_HIA			
					Where 
						Ctabase.num_proc_HIA =  @Num_Proc and 
						Ctabase.Num_DCN_HIA = @CredNote and
						Ctabase.Cd_Cred_Dev_HIA = @Cred_Dev And 
						Ctabase.Comp_DN_HIA = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 

		End
GO
