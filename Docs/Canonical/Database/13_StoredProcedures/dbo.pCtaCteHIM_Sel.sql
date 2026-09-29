SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteHIM_Sel    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCtaCteHIM_Sel 
(
@Num_Proc		VarChar(16),
@CreditNote		VarChar(12) ='', 
@RP_HIM		Char(1)=''
)
 AS
	If @RP_HIM = ''
		Select  
			Num_Proc_HIM, 
			Cta_Cte_Hou_Imp_Mar.Cd_Tp_Tx, 
			Nome_Tp_Tx, 
			Nome_Tp_Tx_Ing,
			DC_HIM, 
			Org_Ins_HIM, 
			Dt_Ins_HIM, 
			Cta_Cte_Hou_Imp_Mar.Cd_Tp_Moeda, 
			Nome_Tp_Moeda, 
			Vlr_Org_HIM, 
			Dt_Prev_Pgto_HIM, 
			Cd_Cred_Dev_HiM, 
			Apelido, 
			Desp_Org_HIM, 
			CPMF_HIM, 
			Comp_RP_HIM, 
			Comp_DN_HIM, 
			Comp_CN_HIM, 
			Comp_CPA_HIM,
			Num_DCN_HIM
		From  	
			Cta_Cte_Hou_Imp_Mar, 
			Tipo_Taxa, 
			Tipo_Moeda, 
			Pessoa 
		Where 
			Num_Proc_HIM = @Num_Proc AND 
			Cta_Cte_Hou_Imp_Mar.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND 
			Cta_Cte_Hou_Imp_Mar.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda AND 
			Cd_Cred_Dev_HIM = Cd_Pes 
		Order by  
			Nome_Tp_Tx, DC_HIM
	Else
		Select  
			Num_Proc_HIM, 
			Cta_Cte_Hou_Imp_Mar.Cd_Tp_Tx, 
			Num_Proc_HIM + '-' + Cta_Cte_Hou_Imp_Mar.Cd_Tp_Tx + '-' + DC_HIM as Seq,
			Nome_Tp_Tx, 
			Nome_Tp_Tx_Ing,	
			DC_HIM, 
			Org_Ins_HIM, 
			Dt_Ins_HIM, 
			Cta_Cte_Hou_Imp_Mar.Cd_Tp_Moeda, 
			Nome_Tp_Moeda, 
			Vlr_Org_HIM, 
			Dt_Prev_Pgto_HIM, 
			Cd_Cred_Dev_HiM, 
			Apelido, 
			Desp_Org_HIM, 
			CPMF_HIM, 
			Comp_RP_HIM, 
			Comp_DN_HIM, 
			Comp_CN_HIM, 
			Comp_CPA_HIM,
			Num_DCN_HIM
		From  	
			Cta_Cte_Hou_Imp_Mar, 
			Tipo_Taxa, 
			Tipo_Moeda, 
			Pessoa 
		Where 
			Cta_Cte_Hou_Imp_Mar.Num_Proc_HIM = @Num_Proc and 
			Cta_Cte_Hou_Imp_Mar.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx and  
			Cta_Cte_Hou_Imp_Mar.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda and  
			Cd_Cred_Dev_HIM = Cd_Pes and 
			Comp_RP_HIM = @RP_HIM
			
		Order by  
			Nome_Tp_Tx, DC_HIM
GO
