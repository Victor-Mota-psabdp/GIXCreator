SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pResumoMEM_Sel
(
@Num_Proc		VarChar(14)
)
 AS
	Select  
		MEM.Tp_Frete_MEM, TT.Nome_Tp_Tx, Cta.DC_MEM, Cta.Cd_Tp_Moeda, Cta.Vlr_Org_MEM, P.Apelido as CredDev, 	
		Cx.Num_Lcto, Cx.Vlr_Ref_MEM, Cx.Par_Moeda_MEM, Cx.Vlr_Pgto_Rcto_MEM, 
		Cx.Dt_Pgto_Rcto_MEM, 
		ParModal.Par_Moeda Par_Modal, ParOficial.Par_Moeda Par_Oficial, Cta.Comp_RP_MEM PgtRct
	From 	
		Master_Exp_Mar as MEM Join Cta_cte_mas_exp_mar as Cta on MEM.Num_Proc_MEM = Cta.Num_Proc_MEM
		Left outer join caixa_mas_exp_mar as Cx on (Cta.Num_Proc_MEM = Cx.Num_Proc_MEM and 
			Cta.Cd_Tp_Tx = Cx.Cd_Tp_Tx and Cta.DC_MEM = Cx.DC_MEM) 
		Left Outer Join Pessoa as P on Cta.Cd_Cred_Dev_MEM = P.Cd_Pes 
		Left Outer Join Tipo_Taxa as TT on Cta.Cd_Tp_Tx = TT.Cd_Tp_Tx
		Left Outer Join Paridade ParModal on PArModal.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and PArModal.Dt_Par = dbo.StrHoje(getdate()) and ParModal.Cd_Tp_Par = 'EXM'
		Left Outer Join Paridade ParOficial on ParOficial.Cd_Tp_Moeda = Cta.Cd_Tp_Moeda and ParOficial.Dt_Par = dbo.StrHoje(getdate()) and ParOficial.Cd_Tp_Par = 'OFC'

	Where 
		Cta.Num_proc_MEM = @Num_Proc and 
		Cta.Desp_Dst_MEM = 'N'
GO
