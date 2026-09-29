SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pHEM_ConteinerSVia_Sel 
(
@Num_Proc		VarChar(16) 
)
 AS	
	Select 
		CMEM.Num_Proc_MEM, CMEM.Item_Cont_EM, 
		Num_Proc_HEM, CMEM.Cd_Tp_Cont, Num_Cont_EM, Num_Lacre_EM, 
		Nome_Tp_Cont, Cd_CC_Ofc, Term.Cd_Term_Ofc,
		Regime_EM, ID_ISO, Tara_EM, CMEM.Peso_Bruto_EM
	From 
		Container_Mas_Exp_Mar as CMEM  Join Volume_Exp_Mar as VEM  on (CMEM.Num_Proc_MEM = Left(VEM.Num_Proc_HEM, 14) and CMEM.Item_Cont_EM = VEM.Item_Cont_EM )
		Join Tipo_Container as TC on CMEM.Cd_Tp_Cont = TC.Cd_Tp_Cont 
		Join Master_Exp_Mar as MEM on MEM.Num_Proc_MEM = Left(@Num_Proc, 14) 
		Left Outer Join Terminal as Term on MEM.Cd_Terminal = Term.Cd_Terminal
	Where
		Num_Proc_HEM = @Num_Proc and 
		CMEM.Cd_Tp_Cont <> 'LCL'

GO
