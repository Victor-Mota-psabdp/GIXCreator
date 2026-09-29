SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pVolImpMar_Sel
(
@Num_Proc_HIM	VarChar(16), 
@Item_IM		VarChar(2)=''
)
 AS
	Declare @Itens as Int 
	Set @Itens = IsNull((Select Count(*) From Volume_Imp_Mar Where Num_Proc_HIM  =@Num_Proc_HIM ),0)
	If @Item_IM <> '' 
		Begin 
			Select 
				VIM.*, TU.Fat_Conv, @Itens as Itens, TE.Nome_Tp_Embal, NCM.Descricao_NCM, NCM.NCM, Cont.Num_Cont_IM
			From 
				Volume_Imp_Mar  as VIM Join Tipo_Unidade  as TU on VIM.Cd_Tp_Unidade = TU.Cd_Tp_Unidade
				Join House_Imp_Mar as HIM on VIM.Num_Proc_HIM = HIM.Num_Proc_HIM
				Left Outer Join Tipo_Embalagem  as TE on VIM.Cd_Tp_Embal = TE.Cd_Tp_Embal 
				Left Outer Join NCM on VIM.ID_NCM = NCM.ID_NCM
				Left Outer Join Container_Mas_Imp_Mar as Cont on (HIM.Num_Proc_MIM = Cont.Num_Proc_MIM and VIM.Item_Cont_IM = Cont.Item_Cont_IM) 
			Where
				VIM.Num_Proc_HIM = @Num_Proc_HIM and 
				Item_IM = @Item_IM
		End 
	Else
		Begin 
			Select 
				VIM.*, TU.Fat_Conv, @Itens as Itens, TE.Nome_Tp_Embal, NCM.Descricao_NCM, NCM.NCM, Cont.Num_Cont_IM  
			From 
				Volume_Imp_Mar as VIM Join Tipo_Unidade  as TU on VIM.Cd_Tp_Unidade = TU.Cd_Tp_Unidade
				Join House_Imp_Mar as HIM on VIM.Num_Proc_HIM = HIM.Num_Proc_HIM
				Left Outer Join Tipo_Embalagem  as TE on VIM.Cd_Tp_Embal = TE.Cd_Tp_Embal 
				Left Outer Join NCM on VIM.ID_NCM = NCM.ID_NCM
				Left Outer Join Container_Mas_Imp_Mar as Cont on (HIM.Num_Proc_MIM = Cont.Num_Proc_MIM and VIM.Item_Cont_IM = Cont.Item_Cont_IM) 
			Where
				VIM.Num_Proc_HIM = @Num_Proc_HIM
		End



GO
