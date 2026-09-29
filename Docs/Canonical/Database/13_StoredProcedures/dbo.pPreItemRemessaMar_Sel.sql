SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pPreItemRemessaMar_Sel  
(
@Num_Proc		VarChar(16),
@Cd_Cred_Dev		VarChar(10) 
)
AS
	If Left(@Num_Proc, 2) = 'EM'
		Select 
			Cte.Num_Proc_HEM, Cte.Cd_Tp_Tx, Cte.DC_HEM, Cte.Org_Ins_HEM, Cte.Dt_Ins_HEM, Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HEM, Cte.Dt_Prev_Pgto_HEM, 
			Cte.Cd_Cred_Dev_HEM, Cte.Desp_Dst_HEM, Cte.CPMF_HEM, Cte.Comp_RP_HEM, Cte.Comp_DN_HEM, Cte.Comp_CN_HEM, 
			Cxa.Num_Lcto, Cxa.Vlr_Ref_HEM, Cxa.Dt_Conv_HEM, Cxa.Cd_Tp_Par, Cxa.Par_Moeda_HEM, Cxa.Vlr_Pgto_Rcto_HEM, Cxa.Dt_Pgto_Rcto_HEM, 
			Cxa.Num_ND_HEM, Cxa.Num_Bx_HEM, Cxa.Num_NF_HEM, Cxa.Num_Rcb_HEM, TM.Nome_Tp_Moeda, Nome_Tp_Tx, 
			Cte.Num_Proc_HEM + '-' + Cte.DC_HEM + '-' +  Cte.Cd_Tp_Tx as Seq 
		From 
			Cta_Cte_Hou_Exp_Mar as Cte Left Outer Join Caixa_Hou_Exp_Mar as Cxa on (Cte.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HEM = Cxa.DC_HEM)
			Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx 
			Join Tipo_Moeda as TM on Cte.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
		Where
			Cte.Num_Proc_HEM = @Num_Proc and 
			Cd_Cred_Dev_HEM = @Cd_Cred_Dev and 
			((Cte.Cd_Tp_Tx = 'FRT' and Cte.DC_HEM = 'D') Or Cte.Cd_Tp_Tx = 'PBD' Or Cte.Cd_Tp_Tx = 'PSA' Or Comp_CN_HEM = 'S' Or Comp_DN_HEM = 'S')
	Else
		Begin 
			If Left(@Num_Proc, 2) = 'IM'
				Select 
					Cte.Num_Proc_HIM, Cte.Cd_Tp_Tx, Cte.DC_HIM, Cte.Org_Ins_HIM, Cte.Dt_Ins_HIM, Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HIM, Cte.Dt_Prev_Pgto_HIM, 
					Cte.Cd_Cred_Dev_HIM, Cte.Desp_Org_HIM, Cte.CPMF_HIM, Cte.Comp_RP_HIM, Cte.Comp_DN_HIM, Cte.Comp_CN_HIM, 
					Cxa.Num_Lcto, Cxa.Vlr_Ref_HIM, Cxa.Dt_Conv_HIM, Cxa.Cd_Tp_Par, Cxa.Par_Moeda_HIM, Cxa.Vlr_Pgto_Rcto_HIM, Cxa.Dt_Pgto_Rcto_HIM, 
					Cxa.Num_ND_HIM, Cxa.Num_Bx_HIM, Cxa.Num_NF_HIM, Cxa.Num_Rcb_HIM, TM.Nome_Tp_Moeda, Nome_Tp_Tx ,
					Cte.Num_Proc_HIM + '-' + Cte.DC_HIM + '-' + Cte.Cd_Tp_Tx as Seq 
				From 
					Cta_Cte_Hou_Imp_Mar as Cte Left Outer Join Caixa_Hou_Imp_Mar as Cxa on (Cte.Num_Proc_HIM = Cxa.Num_Proc_HIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HIM = Cxa.DC_HIM)
					Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx 
					Join Tipo_Moeda as TM on Cte.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
				Where
					Cte.Num_Proc_HIM = @Num_Proc and 
					Cd_Cred_Dev_HIM = @Cd_Cred_Dev and 
					((Cte.Cd_Tp_Tx = 'FRT' and Cte.DC_HIM = 'D') Or Cte.Cd_Tp_Tx = 'PBD' Or Cte.Cd_Tp_Tx = 'PSA' Or Comp_CN_HIM = 'S' Or Comp_DN_HIM = 'S')
		End

GO
