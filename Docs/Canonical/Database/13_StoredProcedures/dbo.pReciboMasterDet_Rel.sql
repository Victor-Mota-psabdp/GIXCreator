SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pReciboMasterDet_Rel 
(
@Num_Proc	VarChar(16),
@Recibo	VarChar(12) 
)
 AS
	If left(@Num_Proc, 2) = 'EA' 
		Begin 
			Select 
				Ttx.Nome_Tp_Tx as Taxa , Cta.DC_MEA as DC, Cta.Desp_Dst_MEA as Origem,   Cta.Cd_Tp_Moeda as Cod_Moeda, Cta.Cd_Tp_Moeda as Moeda,
				Cta.Vlr_Org_MEA as Refer,  Cxa.Vlr_Ref_MEA as Parcela,   Cxa.Par_Moeda_MEA  as Paridade, Cxa.Vlr_Pgto_Rcto_MEA as ValorPago, 
				Sum(Tot.Vlr_Pgto_Rcto_MEA) as Saldo
			From 
				Cta_Cte_Mas_Exp_Aer As Cta Left Outer Join Caixa_Mas_Exp_Aer as Cxa on (Cta.Num_Proc_MEA = Cxa.Num_Proc_MEA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MEA = Cxa.DC_MEA )
				Left Outer Join Caixa_Mas_Exp_Aer as Tot on  (Cta.Num_Proc_MEA = Tot.Num_Proc_MEA and Cta.Cd_Tp_Tx = Tot.Cd_Tp_Tx and  Cta.DC_MEA = Tot.DC_MEA and Cxa.Num_Lcto <> Tot.Num_Lcto and Tot.Num_Lcto <> 'PROVISÓRIO')
				Left Outer Join Tipo_taxa Ttx on Cta.Cd_Tp_Tx = Ttx.Cd_Tp_Tx 
			Where 
				Cxa.Num_Rcb_MEA = @Recibo
			Group By 
				Ttx.Nome_Tp_Tx, Cta.DC_MEA, Cta.Desp_Dst_MEA, Cta.Cd_Tp_Moeda, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_MEA, Cxa.Vlr_Ref_MEA, Cxa.Par_Moeda_MEA, Cxa.Vlr_Pgto_Rcto_MEA, TTx.IRRF_Tx
		End 
	If left(@Num_Proc, 2) = 'EM' 
		Begin 
			Select 
				Ttx.Nome_Tp_Tx as Taxa , Cta.DC_MEM as DC, Desp_Dst_MEM as Origem, Cta.Cd_Tp_Moeda as Cod_Moeda, Cta.Cd_Tp_Moeda as Moeda,
				Cta.Vlr_Org_MEM as Refer, Cxa.Vlr_Ref_MEM as Parcela, Cxa.Par_Moeda_MEM as Paridade, Cxa.Vlr_Pgto_Rcto_MEM as ValorPago, 
				Sum(Tot.Vlr_Pgto_Rcto_MEM) as Saldo
			From 
				Cta_Cte_Mas_Exp_Mar As Cta Left Outer Join Caixa_Mas_Exp_Mar as Cxa on (Cta.Num_Proc_MEM = Cxa.Num_Proc_MEM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MEM = Cxa.DC_MEM )
				Left Outer Join Caixa_Mas_Exp_Mar as Tot on  (Cta.Num_Proc_MEM = Tot.Num_Proc_MEM and Cta.Cd_Tp_Tx = Tot.Cd_Tp_Tx and Cta.DC_MEM = Tot.DC_MEM  and Cxa.Num_Lcto <> Tot.Num_Lcto and Tot.Num_Lcto <> 'PROVISÓRIO')
				Left Outer Join Tipo_taxa Ttx on Cta.Cd_Tp_Tx = Ttx.Cd_Tp_Tx 
			Where 
				Cxa.Num_Rcb_MEM = @Recibo
			Group By 
				Ttx.Nome_Tp_Tx, Cta.DC_MEM, Desp_Dst_MEM, Cta.Cd_Tp_Moeda, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_MEM, Cxa.Vlr_Ref_MEM, Cxa.Par_Moeda_MEM, Cxa.Vlr_Pgto_Rcto_MEM, TTx.IRRF_Tx
		End 
	If left(@Num_Proc, 2) = 'IA' 
		Begin 
			Select 
				Ttx.Nome_Tp_Tx as Taxa , Cta.DC_MIA as DC, Desp_Org_MIA as Origem,  Cta.Cd_Tp_Moeda as Cod_Moeda, Cta.Cd_Tp_Moeda as Moeda,
				Cta.Vlr_Org_MIA as Refer, Cxa.Vlr_Ref_MIA as Parcela, Cxa.Par_Moeda_MIA  as Paridade, Cxa.Vlr_Pgto_Rcto_MIA as ValorPago, 
				Sum(Tot.Vlr_Pgto_Rcto_MIA) as Saldo
			From 
				Cta_Cte_Mas_Imp_Aer As Cta Left Outer Join Caixa_Mas_Imp_Aer as Cxa on (Cta.Num_Proc_MIA = Cxa.Num_Proc_MIA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MIA = Cxa.DC_MIA )
				Left Outer Join Caixa_Mas_Imp_Aer as Tot on  (Cta.Num_Proc_MIA = Tot.Num_Proc_MIA and Cta.Cd_Tp_Tx = Tot.Cd_Tp_Tx and Cta.DC_MIA = Tot.DC_MIA and Cxa.Num_Lcto <> Tot.Num_Lcto and Tot.Num_Lcto <> 'PROVISÓRIO')
				Left Outer Join Tipo_taxa Ttx on Cta.Cd_Tp_Tx = Ttx.Cd_Tp_Tx 
			Where 
				Cxa.Num_Rcb_MIA = @Recibo
			Group By 
				Ttx.Nome_Tp_Tx, Cta.DC_MIA, Desp_Org_MIA, Cta.Cd_Tp_Moeda, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_MIA, Cxa.Vlr_Ref_MIA, Cxa.Par_Moeda_MIA, Cxa.Vlr_Pgto_Rcto_MIA, TTx.IRRF_Tx
		End 
	If left(@Num_Proc, 2) = 'IM' 
		Begin 
			Select 
				Ttx.Nome_Tp_Tx as Taxa , Cta.DC_MIM  as DC, Desp_Org_MIM as Origem,  Cta.Cd_Tp_Moeda as Cod_Moeda, Cta.Cd_Tp_Moeda as Moeda,
				Cta.Vlr_Org_MIM as Refer, Cxa.Vlr_Ref_MIM as Parcela, Cxa.Par_Moeda_MIM as Paridade, Cxa.Vlr_Pgto_Rcto_MIM as ValorPago, 
				Sum(Tot.Vlr_Pgto_Rcto_MIM) as Saldo
			From 
				Cta_Cte_Mas_Imp_Mar As Cta left outer Join Caixa_Mas_Imp_Mar as Cxa on (Cta.Num_Proc_MIM = Cxa.Num_Proc_MIM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MIM = Cxa.DC_MIM )
				Left Outer Join Caixa_Mas_Imp_Mar as Tot on  (Cta.Num_Proc_MIM = Tot.Num_Proc_MIM and Cta.Cd_Tp_Tx = Tot.Cd_Tp_Tx and Cta.DC_MIM = Tot.DC_MIM and Cxa.Num_Lcto <> Tot.Num_Lcto and Tot.Num_Lcto <> 'PROVISÓRIO')
				Left Outer Join Tipo_taxa Ttx on Cta.Cd_Tp_Tx = Ttx.Cd_Tp_Tx 
			Where 
				Cxa.Num_Rcb_MIM = @Recibo
			Group By 
				Ttx.Nome_Tp_Tx, Cta.DC_MIM, Desp_Org_MIM, Cta.Cd_Tp_Moeda, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_MIM, Cxa.Vlr_Ref_MIM, Cxa.Par_Moeda_MIM, Cxa.Vlr_Pgto_Rcto_MIM, TTx.IRRF_Tx
		End



GO
