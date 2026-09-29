SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pDNCN_Sel 
(
@Modal	Char(1),
@DNCN	VarChar(12),
@Cd_Pes 	VarChar(10)
)
 AS
	If @Modal = 'A'
		Select  
			CteI.Num_Proc_HIA as Num_Proc, Num_DCN_HIA as NUm_DCN, CteI.Cd_Tp_Tx as Cd_TP_Tx, TTI.Nome_Tp_Tx as Taxa, CteI.DC_HIA as DC, CteI.Cd_Tp_Moeda as Moeda, CteI.Vlr_Org_HIA as Vlr_Org,  CxaI.Num_Lcto as Lcto, CxaI.Num_Rcb_HIA as Num_Rcb  
		From 
			Cta_Cte_Hou_Imp_Aer as CteI Left Outer Join Caixa_Hou_Imp_Aer as CxaI on (CteI.Num_Proc_HIA = CxaI.Num_Proc_HIA and CteI.DC_HIA = CxaI.DC_HIA and CteI.Cd_Tp_Tx = CxaI.Cd_Tp_Tx) Join Tipo_Taxa as TTI on CteI.Cd_Tp_Tx = TTI.Cd_Tp_Tx 
		Where 
			Num_DCN_HIA = @DNCN  and CteI.Cd_Cred_Dev_HIA = @Cd_Pes  and ((CteI.Cd_Tp_Tx = 'FRT' and CteI.DC_HIA = 'D') Or CteI.Cd_Tp_Tx = 'PBD' Or CteI.Cd_Tp_Tx = 'PSA' Or CteI.Comp_CN_HIA = 'S' Or CteI.Comp_DN_HIA = 'S')  
	
		Union 

		Select 
			CteE.Num_Proc_HEA as Num_Proc, Num_DCN_HEA as NUm_DCN, CteE.Cd_Tp_Tx as Cd_TP_Tx, TTE.Nome_Tp_Tx as Taxa, CteE.DC_HEA as DC, CteE.Cd_Tp_Moeda as Moeda, CteE.Vlr_Org_HEA as Vlr_Org,  CxaE.Num_Lcto as Lcto, CxaE.Num_Rcb_HEA as Num_Rcb  
		From 
			Cta_Cte_Hou_Exp_Aer as CteE Left Outer Join Caixa_Hou_Exp_Aer as CxaE on (CteE.Num_Proc_HEA = CxaE.Num_Proc_HEA and CteE.DC_HEA = CxaE.DC_HEA and CteE.Cd_Tp_Tx = CxaE.Cd_Tp_Tx) Join Tipo_Taxa as TTE on CteE.Cd_Tp_Tx = TTE.Cd_Tp_Tx 
		Where 
			Num_DCN_HEA = @DNCN and CteE.Cd_Cred_Dev_HEA = @Cd_Pes  and ((CteE.Cd_Tp_Tx = 'FRT' and CteE.DC_HEA = 'D') Or CteE.Cd_Tp_Tx = 'PBD' Or CteE.Cd_Tp_Tx = 'PSA' Or CteE.Comp_CN_HEA = 'S' Or CteE.Comp_DN_HEA = 'S')
	Else 
		Select 
			CteI.Num_Proc_HIM as Num_Proc, Num_DCN_HIM as NUm_DCN, CteI.Cd_Tp_Tx as Cd_TP_Tx, TTI.Nome_Tp_Tx as Taxa, CteI.DC_HIM as DC, CteI.Cd_Tp_Moeda as Moeda, CteI.Vlr_Org_HIM as Vlr_Org,  CxaI.Num_Lcto as Lcto, CxaI.Num_Rcb_HIM as Num_Rcb  
		From  
			Cta_Cte_Hou_Imp_Mar as CteI Left Outer Join Caixa_Hou_Imp_Mar as CxaI on (CteI.Num_Proc_HIM = CxaI.Num_Proc_HIM and CteI.DC_HIM = CxaI.DC_HIM and CteI.Cd_Tp_Tx = CxaI.Cd_Tp_Tx) Join Tipo_Taxa as TTI on CteI.Cd_Tp_Tx = TTI.Cd_Tp_Tx 
		Where 
			Num_DCN_HIM = @DNCN  and CteI.Cd_Cred_Dev_HIM = @Cd_Pes  and ((CteI.Cd_Tp_Tx = 'FRT' and CteI.DC_HIM = 'D') Or CteI.Cd_Tp_Tx = 'PBD' Or CteI.Cd_Tp_Tx = 'PSA' Or CteI.Comp_CN_HIM = 'S' Or CteI.Comp_DN_HIM = 'S')  

		Union 
		
		Select 
			CteE.Num_Proc_HEM as Num_Proc, Num_DCN_HEM as NUm_DCN, CteE.Cd_Tp_Tx as Cd_TP_Tx, TTE.Nome_Tp_Tx as Taxa, CteE.DC_HEM as DC, CteE.Cd_Tp_Moeda as Moeda, CteE.Vlr_Org_HEM as Vlr_Org,  CxaE.Num_Lcto as Lcto, CxaE.Num_Rcb_HEM as Num_Rcb  
		From 
			Cta_Cte_Hou_Exp_Mar as CteE Left Outer Join Caixa_Hou_Exp_Mar as CxaE on (CteE.Num_Proc_HEM = CxaE.Num_Proc_HEM and CteE.DC_HEM = CxaE.DC_HEM and CteE.Cd_Tp_Tx = CxaE.Cd_Tp_Tx) Join Tipo_Taxa as TTE on CteE.Cd_Tp_Tx = TTE.Cd_Tp_Tx 
		Where 
			Num_DCN_HEM = @DNCN and CteE.Cd_Cred_Dev_HEM = @Cd_Pes and ((CteE.Cd_Tp_Tx = 'FRT' and CteE.DC_HEM = 'D') Or CteE.Cd_Tp_Tx = 'PBD' Or CteE.Cd_Tp_Tx = 'PSA' Or CteE.Comp_CN_HEM = 'S' Or CteE.Comp_DN_HEM = 'S')

GO
