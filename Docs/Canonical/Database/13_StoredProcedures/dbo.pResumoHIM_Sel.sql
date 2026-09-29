SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pResumoHIM_Sel
(
@Num_Proc		VarChar(14)
)
 AS
	Select  
		HIM.Num_Proc_HIM, HIM.HAWB_HIM, Import.Apelido as Importador, Consig.Apelido as Consignatario,
		Export.Apelido as Exportador, TT.Nome_Tp_Tx, Cta.DC_HIM, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_HIM,
		P.Apelido as CredDev, Cx.Num_Lcto, Cx.Vlr_Ref_HIM, Cx.Par_Moeda_HIM, Cx.Vlr_Pgto_Rcto_HIM, 
		Cx.Dt_Pgto_Rcto_HIM, HIM.Tp_Frete_HIM, HIM.Cd_Tp_Moeda, HIM.Vlr_Frete_Efet_HIM, HIM.Peso_Bruto_HIM,
		ParModal.Par_Moeda Par_Modal, ParOficial.Par_Moeda Par_Oficial, Cta.Comp_RP_HIM PgtRct
	From 	
		House_Imp_Mar as HIM Join Cta_Cte_Hou_Imp_Mar as Cta on HIM.Num_Proc_HIM = Cta.Num_Proc_HIM
		Left outer join Caixa_Hou_Imp_Mar as Cx on (Cta.Num_Proc_HIM = Cx.Num_Proc_HIM and 
			Cta.Cd_Tp_Tx = Cx.Cd_Tp_Tx and Cta.DC_HIM = Cx.DC_HIM) 
		Left Outer Join Pessoa as P on Cta.Cd_Cred_Dev_HIM = P.Cd_Pes 
		Left Outer Join Tipo_Taxa as TT on Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx
		Left Outer Join Pessoa As Import on HIM.Cd_Import_HIM = Import.Cd_Pes 
		Left Outer Join Pessoa As  Consig on HIM.Cd_Consig_HIM = Consig.Cd_Pes  
		Left Outer Join Pessoa As  Export on HIM.Cd_Export_HIM = Export.Cd_Pes  
		Left Outer Join Paridade ParModal on PArModal.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and PArModal.Dt_Par = dbo.StrHoje(getdate()) and ParModal.Cd_Tp_Par = 'IMM'
		Left Outer Join Paridade ParOficial on ParOficial.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and ParOficial.Dt_Par = dbo.StrHoje(getdate()) and ParOficial.Cd_Tp_Par = 'OFC'

	Where 
		HIM.Num_proc_MIM = @Num_Proc and Cta.Desp_Org_HIM = 'N'
GO
