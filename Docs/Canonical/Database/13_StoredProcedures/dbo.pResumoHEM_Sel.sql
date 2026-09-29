SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE pResumoHEM_Sel
(
@Num_Proc		VarChar(14)
)
 AS
	Select  
		HEM.Num_Proc_HEM, HEM.HAWB_HEM, Export.Apelido as Exportador, Consig.Apelido as Consignatario,
		TT.Nome_Tp_Tx, Cta.DC_HEM, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_HEM, Cta.Desp_Dst_HEM,
		P.Apelido as CredDev, Cx.Num_Lcto, Cx.Vlr_Ref_HEM, Cx.Par_Moeda_HEM, Cx.Vlr_Pgto_Rcto_HEM, 
		Cx.Dt_Pgto_Rcto_HEM, HEM.Tp_Frete_HEM, HEM.Cd_Tp_Moeda, HEM.Vlr_Frete_Tot_HEM, HEM.Peso_Bruto_HEM,
		ParModal.Par_Moeda Par_Modal, ParOficial.Par_Moeda Par_Oficial, Cta.Comp_RP_HEM PgtRct
	From 	
		House_Exp_Mar as HEM Join Cta_cte_Hou_exp_mar as Cta on HEM.Num_Proc_HEM = Cta.Num_Proc_HEM
		Left outer join caixa_hou_exp_mar as Cx on (Cta.Num_Proc_HEM = Cx.Num_Proc_HEM and 
			Cta.Cd_Tp_Tx = Cx.Cd_Tp_Tx and Cta.DC_HEM = Cx.DC_HEM) 
		Left Outer Join Pessoa as P on Cta.Cd_Cred_Dev_HEM = P.Cd_Pes 
		Left Outer Join Tipo_Taxa as TT on Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx
		Left Outer Join Pessoa As Export on HEM.Cd_Export_HEM = Export.Cd_Pes 
		Left Outer Join Pessoa As  Consig on HEM.Cd_Consig_HEM = Consig.Cd_Pes  
		Left Outer Join Paridade ParModal on PArModal.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and PArModal.Dt_Par = dbo.StrHoje(getdate()) and ParModal.Cd_Tp_Par = 'EXM'
		Left Outer Join Paridade ParOficial on ParOficial.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and ParOficial.Dt_Par = dbo.StrHoje(getdate()) and ParOficial.Cd_Tp_Par = 'OFC'

	Where 
		HEM.Num_proc_MEM = @Num_Proc  and 
		Cta.Desp_Dst_HEM = 'N'
GO
