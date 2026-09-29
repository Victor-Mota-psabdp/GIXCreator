SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCtaCteHEMSVia_Sel 
(
@Num_Proc		VarChar(16)
)
 AS
	Select  
		Num_Proc_HEM, Cta.Cd_Tp_Tx, Nome_Tp_Tx, Nome_Tp_Tx_Ing,DC_HEM, Org_Ins_HEM, Dt_Ins_HEM, 
		Cta.Cd_Tp_Moeda, Nome_Tp_Moeda, Vlr_Org_HEM, Dt_Prev_Pgto_HEM, Cd_Cred_Dev_HEM, Apelido, 
		Desp_Dst_HEM, CPMF_HEM, Comp_RP_HEM, Comp_DN_HEM, Comp_CN_HEM, Comp_CPA_HEM,Num_DCN_HEM,
		Cd_Moeda_Ofc
	From  	
		Cta_Cte_Hou_Exp_Mar as Cta Join Tipo_Taxa as TT on Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx 
		Join Tipo_Moeda as TM on Cta.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
		Join Pessoa on Cta.Cd_Cred_Dev_HEM = Cd_Pes 
	Where 
		Cta.Num_Proc_HEM = @Num_Proc and 
		(Cta.Cd_Tp_Tx = 'FRT' or Cta.CPMF_HEM = 'S') and 
		Cta.DC_HEM = 'C'
	Order by  
		Nome_Tp_Tx, DC_HEM



GO
