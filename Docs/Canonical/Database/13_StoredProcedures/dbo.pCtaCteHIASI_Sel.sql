SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pCtaCteHIASI_Sel 
(
@Num_Proc		VarChar(16) =''
)
 AS
 
		Select  
			Num_Proc_HIA, 
			Nome_Tp_Tx_Ing,
			Cta_Cte_Hou_Imp_Aer.Cd_Tp_Tx, 
			Nome_Tp_Tx, 
			DC_HIA, 
			Org_Ins_HIA, 
			Dt_Ins_HIA, 
			Cta_Cte_Hou_Imp_Aer.Cd_Tp_Moeda, 
			Nome_Tp_Moeda, 
			Vlr_Org_HIA, 
			Dt_Prev_Pgto_HIA, 
			Cd_Cred_Dev_HIA, 
			Desp_Org_HIA,
			Apelido, 
			Desp_Org_HIA
			CPMF_HIA, 
			Comp_RP_HIA, 
			Comp_DN_HIA, 
			Comp_CN_HIA, 
			Comp_CPA_HIA, 
			Num_DCN_HIA,
			Dt_Ctb_CC_HIA
		From  	
			Cta_Cte_Hou_Imp_Aer, 
			Tipo_Taxa, 
			Tipo_Moeda, 
			Pessoa 
		Where 	
			Num_Proc_HIA = @Num_Proc AND 
			Cta_Cte_Hou_Imp_Aer.DC_HIA = 'C' and 
			Cta_Cte_Hou_Imp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND 
			Cta_Cte_Hou_Imp_Aer.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda AND 
			Cd_Cred_Dev_HIA = Cd_Pes 
		Order by  
			Nome_Tp_Tx, DC_HIA

GO
