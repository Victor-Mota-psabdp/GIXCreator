SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pVolExpMar_Sel
(
@Num_Proc_HEM	VarChar(16), 
@Item_EM		VarChar(2)=''
)
 AS
	Declare @Itens as Int 
	Set @Itens = IsNull((Select Count(*) From Volume_Exp_Mar Where Num_Proc_HEM  =@Num_Proc_HEM ),0)
	If @Item_EM <> '' 
		Begin 
			Select 
				*, TU.Fat_Conv, @Itens as Itens, TE.Nome_Tp_Embal, NCM.Descricao_NCM, NCM.NCM 
			From 
				Volume_Exp_Mar  as VEM Join Tipo_Unidade  as TU on VEM.Cd_Tp_Unidade = TU.Cd_Tp_Unidade
				Join House_Exp_Mar as HEM on VEM.Num_Proc_HEM = HEM.Num_Proc_HEM
				Left Outer Join Tipo_Embalagem  as TE on VEM.Cd_Tp_Embal = TE.Cd_Tp_Embal 
				Left Outer Join NCM on VEM.ID_NCM = NCM.ID_NCM
				Left Outer Join Container_Mas_Exp_Mar as Cont on (HEM.Num_Proc_MEM = Cont.Num_Proc_MEM and VEM.Item_Cont_EM = Cont.Item_Cont_EM) 
			Where
				VEM.Num_Proc_HEM = @Num_Proc_HEM and 
				Item_EM = @Item_EM
		End 
	Else
		Begin 
			Select 
				*, TU.Fat_Conv, @Itens as Itens,TE.Nome_Tp_Embal, NCM.Descricao_NCM, NCM.NCM  
			From 
				Volume_Exp_Mar as VEM Join Tipo_Unidade  as TU on VEM.Cd_Tp_Unidade = TU.Cd_Tp_Unidade
				Join House_Exp_Mar as HEM on VEM.Num_Proc_HEM = HEM.Num_Proc_HEM
				Left Outer Join Tipo_Embalagem  as TE on VEM.Cd_Tp_Embal = TE.Cd_Tp_Embal 
				Left Outer Join NCM on VEM.ID_NCM = NCM.ID_NCM
				Left Outer Join Container_Mas_Exp_Mar as Cont on (HEM.Num_Proc_MEM = Cont.Num_Proc_MEM and VEM.Item_Cont_EM = Cont.Item_Cont_EM) 
			Where
				VEM.Num_Proc_HEM = @Num_Proc_HEM
		End



GO
