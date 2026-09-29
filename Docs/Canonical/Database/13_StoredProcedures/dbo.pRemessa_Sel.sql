SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pRemessa_Sel 
(
@Num_Remessa	VarChar(12)
)
AS
	If Left(@Num_Remessa,2) = 'RA'
		Begin
			Select  
				Cta.Num_Proc_HEA as Num_Proc, Nome_Tp_Tx as Nome_Taxa, Cta.DC_HEA as DC, Nome_Tp_Moeda as Moeda, 
				Vlr_Org_HEA as Valor_Org, Desp_Dst_HEA as Desp_Dst, Comp_DN_HEA as Comp_DN, Comp_CN_HEA as Comp_CN, 
				Num_DCN_HEA as Num_DCN, Par_Moeda_HEA as Paridade, Vlr_Pgto_Rcto_HEA as Valor_Pgto, Dt_Pgto_Rcto_HEA as Dt_Pgto
			From  
				Cta_Cte_Hou_Exp_Aer as Cta Join Caixa_Hou_Exp_Aer as Cxa on (Cta.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEA = Cxa.DC_HEA) 
				Join Tipo_Taxa as TT on Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx 
				Join Tipo_Moeda as TM on Cta.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
			Where
				Num_Rcb_HEA =  @Num_Remessa 

			Union

			Select  
				Cta.Num_Proc_HIA as Num_Proc, Nome_Tp_Tx as Nome_Taxa, Cta.DC_HIA as DC, Nome_Tp_Moeda as Moeda, 
				Vlr_Org_HIA as Valor_Org, Desp_Org_HIA as Desp_Dst, Comp_DN_HIA as Comp_DN, Comp_CN_HIA as Comp_CN, 
				Num_DCN_HIA as Num_DCN, Par_Moeda_HIA as Paridade, Vlr_Pgto_Rcto_HIA as Valor_Pgto, Dt_Pgto_Rcto_HIA as Dt_Pgto
			From  
				Cta_Cte_Hou_Imp_Aer as Cta Join Caixa_Hou_Imp_Aer as Cxa on (Cta.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIA = Cxa.DC_HIA) 
				Join Tipo_Taxa as TT on Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx 
				Join Tipo_Moeda as TM on Cta.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
			Where
				Num_Rcb_HIA =  @Num_Remessa 


		End 
	Else 
		Begin 
			Select  
				Cta.Num_Proc_HEM as Num_Proc, Nome_Tp_Tx as Nome_Taxa, Cta.DC_HEM as DC, Nome_Tp_Moeda as Moeda, 
				Vlr_Org_HEM as Valor_Org, Desp_Dst_HEM as Desp_Dst, Comp_DN_HEM as Comp_DN, Comp_CN_HEM as Comp_CN, 
				Num_DCN_HEM as Num_DCN, Par_Moeda_HEM as Paridade, Vlr_Pgto_Rcto_HEM as Valor_Pgto, Dt_Pgto_Rcto_HEM as Dt_Pgto
			From  
				Cta_Cte_Hou_Exp_Mar as Cta Join Caixa_Hou_Exp_Mar as Cxa on (Cta.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEM = Cxa.DC_HEM) 
				Join Tipo_Taxa as TT on Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx 
				Join Tipo_Moeda as TM on Cta.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
			Where
				Num_Rcb_HEM =  @Num_Remessa 

			Union

			Select  
				Cta.Num_Proc_HIM as Num_Proc, Nome_Tp_Tx as Nome_Taxa, Cta.DC_HIM as DC, Nome_Tp_Moeda as Moeda, 
				Vlr_Org_HIM as Valor_Org, Desp_Org_HIM as Desp_Dst, Comp_DN_HIM as Comp_DN, Comp_CN_HIM as Comp_CN, 
				Num_DCN_HIM as Num_DCN, Par_Moeda_HIM as Paridade, Vlr_Pgto_Rcto_HIM as Valor_Pgto, Dt_Pgto_Rcto_HIM as Dt_Pgto
			From  
				Cta_Cte_Hou_Imp_Mar as Cta Join Caixa_Hou_Imp_Mar as Cxa on (Cta.Num_Proc_HIM = Cxa.Num_Proc_HIM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIM = Cxa.DC_HIM) 
				Join Tipo_Taxa as TT on Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx 
				Join Tipo_Moeda as TM on Cta.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
			Where
				Num_Rcb_HIM =  @Num_Remessa 

		End 

GO
