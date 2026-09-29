SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCtaCte_Cxa_MIM_Sel
(
@Processo		VarChar(16)
)
 AS
	Select 
		Cxa.Num_Proc_MIM, Cte.Dt_Ins_MIM, Cte.Cd_Tp_Moeda, Ps.Apelido as CredDev, Cte.Desp_Org_MIM, Cte.Comp_DN_MIM, Cte.Comp_CN_MIM, 
		Cte.Comp_RP_MIM,Num_Rcb_MIM, Nome_Tp_Tx, Cxa.DC_MIM, Num_Lcto, Nome_Tp_Moeda, Vlr_Ref_MIM, Dt_Conv_MIM, Nome_Tp_Par, 
		Par_Moeda_MIM, Vlr_Pgto_Rcto_MIM, Dt_Pgto_Rcto_MIM, Cxa.Num_Rcb_MIM 
	From 
		Caixa_Mas_Imp_Mar as Cxa , Cta_Cte_Mas_Imp_Mar as Cte, Tipo_Taxa, Tipo_Moeda, Tipo_Paridade, Pessoa as Ps
	Where 
		Cxa.Num_Proc_MIM = @Processo and  
		Cxa.Num_Proc_MIM = Cte.Num_Proc_MIM and 
		Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and  
		Cxa.DC_MIM = Cte.DC_MIM and 
		Cxa.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx And
		Cte.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda and 
		Cxa.Cd_Tp_Par = Tipo_Paridade.Cd_Tp_Par and 
		Cte.Cd_Cred_Dev_MIM = Ps.Cd_Pes
	Order by 
		Nome_Tp_Tx, Cxa.DC_MIM, Num_Lcto



GO
