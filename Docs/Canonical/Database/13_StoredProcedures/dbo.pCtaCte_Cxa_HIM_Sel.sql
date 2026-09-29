SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCtaCte_Cxa_HIM_Sel
(
@Processo		VarChar(16)
)
 AS
	Select 
		Cxa.Num_Proc_HIM, Cte.Dt_Ins_HIM, Cte.Cd_Tp_Moeda, Ps.Apelido as CredDev, Cte.Desp_Org_HIM, Cte.Comp_DN_HIM, Cte.Comp_CN_HIM, 
		Cte.Comp_RP_HIM,Num_Rcb_HIM, Nome_Tp_Tx, Cxa.DC_HIM, Num_Lcto, Nome_Tp_Moeda, Vlr_Ref_HIM, Dt_Conv_HIM, Nome_Tp_Par, 
		Par_Moeda_HIM, Vlr_Pgto_Rcto_HIM, Dt_Pgto_Rcto_HIM, Cxa.Num_Rcb_HIM 
	From 
		Caixa_Hou_Imp_Mar as Cxa , Cta_Cte_Hou_Imp_Mar as Cte, Tipo_Taxa, Tipo_Moeda, Tipo_Paridade, Pessoa as Ps
	Where 
		Cxa.Num_Proc_HIM = @Processo and  
		Cxa.Num_Proc_HIM = Cte.Num_Proc_HIM and 
		Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and  
		Cxa.DC_HIM = Cte.DC_HIM and 
		Cxa.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx And
		Cte.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda and 
		Cxa.Cd_Tp_Par = Tipo_Paridade.Cd_Tp_Par and 
		Cte.Cd_Cred_Dev_HIM = Ps.Cd_Pes
	Order by 
		Nome_Tp_Tx, Cxa.DC_HIM, Num_Lcto



GO
