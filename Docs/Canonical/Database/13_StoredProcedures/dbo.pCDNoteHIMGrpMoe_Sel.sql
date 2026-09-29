SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pCDNoteHIMGrpMoe_Sel
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
						CtaBase.Cd_tp_moeda, sum((Case When CtaD.Vlr_Org_HIM Is Null then 0 else CtaD.Vlr_Org_HIM End)
						-(Case When CtaC.Vlr_Org_HIM Is Null then 0 else CtaC.Vlr_Org_HIM End)) as Total 
					From 
						Cta_cte_hou_imp_Mar as ctaBase 
						Left Outer Join Cta_cte_hou_imp_Mar as CtaC on CtaC.Num_Proc_HIM = CtaBase.Num_Proc_HIM and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HIM = 'C' and CtaC.Num_DCN_HIM is null  and CtaC.Cd_Cred_Dev_HIM = @Cred_Dev And CtaC.Comp_CN_HIM = 'S' AND CtaC.DC_HIM = CtaBase.DC_HIM
						Left Outer Join Cta_cte_hou_imp_Mar as CtaD on CtaD.Num_Proc_HIM = CtaBase.Num_Proc_HIM and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HIM = 'D' and CtaD.Num_DCN_HIM is null  and CtaD.Cd_Cred_Dev_HIM = @Cred_Dev And CtaD.Comp_CN_HIM = 'S' and  CtaD.DC_HIM = CtaBase.DC_HIM			
					Where 
						Ctabase.num_proc_HIM =  @Num_Proc and 
						Ctabase.Num_DCN_HIM is null  and
						Ctabase.Cd_Cred_Dev_HIM = @Cred_Dev And 
						Ctabase.Comp_CN_HIM = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 

			If @CD = 'D' 
				Begin 
					Select 
						CtaBase.cd_tp_moeda, sum((Case When CtaC.Vlr_Org_HIM Is Null then 0 else CtaC.Vlr_Org_HIM End)
						-(Case When CtaD.Vlr_Org_HIM Is Null then 0 else CtaD.Vlr_Org_HIM End)) as Total 
					From 
						Cta_cte_hou_imp_Mar as ctaBase 
						Left Outer Join Cta_cte_hou_imp_Mar as CtaC on CtaC.Num_Proc_HIM = CtaBase.Num_Proc_HIM and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HIM = 'C' and CtaC.Num_DCN_HIM  is null   and CtaC.Cd_Cred_Dev_HIM = @Cred_Dev And CtaC.Comp_DN_HIM = 'S' AND CtaC.DC_HIM = CtaBase.DC_HIM			
						Left Outer Join Cta_cte_hou_imp_Mar as CtaD on CtaD.Num_Proc_HIM = CtaBase.Num_Proc_HIM and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HIM = 'D' and CtaD.Num_DCN_HIM  is null  and CtaD.Cd_Cred_Dev_HIM = @Cred_Dev And CtaD.Comp_DN_HIM = 'S' AND CtaD.DC_HIM = CtaBase.DC_HIM			
					Where 
						Ctabase.num_proc_HIM =  @Num_Proc and 
						Ctabase.Num_DCN_HIM is null  and
						Ctabase.Cd_Cred_Dev_HIM = @Cred_Dev And 
						Ctabase.Comp_DN_HIM = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 
		End 
	Else
		Begin 
			If @CD = 'C' 
				Begin 
					Select 
						CtaBase.cd_tp_moeda, sum((Case When CtaD.Vlr_Org_HIM Is Null then 0 else CtaD.Vlr_Org_HIM End)
						-(Case When CtaC.Vlr_Org_HIM Is Null then 0 else CtaC.Vlr_Org_HIM End)) as Total 
					From 
						Cta_cte_hou_imp_Mar as ctaBase 
						Left Outer Join Cta_cte_hou_imp_Mar as CtaC on CtaC.Num_Proc_HIM = CtaBase.Num_Proc_HIM and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HIM = 'C' and CtaC.Num_DCN_HIM = @CredNote and CtaC.Cd_Cred_Dev_HIM = @Cred_Dev And CtaC.Comp_CN_HIM = 'S'  AND CtaC.DC_HIM = CtaBase.DC_HIM			 
						Left Outer Join Cta_cte_hou_imp_Mar as CtaD on CtaD.Num_Proc_HIM = CtaBase.Num_Proc_HIM and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HIM = 'D' and CtaD.Num_DCN_HIM = @CredNote and CtaD.Cd_Cred_Dev_HIM = @Cred_Dev And CtaD.Comp_CN_HIM = 'S' AND CtaD.DC_HIM = CtaBase.DC_HIM			
					Where 
						Ctabase.num_proc_HIM =  @Num_Proc and 
						Ctabase.Num_DCN_HIM = @CredNote  and
						Ctabase.Cd_Cred_Dev_HIM = @Cred_Dev And 
						Ctabase.Comp_CN_HIM = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 

			If @CD = 'D' 
				Begin 
					Select 
						CtaBase.cd_tp_moeda, sum((Case When CtaC.Vlr_Org_HIM Is Null then 0 else CtaC.Vlr_Org_HIM End)
						-(Case When CtaD.Vlr_Org_HIM Is Null then 0 else CtaD.Vlr_Org_HIM End)) as Total 
					From 
						Cta_cte_hou_imp_Mar as ctaBase 
						Left Outer Join Cta_cte_hou_imp_Mar as CtaC on CtaC.Num_Proc_HIM = CtaBase.Num_Proc_HIM and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HIM = 'C' and CtaC.Num_DCN_HIM = @CredNote and CtaC.Cd_Cred_Dev_HIM = @Cred_Dev And CtaC.Comp_DN_HIM = 'S' AND CtaC.DC_HIM = CtaBase.DC_HIM			
						Left Outer Join Cta_cte_hou_imp_Mar as CtaD on CtaD.Num_Proc_HIM = CtaBase.Num_Proc_HIM and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HIM = 'D' and CtaD.Num_DCN_HIM = @CredNote and  CtaD.Cd_Cred_Dev_HIM = @Cred_Dev And CtaD.Comp_DN_HIM = 'S' AND CtaD.DC_HIM = CtaBase.DC_HIM			
					Where 
						Ctabase.num_proc_HIM =  @Num_Proc and 
						Ctabase.Num_DCN_HIM = @CredNote and
						Ctabase.Cd_Cred_Dev_HIM = @Cred_Dev And 
						Ctabase.Comp_DN_HIM = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 

		End
GO
