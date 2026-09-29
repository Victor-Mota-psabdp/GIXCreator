SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pVolImpMarSVia_Sel
(
@Num_Proc_HIM	VarChar(16),
@Tipo_Carga		Char(1)
--(S) Solta / (G) Granel / (C) Conteinerizada
)
 AS
	If @Tipo_Carga = 'S'
		Select 
			*, TU.Fat_Conv, TE.Nome_Tp_Embal, TE.Cd_Embal_Ofc, NCM.Descricao_NCM, NCM.NCM, Cont.Num_Cont_IM  
		From 
			Volume_Imp_Mar as VIM Join Tipo_Unidade  as TU on VIM.Cd_Tp_Unidade = TU.Cd_Tp_Unidade
			Join House_Imp_Mar as HIM on VIM.Num_Proc_HIM = HIM.Num_Proc_HIM
			Left Outer Join Tipo_Embalagem  as TE on VIM.Cd_Tp_Embal = TE.Cd_Tp_Embal 
			Left Outer Join NCM on VIM.ID_NCM = NCM.ID_NCM
			Left Outer Join Container_Mas_Imp_Mar as Cont on (HIM.Num_Proc_MIM = Cont.Num_Proc_MIM and VIM.Item_Cont_IM = Cont.Item_Cont_IM) 
		Where
			VIM.Num_Proc_HIM = @Num_Proc_HIM and 
			(VIM.Item_Cont_IM Is null or Cd_Tp_Cont = 'LCL' ) and VIM.Cd_Tp_Embal <> 999 
	
	If @Tipo_Carga = 'G'
		Select 
			*, TU.Fat_Conv, TE.Nome_Tp_Embal, TE.Cd_Embal_Ofc, NCM.Descricao_NCM, NCM.NCM, Cont.Num_Cont_IM  
		From 
			Volume_Imp_Mar as VIM Join Tipo_Unidade  as TU on VIM.Cd_Tp_Unidade = TU.Cd_Tp_Unidade
			Join House_Imp_Mar as HIM on VIM.Num_Proc_HIM = HIM.Num_Proc_HIM
			Left Outer Join Tipo_Embalagem  as TE on VIM.Cd_Tp_Embal = TE.Cd_Tp_Embal 
			Left Outer Join NCM on VIM.ID_NCM = NCM.ID_NCM
			Left Outer Join Container_Mas_Imp_Mar as Cont on (HIM.Num_Proc_MIM = Cont.Num_Proc_MIM and VIM.Item_Cont_IM = Cont.Item_Cont_IM) 
		Where
			VIM.Num_Proc_HIM = @Num_Proc_HIM and 
			VIM.Item_Cont_IM Is null and VIM.Cd_Tp_Embal = 999 
	If @Tipo_Carga = 'C'
		Select 
			*, TU.Fat_Conv, TE.Nome_Tp_Embal, TE.Cd_Embal_Ofc, NCM.Descricao_NCM, NCM.NCM, Cont.Num_Cont_IM  
		From 
			Volume_Imp_Mar as VIM Join Tipo_Unidade  as TU on VIM.Cd_Tp_Unidade = TU.Cd_Tp_Unidade
			Join House_Imp_Mar as HIM on VIM.Num_Proc_HIM = HIM.Num_Proc_HIM
			Left Outer Join Tipo_Embalagem  as TE on VIM.Cd_Tp_Embal = TE.Cd_Tp_Embal 
			Left Outer Join NCM on VIM.ID_NCM = NCM.ID_NCM
			Left Outer Join Container_Mas_Imp_Mar as Cont on (HIM.Num_Proc_MIM = Cont.Num_Proc_MIM and VIM.Item_Cont_IM = Cont.Item_Cont_IM) 
		Where
			VIM.Num_Proc_HIM = @Num_Proc_HIM and 
			VIM.Item_Cont_IM Is Not Null



GO
