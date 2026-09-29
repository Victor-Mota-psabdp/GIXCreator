SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHIM_Conteiner_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHIM_Conteiner_Sel 
(
@Num_Proc		VarChar(16) 
)
 AS	
	Select 
		Container_Mas_Imp_Mar.Num_Proc_MIM, Container_Mas_Imp_Mar.Item_Cont_IM, 
		Num_Proc_HIM, Container_Mas_Imp_Mar.Cd_Tp_Cont, Num_Cont_IM, Num_Lacre_IM, 
		Nome_Tp_Cont, Dt_Vcto_Devol_IM,Dt_Devol_IM
	From 
		Container_Mas_Imp_Mar, Container_Hou_Imp_Mar, Tipo_Container 
	Where
		Container_Hou_Imp_Mar.Num_Proc_MIM = Container_Mas_Imp_Mar.Num_Proc_MIM and
		Container_Hou_Imp_Mar.Item_Cont_IM = Container_Mas_Imp_Mar.Item_Cont_IM and 
		Container_Mas_Imp_Mar.Cd_Tp_Cont = Tipo_Container.Cd_Tp_Cont and 
		Num_Proc_HIM = @Num_Proc



GO
