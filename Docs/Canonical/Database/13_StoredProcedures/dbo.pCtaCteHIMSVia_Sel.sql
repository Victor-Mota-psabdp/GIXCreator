SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pCtaCteHIMSVia_Sel 
(
@Num_Proc		VarChar(16)
)
 AS
	Select  
		Num_Proc_HIM, Cta.Cd_Tp_Tx, Nome_Tp_Tx, Nome_Tp_Tx_Ing,	DC_HIM, Org_Ins_HIM, Dt_Ins_HIM, 
		Cta.Cd_Tp_Moeda, Nome_Tp_Moeda, Vlr_Org_HIM, Dt_Prev_Pgto_HIM, Cd_Cred_Dev_HiM, Apelido, 
		Desp_Org_HIM, CPMF_HIM, Comp_RP_HIM, Comp_DN_HIM, Comp_CN_HIM, Comp_CPA_HIM,Num_DCN_HIM,
		Cd_Moeda_Ofc
	From  	
		Cta_Cte_Hou_Imp_Mar as Cta Join Tipo_Taxa as TT on Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx 
		Join Tipo_Moeda as TM on Cta.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
		Join Pessoa on Cta.Cd_Cred_Dev_HIM = Cd_Pes 
	Where 
		Cta.Num_Proc_HIM = @Num_Proc and 
		(Cta.Cd_Tp_Tx = 'FRT' or Cta.CPMF_HIM = 'S') and 
		Cta.DC_HIM = 'C'
	Order by  
		Nome_Tp_Tx, DC_HIM



GO
