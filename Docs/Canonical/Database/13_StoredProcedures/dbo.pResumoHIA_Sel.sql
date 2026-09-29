SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pResumoHIA_Sel
(
@Num_Proc		VarChar(14)
)
 AS
	Select  
		HIA.Num_Proc_HIA, HIA.HAWB_HIA, Export.Apelido as Exportador, Consig.Apelido as Consignatario,
		TT.Nome_Tp_Tx, Cta.DC_HIA, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_HIA, Cta.Desp_Org_HIA,
		P.Apelido as CredDev, Cx.Num_Lcto, Cx.Vlr_Ref_HIA, Cx.Par_Moeda_HIA, Cx.Vlr_Pgto_Rcto_HIA, 
		Cx.Dt_Pgto_Rcto_HIA, HIA.Tp_Frete_HIA, HIA.Cd_Tp_Moeda, HIA.Vlr_Frete_Efet_HIA, HIA.Peso_Bruto_HIA,
		ParModal.Par_Moeda Par_Modal, ParOficial.Par_Moeda Par_Oficial, Cta.Comp_RP_HIA PgtRct
	From 	
		House_Imp_Aer as HIA Join Cta_cte_Hou_Imp_Aer as Cta on HIA.Num_Proc_HIA = Cta.Num_Proc_HIA
		Left outer join caixa_hou_imp_aer as Cx on (Cta.Num_Proc_HIA = Cx.Num_Proc_HIA and 
			Cta.Cd_Tp_Tx = Cx.Cd_Tp_Tx and Cta.DC_HIA = Cx.DC_HIA) 
		Left Outer Join Pessoa as P on Cta.Cd_Cred_Dev_HIA = P.Cd_Pes 
		Left Outer Join Tipo_Taxa as TT on Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx
		Left Outer Join Pessoa As Export on HIA.Cd_Export_HIA = Export.Cd_Pes 
		Left Outer Join Pessoa As  Consig on HIA.Cd_Consig_HIA = Consig.Cd_Pes  
		Left Outer Join Paridade ParModal on PArModal.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and PArModal.Dt_Par = dbo.StrHoje(getdate()) and ParModal.Cd_Tp_Par = 'IMA'
		Left Outer Join Paridade ParOficial on ParOficial.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and ParOficial.Dt_Par = dbo.StrHoje(getdate()) and ParOficial.Cd_Tp_Par = 'OFC'

	Where 
		HIA.Num_proc_MIA = @Num_Proc and 
		Cta.Desp_Org_HIA = 'N'
GO
