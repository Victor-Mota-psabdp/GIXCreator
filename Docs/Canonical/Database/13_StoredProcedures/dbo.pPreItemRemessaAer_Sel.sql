SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pPreItemRemessaAer_Sel  
(
@Num_Proc		VarChar(16),
@Cd_Cred_Dev		VarChar(10) 
)
AS
	If Left(@Num_Proc, 2) = 'EA'
		Select 
			Cte.Num_Proc_HEA, Cte.Cd_Tp_Tx, Cte.DC_HEA, Cte.Org_Ins_HEA, Cte.Dt_Ins_HEA, Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HEA, Cte.Dt_Prev_Pgto_HEA, 
			Cte.Cd_Cred_Dev_HEA, Cte.Desp_Dst_HEA, Cte.CPMF_HEA, Cte.Comp_RP_HEA, Cte.Comp_DN_HEA, Cte.Comp_CN_HEA, 
			Cxa.Num_Lcto, Cxa.Vlr_Ref_HEA, Cxa.Dt_Conv_HEA, Cxa.Cd_Tp_Par, Cxa.Par_Moeda_HEA, Cxa.Vlr_Pgto_Rcto_HEA, Cxa.Dt_Pgto_Rcto_HEA, 
			Cxa.Num_ND_HEA, Cxa.Num_Bx_HEA, Cxa.Num_NF_HEA, Cxa.Num_Rcb_HEA, TM.Nome_Tp_Moeda, Nome_Tp_Tx, 
			Cte.Num_Proc_HEA + '-' + Cte.DC_HEA + '-' +  Cte.Cd_Tp_Tx as Seq 
		From 
			Cta_Cte_Hou_Exp_Aer as Cte Left Outer Join Caixa_Hou_Exp_Aer as Cxa on (Cte.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HEA = Cxa.DC_HEA)
			Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx 
			Join Tipo_Moeda as TM on Cte.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
		Where
			Cte.Num_Proc_HEA = @Num_Proc and 
			Cd_Cred_Dev_HEA = @Cd_Cred_Dev and 
			((Cte.Cd_Tp_Tx = 'FRT' and Cte.DC_HEA = 'D') Or Cte.Cd_Tp_Tx = 'PBD' Or Cte.Cd_Tp_Tx = 'PSA' Or Comp_CN_HEA = 'S' Or Comp_DN_HEA = 'S')
	Else
		Begin 
			If Left(@Num_Proc, 2) = 'IA'
				Select 
					Cte.Num_Proc_HIA, Cte.Cd_Tp_Tx, Cte.DC_HIA, Cte.Org_Ins_HIA, Cte.Dt_Ins_HIA, Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HIA, Cte.Dt_Prev_Pgto_HIA, 
					Cte.Cd_Cred_Dev_HIA, Cte.Desp_Org_HIA, Cte.CPMF_HIA, Cte.Comp_RP_HIA, Cte.Comp_DN_HIA, Cte.Comp_CN_HIA, 
					Cxa.Num_Lcto, Cxa.Vlr_Ref_HIA, Cxa.Dt_Conv_HIA, Cxa.Cd_Tp_Par, Cxa.Par_Moeda_HIA, Cxa.Vlr_Pgto_Rcto_HIA, Cxa.Dt_Pgto_Rcto_HIA, 
					Cxa.Num_ND_HIA, Cxa.Num_Bx_HIA, Cxa.Num_NF_HIA, Cxa.Num_Rcb_HIA, TM.Nome_Tp_Moeda, Nome_Tp_Tx ,
					Cte.Num_Proc_HIA + '-' + Cte.DC_HIA + '-' + Cte.Cd_Tp_Tx as Seq 
				From 
					 Cta_Cte_Hou_Imp_Aer as Cte Left Outer Join Caixa_Hou_Imp_Aer as Cxa on (Cte.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HIA = Cxa.DC_HIA)
					Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx 
					Join Tipo_Moeda as TM on Cte.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
				Where
					Cte.Num_Proc_HIA = @Num_Proc and 
					Cd_Cred_Dev_HIA = @Cd_Cred_Dev and 
					((Cte.Cd_Tp_Tx = 'FRT' and Cte.DC_HIA = 'D') Or Cte.Cd_Tp_Tx = 'PBD' Or Cte.Cd_Tp_Tx = 'PSA' Or Comp_CN_HIA = 'S' Or Comp_DN_HIA = 'S')
		End

GO
