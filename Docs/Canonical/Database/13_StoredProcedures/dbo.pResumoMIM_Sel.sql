SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pResumoMIM_Sel    Script Date: 17/10/2002 07:32:52 ******/
CREATE PROCEDURE pResumoMIM_Sel
(
@Num_Proc		VarChar(14)
)
 AS
	Select  
		MIM.Tp_Frete_MIM, TT.Nome_Tp_Tx, Cta.DC_MIM, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_MIM, P.Apelido as CredDev, 	
		Cx.Num_Lcto, Cx.Vlr_Ref_MIM, Cx.Par_Moeda_MIM, Cx.Vlr_Pgto_Rcto_MIM, 
		Cx.Dt_Pgto_Rcto_MIM, 	ParModal.Par_Moeda Par_Modal, ParOficial.Par_Moeda Par_Oficial, Cta.Comp_RP_MIM PgtRct
	From 	
		Master_Imp_Mar as MIM Join Cta_Cte_Mas_Imp_Mar as Cta on MIM.Num_Proc_MIM = Cta.Num_Proc_MIM
		Left outer join caixa_mas_imp_mar as Cx on (Cta.Num_Proc_MIM = Cx.Num_Proc_MIM and 
			Cta.Cd_Tp_Tx = Cx.Cd_Tp_Tx and Cta.DC_MIM = Cx.DC_MIM) 
		Left Outer Join Pessoa as P on Cta.Cd_Cred_Dev_MIM = P.Cd_Pes 
		Left Outer Join Tipo_Taxa as TT on Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx
		Left Outer Join Paridade ParModal on PArModal.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and PArModal.Dt_Par = dbo.StrHoje(getdate()) and ParModal.Cd_Tp_Par = 'IMM'
		Left Outer Join Paridade ParOficial on ParOficial.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and ParOficial.Dt_Par = dbo.StrHoje(getdate()) and ParOficial.Cd_Tp_Par = 'OFC'

	Where 
		Cta.Num_proc_MIM = @Num_Proc and 
		Cta.Desp_Org_MIM = 'N'
GO
