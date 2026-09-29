SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pResumoMEA_Sel
(
@Num_Proc		VarChar(14)
)
 AS
	Select  
		MEA.Tp_Frete_MEA, TT.Nome_Tp_Tx, Cta.DC_MEA, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_MEA, P.Apelido as CredDev, 	
		Cx.Num_Lcto, Cx.Vlr_Ref_MEA, Cx.Par_Moeda_MEA, Cx.Vlr_Pgto_Rcto_MEA, 
		Cx.Dt_Pgto_Rcto_MEA, 		ParModal.Par_Moeda Par_Modal, ParOficial.Par_Moeda Par_Oficial, Cta.Comp_RP_MEA PgtRct
	From 	
		Master_Exp_Aer as MEA Join Cta_Cte_Mas_Exp_Aer as Cta on MEA.Num_Proc_MEA = Cta.Num_Proc_MEA
		Left outer join Caixa_Mas_Exp_Aer as Cx on (Cta.Num_Proc_MEA = Cx.Num_Proc_MEA and 
			Cta.Cd_Tp_Tx = Cx.Cd_Tp_Tx and Cta.DC_MEA = Cx.DC_MEA) 
		Left Outer Join Pessoa as P on Cta.Cd_Cred_Dev_MEA = P.Cd_Pes 
		Left Outer Join Tipo_Taxa as TT on Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx
		Left Outer Join Paridade ParModal on PArModal.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and PArModal.Dt_Par = dbo.StrHoje(getdate()) and ParModal.Cd_Tp_Par = 'EXA'
		Left Outer Join Paridade ParOficial on ParOficial.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and ParOficial.Dt_Par = dbo.StrHoje(getdate()) and ParOficial.Cd_Tp_Par = 'OFC'
	Where 
		Cta.Num_proc_MEA = @Num_Proc and 
		Cta.Desp_Dst_MEA = 'N'
GO
