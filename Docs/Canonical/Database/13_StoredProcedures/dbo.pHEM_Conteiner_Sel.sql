SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHEM_Conteiner_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHEM_Conteiner_Sel 
(
@Num_Proc		VarChar(16) 
)
 AS	
	Select 
		Container_Mas_Exp_Mar.Num_Proc_MEM, Container_Mas_Exp_Mar.Item_Cont_EM, 
		Num_Proc_HEM, Container_Mas_Exp_Mar.Cd_Tp_Cont, Num_Cont_EM, Num_Lacre_EM, 
		Nome_Tp_Cont 
	From 
		Container_Mas_Exp_Mar, Container_Hou_Exp_Mar, Tipo_Container 
	Where
		Container_Hou_Exp_Mar.Num_Proc_MEM = Container_Mas_Exp_Mar.Num_Proc_MEM and
		Container_Hou_Exp_Mar.Item_Cont_EM = Container_Mas_Exp_Mar.Item_Cont_EM and 
		Container_Mas_Exp_Mar.Cd_Tp_Cont = Tipo_Container.Cd_Tp_Cont and 
		Num_Proc_HEM = @Num_Proc



GO
