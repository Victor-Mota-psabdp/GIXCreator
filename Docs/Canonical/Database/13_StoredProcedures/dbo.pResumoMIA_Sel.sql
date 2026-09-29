SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pResumoMIA_Sel
(
@Num_Proc		VarChar(14)
)
 AS
	Select  
		MIA.Tp_Frete_MIA, TT.Nome_Tp_Tx, Cta.DC_MIA, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_MIA, P.Apelido as CredDev, 	
		Cx.Num_Lcto, Cx.Vlr_Ref_MIA, Cx.Par_Moeda_MIA, Cx.Vlr_Pgto_Rcto_MIA, 
		Cx.Dt_Pgto_Rcto_MIA, 
		ParModal.Par_Moeda Par_Modal, ParOficial.Par_Moeda Par_Oficial, Cta.Comp_RP_MIA PgtRct
	From 	
		Master_Imp_Aer as MIA Join Cta_Cte_Mas_Imp_Aer as Cta on MIA.Num_Proc_MIA = Cta.Num_Proc_MIA
		Left outer join caixa_mas_imp_aer as Cx on (Cta.Num_Proc_MIA = Cx.Num_Proc_MIA and 
			Cta.Cd_Tp_Tx = Cx.Cd_Tp_Tx and Cta.DC_MIA = Cx.DC_MIA) 
		Left Outer Join Pessoa as P on Cta.Cd_Cred_Dev_MIA = P.Cd_Pes 
		Left Outer Join Tipo_Taxa as TT on Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx
		Left Outer Join Paridade ParModal on PArModal.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and PArModal.Dt_Par = dbo.StrHoje(getdate()) and ParModal.Cd_Tp_Par = 'IMA'
		Left Outer Join Paridade ParOficial on ParOficial.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and ParOficial.Dt_Par = dbo.StrHoje(getdate()) and ParOficial.Cd_Tp_Par = 'OFC'

	Where 
		Cta.Num_proc_MIA = @Num_Proc and 
		Cta.Desp_Org_MIA = 'N'
GO
