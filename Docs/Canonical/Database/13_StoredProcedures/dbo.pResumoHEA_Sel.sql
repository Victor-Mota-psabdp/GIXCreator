SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE PROCEDURE pResumoHEA_Sel
(
@Num_Proc		VarChar(14)
)
 AS
	Select  
		HEA.Num_Proc_HEA, HEA.HAWB_HEA, Export.Apelido as Exportador, Consig.Apelido as Consignatario,
		TT.Nome_Tp_Tx, Cta.DC_HEA, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_HEA, Cta.Desp_Dst_HEA,
		P.Apelido as CredDev, Cx.Num_Lcto, Cx.Vlr_Ref_HEA, Cx.Par_Moeda_HEA, Cx.Vlr_Pgto_Rcto_HEA, 
		Cx.Dt_Pgto_Rcto_HEA, HEA.Tp_Frete_HEA, HEA.Cd_Tp_Moeda, HEA.Vlr_Frete_Tot_HEA, HEA.Peso_Bruto_HEA,
		Tx_Refer_MEA Par_Modal, Tx_Refer_MEA Par_Oficial, Cta.Comp_RP_HEA PgtRct
	From 	
		House_Exp_Aer as HEA Join Cta_cte_Hou_exp_Aer as Cta on HEA.Num_Proc_HEA = Cta.Num_Proc_HEA
		Left outer join caixa_hou_exp_aer as Cx on (Cta.Num_Proc_HEA = Cx.Num_Proc_HEA and 
			Cta.Cd_Tp_Tx = Cx.Cd_Tp_Tx and Cta.DC_HEA = Cx.DC_HEA) 
		Left Outer Join Pessoa as P on Cta.Cd_Cred_Dev_HEA = P.Cd_Pes 
		Left Outer Join Tipo_Taxa as TT on Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx
		Left Outer Join Pessoa As Export on HEA.Cd_Export_HEA = Export.Cd_Pes 
		Left Outer Join Pessoa As  Consig on HEA.Cd_Consig_HEA = Consig.Cd_Pes  
		Join Master_Exp_Aer MEA on MEA.Num_Proc_MEA = HEA.Num_Proc_Mea
		--Left Outer Join Paridade ParModal on PArModal.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and PArModal.Dt_Par = dbo.StrHoje(getdate()) and ParModal.Cd_Tp_Par = 'EXA'
		--Left Outer Join Paridade ParOficial on ParOficial.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and ParOficial.Dt_Par = dbo.StrHoje(getdate()) and ParOficial.Cd_Tp_Par = 'OFC'

	Where 
		HEA.Num_proc_MEA = @Num_Proc and 
		Cta.Desp_Dst_HEA = 'N'
GO
