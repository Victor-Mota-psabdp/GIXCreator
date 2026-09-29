SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pReciboHouseDet_Rel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE [dbo].[pReciboHouseDet_Rel] 
(
@Num_Proc	VarChar(16),
@Recibo	VarChar(12) 
)
 AS
	If left(@Num_Proc, 2) = 'EA' 
		Begin 
			Select 
				Ttx.Nome_Tp_Tx as Taxa , Cta.DC_HEA as DC, Cta.Desp_Dst_HEA as Origem,   Cta.Cd_Tp_Moeda as Cod_Moeda, Cta.Cd_Tp_Moeda as Moeda,
				Cta.Vlr_Org_HEA as Refer,  Cxa.Vlr_Ref_HEA as Parcela,   Cxa.Par_Moeda_HEA  as Paridade, Cxa.Vlr_Pgto_Rcto_HEA as ValorPago, 
				Sum(Tot.Vlr_Pgto_Rcto_HEA) as Saldo
			From 
				Cta_Cte_Hou_Exp_Aer As Cta Left Outer Join Caixa_Hou_Exp_Aer as Cxa on (Cta.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEA = Cxa.DC_HEA )
				Left Outer Join Caixa_Hou_Exp_Aer as Tot on  (Cta.Num_Proc_HEA = Tot.Num_Proc_HEA and Cta.Cd_Tp_Tx = Tot.Cd_Tp_Tx and  Cta.DC_HEA = Tot.DC_HEA and Cxa.Num_Lcto <> Tot.Num_Lcto and Tot.Num_Lcto <> 'PROVISÓRIO')
				Left Outer Join Tipo_taxa Ttx on Cta.Cd_Tp_Tx = Ttx.Cd_Tp_Tx 
			Where 
				Cxa.Num_Rcb_HEA = @Recibo
			Group By 
				Ttx.Nome_Tp_Tx, Cta.DC_HEA, Cta.Desp_Dst_HEA, Cta.Cd_Tp_Moeda, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_HEA, Cxa.Vlr_Ref_HEA, Cxa.Par_Moeda_HEA, Cxa.Vlr_Pgto_Rcto_HEA, TTx.IRRF_Tx
		End 

	If left(@Num_Proc, 2) = 'EO' 
		Begin 
			Select 
				Ttx.Nome_Tp_Tx as Taxa , Cta.DC_HEO as DC, Cta.Desp_Org_HEO as Origem,   Cta.Cd_Tp_Moeda as Cod_Moeda, Cta.Cd_Tp_Moeda as Moeda,
				Cta.Vlr_Org_HEO as Refer,  Cxa.Vlr_Ref_HEO as Parcela,   Cxa.Par_Moeda_HEO  as Paridade, Cxa.Vlr_Pgto_Rcto_HEO as ValorPago, 
				Sum(Tot.Vlr_Pgto_Rcto_HEO) as Saldo
			From 
				Cta_Cte_Hou_Exp_Out As Cta Left Outer Join Caixa_Hou_Exp_Out as Cxa on (Cta.Num_Proc_HEO = Cxa.Num_Proc_HEO and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEO = Cxa.DC_HEO )
				Left Outer Join Caixa_Hou_Exp_Out as Tot on  (Cta.Num_Proc_HEO = Tot.Num_Proc_HEO and Cta.Cd_Tp_Tx = Tot.Cd_Tp_Tx and  Cta.DC_HEO = Tot.DC_HEO and Cxa.Num_Lcto <> Tot.Num_Lcto and Tot.Num_Lcto <> 'PROVISÓRIO')
				Left Outer Join Tipo_taxa Ttx on Cta.Cd_Tp_Tx = Ttx.Cd_Tp_Tx 
			Where 
				Cxa.Num_Rcb_HEO = @Recibo
			Group By 
				Ttx.Nome_Tp_Tx, Cta.DC_HEO, Cta.Desp_Org_HEO, Cta.Cd_Tp_Moeda, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_HEO, Cxa.Vlr_Ref_HEO, Cxa.Par_Moeda_HEO, Cxa.Vlr_Pgto_Rcto_HEO, TTx.IRRF_Tx
		End 

	If left(@Num_Proc, 2) = 'EM' 
		Begin 
			Select 
				Ttx.Nome_Tp_Tx as Taxa , Cta.DC_HEM as DC, Desp_Dst_HEM as Origem, Cta.Cd_Tp_Moeda as Cod_Moeda, Cta.Cd_Tp_Moeda as Moeda,
				Cta.Vlr_Org_HEM as Refer, Cxa.Vlr_Ref_HEM as Parcela, Cxa.Par_Moeda_HEM as Paridade, Cxa.Vlr_Pgto_Rcto_HEM as ValorPago, 
				Sum(Tot.Vlr_Pgto_Rcto_HEM) as Saldo
			From 
				Cta_Cte_Hou_Exp_Mar As Cta Left Outer Join Caixa_Hou_Exp_Mar as Cxa on (Cta.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEM = Cxa.DC_HEM )
				Left Outer Join Caixa_Hou_Exp_Mar as Tot on  (Cta.Num_Proc_HEM = Tot.Num_Proc_HEM and Cta.Cd_Tp_Tx = Tot.Cd_Tp_Tx and Cta.DC_HEM = Tot.DC_HEM  and Cxa.Num_Lcto <> Tot.Num_Lcto and Tot.Num_Lcto <> 'PROVISÓRIO')
				Left Outer Join Tipo_taxa Ttx on Cta.Cd_Tp_Tx = Ttx.Cd_Tp_Tx 
			Where 
				Cxa.Num_Rcb_HEM = @Recibo
			Group By 
				Ttx.Nome_Tp_Tx, Cta.DC_HEM, Desp_Dst_HEM, Cta.Cd_Tp_Moeda, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_HEM, Cxa.Vlr_Ref_HEM, Cxa.Par_Moeda_HEM, Cxa.Vlr_Pgto_Rcto_HEM, TTx.IRRF_Tx
		End 
	If left(@Num_Proc, 2) = 'IA' 
		Begin 
			Select 
				Ttx.Nome_Tp_Tx as Taxa , Cta.DC_HIA as DC, Desp_Org_HIA as Origem,  Cta.Cd_Tp_Moeda as Cod_Moeda, Cta.Cd_Tp_Moeda as Moeda,
				Cta.Vlr_Org_HIA as Refer, Cxa.Vlr_Ref_HIA as Parcela, Cxa.Par_Moeda_HIA  as Paridade, Cxa.Vlr_Pgto_Rcto_HIA as ValorPago, 
				Sum(Tot.Vlr_Pgto_Rcto_HIA) as Saldo
			From 
				Cta_Cte_Hou_Imp_Aer As Cta Left Outer Join Caixa_Hou_Imp_Aer as Cxa on (Cta.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIA = Cxa.DC_HIA )
				Left Outer Join Caixa_Hou_Imp_Aer as Tot on  (Cta.Num_Proc_HIA = Tot.Num_Proc_HIA and Cta.Cd_Tp_Tx = Tot.Cd_Tp_Tx and Cta.DC_HIA = Tot.DC_HIA and Cxa.Num_Lcto <> Tot.Num_Lcto and Tot.Num_Lcto <> 'PROVISÓRIO')
				Left Outer Join Tipo_taxa Ttx on Cta.Cd_Tp_Tx = Ttx.Cd_Tp_Tx 
			Where 
				Cxa.Num_Rcb_HIA = @Recibo
			Group By 
				Ttx.Nome_Tp_Tx, Cta.DC_HIA, Desp_Org_HIA, Cta.Cd_Tp_Moeda, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_HIA, Cxa.Vlr_Ref_HIA, Cxa.Par_Moeda_HIA, Cxa.Vlr_Pgto_Rcto_HIA, TTx.IRRF_Tx
		End 
	If left(@Num_Proc, 2) = 'IM' 
		Begin 
			Select 
				Ttx.Nome_Tp_Tx as Taxa , Cta.DC_HIM  as DC, Desp_Org_HIM as Origem,  Cta.Cd_Tp_Moeda as Cod_Moeda, Cta.Cd_Tp_Moeda as Moeda,
				Cta.Vlr_Org_HIM as Refer, Cxa.Vlr_Ref_HIM as Parcela, Cxa.Par_Moeda_HIM as Paridade, Cxa.Vlr_Pgto_Rcto_HIM as ValorPago, 
				Sum(Tot.Vlr_Pgto_Rcto_HIM) as Saldo
			From 
				Cta_Cte_Hou_Imp_Mar As Cta left outer Join Caixa_Hou_Imp_Mar as Cxa on (Cta.Num_Proc_HIM = Cxa.Num_Proc_HIM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIM = Cxa.DC_HIM )
				Left Outer Join Caixa_Hou_Imp_Mar as Tot on  (Cta.Num_Proc_HIM = Tot.Num_Proc_HIM and Cta.Cd_Tp_Tx = Tot.Cd_Tp_Tx and Cta.DC_HIM = Tot.DC_HIM and Cxa.Num_Lcto <> Tot.Num_Lcto and Tot.Num_Lcto <> 'PROVISÓRIO')
				Left Outer Join Tipo_taxa Ttx on Cta.Cd_Tp_Tx = Ttx.Cd_Tp_Tx 
			Where 
				Cxa.Num_Rcb_HIM = @Recibo
			Group By 
				Ttx.Nome_Tp_Tx, Cta.DC_HIM, Desp_Org_HIM, Cta.Cd_Tp_Moeda, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_HIM, Cxa.Vlr_Ref_HIM, Cxa.Par_Moeda_HIM, Cxa.Vlr_Pgto_Rcto_HIM, TTx.IRRF_Tx
		End

	If left(@Num_Proc, 2) = 'IO' 
		Begin 
			Select 
				Ttx.Nome_Tp_Tx as Taxa , Cta.DC_HIO  as DC, Desp_Org_HIO as Origem,  Cta.Cd_Tp_Moeda as Cod_Moeda, Cta.Cd_Tp_Moeda as Moeda,
				Cta.Vlr_Org_HIO as Refer, Cxa.Vlr_Ref_HIO as Parcela, Cxa.Par_Moeda_HIO as Paridade, Cxa.Vlr_Pgto_Rcto_HIO as ValorPago, 
				Sum(Tot.Vlr_Pgto_Rcto_HIO) as Saldo
			From 
				Cta_Cte_Hou_Imp_Out As Cta left outer Join Caixa_Hou_Imp_Out as Cxa on (Cta.Num_Proc_HIO = Cxa.Num_Proc_HIO and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIO = Cxa.DC_HIO )
				Left Outer Join Caixa_Hou_Imp_Out as Tot on  (Cta.Num_Proc_HIO = Tot.Num_Proc_HIO and Cta.Cd_Tp_Tx = Tot.Cd_Tp_Tx and Cta.DC_HIO = Tot.DC_HIO and Cxa.Num_Lcto <> Tot.Num_Lcto and Tot.Num_Lcto <> 'PROVISÓRIO')
				Left Outer Join Tipo_taxa Ttx on Cta.Cd_Tp_Tx = Ttx.Cd_Tp_Tx 
			Where 
				Cxa.Num_Rcb_HIO = @Recibo
			Group By 
				Ttx.Nome_Tp_Tx, Cta.DC_HIO, Desp_Org_HIO, Cta.Cd_Tp_Moeda, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_HIO, Cxa.Vlr_Ref_HIO, Cxa.Par_Moeda_HIO, Cxa.Vlr_Pgto_Rcto_HIO, TTx.IRRF_Tx
		End






GO
