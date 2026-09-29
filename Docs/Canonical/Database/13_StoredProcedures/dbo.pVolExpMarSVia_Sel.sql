SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pVolExpMarSVia_Sel
(
@Num_Proc_HEM	VarChar(16),
@Tipo_Carga		Char(1)
--(S) Solta / (G) Granel / (C) Conteinerizada
)
 AS
	If @Tipo_Carga = 'S'
		Select 
			*, TU.Fat_Conv, TE.Nome_Tp_Embal, TE.Cd_Embal_Ofc, NCM.Descricao_NCM, NCM.NCM, Cont.Num_Cont_EM  
		From 
			Volume_Exp_Mar as VEM Join Tipo_Unidade  as TU on VEM.Cd_Tp_Unidade = TU.Cd_Tp_Unidade
			Join House_Exp_Mar as HEM on VEM.Num_Proc_HEM = HEM.Num_Proc_HEM
			Left Outer Join Tipo_Embalagem  as TE on VEM.Cd_Tp_Embal = TE.Cd_Tp_Embal 
			Left Outer Join NCM on VEM.ID_NCM = NCM.ID_NCM
			Left Outer Join Container_Mas_Exp_Mar as Cont on (HEM.Num_Proc_MEM = Cont.Num_Proc_MEM and VEM.Item_Cont_EM = Cont.Item_Cont_EM) 
		Where
			VEM.Num_Proc_HEM = @Num_Proc_HEM and 
			VEM.Item_Cont_EM Is null and VEM.Cd_Tp_Embal <> 999 
	
	If @Tipo_Carga = 'G'
		Select 
			*, TU.Fat_Conv, TE.Nome_Tp_Embal, TE.Cd_Embal_Ofc, NCM.Descricao_NCM, NCM.NCM, Cont.Num_Cont_EM  
		From 
			Volume_Exp_Mar as VEM Join Tipo_Unidade  as TU on VEM.Cd_Tp_Unidade = TU.Cd_Tp_Unidade
			Join House_Exp_Mar as HEM on VEM.Num_Proc_HEM = HEM.Num_Proc_HEM
			Left Outer Join Tipo_Embalagem  as TE on VEM.Cd_Tp_Embal = TE.Cd_Tp_Embal 
			Left Outer Join NCM on VEM.ID_NCM = NCM.ID_NCM
			Left Outer Join Container_Mas_Exp_Mar as Cont on (HEM.Num_Proc_MEM = Cont.Num_Proc_MEM and VEM.Item_Cont_EM = Cont.Item_Cont_EM) 
		Where
			VEM.Num_Proc_HEM = @Num_Proc_HEM and 
			(VEM.Item_Cont_EM Is null or Cd_Tp_Cont = 'LCL' ) and VEM.Cd_Tp_Embal = 999 
	If @Tipo_Carga = 'C'
		Select 
			*, TU.Fat_Conv, TE.Nome_Tp_Embal, TE.Cd_Embal_Ofc, NCM.Descricao_NCM, NCM.NCM, Cont.Num_Cont_EM  
		From 
			Volume_Exp_Mar as VEM Join Tipo_Unidade  as TU on VEM.Cd_Tp_Unidade = TU.Cd_Tp_Unidade
			Join House_Exp_Mar as HEM on VEM.Num_Proc_HEM = HEM.Num_Proc_HEM
			Left Outer Join Tipo_Embalagem  as TE on VEM.Cd_Tp_Embal = TE.Cd_Tp_Embal 
			Left Outer Join NCM on VEM.ID_NCM = NCM.ID_NCM
			Left Outer Join Container_Mas_Exp_Mar as Cont on (HEM.Num_Proc_MEM = Cont.Num_Proc_MEM and VEM.Item_Cont_EM = Cont.Item_Cont_EM) 
		Where
			VEM.Num_Proc_HEM = @Num_Proc_HEM and 
			VEM.Item_Cont_EM Is Not Null



GO
