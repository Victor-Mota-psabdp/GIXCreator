SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteHEM_Rel    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCtaCteHEM_Rel 
(
@Num_Proc		VarChar(16) ='',
@CreditNote		VarChar(12) =''
)
 AS
	If @CreditNote <> '' 
		Select  
			Nome_Tp_Tx_Ing, 
			DC_HEM, 
			Cd_Tp_Moeda, 
			Vlr_Org_HEM
		From  	
			Cta_Cte_Hou_Exp_Mar, 
			Tipo_Taxa 
		Where 	
			Cta_Cte_Hou_Exp_Mar.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx  and
			Num_DCN_HEM = @CreditNote and 
			Num_Proc_HEM = @Num_Proc 
		Order by  
			Cd_Tp_Moeda, 			
			Nome_Tp_Tx_Ing
	Else
		Select  
			Num_Proc_HEM, 
			Nome_Tp_Tx_Ing,
			Cta_Cte_Hou_Exp_Mar.Cd_Tp_Tx, 
			Nome_Tp_Tx, 
			DC_HEM, 
			Org_Ins_HEM, 
			Dt_Ins_HEM, 
			Cta_Cte_Hou_Exp_Mar.Cd_Tp_Moeda, 
			Nome_Tp_Moeda, 
			Vlr_Org_HEM, 
			Dt_Prev_Pgto_HEM, 
			Cd_Cred_Dev_HEM, 
			Desp_Dst_HEM,	
			Apelido, 
			Desp_Dst_HEM, 
			CPMF_HEM, 
			Comp_RP_HEM, 
			Comp_DN_HEM, 
			Comp_CN_HEM, 
			Comp_CPA_HEM, 
			Num_DCN_HEM,
			Dt_Ctb_CC_HEM
		From  	
			Cta_Cte_Hou_Exp_Mar, 
			Tipo_Taxa, 
			Tipo_Moeda, 
			Pessoa 
		Where 	
			Num_Proc_HEM = @Num_Proc AND 
			Cta_Cte_Hou_Exp_Mar.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND 
			Cta_Cte_Hou_Exp_Mar.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda AND 
			Cd_Cred_Dev_HEM = Cd_Pes 
		Order by  
			Nome_Tp_Tx, DC_HEM



GO
