SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCtaCte_Cxa_MEM_Sel
(
@Processo		VarChar(16)
)
 AS
	Select 
		Cxa.Num_Proc_MEM, Cte.Dt_Ins_MEM, Cte.Cd_Tp_Moeda, Ps.Apelido as CredDev, Cte.Desp_Dst_MEM, Cte.Comp_DN_MEM, Cte.Comp_CN_MEM, 
		Cte.Comp_RP_MEM,Num_Rcb_MEM, Nome_Tp_Tx, Cxa.DC_MEM, Num_Lcto, Nome_Tp_Moeda, Vlr_Ref_MEM, Dt_Conv_MEM, Nome_Tp_Par, 
		Par_Moeda_MEM, Vlr_Pgto_Rcto_MEM, Dt_Pgto_Rcto_MEM, Cxa.Num_Rcb_MEM 
	From 
		Caixa_Mas_Exp_Mar as Cxa, Cta_Cte_Mas_Exp_Mar as Cte, Tipo_Taxa, Tipo_Moeda, Tipo_Paridade, Pessoa as Ps 
	Where 
		Cxa.Num_Proc_MEM = @Processo and  
		Cxa.Num_Proc_MEM = Cte.Num_Proc_MEM and 
		Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and  
		Cxa.DC_MEM = Cte.DC_MEM and 
		Cxa.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx And
		Cte.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda and 
		Cxa.Cd_Tp_Par = Tipo_Paridade.Cd_Tp_Par and 
		Cte.Cd_Cred_Dev_MEM = Ps.Cd_Pes
	Order by 
		Nome_Tp_Tx, Cxa.DC_MEM, Num_Lcto



GO
