SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pCDNoteHEMGrpMoe_Sel
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
						CtaBase.cd_tp_moeda, sum((Case When CtaD.Vlr_Org_HEM Is Null then 0 else CtaD.Vlr_Org_HEM End)
						-(Case When CtaC.Vlr_Org_HEM Is Null then 0 else CtaC.Vlr_Org_HEM End)) as Total 
					From 
						Cta_cte_hou_exp_mar as ctaBase 
						Left Outer Join Cta_cte_hou_exp_mar as CtaC on CtaC.Num_Proc_HEM = CtaBase.Num_Proc_HEM and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HEM = 'C' and CtaC.Num_DCN_HEM is null  and CtaC.Cd_Cred_Dev_HEM = @Cred_Dev And CtaC.Comp_CN_HEM = 'S' AND CtaC.DC_HEM = CtaBase.DC_HEM
						Left Outer Join Cta_cte_hou_exp_mar as CtaD on CtaD.Num_Proc_HEM = CtaBase.Num_Proc_HEM and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HEM = 'D' and CtaD.Num_DCN_HEM is null  and CtaD.Cd_Cred_Dev_HEM = @Cred_Dev And CtaD.Comp_CN_HEM = 'S' and  CtaD.DC_HEM = CtaBase.DC_HEM			
					Where 
						Ctabase.num_proc_HEM =  @Num_Proc and 
						Ctabase.Num_DCN_HEM is null  and
						Ctabase.Cd_Cred_Dev_HEM = @Cred_Dev And 
						Ctabase.Comp_CN_HEM = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 

			If @CD = 'D' 
				Begin 
					Select 
						CtaBase.cd_tp_moeda, sum((Case When CtaC.Vlr_Org_HEM Is Null then 0 else CtaC.Vlr_Org_HEM End)
						-(Case When CtaD.Vlr_Org_HEM Is Null then 0 else CtaD.Vlr_Org_HEM End)) as Total 
					From 
						Cta_cte_hou_exp_mar as ctaBase 
						Left Outer Join Cta_cte_hou_exp_mar as CtaC on CtaC.Num_Proc_HEM = CtaBase.Num_Proc_HEM and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HEM = 'C' and CtaC.Num_DCN_HEM  is null   and CtaC.Cd_Cred_Dev_HEM = @Cred_Dev And CtaC.Comp_DN_HEM = 'S' AND CtaC.DC_HEM = CtaBase.DC_HEM			
						Left Outer Join Cta_cte_hou_exp_mar as CtaD on CtaD.Num_Proc_HEM = CtaBase.Num_Proc_HEM and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HEM = 'D' and CtaD.Num_DCN_HEM  is null  and CtaD.Cd_Cred_Dev_HEM = @Cred_Dev And CtaD.Comp_DN_HEM = 'S' AND CtaD.DC_HEM = CtaBase.DC_HEM			
					Where 
						Ctabase.num_proc_HEM =  @Num_Proc and 
						Ctabase.Num_DCN_HEM is null  and
						Ctabase.Cd_Cred_Dev_HEM = @Cred_Dev And 
						Ctabase.Comp_DN_HEM = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 
		End 
	Else
		Begin 
			If @CD = 'C' 
				Begin 
					Select 
						CtaBase.cd_tp_moeda, sum((Case When CtaD.Vlr_Org_HEM Is Null then 0 else CtaD.Vlr_Org_HEM End)
						-(Case When CtaC.Vlr_Org_HEM Is Null then 0 else CtaC.Vlr_Org_HEM End)) as Total 
					From 
						Cta_cte_hou_exp_mar as ctaBase 
						Left Outer Join Cta_cte_hou_exp_mar as CtaC on CtaC.Num_Proc_HEM = CtaBase.Num_Proc_HEM and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HEM = 'C' and CtaC.Num_DCN_HEM = @CredNote and CtaC.Cd_Cred_Dev_HEM = @Cred_Dev And CtaC.Comp_CN_HEM = 'S'  AND CtaC.DC_HEM = CtaBase.DC_HEM			 
						Left Outer Join Cta_cte_hou_exp_mar as CtaD on CtaD.Num_Proc_HEM = CtaBase.Num_Proc_HEM and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HEM = 'D' and CtaD.Num_DCN_HEM = @CredNote and CtaD.Cd_Cred_Dev_HEM = @Cred_Dev And CtaD.Comp_CN_HEM = 'S' AND CtaD.DC_HEM = CtaBase.DC_HEM			
					Where 
						Ctabase.num_proc_HEM =  @Num_Proc and 
						Ctabase.Num_DCN_HEM = @CredNote  and
						Ctabase.Cd_Cred_Dev_HEM = @Cred_Dev And 
						Ctabase.Comp_CN_HEM = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 

			If @CD = 'D' 
				Begin 
					Select 
						CtaBase.cd_tp_moeda, sum((Case When CtaC.Vlr_Org_HEM Is Null then 0 else CtaC.Vlr_Org_HEM End)
						-(Case When CtaD.Vlr_Org_HEM Is Null then 0 else CtaD.Vlr_Org_HEM End)) as Total 
					From 
						Cta_cte_hou_exp_mar as ctaBase 
						Left Outer Join Cta_cte_hou_exp_mar as CtaC on CtaC.Num_Proc_HEM = CtaBase.Num_Proc_HEM and CtaC.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaC.DC_HEM = 'C' and CtaC.Num_DCN_HEM = @CredNote and CtaC.Cd_Cred_Dev_HEM = @Cred_Dev And CtaC.Comp_DN_HEM = 'S' AND CtaC.DC_HEM = CtaBase.DC_HEM			
						Left Outer Join Cta_cte_hou_exp_mar as CtaD on CtaD.Num_Proc_HEM = CtaBase.Num_Proc_HEM and CtaD.Cd_Tp_Tx = CtaBase.Cd_Tp_Tx and CtaD.DC_HEM = 'D' and CtaD.Num_DCN_HEM = @CredNote and  CtaD.Cd_Cred_Dev_HEM = @Cred_Dev And CtaD.Comp_DN_HEM = 'S' AND CtaD.DC_HEM = CtaBase.DC_HEM			
					Where 
						Ctabase.num_proc_HEM =  @Num_Proc and 
						Ctabase.Num_DCN_HEM = @CredNote and
						Ctabase.Cd_Cred_Dev_HEM = @Cred_Dev And 
						Ctabase.Comp_DN_HEM = 'S'			
					
					Group by 
						CtaBase.Cd_tp_Moeda
				End 

		End
GO
